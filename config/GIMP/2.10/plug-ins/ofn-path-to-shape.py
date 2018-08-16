#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to generate shapes using reference points in paths
# (c) Ofnuts 2014-2016
#
#   History:
#
#   v0.0: 2014-02-12 First published version
#   v0.1: 2014-02-15 Add circumcircle, star, double star, rectangle
#                    Harden the code
#   v0.2: 2014-02-18 Add tangents
#   v0.3: 2014-02-22 Add multiply/divide segments
#   v0.4: 2014-02-24 Add Star/Spokes
#   v0.5: 2014-04-28 Add square from diagonal
#   v0.6: 2014-04-28 Refactor, add more "shapes on segments"
#   v1.0: 2016-07-25 Add undo grouping, misc fixes for publication
#   v1.1: 2016-07-27 Fix grammatical error
#   v1.2: 2016-08-29 Add crosshair shape
#   v1.3: 2016-12-25 Fix bug if current path is linked when computing tangents
#                    First shot at Reuleaux polygons
#                    Add rounded polygons
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published
#   by the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This very file is the complete source code to the program.
#
#   If you make and redistribute changes to this code, please mark it
#   in reasonable ways as different from the original version. 
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   The GPL v3 licence is available at: https://www.gnu.org/licenses/gpl-3.0.en.html

from gimpfu import *
import os,sys,math,time

#################################
### Registration and base support
#################################

def protected(function):
    '''
    Create protected version of function
    '''
    def p(*parms):
        image=parms[0]
        pdb.gimp_image_undo_group_start(image)
        try:
            function(*parms)
        except Exception as e:
            print e.args[0]
            pdb.gimp_message(e.args[0])
        pdb.gimp_image_undo_group_end(image)
    return p
        
### Registration data
author='Ofnuts'
year='2016'
imageTypes='*'
menu='<Vectors>/Shapes'
strokesMenu=menu+'/On strokes'
segmentsMenu=menu+'/On segments'
circleMenu=strokesMenu+'/Circle'
starMenu=strokesMenu+'/Star'
polygonMenu=strokesMenu+'/Polygon'
roundedPolygonMenu=strokesMenu+'/Rounded Polygon'
rectangleMenu=strokesMenu+'/Rectangle'
tangentMenu=menu+'/Various/Tangent'
lineMenu=strokesMenu+'/Line'
standardParameters=[(PF_IMAGE,'image','Input image', None),(PF_VECTORS,'path','Input path', None),]
whoiam='\n'+os.path.abspath(sys.argv[0])

def reg(function,atom,description,menuItem,menu,additionalParameters=[]):
    #print '**** Registering %s/%s' % (menu,menuItem)
    register(
    'ofn-'+atom,description+whoiam,menuItem,author,author,year,menuItem,
    imageTypes,standardParameters+additionalParameters,[],
    protected(function),menu=menu
    )

######################
### Geometry functions
######################

def middle(p1,p2):
    x1,y1=p1
    x2,y2=p2
    return ((x1+x2)/2,(y1+y2)/2)

def intermediatePoint(p1,p2,ratio):
    x1,y1=p1
    x2,y2=p2
    return (x1+(x2-x1)*ratio,y1+(y2-y1)*ratio)

def angle(p1,p2):
    x1,y1=p1
    x2,y2=p2
    return math.atan2(y2-y1,x2-x1)
    
def distance(p1,p2):
    x1,y1=p1
    x2,y2=p2
    dx=x2-x1
    dy=y2-y1
    return math.sqrt(dx*dx+dy*dy)

def bisector(p1,p2):
    '''
    Computes the equation of the bisector of a segment, 
    Returns coefficients for equation ax+by=c, suitable for Cramer equation
    '''
    x1,y1=p1
    x2,y2=p2
    xm,ym=middle(p1,p2)
    if x1==x2: # segment is vertical: bisector is horizontal
        return (0,1,ym)
    elif y1==y2: # segment is horizontal: bisector is vertical
        return (1,0,xm)
    else: # general case, y=ax+b or ax-y=-b
        a=(x2-x1)/(y1-y2)
        b=ym-a*xm
        return (a,-1,-b)
        
def intersection(l1,l2):
    '''
    Computes the intersection of two lines by Cramer's rule
    '''
    a,b,e=l1
    c,d,f=l2
    det=a*d-b*c
    if abs(det)<.0001:
        print 'Determinant: %3.5f, a/c=%3.5f, b/d=%3.5f' % (det,a/c,b/d)
        raise Exception('No intersection found')
    else:
        x=(e*d-b*f)/det
        y=(a*f-e*c)/det
        return (x,y)
    
def circleCenterFromPoints(points):
    '''
    Determines the center of a circle going through 3 points. 
    This can be used for the circumcircle of three random points but will work just as well
    on a circle stroke (taking the first three points, that are accurately on the real circle),
    or on the vertices of a regular polygon (all vertices are on the same circle, so we can pick any three)
    '''
    
    if len(points)<3: # Normally handled upstream
        raise Exception('Not enough points to compute the circumcircle') 
    bisector1=bisector(points[0],points[1])
    bisector2=bisector(points[1],points[2])
    try:
        center=intersection(bisector1,bisector2)
    except Exception as e:
        raise Exception('Stroke starting at (%3.1f,%3.1f) contains colinear or near-colinear segments' % (points[0][0],points[0][1]))
    return center

def pointAtRhoThetaFromOrigin(origin,rho,theta):
    xo,yo=origin
    x=xo+rho*math.cos(theta)
    y=yo+rho*math.sin(theta)
    return (x,y)

