;=======================================================================
; Dawn Twilight  v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Lightens and mutes colours while applying a yellow filter to 
;                   dark photos and images.
;
; � 2008 Claire Jones
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

(define (script-fu-dawn-twilight    	image
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
    (gimp-layer-set-opacity navy-sub 25))
		
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
	(yellow-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name yellow-soft "Yellow Soft Light")
	(gimp-context-set-foreground '(244 239 106))
	(gimp-drawable-fill yellow-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image yellow-soft 0)
    (gimp-layer-set-mode yellow-soft 19)
    (gimp-layer-set-opacity yellow-soft 20))	

(let*	(
	(rose-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name rose-soft "Rose Soft Light")
	(gimp-context-set-foreground '(234 195 184))
	(gimp-drawable-fill rose-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image rose-soft 0)
    (gimp-layer-set-mode rose-soft 19)
    (gimp-layer-set-opacity rose-soft 80))		
		
		
	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	)))


(script-fu-register 
	"script-fu-dawn-twilight"
	"Dawn Twilight"
	"Lightens and mutes colours while applying a yellow filter to dark photos and images."
	"Claire Jones"
	"� 2008 Claire Jones"
	"September 3, 2008"
	"RGB*"
	SF-IMAGE	"Image"	        0
	SF-DRAWABLE	"Drawable"		0
)

(script-fu-menu-register "script-fu-dawn-twilight" "<Image>/Filters/Colors/Dawn")		
