;=======================================================================
; Reminisce Storm v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Produces a stylized yellow-green color effect on images.
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

(define (script-fu-reminisce-storm    	image
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
    (gimp-layer-set-opacity navy-sub 5))

(let*	(
	(beige-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name beige-soft "Beige Soft Light")
	(gimp-context-set-foreground '(255 229 220))
	(gimp-drawable-fill beige-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image beige-soft 0)
    (gimp-layer-set-mode beige-soft 19)
    (gimp-layer-set-opacity beige-soft 60))

(let*	(
	(orange-burn (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name orange-burn "Orange Burn")
	(gimp-context-set-foreground '(229 133 83))
	(gimp-drawable-fill orange-burn FOREGROUND-FILL) 
   	(gimp-image-add-layer image orange-burn 0)
    (gimp-layer-set-mode orange-burn 17)
    (gimp-layer-set-opacity orange-burn 35))

(let*	(
	(yellow-merge (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name yellow-merge "Yellow Grain Merge")
	(gimp-context-set-foreground '(244 239 106))
	(gimp-drawable-fill yellow-merge FOREGROUND-FILL) 
    (gimp-image-add-layer image yellow-merge 0)
    (gimp-layer-set-mode yellow-merge 21)
    (gimp-layer-set-opacity yellow-merge 15))	
		
(let*	(
	(rose-burn (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name rose-burn "Rose Burn")
	(gimp-context-set-foreground '(234 195 184))
	(gimp-drawable-fill rose-burn FOREGROUND-FILL) 
    (gimp-image-add-layer image rose-burn 0)
    (gimp-layer-set-mode rose-burn 17)
    (gimp-layer-set-opacity rose-burn 20))
		
(let*	(
	(teal-mult (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name teal-mult "Teal Burn")
	(gimp-context-set-foreground '(0 141 154))
	(gimp-drawable-fill teal-mult FOREGROUND-FILL) 
    (gimp-image-add-layer image teal-mult 0)
    (gimp-layer-set-mode teal-mult 3)
    (gimp-layer-set-opacity teal-mult 15))		
		
	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	))))


(script-fu-register 
	"script-fu-reminisce-storm"
	"Reminisce Storm"
	"Produces a stylized yellow-green color effect on images."
	"Claire Jones"
	"� 2008 Claire Jones"
	"September 23, 2008"
	"RGB*"
	SF-IMAGE	"Image"	    0
	SF-DRAWABLE	"Drawable"	0
)

    (script-fu-menu-register "script-fu-reminisce-storm" "<Image>/Filters/Colors/Reminisce")		