def tangentSegments(center,radius,point,tangentSets):
    dist=distance(center,point)
    if dist < radius:
        raise Exception('Point at (%3.1f,%3.1f) is inside circle centered at (%3.1f,%3.1f) with radius %3.1f' % (point[0],point[1],center[0],center[1],radius))
    axisAngle=angle(center,point)
    radiusAngle=math.acos(radius/dist)
    tp=pointAtRhoThetaFromOrigin(center,radius,axisAngle+radiusAngle)
    gimp.VectorsBezierStroke(tangentSets[0],segmentStroke(tp,point),False)
    tp=pointAtRhoThetaFromOrigin(center,radius,axisAngle-radiusAngle)
    gimp.VectorsBezierStroke(tangentSets[1],segmentStroke(tp,point),False)
    
####################################################
### Basic stroke analysis and construction functions
####################################################

# The famous constant for the computation of control points that create
# a spline that most closely matches a quarter of a circle.
kappa=4*(math.sqrt(2)-1)/3
# See http://spencermortensen.com/articles/bezier-circle/
# .551915024494 is a slightly better value but can only be used for 
# quarter-circles

# The more evolved version of the above for an arbitrary angle (0->pi/2)
def tangentDistanceForArc(radius,halfAngle):
    return radius * (4./3.) * (1-math.cos(halfAngle))/math.sin(halfAngle)

def pointsFromStroke(stroke,minPoints):
    '''
    Takes a list of stroke coordinates and extracts the anchors as (x,y) tuples
    Also checks that the stroke has the required minimum number of points
    '''
    p,closed=stroke.points
    points=[tuple(p[i:i+2]) for i in range(2,len(p),6)]
    if minPoints > 0 and len(points) < minPoints:
        raise Exception('Stroke starting at (%3.1f,%3.1f) should have at least %d points' % (points[0][0],points[0][1],minPoints))
    return (points,closed)

def triplets(points):
    ''' 
    Takes a list of consecutive objects and contructs 
    a list with each object replicated three times.
    Typically used to construct triplets from points
    when no handles are needed
    '''
    return [point for point in points for count in range(3)]

def flattenToStroke(points):
    '''
    Takes a list of points as tuples and flattens it to a list of coordinates 
    '''
    return [coord for point in points for coord in point]

def addStroke(path,points,closed):
    '''
    Add the points to the path as a new stroke. The points are tuples and go by threes
    In most cases the returned stroke is ignored by the caller 
    '''
    if len(points) == 0:
        return None
    return gimp.VectorsBezierStroke(path,flattenToStroke(points),closed)

def addPath(image,oldPath,newPath):
    if len(newPath.strokes) > 0:
        pdb.gimp_image_add_vectors(image, newPath, 0)    
        oldPath.visible=False
        newPath.visible=True
    else:
        gimp.delete(newPath)
    
def circleCenterRadius(stroke):
    points,closed=pointsFromStroke(stroke,2)
    if len(points)==2:
        return points[0],distance(points[0],points[1])
    else: # len(points)>=3:
        center=circleCenterFromPoints(points)
        return center,distance(center,points[0])
    
def tripletAtRhoThetaFromOrigin(origin,rho,theta):
    p=pointAtRhoThetaFromOrigin(origin,rho,theta)
    return [p,p,p]

def tripletAtXYFromOrigin(origin,dx,dy):
    x0,y0=origin
    p=(x0+dx,y0+dy)
    return [p,p,p]

# Paths for circles and circle arcs run in the trig/CCW direction in mathematical coordinates
# The downward pointing Y axis used by Gimp make them run clockwise in practice.

def circleTriplet(center,rho,theta):
    '''
    One anchor and its two handles to create a circle approximation
    (four needed for a full circle)
    '''
    anchor=pointAtRhoThetaFromOrigin(center,rho,theta)
    bwdHandle=pointAtRhoThetaFromOrigin(anchor,rho*kappa,theta-math.pi/2)
    fwdHandle=pointAtRhoThetaFromOrigin(anchor,rho*kappa,theta+math.pi/2)
    return [bwdHandle,anchor,fwdHandle]

def circleArcSextuplet(center,rho,theta,width):
    '''
    Anchors and tangent handles to create a circle arc approximation
    (0<width<pi/2)
    '''
    p1=pointAtRhoThetaFromOrigin(center,rho,theta)
    p2=pointAtRhoThetaFromOrigin(center,rho,theta+width)
    tg=tangentDistanceForArc(rho,theta/2)
    tgOrientation=math.copySign(width,math.pi/2)
    t1=pointAtRhoThetaFromOrigin(p1,tg,theta+tgOrientation)
    t2=pointAtRhoThetaFromOrigin(p2,tg,theta+width-tgOrientation)
    if width>0: # CW for Gimp
        return [p1,p1,t1,t2,p2,p2]
    else:    
        return [p2,p2,t2,t1,p1,p1]
    
def circleFromRadius(p1,p2):
    rho=distance(p1,p2)
    theta=angle(p1,p2)
    points=[]
    for i in range(4):
        triplet=circleTriplet(p1,rho,theta+(i*math.pi/2))
        points.extend(triplet)
    return points,True

def crosshairFromRadius(p1,p2):
    x1,y1=p1
    x2,y2=p2
    dx,dy=x2-x1,y2-y1
    pa=p2
    pb=(x1-dx,y1-dy)
    diameter1=[pa]*3+[pb]*3,False
    pc=(x1+dy,y1-dx)
    pd=(x1-dy,y1+dx)
    diameter2=[pc]*3+[pd]*3,False
    return [diameter1,diameter2]

def circleFromDiameter(p1,p2):
    return circleFromRadius(middle(p1,p2),p2)

def segmentStroke(p1,p2):
    return [coord for point in [p1]*3+[p2]*3 for coord in point]

    
