; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
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
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
;  Comic Book Logo v0.1  04/08/98
;  by Brian McFee
;  Creates snazzy-looking text, inspired by watching a Maxx marathon :)

(define (apply-comic-logo-effect img
				 logo-layer
				 gradient
				 gradient-reverse
				 ol-width
				 ol-color
				 bg-color)
  (let* ((width (car (gimp-drawable-width logo-layer)))
	 (height (car (gimp-drawable-height logo-layer)))
	 (posx (- (car (gimp-drawable-offsets logo-layer))))
	 (posy (- (cadr (gimp-drawable-offsets logo-layer))))
	 (bg-layer (car (gimp-layer-new img width height RGBA-IMAGE
					"Background" 100 NORMAL-MODE)))
	 (white-layer (car (gimp-layer-copy logo-layer 1)))
	 (black-layer (car (gimp-layer-copy logo-layer 1))))

    (gimp-context-push)

    (script-fu-util-image-resize-from-layer img logo-layer)
    (gimp-image-add-layer img bg-layer 1)
    (gimp-image-add-layer img white-layer 1)
    (gimp-layer-translate white-layer posx posy)
    (gimp-drawable-set-name white-layer "White")
    (gimp-image-add-layer img black-layer 1)
    (gimp-layer-translate black-layer posx posy)
    (gimp-drawable-set-name black-layer "Black")
  
    (gimp-selection-all img)
    (gimp-context-set-background bg-color)
    (gimp-edit-fill bg-layer BACKGROUND-FILL)
    (gimp-selection-none img)

    (gimp-layer-set-preserve-trans white-layer TRUE)
    (gimp-context-set-background ol-color)
    (gimp-selection-all img)
    (gimp-edit-fill white-layer BACKGROUND-FILL)
    (gimp-layer-set-preserve-trans white-layer FALSE)
    (plug-in-spread 1 img white-layer (* 3 ol-width) (* 3 ol-width))
    (plug-in-gauss-rle 1 img white-layer (* 2 ol-width) 1 1)
    (plug-in-threshold-alpha 1 img white-layer 0)
    (gimp-layer-set-preserve-trans white-layer TRUE)
    (gimp-edit-fill white-layer BACKGROUND-FILL)
    (gimp-selection-none img)

    (gimp-context-set-background '(0 0 0))
    (gimp-layer-set-preserve-trans black-layer TRUE)
    (gimp-selection-all img)
    (gimp-edit-fill black-layer BACKGROUND-FILL)
    (gimp-selection-none img)
    (gimp-layer-set-preserve-trans black-layer FALSE)
    (plug-in-gauss-rle 1 img black-layer ol-width 1 1)
    (plug-in-threshold-alpha 1 img black-layer 0)

    (gimp-context-set-gradient gradient)
    (gimp-layer-set-preserve-trans logo-layer TRUE)
    (gimp-selection-all img)

    (gimp-edit-blend logo-layer CUSTOM-MODE NORMAL-MODE
		     GRADIENT-LINEAR 100 0 REPEAT-NONE gradient-reverse
		     FALSE 0 0 TRUE
		     0 (* height 0.3) 0 (* height 0.78))

    (plug-in-noisify 1 img logo-layer 0 0.20 0.20 0.20 0.20)
    (gimp-selection-none img)
    (gimp-layer-set-preserve-trans logo-layer FALSE)
    (gimp-brightness-contrast logo-layer 0 30)
    (plug-in-threshold-alpha 1 img logo-layer 60)
    (gimp-image-set-active-layer img logo-layer)

    (gimp-context-pop)))

(define (script-fu-comic-logo-alpha img
				    logo-layer
				    gradient
				    gradient-reverse
				    ol-width
				    ol-color
				    bg-color)
  (begin
    (gimp-image-undo-group-start img)
    (apply-comic-logo-effect img logo-layer
			     gradient gradient-reverse
			     ol-width ol-color bg-color)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)))

(script-fu-register "script-fu-comic-logo-alpha"
		    _"Comic Boo_k..."
		    "Comic-book Style Logos"
		    "Brian McFee <keebler@wco.com>"
		    "Brian McFee"
		    "April 1998"
		    "RGBA"
                    SF-IMAGE       "Image"            0
                    SF-DRAWABLE    "Drawable"         0
		    SF-GRADIENT   _"Gradient"         "Incandescent"
		    SF-TOGGLE     _"Gradient reverse" FALSE
		    SF-ADJUSTMENT _"Outline size"     '(5 1 100 1 10 0 1)
		    SF-COLOR      _"Outline color"    '(255 255 255)
		    SF-COLOR      _"Background color" '(255 255 255))

(script-fu-menu-register "script-fu-comic-logo-alpha"
			 _"<Image>/Script-Fu/Alpha to Logo")


(define (script-fu-comic-logo text
			      size
			      font
			      gradient
			      gradient-reverse
			      ol-width
			      ol-color
			      bg-color)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
         (border (/ size 4))
	 (text-layer (car (gimp-text-fontname
			   img -1 0 0 text border TRUE size PIXELS font))))
    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer text)
    (apply-comic-logo-effect img text-layer gradient gradient-reverse
			     ol-width ol-color bg-color)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

(script-fu-register "script-fu-comic-logo"
		    _"Comic Boo_k..."
		    "Comic-book Style Logos"
		    "Brian McFee <keebler@wco.com>"
		    "Brian McFee"
		    "April 1998"
		    ""
		    SF-STRING     _"Text"               "Moo"
		    SF-ADJUSTMENT _"Font size (pixels)" '(85 2 1000 1 10 0 1)
		    SF-FONT       _"Font"               "Tribeca"
		    SF-GRADIENT   _"Gradient"           "Incandescent"
		    SF-TOGGLE     _"Gradient reverse"   FALSE
		    SF-ADJUSTMENT _"Outline size"       '(5 1 100 1 10 0 1)
		    SF-COLOR      _"Outline color"      '(255 255 255)
		    SF-COLOR      _"Background color"   '(255 255 255))

(script-fu-menu-register "script-fu-comic-logo"
			 _"<Toolbox>/Xtns/Script-Fu/Logos")
