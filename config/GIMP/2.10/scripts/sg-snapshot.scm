; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

(define (script-fu-sg-snapshot orig-image)
  ;; Save a copy of the image 
  (let* ((buffer-name (car (gimp-edit-named-copy-visible orig-image "snapshot")))
         (image (car (gimp-edit-named-paste-as-new buffer-name)))
         (layer (car (gimp-image-get-active-layer image)))
         (filename 
           (if (zero? (strcmp "" (car (gimp-image-get-filename orig-image)) ))
             "Untitled.png"
             (car (gimp-image-get-filename orig-image)) ))
         (fn-components (strbreakup filename "."))
         )
    (set! fn-components (unbreakupstr (butlast fn-components) "."))
    (set! filename (string-append fn-components
                                  "-"
                                  (number->string (modulo (realtime) 
                                                          (* 60 60 24) ))
                                  ".png" ))
    (file-png-save2 RUN-NONINTERACTIVE
                    image 
                    layer
                    filename 
                    filename 
                    FALSE ; Adam7 interlacing?
                    9     ; Compression level
                    FALSE ; bKGD chunk?
                    FALSE ; gAMA chunk?
                    FALSE ; oFFS chunk?
                    FALSE ; pHYS chunk?
                    FALSE ; tIME chunk?
                    FALSE ; write comment?
                    FALSE ; Preserve transparency 
                    )
    (gimp-image-delete image)
    (gimp-buffer-delete buffer-name)
    )
  )
        
(script-fu-register "script-fu-sg-snapshot"
  "Snapshot"
  "Save a copy of the image"
  "Saul Goode"
  "Saul Goode"
  "Aug 2011"
  "*"
  SF-IMAGE    "Image"    0
  )

(script-fu-menu-register "script-fu-sg-snapshot"
 "<Image>/File"
 )
