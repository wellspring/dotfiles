#!/usr/bin/env python
# sprite_gutter_add
# Version 1.1
# Copyright 2012 David 'The Visible Man' Braun
# GIMP plugin to add padding/gutter to 2D Spritesheets

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# See <http://www.gnu.org/licenses/> for a copy of the GNU General Public License

from gimpfu import *
import os

gettext.install("gimp20-python", gimp.locale_directory, unicode=True)

def python_sprite_gutter_add(img, tdrawable, padding=1, spacing=0, tile_width=32, tile_height=32, \
        resize=1, gutter=False, padding_edge=True, spacing_edge=False, preserve_undo=True):
    
    old_width = img.width
    old_height = img.height
    
    tile_width = int(tile_width)
    tile_height = int(tile_height)
    padding = int(padding)
    spacing = int(spacing)
    
    if img.width>0 and img.height>0 and tile_width>0 and tile_height>0 and (padding>0 or spacing>0):
        
        if (old_width%tile_width)!=0 or (old_height%tile_height)!=0:
            pdb.gimp_message("Image dimensions are not multiples of tile dimensions. Extra area will be lost.")
        
        columns = old_width / tile_width
        rows = old_height / tile_height
        
        # Ignore areas that don't fit within tiles
        old_width = columns*tile_width
        old_height = rows*tile_height
        
        new_width = columns * (tile_width + padding*2 + spacing) - spacing
        new_height = rows * (tile_height + padding*2 + spacing) - spacing
        
        if spacing_edge==True:
            # Place spacing along image edges
            new_width += spacing*2
            new_height += spacing*2
        
        if padding_edge==False:
            # Don't place padding along image edges
            new_width -= padding*2
            new_height -= padding*2
        
        if resize == 1: # Multiple of four
            new_width = (new_width + 3) & ~0x03
            new_height = (new_height + 3) & ~0x03
        elif resize == 2: # Power of two
            new_width-=1
            new_width |= new_width >> 1
            new_width |= new_width >> 2
            new_width |= new_width >> 4
            new_width |= new_width >> 8
            new_width |= new_width >> 16
            new_width+=1
            
            new_height-=1
            new_height |= new_height >> 1
            new_height |= new_height >> 2
            new_height |= new_height >> 4
            new_height |= new_height >> 8
            new_height |= new_height >> 16
            new_height+=1
        
        if preserve_undo:
            # Start undo group
            pdb.gimp_image_undo_group_start(img)
        else:
            # Don't track specific undo history for this next section
            pdb.gimp_image_undo_disable(img)
        
        # Make sure feather isn't enabled
        pdb.gimp_context_set_feather(FALSE)
        
        # We use the active layer as the source layer
        source_layer = img.active_layer
        
        # Resize the image to fit the new padding
        img.resize(new_width, new_height,0,0)
        
        # Work on a new layer placed above active layer
        dest_layer = pdb.gimp_layer_copy(source_layer, True)
        pdb.gimp_image_insert_layer(img, dest_layer, None, -1)
        pdb.gimp_layer_resize_to_image_size(dest_layer)
        dest_layer.fill(TRANSPARENT_FILL) 

        # Space out rows
        for row in range(rows-1,-1,-1):
        
            # Copy original row from source layer
            pdb.gimp_image_select_rectangle(img, 2, 0, (row*tile_height), old_width, tile_height)
            success = pdb.gimp_edit_copy(source_layer)
            
            # Determine destination position (y-value)
            pos = (row*(tile_height + padding*2 + spacing))
            if padding_edge:
                pos+=padding
            if spacing_edge:
                pos+=spacing
            
            # Paste in destination
            pdb.gimp_image_select_rectangle(img, 2, 0, pos, old_width, tile_height)
            floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
            pdb.gimp_floating_sel_anchor(floating_sel)
            
            # Add gutter if requested
            if gutter==True:
            
                # Top edge gutter
                if row>0 or padding_edge:
                    # Copy the top edge of the row
                    pdb.gimp_image_select_rectangle(img, 2, 0, pos, old_width, 1)
                    success = pdb.gimp_edit_copy(dest_layer)
                    
                    # Duplicate the top edge based on the amount of gutter padding
                    for offset in range(1, padding+1):
                        pdb.gimp_image_select_rectangle(img, 2, 0, pos-offset, old_width, 1)
                        floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
                        pdb.gimp_floating_sel_anchor(floating_sel)
                
                # Bottom edge gutter
                if row<rows-1 or padding_edge:
                    # Copy the bottom edge of the row
                    pdb.gimp_image_select_rectangle(img, 2, 0, pos+tile_height-1, old_width, 1)
                    success = pdb.gimp_edit_copy(dest_layer)
                    
                    # Duplicate the bottom edge based on the amount of gutter padding
                    for offset in range(1, padding+1):
                        pdb.gimp_image_select_rectangle(img, 2, 0, pos+tile_height-1+offset, old_width, 1)
                        floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
                        pdb.gimp_floating_sel_anchor(floating_sel)
                
        
        # Space out columns
        for col in range(columns-1,-1,-1):
        
            # Cut column from destination layer
            pdb.gimp_image_select_rectangle(img, 2, (col*tile_width), 0, tile_width, new_height)
            success = pdb.gimp_edit_cut(dest_layer)
            
            # Determine destination position (x-value)
            pos = (col*(tile_width + padding*2 + spacing))
            if padding_edge:
                pos+=padding
            if spacing_edge:
                pos+=spacing
                
            # Paste in destination
            pdb.gimp_image_select_rectangle(img, 2, pos, 0, tile_width, new_height)
            floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
            pdb.gimp_floating_sel_anchor(floating_sel)
            
            # Add gutter if requested
            if gutter==True:
            
                # Left edge gutter
                if col>0 or padding_edge:
                    # Copy the left edge of the row
                    pdb.gimp_image_select_rectangle(img, 2, pos, 0, 1, new_height)
                    success = pdb.gimp_edit_copy(dest_layer)
                    
                    # Duplicate the left edge based on the amount of gutter padding
                    for offset in range(1, padding+1):
                        pdb.gimp_image_select_rectangle(img, 2, pos-offset, 0, 1, new_height)
                        floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
                        pdb.gimp_floating_sel_anchor(floating_sel)
                        
                # Right edge gutter
                if col<columns-1 or padding_edge:
                    # Copy the right edge of the row
                    pdb.gimp_image_select_rectangle(img, 2, pos+tile_width-1, 0, 1, new_height)
                    success = pdb.gimp_edit_copy(dest_layer)
                    
                    # Duplicate the right edge based on the amount of gutter padding
                    for offset in range(1, padding+1):
                        pdb.gimp_image_select_rectangle(img, 2, pos+tile_width-1+offset, 0, 1, new_height)
                        floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
                        pdb.gimp_floating_sel_anchor(floating_sel)
        
        # Hide the old layer
        source_layer.visible = False
        
        if preserve_undo:
            # End undo group
            pdb.gimp_image_undo_group_end(img)
        else:
            # Re-enable undo history
            pdb.gimp_image_undo_enable(img)

