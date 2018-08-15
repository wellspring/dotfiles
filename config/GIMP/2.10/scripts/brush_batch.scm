(define (brush-batch load opt name filename spacing location)
(set! a
	(cond 
		(( equal? opt 0 ) ".jpg" )
		(( equal? opt 1 ) ".bmp" )
		(( equal? opt 2 ) ".xcf" )
		(( equal? opt 3 ) ".png" )
		(( equal? opt 4 ) ".gif" )
	))
(let* (
	(filelist (cadr (file-glob (string-append load "\\*" a)  1)))
	(s 1)
	)
(while filelist
	(let* (
		(loadfile (car filelist))
		(image (car (gimp-file-load RUN-NONINTERACTIVE loadfile loadfile)))
		)


(gimp-image-flatten image)
(set! drawable (gimp-image-get-active-drawable image))
(if (= 1 (car (gimp-selection-is-empty image)))
(gimp-selection-all image))
(gimp-displays-flush)
(gimp-edit-copy (car drawable) )
(set! selection-bounds (gimp-selection-bounds image))
(set! sx1 (cadr selection-bounds))
(set! sy1 (caddr selection-bounds))
(set! sx2 (cadr (cddr selection-bounds)))
(set! sy2 (caddr (cddr selection-bounds)))
(gimp-image-delete image)
(set! swidth  (- sx2 sx1))
(set! sheight (- sy2 sy1))
(set! newimage (gimp-image-new swidth sheight 0))
(set! newlayer (gimp-layer-new (car newimage) swidth sheight 1 "newlayer" 100 0))
(gimp-image-add-layer (car newimage) (car newlayer) 0)
(gimp-drawable-fill (car newlayer) 3)
(gimp-edit-paste (car newlayer) 0 )
(gimp-image-flatten (car newimage))
(set! active(gimp-image-get-active-drawable (car newimage)))
(gimp-desaturate (car active))
(gimp-image-convert-grayscale (car newimage))
(gimp-displays-flush)
(gimp-selection-all (car newimage))
(set! filename2 (string-append location "/" filename (string-append (number->string s))".gbr"
))
(file-gbr-save 1 (car newimage) (car active) filename2 (string-append name (number->string s)) spacing (string-append name (number->string s))))
(set! s (+ s 1))
(gimp-image-delete (car newimage))
(set! filelist (cdr filelist))))
)
(script-fu-register "brush-batch"
		    "<Toolbox>/Xtns/Script-Fu/Gimp-talk.com/Brush-batch..."
		    "turns a folder of files into brush's works with jpg, bmp, xcf, png and gif"
		    "Karl Ward"
		    "Karl Ward"
		    "April 2006"
		    ""
		    
			SF-DIRNAME    "Load from" ""
			SF-OPTION     "File Type"'("jpg" "bmp""xcf""png""gif")

		    	SF-STRING     "Brush Name" "name"
		    	SF-STRING     "File Name" "filename"
		    	SF-ADJUSTMENT "spacing"         '(25 0 1000 1 1 1 0)
		    	SF-DIRNAME    "SAVE TO FOLDER" "")
