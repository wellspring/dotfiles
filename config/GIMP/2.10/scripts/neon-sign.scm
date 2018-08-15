; neon-sign.scm v0.4
; Copyright (c) 1998 Mike Oliphant (oliphant@ling.ed.ac.uk)
;
; A Script-Fu script for the GIMP that generated blinking neon signs
; from (almost) any image. The image produced is savable as an animated
; gif. The basic ideas implemented here came from Spencer Kimball's neon
; text script.
;
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
;
; The script creates three menu entries under Gimp's Script-Fu menu:
;
;  o Alchemy->Neon Sign              -- Creates a neon sign
;  o Animators->Flashing neon sign   -- Creates a two-layer, flashing neon sign
;  o Animators->Pulsating neon sign  -- Creates a multi-layer neon sign that
;                                       pulsates
;
; NOTES:
;
;  o The source image should have a transparent background
;  o The image should ideally be drawn with a sharp-edged brush
;  o If you want to save the image as an animated gif, make sure that
;    you convert it to an indexed palette first
;  o The GFig plugin is very useful for generating images to turn
;    into neon signs
;
;
; If you use this script to create web pages graphics, it would be cool if
; you would put a note a link somewhere to the page: 
;
;         http://www.ling.ed.ac.uk/~oliphant/gimp/neon/neon-sign.html 
;
;
; Revision history:
;
;   v0.4: - All aspects of the tube color are now used -- hue, saturation,
;           and brightness
;         - Pulsating signs can now be generated
;   v0.3: - Fixed the hue-offset calculation (it now does all colors correctly)
;   v0.2: - Fixed script exiting if tube-width was too small
;   v0.1: - First public release
;
; Changed on June 15, 2000 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.1.26
;
; Changed on December 9, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.3
;
; Changed on January 29, 2004 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 2.0pre3


;; Get the integer part of a number

(define (floor x) (- x (fmod x 1)))

;; Functions to create spline curves to send to gimp-curves-spline

(define (set-pt a index x y)
  (prog1
   (aset a (* index 2) x)
   (aset a (+ (* index 2) 1) y)))

