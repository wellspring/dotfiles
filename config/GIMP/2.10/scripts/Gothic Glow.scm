;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                 Gothic Glow                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A GIMP script-fu version of the popular PS
; action by "feivel".

; Creates a layer set to multiply mode and
; another layer set to screen mode.
; Blur radii may be specified for each layer,
; and you can choose to add fully transparent
; layer masks to both layers automatically.
; 
; Only tested on 2.2.8
; 3/21/2006
 
 
(define (script-fu-gothic-glow  img drawable mult-blur-rad screen-blur-rad mask-flag )
 
   ; Start an undo group.  Everything between the start and the end
   ; will be carried out if an undo command is issued.

   (gimp-image-undo-group-start img)

   ;; CREATE THE MULTIPLY LAYER ;;

   ; Create a new layer
 
   (set! mult-layer (car (gimp-layer-copy drawable 0)))
  
   ; Give it a name

   (gimp-drawable-set-name mult-layer "Multiply Layer")
  
   ; Add the new layer to the image
 
   (gimp-image-add-layer img mult-layer 0)

   ; Set opacity to 100%

   (gimp-layer-set-opacity mult-layer 100)

   ; Copy the layer for later ...

   (set! screen-layer (car (gimp-layer-copy mult-layer 0)))

   ; Set the layer mode to Multiply

   (gimp-layer-set-mode mult-layer 3)
   
   ; Blur the layer
 
   (if (> mult-blur-rad 0)
       (plug-in-gauss-iir 1 img mult-layer mult-blur-rad 1 1 )
       ()
   )

   ; Add layer mask if required

   (if (equal? mask-flag TRUE)
       (gimp-layer-add-mask  mult-layer (car (gimp-layer-create-mask mult-layer 0))) 
       ()
   )

   ;
   ;

   ;; CREATE THE SCREEN LAYER ;;
   
   ; Name the screen layer

   (gimp-drawable-set-name screen-layer "Screen Layer")
  
   ; Add the new layer to the image
 
   (gimp-image-add-layer img screen-layer 0)

   ; Set opacity to 100%

   (gimp-layer-set-opacity screen-layer 100)

   ; Set the layer mode to Screen

   (gimp-layer-set-mode screen-layer 4)

   ; Blur the layer
 
   (if (> screen-blur-rad 0)
       (plug-in-gauss-iir 1 img screen-layer screen-blur-rad 1 1 )
       ()
   )

   ; Add layer mask if required

   (if (equal? mask-flag TRUE)
       (gimp-layer-add-mask  screen-layer (car (gimp-layer-create-mask screen-layer 0))) 
       ()
   )


   ; Complete the undo group

   (gimp-image-undo-group-end img)

   ; Flush the display 
 
   (gimp-displays-flush)   
 
)
 
 
(script-fu-register "script-fu-gothic-glow"
 
      "<Image>/Script-Fu/Gothic Glow"
 
      "Add multiply layer and a screen layer"
 
      "Mark Lowry"
 
      "Mark Lowry"
 
      "2006"
  
      "RGB*, GRAY*"
 
      SF-IMAGE "Image" 0
 
      SF-DRAWABLE "Current Layer" 0

      SF-VALUE "Multiply Layer Blur Radius"  "8"

      SF-VALUE "Screen Layer Blur Radius"  "0"

      SF-TOGGLE "Add Layer Masks?"  TRUE
 )

