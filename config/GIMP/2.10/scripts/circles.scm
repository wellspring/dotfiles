(define (script-fu-amazing-circles	theImage
					theLayer
					circlePercent
					preCrop
					postCrop
	)
    ;Initial setup
    ;Start an undo group so the process can be undone with one undo
    (gimp-image-undo-group-start theImage)

    ;Select none
    (gimp-selection-none theImage)


    ;Start main processing
    (let* 
    (
        ;Read the image width and height
	(imageWidth (car (gimp-image-width theImage)))
	(imageHeight (car (gimp-image-height theImage)))

        (offSet)

    )

    ;Select none
    (gimp-selection-none theImage)

    (if (= imageHeight imageWidth)
	()
	(begin
	    (if (= preCrop TRUE)
		(begin 
    
			(if (> imageHeight imageWidth)
		 	    (begin

			    ;Calculate the offset
			    (set! offSet (/ (- imageHeight imageWidth) 2))

			    ;Set image height
			    (set! imageHeight imageWidth)

			    ;Crop the image
			    (gimp-image-crop theImage imageWidth imageWidth 0 offSet))

			    (begin

			    ;Calculate the offset
			    (set! offSet (/ (- imageWidth imageHeight) 2))

			    ;Set image height
			    (set! imageWidth imageHeight)

			    ;Crop the image
			    (gimp-image-crop theImage imageHeight imageHeight offSet 0)))

		)
		()
	    )
    	)
    )


    ;First polar co-ord with "To Polar = off"
    (plug-in-polar-coords 1 theImage theLayer circlePercent 0 1 0 0)

    ;Flip vertically
    (gimp-image-flip theImage 1)


    ;Seond polar co-ord with "To Polar = on"
    (plug-in-polar-coords 1 theImage theLayer circlePercent 0 1 0 1)

    (if (= imageHeight imageWidth)
	()
	(begin
	    (if (= postCrop TRUE)
		(begin 
    
			(if (> imageHeight imageWidth)
		 	    (begin

			    ;Calculate the offset
			    (set! offSet (/ (- imageHeight imageWidth) 2))

			    ;Crop the image
			    (gimp-image-crop theImage imageWidth imageWidth 0 offSet))

			    (begin

			    ;Calculate the offset
			    (set! offSet (/ (- imageWidth imageHeight) 2))

			    ;Crop the image
			    (gimp-image-crop theImage imageHeight imageHeight offSet 0)))
		)
		()
	    )
    	)
    )



    ;Finish main processing

    ;Finish the undo group for the process
    (gimp-image-undo-group-end theImage)

    ;Ensure the updated image is displayed now
    (gimp-displays-flush)

  )
    
)


(script-fu-register "script-fu-amazing-circles"
            _"_Amazing circles...."
            "Does the amazing circles on a square image"
            "Harry Phillips"
            "Harry Phillips"
            "Mar. 23 2007"
            "*"
            SF-IMAGE		"Image"     0
            SF-DRAWABLE		"Drawable"  0
	    SF-ADJUSTMENT	_"Circle depth"      '(100 0 100 1 10 1 0)
	    SF-TOGGLE     	_"Crop photo to a square before"       FALSE
	    SF-TOGGLE     	_"Crop result to a square"       TRUE
)

(script-fu-menu-register "script-fu-amazing-circles"
                         _"<Image>/Script-Fu/Distorts")
            
