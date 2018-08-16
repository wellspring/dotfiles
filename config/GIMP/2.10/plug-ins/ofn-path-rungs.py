#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to generate ladder steps between two paths
# (c) Ofnuts 2013, 2016
#
#   History:
#
#   v0.0: 2013-09-17 first published version
#   v0.1: 2014-04-14 run on several strokes in each path
#   v1.0: 2016-08-26 add option with spacing, repackage
#   v1.1: 2016-09-20 add anchors option in spacing variant
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

import os, sys, math, traceback

from gimpfu import *

platformsWithTraceToTerminal=['linux2']
platformsWithTraceToTerminal=[]

def trace(formatstring,*args):
    if sys.platform in platformsWithTraceToTerminal:
        print formatstring % args

PRECISION=0.01

STRETCHTYPE_LINEAR=0
STRETCHTYPE_ACCELERATE=1
STRETCHTYPE_DECELERATE=2
STRECTHTYPE_SWING=3

stretchFunctions=[lambda t:t,lambda t:t**2, lambda t: 1-((1-t)**2), lambda t: (1-math.cos(t*math.pi))/2]

#----------------------------------------------------
# Enhanced path Stroke
#----------------------------------------------------
class Stroke:
            
    def __init__(self,stroke,last=True,closed=None):
        self.stroke=stroke
        # self.last tells if the stroke is the last one in case of stroke splitting
        # this normally means that there can be one last rung across the annchros of the last pair 
        self.last=last # generate rung on last anchor
        
        # self.closed tells if the overall stroke was closed in case of stroke splitting
        # Its value is relevant only if self.last is True.
        # The default value None is used for non splitted strokes, the value is then
        # assume to be the same as the one from the Gimp stroke.
        self.closed=self.stroke.points[1] if closed is None else closed        
        
        # The number of splines seems to have an influence on global
        # precision, so adapt precision to number of splines for best results
        self.precision=PRECISION/((len(self.stroke.points[0])/6)-1)

        # The stroke length, computed once for all. It appears that due to 
        # precision errors self.stroke.get_point_at_dist(self.length) may not 
        # return a valid point.
        self.length=stroke.get_length(self.precision)

    # Computes the coordinates and signed angle of a point at a given distance
    # from the stroke origin. Mostly makes up for some deficiencies in Gimp's API. 
    def getPointAtRatio(self,ratio,backwards=False):
        if backwards:
            ratio=1.-ratio
        dist=self.length*ratio
        x,y,_,valid=self.stroke.get_point_at_dist(dist,self.precision)
        if not valid: # possible overshoot at end of stroke, so take the last point
            trace('Fixed get_point_at_dist at %6.4f in stroke %s with length %6.4f' % (dist,self.stroke.ID,self.length))
            x,y=self.stroke.points[0][-4:-2]
        
        # Can't use the "slope" returned by the Gimp calls since it is not signed
        # so we do not obtain an absolute direction. The tangent is approximated by the 
        # orientation of a straigh line between the point and a neighboring point
        # (forward in the first half, backward in the second half)
        
        ndist=20*self.precision # distance of neighbor
        if ratio < .5: # first half
            nx,ny,_,_=self.stroke.get_point_at_dist(dist+ndist,self.precision)
            alpha=math.atan2(ny-y,nx-x)
        else: # second half
            nx,ny,_,_=self.stroke.get_point_at_dist(dist-ndist,self.precision)
            alpha=math.atan2(y-ny,x-nx)

        trace('> Stroke %03d Point (%3.3f,%3.3f) @ %3.1f°' % (self.stroke.ID,x,y,alpha*180/math.pi))
        return (x,y),alpha

# splits a Gimp stroke into individual components
def splitStroke(stroke):
    substrokes=[]
    points,closed=stroke.points
    for i in range(2,len(points)-4,6):
        # points for one individual bezier curve
        xa1,ya1,xt1,yt1,xt2,yt2,xa2,ya2=points[i:i+8]
        # points for new stroke (no external tangents) 
        p=[xa1,ya1]*2+[xt1,yt1]+[xt2,yt2]+[xa2,ya2]*2
        substrokes.append(p)
    if closed: # one more stroke back to origin
        xa1,ya1,xt1,yt1=points[-4:]
        xt2,yt2,xa2,ya2=points[:4]
        p=[xa1,ya1]*2+[xt1,yt1]+[xt2,yt2]+[xa2,ya2]*2
        substrokes.append(p)
    return substrokes,closed    
    
