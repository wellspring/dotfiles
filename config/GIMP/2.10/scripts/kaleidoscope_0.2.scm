; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Kaleidoscope script (easy version)  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/11/10
;     - Initial relase
;
; version 0.2 Raymond Ostertag 2004/10
;     - Ported to Gimp2
;     - Changed menu entry
 
; --------------------------------------------------------------------
;     Reference Book
; http://www.shoeisha.com/book/Detail.asp?bid=1227
; --------------------------------------------------------------------
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
;

; -- TODO --
; * Layer Mask
; * Selection


	;; Glass Tile script

(define (script-fu-kaleidoscope-easy
			img		;; Target Image
			drawable	;; Target Drawable (Layer)
			mode1		;; Layer mode 1
			mode2		;; Layer mode 2
	)

  (define (list-ref l n) (nth n l))

  (define (get-layer-mode mode)
    (cond 
          ((= mode 2) MULTIPLY-MODE)
          ((= mode 3) SCREEN-MODE)
          ((= mode 4) OVERLAY-MODE)
          ((= mode 5) DIFFERENCE-MODE)
          ((= mode 6) ADDITION-MODE)
          ((= mode 1) DARKEN-ONLY-MODE)
          ((= mode 0) LIGHTEN-ONLY-MODE)
          ((= mode 7) SUBTRACT-MODE)
          ((= mode 8) DIVIDE-MODE)
          ('else      NORAML-MODE) ))

  (gimp-image-undo-group-start img)

  (let* (
         (layer-mode1 (get-layer-mode mode1))
         (layer-mode2 (get-layer-mode mode2))
	 (old-selection (car (gimp-selection-save img)))
         (selection-bounds (gimp-selection-bounds img))
         (have-selection? (car selection-bounds))
        )
    (if (eqv? have-selection? FALSE)
        (gimp-selection-all img))
    (gimp-edit-copy drawable)

    (let* (
           (image-width (if (eqv? have-selection? TRUE)
                            (- (list-ref selection-bounds 3) (list-ref selection-bounds 1))
                            (car (gimp-drawable-width drawable))))
           (image-height (if (eqv? have-selection? TRUE)
                             (- (list-ref selection-bounds 4) (list-ref selection-bounds 2))
                             (car (gimp-drawable-height drawable))))
           (image (car (gimp-image-new image-width image-height RGB)))
           (layer-copy1 (car (gimp-layer-new image image-width image-height
                                             RGBA-IMAGE "Kaleidoscope" 100 NORMAL-MODE)))
          )
      (gimp-image-add-layer image layer-copy1 -1)
      (gimp-floating-sel-anchor (car (gimp-edit-paste layer-copy1 0)))

      (let* (
             (layer-copy2 (car (gimp-layer-copy layer-copy1 TRUE)))
             (layer-copy3 (car (gimp-layer-copy layer-copy1 TRUE)))
             (layer-copy4 (car (gimp-layer-copy layer-copy1 TRUE)))
            )
        (gimp-layer-set-mode layer-copy2 layer-mode1)
        (gimp-layer-set-mode layer-copy3 layer-mode1)
        (gimp-layer-set-mode layer-copy4 layer-mode1)
        (gimp-image-add-layer image layer-copy2 -1)
        (gimp-image-add-layer image layer-copy3 -1)
        (gimp-image-add-layer image layer-copy4 -1)
        (gimp-flip layer-copy2 ORIENTATION-HORIZONTAL)
        (gimp-flip layer-copy3 ORIENTATION-HORIZONTAL)
        (gimp-flip layer-copy3 ORIENTATION-VERTICAL)
        (gimp-flip layer-copy4 ORIENTATION-VERTICAL)

        (set! marged-layer1 (car (gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)))
        (set! marged-layer2 (car (gimp-layer-copy marged-layer1 TRUE)))
        (gimp-image-add-layer image marged-layer2 -1)
        (gimp-layer-set-mode marged-layer2 layer-mode2)
        (gimp-rotate marged-layer2 FALSE (* 2 *pi* (/ 90 360)))
        (set! marged-layer3 (car (gimp-image-merge-visible-layers image EXPAND-AS-NECESSARY)))

        (gimp-edit-copy marged-layer3)
        (gimp-floating-sel-anchor (car (gimp-edit-paste drawable 0)))
        (if (eqv? have-selection? FALSE)
          (gimp-selection-none img)
          (gimp-selection-load old-selection))
        (gimp-image-remove-channel img old-selection)

      ); end of let*
    ) ; end of let*
  ) ; end of let*
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)
)

(script-fu-register
  "script-fu-kaleidoscope-easy"
  "<Image>/Script-Fu/Render/Kaleidoscope..."
  "Create kaleidoscope image"
  "Iccii <iccii@hotmail.com>"
  "Iccii"
  "2001, Nov"
  "RGB* GRAY* INDEXED*"
  SF-IMAGE      "Image"     0
  SF-DRAWABLE   "Drawable"  0
  SF-OPTION     "Mode 1"    (set! MODE-LIST '(
                              "Lighten Only" "Darken Only"
                              "Multiply" "Screen" "Overlay" "Difference"
                              "Addition" "Substract" "Divide"))
  SF-OPTION     "Mode 2"    MODE-LIST
)
