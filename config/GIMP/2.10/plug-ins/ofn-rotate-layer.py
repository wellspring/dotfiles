#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to create several rotations of a layer

# (c) Ofnuts 2017
#
#   History:
#
#   v0.0: 2017-12-15 First published version

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

import sys,os,math,traceback
from gimpfu import *
    
def rotateLayer(image,source,ccw,angle,count,autocenter,centerX,centerY,namePattern):

    image.undo_group_start()
    savedSel=None
    try:
        count=int(count)
        if angle==0. and count==0: 
            raise Exception('Angle and Count cannot be null at the same time!')
        elif angle<0:
            raise Exception('Angle must be positive (use the "Direction" setting)')
        elif angle==0.:
            angle=360./count
        elif count==0:
            count=int(360/angle)
        else:
            pass; # no neded to giess anything
        
        angle=math.pi*angle/180.
        angle=-angle if ccw else angle # Trig is counter-clockwise, but Gimp's Y is upside-down

        formatValues={}
        formatValues['sourceName']=source.name
        formatValues['count']=count
        formatValues['direction']=['CW','CCW'][ccw]
        
        savedSel=pdb.gimp_selection_save(image)
        pdb.gimp_selection_none(image)
        
        for i in range(count):
            rotation=angle*i
            formatValues['num0']=i
            formatValues['num1']=i+1
            formatValues['angleInt']=int(.5+abs(rotation)*180/math.pi)
            formatValues['angleDec']=rotation*180/math.pi
            layerName=namePattern.format(**formatValues)
            rotated=source.copy()
            rotated.name=layerName
            image.add_layer(rotated,0)
            pdb.gimp_item_transform_rotate(rotated,rotation,autocenter,centerX,centerY)
            
    except Exception as e:
        pdb.gimp_message(e.args[0])
        print traceback.format_exc()
    if savedSel:
        pdb.gimp_image_select_item(image,CHANNEL_OP_REPLACE,savedSel)
        image.remove_channel(savedSel)
        
    image.undo_group_end()
    

### Registrations
author='Ofnuts'
year='2017'
desc='Create multiple rotated copies of the layer'
whoiam='\n'+os.path.abspath(sys.argv[0])

register(
    'ofn-rotate-layer',
    desc+whoiam,desc,author,author,year,'Multi-rotate...',
    '*',
    [
        (PF_IMAGE,      'image',        'Input image', None),
        (PF_DRAWABLE,   'source',       'Input layer', None),
        (PF_OPTION,     'ccw',          'Direction',   0,['Clockwise','Counter-clockwise']),
        (PF_FLOAT,      'angle',        'Angle(°)',    0.),
        (PF_SPINNER,    'count',        'Count',       12, (1,1000,1)),
        (PF_OPTION,     'autocenter',   'Auto-center', 1,['No','Yes']),        
        (PF_FLOAT,      'centerX',      'Center X',    0.),
        (PF_FLOAT,      'centerY',      'Center Y',    0.),
        (PF_STRING,     'namePattern',  'Layer name',  '{sourceName}-{angleInt:03d}')
    ],
    [],
    rotateLayer,
    menu='<Image>/Layer/Transform'
)

main()
