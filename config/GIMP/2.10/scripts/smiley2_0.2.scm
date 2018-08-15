; smiley plugin
; 
; Original version 
;   Copyright (C) 2000 MARIN Laetitia 
;   titix@amin.unice.fr
; Version 0.2 Raymond Ostertag 2004/09
; - Ported to Gimp2
; - Changed menu entry

(define (make-grr img grr radius)
  (let* ((grr-posX (- (+ 10 (* (/ radius 4) 3)) 5))
	(grr-posY (- (+ 10 (/ (* radius 7) 6)) 3))
	(grr-dimX (/ radius 2))
	(grr-dimY (/ radius 2))
	(dent-dimX (/ grr-dimX 4))
	(dent-dimY (/ grr-dimY 2)))
    (gimp-rect-select img grr-posX grr-posY (+ grr-dimX 10) (+ grr-dimY 6) CHANNEL-OP-REPLACE TRUE 0)

    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-bucket-fill grr FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    (gimp-rect-select img (+ 2               grr-posX) (+ 2               grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)
    (gimp-rect-select img (+ (+ 4 dent-dimX) grr-posX) (+ 2               grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)
    (gimp-rect-select img (+ (+ 6 (* dent-dimX 2)) grr-posX) (+ 2               grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)
    (gimp-rect-select img (+ (+ 8 (* dent-dimX 3)) grr-posX) (+ 2               grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)

    (gimp-rect-select img (+ (+ 4 dent-dimX) grr-posX) (+ (+ 4 dent-dimY) grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)
    (gimp-rect-select img (+ 2               grr-posX) (+ (+ 4 dent-dimY) grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)
    (gimp-rect-select img (+ (+ 8 (* dent-dimX 3)) grr-posX) (+ (+ 4 dent-dimY) grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)
    (gimp-rect-select img (+ (+ 6 (* dent-dimX 2)) grr-posX) (+ (+ 4 dent-dimY) grr-posY) dent-dimX dent-dimY CHANNEL-OP-SUBTRACT TRUE 0)

    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill grr FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-selection-none img)
    (gimp-perspective grr TRUE 0 0 
		      (+ (* radius 2) 20) 0 
		      0 (+ (* radius 2) 20)
		      (* (/ (+ (* radius 2) 20) 8) 7) (* (/ (+ (* radius 2) 20) 8) 7))))

(define (make-eyes img eyes radius)
  (let ((eye-l-pos-x  (+ 10 (/ (* radius 2) 3)))
	(eye-r-pos-x  (+ 10 (- (+ radius (/ radius 3)) (/ radius 4))))
	(eye-pos-y (+ 10 (/ radius 2)))
	(eye-radius-x (/ radius 4))
	(eye-radius-y (/ radius 3)))
    (gimp-ellipse-select img eye-l-pos-x eye-pos-y eye-radius-x eye-radius-y CHANNEL-OP-REPLACE TRUE 0 0)
    (gimp-ellipse-select img eye-r-pos-x eye-pos-y eye-radius-x eye-radius-y CHANNEL-OP-ADD TRUE 0 0)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill eyes FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)))

(define (make-reflet img reflet radius)
  (let ((reflet-pos (+ 10 (/ radius 6)))
	(reflet-radius (* (/ radius 7) 12)))
    (gimp-ellipse-select img 10 10 (* radius 2) (* radius 2) CHANNEL-OP-REPLACE TRUE 0 0)
    (gimp-ellipse-select img reflet-pos reflet-pos reflet-radius reflet-radius  CHANNEL-OP-SUBTRACT TRUE 0 0))

  (gimp-palette-set-foreground '(255 255 255))
  (gimp-edit-bucket-fill reflet FG-BUCKET-FILL NORMAL-MODE 50 0 FALSE 0 0)
  
  (gimp-selection-none img)
  
  (plug-in-gauss-iir2 TRUE img reflet 15 15))

  
(define (script-fu-smiley2 radius)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 ;; image creation
	 (img (car (gimp-image-new (+ (* radius 2) 20) (+ (* radius 2) 20) RGB)))
	 ;; layers creation
	 (reflet (car (gimp-layer-new img (+ (* radius 2) 20) (+ (* radius 2) 20) RGBA-IMAGE "reflet" 100 NORMAL-MODE)))
	 (eyes (car (gimp-layer-new img (+ (* radius 2) 20) (+ (* radius 2) 20) RGBA-IMAGE "eyes" 100 NORMAL-MODE)))
	 (grr (car (gimp-layer-new img (+ (* radius 2) 20) (+ (* radius 2) 20) RGBA-IMAGE "grr" 100 NORMAL-MODE)))
	 (shape (car (gimp-layer-new img (+ (* radius 2) 20) (+ (* radius 2) 20) RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
	 (background (car (gimp-layer-new img (+ (* radius 2) 20) (+ (* radius 2) 20) RGBA-IMAGE "background" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
  
    ;; add layers 
    (gimp-image-add-layer img background 0)
    (gimp-image-add-layer img shape 0)
    (gimp-image-add-layer img reflet 0)
    (gimp-image-add-layer img grr 0)
    (gimp-image-add-layer img eyes 0)
    
    ;; Init layers back colors
    (gimp-edit-clear shape)
    (gimp-edit-clear eyes)
    (gimp-edit-clear grr)
    (gimp-edit-clear reflet)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill background FOREGROUND-FILL)

    ;; make shape
    (gimp-ellipse-select img 10 10 (* radius 2) (* radius 2) CHANNEL-OP-REPLACE TRUE 0 0)
    (gimp-palette-set-foreground '(86 225 47))
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; make shape grrrrrr
    (make-grr img grr radius)

    ;; make eyes
    (make-eyes img eyes radius)

    ;; make reflet
    (make-reflet img reflet radius)

    ;; bring back fore and back color
    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-smiley2"
		    "<Toolbox>/Xtns/Script-Fu/Render/Smiley Grr..."
		    "green grrr smiley face"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Radius"        "64")






