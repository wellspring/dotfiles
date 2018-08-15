;  basic3-logo.scm - draw the specified text over a background with a 
;    drop shadow and a cut side.  Majority of the code was shamelessly 
;    stolen from Spencer Kimball's basic2-logo.scm script.
;
; Copyright (C) 1998 by Jaroslav Benkovsky <benkovsk@pha.pvt.cz>
;    - changed highlight to cut-side (changed its signum)
;    - shadow and cut-side offsets are computed relative to text size
;    - cut-side color and blending are parameters
;    - changed default values :)
;
; Original code is
; Copyright (C) 1998 by Spencer Kimball
; 
; Version: 0.1
;
; Changed on June 15, 2000 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.1.26
;
; Changed on December 6, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.2
;
; Changed on January 29, 2004 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 2.0pre3

(define (color-highlight color)
  (let ((r (car color))
	(g (cadr color))
	(b (caddr color)))
    (set! r (+ r (* (- 255 r) 0.75)))
    (set! g (+ g (* (- 255 g) 0.75)))
    (set! b (+ b (* (- 255 b) 0.75)))
    (list r g b)))

(define (script-fu-basic3-logo text size font bg-color text-color provide-cut-color? cut-color blend?)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
	 (text-layer (car (gimp-text img -1 0 0 text 10 TRUE size PIXELS "*" font "*" "*" "*" "*" "*" "*")))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (bg-layer (car (gimp-layer-new img width height RGB-IMAGE "Background" 100 NORMAL-MODE)))
	 (highlight-layer (car (gimp-layer-copy text-layer TRUE)))
	 (shadow-layer (car (gimp-layer-new img width height RGBA-IMAGE "Shadow" 100 MULTIPLY-MODE)))
	 (highlight-ofs (+ (/ size 100) 1))
	 (shadow-ofs (+ (/ size 50) 1))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))
    (gimp-image-undo-disable img)
    (gimp-image-resize img width height 0 0)
    (gimp-image-add-layer img bg-layer 1)
    (gimp-image-add-layer img shadow-layer 1)
    (gimp-image-add-layer img highlight-layer 1)
    (gimp-palette-set-background text-color)
    (gimp-layer-set-preserve-trans text-layer TRUE)
    (gimp-edit-fill text-layer BACKGROUND-FILL)
    (gimp-edit-clear shadow-layer)
    (if (= provide-cut-color? FALSE)
	(gimp-palette-set-background (color-highlight text-color))
	(gimp-palette-set-background cut-color))
    (gimp-layer-set-preserve-trans highlight-layer TRUE)
    (gimp-edit-fill highlight-layer BACKGROUND-FILL)
    (gimp-palette-set-background bg-color)
    (gimp-drawable-fill bg-layer BACKGROUND-FILL)
    (gimp-selection-layer-alpha text-layer)
    (gimp-palette-set-background '(0 0 0))
    (gimp-selection-feather img 7.5)
    (gimp-edit-fill shadow-layer BACKGROUND-FILL)
    (gimp-selection-none img)
    (gimp-palette-set-foreground '(255 255 255))
    (if (= blend? TRUE)
	(gimp-edit-blend text-layer FG-BG-RGB-MODE MULTIPLY-MODE GRADIENT-RADIAL 100 20 REPEAT-NONE FALSE FALSE 0 0 FALSE 0 0 0 0 width height))
    (gimp-layer-translate shadow-layer shadow-ofs shadow-ofs)
    (gimp-layer-translate highlight-layer highlight-ofs highlight-ofs)
    (gimp-drawable-set-name text-layer text)
    (gimp-drawable-set-name highlight-layer "Highlight")
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

(script-fu-register "script-fu-basic3-logo"
		    "<Toolbox>/Xtns/Script-Fu/Logos/Basic III..."
		    "Creates a simple logo with a shadow and a cut side"
		    "Jaroslav Benkovsky <benkovsk@pha.pvt.cz>"
		    "Spencer Kimball, Jaroslav Benkovsky"
		    "August 1998"
		    ""
		    SF-STRING "Text String" "Scanner"
		    SF-VALUE  "Font Size (in pixels)" "100"
		    SF-FONT   "Font" "Charter"
		    SF-COLOR  "Background Color" '(255 255 255)
		    SF-COLOR  "Text Color" '(66 3 122)
			SF-TOGGLE "Provide Cut Color" TRUE
		    SF-COLOR  "Cut Color" '(255 255 255)
			SF-TOGGLE "Blend" TRUE)

; End of file basic3-logo.scm
