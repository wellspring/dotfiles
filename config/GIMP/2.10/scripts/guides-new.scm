;; -*-scheme-*-

;; Alan Horkan 2004.  Public Domain.  
;; so long as remove this block of comments from your script
;; feel free to use it for whatever you like.  

(define (script-fu-guide-new image
			     drawable
			     direction
			     position)
  (let* ((width (car (gimp-image-width image)))
	 (height (car (gimp-image-height image))))
    (gimp-image-undo-group-start image)

    (if (= direction 0) 
	;; check position is inside the image boundaries
	(if (<= position height) (gimp-image-add-hguide image position))
	(if (<= position width) (gimp-image-add-vguide image position)))

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)))
    
(script-fu-register "script-fu-guide-new" 
		    _"New _Guide..." 
		    "Add a single Line Guide with the specified postion and orientation. Postion is specified in Pixels (px)."
		    "Alan Horkan"
		    "Alan Horkan, 2004.  Public Domain."
		    "2004-04-02"
		    ""
		    SF-IMAGE      "Image"      0 
		    SF-DRAWABLE   "Drawable"   0
		    SF-OPTION     _"Direction" '(_"Horizontal" 
						 _"Vertical")
		    SF-ADJUSTMENT "Position"   '(0 0 262144 1 10 0 1))
    
(script-fu-menu-register "script-fu-guide-new" 
			 "<Image>/Image/Guides")
