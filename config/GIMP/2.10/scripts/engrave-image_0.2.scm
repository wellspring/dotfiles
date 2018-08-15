;
; engrave-image
;
;  Jeff Trefftzs <trefftzs@tcsn.net>
;  - original release
;  version 0.2 Raymond Ostertag <r.ostertag@caramail.com>
;  - ported to Gimp 2.0, changed menu entry
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

; Define the function:

(define (script-fu-engrave-image inImage inLayer)

  (gimp-image-undo-group-start inImage)
;  (gimp-image-undo-disable inImage)

  ;  Force grayscale RGB image
  (gimp-image-convert-grayscale inImage)
  (gimp-image-convert-rgb inImage)

  (set! layer2 (car (gimp-layer-copy inLayer TRUE)))
  (gimp-image-add-layer inImage layer2 -1)
  (gimp-levels layer2 0 0 213 1.0 0 255)
  (plug-in-newsprint 1 inImage layer2 4 2 0 45.0 1 45.0 1 45.0 1 45.0 1 15)
  (gimp-drawable-set-name layer2 "Second Newsprint Layer")

  (set! toplayer (car (gimp-layer-copy inLayer TRUE)))
  (gimp-image-add-layer inImage toplayer -1)
  (gimp-levels toplayer 0 0 201 1.0 0 255)
  (plug-in-newsprint 1 inImage toplayer 4 2 0 -45.0 1 
		     -45.0 1 -45.0 1 -45.0 1 15)
  (gimp-layer-set-mode toplayer 9)
  (gimp-drawable-set-name toplayer "Topmost Layer")

  (plug-in-gauss-iir 1 inImage inLayer 35 TRUE TRUE)
  (gimp-drawable-set-name inLayer "Displacement Map")

  (plug-in-displace 1 inImage toplayer 0.0 15.0 0 1 inLayer inLayer 0)
  (plug-in-displace 1 inImage layer2   0.0 15.0 0 1 inLayer inLayer 0)
  
;  (gimp-image-undo-enable inImage)
  (gimp-image-undo-group-end inImage)
  (gimp-image-set-active-layer inImage inLayer)
  (gimp-displays-flush)
)

(script-fu-register
 "script-fu-engrave-image"
 _"<Image>/Script-Fu/Stencil Ops/Engrave Image..."
 "Converts the image into a black and white engraving"
 "Jeff Trefftzs, based on the Old Stamp image of GGJ
\"G.G.J\" <junqueira@usa.net>"
 "Copyright 2001, Jeff Trefftzs"
 "February 1, 2001"
 "RGB*, GRAY*, INDEXED*"
 SF-IMAGE "The Image" 0
 SF-DRAWABLE "The Layer" 0
)
