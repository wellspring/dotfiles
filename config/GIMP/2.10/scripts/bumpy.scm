;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; bumpy.scm
; Version 0.2 (For The Gimp 2.0 and 2.2)
; A Script-Fu that create a bumpmapped Text or Shape
;
; Copyright (C) 2005 Denis Bodor <lefinnois@lefinnois.net>
;
; This program is free software; you can redistribute it and/or 
; modify it under the terms of the GNU General Public License   
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (apply-bumpy-logo-effect	img
					basetext
					text-color
					boolrippleh
					boolripplev)

  (let* ((width (car (gimp-drawable-width basetext)))
	 (height (car (gimp-drawable-height basetext)))

	 (fond (car (gimp-layer-new   img
				      width height RGBA-IMAGE
				      "Background" 100 NORMAL-MODE)))
	 (damap (car (gimp-layer-new  img
				      width height RGB-IMAGE
				      "Map" 100 NORMAL-MODE)))
	 (innermap (car (gimp-layer-new  img
				      width height RGB-IMAGE
				      "iMap" 100 NORMAL-MODE)))
	 )
 

    (gimp-context-push)

    ; filling back with background
    (gimp-context-set-background '(255 255 255))
    (gimp-selection-none img)
    (script-fu-util-image-resize-from-layer img basetext)
    (gimp-image-add-layer img fond 1)
    (gimp-edit-clear fond)
    
    ; correcting resizing effect on background
    (gimp-context-set-foreground '(255 255 255))
    (gimp-layer-resize-to-image-size fond)
    (gimp-edit-fill fond FOREGROUND-FILL)

    ;(gimp-message (number->string width))
    ;(gimp-message (number->string height))

    ; waving/rippling the text
    (if (= boolrippleh TRUE) (plug-in-ripple 1 img basetext 26 2 0 0 0 TRUE FALSE)) ; Horiz
    (if (= boolripplev TRUE) (plug-in-ripple 1 img basetext 26 2 1 0 0 TRUE FALSE)) ; Vert
    (plug-in-gauss-rle2 1 img basetext 1 1)
       
    ; save se selection
    (gimp-selection-layer-alpha basetext)
    (set! chantext (car (gimp-selection-save img)))
    (gimp-selection-none img)

    ; creating map
    (gimp-image-add-layer img damap 1)
    (gimp-context-set-foreground '(255 255 255))
    (gimp-edit-fill damap FOREGROUND-FILL)

    (gimp-selection-load chantext)
    (gimp-selection-grow img 15)
    (gimp-selection-invert img)
    (gimp-context-set-foreground '(0 0 0))
    (gimp-edit-fill damap FOREGROUND-FILL)
    (gimp-selection-none img)
    (plug-in-gauss-rle2 1 img damap 27 27)
    (gimp-selection-load chantext)
    (gimp-edit-fill damap FOREGROUND-FILL)
    (gimp-selection-none img)
    (plug-in-gauss-rle2 1 img damap 2 2)
   
    (plug-in-plasma 1 img fond 0 1.0)
    (gimp-desaturate fond)
    (plug-in-noisify 1 img fond 1 0.2 0.2 0.2 0)
    (gimp-desaturate fond)

    ; apply bumpmap
    (plug-in-bump-map 1
		      img
		      fond
		      damap
		      135
		      42
		      33
		      0
		      0
		      0
		      0
		      1
		      0
		      LINEAR)

    ; creating second map
    (gimp-image-add-layer img innermap 1)
    (gimp-context-set-foreground '(255 255 255))
    (gimp-edit-fill innermap FOREGROUND-FILL)
    (gimp-selection-load chantext)
    (gimp-selection-shrink img 3)
    (gimp-context-set-foreground '(0 0 0))
    (gimp-edit-fill innermap FOREGROUND-FILL)
    (gimp-selection-none img)
    (plug-in-gauss-rle2 1 img innermap 6 6)
    
    (gimp-context-set-foreground text-color)
    (gimp-edit-fill basetext FOREGROUND-FILL)
    (plug-in-bump-map 1
		      img
		      basetext
		      innermap
		      135
		      32
		      5
		      0
		      0
		      0
		      0
		      1
		      1
		      LINEAR)
    (gimp-selection-load chantext)
    (gimp-selection-shrink img 2)
    (set! masktext (car (gimp-layer-create-mask basetext ADD-SELECTION-MASK)))
    (gimp-layer-add-mask basetext masktext)
    (gimp-selection-none img)
    (plug-in-gauss-rle2 1 img masktext 1 1)

    (gimp-image-raise-layer img fond)
    (gimp-image-raise-layer img fond)
    
    (gimp-context-pop)))



(define (script-fu-bumpy-logo-alpha   img
				      text-layer
				      text-color
				      boolrippleh
				      boolripplev
				      )
  (begin
    (gimp-image-undo-disable img)
    (apply-bumpy-logo-effect img text-layer text-color boolrippleh boolripplev)
    (gimp-image-undo-enable img)
    (gimp-displays-flush)))

(gimp-message-set-handler 1)

(script-fu-register 	"script-fu-bumpy-logo-alpha"
			"Bumpy..."
			"Create a bumpmapped logo"
			"Denis Bodor <lefinnois@lefinnois.net>"
			"Denis Bodor"
			"05/14/2005"
			""
			SF-IMAGE	"Image"			0
			SF-DRAWABLE	"Drawable"		0
			SF-COLOR 	"Shape Color" '(200 200 40)
			SF-TOGGLE	"Ripple Horiz." TRUE
			SF-TOGGLE	"Ripple Vert."  TRUE
			)

(script-fu-menu-register "script-fu-bumpy-logo-alpha"
			 "<Image>/Script-Fu/Alpha to Logo")

(define (script-fu-bumpy-logo		font
					text
					text-color
					boolrippleh
					boolripplev
					size
					)
  
  (let* ((img (car (gimp-image-new 256 256 RGB)))	; nouvelle image -> img
	 (border (/ size 4))
	 (text-layer (car (gimp-text-fontname img
					      -1 0 0 text border TRUE 
					      size PIXELS font)))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 )
    
    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer text)
    (apply-bumpy-logo-effect img text-layer text-color boolrippleh boolripplev)
    (gimp-image-undo-enable img)
    (gimp-display-new img)    
    ))


(script-fu-register 	"script-fu-bumpy-logo"
			"Bumpy"
			"Create a bumpmapped logo"
			"Denis Bodor <lefinnois@lefinnois.net>"
			"Denis Bodor"
			"03/31/2005"
			""
			SF-FONT "Font Name" "Blippo Heavy"
			SF-STRING "Enter your text" "BUMPY"
			SF-COLOR "Text Color" '(200 200 40)
			SF-TOGGLE "Ripple Horiz." TRUE
			SF-TOGGLE "Ripple Vert." TRUE
			SF-ADJUSTMENT "Font size (pixels)" '(150 2 1000 1 10 0 1))

(script-fu-menu-register "script-fu-bumpy-logo"
			 "<Toolbox>/Xtns/Render/Logos")
