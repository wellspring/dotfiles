
;;;Script written by Guillaume de Sercey
;;;gd32@bton.ac.uk

;;;What it does: writes a text following a path
;;;How does it do it:
;;;-creates an empty text layer
;;;-prints the text a letter at a time in a new layer (with the freetype plug-in)
;;;-gets a point along a path with its gradient (gimp-path-get-point-at-dist)
;;;-transform the gradient in a angle (script-fu-path-get-point-at-dist does this together with the previous step)
;;;-rotate the character layer by the angle (rotation around the top-left corner)
;;;-move the character layer at the position of the point on the path
;;;-merge the character layer with the text layer
;;;-repeat until a characters ahave been printed

;;;I use the freetype plug-in because it is the only text function that always align letters
;;;The *catch function is here in case the text is longer than the path
;;;It avoids getting an error from gimp-path-get-point-at-dist
;;;However it will also ignore any other error in the *catch form
;;;In particular, errors caused by an invalid fontname for freetype
;;;I've worked around that by using freetype to create the base text layer (a space character), before the catch

;;;Note: it is best to modify the argument of SF-FILENAME to match a valid font on your system
;;;Or at least a valid directory
;;;Saves a lot of browsing


(define (script-fu-path-get-point-at-dist img position)    ;a variation on gimp-path-get-point-at-dist where the last argument is the angle not the gradient
  (let*
      (
       (delta .1)
       (deltastart .2)
       (point (gimp-path-get-point-at-dist img position))
       (angle (atan (caddr point)))    ;this return an angle between [-pi,+pi] and needs to be adjusted
       (point1 (butlast (gimp-path-get-point-at-dist img (- position deltastart))))
       (point2 (butlast (gimp-path-get-point-at-dist img (+ position deltastart))))           
       )    ; end declare
    (while (equal? point1 point2)
	   (set! deltastart (+ deltastart delta))
	   (set! point1 (butlast (gimp-path-get-point-at-dist img (- position deltastart))))
	   (set! point2 (butlast (gimp-path-get-point-at-dist img (+ position deltastart))))           
	   )
    (if (= (car point1) (car point2))    ;if x coords are equal
	(if (< angle 0)                       ;and angle negative
	    (if (< (cadr point1) (cadr point2))    ;then if point1 is below point2
		(set! angle (+ *pi* angle))    ;add pi to the angle otherwise do nothing
                ) ;end true of angle negative
	    (if (> (cadr point 1) (cadr point2))    ;angle is positive. if point1 is above point2
		(set! angle (+ *pi* angle))    ;add pi to the angle otherwise do nothing
                ) ;end false of angle negative
            ) ;end if angle, end true of x coords equal
	(if (< (car point2) (car point1))
	    (set! angle (+ *pi* angle))
            ) ;end if point, end false of x coords equal
        ) ;end if x coords equal
    (list (car point) (cadr point) angle)
    )
  )

					;the script itself
(define (script-fu-text-along-path img drw text fontfile fontsize spacing antialiasing no-upsidedown)
  (if (= 0 (car (gimp-path-list img)))
      (gimp-message "This script needs a path!")    ;no path exists, end of script
      (begin    ;there is a path let's go
	(let*
	    (
	     (path (car (gimp-path-get-current img)))
	     (textlen (length text))
	     (typea (car (gimp-drawable-type-with-alpha drw)))
	     (text-layer (car (plug-in-freetype RUN-NONINTERACTIVE img 0 fontfile fontsize PIXELS 1 0 0 1 FALSE FALSE FALSE FALSE 0 " ")))
	   <@  (char-layer)
	   (charac "!")    ;a 1 character-long string
	   (position 0)
	   (charcount 0)
	   (charwidth)
	   )    ;end variable declaration
	  (if (= text-layer -1)   
	      (gimp-message "Error with freetype")    ;stop there
	      (begin    ;all is fine, continue    
		(gimp-layer-set-name text-layer text)
		(*catch 'errobj    ;catch any error. The only error that should appear will be caused by gimp-path-get-point-at-dist when it reaches the end of the path
			(while (< charcount textlen)    ;while there is some characters to print
			       (if (= TRUE no-upsidedown)
				   (begin
				     (set! point (gimp-path-get-point-at-dist img position))
				     (set! point (list (car point) (cadr point) (atan (caddr point))))
				     )
				   (set! point (script-fu-path-get-point-at-dist img position))
				   )
			       (aset charac 0 (aref text charcount))
			       (set! char-layer (car (plug-in-freetype RUN-NONINTERACTIVE img 0 fontfile fontsize PIXELS 1 0 0 1 FALSE FALSE antialiasing FALSE 0 charac)))
			       (set! charwidth (car (gimp-drawable-width char-layer)))
			       (gimp-transform-2d char-layer TRUE 0 0 1 1 (caddr point) 0 0)    ;rotation around the top left corner
			       (gimp-layer-set-offsets char-layer (car point) (cadr point))
			       (set! text-layer (gimp-image-merge-down img char-layer EXPAND-AS-NECESSARY))
			       (set! charcount (+ charcount 1))
			       (set! position (+ position spacing charwidth))
			       )    ;end while
                        )    ;end catch
		)    ;end begin
	      )    ;end if
	  )    ;end let
	(gimp-displays-flush)
        )    ;end begin
      )    ;end if
  )    ;end define

(script-fu-register
 "script-fu-text-along-path"
 "<Image>/Script-Fu/Render/Text along path"
 "Prints a text along a path"
 "Guillaume de Sercey"
 "gd32@bton.ac.uk"
 "March 2001"
 ""
 SF-IMAGE             "img"              0
 SF-DRAWABLE     "drw"              0
 SF-STRING            "text"             "The gimp"
 SF-FILENAME        "font"             (string-append (begin (set! path "") (*catch 'errobj (set! path (car (gimp-gimprc-query "freetype-fontpath")))) path) "/arial.ttf")
 SF-ADJUSTMENT    "size"           '(20 1 256 1 10 0 1)
 SF-ADJUSTMENT    "spacing"      '(0 0 256 1 10 0 1)
 SF-TOGGLE            "antialiase"    TRUE
 SF-TOGGLE            "no upside down letters" FALSE
 )




