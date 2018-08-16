#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to generate a grid-shaped path
# (c) Ofnuts 2013
#
#   History:
#
#   v0.0: 2013-04-20 first published version
#   v0.1: 2014-01-25 add entry for Offset & Spacing specification
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



import os, sys

from gimpfu import *

def strokePoints(x1,y1,x2,y2):
	return [x1,y1]*3+[x2,y2]*3
	
def steps(first,last,count):
	step=(last-first)/(count-1.)
#	print 'Step(%3.2f,%3.2f,%d)=%3.2f' % (first,last,count,step)
	return [first+(step*x) for x in range(count-1)]+[last]

class GridPathSelectionRenderer(object):
	def __init__(self,image,linesH,linesV):
		self.image=image
		self.linesH=linesH
		self.linesV=linesV
		
		self.minX=0
		self.maxX=0
		self.minY=0
		self.maxY=0

	def generateVerticalStrokes(self):
		for x in steps(self.minX,self.maxX,self.linesV):
			points=strokePoints(x,self.minY,x,self.maxY)
			pdb.gimp_vectors_stroke_new_from_points(self.path,0, len(points),points,False)
			
	def generateHorizontalStrokes(self):
		for y in steps(self.minY,self.maxY,self.linesH):
			points=strokePoints(self.minX,y,self.maxX,y)
			pdb.gimp_vectors_stroke_new_from_points(self.path,0, len(points),points,False)
	
	def run(self):
		defined,self.minX,self.minY,self.maxX,self.maxY=pdb.gimp_selection_bounds(self.image)
		self.path=pdb.gimp_vectors_new(self.image, 'Grid %d x %d' % (self.linesH,self.linesV))
		pdb.gimp_image_add_vectors(self.image, self.path, 0)
		if self.linesV > 1:
			self.generateVerticalStrokes()
		if self.linesH > 1:
			self.generateHorizontalStrokes()
		self.path.visible=True	
	
class GridPathRenderer(object):
	def __init__(self,image,spacingH,spacingV,offsetH,offsetV):
		self.image=image
		self.spacingH=spacingH
		self.spacingV=spacingV
		self.offsetH=offsetH
		self.offsetV=offsetV
		
		self.minX=0
		self.maxX=image.width
		self.minY=0
		self.maxY=image.height

	def generateVerticalStrokes(self):
		x=self.minX+self.offsetH
		while x<self.maxX: 
			points=strokePoints(x,self.minY,x,self.maxY)
			pdb.gimp_vectors_stroke_new_from_points(self.path,0, len(points),points,False)
			x+=self.spacingH
			
	def generateHorizontalStrokes(self):
		y=self.minY+self.offsetV
		while y<self.maxY: 
			points=strokePoints(self.minX,y,self.maxX,y)
			pdb.gimp_vectors_stroke_new_from_points(self.path,0, len(points),points,False)
			y+=self.spacingV
	def run(self):
		defined,self.minX,self.minY,self.maxX,self.maxY=pdb.gimp_selection_bounds(self.image)
		self.path=pdb.gimp_vectors_new(self.image, 'Grid %3.1fx%3.1f@%3.1f,%3.1f' % (self.spacingH,self.spacingV,self.offsetH,self.offsetV))
		pdb.gimp_image_add_vectors(self.image, self.path, 0)
		if self.spacingH > 0.:
			self.generateVerticalStrokes()
		if self.spacingV > 0:
			self.generateHorizontalStrokes()
		self.path.visible=True	

def gridPathOnSelection(image,linesH,linesV):
	pdb.gimp_image_undo_group_start(image)
	try:
		GridPathSelectionRenderer(image,int(linesH),int(linesV)).run()

        except Exception as e:
		print e.args[0]
		pdb.gimp_message(e.args[0])

	pdb.gimp_image_undo_group_end(image)
	pdb.gimp_displays_flush()
	return;
	
def gridPath(image,spacingH,spacingV,offsetH,offsetV):
	pdb.gimp_image_undo_group_start(image)
	try:
		GridPathRenderer(image,spacingH,spacingV,offsetH,offsetV).run()

        except Exception as e:
		print e.args[0]
		pdb.gimp_message(e.args[0])

	pdb.gimp_image_undo_group_end(image)
	pdb.gimp_displays_flush()
	return;


### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])

register(
	'path-grid-selection',
	N_('Generate rectangular grid path in selection boundaries'+whoiam),
	'Generate rectangular grid path in selection boundaries',
	'Ofnuts',
	'Ofnuts',
	'2011',
	'Rectangular grid path in selection...',
	'*',
	[
		(PF_IMAGE, 'image', 'Input image', None),
		(PF_SPINNER, 'linesH', 'Horizontal lines',20,(0,1000, 1)),
		(PF_SPINNER, 'linesV', 'Vertical lines',20,(0,1000, 1)),
	],
	[],
	gridPathOnSelection,
	menu='<Image>/Filters/Render/Pattern',
)

register(
	'path-grid',
	N_('Generate rectangular grid path with spacing and offset'+whoiam),
	'Generate rectangular grid path with spacing and offset',
	'Ofnuts',
	'Ofnuts',
	'2011',
	'Rectangular grid path...',
	'*',
	[
		(PF_IMAGE, 'image', 'Input image', None),
		(PF_FLOAT, 'spacingH', 'Horizontal spacing',0.),
		(PF_FLOAT, 'spacingV', 'Vertical spacing',0.),
		(PF_FLOAT, 'offsetH', 'Horizontal offset',0.),
		(PF_FLOAT, 'offsetV', 'Vertical offset',0.),
	],
	[],
	gridPath,
	menu='<Image>/Filters/Render/Pattern',
)


main()
