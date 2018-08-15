;=======================================================================
; Reminisce Dusk v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Produces a stylized greenish color effect on images.
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

(define (script-fu-reminisce-dusk    	image
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
    (gimp-layer-set-opacity beige-burn 70))

(let*	(
	(orange-divide (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name orange-divide "Orange Divide")
	(gimp-context-set-foreground '(229 133 83))
	(gimp-drawable-fill orange-divide FOREGROUND-FILL) 
    (gimp-image-add-layer image orange-divide 0)
    (gimp-layer-set-mode orange-divide 15)
    (gimp-layer-set-opacity orange-divide 20))

(let*	(
	(yellow-mult (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name yellow-mult "Yellow Multiply")
	(gimp-context-set-foreground '(244 239 106))
	(gimp-drawable-fill yellow-mult FOREGROUND-FILL) 
    (gimp-image-add-layer image yellow-mult 0)
    (gimp-layer-set-mode yellow-mult 3)
    (gimp-layer-set-opacity yellow-mult 25))

(let*	(
	(purple-ext (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name purple-ext "Purple Grain Extract")
	(gimp-context-set-foreground '(203 106 244))
	(gimp-drawable-fill purple-ext FOREGROUND-FILL) 
    (gimp-image-add-layer image purple-ext 0)
    (gimp-layer-set-mode purple-ext 20)
    (gimp-layer-set-opacity purple-ext 10))		
		
(let*	(
	(blue-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name blue-soft "Blue Soft Light")
	(gimp-context-set-foreground '(158 172 201))
	(gimp-drawable-fill blue-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image blue-soft 0)
    (gimp-layer-set-mode blue-soft 19)
    (gimp-layer-set-opacity blue-soft 30))

(let*	(
	(rose-mult (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name rose-mult "Rose Multiply")
	(gimp-context-set-foreground '(234 195 184))
	(gimp-drawable-fill rose-mult FOREGROUND-FILL) 
    (gimp-image-add-layer image rose-mult 0)
    (gimp-layer-set-mode rose-mult 3)
    (gimp-layer-set-opacity rose-mult 50))


	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	))))


(script-fu-register 
	"script-fu-reminisce-dusk"
	"Reminisce Dusk"
	"Produces a stylized greenish color effect on images."
	"Claire Jones"
	"© 2008 Claire Jones"
	"September 23, 2008"
	"RGB*"
	SF-IMAGE	"Image"	    0
	SF-DRAWABLE	"Drawable"	0
)

    (script-fu-menu-register "script-fu-reminisce-dusk" "<Image>/Filters/Colors/Reminisce")		
