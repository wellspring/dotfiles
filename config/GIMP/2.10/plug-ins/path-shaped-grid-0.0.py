#!/usr/bin/env python
# -*- coding: utf-8 -*-

# GIMP plugin to generate a grid-shaped path
# (c) Ofnuts 2014
#
#   History:
#
#   v0.0: 2014-04-26 first published version
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.



import os, sys

from gimpfu import *

directionNames=['Horizontal','Vertical']
shapeNames=['Hexagonal','Rhombic', 'Triangular','Square', 'Diamond']
SHAPE_HEXAGON=0
SHAPE_RHOMBUS=1
SHAPE_TRIANGLE=2
SHAPE_SQUARE=3
SHAPE_DIAMOND=4

# Arrays describing the spokes to generate each shape. The end of the spokes are given as
# a pair ot dx/dy deltas from the reference point. Each delta is the dot product of the 
# (direct,transverse) sizes with a pair of coefficients, so a spoke is described by the 
# tuple of tuples;
# ((directX,transverseX),(directY,transverseY))

SPOKES_HEXAGON_HORIZONTAL=   [((+1.,0.),(0., 0.)),
                              ((-.5,0.),(0.,-1.)),
                              ((-.5,0.),(0.,+1.))]
SPOKES_HEXAGON_VERTICAL =    [((0., 0.),(+1.,0.)),
                              ((0.,-1.),(-.5,0.)),
                              ((0.,+1.),(-.5,0.))]

SPOKES_RHOMBUS_HORIZONTAL =  [((+1.,0.),(0., 0.)),
                              ((+.5,0.),(0.,+1.)),
                              ((-.5,0.),(0.,+1.)),
                              ((-1.,0.),(0., 0.)),
                              ((-.5,0.),(0.,-1.)),
                              ((+.5,0.),(0.,-1.))]
SPOKES_RHOMBUS_VERTICAL =    [((0., 0.),(+1.,0.)),
                              ((0.,+1.),(+.5,0.)),
                              ((0.,+1.),(-.5,0.)),
                              ((0., 0.),(-1.,0.)),
                              ((0.,-1.),(-.5,0.)),
                              ((0.,-1.),(+.5,0.))]
                              
SPOKES_TRIANGLE_HORIZONTAL = [((+1.,0.),(0., 0.)),
                              ((+.5,0.),(0.,+1.)),
                              ((-.5,0.),(0.,+1.))]
SPOKES_TRIANGLE_VERTICAL =   [((0., 0.),(+1.,0.)),
                              ((0.,+1.),(+.5,0.)),
                              ((0.,+1.),(-.5,0.))]

SPOKES_SQUARE_HORIZONTAL =   [((+1.,0.),(0., 0.)),
                              (( 0.,0.),(0.,+1.)),
                              ((-1.,0.),(0., 0.)),
                              (( 0.,0.),(0.,-1.))]
SPOKES_SQUARE_VERTICAL =     [((0., 0.),(+1.,0.)),
                              ((0.,+1.),( 0.,0.)),
                              ((0., 0.),(-1.,0.)),
                              ((0.,-1.),( 0.,0.))]

SPOKES_DIAMOND_HORIZONTAL =  [((+.25,0.),(0.,+.25)),
                              ((-.25,0.),(0.,+.25)),
                              ((-.25,0.),(0.,-.25)),
                              ((+.25,0.),(0.,-.25))]
SPOKES_DIAMOND_VERTICAL =     SPOKES_DIAMOND_HORIZONTAL

SPOKES=[
		[SPOKES_HEXAGON_HORIZONTAL,SPOKES_HEXAGON_VERTICAL],
		[SPOKES_RHOMBUS_HORIZONTAL,SPOKES_RHOMBUS_VERTICAL],
		[SPOKES_TRIANGLE_HORIZONTAL,SPOKES_TRIANGLE_VERTICAL],
		[SPOKES_SQUARE_HORIZONTAL,SPOKES_SQUARE_VERTICAL],
		[SPOKES_DIAMOND_HORIZONTAL,SPOKES_DIAMOND_VERTICAL]
	]
	
TRANSVERSE_HEXAGON=math.cos(math.pi/6)
TRANSVERSE_RHOMBUS=math.cos(math.pi/6)
TRANSVERSE_TRIANGLE=math.cos(math.pi/6)
TRANSVERSE_SQUARE=1.
TRANSVERSE_DIAMOND=1.

