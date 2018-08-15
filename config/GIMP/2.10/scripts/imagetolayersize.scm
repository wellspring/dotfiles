(define (script-fu-imagesize-to-layersize inImage theDrawable)
 
  ; get image layers
  (set! theLayerCount (car  (gimp-image-get-layers inImage)))
  (set! theLayerList  (car (cdr (gimp-image-get-layers inImage))))

  ; minima
  (set! theMin_X 0)
  (set! theMin_Y 0)

  ; maxima
  (set! theMax_X 0)
  (set! theMax_Y 0)
  
  ;iterate over vertices to get their coordinates
  (set! theCounter   0)
 
  (while (< theCounter theLayerCount)

	 ; get the offsets of the layer	 
	 (set! theOffset_X (car (gimp-drawable-offsets (aref theLayerList theCounter))))
	 (set! theOffset_Y (cadr (gimp-drawable-offsets (aref theLayerList theCounter))))

	 ; get the height and width of the layer	  
 	 (set! theHeight (car (gimp-drawable-height (aref theLayerList theCounter))))
 	 (set! theWidth  (car (gimp-drawable-width  (aref theLayerList theCounter))))

	 ; update global minima
	 (if (< theOffset_X  theMin_X) 
	     (set! theMin_X theOffset_X)
	     )
	 (if (< theOffset_Y  theMin_Y) 
	     (set! theMin_Y theOffset_Y)
	     )

         ; update global maxima
	 (if (> (+ theOffset_X theWidth) theMax_X) 
	     (set! theMax_X (+ theOffset_X theWidth)) )
	 (if (> (+ theOffset_Y theHeight) theMax_Y) 
	     (set! theMax_Y (+ theOffset_Y theHeight)) )

; 	 (gimp-message (string-append "ox : " (number->string theOffset_X)))
; 	 (gimp-message (string-append "oy : " (number->string theOffset_Y)))
; 	 (gimp-message (string-append "h : " (number->string theHeight)))
; 	 (gimp-message (string-append "w : " (number->string theWidth)))
	 
	 (set! theCounter (+ theCounter 1))

  )

; 	 (gimp-message (string-append "-x : " (number->string (- 0 theMin_X))))
; 	 (gimp-message (string-append "-y : " (number->string (- 0 theMin_Y))))
; 	 (gimp-message (string-append "+x : " (number->string (+ theMax_X theMin_X))))
; 	 (gimp-message (string-append "+y : " (number->string (+ theMax_Y theMin_Y))))

  ; resize image and adjust offsets
  (gimp-image-resize inImage (+ theMax_X (abs theMin_X)) (+ theMax_Y (abs theMin_Y)) (- 0 theMin_X) (- 0 theMin_Y))

)

(script-fu-register "script-fu-imagesize-to-layersize" 
		    _"<Image>/Script-Fu/Tools/Imagesize to layersize" 
		    "" 
		    "Michael Schumacher <schumaml@gmx.de>" 
		    "Michael Schumacher <schumaml@gmx.de>" 
		    "2001/10/23" 
		    "" 
		    SF-IMAGE      "Image" 0
		    SF-DRAWABLE   "Drawable" 0
		    )




