;; scanner-logo.scm  -*-scheme-*-
;; draw the specified text with gradient over a background 
;; with a drop shadow and a cut side.  Majority of the code was shamelessly 
;; stolen from Spencer Kimball's basic2-logo.scm script.
;;
;; This is a version compatible with GIMP v1.1., formerly basic3-logo.scm.
;;
;; Copyright (C) 1999 by Jaroslav Benkovsky <Edheldil@atlas.cz>
;; Original code is Copyright (C) 1998 by Spencer Kimball
;; Released under General Public License (GPL)
;;
;; Changes:
;;   - changed highlight to cut-side (changed its signum)
;;   - shadow and cut-side offsets are computed relative to text size
;;   - cut-side color and blending are parameters
;;   - changed default values :)
;;   - select gradient
;;   - adapted to GIMP 1.1
;;   - adapted to GIMP 1.1.22
;;
;; RCS: $Id: scanner-logo.scm,v 1.3 2000/06/26 01:01:47 benkovsk Exp $


(define (script-fu-scanner-logo text size font text-color use-gradient? text-gradient cut-color bg-color)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
	 (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (bg-layer (car (gimp-layer-new img width height RGB_IMAGE "Background" 100 NORMAL)))
	 (cut-layer (car (gimp-layer-copy text-layer TRUE)))
	 (shadow-layer (car (gimp-layer-new img width height RGBA_IMAGE "Shadow" 100 MULTIPLY)))
	 (cut-ofs (+ (/ size 100) 1))
	 (shadow-ofs (+ (/ size 50) 1))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))

    (gimp-image-undo-disable img)
    (gimp-image-resize img width height 0 0)
    (gimp-image-add-layer img bg-layer 1)
    (gimp-image-add-layer img shadow-layer 1)
    (gimp-image-add-layer img cut-layer 1)

    (gimp-edit-clear shadow-layer)

    (gimp-palette-set-background cut-color)
    (gimp-layer-set-preserve-trans cut-layer TRUE)
    (gimp-edit-fill cut-layer BG-IMAGE-FILL)

    (gimp-palette-set-background bg-color)
    (gimp-drawable-fill bg-layer BG-IMAGE-FILL)

    (gimp-selection-layer-alpha text-layer)
    (gimp-palette-set-background '(0 0 0))
    (gimp-selection-feather img 7.5)
    (gimp-edit-fill shadow-layer BG-IMAGE-FILL)
    (gimp-selection-none img)

    (gimp-palette-set-background text-color)
    (gimp-layer-set-preserve-trans text-layer TRUE)
    (gimp-edit-fill text-layer BG-IMAGE-FILL)

    (if (= use-gradient? TRUE)
	(begin
	  (gimp-layer-set-preserve-trans text-layer TRUE)
	  (gimp-gradients-set-active text-gradient)
	  (gimp-blend text-layer CUSTOM NORMAL RADIAL 100 20 REPEAT-NONE
		      FALSE 0 0 0 0 width height)))

    (gimp-layer-translate shadow-layer shadow-ofs shadow-ofs)
    (gimp-layer-translate cut-layer cut-ofs cut-ofs)
    (gimp-layer-set-name text-layer text)
    (gimp-layer-set-name cut-layer "Cut")
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

(script-fu-register "script-fu-scanner-logo"
		    "<Toolbox>/Xtns/Script-Fu/Logos/Scanner"
		    "Creates a simple logo with a gradient text, a shadow and a cut side"
		    "Jaroslav Benkovsky <Edheldil@atlas.cz>"
		    "Spencer Kimball, Jaroslav Benkovsky"
		    "June 2000"
		    ""
		    SF-STRING   "Text String"      "Scanner"
		    SF-ADJUSTMENT "Font Size (pixels)" '(100 2 1000 1 10 0 1)
		    SF-FONT     "Font"             "-*-charter-bold-i-normal-*-*-1000-*-*-p-*-*-*"
		    SF-COLOR    "Text Color"       '(66 3 122)
                    SF-TOGGLE   "Use Gradient"     TRUE
                    SF-GRADIENT "Gradient"         "Tropical_Colors"
		    SF-COLOR    "Cut Color"        '(255 255 255)
		    SF-COLOR    "Background Color" '(255 255 255))

; End of file scanner-logo.scm