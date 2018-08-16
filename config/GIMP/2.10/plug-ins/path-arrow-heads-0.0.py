#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to add arrow heads to path strokes
# (c) Ofnuts 2011
#
#   History:
#
#   v0.0: 2012-01-09 first published version
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

AXIS_TANGENT=0
AXIS_BEST=1
AXIS_NAMES=["Tangent","Best fit"]

SIDE_START=0
SIDE_END=1
SIDE_BOTH=2
SIDE_NAMES=["Start","End","Both"]

class ArrowHeadAdder(object):
	arrowWingSize = 0
	arrowWingAngle = 0
	closeArrowHead = False
	angle = 0
	arrowHeadAxis = 0
	sides = 0
	arrowHeadAtStart=False
	arrowHeadAtEnd=False
	image=None
	sourcePath=None
	
	def __init__(self, image, path, size, angle, sides, close, axis):
		self.image = image
		self.sourcePath = path
		self.arrowWingSize = size
		self.angle = angle # kept for display
		self.arrowWingAngle = (angle / 180) * math.pi
		self.sides = sides # kept for display
		if sides == SIDE_START or sides == SIDE_BOTH:
			self.arrowHeadAtStart = True
		if sides == SIDE_END or sides == SIDE_BOTH:
			self.arrowHeadAtEnd = True
		self.closeArrowHead = close
		self.arrowHeadAxis = axis
		
	def __str__(self):
		return '%d, %d, %s, "%s, %s"' % (self.arrowWingSize, self.angle, SIDE_NAMES[self.sides], AXIS_NAMES[self.arrowHeadAxis], self.closeArrowHead)
		
	def generatePathWithArrowsHeads(self):
		arrowHeadsPath=pdb.gimp_vectors_new(self.image, 'Arrow heads(%s) for %s' % (self,self.sourcePath.name))
		pdb.gimp_image_add_vectors(self.image, arrowHeadsPath, 0)

		for stroke in self.sourcePath.strokes:
			points,closed=stroke.points
			if not closed:
				self.addArrowHeads(arrowHeadsPath,points)
		arrowHeadsPath.visible = True
	
	def addArrowHeads(self,arrowHeadsPath,points):
		if self.arrowHeadAtStart:
			endPoints=self.getHeadDataAtStart(points)
			headStrokePoints=self.generateHeadStroke(endPoints)
			self.addArrowHead(arrowHeadsPath,headStrokePoints)
			
		if self.arrowHeadAtEnd:
			endPoints=self.getHeadDataAtEnd(points)
			headStrokePoints=self.generateHeadStroke(endPoints)
			self.addArrowHead(arrowHeadsPath,headStrokePoints)
	
	def addArrowHead(self,arrowHeadsPath,headPoints):
			sid = pdb.gimp_vectors_stroke_new_from_points(arrowHeadsPath,0, len(headPoints), headPoints, self.closeArrowHead)

	def generateHeadStroke(self,endPoints):
		arrowTip = endPoints[0:2]
		tangentPoint = self.tangentReferencePoint(endPoints)
		# Arrow wings start from the tip, towards the tangent anchor
		tangentAngle = self.segmentAngle(arrowTip,tangentPoint)
		
		wingTip1 = self.pointAtAngleDistance(arrowTip, tangentAngle + self.arrowWingAngle, self.arrowWingSize)
		wingTip2 = self.pointAtAngleDistance(arrowTip, tangentAngle - self.arrowWingAngle, self.arrowWingSize)
		# Since the arrow head is all straight lines we merely triplicate the points
		strokePoints=wingTip1*3 + arrowTip*3 + wingTip2*3
		return strokePoints
		
	def tangentReferencePoint(self,endPoints):
		if self.arrowHeadAxis == AXIS_TANGENT:
			return self.trueTangentPoint(endPoints)
		else: # self.arrowHeadAxis == AXIS_BEST
			return self.bestFitPoint(endPoints)
		
	# The points of interest:
	# - the ending point
	# - its tangent handle towards next/previous anchor point
	# - the tangent handle from next/previous point to ending point
	# - the next previous anchor point
	def getHeadDataAtStart(self,points):
		return points[2:10]
		
	def getHeadDataAtEnd(self,points):
		return self.reversePoints(points[-10:-2])
		
	def reversePoints(self,points):
		reversed=[]
		for i in range(len(points)-2,-1,-2):
			reversed.append(points[i])
			reversed.append(points[i+1])
		return reversed

	# Tangent determination. The pure tangent is given by:
	# - the tangent handle for this anchor point, if it exists
	# - the tangent handle at the next/revious anchor point, if it exists
	# - the next/previous anchor point
	# However since missing handles use the coordinate of the anchor, the 
	# third case is the same as the 2nd.
	def trueTangentPoint(self,points):
		if points[2:4] == points[0:2]:
			return points[4:6]
		else:
			return points[2:4]	
	
	# Rough calculation to find where the curve enters the visual triangle 
	# created by the wings. The length isn't accurate, and nothing says that
	# pointAt(t) is actually at length*t. But it seems good enough.
	def bestFitPoint(self,points):
		curveLength = self.approximateBezierLength(points)
		t = self.arrowWingSize * math.cos(self.arrowWingAngle) / curveLength
		bestFitPoint = self.bezierPointAt(points, t)
		return bestFitPoint

	# Calculation of the corrdinates of a point on the curve. The computation
	# here is a literal equivalent to the geometric construction. The canonical
	# formula could be faster but less fun to write :)
	def bezierPointAt(self, points, t):
		# First order points
		m11 = self.pointAt(points[0:2], points[2:4], t)
		m12 = self.pointAt(points[2:4], points[4:6], t)
		m13 = self.pointAt(points[4:6], points[6:8], t)
		# Second order points
		m21 = self.pointAt(m11, m12, t)
		m22 = self.pointAt(m12, m13, t)
		#Final point
		mp = self.pointAt(m21, m22, t)
		return mp
	
	def pointAt(self,p1,p2,t):
		x=p1[0]*(1-t) + p2[0]*t
		y=p1[1]*(1-t) + p2[1]*t 
		return [x,y]
		
	# Very approximate length of a Bezier curve, taken as the average of the direct
	# distance between anchors and the envelope (anchor->handle->handle->anchor) length.
	# A few tests show it is accurate to about 5% for "reasonable" curves.
	def approximateBezierLength(self,points):
		direct = self.distance(points[0:2], points[6:8])
		envelope1 = self.distance(points[0:2], points[2:4])
		envelope2 = self.distance(points[2:4], points[4:6])
		envelope3 = self.distance(points[4:6], points[6:8])
		envelope = envelope1 + envelope2 + envelope3
		approximateLength = (direct + envelope) / 2
		return approximateLength
	
	def distance(self,p1,p2):
		return math.sqrt((p1[0]-p2[0]) ** 2 + (p1[1]-p2[1]) ** 2)


	def printPoint(self, name, xy):
		print '%s: %3.2f,%3.2f' % (name, xy[0], xy[1])

	def segmentAngle(self,fromPoint,toPoint):
		dX = toPoint[0] - fromPoint[0]
		dY = toPoint[1] - fromPoint[1]
		
		if math.fabs(dX) < .001:
			theta = math.copysign(math.pi/2, dY)
		else:
			theta = math.atan(dY / dX)
			if dX < 0:
				theta = theta + math.pi
		return theta % (math.pi*2)

	# Computes point at signed distance and given oriented angle
	def pointAtAngleDistance(self,origin,alpha,distance):
		deltaX = distance*math.cos(alpha)
		deltaY = distance*math.sin(alpha)
		x = origin[0] + deltaX
		y = origin[1] + deltaY
		return [x,y]

