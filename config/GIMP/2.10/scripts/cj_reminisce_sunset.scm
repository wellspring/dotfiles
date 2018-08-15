;=======================================================================
; Reminisce Sunset v.1
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

(define (script-fu-reminisce-sunset    	image
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
    (gimp-layer-set-opacity beige-soft 75))

(let*	(
	(purple-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name purple-soft "Purple Soft Light")
	(gimp-context-set-foreground '(203 106 244))
	(gimp-drawable-fill purple-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image purple-soft 0)
    (gimp-layer-set-mode purple-soft 19)
    (gimp-layer-set-opacity purple-soft 50))
		
(let*	(
	(orange-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name orange-soft "Orange Soft Light")
	(gimp-context-set-foreground '(229 133 83))
	(gimp-drawable-fill orange-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image orange-soft 0)
    (gimp-layer-set-mode orange-soft 19)
    (gimp-layer-set-opacity orange-soft 50))		
		
(let*	(
	(yellow-multiply (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name yellow-multiply "Yellow Multiply")
	(gimp-context-set-foreground '(243 211 147))
	(gimp-drawable-fill yellow-multiply FOREGROUND-FILL) 
    (gimp-image-add-layer image yellow-multiply 0)
    (gimp-layer-set-mode yellow-multiply 3)
    (gimp-layer-set-opacity yellow-multiply 40))	

(let*	(
	(brown-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name brown-soft "Brown Soft Light")
	(gimp-context-set-foreground '(119 69 43))
	(gimp-drawable-fill brown-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image brown-soft 0)
    (gimp-layer-set-mode brown-soft 19)
    (gimp-layer-set-opacity brown-soft 50))		

(let*	(
	(teal-burn (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name teal-burn "Teal Burn")
	(gimp-context-set-foreground '(155 224 212))
	(gimp-drawable-fill teal-burn FOREGROUND-FILL) 
    (gimp-image-add-layer image teal-burn 0)
    (gimp-layer-set-mode teal-burn 17)
    (gimp-layer-set-opacity teal-burn 100))

(let*	(
	(blue-soft (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name blue-soft "Blue Soft Light")
	(gimp-context-set-foreground '(158 172 201))
	(gimp-drawable-fill blue-soft FOREGROUND-FILL) 
    (gimp-image-add-layer image blue-soft 0)
    (gimp-layer-set-mode blue-soft 19)
    (gimp-layer-set-opacity blue-soft 60))

(let*	(
	(rose-burn (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name rose-burn "Rose Burn")
	(gimp-context-set-foreground '(234 195 184))
	(gimp-drawable-fill rose-burn FOREGROUND-FILL) 
    (gimp-image-add-layer image rose-burn 0)
    (gimp-layer-set-mode rose-burn 17)
    (gimp-layer-set-opacity rose-burn 100))


	(gimp-palette-set-foreground old-fg-color)
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	))))


(script-fu-register 
	"script-fu-reminisce-sunset"
	"Reminisce Sunset"
	"Produces a stylized warm color effect on images."
	"Claire Jones"
	"© 2008 Claire Jones"
	"September 22, 2008"
	"RGB*"
	SF-IMAGE	"Image"	    0
	SF-DRAWABLE	"Drawable"	0
)

    (script-fu-menu-register "script-fu-reminisce-sunset" "<Image>/Filters/Colors/Reminisce")		
