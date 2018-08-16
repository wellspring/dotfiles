#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin replicate a layer on a path
# (c) J.F.Garcia 2013 www.arakne.es

# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA.
# 2014-02-16

import os, sys

from gimpfu import *

p=os.path.dirname(sys.argv[0]) + os.sep +'locales'
gettext.install("arakne-stitch", p, unicode=True)

def calcRot(x1 , x2 , y1 , y2):
	return math.atan2(y1-y2,x1-x2)

def pLength(x1 , x2 , y1 , y2):
	return math.sqrt(math.pow(x2-x1,2)+math.pow(y2-y1,2))

class cFPath(object):
	def __init__(self, img, path, lay, path2, lay2):
		if len(path.strokes)<1:
			alert(_('Not valid path. No strokes found'))
			return
		if len(path2.strokes)<1:
			alert(_('Not valid path. No strokes found'))
			return
		st = path.strokes[0]
		pts = st.points[0]
		xa1,ya1,xa2,ya2 = (pts[2],pts[3],pts[8],pts[9])
		length1 = pLength(xa1,xa2,ya1,ya2)
		r1 = calcRot(xa1,xa2,ya1,ya2)-math.degrees(90)
		st = path2.strokes[0]
		pts = st.points[0]
		x1, y1, x2, y2 = (pts[2], pts[3], pts[8], pts[9])
		r2 = calcRot(x1, x2, y1, y2) - math.degrees(90)
		rFin = r1-r2
		length2 = pLength(x1,x2,y1,y2)
		scale = length1/length2
		ofs = lay2.offsets
		pdb.gimp_image_undo_group_start(img)
		pdb.gimp_item_transform_scale(lay2, 0, 0, int(lay2.width * scale), int(lay2.height * scale))
		lay2.translate(int(pts[2]-(pts[2]-ofs[0])*scale), int(pts[3]-(pts[3]-ofs[1])*scale))
		pdb.gimp_item_transform_rotate(lay2, rFin, False, int(x1), int(y1))
		lay2.translate(int(xa1-x1),int(ya1-y1))
		pdb.gimp_image_undo_group_end(img)
		pdb.gimp_displays_flush()

def fPath(img, srcPath, lay,path2,lay2):
	try:
		cFPath(img, srcPath,lay,path2,lay2)
        except Exception as e:
		print e.args[0]
		pdb.gimp_message(e.args[0])
	pdb.gimp_displays_flush()
	return;

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])

def alert(msg):
  dlg = gtk.MessageDialog(None, 0, gtk.MESSAGE_ERROR, gtk.BUTTONS_OK, msg)
  dlg.run()
  dlg.hide()

register("stitch-layers3",
	_("Stitch two layers...")+whoiam, _("Stitch layers 3"), "J.F.Garcia", "J.F.Garcia",
	"2014",
	_("Stitch two layers..."),
	"RGB*,GRAY*",
	[
		(PF_IMAGE, "image", "Input image", None),
		(PF_VECTORS, "path", _("Path fixed"), None),
		(PF_LAYER, "layer1", _("Layer fixed"), None),
		(PF_VECTORS, "path2", _("2nd path"), None),
		(PF_LAYER, "layer2", _("2nd layer"), None),
	],
	[],
	fPath,
	menu="<Image>/Filters/Path/",
	domain=("gimp20-python", gimp.locale_directory)
)

main()
