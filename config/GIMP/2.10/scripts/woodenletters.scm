; =====================================================================
; Wooden Letters - yet another silly script from WWWWolf
; =====================================================================
; Copyright (C) 21.5.1998 Urpo Lankinen.
;  Distributed under GPL. Permission granted to distribute this script
;  with *anything* that has *something* to do with The GIMP.
; =====================================================================
;
; E-mail: <wwwwolf@iki.fi> Homepage: <URL:http://www.iki.fi/wwwwolf/>
;
; RCS: $Id: woodenletters.scm,v 1.0 1998/05/21 14:55:21 urpo Exp urpo $
;
; Yeps, another script. Not even a clever one this time, unlike the
; Fiery Steel that had a flame-generation algorithm... This is just a
; tribute (questionable sort due to the stupidness) to the Bumpmaps,
; da kewlest feature of da GIMP. b'sides, I just had a boring day when
; the network wasn't quite reachable.
;
; I just discovered solid noise. Perharps this will make the cool things
; even cooler!
;
; Some fonts you can try: cuneifontlight, Frizquadrata (dunno why)...
;
; Changed on June 15, 2000 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.1.26
;
; Changed on December 8, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.2
;
; Changed on January 29, 2004 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 2.0pre3
;

(define (script-fu-wooden-letters text font size woodpat backpat bradius)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
	 (bg-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (text2-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (hibump-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))

    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer "Text")
    (gimp-drawable-set-name text2-layer "Text 2")
    (gimp-drawable-set-name hibump-layer "Bump map")
    (gimp-drawable-set-name bg-layer "Background")
    (gimp-image-resize img width height 0 0)

    ; Action! =========================================================

    ; We do some filling here, so...
    (gimp-selection-all img)

    ; Let's make the background interleaved.
    (gimp-patterns-set-pattern backpat)
    (gimp-edit-bucket-fill bg-layer 2 0 100 15 0 0 0) ; PATTERN-BUCKET-FILL

    ; Then, woodize our letters.
    (gimp-patterns-set-pattern woodpat)
    (gimp-layer-set-preserve-trans text-layer TRUE)
    (gimp-edit-bucket-fill text-layer 2 0 100 15 0 0 0) ; YAP-B-F

    ; Black on white for the second text layer... we need new layer.
    (set! textbumplayer
	  (car (gimp-layer-new img width height RGBA-IMAGE "Text bump map"
			       100 0)))
    (gimp-image-add-layer img textbumplayer 2)
    ; make the new layer white...
    (gimp-palette-set-foreground '(255 255 255)) ; White
    (gimp-edit-bucket-fill textbumplayer 0 0 100 15 0 0 0)
    (gimp-palette-set-foreground '(0 0 0)) ; Black
    ; Strategic retreat... *BOOM* Okay, then back...
    (gimp-drawable-set-visible bg-layer FALSE)
    (gimp-drawable-set-visible text-layer FALSE)
    (gimp-drawable-set-visible hibump-layer FALSE)
    (set! textbumplayer
	  (car (gimp-image-merge-visible-layers img EXPAND-AS-NECESSARY)))
    (gimp-drawable-set-visible bg-layer TRUE)
    (gimp-drawable-set-visible text-layer TRUE)
    (gimp-drawable-set-visible hibump-layer TRUE)
    ; Some blurring...
    (plug-in-gauss-iir 1 img textbumplayer bradius TRUE TRUE)
    ; JA BUMPMAPPI... [1]
    (plug-in-bump-map 1 img text-layer textbumplayer
		      275.00 45.00 9 0 0 0 0 TRUE FALSE 0)
    (gimp-image-remove-layer img textbumplayer)

    ; Uh, and then some randomness...
    (gimp-palette-set-foreground '(255 255 255)) ; White
    (gimp-edit-bucket-fill hibump-layer 0 0 100 15 0 0 0)
    (gimp-palette-set-foreground '(0 0 0)) ; Black

    (plug-in-solid-noise 1 img hibump-layer FALSE TRUE 42 9
			 (/ width 2) (/ height 2))
    (gimp-invert hibump-layer)
    (plug-in-spread 1 img hibump-layer (* bradius 3) (* bradius 2))
    (plug-in-gauss-iir 1 img hibump-layer bradius TRUE TRUE)
    (plug-in-c-astretch 1 img hibump-layer)
    (gimp-threshold hibump-layer 115 155)

    (plug-in-gauss-iir 1 img hibump-layer (/ bradius 2) TRUE TRUE)

    ; I like this plug-in, I really do
    (plug-in-bump-map 1 img text-layer hibump-layer
		      275.00 45.00 3 0 0 0 0 TRUE FALSE 1)

    (gimp-image-remove-layer img hibump-layer)
    (gimp-selection-none img)

    ; End of action(tm) ===============================================
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

;
; Hayaaaaa! Ha! ::smashes the brick with bare paws::
;
(script-fu-register
 "script-fu-wooden-letters"
 "<Toolbox>/Xtns/Script-Fu/Logos/Wooden Letters..."
 "Wooden letters"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "21 May 1998"
 ""
 SF-STRING "Text String" "Good Wood"
 SF-FONT   "Font"        "Arnold Boecklin"
 SF-ADJUSTMENT "Font Size (pixels)" '(80 2 1000 1 10 0 1)
 SF-PATTERN "Wood pattern" "Wood #1"
 SF-PATTERN "Background pattern" "Maple Leaves"
 SF-VALUE "Blur radius" "10"
)

; [1] Okay, in-joke that can be explained. One of my friends added a
;   sine curve effect to *all* of his demos; So, upon seeing yet
;   another of these demos, one of his friends just said "Ja
;   sinikäyrä!" (...and a sine curve!) I tend to add bumpmap to all
;   scripts I write...
