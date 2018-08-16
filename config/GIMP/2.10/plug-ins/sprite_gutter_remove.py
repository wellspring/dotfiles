#!/usr/bin/env python
# sprite_gutter_remove
# Version 1.1
# Copyright 2012 David 'The Visible Man' Braun
# GIMP plugin to remove padding/spacing from 2D Spritesheets

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

def python_sprite_gutter_remove(img, tdrawable, padding=1, spacing=0, tile_width=32, tile_height=32, \
        resize=1, padding_edge=True, spacing_edge=False, preserve_undo=True):
    
    old_width = img.width
    old_height = img.height
    
    tile_width = int(tile_width)
    tile_height = int(tile_height)
    padding = int(padding)
    spacing = int(spacing)
    
    if img.width>0 and img.height>0 and tile_width>0 and tile_height>0 and (padding>0 or spacing>0):
        
        new_width = old_width
        new_height = old_height
        
        if spacing_edge:
            # Remove spacing along image edges
            new_width -= spacing*2
            new_height -= spacing*2
        if not padding_edge:
            # Offset edge padding assumption in equation
            new_width += padding*2
            new_height += padding*2
        
        columns = (new_width+spacing) / (tile_width + padding*2 + spacing)
        rows = (new_height+spacing) / (tile_height + padding*2 + spacing)
        
        new_width = columns*tile_width
        new_height = rows*tile_height
        
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
        
        # Work on a new layer placed above active layer
        dest_layer = pdb.gimp_layer_copy(source_layer, True)
        pdb.gimp_image_insert_layer(img, dest_layer, None, -1)
        dest_layer.fill(TRANSPARENT_FILL) 

        # Compress rows
        offset = ((padding_edge and padding) or 0) + ((spacing_edge and spacing) or 0)
        multiplier = (tile_height + padding*2 + spacing)
        right_edge = old_width - offset # Don't want to copy any padding on right edge, or we'd have to go back and clean it
        
        for row in range(rows):
        
            pos = row*multiplier + offset
                
            # Copy original
            pdb.gimp_image_select_rectangle(img, 2, 0, pos, right_edge, tile_height)
            success = pdb.gimp_edit_copy(source_layer)
            
            # Paste in destination
            pdb.gimp_image_select_rectangle(img, 2, 0, (row*tile_height), right_edge, tile_height)
            floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
            pdb.gimp_floating_sel_anchor(floating_sel)
        
        # Compress columns
        multiplier = (tile_width + padding*2 + spacing)
        
        for col in range(columns):
        
            pos = col*multiplier + offset
                
            # Cut from destination
            pdb.gimp_image_select_rectangle(img, 2, pos, 0, tile_width, new_height)
            success = pdb.gimp_edit_cut(dest_layer)
            
            # Paste in destination
            pdb.gimp_image_select_rectangle(img, 2, (col*tile_width), 0, tile_width, new_height)
            if dest_layer.has_alpha:
                pdb.gimp_edit_clear(dest_layer) # Prevent spacing between columns from affecting tiles
            floating_sel = pdb.gimp_edit_paste(dest_layer, FALSE)
            pdb.gimp_floating_sel_anchor(floating_sel)
        
        # Resize the image to fit the new dimensions
        img.resize(new_width, new_height,0,0)
        
        #Resize our resulting layer
        pdb.gimp_layer_resize_to_image_size(dest_layer)
        
        # Hide the old layer
        source_layer.visible = False
        
        if preserve_undo:
            # End undo group
            pdb.gimp_image_undo_group_end(img)
        else:
            # Re-enable undo history
            pdb.gimp_image_undo_enable(img)

register(
    proc_name=("python_fu_sprite_gutter_remove"),
    blurb=("Removes padding and spacing from a 2D Spritesheet. \n\
Padding is applied on all four sides of each tile. \n\
Spacing is applied between each tile. \n\
Disable undo history to improve performance."),
    help=("Removes padding/gutter from spritesheets"),
    author=("The Visible Man"),
    copyright=("GPLv3, David 'The Visible Man' Braun"),
    date=("2012"),
    label=("Remove Gutter"),
    imagetypes=("*"),
    params=[
        (PF_IMAGE, "img", "Image", None),
        (PF_DRAWABLE, "tdrawable", "Drawable", None),
        (PF_SPINNER, "padding", "Padding:", 1, (0, 32, 1)),
        (PF_SPINNER, "spacing", "Spacing:", 0, (0, 32, 1)),
        (PF_SPINNER, "tile_width", "Tile Width:", 32, (1, 1024, 1)),
        (PF_SPINNER, "tile_height", "Tile Height:", 32, (1, 1024, 1)),
        (PF_OPTION, "resize", "Resize:", 1, ["Minimum", "Multiple of four", "Power of two"]),
        (PF_TOGGLE, "padding_edge", "Padding at image edge:", True),
        (PF_TOGGLE, "spacing_edge", "Spacing at image edge:", False),
        (PF_TOGGLE, "preserve_undo", "Preserve Undo History:", True),
    ],
    results=[],
    function=(python_sprite_gutter_remove),
    menu=("<Image>/Filters/Sprite Sheet"),
    domain=("gimp20-python", gimp.locale_directory),
)

main()
