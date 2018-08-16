; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

(define (script-fu-sg-arrow-stroke-path image)
  (define (dot x0 y0 x1 y1)
    (+ (* x0 x1) (* y0 y1)) )
  (let ((path (car (gimp-image-get-active-vectors image)))
        (drawable (car (gimp-image-get-active-drawable image)))
        (brush (car (gimp-brush-new "temp-brush")))
        (paint-width 0.1)
        (arrow-head #f)
        (arrow-tail #f) )
    (gimp-image-undo-group-start image)
    (gimp-context-push)
    (gimp-context-set-paint-method "gimp-paintbrush")
    (gimp-context-set-brush brush)
    (gimp-context-set-paint-mode NORMAL-MODE)
    (gimp-brush-set-hardness brush 1.0)
    (gimp-brush-set-radius brush (max (car (gimp-image-width image)) 100))
    
    (let* ((orig-sel (car (gimp-selection-save image)))
           (stroke (vector-ref (cadr (gimp-vectors-get-strokes path))
                               (- (car (gimp-vectors-get-strokes path)) 1) )))
      (let* ((points (caddr (gimp-vectors-stroke-get-points path stroke)))
             (x0 (vector-ref points 2))
             (y0 (vector-ref points 3))
             (x1 (vector-ref points 0))
             (y1 (vector-ref points 1)) )
        (unless (and (= x0 x1) (= y0 y1))
          (let* ((edge-length (sqrt (+ (* (- x0 x1) (- x0 x1)) (* (- y0 y1) (- y0 y1)))))
                 (intersect (gimp-vectors-stroke-get-point-at-dist path
                                                                   stroke 
                                                                   edge-length
                                                                   0.2 ))
                 (base-length (sqrt (+ (* (- x0 (car intersect)) (- x0 (car intersect))) 
                                       (* (- y0 (cadr intersect)) (- y0 (cadr intersect))) )))
                 (angle (acos (- (/ (dot (- x1 x0) 
                                         (- y1 y0)
                                         (- (car intersect) x0) 
                                         (- (cadr intersect) y0) )
                                    (* base-length edge-length) ))))
                 (stroke-m (car (gimp-vectors-bezier-stroke-new-moveto path x1 y1))) )
            (unless (< (- (* (- x1 x0) (- (cadr intersect) y0)) 
                      (* (- y1 y0) (- (car intersect) x0)) )
                   0 )
              (set! angle (- angle)) ) 
            (gimp-vectors-bezier-stroke-lineto path stroke-m x0 y0)
            (gimp-vectors-stroke-rotate path stroke-m x0 y0 (* angle 2 (/ 180 *pi*)))
            (let ((points (caddr (gimp-vectors-stroke-get-points path stroke-m))))
              (gimp-vectors-remove-stroke path stroke-m) 
              (gimp-brush-set-radius brush (* (sqrt (+ (* (- x1 (vector-ref points 8))
                                                          (- x1 (vector-ref points 8)) )
                                                       (* (- y1 (vector-ref points 9))
                                                          (- y1 (vector-ref points 9)) )))
                                              paint-width ))
              (set! arrow-head (list (vector x0 y0 x1 y1 (vector-ref points 8) (vector-ref points 9))
                                     (vector x1 y1
                                             (+ (- x0 (vector-ref points 8)) x0) 
                                             (+ (- y0 (vector-ref points 9)) y0)
                                             (+ (- x0 x1) x0) 
                                             (+ (- y0 y1) y0)
                                             (vector-ref points 8) 
                                             (vector-ref points 9) )))))))
      (let* ((points (caddr (gimp-vectors-stroke-get-points path stroke)))
             (num-points (cadr (gimp-vectors-stroke-get-points path stroke)))
             (x0 (vector-ref points (- num-points 4)))
             (y0 (vector-ref points (- num-points 3)))
             (x1 (vector-ref points (- num-points 2)))
             (y1 (vector-ref points (- num-points 1))) )
        (unless (and (= x0 x1) (= y0 y1))
          (let* ((edge-length (sqrt (+ (* (- x0 x1) (- x0 x1)) (* (- y0 y1) (- y0 y1)))))
                 (intersect (gimp-vectors-stroke-get-point-at-dist path
                                                               stroke 
                                                               (- (car (gimp-vectors-stroke-get-length path
                                                                                                       stroke
                                                                                                       0.2 ))
                                                                  edge-length)
                                                               0.2 ))
                 (base-length (sqrt (+ (* (- x0 (car intersect)) (- x0 (car intersect))) 
                                       (* (- y0 (cadr intersect)) (- y0 (cadr intersect))) )))
                 (angle (acos (- (/ (dot (- x1 x0) 
                                         (- y1 y0)
                                         (- (car intersect) x0) 
                                         (- (cadr intersect) y0) )
                                    (* base-length edge-length) ))))
                 (stroke-m (car (gimp-vectors-bezier-stroke-new-moveto path x1 y1))) )
            (unless (< (- (* (- x1 x0) (- (cadr intersect) y0)) 
                          (* (- y1 y0) (- (car intersect) x0)) )
                       0 )
              (set! angle (- angle)) )
            (gimp-vectors-bezier-stroke-lineto path stroke-m x0 y0)
            (gimp-vectors-stroke-rotate path stroke-m x0 y0 (* angle 2 (/ 180 *pi*) ))
            (let ((points (caddr (gimp-vectors-stroke-get-points path stroke-m))))
              (gimp-vectors-remove-stroke path stroke-m) 
              (gimp-brush-set-radius brush (min (car (gimp-brush-get-radius brush))
                                                (* (sqrt (+ (* (- x1 (vector-ref points 8))
                                                          (- x1 (vector-ref points 8)) )
                                                       (* (- y1 (vector-ref points 9))
                                                          (- y1 (vector-ref points 9)) )))
                                                   paint-width )))
              (set! arrow-tail (list (vector x0 y0 x1 y1 (vector-ref points 8) (vector-ref points 9))
                                     (vector x1 y1
                                             (+ (- x0 (vector-ref points 8)) x0) 
                                             (+ (- y0 (vector-ref points 9)) y0)
                                             (+ (- x0 x1) x0) 
                                             (+ (- y0 y1) y0)
                                             (vector-ref points 8) 
                                             (vector-ref points 9) )))))))
      (let ((layer (car (gimp-layer-new image
                                        (car (gimp-image-width image))
                                        (car (gimp-image-height image))
                                        (+ (* (car (gimp-image-base-type image)) 2) 1)
                                        "Arrow"
                                        100
                                        NORMAL-MODE ))) )
        (gimp-drawable-fill layer TRANSPARENT-FILL)
        (if (= (car (gimp-item-is-layer drawable)) 1)
          (begin
            (gimp-image-set-active-layer image drawable)
            (gimp-image-insert-layer image layer 0 -1) )
          (gimp-image-insert-layer image layer 0 0) )
        (gimp-edit-stroke-vectors layer path)
        (when arrow-head
          (gimp-image-select-polygon image
                                     CHANNEL-OP-REPLACE 
                                     8
                                     (cadr arrow-head) )
          (gimp-edit-clear layer)
          (gimp-image-select-polygon image
                                     CHANNEL-OP-REPLACE 
                                     6
                                     (car arrow-head) )
          (gimp-edit-fill layer FOREGROUND-FILL) )
        (when arrow-tail
          (gimp-image-select-polygon image
                                     CHANNEL-OP-REPLACE 
                                     8
                                     (cadr arrow-tail) )
          (gimp-edit-clear layer)
          (gimp-image-select-polygon image
                                     CHANNEL-OP-REPLACE 
                                     6
                                     (car arrow-tail) )
          (gimp-edit-fill layer FOREGROUND-FILL) )
        (when (or (= (car (gimp-item-is-layer-mask drawable)) 1)
                  (= (car (gimp-item-is-channel drawable)) 1) )
          (gimp-image-select-item image CHANNEL-OP-REPLACE layer)
          (gimp-image-remove-layer image layer)
          (gimp-invert drawable)
          (unless (= (car (gimp-item-is-layer-mask drawable)) 1)
            (gimp-image-set-active-channel image drawable) )))
      (gimp-selection-load orig-sel)
      (gimp-image-remove-channel image orig-sel) )
    (gimp-brush-delete brush)
    (gimp-image-undo-group-end image)
    (gimp-context-pop)
    (gimp-displays-flush)
    )
  )

(script-fu-register "script-fu-sg-arrow-stroke-path"
  "Arrow Stroke Path"
  "Stroke path with arrowheads on new layer"
  "Saul Goode"
  "Saul Goode"
  "June 2013"
  "*"
  SF-IMAGE    "Image"    0
  )

(script-fu-menu-register "script-fu-sg-arrow-stroke-path"
 "<Image>/Edit/Stroke"
 )

    
    
  