###########################################################################    
# Iteration over strokes and points. 
# 
# For segment-based iterations, each segment between two points
# is mapped to a shape stroke by a shapeGenerator function. This function
# is given the begin and end points of the segment. All the other parameters
# (actual shape, orientation on segment, etc...) come with the shapeGenerator
# functions which is built with a closure.
# 
# For stroke-based iterations, each stroke is mapped to a shape stroke
# by a shapeGenerator function, which is given the list of anchor points
# in the stroke.
#
# Shape generators return a list of (stroke_triplets,"closed stroke" flag) tuples:
# ([(xa1,ya1),(xa2,ya2),(xa3,ya3),.................,((xz1,yz1),(xz2,yz2),(xz3,yz3))],true/false)

###########################################################################    

#############################################################
### Shape from segments generators for the "segments" section 
#############################################################
def shapesOnOverlappingSegments(image,path,shapeGenerator,shapesDescription):
    shapes=gimp.Vectors(image,'%s using overlapping segments in <%s>' % (shapesDescription,path.name))
    for stroke in path.strokes:
        points,closed=pointsFromStroke(stroke,2)
        for point in points[1:]:
            segmentShapes=shapeGenerator(points[0],point)
            for segmentShape in segmentShapes:
                shapePoints,shapeClosed=segmentShape
                addStroke(shapes,shapePoints,shapeClosed)
    addPath(image,path,shapes)
    
def shapesOnConsecutiveSegments(image,path,shapeGenerator,shapesDescription):
    shapes=gimp.Vectors(image,'%s using consecutive segments in <%s>' % (shapesDescription,path.name))
    for stroke in path.strokes:
        points,closed=pointsFromStroke(stroke,2)
        if closed:
            points.append(points[0])
        for i in range(len(points)-1):
            segmentShapes=shapeGenerator(points[i],points[i+1])
            for segmentShape in segmentShapes:
                shapePoints,shapeClosed=segmentShape
                addStroke(shapes,shapePoints,shapeClosed)
    addPath(image,path,shapes)
        
##########################################################
### Shape from strokes generator for the "strokes" section 
##########################################################
def shapesOnStrokes(image,path,shapeGenerator,minPoints,shapesDescription):
    shapes=gimp.Vectors(image,'%s using strokes in <%s>' % (shapesDescription,path.name))
    for stroke in path.strokes:
        points,closed=pointsFromStroke(stroke,minPoints)
        segmentShapes=shapeGenerator(points,closed)
        for segmentShape in segmentShapes:
            shapePoints,shapeClosed=segmentShape
            addStroke(shapes,shapePoints,shapeClosed)
    addPath(image,path,shapes)
                
iteratorOptions={'Consecutive':shapesOnConsecutiveSegments,'Overlapping':shapesOnOverlappingSegments}

##################################
### Implementations of the plugins
##################################

###########
### Circles
###########

def circleOnRadiusSegment(p1,p2):
    return [circleFromRadius(p1,p2)]

def circleOnDiameterSegment(p1,p2):
    return [circleFromDiameter(p1,p2)]

def circumcircleOnStroke(points,closed):
    center=circleCenterFromPoints(points)
    return [circleFromRadius(center,points[0])]

def crosshairOnStroke(points,closed):
    center=circleCenterFromPoints(points)
    return crosshairFromRadius(center,points[0])

def circumcircle(image,path):
    shapesOnStrokes(image,path,circumcircleOnStroke,3,'Circumcircles')

def crosshair(image,path):
    shapesOnStrokes(image,path,crosshairOnStroke,3,'Crosshairs')

reg(circumcircle,'circumcircle','Create circumcircle (circle going through three points)','Circumcircle',circleMenu)

reg(crosshair,'crosshair','Locate center of circumcircle (circle going through three points)','Crosshair',circleMenu)

circleSegmentRefOptions={'Radius':circleOnRadiusSegment,'Diameter':circleOnDiameterSegment}

def circlesOnSegments(image, path, segmentRef, iteratorType):
    generator=dictValueFromKeyIndex(circleSegmentRefOptions,segmentRef)
    iterator=dictValueFromKeyIndex(iteratorOptions,iteratorType)
    iterator(image,path,generator,'circlesOnSegments')
    #raise Exception('polygonsOrSpokesOnSegments: %s' % [shape, segmentRef, sides, apothem])

    
reg(circlesOnSegments,'circles-on-segments','Generate circles over segments','Circles',segmentsMenu,
    additionalParameters=[
        (PF_OPTION, 'segmentRef',  'Segment reference',0,circleSegmentRefOptions.keys()),
        (PF_OPTION, 'iteratorType','Segments',0,iteratorOptions.keys())
        ]
    )

#########
### Stars
#########

def spokesFromGeometry(center,rho,theta,count):
    points=[]
    alpha=(2*math.pi)/count
    strokes=[]
    for i in range(count):
        strokes.append((triplets([center,pointAtRhoThetaFromOrigin(center,rho,theta+i*alpha)]),False))
    return strokes

def spokesGeneratorCore(p1,p2,count,apothem,geometry):
    g=geometry(p1,p2,count,apothem)
    return spokesFromGeometry(*g)

def spokesGenerator(count,apothem,geometry):
    def generator(p1,p2):
        return spokesGeneratorCore(p1,p2,count,apothem,geometry)
    return generator

def star(image,path):
    star=gimp.Vectors(image,'Star using <%s>' % (path.name))
    for stroke in path.strokes:
        points,closed=pointsFromStroke(stroke,4)
        center=points[0]
        rho1=distance(center,points[1])
        rho2=distance(center,points[2])
        theta=angle(center,points[1])
        count=len(points)-2
        alpha=(2*math.pi)/count
        starPoints=[]
        for i in range(count):
            starPoints.extend(tripletAtRhoThetaFromOrigin(center,rho1,theta+i*alpha))
            starPoints.extend(tripletAtRhoThetaFromOrigin(center,rho2,theta+i*alpha+alpha/2))
        gimp.VectorsBezierStroke(star,flattenToStroke(starPoints),True)
        pdb.gimp_image_add_vectors(image, star, 0)    
        star.visible=True

