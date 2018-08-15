; Helper functions used by numerous Gimp scripts
; Author: "Zow" Terry Brugger <zow@acm.org>
;
; This script is provided under the GPL, version 2.
; No warranty is expressed or implied. See http://www.gnu.org/ for details.

; Retrieve the width of the text from the extents list
(define (get-text-width extents)
  (car extents))

; Retrieve the height of the text from the extents list
(define (get-text-height extents)
  (cadr extents))

; Retrieve the ascent of the text from the extents list
(define (get-text-ascent extents)
  (caddr extents))

; Retrieve the descent of the text from the extents list
(define (get-text-descent extents)
  (cadr (cddr extents)))

; Add the text
(define (add-text image text text-size text-foundry 
		  text-family text-weight text-slant text-set-width 
		  text-spacing text-angle text-color shadow-color
		  start-text-x start-text-y)
  (let* (
	 ; Add the text to the text layer in the given text color
	 ; We cheat to set the text-color (by executing set-forground in let*)
	 (text-layer (gimp-palette-set-foreground text-color))
	 (text-layer (car (gimp-text image -1 start-text-x start-text-y 
				      text 0 TRUE text-size PIXELS 
				      text-foundry text-family text-weight 
				      text-slant text-set-width text-spacing)))
	 ; Declare the shadow layers
	 (shadow-layer ())
	 (darker-shadow-layer ())
	 ; Determine if we need to use interpolation in the rotation
	 (  interpolate (if (= text-angle 0)
			    FALSE
			    TRUE)  )
	 )
    ; Rotate the text by the given amount
    (gimp-rotate image text-layer interpolate text-angle)

    ; Deselect the text
    (gimp-selection-none image)

    ; Duplicate the text layer to the shadow layer
    (set! shadow-layer (car (gimp-layer-copy text-layer FALSE)))
    (gimp-layer-set-name shadow-layer "Shadow Layer")
    (gimp-image-add-layer image shadow-layer 1)

    ; In the shadow layer, change the given text color to the 
    ; given shadow color
    (gimp-by-color-select image shadow-layer text-color 128 REPLACE TRUE
			  FALSE 0 FALSE)
    (gimp-palette-set-foreground shadow-color)
    (gimp-bucket-fill image shadow-layer FG-BUCKET-FILL NORMAL 100 0 FALSE 0 0)

    ; Deselect all
    (gimp-selection-none image)

    ; Gausian Blur to create the shadow
    (plug-in-gauss-iir 1 image shadow-layer 5.0 TRUE TRUE)

    ; Duplicate the shadow layer to darken the shadow
    (set! darker-shadow-layer (car (gimp-layer-copy shadow-layer FALSE)))
    (gimp-layer-set-name darker-shadow-layer "Darker Shadow Layer")
    (gimp-image-add-layer image darker-shadow-layer 1)

    ) ; end let*
  ) ; end add-text

; Function to set up the image for processing
(define (set-up image background background-color)
  
  ; Disable the undo buffer
  (gimp-image-disable-undo image)

  ; Add the background
  (gimp-image-add-layer image background 1)
  (gimp-palette-set-background background-color)
  (gimp-edit-fill image background)

  ) ; end set-up

; Function to clean up when we're done
(define (clean-up image background old-fg-color old-bg-color)

  ; Flaten the layers
  (gimp-image-set-active-layer image background)
  (gimp-image-flatten image)

  ; Restore the palette
  (gimp-palette-set-foreground old-fg-color)
  (gimp-palette-set-background old-bg-color)

  ; Enable the undo buffer
  (gimp-image-enable-undo image)

  ; Display the image!
  (gimp-display-new image)
  ) ; end clean-up