def arrowHeads(image, sourcePath, size, angle, sides, close, axis):
	try:
		arrowHeadAdder = ArrowHeadAdder(image, sourcePath, size, angle, sides, close, axis)
		arrowHeadAdder.generatePathWithArrowsHeads()
        except Exception as e:
		print e.args[0]
		pdb.gimp_message(e.args[0])

	pdb.gimp_displays_flush()
	return;

### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])

register(
	"arrow-heads",
	N_("Add arrow heads..."+whoiam),
	"Add arrow heads",
	"Ofnuts",
	"Ofnuts",
	"2011",
	N_("Arrow heads..."),
	"RGB*,GRAY*",
	[
		(PF_IMAGE, "image", "Input image", None),
		(PF_VECTORS, "refpath", "Input path", None),
		(PF_SPINNER, "size", "Size:", 20, (1, +200, 1)),	
		(PF_SPINNER, "angle", "Angle:", 20, (1, +60, 1)),	
		(PF_OPTION, "side", "Ends:", SIDE_END, SIDE_NAMES),
		(PF_TOGGLE, "close", "Close:", 0),
		(PF_OPTION, "axis", "Axis:", AXIS_BEST, AXIS_NAMES),
	],
	[],
	arrowHeads,
	menu="<Vectors>/Decorate",
	domain=("gimp20-python", gimp.locale_directory)
)

main()

