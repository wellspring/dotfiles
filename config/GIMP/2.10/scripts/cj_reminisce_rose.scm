;=======================================================================
; Reminisce Rose v.1
; Author: Claire Jones
; Website: http://clairejones.deviantart.com
; Description: Produces a stylized rose color effect on images.
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

(define (script-fu-reminisce-rose    	image
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
    (gimp-layer-set-opacity navy-sub 15))

(let*	(
	(beige-screen (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name beige-screen "Beige Screen")
	(gimp-context-set-foreground '(255 229 220))
	(gimp-drawable-fill beige-screen FOREGROUND-FILL) 
    (gimp-image-add-layer image beige-screen 0)
    (gimp-layer-set-mode beige-screen 4)
    (gimp-layer-set-opacity beige-screen 15))

(let*	(
	(red-hard-light (car (gimp-layer-new-from-drawable layer image)))
	)

	(gimp-layer-set-name red-hard-light "Red Hard Light")
	(gimp-context-set-foreground '(255 0 0))
	(gimp-drawable-fill red-hard-light FOREGROUND-FILL) 
    (gimp-image-add-layer image red-hard-light 0)
    (gimp-layer-set-mode red-hard-light 3)
    (gimp-layer-set-opacity red-hard-light 15))

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
    (gimp-layer-set-opacity blue-soft 100))

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
	))))


(script-fu-register 
	"script-fu-reminisce-rose"
	"Reminisce Rose"
	"Produces a stylized rose color effect on images."
	"Claire Jones"
	"� 2008 Claire Jones"
	"September 22, 2008"
	"RGB*"
	SF-IMAGE	"Image"	    0
	SF-DRAWABLE	"Drawable"	0
)

    (script-fu-menu-register "script-fu-reminisce-rose" "<Image>/Filters/Colors/Reminisce")		
