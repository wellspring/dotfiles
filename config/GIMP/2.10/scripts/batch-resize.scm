(define (script-fu-batch-resize globexp newx newy)
  (define (resize-img n f)
    (let* ((fname (car f))
          (img (car (gimp-file-load 1 fname fname))))
      (gimp-image-undo-disable img)
      (gimp-image-scale img newx newy 0 0)
      (gimp-file-save 1 img (car (gimp-image-get-active-drawable img)) fname fname)
      (gimp-image-delete img)
    )
    (if (= n 1) 1 (resize-img (- n 1) (cdr f)))
  )
  (set! files (file-glob globexp 0))
  (resize-img (car files) (car (cdr files)))
)

; English version of original script http://www.gimpusers.de/dl/batch-resize-2.2.scm
; R.Ostertag

(script-fu-register "script-fu-batch-resize"
		    "<Toolbox>/Xtns/Script-Fu/Batch/Resize..."
		    "Multiple images resize batch process"
		    "Richard Hirner"
		    "2006, Richard Hirner"
		    "Sep 7, 2006"
		    ""
		    SF-STRING "Files" "PATH/*.jpg"
		    SF-VALUE "Width" "1280"
		    SF-VALUE "Height" "1024")
