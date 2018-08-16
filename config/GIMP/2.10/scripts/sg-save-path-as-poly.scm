; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

(define (script-fu-sg-save-path-as-poly image 
                                        use-paths 
                                        filename 
                                        alt-name 
                                        border-size 
                                        interpolate 
                                        precision )
  (gimp-image-undo-freeze image)
  (let ((paths (case use-paths
                 ((0) (gimp-image-get-active-vectors image) )
                 ((1) (plug-in-sel2path RUN-NONINTERACTIVE image 0)
                      (gimp-image-get-active-vectors image) )
                 ((2) (vector->list (cadr (gimp-image-get-vectors image))) )
                 ((3) (let loop ((paths (vector->list (cadr (gimp-image-get-vectors image))))
                                 (visibles '()) )
                        (if (null? paths)
                          (reverse visibles)
                          (loop (cdr paths)
                                (if (zero? (car (gimp-vectors-get-visible (car paths))))
                                  visibles
                                  (cons (car paths) visibles) )))))
                 ((4) (let loop ((paths (vector->list (cadr (gimp-image-get-vectors image))))
                                 (linkeds '()) )
                        (if (null? paths)
                          (reverse linkeds)
                          (loop (cdr paths)
                                (if (zero? (car (gimp-vectors-get-linked (car paths))))
                                  linkeds
                                  (cons (car paths) linkeds) ))))))))
    (unless (zero? interpolate)
      (set! interpolate precision) )

    (with-output-to-file filename (lambda ()
      (display "<img src=") (write (car (gimp-image-get-name image)))
        (display " width=")   (write (number->string (car (gimp-image-width image))))
        (display " height=")  (write (number->string (car (gimp-image-height image))))
        (display " border=")  (write (number->string border-size))
        (display " usemap=")  (write "#map")
        (display " />")
        (newline) (newline)
      (display "<map name=") (write "map") (display ">")
        (newline)
        (let loop-path ((paths paths))
          (unless (null? paths)
            (display "<area shape=\"poly\" coords=\"")
            (let loop-stroke ((strokes (vector->list (cadr (gimp-vectors-get-strokes (car paths))))))
              (unless (null? strokes)
                (let ((points (if (zero? interpolate)
                                (let loop ((points (vector->list (caddr 
                                                         (gimp-vectors-stroke-get-points (car paths) 
                                                                                         (car strokes) ))))
                                           (anchors '()) )
                                  (if (null? points)
                                    (reverse anchors)
                                    (loop (cddr (cddddr points))
                                          (cons (cadr points) (cons (car points) anchors)) )))
                                (vector->list (cadr (gimp-vectors-stroke-interpolate (car paths) 
                                                                                     (car strokes) 
                                                                                     interpolate ))))))
                  (set! points (map (lambda (x) 
                                            (inexact->exact (truncate (+ 0.5 x))))
                                    points ))
                  (display (car points))
                  (let loop ((points (cdr points))
                             (line-length 30) )
                    (unless (null? points)
                      (display ",")
                      (when (> line-length 75)
                        (newline) 
                        (display "      ") )
                      (display (car points))
                      (loop (cdr points)
                            (if (> line-length 75)
                              0
                              (+ line-length (string-length (number->string (car points))) 1) )))))))
            (display "\" ") 
            (display "nohref=\"nohref\" ")
            (when (not (zero? alt-name))
              (display "alt=")
              (write (car (gimp-vectors-get-name (car paths)))) )
            (display "/>") 
            (newline)
            (loop-path (cdr paths)) ))
        (display "</map>") ))
    (if (= use-paths 1)
      (gimp-image-remove-vectors image (car paths)) )
    )
  (gimp-image-undo-thaw image)
  )

(define (script-fu-sg-save-path-as-poly-context-menu image 
                                                     path
                                                     use-paths 
                                                     filename 
                                                     alt-name 
                                                     border-size 
                                                     interpolate 
                                                     precision )
  (script-fu-sg-save-path-as-poly image use-paths filename alt-name border-size interpolate precision) )
  

(script-fu-register "script-fu-sg-save-path-as-poly"
 "Save path(s) as HTML poly map..."
 "Save paths as a poly readable by Image Map"
 "Saul Goode"
 "Saul Goode"
 "Dec 2013"
 "*"
 SF-IMAGE    "Image"    0
 SF-OPTION "Source" '("Active Path" "Selection" "All Paths" "All Visible" "All Linked")
 SF-STRING "Map file" "Untitled.map"
 SF-TOGGLE "Use Path Name as ALT" TRUE
 SF-ADJUSTMENT "Border" '( 0 0 20 1 4 0 1 )
 SF-TOGGLE "Interpolate" FALSE
 SF-ADJUSTMENT "Precision" '( 3 1 100 1 10 0 1 )
 )

(script-fu-menu-register "script-fu-sg-save-path-as-poly"
 "<Image>/Filters/Web"
 )

(script-fu-register "script-fu-sg-save-path-as-poly-context-menu"
 "Save as HTML poly map..."
 "Save path as a poly readable by Image Map"
 "Saul Goode"
 "Saul Goode"
 "Dec 2013"
 "*"
 SF-IMAGE    "Image"    0
 SF-VECTORS "Path" 0
 SF-OPTION "Source" '("Active Path" "Selection" "All Paths" "All Visible" "All Linked")
 SF-STRING "Map file" "Untitled.map"
 SF-TOGGLE "Use Path Name as ALT" TRUE
 SF-ADJUSTMENT "Border" '( 0 0 20 1 4 0 1 )
 SF-TOGGLE "Interpolate" FALSE
 SF-ADJUSTMENT "Precision" '( 3 1 100 1 10 0 1 )
 )

(script-fu-menu-register "script-fu-sg-save-path-as-poly-context-menu"
 "<Vectors>"
 )
