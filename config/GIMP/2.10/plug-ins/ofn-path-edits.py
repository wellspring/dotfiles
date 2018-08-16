#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP script for several stroke-editing functions
# (c) Ofnuts 2016
#
#   History:
#
#   v0.0: 2016-12-03 Gather separate scripts, refactor code
#   v0.1: 2016-12-11 Fix Extrac/Delete bug when path extends beyond canvas limits

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published
#   by the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This very file is the cmplete source code to the program.
#
#   If you make and redistribute changes to this code, please mark it
#   in reasonable ways as different from the original version. 
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   The GPL v3 licence is available at: https://www.gnu.org/licenses/gpl-3.0.en.html


import os, sys, math
from collections import namedtuple
from gimpfu import *
import traceback

# ***********************************************
# Some useful functions and classes 

# *********
# Point class, that derives from namedtuple. This makes it immutable, and behaving as an
# iterable list with x,y which is useful when passing x and y as parameters ("*point").
class Point(namedtuple('Point', 'x y')):
    __slots__ = () # Save memory since we will potentially allocate a lot of these small objects

    CLOSE_ENOUGH=0.1

    def __repr__(self):
        return '{%4.2f,%4.2f}' % (self.x, self.y)

    def __eq__(self,other):
        return isinstance(other,Point) and abs(self.x-other.x) < self.CLOSE_ENOUGH and abs(self.y-other.y) < self.CLOSE_ENOUGH
    
    @property
    def pixelX(self):
        return int(math.floor(self.x))

    @property
    def pixelY(self):
        return int(math.floor(self.y))

    @property
    def pixel(self):
        return int(math.floor(self.x)),int(math.floor(self.y))

# *********
# Utility functions

def pointsFromCoords(coords):
    '''Transforms a flat list of coordinates into a list of Points'''
    uniqueiterator=iter(coords)
    return [Point(x,y) for x,y in zip(uniqueiterator,uniqueiterator)]

def coordsFromPoints(points):
    '''Flattens a list of Points into a list of coordinates'''
    return [coord for point in points for coord in point]

def anchorIterator(points):
    '''Iterates the anchors in a list of Points'''
    for i in range(1,len(points),3):
        yield points[i]

# ****************** 
# Stroke class, which helps handling the list of points.
# Unlike gimp.VectorBezierStroke it can exist outside of a path.
class Stroke(object):

    # General constructor, accepts gimp.Stroke, flat list of coordinates, or Points
    def __init__(self,data,closed=False):
        if isinstance(data,gimp.VectorsBezierStroke):
            coords,closed=data.points
            self._points=pointsFromCoords(coords)
            self._closed=closed
        elif isinstance(data,list):
            if isinstance(data[0],Point):
                self._points=data
                self._closed=closed
            elif isinstance(data[0],float):
                self._points=pointsFromCoords(coords)
                self._closed=closed
            else:
                raise Exception('Cannot create stroke from list of %s',type(data[0]))
        else:
            raise Exception('Cannot create stroke from %s',type(data))

    def __repr__(self):
        return '[%r->%r]%s' % (self.start, self.end, 'OC'[self.closed])

    # create reversed stroke
    def reversed(self):
        return Stroke(self._points[::-1],self._closed)

    def gimpStroke(self,path):
        return gimp.VectorsBezierStroke(path,coordsFromPoints(self._points),self._closed)

    # Some fake read-only attributes
    @property
    def points(self):
        return self._points

    @property
    def closed(self):
        return self._closed

    # Some specifc often-used points
    @property
    def start(self):
        return self._points[1]
    
    @property
    def end(self):
        return self._points[-2]
    
    @property
    def firstForward(self):
        return self._points[2]
    
    @property
    def lastBackward(self):
        return self._points[-3]
    
def hasSelectedAnchors(image,points,includeEnds=True):
    '''Returns first anchor in selection, if any'''
    if includeEnds:
        checkedAnchors=enumerate(anchorIterator(points),start=0)
    else:
        checkedAnchors=enumerate(anchorIterator(points[3:-3]),start=1)
    for i,point in checkedAnchors:
        #print point, image.selection.get_pixel(point.pixelX,point.pixelY)
        x,y=point.pixelX,point.pixelY
        if 0<=x<image.width and 0<=y<image.height and image.selection.get_pixel(x,y)[0] > 0:
            return True,i
    return False,-10000 # Make sure it is not used by mistake

