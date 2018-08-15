; Basic script to hatch areas.
; The script creates two menu entries
; Toolbox->Xtns->Script-Fu->Patterns->Hatches to create a hatched pattern
; Image->Script-Fu->Render->Hatches to fill the selection (or full layer) on an existing image
; written by gd32@bton.ac.uk
; standard gpl licence

; The script uses gimp-free-select to create the hatched pattern. The pattern is drawn onto
; a channel that contain the original selection. This allow to compute the intersection of the orignal
; selection with the sum of the hatches selection.
; version 1.0
; version 2.0: updated for gimp 2.x (added gimp-image-add-channel call which wasn't needed before)

(define (script-fu-gds-hatch img drw angle spacing thickness)
    (define (projx dist angle) (if (= 0 (sin angle)) -1 (/ dist (sin angle))))      ; project a distance on the x axis
    (define (projy dist angle) (if (= 0 (cos angle)) -1 (/ dist (cos angle))))      ; project a distance on the y axis
    (gimp-undo-push-group-start img)
    (let*
        (
            (width (car (gimp-drawable-width drw)))
            (height (car (gimp-drawable-height drw)))
            (old-selection (car (gimp-selection-save img)))                        ; selection backup
            (selection (car (gimp-channel-copy old-selection)))                    ; channel to create hatch pattern
            (old-fg (car (gimp-palette-get-foreground)))                           ; foreground backup
            (angle-rad (abs (/ (* angle *pi*) 180)))                               ; convert degrees into radians
            (spx (projx spacing angle-rad))
            (spy (projy spacing angle-rad))
            (thx (projx (/ thickness 2) angle-rad))
            (thy (projy (/ thickness 2) angle-rad))
            (x (/ spx 2))
            (y (/ spy 2))
            (pt-array (cons-array 8 'double))
        )    ;end variable declaration
        (if (= (car (gimp-selection-is-empty img)) 1) (gimp-drawable-fill selection WHITE-IMAGE-FILL))    ; no selection, makes channel white (full selection)
        (gimp-selection-none img)
        (gimp-palette-set-foreground '(0 0 0))                                     ; black colour
        (if (= -90 angle) (set! angle 90))                                         ; -90 deg -> 90 deg
        (cond
            ((= angle 0) (begin                                                    ; horizontal hatches
                (while (< y height)                                                ; move along the y axis
                    (aset pt-array 0 0)
                    (aset pt-array 1 (- y thy))
                    (aset pt-array 2 0)
                    (aset pt-array 3 (+ y thy))
                    (aset pt-array 4 width)
                    (aset pt-array 5 (+ y thy))
                    (aset pt-array 6 width)
                    (aset pt-array 7 (- y thy))
                    (gimp-free-select img 8 pt-array ADD TRUE 0 0)
                    (set! y (+ y spacing))
                )    ; end while
            ))    ; end begin, end horizontal lines
            (( = angle 90) (begin                                                  ; vertical hatches
                (while (< x width)                                                 ; move along the x axis
                    (aset pt-array 0 (+ x thx))
                    (aset pt-array 1 0)
                    (aset pt-array 2 (- x thx))
                    (aset pt-array 3 0)
                    (aset pt-array  4 (- x thx))
                    (aset pt-array 5 height)
                    (aset pt-array 6 (+ x thx))
                    (aset pt-array 7 height)
                    (gimp-free-select img 8 pt-array ADD TRUE 0 0)
                    (set! x (+ x spacing))
                )    ; end while
            ))    ; end begin, end vertical lines
            (( > angle 0) (begin                                                  ; upward right hatches
                (while (< y height)                                               ; move along the y axis
                    (aset pt-array 0 0)
                    (aset pt-array 1 (- y thy))
                    (aset pt-array 2 0)
                    (aset pt-array 3 (+ y thy))
                    (aset pt-array 4 (+ (/ y (tan angle-rad)) thx))               ; intersection with the x axis
                    (aset pt-array 5 0)
                    (aset pt-array 6 (- (/ y (tan angle-rad)) thx))
                    (aset pt-array 7 0)
                    (gimp-free-select img 8 pt-array ADD TRUE 0 0)
                    (set! y (+ y spy))
                )    ; end while
                (set! x (/ (- y height) (tan angle-rad)))
                (while (< x width)                                                ; move along the x axis
                    (aset pt-array 0 (- x thx))
                    (aset pt-array 1 height)
                    (aset pt-array 2 (+ x thx))
                    (aset pt-array 3 height)
                    (aset pt-array 4 width)
                    (aset pt-array 5 (+ (- height (* (- width x) (tan angle-rad))) thy))    ; intersection with the y axis
                    (aset pt-array 6 width)
                    (aset pt-array 7 (- (- height (* (- width x) (tan angle-rad))) thy))
                    (gimp-free-select img 8 pt-array ADD TRUE 0 0)
                    (set! x (+ x spx))
                )    ; end while
            ))    ; end begin, end upward right hatches
            ((< angle 0) (begin                                                  ; downward right hatches
                (while (< y height)                                              ; move along the y axis
                    (aset pt-array 0 0)
                    (aset pt-array 1 (+ (- height y) thy))
                    (aset pt-array 2 0)
                    (aset pt-array 3 (- (- height y) thy))
                    (aset pt-array 4 (+ (/ y (tan angle-rad)) thx))              ; intersection with the x axis
                    (aset pt-array 5 height)
                    (aset pt-array 6 (- (/ y (tan angle-rad)) thx))
                    (aset pt-array 7 height)
                    (gimp-free-select img 8 pt-array ADD TRUE 0 0)
                    (set! y (+ y spy))
                ) ; end while
                (set! x (/ (- y height) (tan angle-rad)))
                (while (< x width)                                               ; move along the x axis
                    (aset pt-array 0 (+ x thx))
                    (aset pt-array 1 0)
                    (aset pt-array 2 (- x thx))
                    (aset pt-array 3 0)
                    (aset pt-array 4 width)
                    (aset pt-array 5 (+ (* (- width x) (tan angle-rad)) thy))    ; intersection with the y axis
                    (aset pt-array 6 width)
                    (aset pt-array 7 (- (* (- width x) (tan angle-rad)) thy))
                    (gimp-free-select img 8 pt-array ADD TRUE 0 0)
                    (set! x (+ x spx))
                )    ; end while
            ))    ; end begin, end downward right hatches
        )    ; end cond
        (gimp-selection-invert img)
        (gimp-image-add-channel img selection 0)
        (gimp-drawable-set-visible selection TRUE)
        (gimp-edit-fill selection FG-IMAGE-FILL)
        (gimp-selection-load selection)
        (gimp-palette-set-foreground old-fg)
        (gimp-edit-fill drw FG-IMAGE-FILL)
        (gimp-selection-load old-selection)
        (gimp-image-remove-channel img selection)
        (gimp-image-remove-channel img old-selection)
    )    ; end let
    (gimp-displays-flush)
    (gimp-undo-push-group-end img)
)    ;end define


(define (script-fu-gds-hatch-new width height angle spacing thickness)
    (let*
        (
            (img (car (gimp-image-new width height RGB)))
            (drw (car (gimp-layer-new img width height RGB-IMAGE "hatches" 100 NORMAL-MODE)))
        )
        (gimp-edit-fill drw BG-IMAGE-FILL)
        (gimp-image-add-layer img drw -1)
        (script-fu-gds-hatch img drw angle spacing thickness)
        (gimp-display-new img)
    )
)

(script-fu-register "script-fu-gds-hatch"
    "<Image>/Script-Fu/Render/Hatches"    ;location
    "Hatches the selected area"    ;description
    "Guillaume de Sercey"    ;author
    "gd32@bton.ac.uk"    ;copyright
    "November 2002"    ;date
    "*"    ;format
    SF-IMAGE "Img" 0
    SF-DRAWABLE "Drw" 0
    SF-ADJUSTMENT "Angle" '(30 -90 90 1 10 0 1)
    SF-VALUE "Spacing" "20"
    SF-VALUE "thickness" "2"
)

(script-fu-register "script-fu-gds-hatch-new"
    "<Toolbox>/Xtns/Script-Fu/Patterns/Hatches"    ;location
    "Hatches the selected area"    ;description
    "Guillaume de Sercey"    ;author
    "gd32@bton.ac.uk"    ;copyright
    "November 2002"    ;date
    ""    ;format
    SF-VALUE "Image Width" "256"
    SF-VALUE "Image Height" "256"
    SF-ADJUSTMENT "Angle" '(30 -90 90 1 10 0 1)
    SF-VALUE "Spacing" "20"
    SF-VALUE "thickness" "2"
)

