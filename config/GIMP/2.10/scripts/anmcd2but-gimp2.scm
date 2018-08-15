; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; ANMCD2/Button script -- It works on a shape and gives it a 3D-like effect.
;
; Copyright (C) 1997 Marco Lamberto
; lm@geocities.com
; http://www.geocities.com/Tokyo/1474/gimp/
;
; $Revision: 1.4 $
; Version 2.0 Raymond Ostertag 2004/12 
; - Ported to Gimp2, changed menu entry
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

; ANMCD 2 Button Generator !

;***
(define (script-fu-anmcd2but image drawable maskcolor ftreshold lcolor bg bbg bbcolor bbsize offx offy)
  (let*   ((w (car (gimp-drawable-width drawable)))
          (h (car (gimp-drawable-height drawable)))
          (old-bg (car (gimp-palette-get-background))))

  (gimp-selection-none image)
  (gimp-image-undo-disable image)
  (set! l-org (car (gimp-image-get-active-layer image)))
;shape  
  (set! l-shape (car (gimp-layer-copy l-org TRUE)))
  (gimp-image-add-layer image l-shape 0)
  (gimp-drawable-set-name l-shape "shape")
  (gimp-selection-layer-alpha l-shape)
  (gimp-palette-set-background bbg)
  (gimp-edit-fill l-shape 1)
  (gimp-selection-invert image)
  (gimp-edit-cut l-shape)
;background  
  (gimp-image-set-active-layer image l-org)
  (gimp-palette-set-background bg)
  (set! l-bg (car (gimp-layer-new image w h RGBA-IMAGE "background" 100 NORMAL-MODE)))
  (gimp-drawable-fill l-bg BACKGROUND-FILL)
  (gimp-image-add-layer image l-bg 0)
  (gimp-image-lower-layer image l-bg)
;border
  (gimp-image-set-active-layer image l-shape)
  (gimp-palette-set-background bbcolor)
  (set! l-blue (car (gimp-layer-new image w h RGBA-IMAGE "blue border" 70 NORMAL-MODE)))
  (gimp-drawable-fill l-blue BACKGROUND-FILL)
  (gimp-image-add-layer image l-blue 0)
  (gimp-selection-layer-alpha l-shape)
  (gimp-image-set-active-layer image l-blue)
  (gimp-selection-shrink image bbsize)
  (gimp-edit-cut l-blue)
  (mask image l-shape l-blue)
;light
  (gimp-image-set-active-layer image l-blue)
  (gimp-palette-set-background lcolor)
  (set! l-light (car (gimp-layer-new image w h RGBA-IMAGE "light" 100 NORMAL-MODE)))
  (gimp-drawable-fill l-light BACKGROUND-FILL)
  (gimp-image-add-layer image l-light 0)
  (gimp-selection-layer-alpha l-shape)
  (gimp-image-set-active-layer image l-light)
  (gimp-edit-cut l-light)
  (gimp-drawable-offset l-light TRUE 0 offx offy)
  (plug-in-gauss-rle TRUE image l-light 15.0 TRUE TRUE) 
  (mask image l-shape l-light)
;merge everything
  (gimp-drawable-set-visible l-light TRUE)
  (gimp-drawable-set-visible l-blue TRUE)
  (gimp-drawable-set-visible l-shape TRUE)
  (gimp-drawable-set-visible l-bg FALSE)
  (gimp-drawable-set-visible l-org FALSE)
  (set! l-but (car (gimp-image-merge-visible-layers image CLIP-TO-IMAGE)))
  (gimp-drawable-set-name l-but "button")
  (gimp-drawable-set-visible l-bg TRUE)
  (gimp-drawable-set-visible l-org FALSE)

  (gimp-palette-set-background old-bg)
  (gimp-image-undo-enable image)
  (gimp-displays-flush)))


;*** apply the shape in 'sl' as mask in 'tl'
(define (mask image sl tl)
  (set! m (car (gimp-layer-create-mask tl ADD-BLACK-MASK)))
  (gimp-layer-add-mask tl m)
  (gimp-selection-layer-alpha sl)
  (gimp-palette-set-background '(255 255 255))
  (gimp-edit-fill m 1)
  (gimp-selection-none image))


;***
(script-fu-register "script-fu-anmcd2but"
  "<Image>/Script-Fu/Shadow/Button 3D effect"
  "It works on a shape and gives it a 3D-like effect."
  "Marco Lamberto <lm@geocities.com>"
  "Marco Lamberto"
  "21 Sep 1997 - 30 Aug 1998"
  "RGBA"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-COLOR "Mask Color" '(255 255 255)
  SF-VALUE "Select Threshold" "100"
  SF-COLOR "Light Color" '(255 255 255)
  SF-COLOR "Background Color" '(0 0 0)
  SF-COLOR "Button Background Color" '(0 51 51)
  SF-COLOR "Border Color" '(0 0 127)
  SF-VALUE "Border Size" "4"
  SF-VALUE "Offset X" "5"
  SF-VALUE "Offset Y" "5")
