#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to create symmetries
# (c) Ofnuts 2016
#
# Warning: the scripts below assume that the layer is a the top of the stack
# and has the size of the image... This is true for single-layer images
#
#   History:
#
#   v0.0: 2016-04-09: First published version
#   v0.1: 2016-04-10: Add diagonal symmetries
#   v0.2: 2016-04-11: Bluntly remove any selections
#   v0.3: 2016-04-11: Make 2.6 complacent (gimp_free_select())
#   v0.4: 2016-09-27: Add straight symmetries
#                     Properly handle partial transparency
#                     Properly handle layers smaller than the image
#                     Properly handle existing selection
#                     Check operation only on square layers for diagonal symmetry
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


version='0.3'

import sys,os
from gimpfu import *

CORNERS=['NW','NE','SE','SW']
SIDES=['N','S','E','W']

def quadrilateralSymmetry(image,layer):
    pdb.gimp_image_undo_group_start(image)
    pdb.gimp_selection_none(image)
    
    w,h=layer.width,layer.height
    layerNE=layer.copy(False)
    layerSE=layer.copy(False)
    layerSW=layer.copy(False)
    image.add_layer(layerNE)
    image.add_layer(layerSE)
    image.add_layer(layerSW)
    layerNE.name='NE'
    layerSE.name='SE'
    layerSW.name='SW'
    layerNE.transform_flip_simple(ORIENTATION_HORIZONTAL, False,w)
    layerSW.transform_flip_simple(ORIENTATION_VERTICAL, False,h)
    layerSE.transform_flip_simple(ORIENTATION_HORIZONTAL, False,w)
    layerSE.transform_flip_simple(ORIENTATION_VERTICAL, False,h)
    merged=image.merge_down(layerSW,EXPAND_AS_NECESSARY)
    merged=image.merge_down(merged,EXPAND_AS_NECESSARY)
    merged=image.merge_down(merged,EXPAND_AS_NECESSARY)
    image.resize(w*2,h*2,0,0)
    pdb.gimp_image_undo_group_end(image)
    return merged

def diagonalSymmetryCore(image,layer,symLayer,corner):
    # Some arrays to avoid if/else, indexed by 'corner'
    flipTypes=[ORIENTATION_HORIZONTAL,ORIENTATION_HORIZONTAL,ORIENTATION_VERTICAL,ORIENTATION_VERTICAL]
    rotateTypes=[ROTATE_90,ROTATE_270,ROTATE_270,ROTATE_90]
    w,h=layer.width,layer.height
    if w!=h:
        raise Exception('Diagonal symmetry only applies to square layers')    
    x,y=layer.offsets
    corners=[(x,y),(x+w,y),(x+w,y+h),(x,y+h)]

    # Rotate and flip as required
    symLayer.transform_flip_simple(flipTypes[corner],True,0)
    symLayer.transform_rotate_simple(rotateTypes[corner],True,0,0)
    
    # Cut the corner we want to symmetrize (so that the original corner shows)
    selectPoints=corners[(corner-1)%4]+corners[corner]+corners[(corner+1)%4]
    if gimp.version >= (2,8,0):
        pdb.gimp_image_select_polygon(image,CHANNEL_OP_REPLACE,len(selectPoints),selectPoints)
    else: # use deprecated version in Gimp 2.6
        pdb.gimp_free_select(image,len(selectPoints),selectPoints,CHANNEL_OP_REPLACE,True, False,0)   
    # remove antialiasing on diagonal, because compositing the antialising pixels is more
    # opaque than the original transparency, so we want one single pixel from either side, the
    # side being not important, since by construction these are the same pixels... 
    pdb.gimp_selection_sharpen(image)

def straightSymmetryCore(image,layer,symLayer,side):
    # Some arrays to avoid if/else, indexed by 'side'
    flipTypes=[ORIENTATION_VERTICAL,ORIENTATION_VERTICAL,ORIENTATION_HORIZONTAL,ORIENTATION_HORIZONTAL]
    x,y=layer.offsets
    w,h=layer.width,layer.height
    # The rects we delete in the flipped layer
    rects=[(x,y,w,h/2),(x,y+h-h/2,w,h/2),(x+w-w/2,y,w/2,h),(x,y,w/2,h)]
    
    # Rotate and flip as required
    symLayer.transform_flip_simple(flipTypes[side],True,0)
    pdb.gimp_image_select_rectangle(image, CHANNEL_OP_REPLACE,*rects[side])

def runSymmetry(symmetryFunction,image,layer,symmetry):
    image.undo_group_start()
    savedSel=pdb.gimp_selection_save(image)
    pdb.gimp_selection_none(image)
    
    # make a copy of the layer, with an alpha channel
    mergedLayer=layer # so we return something anyway
    symLayer=layer.copy(True)
    image.add_layer(symLayer)
        
    try:
        symmetryFunction(image,layer,symLayer,symmetry)
        pdb.gimp_edit_clear(symLayer)
        pdb.gimp_selection_invert(image)
        pdb.gimp_edit_clear(layer)
        mergedLayer=image.merge_down(symLayer,EXPAND_AS_NECESSARY)     
    except Exception as e:
        image.remove_layer(symLayer) # in this case it still exists
        gimp.message(e.args[0])
        
    # Clean and exit
    pdb.gimp_image_select_item(image,CHANNEL_OP_REPLACE,savedSel)
    image.remove_channel(savedSel)
    image.undo_group_end()
    return mergedLayer

### Registrations

# By utter laziness and just for the hell of it, functions
# that generate the proper function for a given corner/side
def straightSymmetryGenerator(side):
    def straightSymmetryForSide(image,layer):
        return runSymmetry(straightSymmetryCore,image,layer,side)
    return straightSymmetryForSide

def diagonalSymmetryGenerator(corner):
    def diagonalSymmetryForCorner(image,layer):
        return runSymmetry(diagonalSymmetryCore,image,layer,corner)
    return diagonalSymmetryForCorner

# Some variables to avoid repeating myself
whoiam='\n%s (v%s)' % (os.path.abspath(sys.argv[0]),version)
parmsIn= [(PF_IMAGE,'image','Input image',None),(PF_DRAWABLE,'layer','Input layer',None)]
parmsOut=[(PF_LAYER, 'layer', 'Returned layer', None),]
menuLocation='<Image>/Layer/Symmetries'
author='Ofnuts'
year='2016'
    
def reg(id,desc,menu,menuLocation,function):
    register(id,desc+whoiam,desc,author,author,year,menu,'*',parmsIn,parmsOut,function,menuLocation)
    
reg('ofn-quad-symmetry','Quadrilateral symmetry','Quadrilateral symmetry',menuLocation,quadrilateralSymmetry)

for cornerIndex,cornerName in enumerate(CORNERS):
    reg('ofn-diagonal-symmetry-%s'%cornerName, 'Diagonal symmetry (%s)' % cornerName,cornerName,menuLocation+'/Diagonal symmetry',diagonalSymmetryGenerator(cornerIndex))

for sideIndex,sideName in enumerate(SIDES):
    reg('ofn-straight-symmetry-%s'%sideName, 'Straight symmetry (%s)' % sideName,sideName,menuLocation+'/Straight symmetry',straightSymmetryGenerator(sideIndex))

main()
