; powder circle plugin
; Original version :
;   Copyright (C) 2000 MARIN Laetitia 
;   titix@amin.unice.fr
; Version 0.2 Raymond Ostertag 2004/09
;   - Ported to gimp2
;   - Changed menu entry
;
  
(define (script-fu-powder rayon)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (size (+ (* rayon 2) 20))
	 (img (car (gimp-image-new (+ (* rayon 2) 20) (+ (* rayon 2) 20) RGB)))
	 (reflet (car (gimp-layer-new img size size RGBA-IMAGE "Reflet" 100 SCREEN-MODE)))
	 (shape (car (gimp-layer-new img size size RGBA-IMAGE "Shape" 100 NORMAL-MODE)))
	 (border (car (gimp-layer-new img size size RGBA-IMAGE "Border" 100 NORMAL-MODE))))

    (gimp-image-undo-disable img)
  
    ;; add layers 
    (gimp-image-add-layer img shape 0)
    (gimp-image-add-layer img border 0)
    (gimp-image-add-layer img reflet 0)
    
    ;; Init layers back colors
    (gimp-edit-clear shape)
    (gimp-edit-clear reflet)
    (gimp-edit-clear border)

    ;; border shape
    (gimp-ellipse-select img 10 10 (* rayon 2) (* rayon 2) CHANNEL-OP-REPLACE TRUE 0 0) 
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-palette-set-background '(0 0 0))
    (gimp-edit-blend border FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE (/ size 4) (/ size 4) (* (/ size 4) 3) (* (/ size 4) 3))

    (gimp-selection-shrink img 10)
    (gimp-palette-set-background '(255 255 255))
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-edit-blend border FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE (/ size 4) (/ size 4) (* (/ size 4) 3) (* (/ size 4) 3))

   ;; shape in brown
    (gimp-palette-set-foreground '(170 110 28))
    (gimp-edit-bucket-fill shape FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (plug-in-scatter-hsv TRUE img shape TRUE 2 3 10 10)
    (plug-in-gauss-iir2 TRUE img shape 5 5)

    ;; border shape
    (gimp-selection-shrink img 10)
    (gimp-edit-clear border)

    (gimp-selection-none img)

    ;; round border
    (gimp-layer-set-preserve-trans border TRUE)
    (plug-in-gauss-iir2 TRUE img border 10 10)
            
    ;; reflection
    (gimp-ellipse-select img 40 40 (- (* rayon 2) 60) (- (* rayon 2) 60) CHANNEL-OP-REPLACE TRUE 0 0) 
    (gimp-ellipse-select img 20 50 (- (* rayon 2) 60) (- (* rayon 2) 60) CHANNEL-OP-SUBTRACT TRUE 0 0) 
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-bucket-fill reflet FG-BUCKET-FILL NORMAL-MODE 20 0 FALSE 0 0)
    (gimp-selection-none img)
    (plug-in-gauss-iir2 TRUE img reflet 20 20)
    
    (gimp-palette-set-foreground old-fg-color)
    (gimp-palette-set-background old-bg-color)

    (gimp-image-undo-enable img)

    (gimp-display-new img)))

(script-fu-register "script-fu-powder"
		    "<Toolbox>/Xtns/Script-Fu/Buttons/Powder..."
		    "powder circle"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-VALUE "Radius"        "100")






