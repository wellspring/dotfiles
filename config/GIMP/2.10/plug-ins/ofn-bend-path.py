#!/usr/bin/env python
# -*- coding: utf-8 -*-

'''
GIMP plugin to vertically bend a path between two other paths

(c) Ofnuts 2017

  History:

  v0.0: 2017-12-20 First published version
  v0.1: 2017-12-21 Improve envelope checks
  v0.2: 2017-12-23 Allow arbitrary envelope curves
  v0.3: 2017-12-25 Handle cases where the equation to solve is not really a cubic one
  v0.4: 2017-12-26 Remove tracing that breaks the program on Windows 

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published
  by the Free Software Foundation; either version 3 of the License, or
  (at your option) any later version.

  This very file is the complete source code to the program.

  If you make and redistribute changes to this code, please mark it
  in reasonable ways as different from the original version. 
  
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  The GPL v3 licence is available at: https://www.gnu.org/licenses/gpl-3.0.en.html
'''

import os, sys, math, cmath
from collections import namedtuple
import traceback

from gimpfu import *

debug=False
def trace(s):
    if debug:
        print s

Curve=namedtuple('Curve',['startX','endX','startY','endY','coeffsX','coeffsY' ])

############################################################################

# Functions to determine the position of the reference lines
# All these functions return topY,botY
def referencesFromBestFit(image,path,topY,botY):
    # Due to Y pointing down the bottom is the biggest Y
    topY=min([min(stroke.points[0][1::2]) for stroke in path.strokes])
    botY=max([max(stroke.points[0][1::2]) for stroke in path.strokes])
    return topY,botY
    
def referencesFromExplicitValues(image,path,topY,botY):
    if topY>botY:
        return botY,topY
    return topY,botY

def referencesFromGuides(image,path,topY,botY):
    guide=0
    vPos=[]

    guide=pdb.gimp_image_find_next_guide(image,0)
    while guide!=0: 
        if pdb.gimp_image_get_guide_orientation(image, guide)==ORIENTATION_HORIZONTAL:
            vPos.append(pdb.gimp_image_get_guide_position(image, guide))
        guide=pdb.gimp_image_find_next_guide(image,guide)

    if len(vPos) != 2:
        raise Exception('There should be exactly two horizontal guides')
    return min(vPos),max(vPos)

referencesFunctions=[('Best fit',referencesFromBestFit),('Guides',referencesFromGuides),('Explicit Values',referencesFromExplicitValues)]

# The math

def cardano(d,c,b,a):
    '''
    Cubic equation solver, 
    "a" is the coeff of the 3rd degree term 
    Shamelessly stolen from: 
    https://stackoverflow.com/questions/35795663/fastest-way-to-find-the-smallest-positive-real-root-of-quartic-polynomial-4-degr/35829660#35829660
    '''
    J=cmath.exp(2j*cmath.pi/3)
    Jc=1/J
    z0=b/3/a
    a2,b2 = a*a,b*b
    p=-b2/3/a2 +c/a
    q=(b/27*(2*b2/a2-9*c/a)+d)/a
    D=-4*p*p*p-27*q*q
    r=cmath.sqrt(-D/27+0j)
    u=((-q-r)/2)**0.33333333333333333333333
    v=((-q+r)/2)**0.33333333333333333333333
    w=u*v
    w0=abs(w+p/3)
    w1=abs(w*J+p/3)
    w2=abs(w*Jc+p/3)
    if w0<w1:
        if w2<w0 : v*=Jc
    elif w2<w1 : v*=Jc
    else: v*=J
    return u+v-z0, u*J+v*Jc-z0, u*Jc+v*J-z0

def secondDegree(c,b,a):
    discrim=b*b-4*a*c
    A=(-b/(2*a))+0j # return complex number
    B=math.sqrt(abs(discrim))/(2*a)
    if discrim==0:
        return [A] # there should be only one
    elif discrim>0:
        return [A+B,A-B]
    else: # for completeness since these will be filtered out
        return [A+(B*1j),A-(B*1j)]

