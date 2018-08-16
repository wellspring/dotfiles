#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to save all layers in an image as separate files.

# (c) Ofnuts 2017
#
#   History:
#
#   v0.0: 2017-12-12 First published version
#   v0.1: 2018-02-22 Change/add name/rawName formatting values

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

import sys,os,os.path,traceback
from gimpfu import *

def exportLayers(image,directory,namePattern):

    try:
        if not image.filename:
            imageName='Layer'
        else:
            imageName,_=os.path.splitext(os.path.basename(image.filename))
        layersCount=len(image.layers)
        formatValues={}
        formatValues['imageName']=imageName
        formatValues['count']=layersCount
        for i,layer in enumerate(image.layers):
            formatValues['numDown0']=i
            formatValues['numDown1']=i+1
            formatValues['numUp0']=layersCount-(i+1)
            formatValues['numUp1']=layersCount-i
            formatValues['rawName']=layer.name
            formatValues['name']=os.path.splitext(layer.name)[0]
            formatValues['width']=layer.width
            formatValues['height']=layer.height
    
            try:
                filename=namePattern.format(**formatValues)
            except KeyError as e:
                raise Exception('No formatting variable called "%s"' % e.args[0])        
            filename=os.path.join(directory,filename)
            pdb.gimp_file_save(image,layer,filename,filename)
            
    except Exception as e:
        pdb.gimp_message(e.args[0])
        print traceback.format_exc()
    
### Registrations
author='Ofnuts'
year='2017'
exportMenu='<Image>/File/Export/'
exportDesc='Export all layers'
whoiam='\n'+os.path.abspath(sys.argv[0])

register(
    'ofn-export-layers',
    exportDesc,exportDesc+whoiam,author,author,year,exportDesc+'...',
    '*',
    [
        (PF_IMAGE,      'image',        'Input image', None),
        (PF_DIRNAME,    'directory',    'Directory',   '.'),
        (PF_STRING,     'namePattern',  'Layer name',   '{imageName}-{name}.png'),
    ],
    [],
    exportLayers,
    menu=exportMenu
)
    
main()
