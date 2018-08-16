#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to dump group names to console
# (c) Ofnuts 2016
#
#   History:
#
#   v0.0: 2016-04-08: First published version
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

from gimpfu import *


def dump(parent,level,dumpList):
    prefix='     '*level
    for pos,layerOrGroup in enumerate(parent.layers):
        dumpList.append(prefix+layerOrGroup.name)
        if isinstance(layerOrGroup,gimp.GroupLayer):
            dump(layerOrGroup,level+1,dumpList)

def dumpLayerHierarchy(image):
    dumpList=[]
    dump(image,0,dumpList)
    gimp.message('\n'.join(dumpList))

### Registrations
    
register(
    'ofn-dump-layer-hierarchy','Dump layer hierarchy','Dump layer hierarchy',
    'Ofnuts','Ofnuts','2016',
    'Dump layer hierarchy',
    '*',
    [(PF_IMAGE, 'image', 'Input image', None)],[],
    dumpLayerHierarchy,
    menu='<Image>/Image',
)

main()
