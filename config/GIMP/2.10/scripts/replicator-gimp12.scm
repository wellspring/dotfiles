; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; Replicator script --- Clone an image into a bigger one filled with the
;                       original.
; Copyright (C) 1997-98 Marco Lamberto
; lm@geocities.com
; http://www.geocities.com/Tokyo/1474/gimp/
;
; $Revision: 1.3 $
;
; Version 1.3a Raymond Ostertag 2003/10
;   - Changed menu entry
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

; main function

(define (script-fu-replicator image drawable rows columns)
  (set! w (car (gimp-drawable-width drawable)))
  (set! h (car (gimp-drawable-height drawable)))
  (set! w2 (* w columns))
  (set! h2 (* h rows))
  (set! image2 (car (gimp-image-new w2 h2 RGB)))
  (set! layer2 (car (gimp-layer-new image2 w2 h2 RGB "layer 1" 100 NORMAL)))
  (gimp-image-add-layer image2 layer2 0)
  (set! drawable2 (car (gimp-image-active-drawable image2)))
  (gimp-undo-push-group-start image)
  (gimp-undo-push-group-start image2)
  (gimp-selection-all image)
  ;(gimp-edit-copy drawable)
	(script-fu-copy-visible image drawable)
  (gimp-selection-none image)
  (set! i w2)
  (while (> i 0)
    (set! i (- i w))
    (set! j h2)
    (while (> j 0)
      (set! j (- j h))
      (gimp-rect-select image2 i j w h ADD FALSE 0)
      (set! fs (car (gimp-edit-paste drawable2 FALSE)))
      (gimp-selection-none image2)))
  (gimp-floating-sel-anchor fs)
  (gimp-display-new image2)
  (gimp-undo-push-group-end image2)
  (gimp-undo-push-group-end image)
  (gimp-displays-flush))

; Register!

(script-fu-register "script-fu-replicator"
  "<Image>/Script-Fu/Utils/Replicator"
  "Clone an image into a bigger one filled with the original."
  "Marco Lamberto <lm@geocities.com>"
  "Marco Lamberto"
  "01 Aug 1997 - 30 Aug 1998"
  "RGB*, GRAY*"
  SF-IMAGE "Image" 0
  SF-DRAWABLE "Drawable" 0
  SF-VALUE "Rows" "2"
  SF-VALUE "Columns" "2")