(define (gen-points x1 y1 x2 y2 x3 y3)
  (let* ((a (cons-array 6 'byte)))
    (set-pt a 0 x1 y1)
    (set-pt a 1 x2 y2)
    (set-pt a 2 x3 y3)
    a))

(define (gen-diff diff)
  (gen-points 0 0 (- 127 diff) (+ 127 diff) 255 255))


;; Convert HSV ([0-360],[0-1],[0-1]) to RGB ([0-1],[0-1],[0-1])

(define (hsv-to-rgb color)
  (let* ((h (car color))
		 (s (cadr color))
		 (v (caddr color)))
	(if (= s 0)
		(list v v v)
		(let* ((quad (/ h 60))
			   (i (floor quad))
			   (f (- quad i))
			   (p (* v (- 1 s)))
			   (q (* v (- 1 (* s f))))
			   (t (* v (- 1 (* s (- 1 f))))))
		  (cond ((= i 0) (list v t p))
				((= i 1) (list q v p))
				((= i 2) (list p v t))
				((= i 3) (list p q v))
				((= i 4) (list t p v))
				(t (list v p q)))))))


;; Do HSV to RGB conversion using gimp ranges

(define (gimp-hsv-to-rgb color)
  (let* ((h (car color))
		 (s (cadr color))
		 (v (caddr color))
		 (rgb (hsv-to-rgb (list h (/ s 100.0) (/ v 100.0))))
		 (r (car rgb))
		 (g (cadr rgb))
		 (b (caddr rgb)))
	(list (* r 255) (* g 255) (* b 255))))


;; Convert RGB ([0-1],[0-1],[0-1]) to HSV ([0-360],[0-1],[0-1])

(define (rgb-to-hsv color)
  (let* ((r (car color))
	 (g (cadr color))
	 (b (caddr color))
	 (cmin (min r (min g b)))
	 (cmax (max r (max g b)))
	 (diff (- cmax cmin))
	 (rc (/ (- cmax r) diff))
	 (gc (/ (- cmax g) diff))
	 (bc (/ (- cmax b) diff))
	 (h (/ (if (= r cmax)
			   (- bc gc)
			   (if (= g cmax)
				   (+ 2.0 (- rc bc))
				   (+ 4.0 (- gc rc))))
		   6.0)))
	(list (if (= cmin cmax)
			  0
			  (* 360 (if (< h 0.0)
					 (+ h 1.0)
					 h)))
		  (if (= cmin cmax)
			  0
			  (/ (- cmax cmin) cmax))
		  cmax)))


;; Do RGB to HSV in gimp ranges

(define (gimp-rgb-to-hsv color)
  (let* ((r (car color))
		 (g (cadr color))
		 (b (caddr color))
		 (hsv (rgb-to-hsv (list (/ r 255.0) (/ g 255.0) (/ b 255.0))))
		 (h (car hsv))
		 (s (cadr hsv))
		 (v (caddr hsv)))
	(list h (* s 100.0) (* v 100.0))))

;; Convert a hue to a hue-offset

(define (hue-to-offset hue)
  (if (> hue 180)
          (- hue 360)
          hue))

(define (neon-sign-rgb orig-img orig-draw tube-width do-trans
					   bg-color tube-color do-glow)
  (let* ((hsv (gimp-rgb-to-hsv tube-color))
		 (hue (car hsv))
		 (sat (cadr hsv))
		 (bright (caddr hsv)))
	(neon-sign orig-img orig-draw tube-width do-trans bg-color hue sat bright
			   do-glow)))

;; Generate a neon sign (either on or off)

(define (neon-sign orig-img orig-draw tube-width do-trans bg-color hue sat
				   brightness do-glow)
  (let* ((width (car (gimp-drawable-width orig-draw)))
		 (height (car (gimp-drawable-height orig-draw)))
		 (img (car (gimp-image-duplicate orig-img)))
		 (draw (car (gimp-image-get-active-layer img)))
		 (outline-grow (max 1 (* tube-width .2)))
		 (glow-grow (max 1 (* tube-width .2)))
		 (feather (max 1 (* tube-width 3)))
		 (feather1 (max 1 (* tube-width .6)))
		 (feather2 (* tube-width 1.3))
		 (inc-shrink (max 1 (* tube-width .2)))
		 (glow-layer 
		  (if (= do-glow TRUE)
			  (car (gimp-layer-new img width height
								   RGBA-IMAGE "Neon Glow" 100 NORMAL-MODE))
			0))
		 (bg-layer (if (= do-trans FALSE)
					   (car (gimp-layer-new img width
											height RGB-IMAGE "Neon Sign"
											100 NORMAL-MODE))
					   0))
		 (selection 0)
		 (old-fg (car (gimp-palette-get-foreground)))
		 (old-bg (car (gimp-palette-get-background))))
    (gimp-image-undo-disable img)
    (if (= do-trans FALSE) (gimp-image-add-layer img bg-layer 1))
    (if (= do-glow TRUE) (gimp-image-add-layer img glow-layer 1))

    (gimp-palette-set-background '(0 0 0))
    (gimp-selection-layer-alpha draw)
    (set! selection (car (gimp-selection-save img)))
    (gimp-selection-none img)

	(if (= do-glow TRUE) (gimp-edit-clear glow-layer))

    (gimp-edit-fill draw BACKGROUND-FILL)

	(if (= do-trans FALSE)
		(prog1
		 (gimp-palette-set-background bg-color)
		 (gimp-edit-fill bg-layer BACKGROUND-FILL)))

	(gimp-selection-load selection)

	(gimp-palette-set-background (gimp-hsv-to-rgb (list hue 0 brightness)))

	(gimp-edit-fill draw BACKGROUND-FILL)

	(gimp-selection-shrink img tube-width)
	(gimp-palette-set-background '(0 0 0))

	(if (= (car (gimp-selection-is-empty img)) FALSE)
		(prog1
		 (gimp-edit-fill selection BACKGROUND-FILL)
		 (gimp-edit-fill draw BACKGROUND-FILL)))

	(gimp-selection-none img)
	(plug-in-gauss-rle 1 img draw feather1 TRUE TRUE)

	(gimp-selection-load selection)
	(plug-in-gauss-rle 1 img draw feather2 TRUE TRUE)
		 
    (gimp-selection-none img)

	(gimp-hue-saturation draw 0 (hue-to-offset hue) -15 sat)


;; Do hilighting using the spline curves from neon-logo.scm

	(gimp-selection-load selection)
	(gimp-selection-feather img inc-shrink)
	(gimp-selection-shrink img inc-shrink)
	(gimp-curves-spline draw 0 6 (gen-diff (* 10 (/ brightness 100.0))))

	(gimp-selection-load selection)
	(gimp-selection-feather img inc-shrink)
	(gimp-selection-shrink img (* inc-shrink 2))
	(gimp-curves-spline draw 0 6 (gen-diff (* 30 (/ brightness 100.0))))

	(gimp-selection-load selection)
	(gimp-selection-feather img inc-shrink)
	(gimp-selection-shrink img (* inc-shrink 3))
	(gimp-curves-spline draw 0 6 (gen-diff (* 40 (/ brightness 100.0))))

;; Do the glow layer, if required
	
	(if (= do-glow TRUE)
		(prog1
		 (gimp-selection-load selection)
		 (gimp-selection-grow img outline-grow)
		 (gimp-selection-invert img)
		 (gimp-edit-clear draw)
		 (gimp-selection-invert img)

		 (gimp-selection-grow img outline-grow)


		 (gimp-palette-set-background (gimp-hsv-to-rgb
									   (list hue sat brightness)))
		 (gimp-edit-fill glow-layer BACKGROUND-FILL)

		 (gimp-selection-none img)
		 (plug-in-gauss-rle 1 img glow-layer (* outline-grow 15) TRUE TRUE)))



    (gimp-selection-none img)

    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-remove-channel img selection)
    (gimp-image-undo-enable img)
	img))


;; Script-Fu interface to generate a sign that is either on or off

(define (script-fu-neon-sign orig-img orig-draw tube-width do-trans
							 bg-color glow-color do-glow)
  (gimp-display-new (neon-sign-rgb orig-img orig-draw tube-width
								   do-trans bg-color glow-color
								   do-glow)))


;; Script-Fu interface to generate a flashing sign, suitable for saving
;; as an animated gif

(define (script-fu-neon-flash orig-img orig-draw tube-width
							  bg-color glow-color do-glow)
  (let* ((width (car (gimp-drawable-width orig-draw)))
		 (height (car (gimp-drawable-height orig-draw)))
		 (hsv (gimp-rgb-to-hsv glow-color))
		 (h (car hsv))
		 (s (cadr hsv))
		 (v (caddr hsv))
		 (off-img (neon-sign orig-img orig-draw tube-width
							 FALSE bg-color h s 20 FALSE))
		 (off-draw (car (gimp-image-flatten off-img)))
		 (on-img (neon-sign orig-img orig-draw tube-width
							FALSE bg-color h s v do-glow))
		 (on-draw (car (gimp-image-flatten on-img)))
		 (off-layer (car (gimp-layer-new on-img width height RGB-IMAGE
										"Sign Off" 100 NORMAL-MODE))))
    (gimp-image-add-layer on-img off-layer 1)
	(gimp-edit-clear off-layer)

	(gimp-edit-copy off-draw)
	(gimp-floating-sel-anchor (car (gimp-edit-paste off-layer FALSE)))

	(gimp-drawable-set-name on-draw "Sign On")

	(gimp-image-delete off-img)

	(gimp-image-clean-all on-img)
	(gimp-display-new on-img)))

;; Script-Fu interface to generate an flash sign, suitable for saving
;; as an animated gif

(define (script-fu-neon-pulse orig-img orig-draw tube-width
							  bg-color glow-color frames)
  (let* ((width (car (gimp-drawable-width orig-draw)))
		 (height (car (gimp-drawable-height orig-draw)))
		 (hsv (gimp-rgb-to-hsv glow-color))
		 (h (car hsv))
		 (s (cadr hsv))
		 (v (caddr hsv))
		 (start-bright 20)
		 (bright-step (/ (- v start-bright) frames))
		 (img (car (gimp-image-new width height RGB)))
		 (frames (max 1 frames))
		 (frame-num 0))
	(while (< frame-num frames)
		   (let* ((frame-img
				   (neon-sign orig-img orig-draw tube-width
							  FALSE bg-color h s
							  (+ start-bright (* bright-step frame-num)) TRUE))
				  (frame-draw (car (gimp-image-flatten frame-img)))
				  (frame-layer (car (gimp-layer-new img width
													height RGB-IMAGE
													"Frame" 100 NORMAL-MODE))))
			 (gimp-image-add-layer img frame-layer 0)
			 (gimp-edit-clear frame-layer)
			 (gimp-edit-copy frame-draw)
			 (gimp-floating-sel-anchor
			  (car (gimp-edit-paste frame-layer FALSE)))
			 (gimp-drawable-set-name frame-layer "Frame")
			 (gimp-image-delete frame-img)
			 (set! frame-num (+ 1 frame-num))))

	(gimp-image-clean-all img)
	(gimp-display-new img)))


;; Register the scripts

(script-fu-register "script-fu-neon-sign"
		    "<Image>/Script-Fu/Alchemy/Neon Sign"
		    "Turn an image into a neon sign"
		    "Mike Oliphant"
		    "Mike Oliphant"
		    "1998"
		    ""
			SF-IMAGE "Image to neon" 0
			SF-DRAWABLE "Drawable to neon" 0
		    SF-VALUE "Tube width (in pixels)" "10"
			SF-TOGGLE "Transparent background?" FALSE
		    SF-COLOR "Background Color" '(0 0 0)
		    SF-COLOR "Sign Color" '(0 255 0)
			SF-TOGGLE "Do glow?" TRUE)

(script-fu-register "script-fu-neon-flash"
		    "<Image>/Script-Fu/Animators/Flashing neon sign..."
		    "Turn an image into a flashing neon sign"
		    "Mike Oliphant"
		    "Mike Oliphant"
		    "1998"
		    ""
			SF-IMAGE "Image to neon" 0
			SF-DRAWABLE "Drawable to neon" 0
		    SF-VALUE "Tube width (in pixels)" "10"
		    SF-COLOR "Background Color" '(0 0 0)
		    SF-COLOR "Glow Color" '(255 0 0)
			SF-TOGGLE "Do glow?" TRUE)

(script-fu-register "script-fu-neon-pulse"
		    "<Image>/Script-Fu/Animators/Pulsating neon sign"
		    "Turn an image into a flashing neon sign"
		    "Mike Oliphant"
		    "Mike Oliphant"
		    "1998"
		    ""
			SF-IMAGE "Image to neon" 0
			SF-DRAWABLE "Drawable to neon" 0
		    SF-VALUE "Tube width (in pixels)" "10"
		    SF-COLOR "Background Color" '(0 0 0)
		    SF-COLOR "Glow Color" '(255 0 0)
			SF-VALUE "Number of Frames" "10")