reg(star,'star','Create stars','Star',starMenu)

def doubleStar(image,path):
    star=gimp.Vectors(image,'Double star using <%s>' % (path.name))
    for stroke in path.strokes:
        points,closed=pointsFromStroke(stroke,5)
        center=points[0]
        rho1=distance(center,points[1])
        rho2=distance(center,points[2])
        rho3=distance(center,points[3])
        theta=angle(center,points[1])
        count=len(points)-3
        alpha=(2*math.pi)/count
        starPoints=[]
        for i in range(count):
            starPoints.extend(tripletAtRhoThetaFromOrigin(center,rho1,theta+i*alpha))
            starPoints.extend(tripletAtRhoThetaFromOrigin(center,rho2,theta+i*alpha+alpha/4))
            starPoints.extend(tripletAtRhoThetaFromOrigin(center,rho3,theta+i*alpha+alpha/2))
            starPoints.extend(tripletAtRhoThetaFromOrigin(center,rho2,theta+i*alpha+alpha*3/4))
        gimp.VectorsBezierStroke(star,flattenToStroke(starPoints),True)
        pdb.gimp_image_add_vectors(image, star, 0)    
        star.visible=True

reg(doubleStar,'double-star','Create double stars','Double star',starMenu)

def spokes(image,path):
    spokes=gimp.Vectors(image,'Spokes using <%s>' % (path.name))
    for stroke in path.strokes:
        points,closed=pointsFromStroke(stroke,3)
        rho=distance(points[0],points[1])
        theta=angle(points[0],points[1])
        count=len(points)-1
        alpha=(2*math.pi)/count
        for i in range(count):
            spokePoints=([points[0]]*3)+tripletAtRhoThetaFromOrigin(points[0],rho,theta+i*alpha)
            gimp.VectorsBezierStroke(spokes,flattenToStroke(spokePoints),False)
        pdb.gimp_image_add_vectors(image, spokes, 0)    
        spokes.visible=True

reg(spokes,'spokes','Create spokes','Spokes',starMenu)

############
### Polygons
############

#################################################################################
### Functions to compute the required points for polygons or spokes over segments
### All cases are transformed into a common "polygonSpecs" quadruplet with:
###   - center point (center)
###   - circumradius (rho)
###   - start angle (theta)
###   - number of summits (count)
#################################################################################

def polygonSpecsFromPseudoDiameter(p1,p2,count,apothem):
    '''
    The polygon constructed covers the whole segment (and may therefore
    not be perfectly centered on it)
    For odd polygons: 
        Pseudo-diameter=Radius+apothem
    For even polygons:
        Pseudo-diameter=2*Radius or 2*apothem depending on flag
    '''
    alpha=math.pi/count # half angle
    length=distance(p1,p2)
    theta=angle(p2,p1) # Looking from center to p1 so same direction as p2 to p1
    
    if count % 2: # Odd polygon: the segment is one radius+one apothem
        k=1/(1+math.cos(alpha))
        rho=k*length
        if apothem:
            center=intermediatePoint(p2,p1,k)
            theta+=alpha
        else:
            center=intermediatePoint(p1,p2,k)
    else: # Even polygon
        # center is always the middle
        center=middle(p1,p2)
        if apothem:
            rho=length/(2*math.cos(alpha))
            theta+=alpha
        else:
            rho=length/2
    return center, rho, theta, count

def polygonSpecsFromIncircleDiameter(p1,p2,count,apothem):
    alpha=math.pi/count # half angle
    length=distance(p1,p2)
    theta=angle(p2,p1) # Looking from center to p1 so same direction as p2 to p1
    center=middle(p1,p2)
    rho=length/(2*math.cos(alpha))
    if apothem:
        theta+=alpha
    return center, rho, theta, count

def polygonSpecsFromCircumcircleDiameter(p1,p2,count,apothem):
    alpha=math.pi/count # half angle
    length=distance(p1,p2)
    theta=angle(p2,p1) # Looking from center to p1 so same direction as p2 to p1
    center=middle(p1,p2)
    rho=length/2
    if apothem:
        theta+=alpha
    return center, rho, theta, count

def polygonSpecsFromCircumcircleRadius(p1,p2,count):
    return p1,distance(p1,p2),angle(p1,p2),count

def polygonSpecsFromIncircleRadius(p1,p2,count):
    alpha=math.pi/count # half angle
    rho=distance(p1,p2)/(math.cos(alpha))
    theta=angle(p1,p2)+alpha
    return p1,rho,theta,count

############################################################
### Functions that generate a polygon from the polygon specs
############################################################

# The one that actually creates the polygons points from the
# polygonSpecs, used both for strokes ans segments
def polygonFromPolygonSpecs(center,rho,theta,count):
    points=[]
    alpha=(2*math.pi)/count
    for i in range(count):
        points.append(pointAtRhoThetaFromOrigin(center,rho,theta+i*alpha))
    return [(triplets(points),True)]

def polygonGeneratorCore(p1,p2,count,apothem,specsGenerator):
    ps=specsGenerator(p1,p2,count,apothem)
    return polygonFromPolygonSpecs(*ps)

# This function creates the function used when iterating over segments
def polygonGenerator(count,apothem,specsGenerator):
    def generator(p1,p2):
        return polygonGeneratorCore(p1,p2,count,apothem,specsGenerator)
    return generator

def polygonFromCircumradiusOnStroke(points,closed):
    polygonSpecs=polygonSpecsFromCircumcircleRadius(points[0],points[1],len(points)-1)
    return polygonFromPolygonSpecs(*polygonSpecs)