TRANSVERSE_FACTOR = [TRANSVERSE_HEXAGON,TRANSVERSE_RHOMBUS,TRANSVERSE_TRIANGLE,TRANSVERSE_SQUARE,TRANSVERSE_DIAMOND]


# Arrays describing the spacings as coeffients to apply to the direct and transverse sizes

SPACING_HEXAGON_HORIZONTAL =((3.,0.),(0.,2.))
SPACING_HEXAGON_VERTICAL   =((0.,2.),(3.,0.))
SPACING_RHOMBUS_HORIZONTAL =SPACING_HEXAGON_HORIZONTAL
SPACING_RHOMBUS_VERTICAL   =SPACING_HEXAGON_VERTICAL
SPACING_TRIANGLE_HORIZONTAL=((1.,0.),(0.,2.))
SPACING_TRIANGLE_VERTICAL  =((0.,2.),(1.,0.))
SPACING_SQUARE_HORIZONTAL  =((2.,0.),(0.,2.))
SPACING_SQUARE_VERTICAL    =((0.,2.),(2.,0.))
SPACING_DIAMOND_HORIZONTAL =((1.,0.),(0.,1.))
SPACING_DIAMOND_VERTICAL   =((0.,1.),(1.,0.))

SPACINGS=[
		[SPACING_HEXAGON_HORIZONTAL,SPACING_HEXAGON_VERTICAL],
		[SPACING_RHOMBUS_HORIZONTAL,SPACING_RHOMBUS_VERTICAL],
		[SPACING_TRIANGLE_HORIZONTAL,SPACING_TRIANGLE_VERTICAL],
		[SPACING_SQUARE_HORIZONTAL,SPACING_SQUARE_VERTICAL],
		[SPACING_DIAMOND_HORIZONTAL,SPACING_DIAMOND_VERTICAL]
	]

def spacings(direct,transverse,shape,direction):
	xCoeffs,yCoeffs=SPACINGS[shape][direction]
	dx,tx=xCoeffs
	spacingX=direct*dx+transverse*tx
	dy,ty=yCoeffs
	spacingY=direct*dy+transverse*ty
	return (spacingX,spacingY)
	
#def strokePoints(x1,y1,x2,y2):
#	return [x1,y1]*3+[x2,y2]*3
	
def strokePointsFromOffsets(x,y,offsets1,offsets2):
	dx1,dy1=offsets1
	dx2,dy2=offsets2
	return [x+dx1,y+dy1]*3+[x+dx2,y+dy2]*3

def coordAt(c1,c2,r):
	return c1+(c2-c1)*r/100.
	
def pointAt(p1,p2,r):
	x1,y1=p1
	x2,y2=p2
	return (coordAt(x1,x2,r),coordAt(y1,y2,r))

def segmentIn(p1,p2,r1,r2):
	return (pointAt(p1,p2,r1),pointAt(p1,p2,r2))

def spokesFromSizes(coeffs,direct,transverse,r1,r2):
	spokes=[]
	for coeff in coeffs:
		xCoeffs,yCoeffs=coeff
		dx,tx=xCoeffs
		x=direct*dx+transverse*tx
		dy,ty=yCoeffs
		y=direct*dy+transverse*ty
		spokes.append(segmentIn((0.,0.),(x,y),r1,r2))
	return spokes

def floatRangeThrough(start,stop,step,anchor):
	''' 
	Generates the set of values separated by "step"
	- that completely include the start-stop range 
	- that include "anchor" as one of the values
	'''
	min=int((start-anchor)/step)-1
	max=2+int((stop-anchor)/step)
	for i in range(min,max):
		yield anchor+step*i	

			
