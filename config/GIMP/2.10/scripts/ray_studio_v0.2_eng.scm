;Ray Studio v0.2
;
;Ray Studio - ray effect creation script;
;
;Version history:
;==================================================================
;ver. 0.2 (November 27th 2011)
; - official release;
;==================================================================

;script-fu-ray-studio
;Main function
;LIST OF ARGUMENTS:
;IMAGE - processed image;
;LAYER - processed layerй;
;FLOAT - lightning edge;
;COLOR - ray's tone color;
;FLOAT - ray toning opacity;
;INTEGER - X coord for center of ray;
;INTEGER - Y coord for center of ray;
;INTEGER - blur size (ray longness);
;INTEGER - resolution degradation step;
(define (script-fu-ray-studio image layer ray_edge ray_color ray_color_opc x_axis y_axis blur_factor blur_degd)

  (let* (
	(org_imh (car (gimp-image-height image)))
	(org_imw (car (gimp-image-width image)))
	(degd_values (list 1 2 4 8 16))
	(fx_imh (/ org_imh (list-ref degd_values blur_degd)))
	(fx_imw (/ org_imw (list-ref degd_values blur_degd)))
	(ref_x_axis (/ x_axis (list-ref degd_values blur_degd)))
	(ref_y_axis (/ y_axis (list-ref degd_values blur_degd)))
	(fximage (car (gimp-image-new org_imw org_imh 0)))
	(fxlayer (car (gimp-layer-new-from-drawable layer fximage)))
	(reslayer)
	(colorlayer)
	(rotated FALSE)
	(fore (car (gimp-context-get-foreground)))
	)

	(gimp-image-undo-group-start image)
	(gimp-image-undo-disable fximage)

	(gel-image-insert-layer fximage fxlayer -1)
	(if (> blur_degd 0)
	  (gel-image-scale-full fximage fx_imw fx_imh 2)
	)
	(if (or (< ref_x_axis 0) (< ref_y_axis 0))
	  (begin
	    (set! rotated TRUE)
	    (gimp-image-rotate fximage 1)
	    (if (< ref_x_axis 0)
	      (set! ref_x_axis (+ (- 0 ref_x_axis) fx_imw))
	      (set! ref_x_axis (- fx_imw ref_x_axis))
	    )
	    (if (< ref_y_axis 0)
	      (set! ref_y_axis (+ (- 0 ref_y_axis) fx_imh))
	      (set! ref_y_axis (- fx_imh ref_y_axis))
	    )
	  )
	)
	(gimp-levels fxlayer 0 ray_edge 255 1.0 0 255)
	(plug-in-mblur 1 fximage fxlayer 2 blur_factor 0 ref_x_axis ref_y_axis)
	(if (> ray_color_opc 0)
	  (begin
	    (set! colorlayer (car (gimp-layer-new fximage fx_imw fx_imh 1 "Ray Studio (color overlay)" ray_color_opc 0)))
	    (gimp-brightness-contrast fxlayer 0 (/ (- 0 ray_color_opc) 3))
	    (gel-image-insert-layer fximage colorlayer -1)
	    (gimp-context-set-foreground ray_color)
	    (gimp-edit-fill colorlayer 0)
	    (gimp-layer-set-mode colorlayer 13)
	    (set! fxlayer (car (gimp-image-merge-down fximage colorlayer 0)))
	    (gimp-context-set-foreground fore)
	  )
	)
	(if (= rotated TRUE)
	  (gimp-image-rotate fximage 1)
	)
	(set! reslayer (car (gimp-layer-new-from-drawable fxlayer image)))
	(gel-image-insert-layer image reslayer -1)
	(gel-item-set-name reslayer "Result")
	(if (> blur_degd 0)
	  (gel-layer-scale-full reslayer org_imw org_imh FALSE 2)
	)
	(gimp-layer-set-mode reslayer 4)
	(gimp-image-undo-group-end image)
	(gimp-image-delete fximage)
	(gimp-displays-flush)
  )
)

(script-fu-register
"script-fu-ray-studio"
"<Image>/Filters/RSS/Ray S_tudio"
"Creating ray effect with resolution control"
"Nepochatov Stanislav"
"Free license"
"November 27th 2011"
"RGB,RGBA*"
SF-IMAGE	"Image"				0
SF-DRAWABLE	"Layer"				0
SF-ADJUSTMENT	"Lightning edge"		'(0 0 255 15 45 1 0)
SF-COLOR	"Ray's tone color"		'(134 164 225)
SF-ADJUSTMENT	"Ray toning opacity"		'(45 0 100 10 10 1 0)
SF-VALUE	"X"				"0"
SF-VALUE	"Y"				"0"
SF-VALUE	"Blur size"			"0"
SF-OPTION	"Degrade resolution"		'(
						"1 (very slow)"
						"1/2"
						"1/4"
						"1/8"
						"1/16 (poor quality)"
						)
)