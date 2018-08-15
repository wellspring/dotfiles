; Brushed-Metal 1.1 by daoo

(define (daoo-apply-brushed-metal img drawable blend lenght angle1 y1 y2)
	(if (= blend TRUE)
		(gimp-edit-blend drawable 0 0 0 100 0 0 FALSE FALSE 6 4 TRUE 0 0 y1 y2)
	) ; Endif
	(if (= blend FALSE)
		(gimp-edit-bucket-fill drawable FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
	) ; Endif
	(plug-in-scatter-rgb 1 img drawable 0 0 0.2 0.2 0.2 0)
	(plug-in-mblur 1 img drawable 0 lenght angle1 0 0)
)

(define (daoo-scripts-brushed-metal-alpha img drawable blend fg bg lenght angle1)
(let* (
		(width (car (gimp-image-width img)))
		(height (car (gimp-image-height img)))
		(oldbg (car (gimp-context-get-background)))
		(oldfg (car (gimp-context-get-foreground)))
		(metal (car (gimp-layer-new img width height 1 "Metal" 100 0)))
	)
	(gimp-image-undo-group-start img)

	(gimp-image-add-layer img metal -1)
	(gimp-context-set-foreground fg)
	(gimp-context-set-background bg)

	(daoo-apply-brushed-metal img metal blend lenght angle1 width height)

	(gimp-context-set-foreground oldfg)
	(gimp-context-set-background oldbg)
	(gimp-image-undo-group-end img)
	(gimp-displays-flush)
))

(script-fu-register "daoo-scripts-brushed-metal-alpha"
	"_Brushed Metal..."
	"Adds a layer with brushed metal."
	"daoo"
	"2006, daoo creation"
	"2006"
	"RGBA RGB GRAY"
	SF-IMAGE      "img"             0
	SF-DRAWABLE   "drawable"        0
	SF-TOGGLE     "Blend?"          TRUE
	SF-COLOR      "Foregroundcolor" '(221 221 221)
	SF-COLOR      "Backgroundcolor" '(170 170 170)
	SF-ADJUSTMENT "Brush Effect Lenght" '(15 0 360 1 1 0 0)
	SF-ADJUSTMENT "Brush Effect Angle"  '(0 0 360 1 15 0 0)
)

(script-fu-menu-register "daoo-scripts-brushed-metal-alpha" "<Image>/Filters/_daoo's scripts")

(define (daoo-scripts-brushed-metal width height blend fg bg lenght angle1)
  (let* (
		(oldbg (car (gimp-context-get-background)))
		(oldfg (car (gimp-context-get-foreground)))
		(img (car(gimp-image-new width height RGB)))
		(metal-layer (car(gimp-layer-new img width height 0 "Metal Layer" 100 0)))
	)
	(gimp-image-undo-group-start img)
	(gimp-context-set-foreground oldfg)
	(gimp-context-set-background oldbg)
	(gimp-image-add-layer img metal-layer -1)

	(daoo-apply-brushed-metal img metal-layer blend lenght angle1 width height)

	(gimp-context-set-foreground oldfg)
	(gimp-context-set-background oldbg)
	(gimp-image-undo-group-end img)
	(gimp-display-new img)
))

(script-fu-register "daoo-scripts-brushed-metal"
	"_Brushed Metal..."
	"Adds a layer with brushed metal."
	"daoo"
	"2006, daoo creation"
	"2006"
	"RGBA RGB GRAY"
	SF-ADJUSTMENT "Width"           '(500 0 9999 1 15 0 1)
	SF-ADJUSTMENT "Height"          '(500 0 9999 1 15 0 1)
	SF-TOGGLE     "Blend?"          TRUE
	SF-COLOR      "Foregroundcolor" '(221 221 221)
	SF-COLOR      "Backgroundcolor" '(170 170 170)
	SF-ADJUSTMENT "Brush Effect Lenght" '(15 0 360 1 1 0 0)
	SF-ADJUSTMENT "Brush Effect Angle"  '(0 0 360 1 15 0 0)
)

(script-fu-menu-register "daoo-scripts-brushed-metal" "<Toolbox>/Xtns/_daoo's scripts")