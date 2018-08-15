;script-fu-splix ver. 3.0
;Extract masks of light and dark areas of the image and tone them into two different colors.
;Version history:
;==================================================================
;ver. 0.1а (September 2009)
; - broken script;
;==================================================================
;ver. 0.3 (September 2009)
; - working script, only with mask extracting;
;==================================================================
;ver. 0.5 (September 2009)
; - script's release;
;==================================================================
;ver. 0.7 (September 2009)
; - some changes in script's procedures;
;==================================================================
;ver. 1.0 (September 2009)
; - additional levels expression;
; - work with visible;
;==================================================================
;ver. 2.0 (23th October 2009)
; - added controls of the mask blending;
;==================================================================
;ver. 2.2 (7th December 2009)
; - remove some useless procedures;
; - interface optimization;
; - affect on contrast control;
; - undo/rebo support;
; - first public release;
;==================================================================
;ver. 2.4 (15th January 2010) #development release
; - faster layers merging;
; - source mask searching (#SPL);
;==================================================================
;ver. 3.0 (22th January 2010)
; - optimization in script's structure;
; - optional affect layer creation;
; - sublayer desaturation (optional);
;==================================================================

;List of input variables:
;image - processed image;
;sEdge - offset of the mask edge;
;sRez - width of the range in the mask;
;sLight - color for light mask;
;sDark - color for dark mask;
;lightboost - additional saturation for light area of the result image;
;opcLight - control for blending light mask;
;opcDark - control for blending dark nask;
;aff - control affection on contrast of the result image;
;srcswitch - toggle for saving source layers;
;viz - toggle for working with visible;
;search - toggle for mask searching;
;des - toggle for sublayer's desaturation;
(define (script-fu-splix3 image sEdge sRez sLight sDark lightboost opcLight opcDark aff srcswitch viz search des)
  (let* (
	(sublayer (car (splix3-source-handle image viz srcswitch)))
	(light (car (gimp-layer-copy sublayer FALSE)))
	(dark (car (gimp-layer-copy sublayer FALSE)))
	(aff-state)
	(affect)
	(aff-src)
	(mask-aff)
	(lightmask)
	(low-input (+ (+ 0 sEdge) sRez))
	(high-input (- (+ 255 sEdge) sRez))
	(reslayer)
	)

	;Undo group start
	(gimp-image-undo-group-start image)

	;Checking and fix variables
	(if (> high-input 255)
	  (set! high-input 255)
	)
	(if (< low-input 0)
	  (set! low-input 0)
	)

	;Desaturation section
	(if (= des TRUE)
	  (gimp-desaturate sublayer)
	)
	(gimp-image-add-layer image dark -1)
	(gimp-image-add-layer image light -1)
	(gimp-drawable-set-name light "Light tone")
	(gimp-drawable-set-name dark "Dark tone")

	;Getting mask and affect source
	(set! mask-aff (splix3-mask-handle image light search))
	(set! lightmask (car mask-aff))
	(set! aff-src (cadr mask-aff))

	;affection section
	(if (> aff 0)
	  (begin
	    (set! affect (car (gimp-layer-copy aff-src FALSE)))
	    (set! aff-state (car (gimp-layer-get-visible affect)))

	    ;cheking visibility
	    (if (= aff-state FALSE)
	      (gimp-layer-set-visible affect TRUE)
	    )
	    (gimp-image-add-layer image affect -1)
	    (gimp-drawable-set-name affect "Contrast affect")
	    (gimp-layer-set-mode affect 5)
	    (gimp-desaturate affect)
	    (gimp-levels affect 0 low-input high-input 1.0 0 255)
	    (gimp-layer-set-opacity affect aff)
	    (gimp-image-lower-layer image affect)
	  )
	)
	(gimp-layer-add-mask light lightmask)
	(gimp-levels lightmask 0 low-input high-input 1.0 0 255)
	(plug-in-colorify 1 image light sLight)
	(plug-in-colorify 1 image dark sDark)
	(gimp-hue-saturation light 0 0 0 lightboost)
	(gimp-layer-set-mode light 13)
	(gimp-layer-set-mode dark 13)
	(gimp-layer-set-opacity light opcLight)
	(gimp-layer-set-opacity dark opcDark)
	
	;final merging
	(if (= srcswitch FALSE)
	    (begin
		(set! reslayer (car (gimp-image-merge-down image dark 0)))
		(if (> aff 0)
		  (set! reslayer (car (gimp-image-merge-down image affect 0)))
		)
		(set! reslayer (car (gimp-image-merge-down image light 0)))
		(gimp-drawable-set-name reslayer "SpliX Result")
	    )
	)

	;end of the script
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
  )
)

(script-fu-register
"script-fu-splix3"
"Spli_X v3.0"
"Tone light and dark areas into two different colors"
"Nepochatov Stanislav"
"Free for any purpose"
"January 2010"
"*"
SF-IMAGE	"Input image"			0
SF-ADJUSTMENT	"Edge offset"			'(0 -120 120 10 30 1 0)
SF-ADJUSTMENT	"Edge sharpness"		'(0 0 120 10 30 1 0)
SF-COLOR	"Light color"			'(200 175 140)
SF-COLOR	"Dark color"			'(80 102 109)
SF-ADJUSTMENT	"Light area сolor burst"	'(75 0 100 10 30 1 0)
SF-ADJUSTMENT	"Light tone"			'(100 0 100 10 25 1 0)
SF-ADJUSTMENT	"Dark tone"			'(100 0 100 10 25 1 0)
SF-ADJUSTMENT	"Affect on contrast"		'(0 0 100 10 25 1 0)
SF-TOGGLE	"Save procedural layers"	FALSE
SF-TOGGLE	"Work with visible"		FALSE
SF-TOGGLE	"Search source mask (#SPL*)"	FALSE
SF-TOGGLE	"Desaturate sublayer"		FALSE
)

(script-fu-menu-register
"script-fu-splix3"
_"<Image>/Filters/Artistic/SpliX"
)

;splix3-source-handle
;SERVICE PROCEDURE
;List of input variables:
;image - processed image;
;viz - toggle for working with visible;
;srcswitch - toggle for saving source layers;
;List of output variables:
;exit - (layer) proper source layer for main script;
(define (splix3-source-handle image viz srcswitch)
(define exit)
  (let* (
	(active (car (gimp-image-get-active-layer image)))
	(exit-layer)
	)
	(if (= viz TRUE)
	  (begin
	    (gimp-edit-copy-visible image)
	    (set! exit-layer 
	      (car
		(gimp-edit-paste active TRUE)
	      )
	    )
	    (gimp-floating-sel-to-layer exit-layer)
	    (gimp-drawable-set-name exit-layer "Source = Visisble")
	    (gimp-image-raise-layer-to-top image exit-layer)
	  )
	  (begin
	    (set! exit-layer (car (gimp-layer-copy active FALSE)))
	    (gimp-image-add-layer image exit-layer -1)
	    (gimp-drawable-set-name exit-layer "Source = Copy")
	  )
	)
	(set! exit exit-layer)
  )
(cons exit '())
)

;splix3-mask-handle
;SERVICE PROCEDURE
;List of input variables:
;image - processed image;
;imput-layer - processed layer;
;search_switch - toggle for mask searching;
;List of output variables:
;list - (LIST) result list with exit mask (CHANNEL) and exit layer (LAYER);
(define (splix3-mask-handle image input_layer search_switch)
(define o-mask 0)
(define o-layer 0)
  (let* (
	(layers_list (gimp-image-get-layers image))
	(layers_count (car layers_list))
	(layers_array (cadr layers_list))
	(n (- layers_count 1))
	(x 0)
	(second_step FALSE)
	)
	(if (= search_switch TRUE)
	  (begin
	    (while (>= n x)
	      (let* (
		    (cur_layer (aref layers_array x))
		    (cur_str (car (gimp-drawable-get-name cur_layer)))
		    (cur_leng (string-length cur_str))
		    )
		    (set! x (+ x 1))
		    (if (>= cur_leng 4)
		      (if (equal? (substring cur_str 0 4) "#SPL")
			(begin
			  (set! o-mask (car (gimp-layer-create-mask cur_layer 5)))
			  (set! o-layer cur_layer)
			  (set! x (* n n))
			)
		      )
		    )
	      )
	    )
	  )
	)
	
	(cond
	  ((= o-mask 0) (set! second_step TRUE))
	  ((= search_switch FALSE) (set! second_step TRUE))
	)

	(if (= second_step TRUE)
	  (begin
	    (set! o-mask (car (gimp-layer-create-mask input_layer 5)))
	    (set! o-layer input_layer)
	  )
	)
  )
(list o-mask o-layer)
)