def l2r(s):
    '''
    Make sure the curves goef left-to-right
    '''
    if s[0]<s[-2]:
        return s
    else: # reverse the pairs
        return [c for p in reversed(zip(s[0::2],s[1::2])) for c in p]
    
def polynomialCoeffs(p):
    '''
    3rd degree polynom coefficients for a Bezier spline
    Takes a list of 4 coordinates
    '''
    coeffs=[p[0],-3*p[0]+3*p[1],3*p[0]-6*p[1]+3*p[2],-p[0]+3*p[1]-3*p[2]+p[3]]
    return coeffs

def curveFromPoints(points):
    '''
    Creates a Curve tuple from 4 points
    '''
    pX=points[0::2]
    pY=points[1::2]
    coeffsX=polynomialCoeffs(pX)
    trace('PointsX: %r, coeffsX: %r' % (pX,coeffsX))
    coeffsY=polynomialCoeffs(pY)
    return Curve(pX[0],pX[-1],pY[0],pY[-1],coeffsX,coeffsY)
    

class Spline(object):
    '''
    Class to hide the complexity of actual strokes made of several Bezier curves
    '''
    def __init__(self,stroke):
        self.name='***' # set later, once we know relative positions
        s,_=stroke.points
        s=l2r(s)
        self.curves=[]
        for i in range(2,len(s)-4,6):
            self.curves.append(curveFromPoints(s[i:i+8]))
            
    def dump(self):
        print '------------------ %s' % self.name
        for c in self.curves:
            print '%6.2f -> %6.2f' % (c.startX,c.endX)
            print c.coeffsX
            print c.coeffsY

    def leftY(self):
        return self.curves[0].startY
    
    def rightY(self):
        return self.curves[-1].endY
    
    def xOutsideRange(self,x):
        raise Exception('x=%.2f outside range for "%s" envelope' % (x,self.name))
                        
    def TforX(self,x,curve):
        '''
        T for given X, by solving the polynomial
        '''
        coeffs=curve.coeffsX[:] # make copy since we alter
        coeffs[0]-=x # "Polynomial(t)=coord" is same as "Polynomial(t)-coord=0"
        d,c,b,a=coeffs
        if a!=0.:
            roots=cardano(d,c,b,a)
        elif b!=0:
            roots=secondDegree(d,c,b)
        elif c!=0:
            roots=[(-d/c)+0j]
        else:
            roots=[d+0j]
            
        #print "Cardano results:", roots
        realRoots=[root.real for root in sorted(roots,key=lambda r: r.real) if 0.<= root.real <= 1. and abs(root.imag) < 1e-8]
        if len(realRoots)==0:
            print 'Roots:',roots
            self.xOutsideRange(x)
        elif len(realRoots)>1:
            print 'Roots:',roots
            raise Exception('Invalid %s envelope shape for x=%.2f' % (self.name,x))
        else:
            return realRoots[0]
    
    def YforT(self,t,curve):
        '''
        Y for a given T
        '''
        p=curve.coeffsY
        termPower=1
        y=0
        for n in range(4):
            y+=termPower*p[n]
            termPower*=t
        return y
        
    def YforX(self,x):
        '''
        Returns the Y position of the curve for a given X by
        1) finding the value of thecurve parameter T for the given X
        2) using that value to compute matching Y
        '''
        # Find adequate Bezier curve
        for c in self.curves:
            #trace('Checking Curve %.2f -> %.2f for %.2f on %s' % (c.startX,c.endX,x,self.name))
            if c.startX <= x <= c.endX:
                break
        else: # not found 
            self.xOutsideRange(x)

        # The two easy cases. 
        # Making them special cases may avoid round-off nastiness when solving the equations
        if x==c.startX:
            return c.startY
        if x==c.endX:
            return c.endY
        
        t=self.TforX(x,c)
        return self.YforT(t,c)


def coordBetween(c1,c2,r):
    return c1+(c2-c1)*r

def pointBetween(p1,p2,r):
    x1,y1=p1
    x2,y2=p2
    return coordBetween(x1,x2,r),coordBetween(y1,y2,r)

