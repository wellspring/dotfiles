; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Scroll script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/12/08
;     - Initial relase
; version 0.1a Raymond Ostertag 2004/09
;     - Changed menu entry
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


	;; Scroll

(define (script-fu-scroll
			img
			drawable
			width
			height
			wrap-type
	)


  (let* (
	 (old-fg (car (gimp-palette-get-foreground)))
         (drawable-width (car (gimp-drawable-width drawable)))
         (drawable-height (car (gimp-drawable-height drawable)))
         (offset-x (min drawable-width width))		; <- needs abs
         (offset-y (min drawable-height  height))	; <- needs abs
        ) ; end variable definition

    (gimp-undo-push-group-start img)

    (cond ((= wrap-type 0)
             (gimp-channel-ops-offset drawable FALSE OFFSET-BACKGROUND offset-x offset-y))
          ((= wrap-type 1)
             (gimp-channel-ops-offset drawable FALSE OFFSET-TRANSPARENT offset-x offset-y))
          ((= wrap-type 2)
             (gimp-channel-ops-offset drawable TRUE OFFSET-TRANSPARENT offset-x offset-y))
          ((= wrap-type 3)
             (gimp-channel-ops-offset drawable FALSE OFFSET-TRANSPARENT offset-x offset-y)
             (gimp-rect-select img (if (> 0 offset-x) 0 offset-x)
                                   (if (> 0 offset-y) (+ drawable-height offset-y -1) offset-y)
                                   (- drawable-width (abs offset-x)) 1 REPLACE FALSE 0)
             (set! float (car (gimp-selection-float drawable
                                                    0 (if (> 0 offset-y) 0 (- offset-y)))))
             (gimp-floating-sel-to-layer float)

	;; gimp-layer-scale の最後を TRUE にするとレイヤーが正しく表示されるのに
	;; FALSE にするとレイヤーが遥か彼方に移動してしまうのはなぜ？
	;; しかも offset を負の数にした時だけ発生する
             (gimp-layer-scale float (- drawable-width (abs offset-x)) (+ (abs offset-y) 1) FALSE)

             (set! drawable (car (gimp-image-merge-down img float EXPAND-AS-NECESSARY)))
             (gimp-rect-select img (if (> 0 offset-x) (+ drawable-width offset-x -1) offset-x)
                                   (if (> 0 offset-y) 0 offset-y)
                                   1 (- drawable-height (abs offset-y)) REPLACE FALSE 0)
             (set! float (car (gimp-selection-float drawable
                                                    (if (> 0 offset-x) 0 (- offset-x)) 0)))
             (gimp-floating-sel-to-layer float)
             (gimp-layer-scale float (+ (abs offset-x) 1) (- drawable-height (abs offset-y)) FALSE)
             (set! drawable (car (gimp-image-merge-down img float EXPAND-AS-NECESSARY)))
             (gimp-rect-select img (if (> 0 offset-x) (+ drawable-width offset-x) 0)
                                   (if (> 0 offset-y) (+ drawable-height offset-y) 0)
                                   (abs offset-x) (abs offset-y) REPLACE FALSE 0)
             (gimp-color-picker img drawable
                                (if (> 0 offset-x) (+ drawable-width offset-x) offset-x)
                                (if (> 0 offset-y) (+ drawable-height offset-y) offset-y)
                                FALSE FALSE 1 TRUE)
             (gimp-edit-fill drawable FG-IMAGE-FILL)
             (gimp-selection-none img))
    ) ; end of cond

    (gimp-palette-set-foreground old-fg)
    (gimp-undo-push-group-end img)
    (gimp-displays-flush)
))

(script-fu-register
  "script-fu-scroll"
  "<Image>/Script-Fu/Utils/Scroll..."
  "Apply scroll, which simulates Photoshop's Photocopy filter"
  "Iccii <iccii@hotmail.com>"
  "Iccii"
  "2001, Dec"
  "RGB* GRAY*"
  SF-IMAGE      _"Image"       0
  SF-DRAWABLE   _"Drawable"    0
  SF-ADJUSTMENT	_"Offset X"    '(10 -1000 1000 1 1 0 1)
  SF-ADJUSTMENT	_"Offset Y"    '(10 -1000 1000 1 1 0 1)
  SF-OPTION     _"Wrap Method" '("BG Color" "Transparent"
                                 "Wrap Around" "Repeat Edge Pixels")
)
