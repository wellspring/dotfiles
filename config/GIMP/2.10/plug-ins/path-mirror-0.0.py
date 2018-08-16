#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to mirror a path across a vertical or horizontal axis
# (c) Ofnuts 2012
#
#   History:
#
#   v0.0: 2012-01-29 first published version

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



import os, sys

from gimpfu import *


# Like in the Flip tools, only the X coordinate is changed for "horizontal"
# while only the Y one changes for "vertical". Since coordinaates are handled
# as indexable objects, we have the nice property that coordinate(orientation)
# is the only thing to chnage throughout. It also works as an offset of the 
# coordinate from the X one in the stroke points data.

HORIZONTAL=0
VERTICAL=1

ORIENTATIONS=[HORIZONTAL,VERTICAL]
ORIENTATIONS_NAMES=['Horizontal','Vertical']

# Within that coordinate delta points are considered identical
EPSILON=.0001

def mirror(sourcePoints,orientation,axis):
	mirrorPoints=sourcePoints[:]
	for i in range(orientation,len(mirrorPoints),2):
		mirrorPoints[i]=axis+(axis-mirrorPoints[i])
	return mirrorPoints
	
def samePoint(p1,p2):
	return abs(p1[0]-p2[0]) < EPSILON and abs(p1[1]-p2[1]) < EPSILON
	
def sameStart(stroke1,stroke2):
	p1=stroke1[2:4]
	p2=stroke2[2:4]
	same=samePoint(p1,p2)
	#if same:
		#print "Same start detected at [%3.2f,%3.2f]" % (p1[0],p1[1])
	return same
	
def sameEnd(stroke1,stroke2):
	p1=stroke1[-4:-2]
	p2=stroke2[-4:-2]
	same=samePoint(p1,p2)
	#if same:
		#print "Same end detected at [%3.2f,%3.2f]" % (p1[0],p1[1])
	return same

def reverse(points):
	reversed=[]
	for i in range(len(points)-2,-1,-2):
		reversed.extend(points[i:i+2])
	return reversed

def spliceAtStart(source,mirror):
	# initial segment reversed, not including final forward handle
	# mirror segment, not including first backrward handle and first anchor
	segment1=reverse(source)
	segment2=mirror
	final=segment1[:-2]
	final.extend(segment2[4:])
	#print "Splice at start final: %s" % final
	return final

def spliceAtEnd(source,mirror):
	# initial segment not including final forward handle
	# mirror segment reversed, not including first backward handle and first anchor
	segment1=source
	segment2=reverse(mirror)
	final=segment1[:-2]
	final.extend(segment2[4:])
	#print "Splice at end final: %s" % final
	return final

def spliceBothEnds(source,mirror):
	#print "Splice both ends source/mirror: %s --/-- %s" % (source,mirror)
	# initial segment not including final forward handle, but with backward handle
	# of first point replaced from same in final triplet of segment2
	# mirror segment reversed, not including first backward handle and first anchor
	# nor final triplet, since we close the stroke
	segment1=source
	segment2=reverse(mirror)
	#print "Splice both ends segments: %s --/-- %s" % (segment1[:-2],segment2[4:-6])
	final=segment1[:-2]
	final[0:2]=segment2[-6:-4]
	final.extend(segment2[4:-6])
	#print "Splice both ends final: %s" % final
	return final

def addStroke(path,merge,sourcePoints,mirrorPoints,closed):
	if not merge: 	# No merge, so just copy the mirror stroke
		pdb.gimp_vectors_stroke_new_from_points(path,0, len(mirrorPoints),mirrorPoints,closed)
	else:
		if closed: # If the stroke is closed we just copy both source and mirror strokes
			pdb.gimp_vectors_stroke_new_from_points(path,0, len(sourcePoints),sourcePoints,closed)
			pdb.gimp_vectors_stroke_new_from_points(path,0, len(mirrorPoints),mirrorPoints,closed)
		else: # this is where we may have to splice the strokes
			commonStart=sameStart(sourcePoints,mirrorPoints)
			commonEnd=sameEnd(sourcePoints,mirrorPoints)
			if commonStart and commonEnd: # makes the mirror "close" the source
				mergedPoints=spliceBothEnds(sourcePoints,mirrorPoints)
				pdb.gimp_vectors_stroke_new_from_points(path,0, len(mergedPoints),mergedPoints,True)
			elif commonStart:
				mergedPoints=spliceAtStart(sourcePoints,mirrorPoints)
				pdb.gimp_vectors_stroke_new_from_points(path,0, len(mergedPoints),mergedPoints,False)
			elif commonEnd:
				mergedPoints=spliceAtEnd(sourcePoints,mirrorPoints)
				pdb.gimp_vectors_stroke_new_from_points(path,0, len(mergedPoints),mergedPoints,False)
			else:
				pdb.gimp_vectors_stroke_new_from_points(path,0, len(sourcePoints),sourcePoints,False)
				pdb.gimp_vectors_stroke_new_from_points(path,0, len(mirrorPoints),mirrorPoints,False)
				
def pathMirror(image,sourcePath,orientation,axis,merge):
	try:
		mirrorPath=pdb.gimp_vectors_new(image, '%s mirrored across %d/%s' % (sourcePath.name,axis,['H','V'][orientation]))
		pdb.gimp_image_add_vectors(image, mirrorPath, 0)

		for sourceStroke in sourcePath.strokes:
			sourcePoints,closed=sourceStroke.points
			mirrorPoints=mirror(sourcePoints,orientation,axis)
			addStroke(mirrorPath,merge,sourcePoints,mirrorPoints,closed)
		mirrorPath.visible=True
        except Exception as e:
		print e.args[0]
		pdb.gimp_message(e.args[0])

	pdb.gimp_displays_flush()
	return;


### Registration


whoiam='\n'+os.path.abspath(sys.argv[0])

register(
	"path-mirror",
	N_("Mirror path..."+whoiam),
	"Mirror path",
	"Ofnuts",
	"Ofnuts",
	"2011",
	N_("Mirror path..."),
	"RGB*,GRAY*",
	[
		(PF_IMAGE, "image", "Input image", None),
		(PF_VECTORS, "refpath", "Input path", None),
		(PF_OPTION, "orientation", "Orientation:", 0, ORIENTATIONS_NAMES),
		(PF_INT, "axis", "Axis", 0),
		(PF_TOGGLE, "merge", "Merge with source", 1),
	],
	[],
	pathMirror,
	menu="<Vectors>/Tools",
	domain=("gimp20-python", gimp.locale_directory)
)

main()
