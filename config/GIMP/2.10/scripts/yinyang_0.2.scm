; yin yang circle plugin
;
; Original version :
;   Copyright (C) 2000 MARIN Laetitia 
;   titix@amin.unice.fr
; Version 0.2 Raymond Ostertag 2004/09
;   - Ported to Gimp2
;   - Changed menu entry

(define (make-yinyan-right-shape img rayon)
  (gimp-ellipse-select img 10 10 (* rayon 2) (* rayon 2) CHANNEL-OP-REPLACE TRUE 0 0)
  (gimp-rect-select img 10 10 rayon (* rayon 2) CHANNEL-OP-SUBTRACT TRUE 0)
  (gimp-ellipse-select img (+ 10 (/ rayon 2)) 10 rayon rayon CHANNEL-OP-SUBTRACT TRUE 0 0)
  (gimp-ellipse-select img (+ 10 (/ rayon 2)) (+ 10 rayon) rayon rayon CHANNEL-OP-ADD TRUE 0 0)
  (gimp-ellipse-select img (+ 10 (* (/ rayon 10) 9)) (+ 10 (- (/ rayon 2) (/ rayon 10))) (/ rayon 5) (/ rayon 5) CHANNEL-OP-ADD TRUE 0 0)
  (gimp-ellipse-select img (+ 10 (* (/ rayon 10) 9)) (+ (+ 10 (- (/ rayon 2) (/ rayon 10))) rayon) (/ rayon 5) (/ rayon 5) CHANNEL-OP-SUBTRACT TRUE 0 0))

(define (make-yinyan-left-shape img rayon)
  (gimp-ellipse-select img 10 10 (* rayon 2) (* rayon 2) CHANNEL-OP-REPLACE TRUE 0 0)
  (gimp-rect-select img (+ 10 rayon) 10  rayon  (* rayon 2) CHANNEL-OP-SUBTRACT TRUE 0)
  (gimp-ellipse-select img (+ 10 (/ rayon 2)) 10 rayon rayon CHANNEL-OP-ADD TRUE 0 0)
  (gimp-ellipse-select img (+ 10 (/ rayon 2)) (+ 10 rayon) rayon rayon CHANNEL-OP-SUBTRACT TRUE 0 0)
  (gimp-ellipse-select img (+ 10 (* (/ rayon 10) 9)) (+ 10 (- (/ rayon 2) (/ rayon 10))) (/ rayon 5) (/ rayon 5) CHANNEL-OP-SUBTRACT TRUE 0 0)
  (gimp-ellipse-select img (+ 10 (* (/ rayon 10) 9)) (+ (+ 10 (- (/ rayon 2) (/ rayon 10))) rayon) (/ rayon 5) (/ rayon 5) CHANNEL-OP-ADD TRUE 0 0))



  
(define (script-fu-yinyan rayon)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (img (car (gimp-image-new (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGB)))
	 (background (car (gimp-layer-new img (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGBA-IMAGE "Shape" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
  
    ;; add layers 
    (gimp-image-add-layer img background 1)
    
    ;; Init layers back colors
    (gimp-edit-clear background)

    ;; make left
    (make-yinyan-left-shape img rayon)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-bucket-fill background FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; make right
    (make-yinyan-right-shape img rayon)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-bucket-fill background FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    (gimp-selection-none img)
    
    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-yinyan"
		    "<Toolbox>/Xtns/Script-Fu/Render/Yin-Yang..."
		    "YinYan circle"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Radius"        "32")
