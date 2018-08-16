#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to resize visible/all layers to the canvas size
# (c) Ofnuts 2018
#
#   History:
#
#   v0.0: 2018-03-11:   First published version
#   v0.1: 2018-03-14:   Fix behavior in presence of layer groups (thx to Joao S Bueno)
#                       Use option selector  
#   v0.2: 2018-03-15:   Add option to add alpha channel
#                       Add option to skip text layers  
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

import os,sys
from gimpfu import *

def resizeLayers(image,all,addAlpha,sizeText):
    image.undo_group_start()
    recursiveResizeLayers(image,all,addAlpha,sizeText)
    image.undo_group_end()

def recursiveResizeLayers(parent,all,addAlpha,sizeText):
    for pos,layerOrGroup in enumerate(parent.layers):
        if all or layerOrGroup.visible: 
            if isinstance(layerOrGroup,gimp.GroupLayer):
                recursiveResizeLayers(layerOrGroup,all,addAlpha,sizeText)
            else:
                if sizeText or not pdb.gimp_item_is_text_layer(layerOrGroup):
                    if addAlpha and not layerOrGroup.has_alpha:
                        layerOrGroup.add_alpha()
                    layerOrGroup.resize_to_image_size()

### Registrations
whoiam='\n'+os.path.abspath(sys.argv[0])
    
register(
    "resize-all-layers-to-image-size",
    "Resize layers to image size"+whoiam,
    "Resize layers to image size",
    "Ofnuts","Ofnuts","2018",
    "Resize layers to image size",
    "*",
    [
        (PF_IMAGE, 'image', 'Input image', None),
        (PF_OPTION,'side','Layers', 0, ['Visible layers','All layers']),
        (PF_OPTION,'addAlpha','Add alpha', 1, ['No','Yes']),
        (PF_OPTION,'sizeText','Skip text layers', 1, ['Yes','No'])
    ],[],
    resizeLayers,
    menu="<Image>/Image/"
)
    
main()       