class ShapedGridPathRenderer(object):
	'''
	The hexagons are created by generating 3 spokes at 120° intervals around strategic points.
	In the horizontal/vertical grids one of these spokes is horizontal/vertical.
	These points are generated in two interleaved grids, that are generated one after another. 
	
	Triangles are generated the same way, with 6 spokes at 60° intervals
	
	Rectangles are generated the same way, with 4 spokes at 90° intervals. The difference between horizontal
	and vertical rectangles is which sides are considered direct and which are transverse
	'''
	def __init__(self,image,shape,size,aspectRatio,direction,anchorX,anchorY,partialStart,partialEnd,integer,single):
		self.image=image
		self.shape=shape
		self.direction=direction
		aspectRatio=math.pow(10.,aspectRatio/100.)
		transverseSize=size*aspectRatio*TRANSVERSE_FACTOR[shape]
		if integer:
			size=round(size)
			transverseSize=round(transverseSize)
		self.spacingX,self.spacingY=spacings(size,transverseSize,shape,direction)

		self.spokeEnds=spokesFromSizes(SPOKES[self.shape][self.direction],size,transverseSize,partialStart,partialEnd)
		self.anchorX=anchorX
		self.anchorY=anchorY
		self.partialStart=partialStart
		self.partialEnd=partialEnd	
		self.single=single
		
		self.spokeStrokes=[[] for i in range(len(SPOKES[shape][direction]))]
		
		self.description='%s,%s grid %3.1fx%3.1f (AR:%3.2f, segment: %d%%->%d%%, anchor: %3.1f,%3.1f)' % (shapeNames[self.shape],directionNames[self.direction],self.spacingX,self.spacingY,aspectRatio,int(partialStart),int(partialEnd),self.anchorX,self.anchorY)	
	
	def createSpokes(self,x,y):
#		print 'Creating spokes at %3.1f,%3.1f' % (x,y)
		for i,sp in enumerate(self.spokeEnds):
			points=strokePointsFromOffsets(x,y,*sp)
			self.spokeStrokes[i].append(points)
		
	def generateGrid(self,anchorOffsetX,anchorOffsetY):
		for y in floatRangeThrough(0,self.image.height,self.spacingY,self.anchorY+anchorOffsetY):
			for x in floatRangeThrough(0,self.image.width,self.spacingX,self.anchorX+anchorOffsetX):
				self.createSpokes(x,y)
		
	def run(self):
		self.generateGrid(0,0);	
		self.generateGrid(self.spacingX/2,self.spacingY/2);			
		if self.single:
			self.path=pdb.gimp_vectors_new(self.image, self.description)
			for spokeGroup in self.spokeStrokes:
				for points in spokeGroup:
					pdb.gimp_vectors_stroke_new_from_points(self.path,0, len(points),points,False)
			pdb.gimp_image_add_vectors(self.image, self.path, 0)
			self.path.visible=True	
		else:
			for sg,spokeGroup in enumerate(self.spokeStrokes):
				self.path=pdb.gimp_vectors_new(self.image, '%s[%d]' % (self.description,sg+1))
				for points in spokeGroup:
					pdb.gimp_vectors_stroke_new_from_points(self.path,0, len(points),points,False)
				pdb.gimp_image_add_vectors(self.image, self.path, 0)
				self.path.visible=True	

def shapedGridPath(image,shape,size,aspectRatio,direction,anchorX,anchorY,partialStart,partialEnd,integer,single):
	pdb.gimp_image_undo_group_start(image)
	try:
		ShapedGridPathRenderer(image,shape,size,aspectRatio,direction,anchorX,anchorY,partialStart,partialEnd,integer,single).run()

        except Exception as e:
		print e.args[0]
		pdb.gimp_message(e.args[0])

	pdb.gimp_image_undo_group_end(image)
	pdb.gimp_displays_flush()
	return;

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])


register(
	'path-shaped-grid',
	N_('Generate shaped grid path'+whoiam),
	'Generate shaped grid path',
	'Ofnuts',
	'Ofnuts',
	'2014',
	'Shape grid...',
	'*',
	[
		(PF_IMAGE,   'image',       'Input image',             None),
		(PF_OPTION,  'shape',       'Shape',                   0,shapeNames),
		(PF_FLOAT,   'size',        'Size',                    50.),
		(PF_SPINNER, 'aspectRatio', 'Aspect Ratio',            0, (-100,100,1)),
		(PF_OPTION,  'direction',   'Direction',               0,directionNames),
		(PF_FLOAT,   'anchorX',     'Anchor X',                0.),
		(PF_FLOAT,   'anchorY',     'Anchor Y',                0.),
		(PF_SPINNER, 'partialStart','Partial start',           0, (-100,200,1)),
		(PF_SPINNER, 'partialEnd',  'Partial end',             100, (-100,200,1)),
		(PF_TOGGLE,  'integer',     'Round to integer pixels', False),
		(PF_TOGGLE,  'single',      'Single path',             True)
	],
	[],
	shapedGridPath,
	menu='<Image>/Filters/Render/Paths',
)


main()
