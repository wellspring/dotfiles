#!/usr/bin/env python

from gimpfu import *

GRID_COLUMNS = 12
GRID_COLUMN_WIDTH = 80
GRID_WIDTH = GRID_COLUMNS * GRID_COLUMN_WIDTH

def python_grid(image, draw, guide_1, guide_2):
	image.undo_group_start();
	
	offset_left = (image.width - GRID_WIDTH) / 2
	
	for i in range (GRID_COLUMNS):
		base = offset_left + i * GRID_COLUMN_WIDTH
		image.add_vguide(base)
		image.add_vguide(base + guide_1)
		image.add_vguide(base + guide_2)
	
	image.add_vguide(base + GRID_COLUMN_WIDTH);
	
	image.undo_group_end();
	pass

register(
	"python_fu_grid",
	"Add 960 grid",
	"Add guides according to 960px 12 column grid",
	"Mihail Menshikov", "Mihail Menshikov", "2011",
	"<Image>/Image/Guides/Add 960 grid...",
	None,
	[
		(PF_SLIDER, "guide_1", "Guide 1", 10, (0, GRID_COLUMN_WIDTH, 1)),
		(PF_SLIDER, "guide_2", "Guide 2", 70, (0, GRID_COLUMN_WIDTH, 1))
	],
	[],
	python_grid)

main()
