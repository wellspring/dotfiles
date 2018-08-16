;-------------------------------------------------
; cai-split-toning.scm
; - Changelog -
; 2012-08-01 Initial release (1.0)
; Works with Gimp 2.8
;
; http://cai.shop.tm/gimp/script-fu/split-toning/
;
; based on algorithm
; http://gimp-tutorials.net/GIMP-split-toning-tutorial
;-------------------------------------------------
(define (script-fu-cai-split-toning inImage to-new-layer)
 (let* (
   (layer1 0)
   (layer2 0)
   (layer3 0)
   (layer4 0)
   (layermask 0)
   (color-backup 0)
  )
  (gimp-image-undo-group-start inImage)
  (set! color-backup (car (gimp-context-get-foreground)))
  (set! layer1 (car (gimp-layer-new-from-visible inImage inImage "Split toning layer")))
  (gimp-image-insert-layer inImage layer1 0 -1)
  (set! layer2 (car (gimp-layer-new-from-visible inImage inImage "Cold tone layer")))
  (gimp-image-insert-layer inImage layer2 0 -1)
  (gimp-desaturate layer2)
  (set! layer3 (car (gimp-layer-new inImage (car (gimp-image-width inImage)) (car (gimp-image-height inImage)) RGBA-IMAGE "Colorization layer" 100 OVERLAY-MODE)))
  (gimp-image-insert-layer inImage layer3 0 -1)
  (gimp-context-set-foreground "#2bc6ff")
  (gimp-selection-all inImage)
  (gimp-edit-fill layer3 FOREGROUND-FILL)
  (gimp-image-merge-down inImage layer3 EXPAND-AS-NECESSARY)

  (set! layer3 (car (gimp-layer-new-from-drawable layer1 inImage)))
  (gimp-image-insert-layer inImage layer3 0 -1)
  (gimp-layer-set-name layer3 "Warm tone layer")
  (gimp-desaturate layer3)
  (set! layer4 (car (gimp-layer-new inImage (car (gimp-image-width inImage)) (car (gimp-image-height inImage)) RGBA-IMAGE "Colorization layer" 100 OVERLAY-MODE)))
  (gimp-image-insert-layer inImage layer4 0 -1)
  (gimp-context-set-foreground "#ffc600")
  (gimp-selection-all inImage)
  (gimp-edit-fill layer4 FOREGROUND-FILL)
  (gimp-image-merge-down inImage layer4 EXPAND-AS-NECESSARY)

  (set! layermask (car (gimp-layer-create-mask (car (gimp-image-get-layer-by-name inImage "Cold tone layer")) ADD-COPY-MASK)))
  (gimp-layer-add-mask (car (gimp-image-get-layer-by-name inImage "Cold tone layer")) layermask)
  (gimp-image-set-active-layer inImage (car (gimp-image-get-layer-by-name inImage "Cold tone layer")))
  (gimp-invert layermask)

  (set! layermask (car (gimp-layer-create-mask (car (gimp-image-get-layer-by-name inImage "Warm tone layer")) ADD-COPY-MASK)))
  (gimp-layer-add-mask (car (gimp-image-get-layer-by-name inImage "Warm tone layer")) layermask)
  (gimp-layer-set-opacity (car (gimp-image-get-layer-by-name inImage "Warm tone layer")) 75)

  (if (= to-new-layer FALSE)
      (gimp-image-merge-visible-layers inImage EXPAND-AS-NECESSARY)
      (begin
        (gimp-image-merge-down inImage (car (gimp-image-get-layer-by-name inImage "Warm tone layer")) EXPAND-AS-NECESSARY)
        (gimp-image-merge-down inImage (car (gimp-image-get-layer-by-name inImage "Cold tone layer")) EXPAND-AS-NECESSARY)	  
	  )
  )
  (gimp-context-set-foreground color-backup)
  (gimp-image-undo-group-end inImage)
  (gimp-displays-flush)
 )  
)

(script-fu-register
 "script-fu-cai-split-toning"
 "Split toning"
 "Split toning"
 "Alex I. Chebykin"
 "Alex I. Chebykin"
 "August 1, 2012"
 "RGB*"
 SF-IMAGE      "The image"     0
 SF-TOGGLE     "Result to new layer"   TRUE
)
(script-fu-menu-register "script-fu-cai-split-toning" "<Image>/Filters/CAI")