; coffee bean plugin
;
; Original version :
; Copyright (C) 2000 MARIN Laetitia 
; titix@amin.unice.fr
;
; Version 0.2 - Ported to Gimp2 by Raymond Ostertag 
;

(define (script-fu-cafe rayon)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (img (car (gimp-image-new (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGB)))
	 (shape (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
	 (shape2 (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Shape2" 100 NORMAL-MODE)))
	 (background (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Shape" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
  
    ;; add layers 
    (gimp-image-add-layer img background 0)
    (gimp-image-add-layer img shape 0)
    (gimp-image-add-layer img shape2 0)
    
    ;; Init layers back colors
    (gimp-edit-clear shape)
    (gimp-edit-clear shape2)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill background FOREGROUND-FILL)

    (gimp-palette-set-foreground '(0 0 0))

    ;; make bean shape
    (gimp-ellipse-select img (+ 10 (/ rayon 4)) 10 (* (- rayon (/ rayon 4)) 2) (* rayon 2) CHANNEL-OP-REPLACE TRUE 0 0)
    ;; fill shape back
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; make bean central edge
    (gimp-rect-select img (+ 10 (- rayon (/ rayon 8))) 10 (/ rayon 4)  (* rayon 2) CHANNEL-OP-INTERSECT TRUE 0)
    ;; fill shape black
    (gimp-edit-bucket-fill shape2 FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
  
    (gimp-selection-none img)

    (plug-in-ripple TRUE img shape2 (/ (* rayon 50) 128) (/ (* rayon 5) 128) 0 0 1 TRUE TRUE)

    (gimp-fuzzy-select shape (+ rayon 10) (+ rayon 10) 15 CHANNEL-OP-REPLACE TRUE FALSE 0 FALSE)
    (gimp-selection-shrink img (/ (* rayon 5) 128))
    (gimp-fuzzy-select shape2 (+ rayon 10) (+ rayon 10) 15 CHANNEL-OP-SUBTRACT TRUE FALSE 0 FALSE)

    ;; fill with brown
    (gimp-palette-set-foreground '(181 132 18))
    (gimp-palette-set-background '(0 0 0))
    ;(gimp-edit-bucket-fill shape2 BG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-edit-blend shape2 FG-BG-RGB-MODE NORMAL-MODE GRADIENT-RADIAL 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE (+ rayon 10) (+ rayon 10) (+ rayon 10) (- 0 (+ rayon 10)))

    (gimp-selection-invert img)

    (gimp-edit-clear shape2)
    
    (gimp-selection-none img)

    (plug-in-gauss-iir2 TRUE img shape2 (/ (* rayon 10) 128) (/ (* rayon 10) 128))

    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-cafe"
		    "<Toolbox>/Xtns/Script-Fu/Render/Coffee bean..."
		    "coffee bean"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Radius"        "32")






