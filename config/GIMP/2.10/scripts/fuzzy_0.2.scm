; fuzzy button
; Original version :
;   Copyright (C) 2000 MARIN Laetitia 
;   <titix@amin.unice.fr>
; Version 0.2
;   Ported to Gimp2 by Raymond Ostertag
;   Changed menu entry

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

(define (create-fuzzy img motif sizeX sizeY color)
  ;; Create solid noise
  (plug-in-solid-noise TRUE img motif 1 0 1 1 4 4)
  ;; select one path on motif 1
  (gimp-selection-none img)
  (gimp-fuzzy-select motif (/ sizeX 2) (/ sizeY 2) 15 CHANNEL-OP-REPLACE TRUE FALSE 0 FALSE)
  (gimp-selection-border img 5)
  ;; fill with fuzzy color
  (gimp-palette-set-foreground color)    
  (gimp-edit-fill motif   FOREGROUND-FILL)
  ;; cut superflux
  (gimp-selection-invert img)
  (gimp-edit-cut motif)
  ;; wave it
  (plug-in-waves TRUE img motif 10 0 10 1 FALSE))

(define (script-fu-fuzzy size)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (sizeX size)
	 (sizeY size)
	 (img (car (gimp-image-new sizeX sizeY RGB)))
 	 (background (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "background" 100 NORMAL-MODE)))
	 (shape (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
 	 (motif1 (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "motif 1" 100 NORMAL-MODE)))
 	 (motif2 (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "motif 2" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
    
    ;; add layers   
    (gimp-image-add-layer img background 0)
    (gimp-image-add-layer img shape 0)
    (gimp-image-add-layer img motif1 0)
    (gimp-image-add-layer img motif2 0)
    
    ;; Init layers back colors
    (gimp-edit-clear motif1)
    (gimp-edit-clear motif2)
    (gimp-edit-clear shape)
    ;; fill white
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill background FOREGROUND-FILL)
    ;; fill black
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-fill shape   FOREGROUND-FILL)

    ;; fill with fuzzy pattern
    (create-fuzzy img motif1 sizeX sizeY '(255 0 0))
    (create-fuzzy img motif2 sizeX sizeY '(0 255 0))

    ;; rotate it
    (gimp-rotate motif2 TRUE 45)

    ;; Create shape
    (create-oval-shape img sizeX sizeY)
    (gimp-selection-invert img)
    (gimp-edit-clear motif1)
    (gimp-edit-clear motif2)
    (gimp-edit-clear shape)    

    (gimp-selection-none img)

    (gimp-drawable-set-visible background FALSE)
    (let ((merged_layer (car (gimp-image-merge-visible-layers img CLIP-TO-IMAGE))))
      (plug-in-bump-map TRUE img merged_layer merged_layer 135 45 3 0 0 0 0 TRUE FALSE GRADIENT-LINEAR))
    (gimp-drawable-set-visible background TRUE)

    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-fuzzy"
		    "<Toolbox>/Xtns/Script-Fu/Render/Fuzzy..."
		    "fuzzy button"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Size "        "128")
