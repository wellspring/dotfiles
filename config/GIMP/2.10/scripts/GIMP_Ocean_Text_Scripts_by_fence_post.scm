;
; ocean-text
;
; Creates a invert semi-"adjustment layer".
;
; Alexander Melcher (a.melchers@planet.nl)
; At xMedia, The Netherlands

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; This script is a modification by Art Wade (fencepost) of Alexander Melchar's script
; so that it will work in GIMP 2.4.  Other than moving it to a new menu location
; Xtns > Logos > Ocean Text... and modifying the code so that it will work in 2.4,
; no other modifications have been made.

; Updated on October 3, 2008 to work in GIMP 2.6 - New menu location is File > Create > Logos > Ocean Text...

; Define the function

(define (script-fu-ocean-text inText
	                      inFontSize
	                      inFont
	)

(let* (
	(theImage 0)
	(textLayer 0)
	(background 0)
	(shadowLayer 0)
	(shadowBlur 0)
	(waveLayer 0)
	(waveLayerMask 0)
	)

; Set up the script so that the user settings can be reset after the script is run

  (gimp-context-push)

; Create the image

(set! theImage (car (gimp-image-new 256 256 RGB)))

; Disable undoing

(gimp-image-undo-disable theImage)


(gimp-context-set-foreground '(128 128 128))
(gimp-context-set-background '(255 255 255))

; Create the initial text layer and background layer

(set! textLayer (car (gimp-text-fontname theImage -1 0 0 inText
	                      (* 30 (/ inFontSize 100)) TRUE inFontSize PIXELS
	                      inFont)))
(gimp-image-resize theImage (car (gimp-drawable-width textLayer))
	                   (car (gimp-drawable-height textLayer)) 0 0)
(set! background (car (gimp-layer-new theImage
	                       (car (gimp-image-width theImage))
	                       (car (gimp-image-height theImage))
	                       1 "Background" 100 0)))

(gimp-image-add-layer theImage background 0)
(gimp-drawable-fill background 1)	

(gimp-image-lower-layer-to-bottom theImage background)
(gimp-context-set-foreground '(0 0 0))

; Create the shadow layer

(gimp-image-set-active-layer theImage textLayer)
(set! shadowLayer (car (gimp-layer-copy textLayer TRUE)))
(gimp-image-add-layer theImage shadowLayer -1)
(gimp-image-lower-layer theImage shadowLayer)
(gimp-edit-clear shadowLayer)
(gimp-selection-layer-alpha textLayer)
(set! shadowBlur (* 6 (/ inFontSize 100)))
(gimp-selection-grow theImage (/ shadowBlur 2))
	

(gimp-edit-bucket-fill shadowLayer 0 0 80 0 FALSE 0 0)
(gimp-selection-none theImage)
(gimp-layer-set-lock-alpha shadowLayer FALSE)
	(if (>= shadowBlur 1.0)
	    (plug-in-gauss-rle 1 theImage shadowLayer shadowBlur TRUE TRUE)
	)	


; Add the ocean waves
	(gimp-context-set-gradient "Horizon 2")
	(gimp-image-set-active-layer theImage textLayer)
	(set! waveLayer (car (gimp-layer-new theImage
	                      (car (gimp-image-width theImage))
	                      (car (gimp-image-height theImage))
	                      1 inText 100 0)))
	
	(gimp-image-add-layer theImage waveLayer -1)
	(gimp-image-lower-layer theImage waveLayer)
	(gimp-edit-blend waveLayer 3 0 0 100 0 0 FALSE FALSE 0 0 TRUE
	            (/ (car (gimp-image-width theImage)) 2) 0
	            (/ (car (gimp-image-width theImage)) 2)
                    (car (gimp-image-height theImage)))	
	(plug-in-ripple 1 theImage waveLayer 100 5 1 0 1 TRUE FALSE)
	(plug-in-gauss-iir 1 theImage waveLayer 3.33334 TRUE TRUE)
	; And make it a text
	(set! waveLayerMask (car (gimp-layer-create-mask waveLayer 1)))
	(gimp-layer-add-mask waveLayer waveLayerMask)	
	(gimp-selection-layer-alpha textLayer)
	(gimp-edit-bucket-fill waveLayerMask 1 0 100 0 FALSE 0 0)
	(gimp-selection-none theImage)


	; Finishing touch (bevel the text layer)
	(gimp-image-set-active-layer theImage textLayer)
	(gimp-drawable-set-name textLayer "Bevel")
	(gimp-layer-set-mode textLayer 5)
	(plug-in-bump-map 1 theImage textLayer textLayer 225 20 5 0 0 0 120
                          TRUE FALSE 0)

	; Restore palette
	(gimp-context-set-foreground '(128 128 128))
	(gimp-context-set-background '(255 255 255))

	; Display the image & re-enable undoing
	(gimp-image-undo-enable theImage)
	(gimp-image-clean-all theImage)
	(gimp-display-new theImage)

	; Force update
	(gimp-displays-flush)

	; Return
	(list theImage)

; Resets previous user settings  
  
(gimp-context-pop)

)
)

; Register script-fu-ocean-text

(script-fu-register
    "script-fu-ocean-text"
    "<Toolbox>/Xtns/Logos/Ocean Text..."
    "Creates a text banner with an ocean wave inside."
    "Alexander Melchers; Art Wade"
    "2002, Alexander Melchers, xMedia; 2008 Art Wade"
    "14th December 2002; October 8, 2008"
    ""
    SF-STRING     "Text"               "Ocean Text"
    SF-ADJUSTMENT "Font Size (pixels)" '(100 2 1000 1 0 0 1)
    SF-FONT       "Font"               "Impact"
)


