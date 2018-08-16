#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to create a 3D perspective view of the layers in an image.

# (c) Ofnuts 2018
#
#   History:
#
#   v0.0: 2018-07-14: Initial version
#   v0.1: 2018-07-19: Add automatic merge of layer
#                     Remove paths in result image
#                     Improve handling of options lists
#   v0.2: 2018-07-28: Remove dependency on Python enums 
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


import math, sys, os, traceback
from gimpfu import *
import gimpcolor
from collections import namedtuple

def createOpts(name,pairs):
    optsclass=namedtuple(name+'Type',[symbol for symbol,label in pairs]+['labels'])
    opts=optsclass(*(range(len(pairs))+[[label for symbol,label in pairs]]))
    return opts

GhostSources=createOpts('Source',
    [
    ('BACKGROUND','Background color'),
    ('SPECIFIED','Specified color'),
    ('AVERAGE','Average layer color'),
    ('MEDIAN','Dominant layer color')
    ])

MergeOptions=createOpts('Merge',[('NONE','None'),('LINKED','Linked layers'),('TEXT','Text layers')])

def removeGuides(image):
    g=image.find_next_guide(0)
    while g!=0: 
        image.delete_guide(g);
        g=image.find_next_guide(0)

def removePaths(image):
    for p in reversed(image.vectors):
        pdb.gimp_image_remove_vectors(image,p)

def whine(s):
    raise Exception(s)
    return True

def getPoints(path):
    path or whine('No path provided')
    path.strokes or whine('No strokes in path provided')
    
    pts,_=path.strokes[0].points
    len(pts)<24 and whine('Not enough points in stroke from path provided')
    
    anchors=sorted([pts[i:i+2] for i in range(2,24,6)],key=lambda x:x[1]) # sorted top-down
    anchorsT=sorted(anchors[0:2],key=lambda x:x[0]) # sorted left-right
    anchorsB=sorted(anchors[2:],key=lambda x:x[0]) # sorted left-right
    return [coord for point in anchorsT+anchorsB for coord in point] # flattened

def colorFromHistogram(r,g,b):
    return (r/255.,g/255.,b/255.)

def layerColor(ghostSource,ghostColor,layer):
    if ghostSource not in [GhostSources.SPECIFIED,GhostSources.BACKGROUND]:
        # Select opaque pixels
        pdb.gimp_image_select_item(layer.image,CHANNEL_OP_REPLACE,layer)
        ra, _, rm, _, _, _ = pdb.gimp_histogram(layer,HISTOGRAM_RED,0,255)
        ga, _, gm, _, _, _ = pdb.gimp_histogram(layer,HISTOGRAM_GREEN,0,255)
        ba, _, bm, p, c, _ = pdb.gimp_histogram(layer,HISTOGRAM_BLUE,0,255)
        pdb.gimp_selection_none(layer.image)
        if ghostSource==GhostSources.AVERAGE:            
            ghostColor=colorFromHistogram(ra,ga,ba)
        elif ghostSource==GhostSources.MEDIAN:            
            ghostColor=colorFromHistogram(rm,gm,bm)
        else:
            raise Exception('Internal error')
    return ghostColor

def perspectiveStack(img,perspective,spaceRatio,marginRatio,merge,ghostOpacity,ghostSource,ghostColor):
    gimp.context_push()
    
    if ghostSource==GhostSources.BACKGROUND:
        ghostColor=gimp.get_background()
    
    try:
        image=img.duplicate()
        image.disable_undo()
        removeGuides(image)
        pts=getPoints(perspective)
        
        mode=[TRANSFORM_FORWARD,INTERPOLATION_LANCZOS,False,3,TRANSFORM_RESIZE_ADJUST]

        layers=image.layers[:]
        for l in layers:
            if not l.visible:
                image.remove_layer(l)

        layers=image.layers[::-1] # reversed list, so we don't destroy what we haven't seen yet
        for l in layers:
            if (pdb.gimp_item_is_text_layer(l) and merge==MergeOptions.TEXT) or (l.linked and merge==MergeOptions.LINKED):
                image.merge_down(l,CLIP_TO_IMAGE)

        layers=image.layers[:] # make copy since insertions/deletion seem to confuse Gimp/Python
        for i,layer in enumerate(layers): 
            if not layer.has_alpha:
                layer.add_alpha()
            # Add fill or resize the layer
            if ghostOpacity==0:
                layer.resize_to_image_size()
            else:
                
                ghostColor=layerColor(ghostSource,ghostColor,layer)
                
                name=layer.name
                ghost=gimp.Layer(image,"##ghost##",image.width,image.height,RGB_IMAGE,ghostOpacity,NORMAL_MODE)
                image.add_layer(ghost,i+1)
                gimp.set_background(ghostColor)
                ghost.fill(BACKGROUND_FILL)   
                layer=image.merge_down(layer,CLIP_TO_IMAGE)
                layer.name=name

            # Transform and position
            pdb.gimp_selection_none(image)
            layer.transform_perspective(*(pts+mode))

        # Final size, position the perpectived layers, and add a background layer
        w,h=image.layers[0].width,image.layers[0].height
        margin=int(w*marginRatio)
        space=int(h*spaceRatio)
        image.resize(w+2*margin,h+space*(len(image.layers)-1)+2*margin)
        for i,l in enumerate(image.layers):
            l.set_offsets(margin,margin+i*space)
        b=gimp.Layer(image,"Background",image.width,image.height,RGB_IMAGE,100, NORMAL_MODE)        
        b.fill(WHITE_FILL)     
        image.add_layer(b,1+len(image.layers))
        removeGuides(image)
        removePaths(image)
        image.enable_undo()
        image.clean_all()
        gimp.Display(image)
        
    except Exception as e:
        traceback.print_exc()
        print e.args[0]
        pdb.gimp_message(e.args[0])
        if (image):
            gimp.delete(image)
      
    gimp.context_pop()

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])
author='Ofnuts'
menu='<Image>/Image/'
copyrightYear='2018'
desc='Stack layers with perspective'

register(
    'ofn-perspective-stack',
    desc+whoiam,desc,author,author,copyrightYear,desc+'...',
    '*',
    [
        (PF_IMAGE, 'image', 'Input image', None),
        (PF_VECTORS,'perspective', 'Perspective path', None),
        (PF_FLOAT, 'spaceRatio', 'Spacing', .2),
        (PF_FLOAT, 'marginRatio', 'Margin',.05),        
        (PF_OPTION, 'mergeLayers', 'Merge layers',MergeOptions.TEXT,MergeOptions.labels),        
        (PF_SLIDER, 'ghostOpacity', 'Ghost opacity',15,(0,100,1)),
        (PF_OPTION, 'ghostSource', 'Ghost color source', GhostSources.MEDIAN,GhostSources.labels),        
        (PF_COLOR, 'ghostColor', 'Ghost color',(192,192,192)),        
    ],[],
    perspectiveStack,
    menu=menu
)

main()