def distance(p1,p2):
    return math.sqrt((p1[0]-p2[0])**2+(p1[1]-p2[1])**2)

# Flattens the two anchors and the two inward handles of a single-segment stroke
# into 2 triplets (ie, 12 coordinates). Outward handles are assumed to be
# equal to the anchors (no outward tangents)
def strokePoints(p1,h1,h2,p2):
    return list(p1)*2+list(h1)+list(h2)+list(p2)*2

class PathRungsBase(object):
    def __init__(self,image,path1,path2,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single):
        self.image=image
        self.path1=path1
        self.path2=path2
        self.shortest=shortest
        self.side1=side1
        self.side2=side2
        self.indicence1=(math.pi*indicence1)/180
        self.indicence2=(math.pi*indicence2)/180
        self.bend1=bend1/100.
        self.bend2=bend2/100.
        self.backwards=backwards
        self.single=single
        
    # Compute handles on both sides of the rung-rail contact point
    def computeHandlesForPoint(self,p,length,angle,incidence):
        angleRight=angle+math.pi/2-incidence
        angleLeft=angle-math.pi/2+incidence
        h1=(p[0]+length*math.cos(angleRight),p[1]+length*math.sin(angleRight))
        h2=(p[0]+length*math.cos(angleLeft),p[1]+length*math.sin(angleLeft))
        return h1,h2
        
    # Find the pair of handles that makes the shortest rung (it is assumed that
    # this occurs when the two handles are the closest to each other). 
    def closestPair(self,p1,p2):
        dmin=float("inf") # infinity...
        for i in [0,1]:
            for j in [0,1]:
                d=distance(p1[i],p2[j])
                if d<dmin:
                    dmin=d
                    pair=(p1[i],p2[j])
        return pair
    
    def selectHandles(self,p1,p2):
        if self.shortest:
            return self.closestPair(p1,p2)
        else:
            return (p1[self.side1],p2[self.side2])
        
    def computeHandles(self,p1,angle1,p2,angle2):
        # distance of handle from anchor is proportional to distance between the ends
        d=distance(p1,p2)
        length1=d*self.bend1
        length2=d*self.bend2
        handles1=self.computeHandlesForPoint(p1,length1,angle1,self.indicence1)
        handles2=self.computeHandlesForPoint(p2,length2,angle2,self.indicence2)
        return self.selectHandles(handles1,handles2)

    def dumpStroke(self,stroke,path,backwards): 
        print '---- %s (%s)' % (path.name,['Forward','Backward'][backwards])
        for i, ratio in enumerate(self.stepValues()):
            p,angle=stroke.getPointAtRatio(ratio,backwards)
            #trace('%3.1f,%3.1f -> %4.1f' % (p[0],p[1],angle*180/math.pi))

    # Basic generator of stroke pairs, on from each path, used in simple cases
    # More complex cases in the "BySpacing" class override this
    def strokePairGenerator(self):
        strokes1=self.path1.strokes
        strokes2=self.path2.strokes
        if len(strokes1) != len(strokes2):
            raise Exception('Source and destination paths do not have the same number of strokes')
        for s1,s2 in zip (strokes1, strokes2): 
            yield Stroke(s1),Stroke(s2)
                
    # Compute the rungs for a pair of strokes
    def runPair(self,stroke1,stroke2):
        rungStrokes=[]
        # stepValues() is provided by the derived class
        for i,ratio in enumerate(self.stepValues(stroke1,stroke2)):
            p1,angle1=stroke1.getPointAtRatio(ratio)
            p2,angle2=stroke2.getPointAtRatio(ratio,self.backwards)
            h1,h2=self.computeHandles(p1,angle1,p2,angle2)
            rungStrokes.append(strokePoints(p1,h1,h2,p2));
        return rungStrokes

    def createFinalPaths(self,rungStrokes):
        # We either collect them in one single path or we create a path for each 
        outputPathName=self.outputPathName()
        if self.single:
            rungsPath=pdb.gimp_vectors_new(self.image,outputPathName)
            rungsPath.visible=True
            for stroke in rungStrokes:
                gimp.VectorsBezierStroke(rungsPath,stroke,False)
