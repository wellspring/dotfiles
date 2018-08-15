;Original concept by Dave Jaseck <jaseck@sbcglobal.net>
;Script Written by Toby Lounsbury <HighNoonRiders@online.ie>
;The original Photoshop action script can be found at http://www.atncentral.com/
; Original description - The prolific Dave Jaseck produces an action that creates a "midnight in the garden" look


(define (script-fu-midnight-sepia TheImage TheLayer FinalOpacity)


(gimp-image-undo-group-start TheImage)
  
(set! WorkLayer (car(gimp-layer-copy TheLayer 0)))
(gimp-image-add-layer TheImage WorkLayer 0)

(plug-in-gauss-rle TRUE TheImage WorkLayer 20 TRUE TRUE)
(gimp-colorize WorkLayer 45 25 20)
(gimp-layer-set-mode WorkLayer 3)

(set! TheLayer (car (gimp-image-flatten TheImage)))

(set! TempLayer (car(gimp-layer-copy TheLayer 0)))
(gimp-layer-set-mode TempLayer 4)
(gimp-image-add-layer TheImage TempLayer 0)

(set! TheLayer (car (gimp-image-flatten TheImage)))

(set! WorkLayer (car (gimp-layer-copy TheLayer 0)))
(gimp-layer-set-name WorkLayer "Adjust Opacity")
(gimp-layer-set-mode WorkLayer 4)
(gimp-layer-set-opacity WorkLayer FinalOpacity)
(gimp-image-add-layer TheImage WorkLayer 0)


(gimp-image-undo-group-end TheImage)
(gimp-displays-flush)
)


(script-fu-register "script-fu-midnight-sepia"
		    _"_Midnight Sepia..."
		    "Creates a midnight in the garden effect"
		    "Toby Lounsbury <HighNoonRiders@online.ie>"
		    "Toby Lounsbury"
		    "2005"
		    "RGB* GRAY*"
		    SF-IMAGE       "The image"          0
		    SF-DRAWABLE    "The layer"       0
		    SF-ADJUSTMENT _"Brightness"        '(0 0 100 1 10 0 0))
(script-fu-menu-register "script-fu-midnight-sepia"
			 _"<Image>/Script-Fu/Decor")