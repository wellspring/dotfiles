; rotate anim plugin
; Original version :
;   2000 MARIN Laetitia 
;   titix@amin.unice.fr
; Version 0.2 : Ported to Gimp2 by Raymond Ostertag
;   Changed menu entry
;
(define (rotate-and-copy3 img drawable x angle)
  (if (> x 0)
      (begin
	(let ((pouet (car (gimp-layer-copy drawable TRUE))))
	  (gimp-image-add-layer img pouet 0)
	  (gimp-rotate pouet TRUE (/ (* (- 0 x) 3.14159) 180)))
	(rotate-and-copy3 img drawable (- x angle) angle))))
      
(define (script-fu-fleur rayon nb-div left)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (size (+ (* rayon 2) 20))
	 (angle (/ 360 nb-div))
	 (img (car (gimp-image-new size size RGB)))
	 (coeur (car (gimp-layer-new img size size RGBA-IMAGE "coeur" 100 NORMAL-MODE)))
	 (reflet (car (gimp-layer-new img size size RGBA-IMAGE "reflet" 100 NORMAL-MODE)))
	 (shape (car (gimp-layer-new img size size RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
	 (background (car (gimp-layer-new img size size RGBA-IMAGE "background" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
  
    ;; add layers 
    (gimp-image-add-layer img background 0)
    (gimp-image-add-layer img shape 0)
    (gimp-image-add-layer img reflet 0)
    (gimp-image-add-layer img coeur 0)
    
    ;; Init layers back colors
    (gimp-edit-clear coeur)
    (gimp-edit-clear reflet)
    (gimp-edit-clear shape)
    (gimp-edit-clear background)

    (gimp-selection-all img)

    (gimp-palette-set-foreground '(0 0 0)) 
    (gimp-edit-bucket-fill background FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    ;; le coeur
    (gimp-ellipse-select img (+ 10 (* (/ rayon 16) 13)) (+ 10 (* (/ rayon 16) 13)) (* (/ rayon 8) 3) (* (/ rayon 8) 3) CHANNEL-OP-REPLACE TRUE 0 0)

    (gimp-palette-set-foreground '(237 209 33)) 
    (gimp-edit-bucket-fill coeur FG-BUCKET-FILL NORMAL-MODE 50 0 FALSE 0 0)

    (gimp-selection-shrink img 1)

    (gimp-palette-set-foreground '(244 244 34)) 
    (gimp-edit-bucket-fill coeur FG-BUCKET-FILL NORMAL-MODE 50 0 FALSE 0 0)

    (plug-in-noisify TRUE img coeur TRUE 0.2 0.2 0.2 0.2)

    ;; un seul pétale
    (gimp-ellipse-select img (+ 10 (* (/ rayon 8) 7)) 10 (/ rayon 4) rayon CHANNEL-OP-REPLACE TRUE 0 0)

    ;; contour bleu
    (gimp-palette-set-foreground '(94 149 237)) 
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    (gimp-selection-shrink img 1)

    ;; centre blanc
    (gimp-palette-set-foreground '(255 255 255)) 
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    (gimp-selection-shrink img 4)
    (gimp-ellipse-select img (* (/ (+ 10 rayon) 8) 6) 10 (/ (+ 10 rayon) 4) rayon CHANNEL-OP-SUBTRACT TRUE 0 0)

    ;; reflet bleu
    (gimp-palette-set-foreground '(94 149 237)) 
    (gimp-edit-bucket-fill reflet FG-BUCKET-FILL NORMAL-MODE 50 0 FALSE 0 0)

    (gimp-selection-none img)

    (plug-in-gauss-iir2 TRUE img reflet 10 10)

    (gimp-drawable-set-visible coeur FALSE)
    (gimp-drawable-set-visible background FALSE)

    (let* ((merged-layer (car (gimp-image-merge-visible-layers img 1)))
	   (pouet (car (gimp-layer-copy merged-layer TRUE))))
      (gimp-image-add-layer img pouet 0)
      (if (= left TRUE)
	  (gimp-rotate pouet TRUE (/ (* (- 0 angle) 3.14159) 180))
	  (gimp-rotate pouet TRUE (/ (* angle 3.14159) 180)))
      (gimp-selection-layer-alpha pouet)
      (gimp-edit-clear merged-layer)
      (gimp-image-remove-layer img pouet)
      (gimp-selection-none img)
      (rotate-and-copy3 img merged-layer (- 360 angle) angle)
      (gimp-image-merge-visible-layers img 1))

    (gimp-drawable-set-visible background TRUE)
    (gimp-drawable-set-visible coeur TRUE)

    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-fleur"
		    "<Toolbox>/Xtns/Script-Fu/Render/Flower..."		    
		    "create a white-blue flower"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Radius" "128"
		    SF-ADJUSTMENT "Petals number" '(24 4 36 4 0 0 1)
		    SF-TOGGLE "anti horair sens" 0)



