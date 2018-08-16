#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to save a layer as tiles

# (c) Ofnuts 2017
#
#   History:
#
#   v0.0: 2017-08-09 First published version
#   v0.1: 2017-08-09 Add tileCR and tileRC format variables, cleanup
#   v0.2: 2017-08-10 Add imageName format variable, harden formatting a bit
#   v0.3: 2017-08-21 Refactor, add width*height input, add more format variables 
#                    add opening, move menus to Open/Export sections of <Image>/File

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

import sys,os,os.path,re,glob,traceback
from gimpfu import *

def tilesDataRC(image,rows,columns):
    if image.width%columns:
        raise Exception('Image width (%d) not a multiple of the number of columns (%d)' % (image.width,columns))        
    if image.height%rows:
        raise Exception('Image height (%d) not a multiple of the number of rows (%d)' % (image.height,rows))
    
    width=image.width/columns
    height=image.height/rows
    return width,height,rows,columns

def tilesDataWH(image,width,height):
    if image.width%width:
        raise Exception('Image width (%d) not a multiple of the tile width (%d)' % (image.width,width))        
    if image.height%height:
        raise Exception('Image height (%d) not a multiple of the tile height (%d)' % (image.height,height))
    
    columns=image.width/width
    rows=image.height/height
    return width,height,rows,columns

def iterateTiles(rows,columns):
    for row in range(rows):
        for column in range(columns):
            yield column*rows+row,row*columns+column,row,column
    
def exportTiles(image,directory,namePattern,tileData):
    image.undo_freeze()
    
    allTiles=None
    try:
        if not image.filename:
            imageName='Tile'
        else:
            imageName,_=os.path.splitext(os.path.basename(image.filename))
        allTiles=pdb.gimp_layer_new_from_visible(image,image,'Tiles')
        image.add_layer(allTiles,0)
        width,height,rows,columns=tileData
        formatValues={}
        formatValues['imageName']=imageName
        formatValues['rows']=rows
        formatValues['columns']=columns
        formatValues['width']=width
        formatValues['height']=height
        formatValues['count']=rows*columns
        for tileCR,tileRC,row,column in iterateTiles(rows,columns):
            formatValues['rowO']=row
            formatValues['row1']=row+1
            formatValues['column0']=column
            formatValues['column1']=column+1
            formatValues['tileCR0']=tileCR
            formatValues['tileCR1']=tileCR+1,
            formatValues['tileRC0']=tileRC
            formatValues['tileRC1']=tileRC+1,
            try:
                filename=namePattern.format(**formatValues)
            except KeyError as e:
                raise Exception('No formatting variable called "%s"' % e.args[0])        
            filename=os.path.join(directory,filename)
            tile=allTiles.copy()
            image.add_layer(tile,0)
            tile.resize(width,height,-column*width,-row*height)
            pdb.gimp_file_save(image,tile,filename,filename)
            image.remove_layer(tile)
            
    except Exception as e:
        pdb.gimp_message(e.args[0])
        print traceback.format_exc()
    
    if allTiles:
        image.remove_layer(allTiles)
    image.undo_thaw()
    
def exportTilesRC(image,directory,namePattern,rows,columns):
    exportTiles(image,directory,namePattern,tilesDataRC(image,int(rows),int(columns)))

def exportTilesWH(image,directory,namePattern,width,height):
    exportTiles(image,directory,namePattern,tilesDataWH(image,int(width),int(height)))

def guess(fileNames,rowsFirst):
    pattern=re.compile(r'(^(.*\D)?)(\d+)(\D+)(\d+)(\D*)$')
    commonSeps=None
    minNums=[sys.maxint,sys.maxint]
    maxNums=[0,0]
    
    for fileName in fileNames:
        fn,_=os.path.splitext(os.path.basename(fileName))
        match=pattern.match(fn)
        if not match:
            raise Exception('Cannot figure out row or columns in %s' % fn)
        s1,_,n1,s2,n2,s3=match.groups()
        if not commonSeps: # first image
            commonSeps=(s1,s2,s3)
        else:
            if commonSeps!=(s1,s2,s3):
                print (fn,)+commonSeps
                raise Exception('Image %s doesn\'t match %s**%s**%s' % ((fn,)+commonSeps))
        nums=[int(n1),int(n2)]
        minNums=[min(x,y) for x,y in zip(nums,minNums)]
        maxNums=[max(x,y) for x,y in zip(nums,maxNums)]
    n1,n2=[1+maxX-minX for minX,maxX in zip(minNums,maxNums)]
    if rowsFirst:
        rows,columns=n1,n2
    else:
        rows,columns=n2,n1
    print 'Guessed: %d rows and %d columns' % (rows,columns)
    return columns, rows 

