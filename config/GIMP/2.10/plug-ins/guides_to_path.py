#!/usr/bin/env python

# Guides_to_path Rel 1
# Created by Tin Tran
# Comments directed to http://gimpchat.com or http://gimpscripts.com
#
# License: GPLv3
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY# without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# To view a copy of the GNU General Public License
# visit: http://www.gnu.org/licenses/gpl.html
#
#
# ------------
#| Change Log |
# ------------
# Rel 1: Initial release. Jump over to python for easy access to sort functions to do intersecting paths to compose a path that respresents selected area with guides.

import math
import string
#import Image
from gimpfu import *
from array import array
def newline(x1,y1,x2,y2):
	return [x1,y1,x1,y1,x1,y1,x2,y2,x2,y2,x2,y2];
def python_guides_to_path(image, layer) :
	pdb.gimp_image_undo_group_start(image)

	#grab selection bounding box values
	selection = pdb.gimp_selection_bounds(image);

	x1 = selection[1];
	y1 = selection[2];
	x2 = selection[3];
	y2 = selection[4];

	#grab all guides-ids into array guides
	guides = []
	next_guide = 0;
	next_guide = pdb.gimp_image_find_next_guide(image,next_guide);
	while next_guide != 0:
		guides.append(next_guide);
		next_guide = pdb.gimp_image_find_next_guide(image,next_guide);

	vertical_guides = [];
	horizontal_guides = [];
	for guide in guides:
		guide_orientation = pdb.gimp_image_get_guide_orientation(image,guide);
		guide_position = pdb.gimp_image_get_guide_position(image,guide);
		if guide_orientation == 1: #vertical guide
			if (guide_position >= x1) and (guide_position <= x2): #if it's within the selected x-range
				vertical_guides.append(guide_position);
		else: #horizontal guide
			if (guide_position >= y1) and (guide_position <= y2): #if it's within the selected y-range
				horizontal_guides.append(guide_position);


	#adds a new path
	if (len(vertical_guides) > 0) or (len(horizontal_guides) > 0): #if there is at least one guide defined we create a path
		new_vectors = pdb.gimp_vectors_new(image,"guides vectors");
		pdb.gimp_image_insert_vectors(image,new_vectors,None,-1);
		#pdb.gimp_vectors_stroke_new_from_points(new_vectors,0,12,newline(0,0,50,50),0);
		all_vertical_points = sorted(set(vertical_guides + [x1,x2]));
		all_horizontal_points = sorted(set(horizontal_guides + [y1,y2]));

		#draw vertical lines
		for ix in range(0,len(vertical_guides)):
			for iy in range(0,len(all_horizontal_points)-1):
				pdb.gimp_vectors_stroke_new_from_points(new_vectors,0,12,newline(vertical_guides[ix],all_horizontal_points[iy],vertical_guides[ix],all_horizontal_points[iy+1]),0);

		#draw horizontal lines
		for iy in range(0,len(horizontal_guides)):
			for ix in range(0,len(all_vertical_points)-1):
				pdb.gimp_vectors_stroke_new_from_points(new_vectors,0,12,newline(all_vertical_points[ix],horizontal_guides[iy],all_vertical_points[ix+1],horizontal_guides[iy]),0);

		pdb.gimp_item_set_visible(new_vectors,1);

	pdb.gimp_message("done");

	pdb.gimp_image_undo_group_end(image)
	pdb.gimp_displays_flush()
    #return

register(
    "python_fu_guides_to_path",
    "Guides To Path",
    "Guides To Path of composing sections that look like the guides (selected area)",
    "Tin Tran",
    "Tin Tran",
    "2014",
    "<Image>/Image/Guides/Guides To Path",
    "RGB*, GRAY*",      # Create a new image, don't work on an existing one
    [
	#(PF_COLOR, "black",  "Black point color",  (0,0,0) ),
	#(PF_COLOR, "white",  "White point color",  (255,255,255) ),
	#(PF_COLOR, "gray",  "Gray point color",  (128,128,128) )
	#(PF_FILE, "infilename", "Temp Filepath", "/Default/Path")
	#(PF_DIRNAME, "source_directory", "Source Directory", "") for some reason, on my computer when i(Tin) use PF_DIRNAME the pythonw.exe would crash
	],
    [],
    python_guides_to_path)

main()