# **************************
# Delete and extract strokes    

def deleteOrExtractStrokes(image,path,extract):
    if pdb.gimp_selection_is_empty(image):
        raise Exception('Empty selection, nothing to %s' % ('extract' if extract else 'delete'))

    for stroke in path.strokes:
        coords,_=stroke.points
        selected,_=hasSelectedAnchors(image,pointsFromCoords(coords))
        if selected^extract:
            path.remove_stroke(stroke)

def deleteStrokes(image,sourcePath):
    deleteOrExtractStrokes(image,sourcePath,False)

def extractStrokes(image,sourcePath):
    deleteOrExtractStrokes(image,sourcePath,True)
    
# *************************
# Reverse Strokes   

def reverseStrokes(image,path):
    reverseAll=pdb.gimp_selection_is_empty(image)

    # To keep strokes in order we have to remove them all 
    # And add them back with changes
    strokes=[Stroke(stroke) for stroke in path.strokes]
    for stroke in path.strokes:
        path.remove_stroke(stroke)
        
    for stroke in strokes:
        selected,_=hasSelectedAnchors(image,stroke.points)
        if reverseAll or selected:
            stroke.reversed().gimpStroke(path)
        # add back
        else: 
            stroke.gimpStroke(path)

# *************************
# Join strokes    

# Attempts to properly close a Stroke if begin/end points are close to each other
# If so, the end point is removed, its backward tangent becomes the backward tangent 
# of the first point. 
# If closure is not possible or already done, the original Stroke is returned.
def attemptClose(s):
    if s.closed:
        return s
    elif s.start==s.end: 
        #print 'Closing %s' % s
        # If no backward tangent on removed point, move handle to remaining point
        firstTangent= s.start if s.lastBackward==s.end else s.lastBackward
        return Stroke([firstTangent]+s.points[1:-3],True)
    else:
        return s

# Attempts to join two strokes. 
# If join is not possible, returns the first stroke.
def attemptJoin(s1,s2):
    #print 'Joining %s and %s' % (s1,s2) 
    if s1.closed or s2.closed:
        return s1
    elif s1.start==s2.start:
        s1,s2=s1.reversed(),s2
    elif s1.start==s2.end:
        s1,s2=s2,s1
    elif s1.end==s2.start:
        pass; # s1,s2 already set 
    elif s1.end==s2.end:
        s1,s2=s1,s2.reversed()
    else:
        return s1
    # Now perform actual join, dropping the forward handle of the last anchor
    # of s1 and the first anchor of s2 and its forward handle. 
    # If there is no backward handle on the first anchor of s2, use the coordinates 
    # of the last anchor of s1 instead.
    tangent=s1.end if s2.firstForward==s2.end else s2.firstForward
    return Stroke(s1.points[:-1]+[tangent]+s2.points[3:],False)

def joinStrokes(image,path):
    removeStrokes=path.strokes[:]
    sourceStrokes=[Stroke(gimpStroke) for gimpStroke in path.strokes]
    finalStrokes=[]
    
    while sourceStrokes:
        stroke=sourceStrokes.pop()
        #print 'Stroke: %s' % stroke
        # if closable or closed no need to look for other strokes
        stroke=attemptClose(stroke)
        if stroke.closed:
            finalStrokes.append(stroke)
            continue # Nothing more to do with that one
        # Scan remaining strokes for possible joins
        for candidate in sourceStrokes:
            joinedStroke=attemptJoin(stroke,candidate)
            if joinedStroke is stroke: # no splice occured
                continue
            else:
                #print 'Joined: %s' % joinedStroke
                sourceStrokes.remove(candidate) # No longer exists
                sourceStrokes.append(joinedStroke) # recheck for closure or more joins
                break
        else: # executed only if we didn't join anything
            finalStrokes.append(stroke)

    # remove current strokes from path
    for stroke in path.strokes:
        path.remove_stroke(stroke)
    # replace wih new ones
    for stroke in finalStrokes:
        stroke.gimpStroke(path)

# *************************
# Disjoin Stroke

def disjoinOpenStrokeOnAnchor(stroke,anchor):
    '''Returns two open strokes, starting/ending on given anchor''' 
    points1=stroke.points[:(anchor+1)*3]
    points2=stroke.points[anchor*3:]
    return (Stroke(points1,False),Stroke(points2,False))