def openTiles(directory,namePattern,rows,columns,rowsFirst,flatten):
    image=None
    try:
        rows=int(rows)
        columns=int(columns)
        tileFiles=list(sorted(glob.glob(os.path.join(directory,namePattern))))
        if (rows,columns)==(0,0):
            columns,rows=guess(tileFiles,rowsFirst)
        if len(tileFiles)!=rows*columns:
            raise Exception('Number of files (%d) does not match the number of expected tiles (%d*%d=%d)' % (len(tileFiles),rows,columns,rows*columns))
        
        image=gimp.Image(1,1,RGB)
        tileW,tileH=0,0
        for row in range(rows):
            for column in range(columns):
                # Whatever the order specified by the user, we open the files row by row
                # The rowsFirst flag only changes how we retrieve the file name from the list
                if rowsFirst:
                    tileFile=tileFiles[row*columns+column]
                else:
                    tileFile=tileFiles[column*rows+row]
                tile=pdb.gimp_file_load_layer(image,tileFile)
                if (tileW,tileH)!=(0,0):
                    if (tileW,tileH)!=(tile.width,tile.height):
                        raise Exception('Tile "%s" is not the same size as the previous ones' % tileFile)
                else:
                    tileW,tileH=tile.width,tile.height
                image.add_layer(tile,0)
                tile.set_offsets(column*tileW,row*tileH)
 
        image.resize(columns*tileW,rows*tileH)
        if flatten: 
            tilesLayer=image.merge_visible_layers(EXPAND_AS_NECESSARY)
            tilesLayer.name=os.path.join(os.path.basename(directory),namePattern)
        image.clean_all()
        gimp.Display(image)
        
    except Exception as e:
        pdb.gimp_message(e.args[0])
        print traceback.format_exc()
        if image:
            gimp.delete(image)
    return image

### Registrations
author='Ofnuts'
year='2017'
exportMenu='<Image>/File/Export/Export tiles'
exportDescWH='Export tiles (by width and height)'
exportDescRC='Export tiles (by rows and columns)'
openDesc='Create image from tiles'
whoiam='\n'+os.path.abspath(sys.argv[0])

register(
    'ofn-export-tiles-rc',
    exportDescRC,exportDescRC+whoiam,author,author,year,exportDescRC+'...',
    '*',
    [
        (PF_IMAGE,      'image',        'Input image', None),
        (PF_DIRNAME,    'directory',    'Directory',   '.'),
        (PF_STRING,     'namePattern',  'Tile name',   '{imageName}-{column1:02d}-{row1:02d}.png'),
        (PF_SPINNER,    'rows',         'Rows',        10, (1,1000,1)),
        (PF_SPINNER,    'columns',      'Columns',     10, (1,1000,1))
    ],
    [],
    exportTilesRC,
    menu=exportMenu
)

register(
    'ofn-export-tiles-wh',
    exportDescWH,exportDescWH+whoiam,author,author,year,exportDescWH+'...',
    '*',
    [
        (PF_IMAGE,      'image',        'Input image', None),
        (PF_DIRNAME,    'directory',    'Directory',   '.'),
        (PF_STRING,     'namePattern',  'Tile name',   '{imageName}-{column1:02d}-{row1:02d}.png'),
        (PF_SPINNER,    'width',        'Tile width',  10, (1,1000,1)),
        (PF_SPINNER,    'height',       'Tile height', 10, (1,1000,1))
    ],
    [],
    exportTilesWH,
    menu=exportMenu
)

register(
    'ofn-open-tiles',
    openDesc,openDesc+whoiam,author,author,year,'Open tiles...',
    '',
    [
        (PF_DIRNAME,    'directory',    'Directory',   '.'),
        (PF_STRING,     'namePattern',  'Tile name',   '*.png'),
        (PF_SPINNER,    'rows',         'Rows',         0, (0,1000,1)),
        (PF_SPINNER,    'columns',      'Columns',      0, (0,1000,1)),
        (PF_OPTION,     'rowsFirst',    'Named by',     0, ['Columns then rows','Rows then columns']),
        (PF_OPTION,     'flatten',      'Tiles',        0, ['Keep as distinct layers','Flatten to single layer'])
    ],
    [
        (PF_IMAGE,      'image',    'Opened image', None),        
    ],
    openTiles,
    menu='<Image>/File/Open'
)

main()
