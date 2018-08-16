#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Straighten a layer using one or several path strokes 

# (c) Ofnuts 2016
#
#   History:
#
#   v0.0: 2016-07-13: Initial version
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANDABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

import os,sys,math
from gimpfu import *

def badPathSpec():
    raise Exception('The active path should have either a single stroke with two points, or two strokes with two points each')

def ambiguousDirection():
    raise Exception('Strokes are not close enough to vertical or horizontal direction to make a best guess')

def ambiguousAverage():
    raise Exception('Strokes are not close enough to each other to make a best guess')


def getPointsFromStroke(stroke, count):
    points,closed=stroke.points
    if len(points)!=count*6: # N triplets of 3 points with 2 coords each
        badPathSpec()
    return [points[6*p+2:6*p+4] for p in range(count)]

# Angle limits. Eliminate the 15° on each side of the 45° multiples
HORIZONTAL=math.pi/6 # 30°
HORIZONTAL_REVERSE=5*math.pi/6 # 330°
VERTICAL_MIN=2*math.pi/6 # 60°
VERTICAL_MAX=4*math.pi/6 # 120°

def angleFromPoints(xs,ys,xe,ye):
    rawAngle=math.atan2(ye-ys,xe-xs)
    if abs(rawAngle)<HORIZONTAL:
        return rawAngle
    elif abs(rawAngle)>HORIZONTAL_REVERSE:
        return rawAngle-math.copysign(math.pi,rawAngle)
    elif VERTICAL_MIN < abs(rawAngle) < VERTICAL_MAX:
        return rawAngle-math.copysign(math.pi/2,rawAngle)
    else:
        ambiguousDirection()
        
def angleFromOneStroke(path):
    ((xs,ys),(xe,ye))=getPointsFromStroke(path.strokes[0],2)
    return angleFromPoints(xs,ys,xe,ye)

def angleFromTwoStrokes(path):
    ((xs,ys),(xe,ye))=getPointsFromStroke(path.strokes[0],2)
    a1=angleFromPoints(xs,ys,xe,ye)
    ((xs,ys),(xe,ye))=getPointsFromStroke(path.strokes[1],2)
    a2=angleFromPoints(xs,ys,xe,ye)
    if abs(a1-a2)<math.pi/4:
        return (a1+a2)/2 # somewhere in the middle
    else:
        ambiguousAverage()

def straightenLayer(image,layer):
    image.undo_group_start()
    try:
        path=image.active_vectors
        if not path:
            raise Exception('No active path found in image')
        if len(path.strokes) == 1:
            angle=angleFromOneStroke(path)
        elif len(path.strokes) == 2:
            angle=angleFromTwoStrokes(path)
        else:
            badPathSpec()

        xc=layer.width/2.
        yc=layer.height/2.
            
        layer.transform_2d(xc,yc,1.,1.,angle,xc,yc,TRANSFORM_BACKWARD,pdb.gimp_context_get_interpolation(),False,3,TRANSFORM_RESIZE_ADJUST) 
        
    except Exception as e:
        print e.args[0]
        gimp.message(e.args[0])

    image.undo_group_end()
    
    
### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])
author='Ofnuts'
copyrightYear='2016'
desc='Straighten a layer using two points or two pairs of points in the current path'
register(
    'ofn-straighten-layer',
    desc+whoiam,desc,
    author,author,copyrightYear,
    'Straighten',
    '*',
    [
        (PF_IMAGE, 'image', 'Input image', None),
        (PF_DRAWABLE, 'drawable', 'Input drawable', None),
    ],
    [],
    straightenLayer,
    menu='<Image>/Layer'
)

main()