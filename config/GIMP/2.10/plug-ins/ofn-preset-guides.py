#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to create preset guides
# (c) Ofnuts 2015
#
#   History:
#
#   v0.0: 2015-11-01: First published version
#   v0.1: 2015-11-01: Fix log and config files location
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

import os,sys,re,codecs
from gimpfu import *

basename=os.path.splitext(sys.argv[0])[0]
logFileName=basename+'.log'
cfgFileName=basename+'.ini'

platformsWithTraceToTerminal=['linux2']

def trace(s):
        print s
        sys.stdout.flush()

if sys.platform not in platformsWithTraceToTerminal:
        sys.stdout=open(logFileName,'w')

def addGuidesFromList(addGuide,size,guides):
    for pos in guides:
        if isinstance(pos,float) and 0 <= pos <= 1.:
            addGuide(int(size*pos))
        if isinstance(pos,float) and -1. <= pos <= 0.:
            addGuide(int(size*(1+pos)))
        elif isinstance(pos,int) and 0 <= pos <= size:
            addGuide(pos)
        elif isinstance(pos,int) and (-size) <= pos <= 0:
            addGuide(size+pos)
        else:
            #gimp.message('Invalid position: %s' % pos)
            pass;

def createGuides(image,hguides,vguides):
	image.undo_group_start()
        addGuidesFromList(image.add_hguide,image.height,hguides)
        addGuidesFromList(image.add_vguide,image.width,vguides)
	image.undo_group_end()

### Registrations
whoiam='\n'+os.path.abspath(sys.argv[0])

def evalGuides(desc,gexp):
    guidesList=None
    try:
        guidesList=eval(gexp)
    except:
        pass;
    if not hasattr(guidesList, '__iter__'):
        try:
            guidesList=eval('['+gexp+']')
        except:
            pass;
    if not hasattr(guidesList, '__iter__'):
        trace('Preset "%s": Incorrect syntax: %s' % (desc,gexp))
        return None
    good=True
    for g in guidesList:
        if isinstance(g,int):
            continue
        if isinstance(g,float):
            continue
        trace('Preset "%s": invalid number: %s' % (desc,repr(g)))
        good=False
    return guidesList if good else None    
            
def registerPreset(id,desc,hguides,vguides):

    # Dynamically create function required for registration  
    def createPresetGuides(image):
        createGuides(image,hguides,vguides)

    register(
        'ofn-create-%s-guides' % id,
        'Create preset guides: %s %s' % (desc, whoiam),
        'Create preset guides: %s' % desc,
        'Ofnuts','Ofnuts','2015',
        desc,
        "*",[(PF_IMAGE, "image", "Input image", None)],[],
        createPresetGuides,
        menu='<Image>/Image/Guides/Presets',
    )

#registerPreset("centered","Centered",[.5],[.5])
#registerPreset("margins20","Margins @20px",[20,-20],[20,-20])
#registerPreset("margins50","Margins @50px",[50,-50],[50,-50])
#registerPreset("fullmonty","Full Monty",[20,50,.5,-50,-20],[20,50,.5,-50,-20])
    
def loadConfig():    
    trace('Reading configuration file %s' % cfgFileName)
    try:
        with codecs.open(cfgFileName, 'r', encoding='utf-8') as configFile:
            for i,line in enumerate(configFile):
                configLineElems=line.strip().split(':',4)
                if len(configLineElems)==0:
                    continue
                if len(configLineElems[0])==0:
                    continue
                if configLineElems[0][0]=='#':
                    continue
                if len(configLineElems)!=4:
                    trace('Line %d does not contain at least 4 elements' % (i+1))
                    continue
                desc,ident,hgexp,vgexp=configLineElems
                hguides=evalGuides(desc,hgexp)
                vguides=evalGuides(desc,vgexp)
                if hguides is None or vguides is None:
                    continue
                registerPreset(ident,desc,hguides,vguides)
                trace('Preset "%s": registering' % desc)
        trace('Configuration file %s read successfully' % cfgFileName)
    except Exception as e:
        trace('Configuration file %s not found or not readable: %s' % (cfgFileName,e))

loadConfig()

main()       
