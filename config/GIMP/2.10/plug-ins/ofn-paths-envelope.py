#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to generate the envelope of two paths
# (c) Ofnuts 2016
#
#   History:
#
#   v0.0: 2016-11-06 first published version
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

import os,sys,math

from gimpfu import *

# extract anchors from stoke points
def anchors(p):
    return [ p[i:i+2] for i in range(2,len(p),6)]

# Distance in a ([x1,y1],[x2,y2]) tuple
def squareDist(pair):
    p1,p2=pair
    x1,y1=p1
    x2,y2=p2
    return (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)

# Max (squared) distance between points of two strokes
def maxSquareDist(p1,p2):
    return max([squareDist(pair) for pair in zip(anchors(p1),anchors(p2))])

class PathEnvelope(object):
    
    def __init__(self,image,path1,path2,accuracy,useGuide,guidePath):
        self.image=image
        self.path1=path1
        self.path2=path2
        self.accuracy=accuracy
        self.useGuide=useGuide
        self.guidePath=None
        if self.useGuide:
            if guidePath==None:
                raise Exception('No guide path specified')
            if guidePath.name==path1.name or guidePath.name==path2.name:
                raise Exception('Guide path cannot be any of the start or end paths')
            if len(guidePath.strokes)>1:
                raise Exception('Guide path should have only one stroke')
            self.guidePath=guidePath
            self.guideStroke=guidePath.strokes[0]
            self.guideLength=self.guideStroke.get_length(.001)
            points,self.guideClosed=self.guideStroke.points
            self.guideFirstPoint=points[2:4]
            if self.guideClosed:
                # for closed strokes, last point is first point
                self.guideLastPoint=self.guideFirstPoint
            else:
                self.guideLastPoint=points[-4:-2]
            
    def guidePoint(self,t):
        x,y,slope,valid=self.guideStroke.get_point_at_dist(self.guideLength*t,.001)
        if valid:
            return [x,y]
        else: # fix possible overshoot when t==1
            return self.guideLastPoint


    def maxStrokeDistance(self,stroke1,stroke2):
        (points1,closed1)=stroke1.points
        (points2,closed2)=stroke2.points
        
        # reference points to locate problem strokes
        x1,y1=points1[2:4]
        x2,y2=points2[2:4]
        
        if closed1 != closed2:
            raise Exception('Strokes have different "closed" status: stroke in path #1 at (%3.2f,%3.2f): %s and stroke in path #2 at (%3.2f,%3.2f): %s' % (x1,y1,closed1,x2,y2,closed2))
        if len(points1) != len(points2):
            raise Exception('Strokes have different number of points: stroke in path #1 at (%3.2f,%3.2f): %d and stroke in path #2 at (%3.2f,%3.2f): %d' % (x1,y1,len(points1)/6,x2,y2,len(points2)/6))

        return maxSquareDist(points1,points2)

    # Check that paths match. Return done implicitly by raising exceptions
    def maxPathDistance(self):
        s1=self.path1.strokes
        s2=self.path2.strokes
        if len(s1) != len(s2):
            raise Exception('Paths have different number strokes: path #1: %d and path #2: %d' % (len(s1),len(s2)))
        pathsDistance=math.sqrt(max(self.maxStrokeDistance(*strokes) for strokes in zip(s1,s2)))
        return pathsDistance
        
    def interpolate(self,p1,p2,t):
        p=[p1[i]-(p1[i]-p2[i])*t for i in [0,1]]
        #print('[%5.2f,%5.2f]->[%5.2f,%5.2f] @ %3.2f = [%5.2f,%5.2f]' % tuple(p1+p2+[t],p))
        return p

    # With guide path:
    # Compute point on guide for t (guidePoint)
    # Translate 1st path from starting point of guide to guidePoint
    # Translate 2nd path from ending point of guide to guidePoint
    # Interpolate with t betwen the two translated paths
    def interpolateWithGuide(self,p1,p2,t,guidePoint):
        p1Translated=[p1[i]+guidePoint[i]-self.guideFirstPoint[i] for i in [0,1]]
        p2Translated=[p2[i]+guidePoint[i]-self.guideLastPoint[i] for i in [0,1]]
        #print '>> [%5.2f,%5.2f]->[%5.2f,%5.2f], [%5.2f,%5.2f]->[%5.2f,%5.2f]' % tuple(p1+p1Translated+p2+p2Translated)
        return self.interpolate(p1Translated,p2Translated,t)
        
    def interpolateStrokePoints(self,strokePoints1,strokePoints2,t,guidePoint):
        interpolatedPoints=[]
        for i in range(0,len(strokePoints1),2):
            if guidePoint:
                interpolatedPoints=interpolatedPoints+self.interpolateWithGuide(strokePoints1[i:i+2],strokePoints2[i:i+2],t,guidePoint)
            else:
                interpolatedPoints=interpolatedPoints+self.interpolate(strokePoints1[i:i+2],strokePoints2[i:i+2],t)
        return interpolatedPoints
            
    def interpolatePath(self,interpolatedPath,t):
        guidePoint=self.guidePoint(t) if self.useGuide else None
        #print '--> guidePoint @%3.2f = [%5.2f,%5.2f]' % tuple([t]+guidePoint)

        for i in range(len(self.path1.strokes)):
            strokePoints1,closed1=self.path1.strokes[i].points
            strokePoints2,closed2=self.path2.strokes[i].points
            strokePoints=self.interpolateStrokePoints(strokePoints1,strokePoints2,t,guidePoint)
            pdb.gimp_vectors_stroke_new_from_points(interpolatedPath,0, len(strokePoints),strokePoints,closed1)
        
    # Compute steps values from distance and accuracy
    # This also checks that both path are sufficiently like each other
    # (same number of strokes and points in strokes
    def stepValues(self):
        pathDistance=self.maxPathDistance()
        steps=int(0.5+pathDistance/self.accuracy)
        for step in range(steps):
            yield float(step)/(steps-1)

    def run(self):
        pdb.gimp_selection_none(self.image)
        for i,t in enumerate(self.stepValues()):
            #print 'Step %d: %3.3f' % (i,t) 
            interpolatedPath=pdb.gimp_vectors_new(self.image, '*** TMP ***')
            self.interpolatePath(interpolatedPath,t)
            pdb.gimp_image_add_vectors(self.image, interpolatedPath, 0)
            pdb.gimp_image_select_item(self.image,CHANNEL_OP_ADD,interpolatedPath)
            pdb.gimp_image_remove_vectors(self.image, interpolatedPath)

def pathsEnvelope(image,path1,path2,accuracy,useGuide,guidePath):
    pdb.gimp_image_undo_group_start(image)
    try:
        PathEnvelope(image,path1,path2,accuracy,useGuide,guidePath).run()

    except Exception as e:
        print e.args[0]
        pdb.gimp_message(e.args[0])

    pdb.gimp_image_undo_group_end(image)
    pdb.gimp_displays_flush()
    return;

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])
desc='Generate envelope of two paths'
author='Ofnuts'

register(
    'ofn-paths-envelope',
    desc+whoiam,desc,
    author,author,'2016',
    desc,
    '*',
    [
        (PF_IMAGE, 'image', 'Input image', None),
        (PF_VECTORS, 'path1', 'Begin path', None),
        (PF_VECTORS, 'path2', 'End path', None),
        (PF_SPINNER, 'accuracy', 'Accuracy (px)', 1,(1,100,1)),
        (PF_TOGGLE,  'useGuide','Use guide', False),
        (PF_VECTORS, 'guide','Guide path', None)
    ],
    [],
    pathsEnvelope,
    menu='<Vectors>/Tools',
)

main()