def disjoinClosedStrokeOnAnchor(stroke,anchor):
    '''Returns one single open stroke, starting and ending on given anchor (begin and end overlap)
       This stroke has of course one more anchor than the original one'''
    ring=stroke.points+stroke.points
    pointsCount=len(stroke.points)+3 # Number of points to extract from ring
    # return a single-element tuple
    return (Stroke(ring[anchor*3:anchor*3+pointsCount],False),)

def disjoinStrokeOnAnchor(stroke,anchor):
    if stroke.closed:
        return disjoinClosedStrokeOnAnchor(stroke,anchor)
    else:
        return disjoinOpenStrokeOnAnchor(stroke,anchor)

def disjoinStrokes(image,path):
    removeStrokes=path.strokes[:]
    sourceStrokes=[Stroke(gimpStroke) for gimpStroke in path.strokes]
    finalStrokes=[]

    while sourceStrokes:
        candidate=sourceStrokes.pop()
        selected,anchor=hasSelectedAnchors(image,candidate.points,candidate.closed)
        if selected and len(candidate.points)>1:
            disjoinStrokes=disjoinStrokeOnAnchor(candidate,anchor)
            sourceStrokes.extend(disjoinStrokes)
        else:
            finalStrokes.append(candidate)

    # remove current strokes from path
    for stroke in path.strokes:
        path.remove_stroke(stroke)
    # replace wih new ones
    for stroke in finalStrokes:
        stroke.gimpStroke(path)
            
# *************************
# Break path apart    

def breakPathApart(image,path):
    if path==None:
        raise Exception('No active path in image')
    if not path :
        raise Exception('No elements in active path')
        
    for i,stroke in enumerate(path.strokes,start=1):
        strokePath=gimp.Vectors(image,'%s [%d]' % (path.name,i))
        points,closed=stroke.points
        gimp.VectorsBezierStroke(strokePath,points,closed)
        pdb.gimp_image_insert_vectors(image, strokePath, None,-1)        

# *************************
# Path summary    

def strokeSummary(path,stroke):
    points,closed=stroke.points
    length=pdb.gimp_vectors_stroke_get_length(path, stroke.ID, .1)
    return '(%3.1f, %3.1f) <- %d : %3.1f : %s -> (%3.1f, %3.1f)' % (points[2],points[3],len(points)/6,length,'OC'[closed],points[-4],points[-3])

def pathSummary(image,path):
    if path==None:
        raise Exception('No active path in image')
    if not path :
        raise Exception('No elements in active path')
            
    strokeSummaries=[strokeSummary(path,stroke) for stroke in path.strokes]
    pdb.gimp_message('Path "%s" [%d]:\n%s' % (path.name,len(strokeSummaries),'\n'.join(strokeSummaries)))

# *************************************************************************************
# Registrations

whoiam='\n'+os.path.abspath(sys.argv[0])
author='Ofnuts'
year='2016'
menu='<Vectors>/Edit'

def protected(function):
    '''Create protected version of function (general try/catch, and Gimp undo)'''
    def p(*parms):
        image=parms[0]
        pdb.gimp_image_undo_group_start(image)
        try:
            function(*parms)
        except Exception as e:
            print e.args[0]
            traceback.print_exc()
            pdb.gimp_message(e.args[0])
        pdb.gimp_image_undo_group_end(image)
        pdb.gimp_displays_flush()
    return p

def commonRegister(gimpProc,pythonProc,desc):
    '''Common registration function'''
    register(
        'ofn-path-'+gimpProc,desc+'...'+whoiam,desc,author,author,year,desc,'*',
        [(PF_IMAGE, 'image', 'Input image', None),(PF_VECTORS, 'refpath', 'Input path', None)],[],
        protected(pythonProc),menu=menu
    )
 
commonRegister('delete-strokes',deleteStrokes,'Delete strokes')
commonRegister('extract-strokes',extractStrokes,'Extract strokes')
commonRegister('reverse-strokes',reverseStrokes,'Reverse strokes')
commonRegister('join-strokes',joinStrokes,'Join strokes')
commonRegister('disjoin-strokes',disjoinStrokes,'Disjoin strokes')
commonRegister('break-path-apart',breakPathApart,'Break path apart')
commonRegister('path-summary',pathSummary,'Path summary')

main()
