;Script written by Guillaume de Sercey
;gd32@bton.ac.uk
;Idea given by Andrew J Fortune in gimpwin-user mail list
;Reproduces photoshop effect Pillow Emboss (well, at least it tries)

;What it does
;Copy the layer twice (it must have some transparency)
;select the alpha
;fill one copy with white
;grow selection
;fill the other copy with white
;blur both layers
;Bump-map (inverted) the background with the second one
;Bump-map the original layer with the first one


(define (script-fu-pillow-emboss img drw background size blur azimuth highlight)
    (define (array->list array)    ;little function to convert an array into a list
        (let*
            (
                (array-size (- (length array) 1))
                (mylist '())
            )    ;end variable declaration
            (while (>= array-size 0)
                (set! mylist (cons (aref array array-size ) mylist))
                (set! array-size (- array-size 1))
            )    ;end while
            mylist
        )
    )    ;end define
    (let*
        (
            (width (car (gimp-drawable-width drw)))
            (height (car (gimp-drawable-height drw)))
            (type (car (gimp-drawable-type-with-alpha drw)))
            (pillowbump-layer (car (gimp-layer-copy drw FALSE)))
            (bevelbump-layer (car (gimp-layer-copy drw FALSE)))
            (background-image (car (gimp-drawable-image background)))
            (elevation (- 100 highlight))
        )    ;end variable definition
        (gimp-undo-push-group-start img)
        (gimp-layer-set-preserve-trans pillowbump-layer FALSE)
        (gimp-layer-set-preserve-trans bevelbump-layer FALSE)
        (gimp-selection-layer-alpha pillowbump-layer)
        (gimp-edit-fill bevelbump-layer WHITE-IMAGE-FILL)
        (gimp-selection-grow img size)
        (gimp-edit-fill pillowbump-layer WHITE-IMAGE-FILL)
        (gimp-selection-none img)
        (plug-in-gauss-rle RUN-NONINTERACTIVE img bevelbump-layer blur TRUE TRUE)
        (plug-in-gauss-rle RUN-NONINTERACTIVE img pillowbump-layer blur TRUE TRUE)
        (if (not (= background-image img))
            (begin    ;if the background layer does not belong to the image
                (gimp-selection-none background-image)
                (gimp-edit-copy background)
                (set! background (car (gimp-edit-paste drw FALSE)))
                (gimp-floating-sel-to-layer background)
            )    ;end begin (if true close)
        ); end if (background belong to image or not)
        (plug-in-bump-map RUN-NONINTERACTIVE img background pillowbump-layer azimuth 37 5 0 0 0 0 TRUE TRUE LINEAR)
        (plug-in-bump-map RUN-NONINTERACTIVE img drw bevelbump-layer azimuth elevation 12 0 0 0 0 TRUE FALSE LINEAR)
        (gimp-layer-delete pillowbump-layer)
        (gimp-layer-delete bevelbump-layer)
        (set! layer-list (cadr (gimp-image-get-layers img)))    ;get the list of layers in the image
        (set! layers-below (memv drw (array->list layer-list)))    ;get the layer and the list of all layers below
        (while (null? (memv background layers-below))       ;while the background is not below the layer
            (gimp-image-lower-layer img background)    ;then lower it
            (set! layer-list (cadr (gimp-image-get-layers img)))
            (set! layers-below (memv drw (array->list layer-list)))
        )    ;end while
        (gimp-undo-push-group-end img)
    )    ;end let
    (gimp-displays-flush)
)    ;end define

(script-fu-register "script-fu-pillow-emboss"
    "<Image>/Script-Fu/Alpha to Logo/Pillow emboss"
    "Pillow Emboss effect\nAs described by Andrew J Fortune in gimpwin-users\nFinal method by Mark Post\nEdge width represents how much the pillow is affected\nBlur amount affects the bump mapping\nAzimuth is the direction of the bump map\nHighlight affects the highlighting of the original image"
    "Guillaume de Sercey"
    "gds"
    "March 2001"
    "RGBA, GRAYA"
    SF-IMAGE "" 0
    SF-DRAWABLE "" 0
    SF-DRAWABLE "background to merge" 0
    SF-ADJUSTMENT "Edge width" '(3 1 100 1 10 0 1)
    SF-ADJUSTMENT "Blur amount" '(10 0 5488 1 10 0 1)
    SF-ADJUSTMENT "Bumpmap Azimuth" '(135 0 360 1 10 0 1)
    SF-ADJUSTMENT "Amount of Highlight" '(30 0 100 1 10 0 0)
)