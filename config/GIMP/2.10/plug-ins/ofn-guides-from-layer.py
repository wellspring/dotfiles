#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin split layers along the guides
# (c) Ofnuts 2018
#
#   History:
#
#   v0.0: 2018-08-08 First published version
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

def guidesFromLayer(image,layer):
    
    if not isinstance(layer,gimp.Layer):
        return

    image.undo_group_start()
    
    x,y=layer.offsets
    w,h=layer.width,layer.height

    image.add_vguide(x)
    image.add_vguide(x+w)    
    image.add_hguide(y)
    image.add_hguide(y+h)

    image.undo_group_end()

### Registrations
register(
    "ofn-guides-from-layer",
    "Generate guides from the bounding box of a layer",
    "Generate guides from the bounding box of a layer",
    "Ofnuts","Ofnuts","2018",
    "New guides from active layer",
    "*",
    [
        (PF_IMAGE, "image", "Input image", None),
        (PF_DRAWABLE, 'drawable', 'Input drawable', None),
    ],
    [],
    guidesFromLayer,
    menu="<Image>/Image/Guides"
)

main()
