#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to enlarge the canvas to fit a path
# (c) Ofnuts 2015,2018
#
#   History:
#
#   v0.0: 2015-11-07 first published version
#   v0.1: 2015-11-07 add margin option
#   v0.2: 2015-11-08 simplify bounding box computation, 
#                    add menu entry in <Vectors>
#                    add configuration file for margin and menu location
#                    behave properly with existing selection
#   v0.3: 2018-06-29 behave properly when /ini file is missing (thx Akovia) 

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



import os, sys, math, ConfigParser
from gimpfu import *

execName=os.path.splitext(os.path.basename(sys.argv[0]))[0]
settingsDir=gimp.directory+'/tool-options/'
iniFileName=settingsDir+execName+'.ini'

def fitCanvasToActivePathWithMargin(image,margin):
    fitCanvasToPathWithMargin(image,image.active_vectors,margin)

def fitCanvasToActivePathTight(image):
    fitCanvasToActivePathWithMargin(image,0)

def fitCanvasToPathWithMargin(image,path,margin):
    margin=int(margin)
    if path==None:
        gimp.message('No active path in image')
        return 
    if not path :
        gimp.message('No elements in active path')
        return
            
    allStrokePoints=[]
    # path bounding box < union stroke bounding boxes 
    # stroke bouding box < union of splines bounding boxes
    # spline bounding polygon = point that define the spline
    # spline bounding box < rectangle the encloses these 4 points
    # hence whole path is within rectangle define by max|min X|Y 
    # of anchor and tangent handles
    for stroke in path.strokes:
        (coords,closed)=stroke.points
        allStrokePoints.extend(coords)

    allX=allStrokePoints[0::2]
    allY=allStrokePoints[1::2]
    minX=int(math.floor(min(allX)))
    minY=int(math.floor(min(allY)))
    maxX=int(math.ceil(max(allX)))
    maxY=int(math.ceil(max(allY)))
         
    image.undo_group_start()
    # resize canvas to rough bounding box of path including margin
    image.resize(2*margin+maxX-minX,2*margin+maxY-minY,-minX+margin,-minY+margin)

    # select path and crop to selection for a tighter fit
    savedSelection=pdb.gimp_selection_save(image)
    pdb.gimp_image_select_item(image,CHANNEL_OP_REPLACE,path)
    _, minX,minY,maxX,maxY=pdb.gimp_selection_bounds(image)
    image.crop(2*margin+maxX-minX,2*margin+maxY-minY,minX-margin,minY-margin)
    pdb.gimp_selection_load(savedSelection)
    image.remove_channel(savedSelection)
    
    image.undo_group_end()

def fitCanvasToPathTight(image,path):
    fitCanvasToPathWithMargin(image,path,0)
    
### Registration

defaults={'margin':'10','imageMenu':'yes','pathsMenu':'no'}
config = ConfigParser.ConfigParser(defaults)
readConfig=config.read([iniFileName])
section= execName if config.sections() else 'DEFAULT'
marginDefault=config.getint(section,'margin')
useImageMenu=config.getboolean(section,'imageMenu')
usePathsMenu=config.getboolean(section,'pathsMenu')

whoiam='\n'+os.path.abspath(sys.argv[0])
descTight='Fit canvas to path (tight)'
menuTight='Tight'
descMargin='Fit canvas to path (with margin)'
menuMargin='With margin...'
imageMenu='<Image>/Image/Fit canvas to path'
pathsMenu='<Vectors>/Fit canvas to path'
author='Ofnuts'

imageParm=(PF_IMAGE, "image", "Input image", None)
pathParm=(PF_VECTORS, "path", "Input path", None)
marginParm=(PF_SLIDER,'margin','Margin',marginDefault,(0,200,1))

if usePathsMenu:
    register(
            "ofn-fit-canvas-to-path-tight",descTight+whoiam,descTight,author,author,"2015",
            menuTight,'*',[imageParm,pathParm],[],fitCanvasToPathTight,menu=pathsMenu
    )

    register(
            "ofn-fit-canvas-to-path-with-margin",descMargin+whoiam,descMargin,author,author,"2015",
            menuMargin,'*',[imageParm,pathParm,marginParm],[],fitCanvasToPathWithMargin,menu=pathsMenu,
    )

if useImageMenu:
    register(
            "ofn-fit-canvas-to-active-path-tight",descTight+whoiam,descTight,author,author,"2015",
            menuTight,'*',[imageParm],[],fitCanvasToActivePathTight,menu=imageMenu
    )

    register(
            "ofn-fit-canvas-to-active-path-with-margin",descMargin+whoiam,descMargin,author,author,"2015",
            menuMargin,'*',[imageParm,marginParm],[],fitCanvasToActivePathWithMargin,menu=imageMenu,
    )

main()
