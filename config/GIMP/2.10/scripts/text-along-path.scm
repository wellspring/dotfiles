;Script written by Guillaume de Sercey
;gd32@bton.ac.uk

;What it does: writes a text following a path
;How does it do it:
;-creates an empty text layer
;-prints the text a letter at a time in a new layer
;-gets a point along a path with its gradient (gimp-path-get-point-at-dist)
;-transform the gradient in a angle (path-get-point-at-dist does this together with the previous step)
;-rotate the character layer by the angle (rotation around the top-left corner)
;-move the character layer at the position of the point on the path
;-merge the character layer with the text layer
;-repeat until all characters have been printed

;obsolete: I use the freetype plug-in because it is the only text function that always align letters
;obsolete: The *catch function is here in case the text is longer than the path
;obsolete: It avoids getting an error from gimp-path-get-point-at-dist
;obsolete: However it will also ignore any other error in the *catch form
;obsolete: In particular, errors caused by an invalid fontname for freetype
;obsolete: I've worked around that by using freetype to create the base text layer (a space character), before the catch.

;obsolete: Note: if the freetype plug-in is properly configured its default font directory will be shown by the script.
;obsolete: Otherwise it is best to change the default value of SF-FILENAME to point to something valid.
;obsolete: Saves a lot of browsing.

; v2.0
; tidied up the script, changed the name of the function.
; greatly improved the behaviour for sudden change of gradient
; by changing rotation centre and translation offset.
; got rid of the 'no upside down letters' argument. Didn't work anyway.

; v3.0pre
; bug 138754: gimp-path-get-point-at-dist is not implemented
; can't do anything without it.

; v3.0
; updated for gimp 2.0x
; no longer use the freetype plugin as gimp default text tool now aligns text layers properly.

; changed starting position from 0 to 1 as (gimp-path-get-point-at-dist img 0) returns invalid values.
; due to bug 161274 the gradient is inverted. Corrected for this
; gimp-path-get-point-at-dist no longer throws an error (errobj) for distances too long, instead it returns '(0 0 0)
; modified path-get-point-at-dist to throw a custom error when two consecutive points returns '(0 0 0)

; v3.1
; due to bug 161272, v3.0 failed for strings containing spaces (and maybe other characters)
; special case made for spaces

; v3.2
; bug 161274 now resolved, modified path-get-point-at-dist accordingly
; bug 161272 now resolved (sort of, gimp-text-fontname does not return a pdb error if the glyph
; does not draw anything. However it does not create a layer either.


(define (script-fu-gds-text-along-path img drw text fontname fontsize spacing antialiasing)
    (define (path-get-point-at-dist img position)    ;a variation on gimp-path-get-point-at-dist where the last argument is the angle not the gradient
        (let*
            (
                (delta .1)
                (deltastart .2)
                (point (gimp-path-get-point-at-dist img position))
                (angle (atan (caddr point)))    ;this return an angle between [-pi/2,+pi/2] and needs to be adjusted
                (point1 (butlast (gimp-path-get-point-at-dist img (- position deltastart))))
                (point2 (butlast (gimp-path-get-point-at-dist img (+ position deltastart))))
            )    ; end declare
            ; find 2 distinct points on each side of point
            (if (and (equal? point '(0 0 0)) (equal? point2 '(0 0))) (*throw 'endpath))     ;test end of path
            (while (equal? point1 point2)
                (set! deltastart (+ deltastart delta))
                (set! point1 (butlast (gimp-path-get-point-at-dist img (- position deltastart))))
                (set! point2 (butlast (gimp-path-get-point-at-dist img (+ position deltastart))))
            )
            ; adjust angle for quadrant
            (if (= (car point1) (car point2))    ;if x coords are equal
            	(if (< angle 0)					 ;and angle negative
            		(if (< (cadr point1) (cadr point2)) (set! angle (+ angle *pi*)))
            		(if (> (cadr point1) (cadr point2)) (set! angle (+ angle *pi*)))
        		)
        		(if (< (car point2) (car point1)) (set! angle (+ angle *pi*)))
             )
            (list (car point) (cadr point) angle)
        )
    )

    ; the script itself
    (if (= 0 (car (gimp-path-list img)))
        (gimp-message "This script needs a path!")    ;no path exists, end of script
        (begin    ;there is a path let's go
            (let*
                (
                    (path (car (gimp-path-get-current img)))
                    (textlen (length text))
                    (typea (car (gimp-drawable-type-with-alpha drw)))
                    (text-layer (car (gimp-text-fontname img -1 0 0 text -1 antialiasing fontsize PIXELS fontname)))    ; will be resized later by merge-down
                    (hh (/ (car (gimp-drawable-height text-layer)) -2)) ; negative half-height of text
                    (char-layer)
                    (charac "!")    ;a 1 character-long string
                    (position 1)    ;(gimp-path-get-point-at-dist img 0) returns invalid values
                    (charcount 0)
                    (charwidth 0)
                )    ;end variable declaration
                (begin    ;all is fine, continue
                    (gimp-drawable-fill text-layer TRANS-IMAGE-FILL)
                    (gimp-layer-set-name text-layer text)
                    (*catch 'endpath
                        (while (< charcount textlen)    ;while there is some characters to print
                            (set! point (path-get-point-at-dist img position))
                            (aset charac 0 (aref text charcount))
                                (set! charwidth (car (gimp-text-get-extents-fontname charac fontsize PIXELS fontname)))
                                (set! char-layer (car (gimp-text-fontname img -1 0 0 charac -1 antialiasing fontsize PIXELS fontname)))
                                (if (> char-layer -1)
                                    (begin
                                        (set! charwidth (car (gimp-drawable-width char-layer)))
                                        (gimp-layer-set-offsets char-layer 0 hh)
                                        (gimp-transform-2d char-layer TRUE 0 0 1 1 (caddr point) (car point) (cadr point))    ;rotation around the top left corner
                                        (set! text-layer (gimp-image-merge-down img char-layer EXPAND-AS-NECESSARY))
                                    )
                                )
                            (set! charcount (+ charcount 1))
                            (set! position (+ position spacing charwidth))
                        )    ;end while
                    )    ;end catch
                )    ;end begin
            )    ;end let
            (gimp-displays-flush)
        )    ;end begin
    )    ;end if
)    ;end define

(script-fu-register
    "script-fu-gds-text-along-path"
    "<Image>/Script-Fu/Render/Text along path"
    "Prints a text along a path"
    "Guillaume de Sercey"
    "gd32@bton.ac.uk"
    "December 2004"
    "*"
    SF-IMAGE        "img"              0
    SF-DRAWABLE     "drw"              0
    SF-STRING       "text"             "Portez ce vieux whisky au juge blond qui fume"
    SF-FONT         "font"             "-*-Verdana-medium-r-normal-*-*-*-*-*-*-*-*-*"
    SF-ADJUSTMENT   "size"             '(20 1 256 1 10 0 1)
    SF-ADJUSTMENT   "spacing"          '(0 0 256 1 10 0 1)
    SF-TOGGLE       "antialiase"       TRUE
)

