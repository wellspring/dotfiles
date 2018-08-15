; aqua button
; Copyright (C) 2000 
; MARIN Laetitia <titix@amin.unice.fr> from the original tuto by Michael Spunt <t0mcat@gmx.de>
;
; version 0.2 : ported to Gimp2 by Raymond Ostertag
; Changed menu entry

(define (create-oval-shape img sizeX sizeY)
  (let* ((corner-size (/ (if (< sizeX sizeY) sizeX sizeY) 5))
	 (offset 10)
	 
	 ;; rect selection size and offsets
	 (r-size corner-size)
	 (r-offset-x1 offset)
	 (r-offset-x2 (- sizeX (+ offset r-size)))
	 (r-offset-y1 offset)
	 (r-offset-y2 (- sizeY (+ offset r-size)))
	 
	 ;; ellipse selection size and offsets
	 (e-size (* 2 corner-size))
	 (e-offset-x1 offset)
	 (e-offset-x2 (- sizeX (+ offset e-size)))
	 (e-offset-y1 offset)
	 (e-offset-y2 (- sizeY (+ offset e-size))))

    (gimp-rect-select img offset offset (- sizeX (+ (* 2 offset) 1)) (- sizeY (+ (* 2 offset) 1)) CHANNEL-OP-REPLACE FALSE 0)
    
    ;; erase corners
    (gimp-rect-select img r-offset-x1 r-offset-y1 r-size r-size CHANNEL-OP-SUBTRACT FALSE 0)
    (gimp-rect-select img r-offset-x1 r-offset-y2 r-size r-size CHANNEL-OP-SUBTRACT FALSE 0)
    (gimp-rect-select img r-offset-x2 r-offset-y2 r-size r-size CHANNEL-OP-SUBTRACT FALSE 0)
    (gimp-rect-select img r-offset-x2 r-offset-y1 r-size r-size CHANNEL-OP-SUBTRACT FALSE 0)
    
    ;; add round corners

    (gimp-ellipse-select img e-offset-x1 e-offset-y1 e-size e-size CHANNEL-OP-ADD TRUE 0 0)
    (gimp-ellipse-select img e-offset-x1 e-offset-y2 e-size e-size CHANNEL-OP-ADD TRUE 0 0)
    (gimp-ellipse-select img e-offset-x2 e-offset-y2 e-size e-size CHANNEL-OP-ADD TRUE 0 0)
    (gimp-ellipse-select img e-offset-x2 e-offset-y1 e-size e-size CHANNEL-OP-ADD TRUE 0 0)))

(define (script-fu-aqua sizeX sizeY)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (img (car (gimp-image-new sizeX sizeY RGB)))
 	 (shade (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "shadow" 100 NORMAL-MODE)))
	 (background (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
 	 (reflection (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "Reflection" 100 SCREEN-MODE)))
 	 (gradient (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "gradient" 100 SCREEN-MODE))))
    
    (gimp-image-undo-disable img)

    ;; add layers 
    (gimp-image-add-layer img shade 0)
    (gimp-image-add-layer img background 0)
    (gimp-image-add-layer img reflection 0)
    (gimp-image-add-layer img gradient 0)
    
    ;; Init layers back colors
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill gradient   FOREGROUND-FILL)
    (gimp-edit-clear background)
    (gimp-edit-fill reflection FOREGROUND-FILL)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill shade      FOREGROUND-FILL)

    ;; Create shape
    (create-oval-shape img sizeX sizeY)

    ;; fill shadow
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill shade FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; fill background
    (gimp-palette-set-foreground '(22 255 213))
    (gimp-edit-bucket-fill background FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    ;; grid background
    (plug-in-grid TRUE img background 0 0 0 '(22 220 255) 255 1 4 4 '(22 220 255) 255 0 2 6 '(22 220 255) 255)

    ;; create gradient
    (gimp-palette-set-background '(255 255 255))
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-blend gradient FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE (/ sizeX 2) 0 (/ sizeX 2) sizeY)

    ;; shrink selection for reflection 
    (gimp-selection-shrink img 2)
    (gimp-rect-select img 0 (/ sizeY 3) sizeX (* sizeY (/ 2 3)) CHANNEL-OP-SUBTRACT FALSE 0)
    ;; fill reflection
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-bucket-fill reflection FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    (gimp-selection-none img)

    ;; blur reflection
    (plug-in-gauss-iir2 TRUE img reflection 3 3)
    ;; blur shadow
    (plug-in-gauss-iir2 TRUE img shade 5 5)

    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-aqua"
		    "<Toolbox>/Xtns/Script-Fu/Buttons/Aqua..."
		    "Aqua pill button"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Size X"        "128"
		    SF-VALUE "Size Y"        "64")
