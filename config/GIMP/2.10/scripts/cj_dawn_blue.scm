;=======================================================================
; Dawn Blue  v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Lightens and mutes colours while applying a blue filter to 
;                   dark photos and images.
;
; © 2008 Claire Jones
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;=======================================================================

(define (script-fu-dawn-blue    	image
									layer
	)

	(gimp-selection-none image)
	(gimp-image-undo-group-start image)	

(let* 	(
	(old-fg-color (car (gimp-palette-get-foreground)))
    (desat-nml (car (gimp-layer-new-from-drawable layer image)))
	)
	
	(gimp-layer-set-name desat-nml "Desaturated Layer")
    (gimp-image-add-layer image desat-nml 0)
	(gimp-desaturate-full desat-nml DESATURATE-LUMINOSITY)
    (gimp-layer-set-opacity desat-nml 25)
		
(let* 	(
    (desat-screen (car (gimp-layer-new-from-drawable layer image)))
	)
	
	(gimp-layer-set-name desat-screen "Black & White Screen")
    (gimp-image-add-layer image desat-screen 0)
	(gimp-desaturate-full desat-screen DESATURATE-LUMINOSITY)
	(gimp-layer-set-mode desat-screen 4)
   	(gimp-layer-set-opacity desat-screen 100)		

(let*	(
	(navy-sub (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name navy-sub "Navy Subtract")
	(gimp-context-set-foreground '(43 38 83))
	(gimp-drawable-fill navy-sub FOREGROUND-FILL) 
    (gimp-image-add-layer image navy-sub 0)
    (gimp-layer-set-mode navy-sub 8)
    (gimp-layer-set-opacity navy-sub 30))
		
(let*	(
	(teal-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name teal-soft "Teal Soft Light")
	(gimp-context-set-foreground '(100 207 183))
	(gimp-drawable-fill teal-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image teal-soft 0)
    (gimp-layer-set-mode teal-soft 19)
    (gimp-layer-set-opacity teal-soft 25))	
	
(let*	(
	(yellow-div (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name yellow-div "Yellow Divide")
	(gimp-context-set-foreground '(244 239 106))
	(gimp-drawable-fill yellow-div FOREGROUND-FILL) 
    (gimp-image-add-layer image yellow-div 0)
    (gimp-layer-set-mode yellow-div 15)
    (gimp-layer-set-opacity yellow-div 25))	

(let*	(
	(beige-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name beige-soft "Beige Soft Light")
	(gimp-context-set-foreground '(251 236 222))
	(gimp-drawable-fill beige-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image beige-soft 0)
    (gimp-layer-set-mode beige-soft 19)
    (gimp-layer-set-opacity beige-soft 95))		
		
		
	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	)))


(script-fu-register 
	"script-fu-dawn-blue"
	"Dawn Blue"
	"Lightens and mutes colours while applying a blue filter to dark photos and images."
	"Claire Jones"
	"© 2008 Claire Jones"
	"September 30, 2008"
	"RGB*"
	SF-IMAGE	"Image"	        0
	SF-DRAWABLE	"Drawable"		0
)

(script-fu-menu-register "script-fu-dawn-blue" "<Image>/Filters/Colors/Dawn")		