register(
    proc_name=("python_fu_sprite_gutter_add"),
    blurb=("Adds padding, spacing, and/or a gutter to a 2D Spritesheet. \n\
A gutter is padding that is filled with a tile's edge pixels, allowing seamless tiles to interpolate correctly in a 3D rendering environment. \n\
Padding is applied on all four sides of each tile. \n\
Spacing is applied between each tile. \n\
Disable undo history to improve performance."),
    help=("Takes heavily-packed spritesheet and adds padding between each tile. Optionally adds gutter buffer for interpolation."),
    author=("The Visible Man"),
    copyright=("GPLv3, David 'The Visible Man' Braun"),
    date=("2012"),
    label=("Add Gutter"),
    imagetypes=("*"),
    params=[
        (PF_IMAGE, "img", "Image", None),
        (PF_DRAWABLE, "tdrawable", "Drawable", None),
        (PF_SPINNER, "padding", "Padding:", 1, (0, 32, 1)),
        (PF_SPINNER, "spacing", "Spacing:", 0, (0, 32, 1)),
        (PF_SPINNER, "tile_width", "Tile Width:", 32, (1, 1024, 1)),
        (PF_SPINNER, "tile_height", "Tile Height:", 32, (1, 1024, 1)),
        (PF_OPTION, "resize", "Resize:", 1, ["Minimum", "Multiple of four", "Power of two"]),
        (PF_TOGGLE, "gutter", "Generate Gutter:", False),
        (PF_TOGGLE, "padding_edge", "Padding at image edge:", True),
        (PF_TOGGLE, "spacing_edge", "Spacing at image edge:", False),
        (PF_TOGGLE, "preserve_undo", "Preserve Undo History:", True),
    ],
    results=[],
    function=(python_sprite_gutter_add),
    menu=("<Image>/Filters/Sprite Sheet"),
    domain=("gimp20-python", gimp.locale_directory),
)

main()
