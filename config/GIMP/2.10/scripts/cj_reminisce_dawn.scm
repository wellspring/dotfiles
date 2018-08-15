;=======================================================================
; Reminisce Dawn v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Produces a stylized warm color effect on images.
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

(define (script-fu-reminisce-dawn    	image
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
    (gimp-layer-set-opacity desat-nml 70)

(let* 	(
    (desat-screen (car (gimp-layer-new-from-drawable layer image)))
	)
	
	(gimp-layer-set-name desat-screen "Black & White Screen")
    (gimp-image-add-layer image desat-screen 0)
	(gimp-desaturate-full desat-screen DESATURATE-LUMINOSITY)
	(gimp-layer-set-mode desat-screen 4)
    (gimp-layer-set-opacity desat-screen 50)

(let* 	(
    (color-fix (car (gimp-layer-new-from-drawable layer image)))
	)
	
	(gimp-layer-set-name color-fix "Color Fix")
    (gimp-image-add-layer image color-fix 0)
    (gimp-layer-set-mode color-fix 19)
    (gimp-layer-set-opacity color-fix 100)

(let*	(
	(navy-sub (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name navy-sub "Navy Subtract")
	(gimp-context-set-foreground '(43 38 83))
	(gimp-drawable-fill navy-sub FOREGROUND-FILL) 
    (gimp-image-add-layer image navy-sub 0)
    (gimp-layer-set-mode navy-sub 8)
    (gimp-layer-set-opacity navy-sub 10))

(let*	(
	(beige-burn (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name beige-burn "Beige Burn")
	(gimp-context-set-foreground '(255 229 220))
	(gimp-drawable-fill beige-burn FOREGROUND-FILL) 
    (gimp-image-add-layer image beige-burn 0)
    (gimp-layer-set-mode beige-burn 17)
    (gimp-layer-set-opacity beige-burn 25))

(let*	(
	(orange-burn (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name orange-burn "Orange Burn")
	(gimp-context-set-foreground '(229 133 83))
	(gimp-drawable-fill orange-burn FOREGROUND-FILL) 
    (gimp-image-add-layer image orange-burn 0)
    (gimp-layer-set-mode orange-burn 17)
    (gimp-layer-set-opacity orange-burn 30))

(let*	(
	(yellow-mult (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name yellow-mult "Yellow Multiply")
	(gimp-context-set-foreground '(244 239 106))
	(gimp-drawable-fill yellow-mult FOREGROUND-FILL) 
    (gimp-image-add-layer image yellow-mult 0)
    (gimp-layer-set-mode yellow-mult 3)
    (gimp-layer-set-opacity yellow-mult 10))

(let*	(
	(purple-merge (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name purple-merge "Purple Grain Merge")
	(gimp-context-set-foreground '(203 106 244))
	(gimp-drawable-fill purple-merge FOREGROUND-FILL) 
    (gimp-image-add-layer image purple-merge 0)
    (gimp-layer-set-mode purple-merge 21)
    (gimp-layer-set-opacity purple-merge 25))		
		
(let*	(
	(rose-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name rose-soft "Rose Soft Light")
	(gimp-context-set-foreground '(234 195 184))
	(gimp-drawable-fill rose-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image rose-soft 0)
    (gimp-layer-set-mode rose-soft 19)
    (gimp-layer-set-opacity rose-soft 40))
		
(let*	(
	(pink-mult (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name pink-mult "Pink Multiply")
	(gimp-context-set-foreground '(234 136 159))
	(gimp-drawable-fill pink-mult FOREGROUND-FILL) 
    (gimp-image-add-layer image pink-mult 0)
    (gimp-layer-set-mode pink-mult 3)
    (gimp-layer-set-opacity pink-mult 10))		


	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	))))


(script-fu-register 
	"script-fu-reminisce-dawn"
	"Reminisce Dawn"
	"Produces a stylized warm color effect on images."
	"Claire Jones"
	"© 2008 Claire Jones"
	"September 22, 2008"
	"RGB*"
	SF-IMAGE	"Image"	    0
	SF-DRAWABLE	"Drawable"	0
)

    (script-fu-menu-register "script-fu-reminisce-dawn" "<Image>/Filters/Colors/Reminisce")		
