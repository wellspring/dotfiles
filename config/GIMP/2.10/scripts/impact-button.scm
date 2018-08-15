; impact-button.scm
; GIMP 1.0 script to create a button for the Brugger Ink Impact page layout.
;
; This is my first crack at a GIMP script, let's see if it shows.
; Hopefully my Lisp (Scheme) skills have improved since college.
;
; Author: "Zow" Terry Brugger <zow@acm.org>
; Date: 1/16/1999
;
; This script is provided under the GPL, version 2.
; No warranty is expressed or implied. See http://www.gnu.org/ for details.

; Add the impact
(define (add-impact image text-angle border
		    circle-radius circle-at-start impact-color)
  (let* (
	 ; Create a layer to place the impact on
	 (image-width (car (gimp-image-width image)))
	 (image-height (car (gimp-image-height image)))
	 (impact-layer (car (gimp-layer-new image image-width image-height
					    RGBA_IMAGE "Impact Layer"
					    100 NORMAL)))

	 ; Determine if the circle should start at the given angle or if it 
	 ; needs to be offset by 180 degrees (so that it starts at the end 
	 ; of the text).
	 (impact-angle (if circle-at-start
			   text-angle
			   (+ text-angle *pi*)))
	 (impact-angle (if (> impact-angle (* *pi* 2))
			   (- impact-angle (* *pi* 2))
			   impact-angle))

	 ; Determine how far from the center the center of the circle should be
	 ; ( (image-width - border) / 2 - radius of impact circle )
	 (impact-radius (- (/ (- (car (gimp-image-width image)) border) 2)
			   circle-radius))

	 ; the x,y center of the circle
	 ; circle-x = width/2 - cos(impact-angle)
	 (circle-x (- (/ image-width 2)
		      (* impact-radius
			 (cos impact-angle))))
	 ; circle-y = height/2 - sin(impact-angle)
	 (circle-y (- (/ image-height 2)
		      (* impact-radius
			 (sin impact-angle))))
	 )
    ; Add the new layer
    (gimp-image-add-layer image impact-layer 1)
    (gimp-image-lower-layer image impact-layer)
    (gimp-image-lower-layer image impact-layer)
    (gimp-edit-clear image impact-layer)

    ; In the impact layer, select the circle
    (gimp-ellipse-select image
			 (- circle-x circle-radius)
			 (- circle-y circle-radius)
			 (* circle-radius 2)
			 (* circle-radius 2)
			 REPLACE FALSE FALSE 0)

    ; Fill in the circle in the given impact color
    (gimp-palette-set-foreground impact-color)
    (gimp-bucket-fill image impact-layer FG-BUCKET-FILL NORMAL 100 0 FALSE 0 0)

    ; Stretch the perspective of the circle impact layer by moving the handle 
    ; closest to the center to three times the impact-radius in the opposet
    ; direction of the impact-angle
    (let* (
	   (x0 (- circle-x circle-radius))
	   (y0 (- circle-y circle-radius))
	   (x1 (+ circle-x circle-radius))
	   (y1 (- circle-y circle-radius))
	   (x2 (- circle-x circle-radius))
	   (y2 (+ circle-y circle-radius))
	   (x3 (+ circle-x circle-radius))
	   (y3 (+ circle-y circle-radius))
	   (new-x (* 3
		     impact-radius
		     (- (cos (+ impact-angle *pi*)))))
	   (new-y (* 3
		     impact-radius
		     (- (sin (+ impact-angle *pi*)))))
	   )
      (if (and (>= impact-angle 0)
	       (< impact-angle (/ *pi* 2)))
	  ; first quadrant: use point 3
	  (gimp-perspective image impact-layer TRUE
			    x0 y0
			    x1 y1
			    x2 y2
			    new-x new-y)
	  )
      (if (and (>= impact-angle (/ *pi* 2))
	       (< impact-angle *pi*))
	  ; second quadrant: use point 2
	  (gimp-perspective image impact-layer TRUE
			    x0 y0
			    x1 y1
			    new-x new-y
			    x3 y3)
	  )
      (if (and (>= impact-angle *pi*)
	       (< impact-angle (* (/ *pi* 2) 3)))
	  ; third quadrant: use point 0
	  (gimp-perspective image impact-layer TRUE
			    new-x new-y
			    x1 y1
			    x2 y2
			    x3 y3)
	  )
      (if (and (>= impact-angle (* (/ *pi* 2) 3))
	       (<= impact-angle (* *pi* 2)))
	  ; forth quadrant: use point 1
	  (gimp-perspective image impact-layer TRUE
			    x0 y0
			    new-x new-y
			    x2 y2
			    x3 y3)
	  )
      (if (or (< impact-angle 0)
	      (> impact-angle (* *pi* 2)))
	  ; error: invalid angle
	  (gimp-message "Invalid angle in add-impact.")
	  )
      ) ; end inner let*

    ; Deselect all
    (gimp-floating-sel-anchor (car (gimp-image-floating-selection image)))
    (gimp-selection-none image)

    ) ; end let*
  ) ; end add-impact

