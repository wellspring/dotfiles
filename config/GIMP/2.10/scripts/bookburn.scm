; =====================================================================
; Book Burning - yet another silly script from WWWWolf
; =====================================================================
; Copyright (C) 27.3.1999 Urpo Lankinen.
;  Distributed under GPL. Permission granted to distribute this script
;  with *anything* that has *something* to do with The GIMP.
;  Made for the GIMP Contest.
; =====================================================================
;
; E-mail: <wwwwolf@iki.fi> Homepage: <URL:http://www.iki.fi/wwwwolf/>
;
; RCS: $Id: bookburn.scm,v 1.0 1999/04/29 21:25:11 wwwwolf Exp wwwwolf $
;
; Done for the GIMP Contest. See the README file for more babble.
;
; The "Fiery steel" script was inspired by "Terminator 2" opening
; titles - and no, I'm not a big fan of Arnold Schwartzenegger
; movies, but... this one was inspired by "Eraser" opening titles. =)
;
; This is the first script I've written entirely within
; XEmacs. =)
;


; Function to resize layer's contents to specified size, while keeping the
; layer same size. new stuff is centered.
(define (script-fu-layer-resize-contents drawable xsize ysize)
  (let* ((width (car (gimp-drawable-width drawable)))
         (height (car (gimp-drawable-height drawable)))
	 (xoff 0) (yoff 0))
    (gimp-layer-scale drawable xsize ysize TRUE)
    (set! xoff (car (gimp-drawable-offsets drawable)))
    (set! yoff (car (cdr (gimp-drawable-offsets drawable))))
    (gimp-layer-resize drawable width height xoff yoff)))


