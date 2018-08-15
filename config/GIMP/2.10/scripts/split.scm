(define (split-width inimage indraw split)
(set! theImage inimage)
(set! theHeight (car (gimp-image-height theImage)))
(set! theWidth (car (gimp-image-width theImage)))
(set! selectWidth (/ theWidth split))

(let*(
(s 1))
(while (<= s split)
(gimp-rect-select theImage (* selectWidth (- s 1)) 0 selectWidth theHeight 0 0 0)
(gimp-edit-copy-visible theImage)

(set! newimage (gimp-image-new selectWidth theHeight 0))
(set! newlayer (gimp-layer-new (car newimage) selectWidth theHeight 1 "newlayer" 100 0))
(gimp-image-add-layer (car newimage) (car newlayer) 0)

(gimp-drawable-fill (car newlayer) 3)
(set! copy-float (car (gimp-edit-paste (car newlayer) 0 )))
(gimp-floating-sel-anchor copy-float)
(gimp-display-new (car newimage))
(gimp-selection-none theImage)
(set! s (+ s 1)))
))
(script-fu-register 	"split-width"
			"<Image>/Script-Fu/Gimp-talk.com/split-width..."
			"splits the image into a requested amount of equal sized images width ways"
			"Karl Ward"
			"Karl Ward"
			"Feb 2006"
			""
			SF-IMAGE      "SF-IMAGE" 0
			SF-DRAWABLE   "SF-DRAWABLE" 0
			SF-ADJUSTMENT "to be split into" '(2 2 30 1 5 0 1)			
)
				
