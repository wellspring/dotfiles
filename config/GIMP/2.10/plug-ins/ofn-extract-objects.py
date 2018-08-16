#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to extract isolated objects and save them to file

# Basic principle:
# * Make all pixels of layer fully opaque
# * Create selection from resulting alpha
# * Create path from that selection, path should have one stroke per object
# * Iterate the strokes:
#     * Create a path with a single stroke
#     * Make aslection from it
#     * if the selection contains enough opaque pixels (otherwise it's a hole)
#       * Copy initial layer to make a layer from that selection
#       * Save layer

# (c) Ofnuts 2017
#
#   History:
#
#   v0.0: 2017-12-16 First published version
#   v0.1: 2017-12-17 Add ability to just create the layers
#                    Add 'resize' option
#                    Remove selection at end
#   v0.2: 2018-01-23 Do not make layers from holes (thanks to mich_lloid@gimp-forum.net)

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

def extractObjects(image,layer,resize,directory,namePattern):
    
    # Having 'directrpy' set tells us if we produce layers or files
    # Undo stack is handled differently for each
    
    if directory:
        image.undo_freeze()
    else:
        image.undo_group_start()
    
    try:
        if not image.filename:
            imageName='Objects'
        else:
            imageName,_=os.path.splitext(os.path.basename(image.filename))

        # Copy layer and make all pixels fully opaque
        hardLayer=layer.copy()
        hardLayer.name='Hard alpha'
        image.add_layer(hardLayer,0)
        pdb.plug_in_threshold_alpha(image,hardLayer,0)
        
        # Get a path where each stroke circles an area of opaque pixels
        pdb.gimp_image_select_item(image,CHANNEL_OP_REPLACE,hardLayer)
        path=pdb.plug_in_sel2path(image,hardLayer)
        allObjectsPath=image.vectors[0]

        formatValues={}
        formatValues['imageName']=imageName
        formatValues['layerName']=layer.name

        # Iterate the strokes
        objectPath=gimp.Vectors(image,'Single Object')
        pdb.gimp_image_add_vectors(image,objectPath,0)
        for i,stroke in enumerate(allObjectsPath.strokes):
            # Create path with single stroke and get a selection from it
            points,closed=stroke.points
            objectStroke=gimp.VectorsBezierStroke(objectPath,points,closed)
            pdb.gimp_image_select_item(image,CHANNEL_OP_REPLACE,objectPath)
            
            # Filter "holes". Holes are selections where pixels with alpha>50% are rare
            _,_,_,_,_,percentile=pdb.gimp_histogram(hardLayer, HISTOGRAM_ALPHA, 128,255)

            if percentile>.05:
                # Add one-pixel margin for safety
                pdb.gimp_selection_grow(image,1)
                # Create new layer from selection, and autocrop it
                pdb.gimp_edit_copy(layer)
                objectLayer=pdb.gimp_edit_paste(layer,True)
                pdb.gimp_floating_sel_to_layer(objectLayer)
                pdb.plug_in_autocrop_layer(image,objectLayer)

                # Get the meaningfull values before we resize the layer
                formatValues['num0'],formatValues['num1']=i,i+1
                formatValues['x'],formatValues['y']=objectLayer.offsets
                formatValues['w'],formatValues['h']=objectLayer.width,objectLayer.height

                if resize:
                    pdb.gimp_layer_resize_to_image_size(objectLayer)
            #else:
                #print 'Selection with %5.2f%% opaque pixels ignored' % (percentile*100)
                
            objectPath.remove_stroke(objectStroke)
            pdb.gimp_selection_none(image)

            #raise Exception('Stopping there')

            # Name/Save the layer
            try:
                objectName=namePattern.format(**formatValues)
            except KeyError as e:
                raise Exception('No formatting variable called "%s"' % e.args[0])        
                
            if directory:
                filename=os.path.join(directory,objectName)
                pdb.gimp_file_save(image,objectLayer,filename,filename)
                image.remove_layer(objectLayer)
            else:
                objectLayer.name=objectName

        image.remove_layer(hardLayer)                
        pdb.gimp_image_remove_vectors(image,allObjectsPath)
        pdb.gimp_image_remove_vectors(image,objectPath)
        
    except Exception as e:
        pdb.gimp_message(e.args[0])
        print traceback.format_exc()
    
    if directory:
        image.undo_thaw()
    else:
        image.undo_group_end()

def extractObjectsToFiles(image,layer,resize,directory,namePattern):
    extractObjects(image,layer,resize,directory,namePattern)

def extractObjectsToLayers(image,layer,resize,namePattern):
    extractObjects(image,layer,resize,None,namePattern)

### Registrations
author='Ofnuts'
year='2017'
menu='<Image>/Layer/Extract objects'
descFiles='Extract objects to files'
descLayers='Extract objects to layers'
whoiam='\n'+os.path.abspath(sys.argv[0])

imageParm=      (PF_IMAGE,    'image',      'Input image', None)
layerParm=      (PF_DRAWABLE, 'layer',      'Input layer', None)
layerSizeParm=  (PF_OPTION,   'resize',     'Layer size',  0, ['Tight fit','Canvas size'])
dirParm=        (PF_DIRNAME,  'directory',  'Directory',   '.')
fileNameParm=   (PF_STRING,   'namePattern','Object name', '{layerName}@({x:04d},{y:04d})-({w:02d},{h:02d}).png')
layerNameParm=  (PF_STRING,   'namePattern','Object name', '{layerName}[{num1:03d}]')

register(
    'ofn-extract-objects-files',
    descFiles,descFiles+whoiam,author,author,year,descFiles+'...',
    '*',[imageParm,layerParm,layerSizeParm,dirParm,fileNameParm],[],
    extractObjectsToFiles,
    menu=menu
)

register(
    'ofn-extract-objects-layers',
    descLayers,descLayers+whoiam,author,author,year,descLayers+'...',
    '*',[imageParm,layerParm,layerSizeParm,layerNameParm],[],
    extractObjectsToLayers,
    menu=menu
)

main()