def addBendingPoints(pts,bendiness):
    '''
    Make straight lines bendable by replacing them with
    equivalent curves with actual tangents
    '''

    # To handle the "closing" stroke from last to first without convoluted logic
    # extend each end with opposite end
    pts=pts[-2:]+pts+pts[:2]
    for c in range(0,len(pts)-1,3):
        sa,st,et,ea=pts[c:c+4]
        if sa==st and et==ea: # no tangents
            pts[c+1]=pointBetween(sa,ea,bendiness)
            pts[c+2]=pointBetween(ea,sa,bendiness)
    return pts[2:-2] # drop the ones we added, sight unseen

def bend(points,srcTopY,srcBotY,topSpline,botSpline,bendiness):
    pts=addBendingPoints(zip(points[0::2],points[1::2]),bendiness)
    bentPoints=[]
    # Move the Y corrdinate of each point
    for x,y in pts:
        yRelative=(y-srcTopY)/(srcBotY-srcTopY)
        bendTopY=topSpline.YforX(x)
        bendBotY=botSpline.YforX(x)
        bentY=bendTopY+(bendBotY-bendTopY)*yRelative
        #print 'x=%5.2f, y=%5.2f, yRelative=%5.3f, bendTopY=%5.2f, bendBotY=%5.2f, bentY=%5.2f' % (x,y,yRelative,bendTopY,bendBotY,bentY)
        bentPoints.extend([x,bentY])
    return bentPoints

def order(s1,s2):
    '''
    Determines top, bottom splines
    '''
    if s1.leftY()<=s2.leftY() and s1.rightY()<=s2.rightY():
        top,bottom=s1,s2 # Smaller Y at top 
    elif s1.leftY()>=s2.leftY() and s1.rightY()>=s2.rightY():
        top,bottom=s2,s1 
    else:
        raise Exception('Ambiguous position of the envelope strokes')
    top.name='top'
    bottom.name='bottom'
    if debug:
        top.dump()
        bottom.dump()
    return top,bottom

def splinesFromEnvelope(envelope):
    '''
    Creates the splines from the envelope, returns (top,bottom)
    '''
    if len(envelope.strokes)!=2:
        raise Exception('Envelope path shoud contain exactly two strokes')
    s1=Spline(envelope.strokes[0])
    s2=Spline(envelope.strokes[1])
    return order(s1,s2)
    
def bendPath(image,path,envelope,bendiness,references,topY,botY):
    trace('*'*60)
    # Figure out reference lines, and top/bottom envelopes
    srcTopY,srcBotY=referencesFunctions[references][1](image,path,topY,botY)
    bendiness=bendiness*.005 # 100% bendiness is half the distance     
    topSpline,botSpline=splinesFromEnvelope(envelope)
    
    # Bend each stroke
    result=gimp.Vectors(image,'Bent <%s>' % path.name)
    for stroke in path.strokes:
        points,closed=stroke.points
        bentPoints=bend(points,srcTopY,srcBotY,topSpline,botSpline,bendiness)
        gimp.VectorsBezierStroke(result,bentPoints,closed)
    pdb.gimp_image_add_vectors(image,result,0)
    result.visible=True
    
### Registration
whoiam='\n'+os.path.abspath(sys.argv[0])

register(
    "ofn-bend-path",
    'Bend a path using another path as an envelope'+whoiam,
    'Bend a path using another path as an envelope',
    'Ofnuts','Ofnuts','2017',
    'Bend...',
    '*',
    [
            (PF_IMAGE,   'image',    'Input image', None),
            (PF_VECTORS, 'path',     'Input path', None),
            (PF_VECTORS, 'envelope', 'Envelope path', None),
            (PF_SLIDER,  'bendiness','Bendiness', 100,(0, 200, 1)),
            (PF_OPTION,  'references','Reference lines', 0,[desc for desc,_ in referencesFunctions]),
            (PF_INT,     'topY',     'Top coordinate', 0),
            (PF_INT    , 'botY',     'Bottom coordinate', 0),
    ],
    [],
    bendPath,
    menu='<Vectors>/Tools'
)

main()

