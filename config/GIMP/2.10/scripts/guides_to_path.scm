; Word-to-shape Rel 2
; Created by Tin Tran
; Comments directed to http://gimpchat.com or http://gimpscripts.com
;
; License: GPLv3
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
; GNU General Public License for more details.
;
; To view a copy of the GNU General Public License
; visit: http://www.gnu.org/licenses/gpl.html
;
;
; ------------
;| Change Log |
; ------------
; Rel 1: Initial release. 
; Rel 2: Allow selection bounds to be used to draw paths within this selection bound if selection exists.
(define (script-fu-guide-to-path image layer 
			
         )
	
		(let* 
		   (
		   (width (car (gimp-image-width image)))
		   (height (car (gimp-image-height image)))
		   (new-vectors 0)
		   (next-guide 0)
		   (guide-orientation 0)
		   (guide-position 0)
		   (selection 0)
		   (x1 0)
		   (y1 0)
		   (x2 0)
		   (y2 0)
		   )
			;(gimp-image-undo-disable image); DN = NO UNDO
			(gimp-context-push)
			(gimp-image-undo-group-start image)                   ;undo-group in one step
			
			(set! selection (car (gimp-selection-bounds image)))
			
			(if (= selection TRUE)
				(begin
					(set! x1 (car (cdr (gimp-selection-bounds image))))
					(set! y1 (car (cddr (gimp-selection-bounds image))))
					(set! x2 (car (cdddr (gimp-selection-bounds image))))
					(set! y2 (car (cddddr (gimp-selection-bounds image))))
				)
				(begin
					(set! x1 0)
					(set! y1 0)
					(set! x2 width)
					(set! y2 height)
				)
			)
			
			
			;gets a guide to see if we can enter the loop or not depending on guide being defined or not
			(set! next-guide (car (gimp-image-find-next-guide image next-guide)))
			(while (<> next-guide 0)
				(if (= new-vectors 0) ;if new-vectors is not set/created we create it
					(begin
						(set! new-vectors (car (gimp-vectors-new image "guides vectors")))
						(gimp-image-insert-vectors image new-vectors 0 0)
					)
				)
				(set! guide-orientation (car (gimp-image-get-guide-orientation image next-guide)))
				(set! guide-position (car (gimp-image-get-guide-position image next-guide)))
				(if (= guide-orientation ORIENTATION-HORIZONTAL)
					(begin ;stroke a Horizontal line
						(if (and (>= guide-position y1) (<= guide-position y2))
							(begin
								(gimp-vectors-stroke-new-from-points new-vectors VECTORS-STROKE-TYPE-BEZIER 12
									(list->vector (list 
									  x1 guide-position x1 guide-position x1 guide-position
									  x2 guide-position x2 guide-position x2 guide-position
													)
									)
									FALSE ;closed path or not
								)
							)
						)
					)
					(begin ;else ORIENTATION-VERTICAL ;stroke a Vertical line
						(if (and (>= guide-position x1) (<= guide-position x2))
							(begin
								(gimp-vectors-stroke-new-from-points new-vectors VECTORS-STROKE-TYPE-BEZIER 12
									(list->vector (list 
									  guide-position y1 guide-position y1 guide-position y1
									  guide-position y2 guide-position y2 guide-position y2
													)
									)
									FALSE ;closed path or not
								)
							)
						)
					)
				)
				
				;gets next guide for next time through the loop.
				(set! next-guide (car (gimp-image-find-next-guide image next-guide)))
			)
		   ;(gimp-image-undo-enable image) ;DN = NO UNDO
			(gimp-image-undo-group-end image)                     ;undo group in one step
			(gimp-context-pop)
			(gimp-displays-flush)
		)   
)
(script-fu-register
  "script-fu-guide-to-path"         ;function name
  "<Image>/Image/Guides/Guides To Path"    ;menu register
  "Creates a path that is defined by guides"       ;description
  "Tin Tran"                          ;author name
  "copyright info and description"         ;copyright info or description
  "2016"                          ;date
  "RGB*, GRAY*"                        ;mode
  SF-IMAGE      "Image" 0                   
  SF-DRAWABLE   "Layer" 0
  ;SF-STRING     "Word" "Gimp Chat Dot Com"
  ;SF-FONT        "Font"          "Sans Bold"
  ;SF-ADJUSTMENT "Center X (-1 = Image X Center)" '(-1 -1 2000 1 10 1 0)
  ;SF-ADJUSTMENT "Center Y (-1 = Image Y Center)" '(-1 -1 2000 1 10 1 0)
  ;SF-ADJUSTMENT "Radius/Width (-1 = Fit to Width)"   '(-1 -1 2000 1 10 1 0)
  ;SF-COLOR        "House/Circle Background color"     '(255 0 0)
  ;SF-ADJUSTMENT _"Highlight opacity"       '(100 0 255 1 10 0 0)  ;Graechan
  ;SF-TOGGLE       "Draw house/circle background" TRUE
  ;SF-OPTION "Shape Type" '("Circle" "House" "Tombstone" "Ice Cream Cone" "Stop Sign" "Heart")
  ;SF-TOGGLE       "Draw Circles instead of Houses" FALSE
  ;SF-ADJUSTMENT "Gaussian Blur Radius" '(38 1 200 1 10 1 0)
  ;SF-ADJUSTMENT "Colorize Hue" '(224 0 360 1 10 0 0)
  ;SF-COLOR        "Colorify" '(0 220 223) 
  ;SF-ADJUSTMENT "Levels Gamma" '(0.12 0.10 10.00 1 1 2 0)
    
  ;SF-GRADIENT   "Gradient 1"           ""
  ;SF-GRADIENT   "Gradient 2"           ""
  ;SF-ADJUSTMENT   "Border width pixels" '(50 0 1000 1 10 0 0)
  ;SF-OPTION     "Color Curves Preset" (strbreakup (car (python-fu-get-color-curves-presets-names 1)) ",")
)

;----------------------------------------------------------------------------------------------------------------------------