def polygonFromCircumradius(image,path):
    shapesOnStrokes(image,path,polygonFromCircumradiusOnStroke,4,'Polygons from circumradius')

reg(polygonFromCircumradius,'polygon-from-circumradius','Create polygons taking a stroke as their circumradius','Polygon from circumradius',polygonMenu)

def polygonFromApothemOnStroke(points,closed):
    polygonSpecs=polygonSpecsFromIncircleRadius(points[0],points[1],len(points)-1)
    return polygonFromPolygonSpecs(*polygonSpecs)

def polygonFromApothem(image,path):
    shapesOnStrokes(image,path,polygonFromApothemOnStroke,4,'Polygons from apothem')

reg(polygonFromApothem,'polygon-from-apothem','Create polygons taking a stroke as their apothem','Polygon from apothem',polygonMenu)

def polygonFromSideOnStroke(points,closed):
    count=len(points)
    sideLength=distance(points[0],points[1])
    sideOrientation=angle(points[0],points[1])
    apothemFoot=middle(points[0],points[1])
    alpha=math.pi/count # half-angle
    apothemLength=sideLength/(2*math.tan(alpha))
    center1=pointAtRhoThetaFromOrigin(apothemFoot,apothemLength,sideOrientation+math.pi/2)
    center2=pointAtRhoThetaFromOrigin(apothemFoot,apothemLength,sideOrientation-math.pi/2)
    # Find which center is closest to third point in stroke
    d1=distance(center1,points[2])
    d2=distance(center2,points[2])
    center=center1 if d1<d2 else center2
    polygonSpecs=(center,sideLength/(2*math.sin(alpha)),angle(center,apothemFoot)+alpha,count)
    return polygonFromPolygonSpecs(*polygonSpecs)

def polygonFromSide(image,path):
    shapesOnStrokes(image,path,polygonFromSideOnStroke,3,'Polygons from sides')

reg(polygonFromSide,'polygon-from-side','Create polygons taking a stroke as their side','Polygon from side',polygonMenu)

polygonOrSpokeOptions={'Polygons':polygonGenerator,'Spokes':spokesGenerator}

polygonSegmentRefOptions={
        'Circumcircle':polygonSpecsFromCircumcircleDiameter,
        'Incircle':polygonSpecsFromIncircleDiameter,
        'Pseudo-diameter':polygonSpecsFromPseudoDiameter
        }

apothemOptions=['Summit/Spoke','Side/Interval']

# Looks unpythonic... but in practice the key index is a user choice among the output of keys() on
# dictionaries that never change and should always be identical, even between disctinct executions of the
# script (in particular, between the execution for the registration and the execution for actual use).
def dictValueFromKeyIndex(d,k):
    return d[d.keys()[k]]

def polygonsOrSpokesOnSegments(image, path, shape, segmentRef, sides, apothem,iteratorType):
    specsGenerator=dictValueFromKeyIndex(polygonSegmentRefOptions,segmentRef)
    generator=dictValueFromKeyIndex(polygonOrSpokeOptions,shape)(int(sides),apothem,specsGenerator)
    iterator=dictValueFromKeyIndex(iteratorOptions,iteratorType)
    iterator(image,path,generator,'polygonsOrSpokesOnSegments')
    #raise Exception('polygonsOrSpokesOnSegments: %s' % [shape, segmentRef, sides, apothem])
    
reg(polygonsOrSpokesOnSegments,'polygons-or-spokes-on-segments','Generate polygons or spokes over segments','Polygons or spokes',segmentsMenu,
    additionalParameters=[
        (PF_OPTION, 'shape',       'Shape',0,polygonOrSpokeOptions.keys()),
        (PF_OPTION, 'segmentRef',  'Segment reference',2,polygonSegmentRefOptions.keys()),
        (PF_SPINNER,'sides',       'Sides/Spokes',3,(3, 300, 1)),
        (PF_OPTION, 'apothem',     'First point of segment',0,apothemOptions),
        (PF_OPTION, 'iteratorType','Segments',0,iteratorOptions.keys())
        ]
    )

####################
### Rounded Polygons
####################

# We use an internal polygon of radius rho*(1-roundness)
# And each vertex we draw an arc of radius rho*roundness
def roundedPolygonFromRoundedPolygonSpecs(center,rho,theta,count,roundness):
    points=[]
    alpha=(2*math.pi)/count
    polyRadius=rho*(1.-roundness)
    arcRadius=rho*roundness
    for i in range(count):
        vertexAngle=theta+i*alpha
        vertex=pointAtRhoThetaFromOrigin(center,polyRadius,vertexAngle)
        # Arc is done with three anchors (ie, two half-arcs) because the triangle
        # requires a 120° arc. S,C,E=Start,Center,End
        angleS=vertexAngle-alpha/2
        angleC=vertexAngle
        angleE=vertexAngle+alpha/2
        
        arcS=pointAtRhoThetaFromOrigin(vertex,arcRadius,angleS)
        arcC=pointAtRhoThetaFromOrigin(vertex,arcRadius,angleC)
        arcE=pointAtRhoThetaFromOrigin(vertex,arcRadius,angleE)
        tangentDistance=tangentDistanceForArc(arcRadius,alpha/4)
        tangentSF=pointAtRhoThetaFromOrigin(arcS,tangentDistance,angleS+math.pi/2)
        tangentCB=pointAtRhoThetaFromOrigin(arcC,tangentDistance,angleC-math.pi/2)
        tangentCF=pointAtRhoThetaFromOrigin(arcC,tangentDistance,angleC+math.pi/2)
        tangentEB=pointAtRhoThetaFromOrigin(arcE,tangentDistance,angleE-math.pi/2)
        # No external handles since we connect in straight line to the arc at next vertex
        points.extend([arcS,arcS,tangentSF,tangentCB,arcC,tangentCF,tangentEB,arcE,arcE])
    return [(points,True)]

