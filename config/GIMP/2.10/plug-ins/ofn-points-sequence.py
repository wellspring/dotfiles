#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to add sequence points following path
# (c) Ofnuts 2018
#
#   History:
#
#   v0.0: 2018-08-09 First published version
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
            
def pointsSequence(image,path,font,fontSize,start,offsetX,offsetY):
    image.undo_group_start()
    try:
        for stroke in path.strokes:
            points,closed=stroke.points
            anchors=[points[x:x+2] for x in range(2,len(points),6)]
            for number,(x,y) in enumerate(anchors,start):
                layer = pdb.gimp_text_layer_new(image, str(number),font,fontSize,0)
                layer.set_offsets(int(x+offsetX-layer.width/2),int(y+offsetY-layer.height/2))
                image.add_layer(layer,0)

    except Exception as e:
        print e.args[0]
        pdb.gimp_message(e.args[0])

    image.undo_group_end() 
    return;

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])

desc='Sequence numbers on anchors'
register(
    "ofn-points-sequence",desc+whoiam,desc,
    "Ofnuts","Ofnuts","2018",desc,"*",
    [
        (PF_IMAGE, "image", "Input image", None),
        (PF_VECTORS, "refpath", "Input path", None),
        (PF_FONT, "font", "Font", 'Sans'),
        (PF_SLIDER, "fontsize", "Font size", 20, (6,400,1)),
        (PF_INT, "start", "Start at", 1),
        (PF_INT, "offsetX", "Offset X", 0),
        (PF_INT, "offsetY", "Offset Y", 0),
    ],
    [],
    pointsSequence,
    menu="<Image>/Filters/Render",
)

main()

