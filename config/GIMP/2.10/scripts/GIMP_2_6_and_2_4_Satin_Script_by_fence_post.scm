; GIMP - The GNU Image Manipulation Program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
;
; Creates a Satin texture layer based on this tutorial:
; http://www.gimpdome.com/forum/index.php?topic=3246.0
; Script can be found under Filters > Render > Satin...
; The user sets the Hue, Saturation, and Lightness Settings as desired.
; The default settings are those used in the tutorial, which is a "dark pink"

; Script updated on October 3, 2008 to work in GIMP 2.6

;Define Script

(define (fp-satin-script image drawable hue saturation lightness)

;Declare Variables

    (let* 
    (
	(theSelection 0)
	(theHeight 0)
	(theWidth 0)
	(satinLayer 0)
	(noiseLayer 0)
	(counter 15)
	(varX1 0)
	(varX2 0)
	(varY1 0)
	(varY2 0)
    )

(gimp-context-push)

; Begin Undo Group

(gimp-undo-push-group-start image)

; Save any active selections to a channel so script can be run on whole layers and then turn off selection

  (set! theSelection (car (gimp-selection-save image)))
  (gimp-selection-none image)

; Set height, width and type based on current image values

(set! theHeight (car (gimp-image-height image)))
(set! theWidth (car (gimp-image-width image)))

; Set the foreground / background colors to black and white

(gimp-context-set-background '(255 255 255))
(gimp-context-set-foreground '(0 0 0))

; Create the Satin Layer, fill it with white and add it to the top of the image

(set! satinLayer (car (gimp-layer-new image theWidth theHeight RGBA-IMAGE "Satin Layer" 100 0)))
(gimp-image-add-layer image satinLayer -1)
(gimp-drawable-fill satinLayer BACKGROUND-FILL)
(gimp-image-raise-layer-to-top image satinLayer)

; Set up a "counter" so that as long as the the counter's value is greater than zero, the 
; gradient will be applied.  In this case, the gradient will be applied 15 times, since the
; counter was set to 15 in the let* block.

(while (> counter 0)

; Randomize the X and Y values so that the gradient can be applied in a random fashion

(set! varX1 (random theWidth))
(set! varX2 (random theWidth))
(set! varY1 (random theHeight))
(set! varY2 (random theHeight))


; Apply gradient

(gimp-edit-blend satinLayer FG-BG-RGB-MODE DIFFERENCE-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 3 0.2 TRUE varX1 varY1 varX2 varY2)

; Minus one from repeat count

(set! counter (- counter 1))

)

; Run the Gaussian Blur plugin using the settings from the tutorial

(plug-in-gauss RUN-NONINTERACTIVE image satinLayer 20.0 20.0 1)

; Run the Edge Detect plugin using the settings from the tutorial

(plug-in-edge RUN-NONINTERACTIVE image satinLayer 2.0 2 0)

; Invert the colors of the satinLayer

(gimp-invert satinLayer)

; Run the Levels Tool using the settings from the tutorial

(gimp-levels satinLayer HISTOGRAM-VALUE 135 255 1.0 0 255)

; Run the Gaussian blur plugin using the settings from the tutorial

(plug-in-gauss RUN-NONINTERACTIVE image satinLayer 2.5 2.5 1)

; Set the foreground color to a middle gray

(gimp-context-set-foreground '(128 128 128))

; Create the noiseLayer, fill it with the new foreground color
; add it to the image above the satinLayer, give it a name
; and set its blend mode to overlay

(set! noiseLayer (car (gimp-layer-copy satinLayer TRUE)))
(gimp-drawable-fill noiseLayer FOREGROUND-FILL)
(gimp-image-add-layer image noiseLayer -1)
(gimp-drawable-set-name noiseLayer "Noise Layer")
(gimp-layer-set-mode noiseLayer OVERLAY-MODE)

; Run the RGB Noise Scatter, Motion Blur, and Displace plugins
; on the noiseLayer using the settings from the tutorial

(plug-in-rgb-noise RUN-NONINTERACTIVE image noiseLayer 0 0 0.2 0.2 0.2 0)
(plug-in-mblur RUN-NONINTERACTIVE image noiseLayer 0 15 135 0 0)
(plug-in-displace RUN-NONINTERACTIVE image noiseLayer 15 15 1 1 satinLayer satinLayer 1)

; Merge the noiseLayer and satinLayer together

(gimp-image-merge-down image noiseLayer CLIP-TO-IMAGE)

; Tell GIMP that the result from the merged layers (the active layer)
; is now called the satinLayer

(set! satinLayer (car (gimp-image-get-active-layer image)))

; Run the Colorize Tool using the values set by the User

(gimp-colorize satinLayer hue saturation lightness)

; The original selection is reloaded and its channel is deleted
  
  (gimp-selection-load theSelection)
  (gimp-image-remove-channel image theSelection)

; End Undo Group

(gimp-undo-push-group-end image)

; Update display

(gimp-displays-flush)

; Resets previous user settings 

(gimp-context-pop)

)
)

; Register Script

(script-fu-register 	"fp-satin-script"
			"<Image>/Filters/Render/Satin..."
			"Create a Satin Fabric"
			"Art Wade"
			"Art Wade"
			"October 3, 2008"
			"RGB*"
			SF-IMAGE      "SF-IMAGE" 0
			SF-DRAWABLE   "SF-DRAWABLE" 0
			SF-ADJUSTMENT	  "Satin Color (order of color is R O Y G B V - Red is zero)" '(20 0 360 1 10 0 0)
			SF-ADJUSTMENT	  "Color Saturation - Its Depth" '(50 10 100 1 10 0 1)
		      SF-ADJUSTMENT	  "Color Lightness - Its Brightness" '(0 -50 70 1 10 0 1)
)
				