; This function is not necessary. You can delete it happily.
(define (script-fu-book-burn
	 img dwbl
	 usepat pattern papermode)
  (let* ((type (car (gimp-drawable-type-with-alpha dwbl)))
         (width (car (gimp-image-width img)))
         (height (car (gimp-image-height img)))
	 (perc 0.25)                 ; Fire
	 (sprd 5)                    ; Fire
	 (rndamt 40)                 ; Fire
	 (sheight (* height perc))   ; Fire
	 (ycoord (- height sheight)) ; FIRE! Enough repetition already...
	 (old-pat (car (gimp-patterns-get-pattern)))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))

    (gimp-image-disable-undo img)
    ; ÄKSÖN =========================================================

    (gimp-layer-add-alpha dwbl)
    (script-fu-layer-resize-contents dwbl (* width 0.80) (* height 0.80))


    (set! bg-layer
	  (car (gimp-layer-new img width height type "Background" 100 NORMAL)))
    (gimp-image-add-layer img bg-layer 2)
    (gimp-layer-set-visible bg-layer TRUE)
    (gimp-image-set-active-layer img bg-layer)
    (gimp-selection-all img)
    (gimp-palette-set-foreground '(0 0 0))
    (gimp-bucket-fill img bg-layer FG-BUCKET-FILL NORMAL 100
		      15 FALSE 1 1)
    (gimp-palette-set-foreground old-fg)

    (if (not usepat) ; ======== If we don't want to use patterns...
	(begin
	  ; ...the user is asking for trouble, so that
	  ; s/he shall get.
	  (set! tmp-layer
		(car (gimp-layer-new img width height type "Temp" 100 NORMAL)))
	  (gimp-image-add-layer img tmp-layer 0)
	  (gimp-layer-set-visible tmp-layer FALSE)
	  ; (plug-in-plasma 1 img tmp-layer 32910 1)
	  (plug-in-solid-noise 1 img tmp-layer
			       TRUE ; Tilable
			       FALSE ; turbulent
			       6942  ; seed (random number, indeed)
			       1     ; Detail                       ; CONST
			       5 5)   ; size
	  (plug-in-c-astretch 1 img tmp-layer)
	  
	  (gimp-desaturate img tmp-layer)
	  (plug-in-displace 1 img dwbl
			    10 10         ; displace amount          ; CONST
			    TRUE TRUE     ; in both directions
			    tmp-layer tmp-layer ; and our map
			    1)            ; SMEAR the edges...
	  
	  (plug-in-bump-map 1 img dwbl tmp-layer
			    135.00
			    45.00 8 0 0 0 0 TRUE FALSE LINEAR)       ; CONST
	  ; THE HOLY PLUGIN HAS SPOKEN!
	  
	  (plug-in-solid-noise 1 img tmp-layer
			       TRUE ; Tilable
			       FALSE ; turbulent
			       6942  ; seed (random number, indeed)
			       1     ; Detail
			       14 14)   ; size                       ; CONST
	  (plug-in-c-astretch 1 img tmp-layer)

	  (gimp-desaturate img tmp-layer)
	  (plug-in-displace 1 img dwbl
			    10 10         ; displace amount         ; CONST
			    TRUE TRUE     ; in both directions
			    tmp-layer tmp-layer ; and our map
			    1)            ; SMEAR the edges...

	  (plug-in-bump-map 1 img dwbl tmp-layer
			    135.00
			    45.00 16 0 0 0 0 TRUE FALSE LINEAR)     ; CONST
	  ; THE HOLY PLUGIN HAS SPOKEN AGAIN!

	  (gimp-image-remove-layer img tmp-layer)
	  )
	; ======== Else, we do this with a bit easier way
	(begin
	  (set! tmp-layer
		(car (gimp-layer-new img width height type "Temp" 100 NORMAL)))
	  (gimp-image-add-layer img tmp-layer 0)
	  (gimp-layer-set-visible tmp-layer FALSE)
	  (gimp-image-set-active-layer img bg-layer)
	  (gimp-selection-all img)
	  (gimp-patterns-set-pattern pattern)
	  (gimp-bucket-fill img tmp-layer PATTERN-BUCKET-FILL NORMAL 100
			    15 FALSE 1 1)
	  (gimp-patterns-set-pattern old-pat)


	  (gimp-desaturate img tmp-layer)
	  (plug-in-c-astretch 1 img tmp-layer)

	  ; Do the smearimg as above:
	  (plug-in-displace 1 img dwbl
			    4 4           ; displace amount       ; CONSTANT
			    TRUE TRUE     ; in both directions
			    tmp-layer tmp-layer ; and our map
			    1)            ; SMEAR the edges...

	  ; THE HOLY BUMPMAP PLUGIN SPEAKS AGAIN! REJOICE!
	  (plug-in-bump-map 1 img dwbl tmp-layer
			    135.00
			    45.00 4 0 0 0 0 TRUE FALSE LINEAR)   ; CONSTANT


	  (gimp-image-remove-layer img tmp-layer)
	  )
	) ; ==== Done patterning.

    ; The whole image shall now be burned, tra la la la laaaaa...

    (set! burn1-layer
	  (car (gimp-layer-new img width height type "Burrrn" 100 NORMAL)))
    (gimp-image-add-layer img burn1-layer 0)
    (gimp-layer-set-visible burn1-layer TRUE)
    (gimp-image-set-active-layer img burn1-layer)
    (gimp-selection-all img)    
    (gimp-edit-clear img burn1-layer)

    (gimp-palette-set-foreground '(109 72 7)) ; Brown

    (gimp-blend img burn1-layer
		FG-TRANS NORMAL LINEAR 100 0 REPEAT-NONE FALSE 3 0.20
		1 height 1 0)
    (if (not papermode)
	(gimp-layer-set-mode burn1-layer COLOR)
	(gimp-layer-set-mode burn1-layer MULTIPLY))

    (set! burn2-layer
	  (car (gimp-layer-new img width height type "Burrrn too" 100 NORMAL)))
    (gimp-image-add-layer img burn2-layer 0)
    (gimp-layer-set-visible burn2-layer TRUE)
    (gimp-image-set-active-layer img burn2-layer)
    (gimp-edit-clear img burn2-layer)
    
    (gimp-palette-set-foreground '(0 0 0)) ; Black
    
    (gimp-blend img burn2-layer
		FG-TRANS NORMAL LINEAR 100 0 REPEAT-NONE FALSE 3 0.20
		1 height 1 0)
    (if (not papermode)
	(gimp-layer-set-mode burn2-layer VALUE)
	(gimp-layer-set-mode burn2-layer MULTIPLY))


    ; Make a displacement layer
    (set! displ-layer
	  (car (gimp-layer-new img width height type "Displacement"
			       100 NORMAL)))
    (gimp-image-add-layer img displ-layer 0)
    (gimp-layer-set-visible displ-layer FALSE)
    (gimp-image-set-active-layer img displ-layer)

    (plug-in-plasma 1 img displ-layer 6942 1.0)
    (gimp-desaturate img displ-layer)
    (plug-in-c-astretch 1 img displ-layer)

    (gimp-image-set-active-layer img burn2-layer)

    ; Displacemap the gradients a bit.
    (plug-in-displace 1 img burn1-layer
		      35 50           ; displace amount       ; CONSTANT
		      TRUE TRUE     ; in both directions
		      displ-layer displ-layer ; and our map
		      1)            ; SMEAR the edges...
    (plug-in-displace 1 img burn2-layer
		      25 60           ; displace amount       ; CONSTANT
		      TRUE TRUE     ; in both directions
		      displ-layer displ-layer ; and our map
		      1)            ; SMEAR the edges...

    (gimp-image-remove-layer img displ-layer)


    ; Make the image burned one
    (gimp-layer-set-visible bg-layer FALSE)
    (set! dwbl
	  (car (gimp-image-merge-visible-layers img EXPAND-AS-NECESSARY)))

    ; Flame rendering

    (gimp-layer-set-visible dwbl FALSE)

    (gimp-selection-none img)


    ; Add a layer
    (set! fire1-layer
	  (car (gimp-layer-new img width height RGBA_IMAGE "Fire 1"
			       100 NORMAL)))
    (gimp-image-add-layer img fire1-layer 0)
    ; Clear it
    (gimp-selection-all img)
    (gimp-edit-clear img fire1-layer)
    ; Make lower part red
    (gimp-rect-select img 0 ycoord width sheight REPLACE FALSE 0)
    (gimp-palette-set-foreground '(180 0 20))
    (gimp-bucket-fill img fire1-layer FG-BUCKET-FILL NORMAL
		      100 255 FALSE 1 1)
    (gimp-selection-none img)
      
    ; Do nasty stuff to the lower fire layer
    (plug-in-ripple 1 img fire1-layer
		    (/ width 8) (/ height 8) 1 0 1 FALSE FALSE)
    (plug-in-whirl-pinch 1 img fire1-layer
			 45 0 0.7)
    
    ; Copy the layer, make it yellow, shift down a bit
    (set! fire2-layer
	  (car (gimp-layer-copy fire1-layer TRUE)))
    (gimp-image-add-layer img fire2-layer 0) ; top
    (gimp-layer-set-name fire2-layer "Fire 2")
    
    (gimp-image-set-active-layer img fire2-layer)
    (gimp-layer-set-preserve-trans fire2-layer TRUE)
    (gimp-palette-set-foreground '(228 170 4)) ; Yellow
    (gimp-selection-all img)
    (gimp-bucket-fill img fire2-layer FG-BUCKET-FILL NORMAL
		      100 255 FALSE 1 1)
    (gimp-layer-set-preserve-trans fire2-layer FALSE)
    (gimp-selection-none img)

    (gimp-channel-ops-offset img fire2-layer FALSE 1 0 (/ height 8))


    ; spread, spindle, mutilate
    (plug-in-spread 1 img fire1-layer 0 (* 3 sprd))
    (plug-in-spread 1 img fire2-layer 0 (* 2 sprd))
      
    ; Merge the layers
    (set! fire-layer
	  (car (gimp-image-merge-visible-layers
		img EXPAND-AS-NECESSARY)))
    (gimp-layer-set-name fire-layer "Fire")

    (gimp-layer-set-preserve-trans fire-layer TRUE)
    (plug-in-gauss-rle 1 img fire-layer (* 2 sprd) TRUE TRUE)
    (gimp-layer-set-preserve-trans fire-layer FALSE)	      

    (plug-in-noisify 1 img fire-layer TRUE 0.2 0.2 0.2 0.2)
    (plug-in-noisify 1 img fire-layer TRUE 0.2 0.2 0.2 0.2)
      
    (plug-in-gauss-rle 1 img fire-layer (* 2 sprd) TRUE TRUE)
      
      ; Then, Let's nastyize it.
    (plug-in-randomize 1 img fire-layer 2 80 rndamt)

    ; Okay, we're done with that...
    (gimp-layer-set-visible bg-layer TRUE)
    (gimp-layer-set-visible dwbl TRUE)

    ; Do a duplicate
    (set! fire2-layer
	  (car (gimp-layer-copy fire-layer TRUE)))
    (gimp-image-add-layer img fire2-layer 2)

    (gimp-image-set-active-layer img fire2-layer)
    (gimp-selection-all img)

    ;(set! fire2-layer (car
    (set! flt (car (gimp-flip img fire2-layer 0))) ; HORIZONTAL
    (gimp-floating-sel-anchor flt)


    ; Make a displacement layer AGAIN... somehow, it just stayed in the
    ; picture earlier!
    (set! displ-layer
	  (car (gimp-layer-new img width height type "Displacement"
			       100 NORMAL)))
    (gimp-image-add-layer img displ-layer 0)
    (gimp-layer-set-visible displ-layer FALSE)
    (gimp-image-set-active-layer img displ-layer)

    (plug-in-plasma 1 img displ-layer 6942 1.0)
    (gimp-desaturate img displ-layer)
    (plug-in-c-astretch 1 img displ-layer)


    (plug-in-displace 1 img fire-layer
		      30 20           ; displace amount       ; CONSTANT
		      TRUE TRUE     ; in both directions
		      displ-layer displ-layer ; and our map
		      1)            ; SMEAR the edges...
    (plug-in-displace 1 img fire2-layer
		      40 50
		      TRUE TRUE
		      displ-layer displ-layer
		      1)

    ; Make the flamez whirl.
    (plug-in-whirl-pinch 1 img fire-layer
			 90.0 -1.0 2.0)
    (plug-in-whirl-pinch 1 img fire2-layer
			 -90.0 -1.0 2.0)

    ; And we flatten the thing now...
    
    (set! dwbl (car (gimp-image-flatten img)))

    ; End of Action(tm) =============================================
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-enable-undo img)
    (gimp-displays-flush)))


;
; Hajaa-ho!
;
(script-fu-register
 "script-fu-book-burn"
 "<Image>/Script-Fu/Decor/Burn image"
 "An effect inspired by the \"Eraser\" opening titles. Burns
  the image. $Revision: 1.0 $"
 "Weyfour WWWWolf <wwwwolf@iki.fi>"
 "Weyfour WWWWolf <wwwwolf@iki.fi>"
 "27 March 1999-30 April 1999"
 "RGB RGBA GRAY GRAYA"
 SF-IMAGE "Image" 0
 SF-DRAWABLE "Drawable" 0

 SF-TOGGLE "Crinkling with pattern?" TRUE
 SF-VALUE "Crinkling Pattern" "\"Crinkled Paper\""
 SF-TOGGLE "Paper mode" TRUE
)
