(define (createnew maxh maxw imagew imageh)  
(set! newimage (gimp-image-new (* imagew (+ maxw 2)) (* imageh (+ maxh 2)) 0))
(set! newlayer (gimp-layer-new (car newimage) (* imagew (+ maxw 2)) (* imageh (+ maxh 2)) 1 "newlayer" 100 0))
(gimp-image-add-layer (car newimage) (car newlayer) 0)
(gimp-drawable-fill (car newlayer) 3)

(set! framelayer (gimp-layer-new (car newimage) (* imagew (+ maxw 2)) (* imageh (+ maxh 2)) 1 "newlayer" 100 0))
(gimp-image-add-layer (car newimage) (car framelayer) 0)
(gimp-drawable-fill (car framelayer) 3)
(gimp-display-new (car newimage))
)
(define (contact load opt maxh maxw imagew imageh)

(createnew maxh maxw imagew imageh)
(set! a
	(cond 
		(( equal? opt 0 ) ".jpg" )
		(( equal? opt 1 ) ".bmp" )
		(( equal? opt 2 ) ".xcf" )
		(( equal? opt 3 ) ".png" )
		(( equal? opt 4 ) ".gif" )
		(( equal? opt 5 ) ".gbr" )
	))


(let* (
	(filelist (cadr (file-glob (string-append load "\\*" a)  1)))
	(x 1)
	(y 1)
	(xy 1)
)
(while filelist
	(let* (
		(loadfile (car filelist))
		(image (car (gimp-file-load RUN-NONINTERACTIVE loadfile loadfile)))
		)

(set! height (car (gimp-image-height image)))
(set! width (car (gimp-image-width image)))
(set! scale (/ maxw width))
(if
	( < maxh (* height scale))
	(set! scale (/ maxh height))

)


(gimp-image-scale image (* width scale) (* height scale) )
(set! indraw (car (gimp-image-get-active-drawable image)))
(gimp-edit-copy indraw)

(gimp-rect-select (car newimage) (* (- x 1)(+ maxw 2)) (* (- y 1)(+ maxh 2)) (+ maxw 2) (+ maxh 2) 2 0 0)


(set! float (car (gimp-edit-paste (car newlayer) 0)))
(gimp-floating-sel-anchor float)
(gimp-rect-select (car newimage) (* (- x 1)(+ maxw 2)) (* (- y 1)(+ maxh 2)) (+ maxw 2) (+ maxh 2) 2 0 0)
(gimp-edit-bucket-fill (car framelayer) 0 0 100 0 0 0 0)
(gimp-selection-shrink (car newimage) 1)
(gimp-edit-cut (car framelayer))
(set! x (+ x 1))
(set! xy (+ xy 1))

(if (> x imagew)(set! y (+ y 1)))
(if (> x imagew)(set! x 1))

(if (> xy (* imagew imageh)) (createnew maxh maxw imagew imageh))
(if (> xy (* imagew imageh)) (set! y 1))
(if (> xy (* imagew imageh)) (set! xy 1))
(gimp-image-delete image)
(set! filelist (cdr filelist))
(gimp-displays-flush)
)))
)
(script-fu-register 	"contact"
			"<Toolbox>/Xtns/Script-Fu/Gimp-talk.com/contact..."
			"Creates a contact sheet of images in folder"
			"Karl Ward"
			"Karl Ward"
			"JAN 2007"
			""
			SF-DIRNAME    "Load from" ""
			SF-OPTION     "File Type"'("jpg" "bmp""xcf""png""gif""gbr")
			SF-ADJUSTMENT	"Max Height" '(100 1 400 1 2 0 1)
			SF-ADJUSTMENT	"Max Width" '(100 1 400 1 2 0 1)
			SF-ADJUSTMENT	"images Wide" '(5 1 100 1 2 0 1)
			SF-ADJUSTMENT	"images high" '(5 1 100 1 2 0 1)
			
)
				
