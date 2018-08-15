;
; "Graynite" slab (Granite? I don't know...)
;
; Based on "Graynite button" script. This uses BumpMaps (Read: Much cooler!)
;
; Copyright (C) 8.3.1998 by Urpo Lankinen.
; Original version (granitebutton.scm):
;     Copyright (C) 15.12.1997 by Urpo Lankinen.
;  Distributed under GPL. Permission granted to distribute this script
;  with anything that has something to do with The GIMP.
;
; RCS: $Id: graniteslab.scm,v 1.1 1998/05/10 06:25:46 urpo Exp urpo $

(define (script-fu-granite-slab text font size slabedge slabdepth textdepth carvetog)
  (let* ((img (car (gimp-image-new 256 256 GRAY)))
	 (bg-layer (car (gimp-text img -1 0 0 text 10 TRUE
				     size PIXELS "*" font "*" "r" "*" "*")))
	 (text-layer (car (gimp-text img -1 0 0 text 10 TRUE
				     size PIXELS "*" font "*" "r" "*" "*")))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (white-layer (car (gimp-text img -1 0 0 text 10 TRUE
				     size PIXELS "*" font "*" "r" "*" "*")))
	 (brd-layer
	  (car (gimp-layer-new img width height
			       GRAYA_IMAGE "border" 100 NORMAL)))

	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))

    (gimp-image-disable-undo img)
    (gimp-layer-set-name text-layer "Text")
    (gimp-layer-set-name white-layer "White")
    (gimp-image-lower-layer img white-layer)
    (gimp-layer-set-name bg-layer "Bg")
    (gimp-image-resize img width height 0 0)

;    (set! amount (* height (/ 1 16)))

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
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-bucket-fill img brd-layer FG-BUCKET-FILL NORMAL 100 0 0 0 0)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-selection-border img slabedge)
    (gimp-bucket-fill img brd-layer FG-BUCKET-FILL NORMAL 100 0 0 0 0)
    (gimp-selection-none img)

    (gimp-layer-set-visible bg-layer 0)
    (gimp-layer-set-visible brd-layer 1)
    (gimp-layer-set-visible text-layer 0)
    (gimp-layer-set-visible white-layer 0)

    ; OK, the borders are in order. Bump-map? Just say YES!
    (gimp-layer-set-visible bg-layer 1)
    (gimp-image-set-active-layer img bg-layer)
    (plug-in-bump-map 1 img bg-layer brd-layer
		      135 45 slabdepth 0 0 0 0 1 0 LINEAR)
;    (gimp-layer-delete brd-layer)
    ; Strange. the previous line crashes GIMP. Hmmm...

    ; Do the "Black text on white bg" trick

    (gimp-layer-set-visible bg-layer 0)
    (gimp-layer-set-visible brd-layer 0)
    (gimp-layer-set-visible text-layer 1)
    (gimp-layer-set-visible white-layer 1)

    (gimp-image-set-active-layer img white-layer)
    (gimp-selection-all img)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-bucket-fill img white-layer FG-BUCKET-FILL NORMAL 100 0 0 0 0)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-selection-none img)
    (set! text-layer
	  (car (gimp-image-merge-visible-layers img EXPAND-AS-NECESSARY)))
    (plug-in-blur 1 img text-layer)

    (plug-in-bump-map 1 img bg-layer text-layer 135 45 textdepth 0 0 0 0 1
		      (if (eq? carvetog FALSE) 1 0) LINEAR)

    (gimp-layer-set-visible bg-layer 1)
    (gimp-layer-set-visible text-layer 0)

    ; End of Action(tm) =============================================
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-enable-undo img)
    (gimp-display-new img)))

;
; Hajaa-ho!
;
(script-fu-register
 "script-fu-granite-slab"
 "<Toolbox>/Xtns/Script-Fu/Logos/Granite slab"
 "Makes a granite slab with a text. $Revision: 1.1 $"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "1998"
 ""
 SF-VALUE "Text String" "\"Graynite\""
 SF-VALUE "Font" "\"becker\""
 SF-VALUE "Font Size" "50"
 SF-VALUE "Edge of the slab" "5"
 SF-VALUE "Depth of the slab" "3"
 SF-VALUE "Depth of the text" "5"
 SF-TOGGLE "Carve" FALSE)