; goose24-photo-lomo.scm
; by Dave Seaton 
; http://thermos.goose24.org

; Version 1.0 (20030602)
; Version 1.0a (2004/09) by Raymond Ostertag : Changed menu entry

; Description
;
; A script-fu script that modifies an image to resemble a photo taken
; by a Lomo Kompakt Automat camera
;

; License:
;
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
; The GNU Public License is available at
; http://www.gnu.org/copyleft/gpl.html

(define (goose24-photo-lomo image 
														drawable 
														contrast 
														saturation 
														cornercreep 
														cornerdarkness 
														cornerblur) 
	(let* (	
					(width (car (gimp-image-width image))) 
					(height (car (gimp-image-height image))) 
					(layer (car (gimp-layer-new image width height RGB-IMAGE "corners" cornerdarkness OVERLAY-MODE))) 
					(oldcolor (car (gimp-palette-get-foreground))) 
        )
		(gimp-undo-push-group-start image)
		(gimp-brightness-contrast drawable 0 contrast) 
		(gimp-hue-saturation drawable 0 0 0 saturation) 
		(gimp-image-add-layer image layer -1) 
		(gimp-layer-add-alpha layer) 
		(gimp-drawable-fill layer TRANS-IMAGE-FILL) 
		(gimp-ellipse-select image 
				(- 0 (* width (* (- cornercreep 1 ) .5))) 
				(- 0 (* height (* (- cornercreep 1) .5))) 
				(* width cornercreep) (* height cornercreep) 
				REPLACE TRUE TRUE 
				(* (/ cornerblur 100) (* (+ width height) .5)))
		(gimp-selection-invert image) 
		(gimp-palette-set-foreground '(0 0 0)) 
		(gimp-bucket-fill layer FG-BUCKET-FILL NORMAL-MODE 100 255 0 1 1) 
		(gimp-palette-set-foreground oldcolor) 
		(gimp-selection-none image) 
		(gimp-image-merge-down image layer CLIP-TO-BOTTOM-LAYER) 
		(gimp-undo-push-group-end image)
		(gimp-displays-flush)))


(script-fu-register "goose24-photo-lomo" 
										"<Image>/Script-Fu/Photo/Lomo Kompakt..." 
										"Make a photo look like a lomo" 
										"Dave Seaton" 
										"Dave Seaton" 
										"May 2003" 
										"RGB RGBA GRAY GRAYA" 
										SF-IMAGE "Image" 0 
										SF-DRAWABLE "Drawable" 0 
										SF-ADJUSTMENT "Contrast" '(30 0 80 1 5 0 0) 
										SF-ADJUSTMENT "Saturation" '(30 0 80 1 5 0 0) 
										SF-ADJUSTMENT "Fallaway" '(1.03125 1 1.25 0.03125 0.03125 1 0) 
										SF-ADJUSTMENT "Weight" '(80 0 100 1 10 0 0) 
										SF-ADJUSTMENT "Reach" '(40 20 120 1 10 0 0)) 
