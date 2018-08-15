; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

(define (set-pt arr i x y) 
(aset arr (* i 2) x)
(aset arr (+ (* i 2) 1) y)
)
(define (glass-sketch)
  (let*
	((a (cons-array 18 'byte)))
	(set-pt a 0 0 0)
	(set-pt a 1 127 32)
	(set-pt a 2 255 64)
	a))
(define (glass inimage indraw thickness displace delete)


(gimp-context-set-foreground '( 255 255 255))
(let*(
(theImage inimage)
(theDraw indraw)

(height (car (gimp-image-height theImage)))
(width (car (gimp-image-width theImage)))
(layer2 (car (gimp-layer-copy theDraw 1)))
(layer3 (car (gimp-layer-new theImage width height 1 "layer3" 100 0)))
)
(gimp-image-undo-group-start theImage)
(gimp-image-add-layer theImage layer2 -1)

(gimp-drawable-fill layer3 3)
(gimp-image-add-layer theImage layer3 -1)
(gimp-selection-layer-alpha layer2 )
(gimp-edit-bucket-fill layer2 0 0 100 0 0 0 0)
(gimp-context-set-foreground '( 132 106 79))
(gimp-edit-bucket-fill layer3 0 0 100 0 0 0 0)
(gimp-selection-none theImage)
(plug-in-gauss 1 theImage layer2 5 5 1)
(plug-in-bump-map 1 theImage layer3 layer2 135 45 (+ thickness 2) 0 0 0 0 0 0 0)
(gimp-selection-layer-alpha layer3 )
(gimp-selection-shrink theImage thickness)
(gimp-selection-feather theImage (- thickness 1))
(gimp-curves-spline layer3 4 6 (glass-sketch))
(let*(
(layer4 (car (gimp-layer-copy layer3 1)))
)
(gimp-image-add-layer theImage layer4 -1)
(gimp-edit-clear layer3)
(gimp-selection-none theImage)
(gimp-invert layer4)
(plug-in-gauss 1 theImage layer3 (+ 2 displace) (+ 2 displace) 1)
(gimp-drawable-offset layer3 1 0 displace displace)
(gimp-hue-saturation layer4 0 0 0 -100)
(gimp-image-remove-layer theImage layer2)
(gimp-drawable-set-visible theDraw 0)
(if (= delete TRUE) (gimp-image-remove-layer theImage theDraw))
(gimp-layer-set-mode layer3 BURN-MODE)
(gimp-layer-set-opacity layer3 86)
(gimp-image-undo-group-end theImage)
(gimp-displays-flush)
)))
(script-fu-register 	"glass"
			"<Image>/Filters/Artistic/Glass"
			"Turns a layer into glass"
			"Karl Ward"
			"Karl Ward"
			"May 2008"
			"RGBA"
			SF-IMAGE      	"SF-IMAGE" 0
			SF-DRAWABLE   	"SF-DRAWABLE" 0
			SF-ADJUSTMENT	"Glass Thickness" '(3 1 10 1 2 0 1)
			SF-ADJUSTMENT	"Shadow Displacment" '(12 5 24 1 2 0 1)
			SF-TOGGLE	"Delete original layer" TRUE
			
)
				
