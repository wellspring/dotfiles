; Changed on June 15, 2000 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.1.26
;
; Changed on December 8, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.2
;
; Changed on December 16, 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.3

(define (script-fu-shadowy inText inShadDist inShadFuz inFont inSize inGradient)
  (let* (
      (dummy (gimp-palette-set-foreground '(0 0 0)))
      (theImage (car (gimp-image-new 100 100 0)))
      (lA (car (gimp-text-fontname theImage -1 0 0 inText 40 TRUE 120 0 inFont)))
      (lC (car (gimp-text-fontname theImage -1 0 0 inText 40 TRUE 120 0 inFont)))
      (dummy (gimp-palette-set-foreground '(255 255 255)))
      (lB (car (gimp-text-fontname theImage -1 0 0 inText 40 TRUE 120 0 inFont)))
      (lE (car (gimp-text-fontname theImage -1 0 0 inText 40 TRUE 120 0 inFont)))
      (lF (car (gimp-text-fontname theImage -1 0 0 inText 40 TRUE 120 0 inFont)))
      (width (car (gimp-drawable-width lA)))
      (height (car (gimp-drawable-height lA)))

      (lD (car (gimp-layer-new theImage width height 0 "Temp" 100 0)))
      (lG (car (gimp-layer-new theImage width height 0 "Temp" 100 0)))
      (lOutline)
      (lOutMask)
      (lShad)
      (lShaMask)
      )
    (gimp-image-resize theImage width height 0 0)
    (gimp-image-add-layer theImage lD 0)
    (gimp-image-add-layer theImage lG 0)

    (gimp-drawable-set-visible lA 1)
    (gimp-drawable-set-visible lB 1)
    (gimp-drawable-set-visible lC 0)
    (gimp-drawable-set-visible lD 0)
    (gimp-drawable-set-visible lE 0)
    (gimp-drawable-set-visible lF 0)
    (gimp-drawable-set-visible lG 0)
    (gimp-layer-set-offsets lA -1 -1)
    (gimp-layer-set-offsets lB 1 1)
    (gimp-image-lower-layer-to-bottom theImage lB)

    (set! lOutline (car (gimp-image-merge-visible-layers theImage 1)))
    (gimp-drawable-set-visible lOutline 0)
    (set! lOutMask (car (gimp-layer-create-mask lOutline 0)))
    (gimp-layer-add-mask lOutline lOutMask)
    (gimp-layer-set-edit-mask lOutline TRUE)
    (gimp-edit-copy lC)
    (gimp-floating-sel-anchor (car (gimp-edit-paste lOutMask TRUE)))
    (gimp-image-remove-layer theImage lC)



    (gimp-drawable-set-visible lD 1)
    (gimp-drawable-set-visible lE 1)
    (gimp-image-lower-layer-to-bottom theImage lD)



    (gimp-layer-set-offsets lE inShadDist inShadDist)

    (gimp-palette-set-background '(0 0 0))
    (gimp-edit-clear lD)
    (set! lShad (car (gimp-image-merge-visible-layers theImage 1)))
    (gimp-drawable-set-visible lShad 0)
    (plug-in-gauss-rle 1 theImage lShad inShadFuz TRUE TRUE)
    (set! lShaMask (car (gimp-layer-create-mask lShad 1)))
    (gimp-layer-add-mask lShad lShaMask)
    (gimp-layer-set-edit-mask lShad TRUE)
    (gimp-edit-copy lF)
    (gimp-floating-sel-anchor (car (gimp-edit-paste lShaMask TRUE)))
    (gimp-image-remove-layer theImage lF)
    (gimp-layer-set-mode lShad MULTIPLY-MODE)

    (gimp-gradients-set-gradient inGradient)
    (gimp-edit-blend lG 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 0 0 height)
    (gimp-image-lower-layer-to-bottom theImage lG)

    (gimp-drawable-set-visible lOutline 1)
    (gimp-drawable-set-visible lShad 1)
    (gimp-drawable-set-visible lG 1)
    (gimp-display-new theImage)
    )
  )

(script-fu-register "script-fu-shadowy"
		    "<Toolbox>/Xtns/Script-Fu/Logos/Shadowy..."
		    "Simple hollowed out text Using Masks"
		    "Terry McKay"
		    "Terry McKay"
		    "Feb/16/1999"
		    ""
		    SF-STRING "Text String" "The Gimp"
		    SF-VALUE "Shadow Spacing" "3"
		    SF-VALUE "Shadow Fuzziness" "5.0"
		    SF-FONT  "Font"      "Courier"
	        SF-ADJUSTMENT "Font Size (pixels)" '(120 2 1000 1 10 0 1)
		    SF-GRADIENT "Background Gradient" "Deep Sea")
