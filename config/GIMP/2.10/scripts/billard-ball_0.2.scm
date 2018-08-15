; billard ball plugin
;
; Original version
; 2000 MARIN Laetitia 
; titix@amin.unice.fr
;
; Version 0.2 : ported to Gimp2 by Raymond Ostertag
; Changed menu entry

(define (script-fu-billard-ball color numero bande)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (old-fg-color (car (gimp-palette-get-foreground)))
	 (sizeX 128)
	 (sizeY 128)
	 (rayonX 13)
	 (rayonY 26)
	 (img (car (gimp-image-new sizeX sizeY RGB)))	 
	 (texture (car (gimp-layer-new img sizeX sizeY RGBA-IMAGE "texture" 100 NORMAL-MODE))))
    
    (gimp-image-undo-disable img)

    (gimp-palette-set-foreground '(0 0 0))

    ;; le numero de la boule
    (let* ((text-layer (car (gimp-text img -1 0 0 (number->string (+ numero 1)) 20 TRUE 18 PIXELS "freefont" "blippo" "heavy" "r" "normal" "*" "*" "*")))
	   (text-sizeX (car (gimp-drawable-width text-layer)))
	   (text-sizeY (car (gimp-drawable-height text-layer))))
	   
      (gimp-image-add-layer img texture 1)
      
      ;; la couleur de fond
      (gimp-palette-set-foreground color)
      (gimp-edit-fill texture FOREGROUND-FILL)
      
      ;; les cercles blancs
      (gimp-ellipse-select img (- (/ sizeX 2) rayonX) (- (/ sizeY 2) rayonY) (* 2 rayonX) (* 2 rayonY) CHANNEL-OP-REPLACE TRUE 0 0)
      (gimp-ellipse-select img (- 0 rayonX) (- (/ sizeY 2) rayonY) (* 2 rayonX) (* 2 rayonY) CHANNEL-OP-ADD TRUE 0 0)
      (gimp-ellipse-select img (- sizeX rayonX) (- (/ sizeY 2) rayonY) (* 2 rayonX) (* 2 rayonY) CHANNEL-OP-ADD TRUE 0 0)
      
      ;; eventuellement la bande
      (if (= bande TRUE)
	  (begin
	    (gimp-rect-select img 0 0 sizeX (/ sizeY 4) CHANNEL-OP-ADD FALSE 0)
	    (gimp-rect-select img 0 (* (/ sizeY 4) 3) sizeX (/ sizeY 4) CHANNEL-OP-ADD FALSE 0)))
            
      (gimp-palette-set-foreground '(255 255 255))
      (gimp-edit-bucket-fill texture FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

      ;; les 3 calques textes
      (gimp-layer-scale text-layer text-sizeX (* text-sizeY 2) 0)
      (gimp-layer-translate text-layer (/ (- sizeX text-sizeX) 2) (- (/ sizeY 2) text-sizeY))

      (let ((text-layer-copy (car (gimp-layer-copy text-layer TRUE))))
	(gimp-image-add-layer img text-layer-copy 0)
	(gimp-layer-translate text-layer-copy (/ sizeX 2) 0))
	
      (let ((text-layer-copy (car (gimp-layer-copy text-layer TRUE))))
	(gimp-image-add-layer img text-layer-copy 0)
	(gimp-layer-translate text-layer-copy (- 0 (/ sizeX 2)) 0))

      (let ((merged-layer (car (gimp-image-merge-visible-layers img 1))))
	(gimp-drawable-set-name merged-layer "texture"))
	
      (gimp-selection-none img)
   
      (gimp-palette-set-foreground old-fg-color)
      (gimp-palette-set-background old-bg-color)
      
      (gimp-image-undo-enable img)
      
      (gimp-display-new img))))


(script-fu-register "script-fu-billard-ball"
		    "<Toolbox>/Xtns/Script-Fu/Render/Billard Ball..."
		    "make a billard ball texture"
		    "MARIN Laetitia"
		    "MARIN Laetitia"
		    "Fev 2000"
		    ""
		    SF-COLOR "color to use"  '(0 0 0)
		    SF-OPTION "numero" '("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")
		    SF-TOGGLE "band" 0)


