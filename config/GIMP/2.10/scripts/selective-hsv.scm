;
; selective-hsv
;
; Allows you to change the hue, saturation and value of a selection and all
; the area around it at the same time, using two different adjustments.
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

; Define the function

(define (script-fu-selective-hsv inImage
	                         inLayer
	                         inIntH
	                         inIntS
	                         inIntV
	                         inIntApply
	                         inExtH
	                         inExtS
	                         inExtV
	                         inExtApply
	                         inCopy
	                         inFlatten
	)

	(if (= (car (gimp-selection-is-empty inImage)) TRUE)
		(begin
			(gimp-message "This script needs a selection to work on.")
			(list -1 -1)
		)
		(begin
			; Select the image; make a copy if needed
			(set! theImage (if (= inCopy TRUE)
			               (car (gimp-channel-ops-duplicate inImage))
			               inImage)
			)

			; Group undo information
			(gimp-undo-push-group-start theImage)

			; If requested to flatten image, do it now
			(if (= inFlatten TRUE)
				(gimp-image-flatten theImage)
				()
			)

			; Select the layer to which to apply the HSV changes
			(set! theLayer (if (= inFlatten TRUE)
			               (aref (cadr (gimp-image-get-layers theImage)) 0)
			               (if (= inCopy TRUE)
			               (car (gimp-image-get-active-layer theImage))
			               inLayer))
			)

			; Invert the selection
			(gimp-selection-invert theImage)

			; HSV adjust the external selection
			(gimp-hue-saturation theLayer inExtApply inExtH
			                     inExtV inExtS)

			; Re-invert the selection to regain the original
			(gimp-selection-invert theImage)

			; HSV adjust the internal selection
			(gimp-hue-saturation theLayer inIntApply inIntH
			                     inIntV inIntS)

			; Group undo information
			(gimp-undo-push-group-end theImage)

			; If a copy was made, show the new image
			(if (= inCopy TRUE)
				(begin
					(gimp-image-clean-all theImage)
					(gimp-display-new theImage)
				)
				()
			)

			; Force updates
			(gimp-displays-flush)

			; Return the results
			(list theImage inLayer)
		)
	)
)

; Register script-fu-selective-hsv

(script-fu-register
    "script-fu-selective-hsv"
    "<Image>/Script-Fu/xMedia/Selective HSV"
    "Allows you to change the hue, saturation and value of a selection and all the area around it at the same time, using two different adjustments."
    "Alexander Melchers"
    "2002, Alexander Melchers, xMedia"
    "8th November 2002"
    "RGB*"
    SF-IMAGE      "The Image"          0
    SF-DRAWABLE   "The Layer"          0
    SF-ADJUSTMENT "Internal Hue"       '(0 -180 180 1 1 0 0 0)
    SF-ADJUSTMENT "Saturation"         '(0 -100 100 1 1 0 0 0)
    SF-ADJUSTMENT "Value"              '(0 -100 100 1 1 0 0 0)
    SF-OPTION     "Apply To"           '("All Hues" "Red Hues" "Yellow Hues"
                                         "Green Hues" "Cyan Hues" "Blue Hues"
                                         "Magenta Hues")
    SF-ADJUSTMENT "External Hue"       '(0 -180 180 1 1 0 0 0)
    SF-ADJUSTMENT "Saturation"         '(0 -100 100 1 1 0 0 0)
    SF-ADJUSTMENT "Value"              '(0 -100 100 1 1 0 0 0)
    SF-OPTION     "Apply To"           '("All Hues" "Red Hues" "Yellow Hues"
                                         "Green Hues" "Cyan Hues" "Blue Hues"
                                         "Magenta Hues")
    SF-TOGGLE     "Work on Copy"       FALSE
    SF-TOGGLE     "Flatten Image"      FALSE
)
