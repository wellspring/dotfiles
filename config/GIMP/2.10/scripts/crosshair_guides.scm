(define (script-fu-guide-crosshair img)
(let* ()
(gimp-image-undo-group-start img)
(gimp-image-add-hguide img (/ (car (gimp-image-height img)) 2))
(gimp-image-add-vguide img (/ (car (gimp-image-width img)) 2))
(gimp-image-undo-group-end img)
(gimp-displays-flush)
)
)
(script-fu-register
"script-fu-guide-crosshair"
"/Image/Guides/Crosshair"
"Add horizontal and vertical guides centered on the image."
"Rob Antonishen"
"Rob Antonishen"
"September 2009"
"*"
SF-IMAGE "Image" 0
)