#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to generate shapes using reference points in paths
# (c) Ofnuts 2017
#
#   History:
#
#   v0.0: 2017-04-30 First published version
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published
#   by the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This very file is the complete source code to the program.
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

from gimpfu import *

def getGuides(image):
    guides=[[],[]] # ORIENTATION-HORIZONTAL (0), ORIENTATION-VERTICAL (1) 
    gid=0
    while True:
        gid=image.find_next_guide(gid)
        if not gid:
            break;
        guides[image.get_guide_orientation(gid)].append(image.get_guide_position(gid))
    map(lambda x:x.sort(),guides)
    return guides

# Yield successive start positions and lengths
def iterateSegments(positions):
    for i in range(len(positions)-1):
        yield positions[i],positions[i+1]-positions[i]

# Yields successive squares
def iterateSquares(image,guides):
    hguides=[0]+guides[0]+[image.height]
    vguides=[0]+guides[1]+[image.width]
    for y,h in iterateSegments(hguides):
        for x,w in iterateSegments(vguides):
            yield x,y,w,h

# Intersection of two rectangles
def intersect(x1,y1,w1,h1,x2,y2,w2,h2):
    x1l,x1r,y1t,y1b=x1,x1+w1,y1,y1+h1
    x2l,x2r,y2t,y2b=x2,x2+w2,y2,y2+h2
    il=max(x1l,x2l) # left side of intersection
    ir=min(x1r,x2r) # right side
    it=max(y1t,y2t) # top (Gimp coordinates!)
    ib=min(y1b,y2b) # bottom
    if ir<=il or ib<=it: # right must be right of left and bottom should be below top
        return None
    return il,it,ir-il,ib-it

def newLayer(image,layer,x,y,w,h):
    lx,ly=layer.offsets[0],layer.offsets[1]
    intersection=intersect(x,y,w,h,lx,ly,layer.width,layer.height)
    if intersection is None:
        return # no intersection
    new=layer.copy()
    image.add_layer(new,0)
    new.name="%s @ (%d,%d)" % (layer.name,x,y)
    ix,iy,iw,ih=intersection
    new.resize(iw,ih,lx-ix,ly-iy)

def guillotineLayer(image,layer):
    image.undo_group_start()
    for x,y,w,h in iterateSquares(image,getGuides(image)):
        newLayer(image,layer,x,y,w,h)
    layer.visible=False;
    image.undo_group_end()

### Registrations
register(
    "ofn-guillotine-layer",
    "Slices the layer into sub-layers using the guides",
    "Slices the layer into sub-layers using the guides",
    "Ofnuts","Ofnuts","2017",
    "Guillotine",
    "*",
    [
        (PF_IMAGE, "image", "Input image", None),
        (PF_DRAWABLE, 'drawable', 'Input drawable', None),
    ],
    [],
    guillotineLayer,
    menu="<Image>/Layer"
)

main()
