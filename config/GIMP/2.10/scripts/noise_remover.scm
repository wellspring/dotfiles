; Original version Tim sleptsov

; Raymond Ostertag 2004/09
; - changed menu entry

(define (noise-remover img drawable noiserad thresold radius)

; Decompose image to LAB
	(set! lab-image (car (plug-in-decompose TRUE img drawable "LAB" TRUE)))
	(set! lab-layers (cadr (gimp-image-get-layers lab-image)))
; Blur B and A channels
	(plug-in-gauss-rle TRUE lab-image (aref lab-layers 0) noiserad 1 1)
	(plug-in-gauss-rle TRUE lab-image (aref lab-layers 1) noiserad 1 1)

; Compose LAB to RGB
	(set! result-image (car (plug-in-drawable-compose TRUE 0 
		(aref lab-layers 2)
		(aref lab-layers 1)
		(aref lab-layers 0) 0 "LAB")))
; Delete LAB image
	(gimp-image-delete lab-image)
    (set! result-layers (cadr (gimp-image-get-layers result-image)))
; Selective Gaussian Blur on result image
	(plug-in-sel-gauss TRUE result-image (aref result-layers 0) radius thresold)

	(gimp-display-new result-image))

(script-fu-register "noise-remover"  
   		    "<Image>/Script-Fu/Enhance/Noise Remover..." 
   		    "Remove color noise by bluring B and A channels in LAB image" 
   		    "Timothey Sleptsov <sleptsov@stel.ru>" 
   		    "Tim sleptsov" 
   		    "2004-09-09" 
   		    ""
			SF-IMAGE "Image" 0
   		SF-DRAWABLE "Layer" 0
			SF-VALUE "Noise Blur Radius" "20.0"
			SF-VALUE "Thresold" "15"
			SF-VALUE "Radius" "5.0"
			)

