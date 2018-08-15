; Stair re-size is a script for The GIMP
;
; Resizes the image up or down in multiple steps instead of one.
;
; The script is located in menu "<Image> / Script-Fu / Misc / Stair Interpolation..."
;
; Last changed: 13 August 2007
;
; Copyright (C) 2007 Harry Phillips <script-fu@tux.com.au>
;
; --------------------------------------------------------------------
; 
; Changelog:
;  Version 0.1 (13th August 2007)
;    - Initial script
; 
; --------------------------------------------------------------------
; 
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 3 of the License, or
; (at your option) any later version.  
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, you can view the GNU General Public
; License version 3 at the web site http://www.gnu.org/licenses/gpl-3.0.html
; Alternatively you can write to the Free Software Foundation, Inc., 675 Mass
; Ave, Cambridge, MA 02139, USA.
;

(define (step-size	stepNumber
			wantedSize
			currentSize)
	
	(let* (
		(stepSize (/ (- wantedSize currentSize) stepNumber))
	)
	
	;Return stepSize
	stepSize))



(define (script-fu-stair-resize		theImage
					theLayer
					targetSide
					targetValue
					stepsWanted)

    (let* (
    
    	;Read the image width and height
	(imageWidth (car (gimp-image-width theImage)))
	(imageHeight (car (gimp-image-height theImage)))
	
	(sizeList)
	(targetWidth)
	(targetHeight)
	(realWidth)
	(realHeight)
	(nextWidth)
	(nextHeight)
	(stepsX)
	(stepsY)

    )

    ;Start an undo group so the process can be undone with one undo
    (gimp-image-undo-group-start theImage)

    ;Select none
    (gimp-selection-none theImage)
    
    ;Calculate the required step size
    (if (= targetSide 0)
    	;True width is the target
    	(begin
    		(set! stepsX (step-size stepsWanted targetValue imageWidth))
    		(set! realWidth (+ (* stepsX stepsWanted) imageWidth))
    		(set! realHeight (/ (* imageHeight  realWidth) imageWidth))
    		(set! stepsY (step-size stepsWanted realHeight imageHeight))
    	)
    	
    	;False the height is the target
    	(begin
    		(set! stepsY (step-size stepsWanted targetValue imageHeight))
    		(set! realHeight (+ (* stepsY stepsWanted) imageHeight))
    		(set! realWidth (/ (* imageWidth  realHeight) imageHeight))
    		(set! stepsX (step-size stepsWanted realWidth imageWidth))
    	)
    )
    
   ;Set the first resize values
   (set! nextWidth (+ imageWidth stepsX))
   (set! nextHeight (+ imageHeight stepsY))

   ;Change the image size by a step at a time
   (while (> stepsWanted 0)
;   	(gimp-layer-scale theLayer nextWidth nextHeight FALSE)
   	(gimp-image-scale theImage nextWidth nextHeight)
   	(set! stepsWanted (- stepsWanted 1))
   	(set! nextWidth (+ nextWidth stepsX))
   	(set! nextHeight (+ nextHeight stepsY))
   )

    ;Finish the undo group for the process
    (gimp-image-undo-group-end theImage)

    ;Ensure the updated image is displayed now
    (gimp-displays-flush)


))


(script-fu-register "script-fu-stair-resize"
            _"<Image>/Script-Fu/Misc/Stair Interpolation..."
            "Resizes the image to desired size using small steps"
            "Harry Phillips"
            "Harry Phillips"
            "13 August 2007"
            "*"
            SF-IMAGE		"Image"				0
            SF-DRAWABLE		"Drawable"			0
	    SF-OPTION		"Target side"			'("Width" "Height")
	    SF-VALUE		"Target value"			"1024"
	    SF-ADJUSTMENT	"Numbers of steps"		'(10 2 20 1 1 0 0)
)            

