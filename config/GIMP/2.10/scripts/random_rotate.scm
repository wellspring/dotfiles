; random_rotate.scm
; by Rob Antonishen
; http://ffaat.pointclark.net

; Version 1.0 (20080931)

; Description
;
; Script to randomly rotate the  floating layer
;

; License:
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
; The GNU Public License is available at
; http://www.gnu.org/copyleft/gpl.html

(define (script-fu-random-rotate img inLayer)
  (let* 
    (
	  (varAngle (/ (* 2 *pi* (rand 360)) 360))   ;random angle to rotate
	  (varLayer (car (gimp-image-get-floating-sel img)))         ;get floating selection ID
	)
	
	; it begins here 
	(gimp-image-undo-group-start img)
	
    (if (<> varLayer -1)  ;if here is a floating selection
	  (begin
        (gimp-layer-scale-full varLayer 
                                (trunc (* (car (gimp-drawable-width varLayer)) (+ 0.5 (/ (rand 1000) 2000.0))))
                                (trunc (* (car (gimp-drawable-height varLayer)) (+ 0.5 (/ (rand 1000) 2000.0))))
                                TRUE INTERPOLATION-LANCZOS)
        (set! varLayer (car (gimp-drawable-transform-rotate varLayer varAngle TRUE 0 0 TRANSFORM-FORWARD INTERPOLATION-LANCZOS TRUE 3 TRANSFORM-RESIZE-ADJUST)))
        (gimp-floating-sel-anchor varLayer)  ;anchor
        (gimp-displays-flush)
    )
	)
	
	;done
	(gimp-image-undo-group-end img)
  )
)

(script-fu-register "script-fu-random-rotate"
        		    "<Image>/Filters/Random Rotate"
                    "Randomly rotate then anchor the floating selection."
                    "Rob Antonishen"
                    "Rob Antonishen"
                    "Sept 2008"
                    ""
                    SF-IMAGE      "image"      0
                    SF-DRAWABLE   "drawable"   0	
)				