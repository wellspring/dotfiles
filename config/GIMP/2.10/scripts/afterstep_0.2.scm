; afterstep logo plugin
; Copyright (C) 2000 MARIN Laetitia 
; titix@amin.unice.fr
;
; version 0.2 : ported to Gimp2 by Raymond Ostertag
; changed menu entry

(define (make-step-shape img rayon)
  (gimp-rect-select img (- (+ 10 (/ rayon 2)) (/ rayon 8)) (- (+ 10 (* (/ rayon 2) 3)) (/ rayon 8)) (+ (/ rayon 2) (/ rayon 8)) (+ (/ rayon 2) (/ rayon 8)) CHANNEL-OP-REPLACE TRUE 0)
  (gimp-rect-select img (- (+ 10 rayon) (/ rayon 8)) (- (+ 10 rayon) (/ rayon 8)) (+ rayon (/ rayon 8)) (+ rayon (/ rayon 8)) CHANNEL-OP-ADD TRUE 0) 
  (gimp-rect-select img (- (+ 10 (* (/ rayon 2) 3)) (/ rayon 8)) (- (+ 10 (/ rayon 2)) (/ rayon 8)) (+ (/ rayon 2) (/ rayon 8)) (+ (/ rayon 2) (/ rayon 8)) CHANNEL-OP-ADD TRUE 0)
  (gimp-ellipse-select img 10 10 (* rayon 2) (* rayon 2) CHANNEL-OP-INTERSECT TRUE 0 0))


  
(define (script-fu-afterstep rayon)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (img (car (gimp-image-new (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGB)))
	 (reflet (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Reflet" 100 SCREEN-MODE)))
	 (reflet2 (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Reflet" 100 DARKEN-ONLY-MODE)))
	 (shape (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
	 (grid (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Grid" 100 NORMAL-MODE)))
	 (background (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Shape" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
  
    ;; add layers 
    (gimp-image-add-layer img background 0)
    (gimp-image-add-layer img grid 0)
    (gimp-image-add-layer img shape 0)
    (gimp-image-add-layer img reflet 0)
    (gimp-image-add-layer img reflet2 0)
    
    ;; Init layers back colors
    (gimp-edit-clear grid)
    (gimp-edit-clear shape)
    (gimp-edit-clear reflet)
    (gimp-edit-clear reflet2)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill background FOREGROUND-FILL)

    ;; make shape step 1
    (make-step-shape img rayon)
    ;; fill shape white
    (gimp-palette-set-foreground '(237 230 230))
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; make shape step 2
    (gimp-selection-invert img)
    (gimp-ellipse-select img 10 10 (* rayon 2) (* rayon 2) CHANNEL-OP-INTERSECT TRUE 0 0)    
    ;; fill shape black
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; reflect shape 1
    (gimp-selection-shrink img (/ rayon 16))
    (gimp-ellipse-select img (+ 10 (/ rayon 3)) (+ 10 (/ rayon 3)) (- (* rayon 2) (/ rayon 6)) (- (* rayon 2) (/ rayon 6)) CHANNEL-OP-SUBTRACT TRUE 0 0)
    ;; fill reflet shape 1
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-bucket-fill reflet FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    ;; blur reflet shape 1
    (gimp-selection-none img)
    (plug-in-gauss-iir2 TRUE img reflet 15 15)

    ;; reflect shape 2
    (make-step-shape img rayon)
    (gimp-selection-shrink img (/ rayon 16))
    (gimp-ellipse-select img 10 10 (- (* rayon 2) (/ rayon 6)) (- (* rayon 2) (/ rayon 6)) CHANNEL-OP-SUBTRACT TRUE 0 0)
    ;; fill reflet shape 2
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill reflet2 FG-BUCKET-FILL NORMAL-MODE 35 0 FALSE 0 0)
    ;; blur reflet shape 2
    (gimp-selection-none img)
    (plug-in-gauss-iir2 TRUE img reflet2 15 15)


    ;; fill grid
    (gimp-rect-select img (- 10 1) (- 10 1) (+ (* rayon 2) 1) (+ (* rayon 2) 1) CHANNEL-OP-REPLACE TRUE 0 0)    
    (plug-in-grid TRUE img grid 1 (/ rayon 2) 9 '(0 0 128) 255 1 (/ rayon 2) 9 '(0 0 128) 255 0 2 6 '(0 0 128) 255)

    (gimp-selection-none img)
    
    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-afterstep"
		    "<Toolbox>/Xtns/Script-Fu/Render/Afterstep..."
		    "Afterstep logo"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Radius"        "32")