; The actual impact-button function
(define (script-fu-impact-button text text-size text-foundry text-family 
				 text-weight text-slant text-set-width 
				 text-spacing text-angle text-color 
				 shadow-color
				 impact-radius impact-at-start impact-color
				 background-color)
  (let*
      (
       ; Save the palette colors
       (old-fg-color (car (gimp-palette-get-foreground)))
       (old-bg-color (car (gimp-palette-get-background)))

       ; Adjust the text-angle so that it is between 0 and 360 degrees
       ; and convert it to radians
       (text-angle (fmod text-angle 360))
       (text-angle (if (< text-angle 0)
		       (+ 360 text-angle)
		       text-angle))
       (text-angle (* text-angle (/ *pi* 180)))

       ; Adjust the boolians into scheme form
       (impact-at-start (if (= impact-at-start TRUE)
			    t
			    ()))

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
       ; Determine the distance from the center of the text to a corner
       (text-radius (sqrt (+ (* (/ text-height 2)
				(/ text-height 2))
			     (* (/ text-width  2)
				(/ text-width  2)))))
       ; Determine tau: the angle from the center to a corner
       (tau (atan(/ (/ text-height 2)
		    (/ text-width  2))))
       ; If the angle is between 0 and 90 or 180 and 270, then the
       ; height is 10 (for a border) + 2 * the distance to the corner 
       ; * the sine of the text-angle plus tau. If the angle is between 
       ; 90 and 180 or 260 and 360, then the text-angle and tau should 
       ; be subtracted.
       (height (+ border
		  (* 2
		     text-radius
		     (abs (sin (if (or (and (>= text-angle 0)
					    (<  text-angle (/ *pi* 2)))
				       (and (>= text-angle *pi*)
					    (<  text-angle (* 3 (/ *pi* 2)))))
				   (+ text-angle tau)
				   (- text-angle tau)))))))
       ; The width would be calculated similarly, except that we need to
       ; paint the text onto the image before rotating the text. This
       ; means that we must leave the width as calculated by the extents,
       ; plus a little room for a border.
       (width (+ text-width border))
       ; Figure out where the text starts
       (start-text-x (- (/ width 2)
			(/ text-width 2)))
       (start-text-y (- (/ height 2)
			(/ text-height 2)))

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
	      text-spacing text-angle text-color shadow-color
	      start-text-x start-text-y)

    ; Add the impact
    (add-impact image text-angle border
		impact-radius impact-at-start impact-color)
    ; Clean up
    (clean-up image background old-fg-color old-bg-color)

    ) ; end let*
  ) ; end script-fu-impact-button

; Register the script
(script-fu-register "script-fu-impact-button"
		    "<Toolbox>/Xtns/Script-Fu/Web page themes/Impact/Button"
		    "Creates a text button for the Brugger Ink Impact theme."
		    "\"Zow\" Terry Brugger <zow@acm.org>"
		    "(c)1999 \"Zow\" Terry Brugger"
		    "1/16/1999"
		    ""
		    SF-VALUE  "Text"            "\"Impact\""
		    SF-VALUE  "Text size"       "32"
		    SF-VALUE  "Foundry"         "\"adobe\""
		    SF-VALUE  "Family"          "\"utopia\""
		    SF-VALUE  "Weight"          "\"bold\""
		    SF-VALUE  "Slant"           "\"r\""
		    SF-VALUE  "Set width"       "\"normal\""
		    SF-VALUE  "Spacing"         "\"p\""
		    SF-VALUE  "Angle"           "30"
		    SF-COLOR  "Text color"      '(255 255 255)
		    SF-COLOR  "Shadow color"    '(  0   0   0)
		    SF-VALUE  "Impact radius"   "16"
		    SF-TOGGLE "Impact at start" FALSE
		    SF-COLOR  "Impact"          '(  5   5 255)
		    SF-COLOR  "Background"      '(255 255 255)
		    ) ; end script-fu-register
