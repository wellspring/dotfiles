(define (sebo-gamma t)
	(set! res 0)
	(set! step (/ t 100))
	(set! courent 1)
	(while (< courent 100)
		(set! res (+ res (/ step (- 1 (log (* courent step))))))
		(set! courent (+ courent 1))
	)
	res
)

(define (sebo-snow image drawable flakes flake-size level-begin level-end wind-direction wind-direction-variance)
	(gimp-image-undo-group-start image)
	(let*
		(
			(flake-image (car (gimp-file-load 1 "C:\\Program Files\\Gimp-2.0\\share\\gimp\\2.0\\scripts\\SnowFlakes.xcf.bz2" "SnowFlakes.xcf.bz2")))
		)
		(let*
			(
				(image-width (car (gimp-image-width image)))
				(image-height (car (gimp-image-height image)))
				(flake-layers (cadr (gimp-image-get-layers flake-image)))
			)
			(set! flakes-to-draw (/ (* flakes (- (sebo-gamma (/ level-end 100)) (sebo-gamma (/ level-begin 100)))) 0.590679))
			(set! flake-layer (car (gimp-layer-new image (car (gimp-image-width image)) (car (gimp-image-height image)) 1 "Snow" 100 0)))
			(gimp-image-add-layer image flake-layer -1)
			(while (> flakes-to-draw 0)
				(let*
					(
						(scale (/ flake-size (- 1 (log (/ (+ (* 327.67 level-begin) (rand (* 327.67 (- level-end level-begin)))) 32767)))));max/(1-log(rand))
						(angle-x (- (rand 360) 180))
						(angle-y (- (rand 360) 180))
						(angle-z (- (rand 360) 180))
						(flake (car (gimp-layer-new-from-drawable (aref flake-layers (rand (length flake-layers))) image)))
					)
					(gimp-image-add-layer image flake -1)
					(gimp-layer-set-mode flake 7)
					;(sebo-rotate-3D 0 image flake angle-x angle-y angle-z 3 size)
					(let*
						(
							(x (/ (- (nth 3 (gimp-drawable-mask-bounds flake)) (nth 1 (gimp-drawable-mask-bounds flake))) 2));wspolzendne LR wzgledem srodka
							(y (/ (- (nth 4 (gimp-drawable-mask-bounds flake)) (nth 2 (gimp-drawable-mask-bounds flake))) 2))
							(center-x (+ (car (gimp-drawable-offsets flake)) (/ (+ (nth 3 (gimp-drawable-mask-bounds flake)) (nth 1 (gimp-drawable-mask-bounds flake))) 2)));wspolzende srodka
							(center-y (+ (cadr (gimp-drawable-offsets flake)) (/ (+ (nth 4 (gimp-drawable-mask-bounds flake)) (nth 2 (gimp-drawable-mask-bounds flake))) 2)))
							(ekran (* 3 (max x y)))
						)
						(let*
							(
								(x0 (+ center-x (/ (* -1 scale ekran x (cos (/ (* angle-x *pi*) 180))) (* 100 (+ ekran (* -1 x (sin (/ (* angle-x *pi*) 180))) (* -1 y (sin (/ (* angle-y *pi*) 180))))))));UL -ekran*x*cos(angle-x)/(distance*max(x,y)-x*sin(angle-x)-y*sin(angle-y))
								(y0 (+ center-y (/ (* -1 scale ekran y (cos (/ (* angle-y *pi*) 180))) (* 100 (+ ekran (* -1 x (sin (/ (* angle-x *pi*) 180))) (* -1 y (sin (/ (* angle-y *pi*) 180))))))));UL -ekran*y*cos(angle-y)/(distance*max(x,y)-x*sin(angle-x)-y*sin(angle-y))
								(x1 (+ center-x (/ (* scale ekran x (cos (/ (* angle-x *pi*) 180))) (* 100 (+ ekran (* x (sin (/ (* angle-x *pi*) 180))) (* -1 y (sin (/ (* angle-y *pi*) 180))))))));UR ekran*x*cos(angle-x)/(distance*max(x,y)+x*sin(angle-x)-y*sin(angle-y))
								(y1 (+ center-y (/ (* -1 scale ekran y (cos (/ (* angle-y *pi*) 180))) (* 100 (+ ekran (* x (sin (/ (* angle-x *pi*) 180))) (* -1 y (sin (/ (* angle-y *pi*) 180))))))));UR -ekran*y*cos(angle-y)/(distance*max(x,y)+x*sin(angle-x)-y*sin(angle-y))
								(x2 (+ center-x (/ (* -1 scale ekran x (cos (/ (* angle-x *pi*) 180))) (* 100 (+ ekran (* -1 x (sin (/ (* angle-x *pi*) 180))) (* y (sin (/ (* angle-y *pi*) 180))))))));LL -ekran*x*cos(angle-x)/(distance*max(x,y)-x*sin(angle-x)+y*sin(angle-y))
								(y2 (+ center-y (/ (* scale ekran y (cos (/ (* angle-y *pi*) 180))) (* 100 (+ ekran (* -1 x (sin (/ (* angle-x *pi*) 180))) (* y (sin (/ (* angle-y *pi*) 180))))))));LL ekran*y*cos(angle-y)/(distance*max(x,y)-x*sin(angle-x)+y*sin(angle-y))
								(x3 (+ center-x (/ (* scale ekran x (cos (/ (* angle-x *pi*) 180))) (* 100 (+ ekran (* x (sin (/ (* angle-x *pi*) 180))) (* y (sin (/ (* angle-y *pi*) 180))))))));LR ekran*x*cos(angle-x)/(distance*max(x,y)+x*sin(angle-x)+y*sin(angle-y))
								(y3 (+ center-y (/ (* scale ekran y (cos (/ (* angle-y *pi*) 180))) (* 100 (+ ekran (* x (sin (/ (* angle-x *pi*) 180))) (* y (sin (/ (* angle-y *pi*) 180))))))));LR ekran*y*cos(angle-y)/(distance*max(x,y)+x*sin(angle-x)+y*sin(angle-y))
							)
							(gimp-drawable-transform-perspective flake x0 y0 x1 y1 x2 y2 x3 y3 0 1 TRUE 3 TRUE)
							(gimp-drawable-transform-rotate flake (/ (* angle-z *pi*) 180) TRUE 0 0 0 1 TRUE 3 TRUE)
							;(set! size (sqrt (+ (pow (- x2 x0) 2) (pow (- y2 y0) 2) (pow (- x3 x1) 2) (pow (- y3 y1) 2))))
							;(if (>= (* 2 size) 1)
							;	(begin
							;		(set! blur-angle (+ wind-direction (/ (* wind-direction-variance (sqrt (* -2 (log (/ (rand 32767) 32767)))) (sin (* 2 *pi* (/ (rand 32767) 32767)))) 100)))
							;		(while (>= blur-angle 360)
							;			(set! blur-angle (- blur-angle 360))
							;		)
							;		(while (< blur-angle 0)
							;			(set! blur-angle (+ blur-angle 360))
							;		)
							;		(plug-in-mblur 1 image flake 0 (min 256 (* 2 size)) blur-angle 0 0)
							;(gimp-rect-select image x0 y0 (* 2 size) 2 2 0 0)
							;(gimp-edit-bucket-fill flake 0 0 100 0 0 0 0)
							;(gimp-selection-none image)
							;	)
							;)
						)
					)
					(gimp-layer-set-offsets flake (- (rand image-width) (/ (car (gimp-drawable-width flake)) 2)) (- (rand image-height) (/ (car (gimp-drawable-height flake)) 2)))
					;(set! flake-layer (car (gimp-image-merge-down image flake 1)))
				)
				(set! flakes-to-draw (- flakes-to-draw 1))
				(gc)
			)
		)
		(gimp-image-delete flake-image)
	)
	(set! flake-layer (car (gimp-image-merge-visible-layers image 1)))
	(gimp-image-undo-group-end image)
	(gimp-displays-flush)
	(gc)
)
(script-fu-register "sebo-snow"
        _"_Snow..."
        "Generates 3D realistic snow."
        "Sebastian Sawicki <Sebo@student.pwr.wroc.pl>"
        "Sebastian Sawicki <Sebo@student.pwr.wroc.pl>"
        "13/12/2006"
        "RGB* GRAY*"
        SF-IMAGE _"Image" 0
        SF-DRAWABLE _"Drawable" 0
        SF-ADJUSTMENT _"Flakes"  '(100 1 8192 1 16 0 1)
        SF-ADJUSTMENT _"Max flake scale"  '(2.5 0.1 100 0.1 1 1 1)
        SF-ADJUSTMENT _"Flat level begin" '(0 0 100 1 16 1 1)
	    SF-ADJUSTMENT _"Flat level end" '(100 0 100 1 16 1 1)
        SF-ADJUSTMENT _"Wind direction angle" '(60 -180 180 0.1 1 1 0)
	    SF-ADJUSTMENT _"Wind direction variance" '(30 0 90 0.1 1 1 1)
)
(script-fu-menu-register "sebo-snow"
 _"<Image>/Script-Fu/Render")