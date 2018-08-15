; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; Bling Bling!
; For all your straight-up thug jewlery needs.
; Copyright (C) 2002 IceWeasel
; <iceweasel@sw-tech.com>
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

(define (script-fu-bling-bling img drawable inInset inMetal)

(let*
(

  (blingOldFG (car (gimp-palette-get-foreground)))
  (blingOldBG (car (gimp-palette-get-background)))
  (blingOldGradient (car (gimp-gradients-get-active)))

  (blingGSImage img)
  (blingGSLayer drawable)
  (blingImageWidth (car (gimp-image-width blingGSImage)))
  (blingImageHeight (car (gimp-image-height blingGSImage)))
  (blingShrinkBy inInset)

  (blingChosenGrad
                   (cond ((equal? inMetal 0) "Golden")
                         ((equal? inMetal 1) "Flare_Sizefac_101")
                         ((equal? inMetal 2) "Rounded_edge")
                   )

  )

  (blingGSMaskImage (car (gimp-image-new blingImageWidth blingImageHeight GRAY)))
  (blingGSMaskLayer (car (gimp-layer-new blingGSMaskImage blingImageWidth blingImageHeight GRAY_IMAGE "layer 1" 100 NORMAL)))
  (blingRGBImage (car (gimp-image-new blingImageWidth blingImageHeight RGB)))
  (blingRGBLayer (car (gimp-layer-new blingRGBImage blingImageWidth blingImageHeight RGB_IMAGE "layer 1" 100 NORMAL)))
  (blingGoldImage (car (gimp-image-new blingImageWidth blingImageHeight RGB)))
  (blingGoldLayer (car (gimp-layer-new blingGoldImage blingImageWidth blingImageHeight RGB_IMAGE "layer 1" 100 NORMAL)))
  (blingFinalImage (car (gimp-image-new blingImageWidth blingImageHeight RGB)))
  (blingFinalLayer (car (gimp-layer-new blingFinalImage blingImageWidth blingImageHeight RGB_IMAGE "bling layer" 100 NORMAL)))

  (blingMask (car (gimp-layer-create-mask blingFinalLayer 0)))

  (blingChannel (car (gimp-channel-new blingFinalImage blingImageWidth blingImageHeight "tempchannel" 100 '(0 0 0))))


)

(gimp-image-undo-disable blingFinalImage)
(gimp-image-undo-disable blingGSImage)

(gimp-image-add-layer blingRGBImage blingRGBLayer 0)
(gimp-image-add-layer blingGoldImage blingGoldLayer 0)
(gimp-image-add-layer blingGSMaskImage blingGSMaskLayer 0)
(gimp-image-add-layer blingFinalImage blingFinalLayer 0)
(gimp-image-add-channel blingFinalImage blingChannel 0)

(gimp-layer-add-alpha blingFinalLayer)
(gimp-selection-all blingFinalImage)
(gimp-edit-clear blingFinalLayer)
(gimp-selection-none blingFinalImage)

(gimp-selection-all blingGSImage)
(gimp-edit-copy blingGSLayer)
(gimp-selection-none blingGSImage)
(gimp-edit-paste blingGSMaskLayer 0)
(gimp-floating-sel-anchor (car (gimp-image-floating-selection blingGSMaskImage)))

(gimp-invert blingGSMaskLayer)
(plug-in-gauss-iir2 TRUE blingGSMaskImage blingGSMaskLayer 3 3)

(gimp-selection-all blingGSMaskImage)
(gimp-edit-copy blingGSMaskLayer)
(gimp-selection-none blingGSMaskImage)
(gimp-edit-paste blingChannel 0)
(gimp-floating-sel-anchor (car (gimp-image-floating-selection blingFinalImage)))

(gimp-palette-set-background '(255 255 255))
(gimp-palette-set-foreground '(0 0 0))
(gimp-gradients-set-active blingChosenGrad)

(gimp-selection-all blingRGBImage)
(gimp-edit-fill blingRGBLayer 1) ;; Why won't gimp-edit-clear work here?
(gimp-selection-none blingRGBImage)

(plug-in-solid-noise TRUE blingGoldImage blingGoldLayer 1 0 0 15 4.0 4.0)
(plug-in-autostretch-hsv TRUE blingGoldImage blingGoldLayer)
(plug-in-gradmap TRUE blingGoldImage blingGoldLayer)

(plug-in-lighting
  TRUE               ; run mode (1)
  blingRGBImage      ; input image
  blingRGBLayer      ; input layer
  blingGSMaskLayer   ; bumpmap layer
  blingGoldLayer     ; envmap layer
  TRUE               ; do bump map
  TRUE               ; do env map
  0                  ; bumptype (0=linear)
  0                  ; lighttype (0=point, 1=dir, 3=spot, 4=none)  (???)
  '(255 255 255)     ; light color
  0.50 0.50 1.00     ; light x y z
  -1.0 -1.0 1.0      ; lightdir x y z
  0.30 1.00          ; intensity:  ambient, diffuse
  0.40 0.60 99999999 ; reflectivity: diffuse, specular, highlight (99999999?)
  FALSE FALSE FALSE  ; antialiasing, newimage, transparent bg
)

(gimp-selection-all blingRGBImage)
(gimp-edit-copy blingRGBLayer)
(gimp-selection-none blingRGBImage)
(gimp-edit-paste blingFinalLayer 0)
(gimp-floating-sel-anchor (car (gimp-image-floating-selection blingFinalImage)))
(gimp-selection-load blingChannel)
(gimp-selection-invert blingFinalImage)

(gimp-selection-grow blingFinalImage 1)

(gimp-edit-clear blingFinalLayer)
(gimp-selection-invert blingFinalImage)
(gimp-selection-shrink blingFinalImage blingShrinkBy)
(gimp-edit-fill blingFinalLayer 2)
(plug-in-noisify TRUE blingFinalImage blingFinalLayer FALSE 0.4 0.4 0.4 0.4)
(plug-in-noisify TRUE blingFinalImage blingFinalLayer FALSE 0.4 0.4 0.4 0.4)
(gimp-selection-none blingFinalImage)

(gimp-image-remove-channel blingFinalImage blingChannel)
(gimp-channel-delete blingChannel)

(gimp-palette-set-background blingOldBG)
(gimp-palette-set-foreground blingOldFG)
(gimp-gradients-set-active blingOldGradient)

(gimp-image-delete blingRGBImage)
(gimp-image-delete blingGoldImage)
(gimp-image-delete blingGSMaskImage)

(gimp-display-new blingFinalImage)

(gimp-image-clean-all blingFinalImage)
(gimp-image-undo-enable blingFinalImage)
(gimp-image-undo-enable blingGSImage)


))

(script-fu-register "script-fu-bling-bling"
                    _"<Image>/Script-Fu/Text/Bling Bling!"
                    "Diamond-encrusted metal effect"
                    "IceWeasel"
                    "<iceweasel@sw-tech.com>"
                    "May 2002"
                    "GRAY"
                    SF-IMAGE "Image" 0
                    SF-DRAWABLE "Drawable" 0
                    SF-ADJUSTMENT "Inset (px)" '(3 1 100 1 10 0 0)
                    SF-OPTION "Metal" '("Gold" "Silver" "Chrome")
)

