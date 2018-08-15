; pen-button.scm
; Gimp script to create a line of text followed by a pen (to give the effect
; that the pen just wrote it).
; First part of the Brugger Ink. "Pen" theme.
;
; Author: "Zow" Terry Brugger <zow@acm.org>
; Date: 1/30/1999
;
; This script is provided under the GPL, version 2.
; No warranty is expressed or implied. See http://www.gnu.org/ for details.

; Add the text
(define (add-text-na image text text-size text-foundry 
		  text-family text-weight text-slant text-set-width 
		  text-spacing text-angle text-color shadow-color text-extents)
  (let* (
	 ; Figure out where the text starts
	 (start-text-x (- (/ (car (gimp-image-width image)) 2)
			  (/ (get-text-width text-extents) 2)))
	 (start-text-y (- (/ (car (gimp-image-height image)) 2)
			  (/ (get-text-height  text-extents) 2)))

	 ; Add the text to the text layer in the given text color
	 ; We cheat to set the text-color
	 (text-layer (gimp-palette-set-foreground text-color))
	 (text-layer (car (gimp-text image -1 start-text-x start-text-y 
				      text 0 TRUE text-size PIXELS 
				      text-foundry text-family text-weight 
				      text-slant text-set-width text-spacing)))
	 )
    ; Deselect the text
    (gimp-selection-none image)

    ) ; end let*
  ) ; end add-text

; Add the pen
(define (add-pen image end-text-x)
  ; Select the tip midway up at the end of the text.
  (let*
      (
       (height (car(gimp-image-height image)))
       (half-height (/ height 2))
       (pt_arr '(end-text-x half-height
			    (+ end-text-x 16) (+ half-height 48)
			    (+ end-text-x 5) (+ half-height 60)) )
       )
    (gimp-free-select image 6 pt_arr REPLACE 0 0 0)
  )
  ; Fill in the tip with a Brushed Aluminium gradient.
  
  ; Select the shaft on the tip.

  ; Fill in the shaft with a Horizon 2 gradient.

  ; Cap the pen off by selecting a circle at the end of the shaft,

  ; and filling it in solid blue.

  ) ; end add-pen

; Create a button with the given text followed by a pen
(define (script-fu-pen-button text text-size text-foundry text-family 
			      text-weight text-slant text-set-width 
			      text-spacing text-color background-color)
  (let*
      (
       ; Save the palette colors
       (old-fg-color (car (gimp-palette-get-foreground)))
       (old-bg-color (car (gimp-palette-get-background)))

       ; Calculate the height & width necessary for the given text
       ; Get the amount of space that the text will take up
       (text-extents (gimp-text-get-extents
		      text text-size PIXELS text-foundry text-family
		      text-weight text-slant text-set-width text-spacing))
       ; Get the height of the text
       (text-height (get-text-height text-extents))
       ; And the width, as we'll need that too
       (text-width (get-text-width text-extents))

       ; extra space for aestedics
       (border 10)
       ; extents determine height & width
       (height (+ text-height border))
       (width (+ text-width border))
       ; Figure out where the text starts
       (start-text-x (- (/ width 2)
			(/ text-width 2)))
       (start-text-y (- (/ height 2)
			(/ text-height 2)))
       (end-text-x (+ (/ width 2)
		      (/ text-width 2)))

       ; Create a new image to draw on
       (image (car (gimp-image-new width height RGB)))
       ; Every image needs a background
       ; We kind of cheat to set the color first
       (background (car (gimp-layer-new image width height RGBA_IMAGE 
					"Background" 100 NORMAL)))
       ) ; end definitions

    ; Set up the image for processing
    (set-up image background background-color)

    ; Add the text
    (add-text image text text-size text-foundry 
	      text-family text-weight text-slant text-set-width 
	      text-spacing 0 text-color background-color
	      start-text-x start-text-y)

    ; Add the pen
    (add-pen image end-text-x)

    ; Clean up
    (clean-up image background old-fg-color old-bg-color)

    ) ; end let*

  ) ; end script-fu-pen-button

; Register the script
(script-fu-register "script-fu-pen-button"
		    "<Toolbox>/Xtns/Script-Fu/Web page themes/Pen/Button"
		    "Creates a text button for the Brugger Ink Pen theme."
		    "\"Zow\" Terry Brugger <zow@acm.org>"
		    "(c)1999 \"Zow\" Terry Brugger"
		    "1/30/1999"
		    ""
		    SF-VALUE  "Text"            "\"Pen\""
		    SF-VALUE  "Text size"       "32"
		    SF-VALUE  "Foundry"         "\"freefont\""
		    SF-VALUE  "Family"          "\"coronetscript\""
		    SF-VALUE  "Weight"          "\"normal\""
		    SF-VALUE  "Slant"           "\"r\""
		    SF-VALUE  "Set width"       "\"normal\""
		    SF-VALUE  "Spacing"         "\"p\""
		    SF-COLOR  "Text color"      '( 32  32 255)
		    SF-COLOR  "Background"      '(255 255 255)
		    ) ; end script-fu-register
