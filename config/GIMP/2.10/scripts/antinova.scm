;;; anti-nova.scm -*-scheme-*-
;;; Version 0.6

(define (script-fu-anti-nova img drw num-of-lines offset variation
corn ownlen spokelen xweg yweg)
  (let* ((*points* (cons-array (* 3 2) 'double))
	 (modulo fmod)			; in R4RS way
	 (pi/2 (/ *pi* 2))
	 (2pi (* 2 *pi*))
	 (rad/deg (/ 2pi 360))
	 (variation/2 (/ variation 2))
	 (drw-width (car (gimp-drawable-width drw)))
	 (drw-height (car (gimp-drawable-height drw)))
	 (drw-offsets (gimp-drawable-offsets drw))
	 (old-selection (car (gimp-selection-save img)))
	 (radius (max drw-height drw-width))
	 (index 0)
	 (dir-deg/line (/ 360 num-of-lines)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,;;;;;;;;;

  (define (draw-vector beg-x beg-y direction)

      (define (set-point! index x y)
	      (aset *points* (* 2 index) x)
	      (aset *points* (+ (* 2 index) 1) y))
      (define (deg->rad rad)
	      (* (modulo rad 360) rad/deg))
   
      (define (set-marginal-point beg-x beg-y direction)
	      (let 
	         ((dir (deg->rad direction)))
         (set-point! 1 
            (+ beg-x (* (cos dir) offset) (* corn (cos (+ dir pi/2))))
            (+ beg-y (* (sin dir) offset) (* corn (sin (+ dir pi/2)))))
         (set-point! 2 
            (+ beg-x (* (cos dir) offset) (* corn  (cos (- dir pi/2))))
            (+ beg-y (* (sin dir) offset) (* corn (sin (- dir pi/2)))))
      ))

      (let* 
         ((dir0 (deg->rad direction)))

         (if (= ownlen TRUE) 
            (set! limitx (+ (* (+ spokelen offset) (cos dir0)) beg-x ))
            (set! limitx (+ (* (/ drw-width 2) (cos dir0)) (/ drw-width 2) )))
         (if (= ownlen TRUE) 
            (set! limity (+ (* (+ spokelen offset) (sin dir0)) beg-y ))
            (set! limity (+ (* (/ drw-height 2) (sin dir0)) (/ drw-height 2))))

         (set-point! 0  limitx limity)

         (set-marginal-point beg-x beg-y direction)
      	(gimp-free-select img 6 *points* ADD TRUE FALSE	0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    (gimp-undo-push-group-start img)
    (gimp-selection-none img)
    (srand (realtime))

    (set! middle-x (+ xweg (nth 0 drw-offsets) (/ drw-width 2)))
    (set! middle-y (+ yweg (nth 1 drw-offsets) (/ drw-height 2)))
    (while (< index num-of-lines)
      (draw-vector middle-x middle-y
		   (* index dir-deg/line))                      
      (set! index (+ index 1)))

    (gimp-bucket-fill img drw FG-BUCKET-FILL NORMAL 100 0 FALSE 0 0)
    (gimp-selection-load img old-selection)
    (gimp-image-remove-channel img old-selection)
    (gimp-undo-push-group-end img)
    (gimp-displays-flush)))

(script-fu-register
 "script-fu-anti-nova"
 "<Image>/Script-Fu/Render/Anti Nova..."
 "Line Nova. Draw lines with Foreground color from the center of image to the edges. 1st undo cancels bucket-fill. 2nd undo gets orignal selection."
 "Stefan Stiasny <sc@oeh.net>"
 "Stefan Stiasny"
 "1997"
 "RGB*, INDEXED*, GRAY*"
 SF-IMAGE "Image to use" 0
 SF-DRAWABLE "Drawable to draw line" 0
 SF-VALUE "Number of lines" "20"
 SF-VALUE "Offset radius" "60"
 SF-VALUE "- randomness" "30"
 SF-VALUE "corn" "8"
 SF-TOGGLE "ownlen" TRUE
 SF-VALUE "spokelen" "50"
 SF-VALUE "middle point x" "0"
 SF-VALUE "middle point y" "0"
)

