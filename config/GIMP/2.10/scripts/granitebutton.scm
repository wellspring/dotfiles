;
; "Graynite" button (Granite? I don't know...)
;
; Copyright (C) 15.12.1997 Urpo Lankinen.
;  Distributed under GPL. Permission granted to distribute this script
;  with anything that has something to do with The GIMP.
;
; RCS: $Id: granitebutton.scm,v 1.3 1998/05/10 06:25:18 urpo Exp urpo $
;

(define (script-fu-granite-button text font size carvetog)
  (let* ((img (car (gimp-image-new 256 256 GRAY)))
	 (bg-layer (car (gimp-text img -1 0 0 text 10 TRUE
				     size PIXELS "*" font "*" "r" "*" "*")))
	 (text-layer (car (gimp-text img -1 0 0 text 10 TRUE
				     size PIXELS "*" font "*" "r" "*" "*")))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (text2-layer (car (gimp-text img -1 0 0 text 10 TRUE
				     size PIXELS "*" font "*" "r" "*" "*")))
	 (brd-layer
	  (car (gimp-layer-new img width height
			       GRAYA_IMAGE "border" 100 OVERLAY)))

	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))

    (gimp-image-disable-undo img)
    (gimp-layer-set-name text-layer "Text")
    (gimp-layer-set-name text2-layer "Text2")
    (gimp-layer-set-name bg-layer "Bg")
    (gimp-image-resize img width height 0 0)

    (set! amount (* height (/ 1 16)))

    ; ÄKSÖN =========================================================
    (gimp-image-set-active-layer img text-layer)
    (gimp-palette-set-foreground '(0 0 0))

    ; Add the border layer
    (gimp-image-add-layer img brd-layer 2)
    (gimp-image-set-active-layer img brd-layer)
    (gimp-edit-clear img brd-layer)

    ; do the plasma and make it gray
    (gimp-image-set-active-layer img bg-layer)
    (plug-in-plasma 1 bg-layer bg-layer 42 3.2)
    (gimp-brightness-contrast img bg-layer -60 -110)

    ; Do the borders
    (gimp-image-set-active-layer img brd-layer)
    (gimp-selection-all img)
    (gimp-selection-border img amount)
    (gimp-edit-clear img brd-layer)
    (gimp-palette-set-foreground '(10 10 10))
    (gimp-palette-set-background '(100 100 100))
    (gimp-blend img brd-layer 0 0 0 100 0 0 0 0 0   
		0 height width 0)
    (gimp-selection-none img)

    (gimp-palette-set-foreground '(0 0 0))
    (gimp-palette-set-background '(255 255 255))

    (gimp-image-set-active-layer img text-layer)

    ; Move the shadow to the correct position
    (if (eq? carvetog FALSE)
	(gimp-channel-ops-offset img text-layer 1 0 -1 1)
	(gimp-channel-ops-offset img text-layer 1 0 1 -1))

    ; Make a "carver" layer that has the text with background pattern
    (set! carver (car (gimp-layer-copy bg-layer 0)))
    (gimp-image-add-layer img carver 0)
    (gimp-layer-set-mode carver DIFFERENCE)

    ; Hide all but text2 and carver
    (gimp-layer-set-visible bg-layer 0)
    (gimp-layer-set-visible text-layer 0)
    (gimp-layer-set-visible brd-layer 0)

    ; Merge 'em, and make it darker
    (set! carver (car (gimp-image-merge-visible-layers img 0)))
    (gimp-image-set-active-layer img carver)
    (gimp-brightness-contrast img carver -25 0)

    ; revisualize the rest of the layers
    (gimp-layer-set-visible bg-layer 1)
    (gimp-layer-set-visible text-layer 1)
    (gimp-layer-set-visible brd-layer 1)

    (set! hilite (car (gimp-layer-copy carver 0)))
    (gimp-image-set-active-layer img hilite)

    (if (eq? carvetog TRUE)
	(gimp-channel-ops-offset img hilite 1 0 -2 2)
	(gimp-channel-ops-offset img hilite 1 0 2 -2))

    (gimp-brightness-contrast img hilite 50 0)

    (gimp-image-add-layer img hilite 0)
    (gimp-image-lower-layer img hilite)
    
    ; End of Action(tm) =============================================
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-enable-undo img)
    (gimp-display-new img)))

;
; Hajaa-ho!
;
(script-fu-register
 "script-fu-granite-button"
 "<Toolbox>/Xtns/Script-Fu/Logos/Granite button"
 "Makes a granite button. $Revision: 1.3 $"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "1997"
 ""
 SF-VALUE "Text String" "\"Graynite\""
 SF-VALUE "Font" "\"becker\""
 SF-VALUE "Font Size" "50"
 SF-TOGGLE "Carve" FALSE)