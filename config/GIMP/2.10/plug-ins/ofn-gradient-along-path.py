#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to draw a gradient radiallly from a path
# More or less a reboot from neon-path, taking advantage
# of a new API to stroke lines
# (c) Ofnuts 2018
#
#   History:
#
#   v0.0: 2018-05-16: Initial version
#   v0.1: 2018-05-17: Add "Reverse gradient" option
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

import math, sys, os
from gimpfu import *

CAP_STYLES=['Current','Butt','Round','Square']
JOIN_STYLES=['Current','Miter','Round','Bevel']

PRECISIONS=[('Very fine',.5),('Fine',1.),('Rough',2.),('Coarse',5.)]

# Returns the successive widths that will be used. 
# Largest, and so, outer, and so, end of gradient, is first
def computeWidths(width,precision):
    w=width
    widths=[]
    while w>0:
        widths.append(w)
        w-=precision
    return widths

def computeGradientSamples(widths,width):
    raw=[w/width for w in widths]
    # Firs one is 1., but last one isn't exactly 0, 
    # so we stretch everybody a little bit
    delta=raw[-1]/(len(widths)-1)
    adjusted=[w-i*delta for i,w in enumerate(raw)]
    #print "---"
    #print raw
    #print adjusted
    return adjusted
     
def sampleColors(widths,width,reverse):
    # Get the colors. The colors are sample on the outer edge of the corresponding stroke
    # so that the outer edge of the result is exactly the rightmost color of the gradient.
    gradient=gimp.context_get_gradient()
    gradientSamples=computeGradientSamples(widths,width)
    count,flatColors=pdb.gimp_gradient_get_custom_samples(gradient,len(gradientSamples),gradientSamples,not reverse)
    return [tuple(flatColors[i:i+4]) for i in range(0,count,4)]
    
def gradientAlongPath(image,path,width,reverse,precision,capStyle,joinStyle,miterLimit):
    pdb.gimp_image_undo_group_start(image)
    pdb.gimp_context_push()

    precision=PRECISIONS[precision][1]
    
    try:
        # Common settings for all stroke operations
        pdb.gimp_context_set_stroke_method(STROKE_LINE)
        if capStyle:
            pdb.gimp_context_set_line_cap_style(capStyle-1)
        if joinStyle:
            pdb.gimp_context_set_line_join_style(joinStyle-1)
            if joinStyle==1: # ugly hard-coding of "Miter"
                pdb.gimp_context_set_line_miter_limit(float(miterLimit))

        widths=computeWidths(width,precision)
        passes=len(widths)
        if passes < 2:
            raise Exception('Line width to small for the requested precision')
            
        drawable=image.active_drawable
        gradientSamples=computeGradientSamples(widths,width)
        colors=sampleColors(widths,width,not reverse)
        for color,width in zip(colors,widths):
            pdb.gimp_context_set_foreground(color)
            pdb.gimp_context_set_line_width(width)
            pdb.gimp_drawable_edit_stroke_item(drawable, path)

    except Exception as e:
        print e.args[0]
        pdb.gimp_message(e.args[0])

    pdb.gimp_context_pop()
    pdb.gimp_image_undo_group_end(image)

    return True

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])
desc='Draw a gradient radially from a path'
    
register(
    'gradient-along-path',desc+whoiam,desc,
    'Ofnuts','Ofnuts','2018',
    'Gradient along path...',
    '*',
    [
        (PF_IMAGE, 'image', 'Input image', None),
        (PF_VECTORS, 'refpath', 'Input path', None),
        (PF_SPINNER, 'width', 'Width (pixels):', 50, (1, 2000, 1)),
        (PF_TOGGLE, 'reverse', 'Reverse gradient', False),
        (PF_OPTION, 'precision', 'Precision',1, [x[0] for x in PRECISIONS]),
        (PF_OPTION, 'capStyle', 'Cap style',0,CAP_STYLES),
        (PF_OPTION, 'joinStyle', 'Join style',0, JOIN_STYLES),
        (PF_SLIDER, 'miterLimit','Miter limit',0,(0,100,1))
    ],
    [],
    gradientAlongPath,
    menu='<Vectors>/Decorate',
)

main()