def roundedPolygonGeneratorCore(p1,p2,count,apothem,roundness,specsGenerator):
    rps=specsGenerator(p1,p2,count,apothem,roundness)
    return roundedPolygonFromRoundedPolygonSpecs(*rps)

# This function creates the function used when iterating over segments
def roundedPolygonGenerator(count,apothem,roundness,specsGenerator):
    def generator(p1,p2):
        return roundedPolygonGeneratorCore(p1,p2,count,apothem,roundness,specsGenerator)
    return generator

def roundedPolygonSpecsFromCircumcircleDiameter(p1,p2,count,apothem,roundness):
    center,rho,theta,count=polygonSpecsFromCircumcircleDiameter(p1,p2,count,apothem)
    return center,rho,theta,count,roundness

def roundedPolygonSpecsFromIncircleDiameter(p1,p2,count,apothem,roundness):
    alpha=math.pi/count # half angle
    length=distance(p1,p2)
    theta=angle(p2,p1) # Looking from center to p1 so same direction as p2 to p1
    center=middle(p1,p2)
    #rho=length/(2*math.cos(alpha))
    rho=length/(2*((1-roundness)*math.cos(alpha)+roundness))
    if apothem:
        theta+=alpha
    return center, rho, theta, count,roundness

def roundedPolygonSpecsFromPseudoDiameter(p1,p2,count,apothem,roundness):
    '''
    The polygon constructed covers the whole segment (and may therefore
    not be perfectly centered on it, for odd polygons. For even-numbered
    polygons, we are in either the incircle (apothem) or 
    circumcicle (^apothem) cases.
    '''

    if count%2==0:
        if apothem:
            return roundedPolygonSpecsFromIncircleDiameter(p1,p2,count,apothem,roundness)
        else:
            return roundedPolygonSpecsFromCircumcircleDiameter(p1,p2,count,apothem,roundness)

    # Now tackle the harder case of the even-numbered polygon
    # Distance from center to tip is rho
    # Distance from center to side is:
    # - apothem of support polygon: rho*(1-roundness)*cos(alpha)
    # - plus distance from side of support polygon to side of final polygon (rho*roundess)
    alpha=math.pi/count # half angle
    length=distance(p1,p2)
    theta=angle(p2,p1) # Looking from center to p1 so same direction as p2 to p1
    k=1/(1+roundness+(math.cos(alpha)*(1-roundness)))
    rho=k*length
    if apothem:
        center=intermediatePoint(p2,p1,k)
        theta+=alpha
    else:
        center=intermediatePoint(p1,p2,k)
    return center,rho,theta,count,roundness

def roundedPolygonSpecsFromCircumcircleRadius(p1,p2,p3,count):
    rho=distance(p1,p3)
    roundingRadius=rho-distance(p1,p2)
    roundness=roundingRadius/rho
    return p1,rho,angle(p1,p3),count,roundness

def roundedPolygonFromCircumradiusOnStroke(points,closed):
    rps=roundedPolygonSpecsFromCircumcircleRadius(points[0],points[1],points[2],len(points)-2)
    return roundedPolygonFromRoundedPolygonSpecs(*rps)

def roundedPolygonFromCircumradius(image,path):
    shapesOnStrokes(image,path,roundedPolygonFromCircumradiusOnStroke,5,'Rounded polygons from circumradius')

reg(roundedPolygonFromCircumradius,'rounded-polygon-from-circumradius','Create rounded polygons taking a stroke as their circumradius','Rounded polygon from circumradius',roundedPolygonMenu)

def roundedPolygonSpecsFromIncircleRadius(p1,p2,p3,count):
    outerApothem=distance(p3,p1)
    innerApothem=distance(p2,p1)
    alpha=math.pi/count
    rho=(innerApothem/math.cos(alpha))+(outerApothem-innerApothem)
    roundness=(outerApothem-innerApothem)/rho
    return p1,rho,angle(p1,p3)+alpha,count,roundness

def roundedPolygonFromApothemOnStroke(points,closed):
    rps=roundedPolygonSpecsFromIncircleRadius(points[0],points[1],points[2],len(points)-2)
    return roundedPolygonFromRoundedPolygonSpecs(*rps)

def roundedPolygonFromApothem(image,path):
    shapesOnStrokes(image,path,roundedPolygonFromApothemOnStroke,5,'Rounded polygons from apothem')

reg(roundedPolygonFromApothem,'rounded-polygon-from-apothem','Create rounded polygons taking a stroke as their apothem','Rounded polygon from apothem',roundedPolygonMenu)

def roundedPolygonSpecsFromSide(p1,p2,p3,p4,count):
    alpha=math.pi/count # half-angle
    sideOrientation=angle(p1,p2)
    externalApothemFoot=middle(p1,p3)
    externalApothemLength=distance(p3,p1)/(2*math.tan(alpha))
    center1=pointAtRhoThetaFromOrigin(externalApothemFoot,externalApothemLength,sideOrientation+math.pi/2)
    center2=pointAtRhoThetaFromOrigin(externalApothemFoot,externalApothemLength,sideOrientation-math.pi/2)
    # Find which center is closest to third point in stroke
    d1,d2=distance(center1,p4),distance(center2,p4)
    center=center1 if d1<d2 else center2
    roundingRadius=distance(p2,p3)/math.tan(alpha)
    rho=roundingRadius+(externalApothemLength-roundingRadius)/math.cos(alpha)
    roundness=roundingRadius/rho
    return center,rho,angle(center,externalApothemFoot)+alpha,count,roundness
    
def roundedPolygonFromSideOnStroke(points,closed):
    rps=roundedPolygonSpecsFromSide(points[0],points[1],points[2],points[3],len(points)-1)
    return roundedPolygonFromRoundedPolygonSpecs(*rps)

