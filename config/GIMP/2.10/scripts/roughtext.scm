;
; "Rough text" .scAm B-) script (c) Urpo Lankinen 12.7.1997
; Not very elegant script, but what the heck, it works. Sometimes.
;
; $Id: roughtext.scm,v 1.2 1998/05/10 06:26:07 urpo Exp urpo $
;
; Changed on June 15, 2000 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.1.26
;
; Changed on December 8, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.2
;
; Changed on December 16, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.3

(define (script-fu-rough-text text font size amount trsh)
  (let* ((img (car (gimp-image-new 256 256 GRAY)))
	 (bg-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font)))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))

    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer "Text")
    (gimp-drawable-set-name bg-layer "Background")
    (gimp-image-resize img width height 0 0)

    (gimp-image-set-active-layer img text-layer)
    (gimp-palette-set-foreground '(0 0 0))

    ; Spread. Repeat x times...?
    (plug-in-spread 1 img text-layer amount amount)
    (plug-in-spread 1 img text-layer amount amount)

    (plug-in-gauss-rle 1 img text-layer (* amount 1.2) TRUE TRUE)
    (plug-in-c-astretch 1 img text-layer)
    (gimp-layer-set-preserve-trans text-layer TRUE)

    (gimp-image-set-active-layer img bg-layer)
    (gimp-palette-set-foreground '(255 255 255))
    (gimp-edit-fill bg-layer BACKGROUND-FILL)

    (set! newlayer (car (gimp-image-flatten img)))
    (gimp-threshold newlayer trsh 255)

    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))
;
; Hajaa-ho!
;
(script-fu-register
 "script-fu-rough-text"
 "<Toolbox>/Xtns/Script-Fu/Logos/Rough Text..."
 "Creates text that looks like enlarged text from an old typewriter.
  Based on the \"Rough text\" tutorial by Zach."
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "Urpo Lankinen <wwwwolf@iki.fi>"
 "1997"
 ""
 SF-STRING "Text String" "Top secret"
 SF-FONT  "Font"       "Courier"
 SF-ADJUSTMENT "Font Size (pixels)" '(50 2 1000 1 10 0 1)
 SF-VALUE "Spread amount" "3"    ; 5
 SF-VALUE "Threshold" "150")     ; 170

