(define (script-fu-layerland landsize noiseDetail noiseSize
	numlayers landgradient invertp jasonp jthresh landOpacity)
    (let*
	(
	    (landImage (car (gimp-image-new landsize landsize RGB)))
	    (landLayers '())
	    (landMask 0)
	    (landCounter 0)
	)
	(gimp-gradients-set-active landgradient)
	(if (= invertp TRUE) (set! jthresh (- 1 jthresh)))
	(while (< landCounter numlayers)
	    (set! landLayers 
		(cons 
		    (car 
			(gimp-layer-new
			    landImage landsize landsize
			    RGB_IMAGE "Layer" 100 NORMAL
			)
		    )
		    landLayers
		)
	    )
	    (gimp-image-add-layer landImage (car landLayers) -1)
	    (plug-in-solid-noise 1 landImage (car landLayers) 
		1 0 (realtime) noiseDetail noiseSize noiseSize)
	    (plug-in-c-astretch 1 landImage (car landLayers))
	    (if (not (= landCounter 0))
	    	(begin
		    (gimp-selection-all landImage)
		    (gimp-edit-copy landImage (car landLayers))
		    (gimp-layer-add-alpha (car landLayers))
		    (set! landMask 
			(car (gimp-layer-create-mask (car landLayers) 2))
		    )
		    (gimp-image-add-layer-mask
			landImage (car landLayers) landMask)
		    (gimp-floating-sel-anchor (car
			    (gimp-edit-paste landImage landMask 0)
		    ))
		    (if (= invertp TRUE)
			(gimp-invert landImage (car landLayers))
		    )
		    (if (= jasonp TRUE)
			(begin
			    (gimp-threshold landImage landMask 
				(* jthresh 255) 255)
			    (plug-in-gauss-rle 1 landImage landMask
				5 TRUE TRUE)
			    (gimp-levels landImage landMask 0
				0 255 1.0 (* landOpacity 255) 255)
			)
		    )
		)
	    )
	    (plug-in-gradmap 1 landImage (car landLayers))
	    (if (not (= landCounter 0))
		(gimp-image-remove-layer-mask landImage (car landLayers) 0)
	    )
	    (set! landCounter (+ 1 landCounter))
	)
	(gimp-display-new landImage)
	(list landImage landLayers)
    )
)
(script-fu-register
    "script-fu-layerland"
    "<Toolbox>/Xtns/Script-Fu/Misc/LandLayers"
    "Floating Layers of Land"
    "Denis Moskowitz"
    "All Rites Reversed (k) Do what you like"
    "Chaos 3, 3165 YOLD"
    ""
    SF-VALUE "Size:" "256"
    SF-VALUE "NoiseDetail:" "2"
    SF-VALUE "NoiseSize:" "4"
    SF-VALUE "Layers:" "5"
    SF-VALUE "Gradient:" "\"Land_and_Sea\""
    SF-TOGGLE "Land on Left?" TRUE
    SF-TOGGLE "Flat Transparency?" FALSE
    SF-VALUE " > Beach Position (0 - 1):" "0.4"
    SF-VALUE " > Ocean Opacity (0 - 1):" "0.45"
)
