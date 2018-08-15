(define (add-text t-colour theImage text font-size font) 
(gimp-context-set-foreground t-colour)
(set! selection-bounds (gimp-selection-bounds theImage))
(set! sx1 (cadr selection-bounds))
(set! sy1 (caddr selection-bounds))
(set! sx2 (cadr (cddr selection-bounds)))
(set! sy2 (caddr (cddr selection-bounds)))
(set! text-layer (car (gimp-text-fontname theImage -1 0 0 text 0 TRUE font-size PIXELS font)))
(set! swidth  (- sx2 sx1))
(set! sheight (- sy2 sy1))
(set! hdiff (/ (- sheight (car (gimp-drawable-height text-layer))) 2 ))
(set! wdiff (/ (- swidth (car (gimp-drawable-width text-layer))) 2 ))
(gimp-layer-translate  text-layer (+ sx1 wdiff) (+ sy1 hdiff) )
)

(define (rusted-paper2 inImage inlayer distress p-colour shadow text-req text font font-size t-colour)
(set! OldFG (car (gimp-palette-get-foreground)))
(set! OldBG (car (gimp-palette-get-background)))
(set! theImage inImage)
(set! theHeight (car (gimp-image-height theImage)))
(set! theWidth (car (gimp-image-width theImage)))
(if 
(= 1 (car (gimp-selection-is-empty theImage)))  
(gimp-selection-all theImage)
)

(set! paper-layer (car (gimp-layer-new theImage theWidth theHeight
 RGBA-IMAGE "paper" 100 NORMAL-MODE)))
(gimp-image-add-layer theImage paper-layer 0)

(gimp-drawable-fill paper-layer 3)

(set! rust-layer (car (gimp-layer-new theImage theWidth theHeight
 RGBA-IMAGE "rust" 100 OVERLAY-MODE)))
(gimp-image-add-layer theImage rust-layer 0)

(gimp-drawable-fill rust-layer 3)

(set! spots-layer (car (gimp-layer-new theImage theWidth theHeight
 RGBA-IMAGE "spots" 100 OVERLAY-MODE)))
(gimp-image-add-layer theImage spots-layer 0)

(gimp-drawable-fill spots-layer 3)

(set! noise-layer (car (gimp-layer-new theImage theWidth theHeight
 RGBA-IMAGE "noise" 100 OVERLAY-MODE)))
(gimp-image-add-layer theImage noise-layer 0)

(gimp-drawable-fill noise-layer 3)

(if (= distress TRUE) (script-fu-distress-selection theImage paper-layer 127 8 4 2 TRUE TRUE)

)

(gimp-context-set-foreground p-colour)
(gimp-edit-bucket-fill paper-layer 0 0 100 0 0 0 0)

(gimp-context-set-pattern "Slate")
(gimp-edit-bucket-fill rust-layer 2 0 100 0 0 0 0)


(gimp-context-set-brush "Circle Fuzzy (13)")
(gimp-context-set-foreground '(0 0 0))
(gimp-edit-stroke spots-layer)

(plug-in-plasma 1 theImage noise-layer 1369051446 1)
(gimp-desaturate noise-layer)
(if (= shadow TRUE) (script-fu-drop-shadow theImage noise-layer 8 8 15 '(0 0 0) 80 1))
(if (= text-req TRUE) (add-text t-colour theImage text font-size font))
(gimp-displays-flush) 
)

(script-fu-register "rusted-paper2"
		    "<Image>/Script-Fu/Gimp-talk.com/rusted-paper2..."
		    "speeds up layer flatten, desaturate and convert to greyscale"
		    "Karl Ward"
		    "Karl Ward"
		    "Oct 2005"
		    ""
		    
		    SF-IMAGE      "SF-IMAGE" 0
		    SF-DRAWABLE   "SF-DRAWABLE" 0
		    SF-TOGGLE     "Distress selection" TRUE
		    SF-COLOR      "Paper Colour" '(207 194 162)
		    SF-TOGGLE     "Apply drop-shadow" TRUE
	            SF-TOGGLE     "Text Required" FALSE
		    SF-STRING     "Text (IF NO TEXT LEAVE BLANK)" ""
		    SF-FONT       "Font" ""
		    SF-ADJUSTMENT "Font-size" '(15 10 300 1 10 0 1)
		    SF-COLOR      "TEXT Colour" '(0 0 0)
		    )