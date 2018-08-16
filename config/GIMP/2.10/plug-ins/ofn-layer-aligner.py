#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Re-align a layer over another layer 

# (c) Ofnuts 2016
#
#   History:
#
#   v0.0: 2016-07-11: Initial version
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

# This script is a Python rewrite of Volker Trier's exact-aligner.scm, 
# from which some good ideas have been shamelessly borrowed

import os,sys,math
from gimpfu import *

def badPathSpec():
    raise Exception('The active path should have either a single stroke with four points, or two strokes with two points each')

def getPointsFromStroke(stroke, count):
    points,closed=stroke.points
    if len(points)!=count*6: # N triplets of 3 points with 2 coords each
        badPathSpec()
    return [points[6*p+2:6*p+4] for p in range(count)]

def alignLayerByMatchingPoints(image,layer):
    image.undo_group_start()
    try:
        path=image.active_vectors
        if not path:
            raise Exception('No active path found in image')
        if len(path.strokes) == 1:
            ((xr1,yr1),(xr2,yr2),(xm1,ym1),(xm2,ym2))=getPointsFromStroke(path.strokes[0],4)
        elif len(path.strokes) == 2:
            ((xr1,yr1),(xr2,yr2))=getPointsFromStroke(path.strokes[0],2)
            ((xm1,ym1),(xm2,ym2))=getPointsFromStroke(path.strokes[1],2)
        else:
            badPathSpec()

        ar=math.atan2(yr2-yr1,xr2-xr1)
        am=math.atan2(ym2-ym1,xm2-xm1)
        
        lr=math.sqrt((xr1-xr2)**2+(yr1-yr2)**2)
        lm=math.sqrt((xm1-xm2)**2+(ym1-ym2)**2)
        
        scale=lr/lm
        angle=ar-am
        
        layer.transform_2d(xm1,ym1,scale,scale,angle,xr1,yr1,TRANSFORM_FORWARD,pdb.gimp_context_get_interpolation(),False,3,TRANSFORM_RESIZE_ADJUST) 
        
    except Exception as e:
        print e.args[0]
        gimp.message(e.args[0])

    image.undo_group_end()
    
    
### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])
author='Ofnuts'
copyrightYear='2016'
desc='Realign layer by matching two pairs of points in the current path'
register(
    'ofn-align-layer-by-matching-points',
    desc+whoiam,desc,
    author,author,copyrightYear,
    'Realign',
    '*',
    [
        (PF_IMAGE, 'image', 'Input image', None),
        (PF_DRAWABLE, 'drawable', 'Input drawable', None),
    ],
    [],
    alignLayerByMatchingPoints,
    menu='<Image>/Layer'
)

main()