#                sid = pdb.gimp_vectors_stroke_new_from_points(rungsPath,0, len(stroke),stroke,False)
            pdb.gimp_image_add_vectors(self.image, rungsPath, 0)
        else:
            for step,stroke in enumerate(rungStrokes):
                rungPath=pdb.gimp_vectors_new(self.image, '%s[%d/%d]' % (outputPathName,step+1,len(rungStrokes)))
                rungPath.visible=True
                gimp.VectorsBezierStroke(rungPath,stroke,False)
                #sid = pdb.gimp_vectors_stroke_new_from_points(rungPath,0, len(stroke),stroke,False)
                pdb.gimp_image_add_vectors(self.image, rungPath, 0)

    def run(self):
        self.traceStart()
        self.path1.visible=False;
        self.path2.visible=False;
        
        # Create strokes for the rungs
        rungs=[]
        for strokePair in self.strokePairGenerator():
            rungs.extend(self.runPair(*strokePair))
        # Create corresponding path
        self.createFinalPaths(rungs)        
            

class PathRungsByCount(PathRungsBase):
    
    def __init__(self,image,path1,path2,count,stretchType,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single):
        super(PathRungsByCount,self).__init__(image,path1,path2,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single)

        self.count=count
        self.stretchType=stretchType
    
    # When source and target strokes are closed, the first and last rungs would be identical
    # It is asssumed that in that case the user means visible rungs, so we compute stretch values 
    # for n+1 steps and only return the first n.
    def stepValues(self,stroke1,stroke2):
        computedStepsCount=self.count+(stroke1.closed and stroke2.closed)
        positions=[stretchFunctions[self.stretchType](float(i)/(computedStepsCount-1)) for i in range(computedStepsCount)]
        return positions[:self.count]

    def outputPathName(self):
        return 'Rungs %s->%s (#%d)' % (self.path1.name, self.path2.name,self.count)
 
    def traceStart(self):
        trace('Running with: paths: "%s", "%s", count: %d, stretch: %s, shortest: %s, sides: %d,%d, incidences: %f,%f, bends: %f,%f, backwards: %s, single: %s'
                 % (self.path1.name,self.path2.name,self.count,self.stretchType,self.shortest,self.side1,self.side2,self.indicence1,self.indicence2,self.bend1,self.bend2,self.backwards,self.single))
    
class PathRungsBySpacing(PathRungsBase):
    
    def __init__(self,image,path1,path2,spacing,anchors,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single):
        super(PathRungsBySpacing,self).__init__(image,path1,path2,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single)

        self.spacing=spacing
        self.anchors=anchors
        
    def stepValues(self,stroke1,stroke2):
        intervals=1+int(.5+(stroke1.length/self.spacing))
        trace('%3.2f / %d = %d -> %3.2f' %  (stroke1.length,self.spacing,intervals,stroke1.length/intervals))
        # this doesn't generate the last fencepost... but we don't always need it
        positions=[float(i)/intervals for i in range(intervals)]
        # the last fencepost (at 1.0) is required only when
        # - this is the last substroke, and
        # - at least one of the overall strokes is open (if they are both closed, 
        # this final rung would duplicate the first one of the first substroke)
        if stroke1.last and not (stroke1.closed and stroke2.closed):
            positions.append(1.)
        return positions

    def strokePairSplitterGenerator(self):
        # dummy path to support the extracted strokes
        print "Using the splitter generator...."
        tmpPath=pdb.gimp_vectors_new(self.image,'***dummy***')
        strokes1=self.path1.strokes
        strokes2=self.path2.strokes
        if len(strokes1) != len(strokes2):
            raise Exception('Source and destination paths do not have the same number of strokes')
        for n, (s1,s2) in enumerate(zip(strokes1,strokes2)):
            subs1,closed1=splitStroke(s1)
            subs2,closed2=splitStroke(s2)
            if len(subs1)!=len(subs2):
                raise Exception('Source and destination strokes #%d do not have the same number of segments' % n)
            # All substrokes but last
            for subpoints1,subpoints2 in zip(subs1,subs2)[:-1]:
                sub1=Stroke(gimp.VectorsBezierStroke(tmpPath,subpoints1,False),last=False)
                sub2=Stroke(gimp.VectorsBezierStroke(tmpPath,subpoints2,False),last=False)
                yield sub1,sub2
            # the last ones
            sub1=Stroke(gimp.VectorsBezierStroke(tmpPath,subs1[-1],False),last=True,closed=closed1)
            sub2=Stroke(gimp.VectorsBezierStroke(tmpPath,subs2[-1],False),last=True,closed=closed2)
            yield sub1,sub2
            
        # delete dummy path at end of iteration
        gimp.delete(tmpPath)
        
    def strokePairGenerator(self):
        return super(PathRungsBySpacing,self).strokePairGenerator() if not self.anchors else self.strokePairSplitterGenerator()
    
    def outputPathName(self):
        return 'Rungs %s->%s (%dpx)' % (self.path1.name, self.path2.name,self.spacing)
 
    def traceStart(self):
        trace('Running with: paths: "%s", "%s", spacing: %d, anchors: %s, shortest: %s, sides: %d,%d, incidences: %f,%f, bends: %f,%f, backwards: %s, single: %s'
                 % (self.path1.name,self.path2.name,self.spacing,self.anchors,self.shortest,self.side1,self.side2,self.indicence1,self.indicence2,self.bend1,self.bend2,self.backwards,self.single))
    
