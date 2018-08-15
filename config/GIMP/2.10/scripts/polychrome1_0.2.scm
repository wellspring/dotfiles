;
;  polychrome1.scm - an elaboration of the illustration script.
;
;
;
;;; --------------------------------------------------------------------
;;; version 0.1  by Jeff Trefftzs <trefftzs@tcsn.net>
;;;     - Initial relase
;;; version 0.2 Raymond Ostertag <r.ostertag@caramail.com>
;;;     - ported to Gimp 2.0, changed menu entry
;;;
;;; --------------------------------------------------------------------
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Helper function to create a new layer
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (copylayer layer layername)
  (set! new (car(gimp-layer-copy layer 1))) ; Add an alpha channel
  (gimp-drawable-set-name new layername)
  new
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  This script uses the emboss plugin below a saturation and a
;;;  color layer.  Try blurring the saturation layer to smooth out
;;;  things like jpeg artifacts.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-polychrome1 inImage inLayer inRough inSmooth)
  (let*
      (
       (satlayer (copylayer inLayer "Saturation Layer"))
       (colorlayer (copylayer inLayer "Color Layer"))
       (embosslayer (copylayer inLayer "Embossed Layer"))
       )

  (gimp-image-undo-group-start inImage)

  (gimp-image-add-layer inImage embosslayer -1) ; and the emboss edge layer
  (gimp-image-add-layer inImage satlayer -1) ; and the saturation layer
  (gimp-layer-set-mode satlayer SATURATION-MODE)
  (if (> 0 inSmooth)
      (plug-in-gauss-iir 1 inImage satlayer inSmooth TRUE TRUE))

  (gimp-image-add-layer inImage colorlayer -1) ; and the color layer
  (gimp-layer-set-mode colorlayer COLOR-MODE)

  (plug-in-emboss TRUE			; non-interactive
		 inImage
		 embosslayer
		 135			; azmiuth in degree
		 45			; elevation
		 inRough			; filter width (= depth)
		 1)			; emboss

  (gimp-image-set-active-layer inImage inLayer)
  (gimp-image-undo-group-end inImage)
  (gimp-displays-flush)
  )
)

(script-fu-register
 "script-fu-polychrome1"
 _"<Image>/Script-Fu/Alchemy/Polychrome..."
 "Embosses the original image, then places it beneath saturation and color layers."
 "Jeff Trefftzs"
 "Copyright 2001, Jeff Trefftzs"
 "June 21, 2001"
 "RGB* GRAY*"
 SF-IMAGE "The Image" 0
 SF-DRAWABLE "The Layer" 0
 SF-ADJUSTMENT "Roughness" '(20 1 64 1 5 0 1)
 SF-ADJUSTMENT "Smoothing" '(0 0 32 1 5 0 1)
)
