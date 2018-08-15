;  Add a fogging layer effect to an image.

;  A script-fu version of the Python-fu script "foggify.py" written by James
; Hentsridge in 1999.
;  This version may be useful for Windows users who are unable to get py-fu
;   to work on their system.

; This is my first script-fu script, so I welcome any criticisms and suggestions 
; on how to implement it better or more efficiently.

; (c) 2007 Nick Coleman
; ncoleman-at-internode-dot-on-dot-net

;===========================================================

; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; ==============================================================
; Version history

; 8 Oct 2007	Initial conversion from foggify.py

; ===============================================================

(define (script-fu-foggify inImage inDrawable inLayerName inColour inTurbulence inOpacity)

	(let* (
			(width (car (gimp-drawable-width inDrawable)))
			(height (car (gimp-drawable-height inDrawable)))
			(fog (car (gimp-layer-new inImage width height RGBA-IMAGE inLayerName inOpacity NORMAL-MODE)))
			(mask (car (gimp-layer-create-mask fog ADD-WHITE-MASK)))
			(old_bg (car (gimp-context-get-background)))						
		) ; end of local variables
		
		; debugging test
		;(gimp-message-set-handler MESSAGE-BOX)
		;(gimp-message (number->string width 10))	; base 10 : (8, 10, 16, e, f)
		;(tracing 1)		;1  turns on tracing -- LOTS of output, put this only where needed
		
		; Start of processing.
		(gimp-image-undo-group-start inImage)
		
		; set up the layer
		(gimp-context-set-background inColour)
		(gimp-drawable-fill fog BACKGROUND-FILL)
		(gimp-context-set-background old_bg)
		(gimp-image-add-layer inImage fog -1)
		; add the mask
		(gimp-layer-add-mask fog mask)
		; add clouds
		(plug-in-plasma 1 inImage mask (realtime) inTurbulence)	; 1 = non-interactive ??, always needed when calling plug-in
		(gimp-layer-remove-mask fog MASK-APPLY)
		
		; Finish of processing
		(gimp-image-undo-group-end inImage)
		(gimp-displays-flush)		
	)
)

(script-fu-register
    "script-fu-foggify"
	"<Image>/Script-Fu/Render/Clouds/Foggify"
	"Adds a layer of fog to the image."
	"Original py-fu script by James Henstridge (1999). \
	Converted by Nick Coleman"
	""
	"October 2007"
	"RGB*, GRAY*"
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-STRING "Layer name"	"Clouds"
	SF-COLOR "Fog colour:"	'(240 180 70)
	SF-ADJUSTMENT "Turbulence"	'(1.00 0.00 10.00 0.5 1.0 2 SF-SLIDER)
	SF-ADJUSTMENT "Opacity:"	'(100 0 100 1 5 2 SF-SLIDER)
	)
