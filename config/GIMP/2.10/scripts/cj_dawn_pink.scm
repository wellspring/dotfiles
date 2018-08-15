;=======================================================================
; Dawn Pink  v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Lightens, mutes colours and applies a pink filter to dark 
;                   photos and images.
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

(define (script-fu-dawn-pink    	image
									layer
	)

	(gimp-selection-none image)
	(gimp-image-undo-group-start image)	

(let* 	(
	(old-fg-color (car (gimp-palette-get-foreground)))
    (desat-ovl (car (gimp-layer-new-from-drawable layer image)))
	)
	
	(gimp-layer-set-name desat-ovl "Desaturated Overlay")
    (gimp-image-add-layer image desat-ovl 0)
	(gimp-desaturate-full desat-ovl DESATURATE-LUMINOSITY)
	(gimp-layer-set-mode desat-ovl 5)	
    (gimp-layer-set-opacity desat-ovl 25)
		
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
    (gimp-layer-set-opacity navy-sub 20))
			
(let*	(
	(teal-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name teal-soft "Teal Soft LIght")
	(gimp-context-set-foreground '(100 207 183))
	(gimp-drawable-fill teal-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image teal-soft 0)
    (gimp-layer-set-mode teal-soft 19)
    (gimp-layer-set-opacity teal-soft 20))		

(let*	(
	(pink-merge (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name pink-merge "Pink Grain Merge")
	(gimp-context-set-foreground '(234 136 159))
	(gimp-drawable-fill pink-merge FOREGROUND-FILL) 
    (gimp-image-add-layer image pink-merge 0)
    (gimp-layer-set-mode pink-merge 21)
    (gimp-layer-set-opacity pink-merge 20))	
	
(let*	(
	(rose-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name rose-soft "Rose Soft Light")
	(gimp-context-set-foreground '(234 195 184))
	(gimp-drawable-fill rose-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image rose-soft 0)
    (gimp-layer-set-mode rose-soft 19)
    (gimp-layer-set-opacity rose-soft 100))		
		
		
	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	)))


(script-fu-register 
	"script-fu-dawn-pink"
	"Dawn Pink"
	"Lightens, mutes colours and applies a pink filter to dark photos and images."
	"Claire Jones"
	"© 2008 Claire Jones"
	"September 30, 2008"
	"RGB*"
	SF-IMAGE	"Image"	        0
	SF-DRAWABLE	"Drawable"		0
)

(script-fu-menu-register "script-fu-dawn-pink" "<Image>/Filters/Colors/Dawn")		