def roundedPolygonFromSide(image,path):
    shapesOnStrokes(image,path,roundedPolygonFromSideOnStroke,4,'Rounded polygons from side')

reg(roundedPolygonFromSide,'rounded-polygon-from-side','Create rounded polygons taking a stroke as their side','Rounded polygon from side',roundedPolygonMenu)


roundedPolygonSegmentRefOptions={
        'Circumcircle':roundedPolygonSpecsFromCircumcircleDiameter,
        'Incircle':roundedPolygonSpecsFromIncircleDiameter,
        'Pseudo-diameter':roundedPolygonSpecsFromPseudoDiameter
        }

def roundedPolygonsOnSegments(image,path,segmentRef,sides,roundness,apothem,iteratorType):
    specsGenerator=dictValueFromKeyIndex(roundedPolygonSegmentRefOptions,segmentRef)
    generator=roundedPolygonGenerator(int(sides),apothem,roundness/100.,specsGenerator)
    iterator=dictValueFromKeyIndex(iteratorOptions,iteratorType)
    iterator(image,path,generator,'roundedPolygonsOnSegments')

roundedPolygonSegmentRefOptions={
        'Circumcircle':roundedPolygonSpecsFromCircumcircleDiameter,
        'Incircle':roundedPolygonSpecsFromIncircleDiameter,
        'Pseudo-diameter':roundedPolygonSpecsFromPseudoDiameter
        }

reg(roundedPolygonsOnSegments,'rounded-polygons-on-segments','Generate rounded polygons over segments','Rounded polygons',segmentsMenu,
    additionalParameters=[
        (PF_OPTION, 'segmentRef',  'Segment reference',2,polygonSegmentRefOptions.keys()),
        (PF_SPINNER,'sides',       'Sides',3,(3, 300, 1)),
        (PF_SPINNER,'roundness',   'Roundness',20,(-100,100,1)),
        (PF_OPTION, 'apothem',     'First point of segment',0,apothemOptions),
        (PF_OPTION, 'iteratorType','Segments',0,iteratorOptions.keys())
        ]
    )

##############
### Rectangles
##############

def corner(r,x,y,dx,dy):
    '''Draws a corner of a rounded rectangle, assumed CCW (but will be CW in Gimp coordinates)'''
    h=r*(1-kappa) # tangent handle distance from corner
    xa=x+(dx*r) # anchor at start/end of curve
    xt=x+(dx*h) # tangent handle
    ya=y+(dy*r) # anchor at start/end of curve
    yt=y+(dy*h) # tangent handle
    if dx == dy: # corner from V to H
        tv=[(x,ya),(x,ya),(x,yt)] # triplet on vertical
        th=[(xt,y),(xa,y),(xa,y)] # triplet on horizontal 
        p=tv+th
    else:
        th=[(xa,y),(xa,y),(xt,y)] # triplet on horizontal 
        tv=[(x,yt),(x,ya),(x,ya)] # triplet on vertical
        p=th+tv 
    return p

def rectangleUprightOnStroke(points,closed):
    x1,y1=points[0]
    x2,y2=points[1]
    xMin=min(x1,x2)
    xMax=max(x1,x2)
    yMin=min(y1,y2)
    yMax=max(y1,y2)
    
    rectanglePoints=[]
    if len(points)==2:
        rectanglePoints=[(xMin,yMin)]*3+[(xMax,yMin)]*3+[(xMax,yMax)]*3+[(xMin,yMax)]*3
        
    elif len(points)==3: # with rounded corners
        r=distance(points[1],points[2]) # radius of corner
        rectanglePoints+=corner(r,xMin,yMin,+1,+1)
        rectanglePoints+=corner(r,xMax,yMin,-1,+1)
        rectanglePoints+=corner(r,xMax,yMax,-1,-1)
        rectanglePoints+=corner(r,xMin,yMax,+1,-1)
    else:
        pass
    return [(rectanglePoints,True)]

def rectangleUpright(image,path):
    shapesOnStrokes(image,path,rectangleUprightOnStroke,2,'Rectangles')
     
reg(rectangleUpright,'rectangle-upright','Create rectangle','Rectangle with optional rounded corners',rectangleMenu)

############
### Tangents
############

def tangentSegmentsForStroke(center,radius,stroke,tangentSets):            
    points,closed=pointsFromStroke(stroke,0)
    for point in points:
        segments=tangentSegments(center,radius,point,tangentSets)
    
def tangentsPointToCircle(image,path):
    tangentSetL=gimp.Vectors(image,'Tangents (L) using <%s>' % (path.name))
    tangentSetR=gimp.Vectors(image,'Tangents (R) using <%s>' % (path.name))
    tangentSets=[tangentSetL,tangentSetR]
    strokes=path.strokes
    center,radius=circleCenterRadius(strokes[0])
    sourcePaths=[p for p in image.vectors if p.linked and p.ID!=path.ID]
    if sourcePaths: # use linked paths if any
        for sourcePath in sourcePaths:
            for stroke in sourcePath.strokes:
                tangentSegmentsForStroke(center,radius,stroke,tangentSets)
    else: # else use other strokes
        if len(strokes) < 2:
            raise Exception('At least two strokes or one linked path are required')
        for stroke in path.strokes[1:]:
            tangentSegmentsForStroke(center,radius,stroke,tangentSets)
    for tangentSet in tangentSets:
        pdb.gimp_image_add_vectors(image,tangentSet, 0)    
        tangentSet.visible=True
        
reg(tangentsPointToCircle,'tangents-point-to-circle','Create tangents to circle from points','Tangents to circle from points',tangentMenu)

