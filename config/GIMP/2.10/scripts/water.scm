(define (script-fu-watercolor watersize 
	noiseDetail noiseSizeX noiseSizeY blurSize waterColor)
    (let*
	(
	    (waterImage (car (gimp-image-new watersize watersize RGB)))
	    (waterLayers '())
	)
	(set! listmin (lambda (a)
		(if (null? (cdr a))
		    (car a)
		    (min (car a) (listmin (cdr a)))
		)
	))
	(set! listmax (lambda (a)
		(if (null? (cdr a))
		    (car a)
		    (max (car a) (listmax (cdr a)))
		)
	))
	(set! waterValue (listmax waterColor))
	(set! waterSaturation 
	    (- 255 (* 255 (/ (listmin waterColor) waterValue))))
	(set! waterHue 
	    (mapcar (lambda (x) (* x (/ waterValue 255))) waterColor))
	
	; Blurry background
	(set! waterLayers 
	    (cons 
		(car 
		    (gimp-layer-new
			waterImage watersize watersize
			RGB_IMAGE "Background" 100 NORMAL
		    )
		)
		waterLayers
	    )
	)
	(gimp-image-add-layer waterImage (car waterLayers) -1)
	(gimp-layer-add-alpha (car waterLayers))
	(plug-in-solid-noise 1 waterImage (car waterLayers) 
	    1 0 (realtime) noiseDetail noiseSizeX noiseSizeY)
	(plug-in-c-astretch 1 waterImage (car waterLayers))
	; Blobby strokes
	(set! waterLayers 
	    (cons 
		(car 
		    (gimp-layer-new
			waterImage watersize watersize
			RGB_IMAGE "Strokes" 100 DIFFERENCE
		    )
		)
		waterLayers
	    )
	)
	(gimp-image-add-layer waterImage (car waterLayers) -1)
	(gimp-layer-add-alpha (car waterLayers))
	(plug-in-solid-noise 1 waterImage (car waterLayers) 
	    1 0 (realtime) noiseDetail noiseSizeX noiseSizeY)
	(plug-in-c-astretch 1 waterImage (car waterLayers))
	(gimp-threshold waterImage (car waterLayers) 0 128)
	(plug-in-gauss-rle 1 waterImage (car waterLayers) blurSize TRUE TRUE)
	; Saturation layer
	(set! waterLayers 
	    (cons 
		(car 
		    (gimp-layer-new
			waterImage watersize watersize
			RGB_IMAGE "Saturation" 100 SATURATION
		    )
		)
		waterLayers
	    )
	)
	(gimp-image-add-layer waterImage (car waterLayers) -1)
	(gimp-layer-add-alpha (car waterLayers))
	(gimp-selection-all waterImage)
	(gimp-palette-set-foreground (list waterSaturation 0 0))
	(gimp-bucket-fill waterImage (car waterLayers) 
	    FG-BUCKET-FILL NORMAL 100 0 FALSE 0 0)
	; Hue
	(set! waterLayers 
	    (cons 
		(car 
		    (gimp-layer-new
			waterImage watersize watersize
			RGB_IMAGE "Hue" 100 HUE
		    )
		)
		waterLayers
	    )
	)
	(gimp-image-add-layer waterImage (car waterLayers) -1)
	(gimp-layer-add-alpha (car waterLayers))
	(gimp-selection-all waterImage)
	(gimp-palette-set-foreground waterHue)
	(gimp-bucket-fill waterImage (car waterLayers) 
	    FG-BUCKET-FILL NORMAL 100 0 FALSE 0 0)
	; Value
	(set! waterLayers 
	    (cons 
		(car 
		    (gimp-layer-new
			waterImage watersize watersize
			RGB_IMAGE "Value" 100 MULTIPLY
		    )
		)
		waterLayers
	    )
	)
	(gimp-image-add-layer waterImage (car waterLayers) -1)
	(gimp-layer-add-alpha (car waterLayers))
	(gimp-selection-all waterImage)
	(gimp-palette-set-foreground (list waterValue waterValue waterValue))
	(gimp-bucket-fill waterImage (car waterLayers) 
	    FG-BUCKET-FILL NORMAL 100 0 FALSE 0 0)
	; End
	(gimp-display-new waterImage)
	(list waterImage waterLayers waterValue waterSaturation waterHue)
    )
)
(script-fu-register
    "script-fu-watercolor"
    "<Toolbox>/Xtns/Script-Fu/Misc/WaterColor"
    "Watercolor-y Background"
    "Denis Moskowitz"
    "All Rites Reversed (k) Do what you like"
    "Chaos 3, 3165 YOLD"
    ""
    SF-VALUE "Size:" "256"
    SF-VALUE "NoiseDetail:" "1"
    SF-VALUE "NoiseSizeX:" "4"
    SF-VALUE "NoiseSizeY:" "8"
    SF-VALUE "BlurSize:" "5"
    SF-COLOR "Color:" '(0 0 255)
)
