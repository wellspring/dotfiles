(define (my-image-to-layer-size image layer)
  (gimp-layer-set-offsets layer 0 0)
  (gimp-image-resize image
		     (car (gimp-drawable-width layer))
		     (car (gimp-drawable-height layer))
		     0 0))

(define (my-layer-add-border layer border)
	(let* ((width  (car (gimp-drawable-width  layer)))
	       (height (car (gimp-drawable-height layer))))
	       (gimp-layer-resize layer
				  (+ width border) (+ height border)
				  (/ border 2) (/ border 2))))

(define (diamond-text text font font-size bevel)
 (let* ((image (car (gimp-image-new 256 256 RGB)))
	(text-layer (car (gimp-text-fontname image -1 0 0 text 0 TRUE font-size PIXELS
					     font))))
(my-image-to-layer-size image text-layer)

(let* ((b-height (car (gimp-drawable-height text-layer))))
(let* ((b-width (car (gimp-drawable-width text-layer))))
     (gimp-layer-set-preserve-trans text-layer 1)
(gimp-gradients-set-active "Golden")

(gimp-selection-layer-alpha text-layer)     
(gimp-blend text-layer CUSTOM NORMAL LINEAR 100 0 0 FALSE TRUE 3 0.20 TRUE 0 0 0 b-height)
(script-fu-add-bevel  image text-layer bevel 0 0)
(gimp-selection-layer-alpha text-layer)
(gimp-selection-shrink image 4)


(set! inset-layer (gimp-layer-new image b-width b-height 1 "inset" 100 0) )
(gimp-drawable-fill (car inset-layer) 3)
(gimp-image-add-layer image (car inset-layer) -1)
(gimp-bucket-fill (car inset-layer) 1 NORMAL 100 0 0 0 0 )

(plug-in-scatter-rgb 1 image (car inset-layer) 0 0 0.80 0.80 0.80 0)
(plug-in-scatter-rgb 1 image (car inset-layer) 0 0 0.10 0.10 0.10 0)
(gimp-selection-none image)
(plug-in-bump-map 1 image (car inset-layer) (car inset-layer) 112 12.5 46 -1 0 26 100 1 0 0)

(let* ((new-layer (car (gimp-image-merge-visible-layers
			     image EXPAND-AS-NECESSARY))))
       (my-image-to-layer-size image new-layer))

(gimp-display-new image)

   ))))
(script-fu-register 	"diamond-text"
			"<Toolbox>/Xtns/Script-Fu/Gimp-talk.com/Diamond..."
			"Create gold text covered in diamonds"
			"Karl Ward"
			"Karl Ward"
			"October 2005"
			""
			SF-STRING	"Text" ""
			SF-FONT		"Font" ""
			SF-ADJUSTMENT	"Font-size" '(100 50 300 1 10 0 1)
			SF-ADJUSTMENT   "Bevel" '(10 5 20 .1 1 1 0))
				
