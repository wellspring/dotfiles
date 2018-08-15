;Copyright 2003 Jonathan Bartlett
;
;Permission is granted to use this script for any purpose and under any
;license.  Permission is granted to relicense.  Any notice may be added or 
;removed.
;

;NOTE - this part is purely functional
;This procedure takes a given width and height and a constrained width and
;height and scaled to that width/height keeping the aspect ratio
(define (get-constrained-scaled-dimensions start-width start-height max-width max-height)
	(let*
		(
			;NOTE - GIMP doesn't have delay, so we are just going
			;       with procedures of no arguments.  Can't evaluate
			;       here because of divide-by-zero worries
			(scale-by-width (lambda () (/ max-width start-width)))
			(scale-by-height (lambda () (/ max-height start-height)))
			(dimensions-height (lambda () (list (* start-width (scale-by-height)) max-height)))
			(dimensions-width (lambda () (list max-width (* start-height (scale-by-width)))))
		)
		(cond 
			((eq? max-width 0) (dimensions-height))
			((eq? max-height 0) (dimensions-width))
			((> (abs (scale-by-width)) (abs (scale-by-height))) 
				(dimensions-height)
			)
			(#t (dimensions-width))
		)
	)
)


;This is the GIMP-operating procedure
(define (script-fu-scale-image-constrained img drw max-width max-height)
	(let*
		(
			(layers (cadr (gimp-image-get-layers img)))
			(top-layer (aref layers 0))
			(start-width (car (gimp-image-width img)))
			(start-height (car (gimp-image-height img)))
			(new-dimensions (get-constrained-scaled-dimensions start-width start-height max-width max-height) )
		)
		(begin
			(gimp-undo-push-group-start img)
			(if (eq? (car (gimp-drawable-is-rgb top-layer)) 0)
				(gimp-convert-rgb img)
			)
			(gimp-image-scale img (car new-dimensions) (cadr new-dimensions))
			(list img top-layer)
			(gimp-undo-push-group-end img)
			(gimp-displays-flush)
		)
	)
)

(script-fu-register "script-fu-scale-image-constrained"
	_"<Image>/Image/Scale Image Constrained..."
	"Scales an image to best-fit based on width/height constraints, keeping the aspect ratio.  The resulting image will be an RGB image, no matter what was started with.  To only have one constraint, use 0 for the other one."
	"Jonathan Bartlett <johnnyb@eskimo.com>"
	"Jonathan Bartlett"
	"2003/08/07"
	""
	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-VALUE _"Width" "0"
	SF-VALUE _"Height" "0"
)