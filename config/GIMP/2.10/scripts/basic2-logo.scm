;  HIGHLIGHT-DROP-SHADOW-LOGO
;  draw the specified text over a background with a drop shadow and a highlight

(define (color-highlight color)
  (let ((r (car color))
	(g (cadr color))
	(b (caddr color)))

    (set! r (+ r (* (- 255 r) 0.75)))
    (set! g (+ g (* (- 255 g) 0.75)))
    (set! b (+ b (* (- 255 b) 0.75)))
    (list r g b)))

(define (apply-basic2-logo-effect img
				  logo-layer
				  bg-color
				  text-color)
  (let* ((width (car (gimp-drawable-width logo-layer)))
	 (height (car (gimp-drawable-height logo-layer)))
	 (posx (- (car (gimp-drawable-offsets logo-layer))))
	 (posy (- (cadr (gimp-drawable-offsets logo-layer))))
	 (bg-layer (car (gimp-layer-new img width height RGB-IMAGE "Background" 100 NORMAL-MODE)))
	 (highlight-layer (car (gimp-layer-copy logo-layer TRUE)))
	 (shadow-layer (car (gimp-layer-new img width height RGBA-IMAGE "Shadow" 100 MULTIPLY-MODE))))

    (gimp-context-push)

    (gimp-selection-none img)
    (script-fu-util-image-resize-from-layer img logo-layer)
    (gimp-image-add-layer img bg-layer 1)
    (gimp-image-add-layer img shadow-layer 1)
    (gimp-image-add-layer img highlight-layer 1)
    (gimp-context-set-foreground text-color)
    (gimp-layer-set-preserve-trans logo-layer TRUE)
    (gimp-edit-fill logo-layer FOREGROUND-FILL)
    (gimp-edit-clear shadow-layer)
    (gimp-context-set-foreground (color-highlight text-color))
    (gimp-layer-set-preserve-trans highlight-layer TRUE)
    (gimp-edit-fill highlight-layer FOREGROUND-FILL)
    (gimp-context-set-background bg-color)
    (gimp-drawable-fill bg-layer BACKGROUND-FILL)
    (gimp-selection-layer-alpha logo-layer)
    (gimp-context-set-background '(0 0 0))
    (gimp-selection-feather img 7.5)
    (gimp-edit-fill shadow-layer BACKGROUND-FILL)
    (gimp-selection-none img)
    (gimp-context-set-foreground '(255 255 255))

    (gimp-edit-blend logo-layer FG-BG-RGB-MODE MULTIPLY-MODE
		     GRADIENT-RADIAL 100 20 REPEAT-NONE FALSE
		     FALSE 0 0 TRUE
		     0 0 width height)

    (gimp-layer-translate shadow-layer 3 3)
    (gimp-layer-translate highlight-layer (- posx 2) (- posy 2))
    (gimp-drawable-set-name highlight-layer "Highlight")

    (gimp-context-pop)))

(define (script-fu-basic2-logo-alpha img
				     logo-layer
				     bg-color
				     text-color)
  (begin
    (gimp-image-undo-group-start img)
    (apply-basic2-logo-effect img logo-layer bg-color text-color)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)))

(script-fu-register "script-fu-basic2-logo-alpha"
		    _"B_asic II..."
		    "Creates a simple logo with a shadow and a highlight"
		    "Spencer Kimball"
		    "Spencer Kimball"
		    "1996"
		    "RGBA"
                    SF-IMAGE      "Image" 0
                    SF-DRAWABLE   "Drawable" 0
       		    SF-COLOR      _"Background color" '(255 255 255)
		    SF-COLOR      _"Text color" '(206 6 50))

(script-fu-menu-register "script-fu-basic2-logo-alpha"
			 _"<Image>/Script-Fu/Alpha to Logo")


(define (script-fu-basic2-logo text
			       size
			       font
			       bg-color
			       text-color)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
	 (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font))))

    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer text)
    (apply-basic2-logo-effect img text-layer bg-color text-color)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

(script-fu-register "script-fu-basic2-logo"
		    _"B_asic II..."
		    "Creates a simple logo with a shadow and a highlight"
		    "Spencer Kimball"
		    "Spencer Kimball"
		    "1996"
		    ""
		    SF-STRING     _"Text"               "SCRIPT-FU"
		    SF-ADJUSTMENT _"Font size (pixels)" '(150 2 1000 1 10 0 1)
		    SF-FONT       _"Font"               "Sans Bold"
		    SF-COLOR      _"Background color"   '(255 255 255)
		    SF-COLOR      _"Text color"         '(206 6 50))

(script-fu-menu-register "script-fu-basic2-logo"
			 _"<Toolbox>/Xtns/Script-Fu/Logos")
