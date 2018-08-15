; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Multiple Block script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
;   - Changelog -
; version 0.1  2001/06/22 iccii <iccii@hotmail.com>
;     - Initial relase
;     - This relase has *many* bugs!
; version 0.2  2001/06/23 iccii <iccii@hotmail.com>
;     - Fixes many bugs
;     - Add Stars option
; version 0.3 Raymond Ostertag 2004/09
;     - Ported to Gimp2
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

(define (script-fu-multiple-circle
		inSize		; ‘å‚«‚³
		inType		; Ží—Þ
		inBrush		; •`‰æƒuƒ‰ƒV
		inNumber	; —Ö‚Ì”A‰½d‚É‚È‚é‚©
		inBlock		; ƒuƒƒbƒNA‰½ŠpŒ`‚É‚È‚é‚©
		inDegree	; ŠJŽnŠp“x
		inRadius-inn	; “à‘¤”¼Œa
		inRadius-out	; ŠO‘¤”¼Œa
	)

  (let* (
	 (count 1)
	 (brush-old (car (gimp-brushes-get-brush)))
	 (theWidth inSize)
	 (theHeight inSize)
	 (theRadius (/ (max theWidth theHeight) 2))
	 (theDegree-step (/ (* *pi* 2) inBlock))
	 (theRadius-step (/ (- theRadius inRadius-inn (- theRadius inRadius-out)) (if (equal? inType 2) (+ inNumber 1) inNumber)))
	 (theInitial-degree (/ (* 2 *pi* inDegree) 360))
	 (theImage (car (gimp-image-new theWidth theHeight RGB)))
	 (theLayer (car (gimp-layer-new theImage theWidth theHeight RGB-IMAGE "Background" 100 NORMAL-MODE)))
	) ; end variable definition

    (gimp-image-undo-disable theImage)
    (gimp-image-add-layer theImage theLayer -1)
    (gimp-drawable-fill theLayer BACKGROUND-FILL)
    (gimp-brushes-set-brush (car inBrush))
	;; “à‘¤”¼Œa‚ªŠO‘¤”¼Œa‚æ‚è‚à‘å‚«‚©‚Á‚½‚ç’†’f
    (if (> inRadius-inn inRadius-out)
        (begin
          (gimp-message "Inner Radius is more than Outer Radius!\n Abort!")
          (set! count inNumber)))
	 ;; “à‘¤/ŠO‘¤”¼Œa‚ª‰æ‘œ‚Ì‘å‚«‚³‚æ‚è‚à‘å‚«‚©‚Á‚½‚ç’†’f
    (if (or (> inRadius-inn inSize) (> inRadius-out inSize))
        (begin
          (gimp-message "Inner/Outer Radius is more than image size!\n Abort!")
          (set! count inNumber)))
    (while (>= inNumber count)
      (let* ((radius (+ (* count theRadius-step) inRadius-inn)))
        (cond

;;;;;;;;;;;;;;;;;;;; Circle

	  ((equal? inType 0)
	     (let* ((x (- (/ theWidth 2) radius))
	            (y (- (/ theHeight 2) radius))
	            (width (* 2 radius))
	            (height (* 2 radius))
	           )
	       (gimp-ellipse-select theImage x y width height CHANNEL-OP-ADD FALSE 0 0)
	       (gimp-edit-stroke theLayer)
	       (gimp-selection-none theImage)
	     )	;; end of let*
	  )

;;;;;;;;;;;;;;;;;;;; Multiple

	  ((equal? inType 1)
	     (let* ((count-inn 0))
	       (while (> inBlock count-inn)
	         (let* ((strokes (cons-array 4 'double))
	                (degree1 (+ theInitial-degree (* count-inn theDegree-step)))
	                (degree2 (+ theInitial-degree (* (+ count-inn 1) theDegree-step)))
	                (x1 (+ (* radius (cos degree1)) (/ theWidth 2)))
	                (y1 (+ (* radius (sin degree1)) (/ theHeight 2)))
	                (x2 (+ (* radius (cos degree2)) (/ theWidth 2)))
	                (y2 (+ (* radius (sin degree2)) (/ theHeight 2)))
	               )
	           (aset strokes 0 x1)
	           (aset strokes 1 y1)
	           (aset strokes 2 x2)
	           (aset strokes 3 y2)
	           (gimp-paintbrush theLayer 0 4 strokes PAINT-CONSTANT 0)
	         )	;; end of let*
	       (set! count-inn (+ count-inn 1))
	       )	;; end of while loop
	    )		;; end of let*
	  )

;;;;;;;;;;;;;;;;;;;; Star

	  ((equal? inType 2)
	     (let* ((count-inn 0))
	       (while (> inBlock count-inn)
	         (let* ((strokes (cons-array 6 'double))
	                (degree1 (+ theInitial-degree (* count-inn theDegree-step)))
	                (degree2 (+ theInitial-degree (* (+ count-inn 1) theDegree-step)))
	                (degree3 (+ theInitial-degree (* (+ count-inn 0.5) theDegree-step)))
	                (x1 (+ (* radius (cos degree1)) (/ theWidth 2)))
	                (y1 (+ (* radius (sin degree1)) (/ theHeight 2)))
	                (x2 (+ (* radius (cos degree2)) (/ theWidth 2)))
	                (y2 (+ (* radius (sin degree2)) (/ theHeight 2)))
	                (x3 (+ (* (+ radius theRadius-step) (cos degree3)) (/ theWidth 2)))
	                (y3 (+ (* (+ radius theRadius-step) (sin degree3)) (/ theHeight 2)))
	               )
	           (aset strokes 0 x1)
	           (aset strokes 1 y1)
	           (aset strokes 2 x3)
	           (aset strokes 3 y3)
	           (aset strokes 4 x2)
	           (aset strokes 5 y2)
	           (gimp-paintbrush theLayer 0 6 strokes PAINT-CONSTANT 0)
	         )	;; end of let*
	       (set! count-inn (+ count-inn 1))
	       )	;; end of while loop
	    )		;; end of let*
	  )

;;;;;;;;;;;;;;;;;;;; [...]

        )	;; end of let*
      )	;; end of cond
      (set! count (+ count 1))
    )	;; end of whole while loop

    (gimp-brushes-set-brush brush-old)
    (gimp-image-undo-enable theImage)
    (gimp-display-new theImage)
    (gimp-displays-flush)
  )
)

	; “o˜^‚È‚Ç
(script-fu-register
	"script-fu-multiple-circle"
	"<Toolbox>/Xtns/Script-Fu/Patterns/Multiple Circles..."
	;"<Toolbox>/Xtns/Script-Fu/Tests/Multiple Circles..."
	"Draw the multiple block"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"Jun, 2001"
	""
	SF-ADJUSTMENT	_"Image Size"		'(256 1 1024 1 10 0 1)
	SF-OPTION	_"Seed"			'(_"Circles" _"Polygons" _"Stars")
	SF-BRUSH	_"Use Brush"		'("Circle (05)" 1.0 44 0)
	SF-ADJUSTMENT	"Number"		'(5 1 32 1 10 0 0)
	SF-ADJUSTMENT	"Block"			'(6 2 32 1 10 0 0)
	SF-ADJUSTMENT	"Start Angle"		'(30 0 360 1 10 0 0)
	SF-ADJUSTMENT	"Inner Radius"		'(10 0 512 1 10 0 1)
	SF-ADJUSTMENT	"Outer Radius"		'(115 0 512 1 10 0 1)
)