def pathRungsByCount(image,path1,path2,count,stretchType,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single):
    pdb.gimp_image_undo_group_start(image)
    try:
        PathRungsByCount(image,path1,path2,int(count),stretchType,shortest==0,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single).run()

    except Exception as e:
        traceback.print_exc()
        trace(e.args[0])
        pdb.gimp_message(e.args[0])

    pdb.gimp_image_undo_group_end(image)
    pdb.gimp_displays_flush()
    return;

def pathRungsBySpacing(image,path1,path2,spacing,anchors,shortest,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single):
    pdb.gimp_image_undo_group_start(image)
    try:
        PathRungsBySpacing(image,path1,path2,spacing,anchors,shortest==0,side1,side2,indicence1,indicence2,bend1,bend2,backwards,single).run()

    except Exception as e:
        traceback.print_exc()
        trace(e.args[0])
        pdb.gimp_message(e.args[0])

    pdb.gimp_image_undo_group_end(image)
    pdb.gimp_displays_flush()
    return;

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])
SIDENAMES=['Right','Left']
author='Ofnuts'
year='2016'
descByCount='Generate given number of rungs between path strokes'
descBySpacing='Generate rungs with given spacing between path strokes'

# Common parameters
image=         (PF_IMAGE,   'image', 'Input image', None)
fromPath=      (PF_VECTORS, 'path1', 'From path', None)
toPath=        (PF_VECTORS, 'path2', 'To path', None)
sideChoiceType=(PF_OPTION,  'shortest', 'Sides',0, ['Shortest rung','Explicit sides'])
sideChoice1=   (PF_OPTION,  'side1', 'Side on "From" path',  0, SIDENAMES)
sideChoice2=   (PF_OPTION,  'side2', 'Side on "To" path', 0, SIDENAMES)
incidence1=    (PF_SPINNER, 'indicence1', 'Incidence on "From" path',  0, (-90,90,1))
incidence2=    (PF_SPINNER, 'indicence2', 'Incidence on "To" path', 0, (-90,90,1))
bend1=         (PF_SLIDER,  'bend1', 'Bendy factor on "From" path',  50, (0,100,1))
bend2=         (PF_SLIDER,  'bend2', 'Bendy factor on "To" path', 50, (0,100,1))
backwards=     (PF_TOGGLE,  'backwards', 'Backwards', False)
single=        (PF_TOGGLE,  'single', 'Single path', True)

register(
    'ofn-path-rungs-count',
    descByCount+whoiam,descByCount,
    author,author,year,
    'By count',
    '*',
    [
        image,fromPath,toPath,
        (PF_SPINNER, 'count', 'Count', 3, (3,1000,1)),
        (PF_OPTION,  'stretchType','Stretch', 0, ['Linear','Acceleration','Deceleration','Swing']),
        sideChoiceType,sideChoice1,sideChoice2,incidence1,incidence2,bend1,bend2,backwards,single
    ],
    [],
    pathRungsByCount,
    menu='<Vectors>/Tools/Path rungs/',
)

register(
    'ofn-path-rungs-spacing',
    descBySpacing+'\n(actual spacing can be adjusted for a uniform spread of the rungs)'+whoiam,descBySpacing,
    author,author,year,
    'By spacing',
    '*',
    [
        image,fromPath,toPath,
        (PF_SPINNER, 'spacing', 'Spacing', 5,(1,1000,1)),
        (PF_TOGGLE,  'anchors', 'Force rungs on anchors', False),
        sideChoiceType,sideChoice1,sideChoice2,incidence1,incidence2,bend1,bend2,backwards,single
    ],
    [],
    pathRungsBySpacing,
    menu='<Vectors>/Tools/Path rungs/',
)

main()