def tangentsCircleToCircleForStroke(center1,radius1,stroke,tangents):
    center2,radius2=circleCenterRadius(stroke)
    # Normalize cases by usin c1,r1 for smallest circle
    if (radius2 < radius1):
        c1,r1=center2,radius2
        c2,r2=center1,radius1
    else:
        c1,r1=center1,radius1
        c2,r2=center2,radius2
        
    dist=distance(c1,c2)
    axisAngle=angle(c2,c1)
    
    if dist < (r2-r1): # smaller circle entirely inside the bigger one: no tangents
        raise Exception('Circles centered at (%3.1f,%3.1f) and (%3.1f,%3.1f) are completely with each other, there are no tangents' % (c1[0],c1[1],c2[0],c2[1])) 

    # circles intersect or are outside each other, there are at least outer tangents
    radiusAngle=math.acos((r2-r1)/dist)
    p1=pointAtRhoThetaFromOrigin(c1,r1,axisAngle+radiusAngle)
    p2=pointAtRhoThetaFromOrigin(c2,r2,axisAngle+radiusAngle)
    gimp.VectorsBezierStroke(tangents[2],segmentStroke(p1,p2),False)
    p1=pointAtRhoThetaFromOrigin(c1,r1,axisAngle-radiusAngle)
    p2=pointAtRhoThetaFromOrigin(c2,r2,axisAngle-radiusAngle)
    gimp.VectorsBezierStroke(tangents[3],segmentStroke(p1,p2),False)

    # if the circles don't intersect, we can in addition find the inner tangents
    if dist > (r1+r2): 
        radiusAngle=math.acos((r2+r1)/dist)
        p1=pointAtRhoThetaFromOrigin(c1,r1,axisAngle+math.pi+radiusAngle)
        p2=pointAtRhoThetaFromOrigin(c2,r2,axisAngle+radiusAngle)
        gimp.VectorsBezierStroke(tangents[0],segmentStroke(p1,p2),False)
        p1=pointAtRhoThetaFromOrigin(c1,r1,axisAngle+math.pi-radiusAngle)
        p2=pointAtRhoThetaFromOrigin(c2,r2,axisAngle-radiusAngle)
        gimp.VectorsBezierStroke(tangents[1],segmentStroke(p1,p2),False)

def tangentsCircleToCircle(image,path):
    tangentSetIL=gimp.Vectors(image,'Tangents (IR) using <%s>' % (path.name))
    tangentSetIR=gimp.Vectors(image,'Tangents (IL) using <%s>' % (path.name))
    tangentSetOL=gimp.Vectors(image,'Tangents (OL) using <%s>' % (path.name))
    tangentSetOR=gimp.Vectors(image,'Tangents (OR) using <%s>' % (path.name))
    tangentSets=[tangentSetIL,tangentSetIR,tangentSetOL,tangentSetOR]
    strokes=path.strokes
    center,radius=circleCenterRadius(strokes[0])
    sourcePaths=[p for p in image.vectors if p.linked and p.ID!=path.ID]
    if sourcePaths: # use linked paths if any
        for sourcePath in sourcePaths:
            for stroke in sourcePath.strokes:
                tangentsCircleToCircleForStroke(center,radius,stroke,tangentSets)
    else: # else use other strokes
        if len(strokes) < 2:
            raise Exception('At least two strokes or one linked path are required')
        for stroke in path.strokes[1:]:
            tangentsCircleToCircleForStroke(center,radius,stroke,tangentSets)
    for tangentSet in tangentSets:
        pdb.gimp_image_add_vectors(image,tangentSet, 0)    
        tangentSet.visible=True
        
reg(tangentsCircleToCircle,'tangents-circle-to-circles','Create tangents between circles','Tangents betwen circles',tangentMenu)

######################
### Lines and segments
######################

def multiplySegmentInStroke(points,closed):
    multiplyFactor=len(points)-1
    p0=points[0]
    p1=points[1]
    dx=(p1[0]-p0[0])
    dy=(p1[1]-p0[1])
    linePoints=[p0,p0,p0,p1,p1,p1]
    for i in range(1,multiplyFactor):
        linePoints.extend(tripletAtXYFromOrigin(p0,dx*(i+1),dy*(i+1)))
    return [(linePoints,False)]


def multiplySegment(image,path):
    shapesOnStrokes(image,path,multiplySegmentInStroke,3,'Multiplied segments')

reg(multiplySegment,'multiply-segment','Multiply segment','Multiply segment',lineMenu)

def divideSegmentInStroke(points,closed):
    divideFactor=len(points)-1
    p0=points[0]
    p1=points[-1]
    dx=(p1[0]-p0[0])/divideFactor
    dy=(p1[1]-p0[1])/divideFactor
    linePoints=[p0,p0,p0]
    for i in range(1,divideFactor):
        linePoints.extend(tripletAtXYFromOrigin(p0,dx*i,dy*i))
    linePoints.extend([p1,p1,p1])    
    return [(linePoints,False)]

def divideSegment(image,path):
    shapesOnStrokes(image,path,divideSegmentInStroke,3,'Divided segments')

reg(divideSegment,'divide-segment','Divide segment evenly','Divide segment',lineMenu)

def segmentShrinkCore(p1,p2,start,end):
    return [(triplets([intermediatePoint(p1,p2,start),intermediatePoint(p1,p2,end)]),False)]

def segmentShrinker(start,end):
    def generator(p1,p2):
        return segmentShrinkCore(p1,p2,start/100.,end/100.)
    return generator
    
def modifySegments(image, path, start, end):
    shapesOnConsecutiveSegments(image,path,segmentShrinker(start,end),'Modified segments (%d%%,%d%%)' % (start,end))
    
reg(modifySegments,'modify-segments','Enlarge, shrink and shift segments','Modify segments',segmentsMenu,
    additionalParameters=[(PF_SPINNER, 'start','Start',0, (-100,200,1)),(PF_SPINNER, 'end',  'End',100, (-100,200,1))])
    
main()
