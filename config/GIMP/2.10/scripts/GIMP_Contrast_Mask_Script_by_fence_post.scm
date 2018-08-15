; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
; This script was made as the result of a request by Photocomix (http://www.flickr.com/photos/97844002@N00/)
; and uses steps he described in creating a contrast mask in a method different from
; a "typical" contrast mask due to a bug in GIMP's Overlay Mode. The script makes
; a duplicate of the active layer and places it above the active layer. The blend mode of
; the duplicate layer is set to Hard Light. The bottom layer is desaturated using the desaturation
; type set by the user and the colors of the original layer can be inverted if the user so chooses.
; A Gaussian Blur is applied using horizontal and vertical blur settings
; set by the user when the script is first run. The layers can be merged if desired.
;
; A "From Camera?" default setting was adding per specs from Photocomix (PC)
; Changed the default blur setting to 3 per PC
; Added layer names that coincide with the actions be performed on them.


; The Script can be found in the Image's Filters Menu > Photo > Photocomix Contrast Mask...
;
; Updated script on October 3, 2008 to work in GIMP 2.6

; Define the function

(define (script-fu-photocomix-contrast-mask image drawable hblur vblur camera-blur desat merge invert)

; Assign the variables

(let* (
(drawable (car (gimp-image-get-active-layer image))) ; gets the active layer
(float 0) ; the variable which will become the upper layer
(buffer-name 0) ; the variable to hold the copied layer
(orig-select 0) ; the variable used to see if there's a selection in place before the script is run.
; If a selection is there, it's temporarily turned off and saved as a channel until
; the script is finished. Then the selection is turned back on.
)


; Perform the script

; Create an undo group so the script can be undone in one step.

(gimp-image-undo-group-start image) 

; Adds an alpha channel to the active layer if one doesn't exist

(gimp-layer-add-alpha drawable)

; Saves a selection to a channel if a selection exists.

(set! orig-select (car (gimp-selection-save image)))

; Turns off the selection so the script will work on the whole layer. 

(gimp-selection-none image) 


; Makes a copy of the active layer and pastes it into the image so there's an unchanged original
; to work with later if the user so chooses.

(set! buffer-name (car (gimp-edit-named-copy drawable "tmp-buffer")))
(set! float (car (gimp-edit-named-paste drawable buffer-name FALSE))) 
(gimp-floating-sel-to-layer float) 
(gimp-image-lower-layer image float)
(gimp-drawable-set-name float "Original Image")
(gimp-image-set-active-layer image drawable)



; Desaturates the active layer using desaturation type specified by the user.

(gimp-desaturate-full drawable desat) 

; Test to see if Camera-Blur Option is selected.  If so, sets hblur/vblur to 5.
; Else vblur/hblur settings are set by user.  Default is let user set vblur/hblur.

(if (= camera-blur TRUE)
  (begin
    (set! hblur 5)
    (set! vblur 5)
  )
)


; Inverts the colors of the active layer.

(if (= invert FALSE)
  (begin
  (gimp-invert drawable) 
  (gimp-drawable-set-name drawable "Blurred, Desaturated, Inverted Layer")
  )
  (gimp-drawable-set-name drawable "Blurred, Desaturated, Non-Inverted Layer")
)
  

; Runs the Gaussian blur plugin in a NON-INTERACTIVE fashion using values assigned by the user

(plug-in-gauss-iir2 	RUN-NONINTERACTIVE 
				image ; run it on the current image
				drawable ; run it on the active layer
				hblur ; uses a horizontal blur as assigned by the user
				vblur ; uses a vertical blur as assigned by the user
)


; Pastes the copied layer into the variable called float

(set! float (car (gimp-edit-named-paste drawable buffer-name FALSE))) 

; Converts the floating selection to an actual layer

(gimp-floating-sel-to-layer float) 

; sets the layer blend mode to Hard Light

(gimp-layer-set-mode float HARDLIGHT-MODE)
(gimp-drawable-set-name float "Hard Light Layer") 


; Checks to see if the user wants the layers merged and merges them if TRUE.  Otherwise
; no merge takes place.

(if (= merge TRUE) 
  (begin
  (gimp-image-merge-down image float CLIP-TO-IMAGE)
  (set! drawable (car (gimp-image-get-active-layer image)))
  (gimp-drawable-set-name drawable "Merged Layers")
  )
)

; Restores the original selection if one existed

(gimp-selection-load orig-select)

; Deletes the buffer
 
(gimp-buffer-delete buffer-name) 

; Delete the channel used to hold the original selection

(gimp-image-remove-channel image orig-select) 

; Update the image display

(gimp-displays-flush) 

; end undo group

(gimp-image-undo-group-end image) 
)
)

; Register Script

(script-fu-register "script-fu-photocomix-contrast-mask"
"<Image>/Filters/Enhance/Photocomix Contrast Mask..."
"Applies a Contrast Mask to reduce overall contrast, and bring out more detail in highlights and shadows"
"Art Wade"
"Art Wade"
"October 3, 2008"
"RGB*"
SF-IMAGE "Image" 0
SF-DRAWABLE "Drawable" 0
SF-ADJUSTMENT "Horizontal Blur" '(3 0.1 1000 0.1 50 1 1)
SF-ADJUSTMENT "Vertical Blur" '(3 0.1 1000 0.1 50 1 1)
SF-TOGGLE "From Camera? (If checked, overrides horizontal/vertical blur choices above by setting values to 5)" FALSE
SF-OPTION "Desaturation Type" '("Lightness" "Luminosity" "Average")
SF-TOGGLE "Merge Layers?" FALSE
SF-TOGGLE "Skip Effect? (No contrast mask added)" FALSE
)