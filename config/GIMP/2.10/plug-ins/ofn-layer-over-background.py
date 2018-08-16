#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to make the active layer the only visible layer over a visible background
# 
# (c) Ofnuts 2016
#
#   History:
#
#   v0.0: 2016-06-30: First published version
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


def layerOverBackground(image,shownLayer):
    for layer in image.layers[:-1]:
        layer.visible=False
    image.layers[-1].visible=True # show background
    shownLayer.visible=True

### Registrations
 
### Registrations
whoiam='\n'+os.path.abspath(sys.argv[0])
desc='Show layer over background'    
author='Ofnuts'
 
register(
    "ofn-layer-over-background",
    desc,desc,author,author,"2016",desc,
    "*",
    [
        (PF_IMAGE, "image", "Input image", None),
        (PF_DRAWABLE, "layer", "Input layer", None),
    ],
    [],
    layerOverBackground,
    menu="<Layers>"
)

main()
