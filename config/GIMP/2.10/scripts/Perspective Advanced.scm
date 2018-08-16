; Perspective Advanced rel 0.03
; Created by Graechan
; Comments directed to http://gimpchat.com or http://gimpscripts.com
;
; License: GPLv3
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;    GNU General Public License for more details.
;
;    To view a copy of the GNU General Public License
;    visit: http://www.gnu.org/licenses/gpl.html
;
;
; ------------
;| Change Log |
; ------------ 
; Rel 0.01 - Initial Release
; Rel 0.02 - changed the SELECTION-MASK to a WHITE-MASK and fixed error with respecting selections
; Rel 0.03 - added 360 degree shadow ability
;
;find layer by name proceedure
(define (find-layer-by-name image layerName)
  (let* (
           (layerList (vector->list (cadr (gimp-image-get-layers image))))    
           (wantedLayerId -1)
		   (layerId 0)
           (layerText "")
        )
       
        (while (not (null? layerList))
          (set! layerId (car layerList))
		  (set! layerText (cond ((defined? 'gimp-image-get-item-position) (car (gimp-item-get-name layerId)))
		                  (else (car (gimp-drawable-get-name layerId)))))
          (if (string=? layerText layerName) (set! wantedLayerId layerId))          
          (set! layerList (cdr layerList))) ;endwhile        
        (if (= -1 wantedLayerId) (error (string-append "Could not find a layer with name:- " layerName)))
        (list wantedLayerId)
  ) ;end variables
) ;end find layer by name proceedure
;
(define (script-fu-perspective-shadow-advanced image
                                      drawable
                                      alpha
                                      rel-distance
                                      rel-length
                                      shadow-blur
                                      shadow-color
                                      shadow-opacity
                                      interpolation
									  fade
                                      allow-resize)
    
	(gimp-image-undo-group-start image)
	
	
  (let* (
        (f1 (cond ((> alpha 180) TRUE)                ;f1 flag
		           (else FALSE)))
		(alpha (cond ((> alpha 180) (-(- alpha 360)))
		              (else alpha)))
		(ver 2.8)
		(shadow 0)
		(shadow-mask 0)
		(width 0)
		(height 0)
		(sel (car (gimp-selection-is-empty image)))
		(selection 0)
		(offx 0)
		(offy 0)
        )
    (cond ((not (defined? 'gimp-image-get-item-position)) (set! ver 2.6))) ;define the gimp version
	
	(gimp-context-push)
    (gimp-context-set-paint-method "gimp-paintbrush")
	(cond ((defined? 'gimp-context-set-dynamics) (gimp-context-set-dynamics "Dynamics Off")))
    (gimp-context-set-foreground '(0 0 0))
	(gimp-context-set-background '(255 255 255))
	
	(if (= sel FALSE) (set! selection (car (gimp-selection-save image))))

;;;;create the shadow and set as active layer	
	(script-fu-perspective-shadow image
                                      drawable
                                      alpha
                                      rel-distance
                                      rel-length
                                      shadow-blur
                                      shadow-color
                                      shadow-opacity
                                      interpolation
                                      FALSE)
	
    (set! shadow (car (find-layer-by-name image "Perspective Shadow")))
	(gimp-image-set-active-layer image shadow)
	(gimp-selection-none image)
	
;;;;get the shadow dimensions	
	(set! width (car (gimp-drawable-width shadow)))
    (set! height (car (gimp-drawable-height shadow)))

;;;;create the mask	
	(set! shadow-mask (car (gimp-layer-create-mask shadow ADD-WHITE-MASK)))
	(gimp-layer-add-mask shadow shadow-mask)

;;;;blend the mask	
	(gimp-context-set-gradient "FG to BG (RGB)")
	(gimp-edit-blend shadow-mask CUSTOM-MODE NORMAL-MODE GRADIENT-LINEAR fade 0 REPEAT-NONE FALSE FALSE 3 0.2 TRUE (/ width 2) 0 (/ width 2) height)
	


	(plug-in-gauss-rle2 RUN-NONINTERACTIVE image shadow-mask 10 10)
	(gimp-layer-remove-mask shadow 0)
	
;;;;adjust shadow position
    (if (= f1 TRUE) (begin
	(gimp-layer-translate shadow 0 height)
	(set! offx (car (gimp-drawable-offsets shadow)))
	(set! offy (cadr (gimp-drawable-offsets shadow)))
	(set! width (car (gimp-drawable-width shadow)))
    (set! height (car (gimp-drawable-height shadow)))	
	(gimp-drawable-transform-flip-simple shadow 1 FALSE (+ offy (/ height 2)) FALSE)	
	)) ;endif
	(if (= allow-resize TRUE) (gimp-image-resize-to-layers image))
	(gimp-image-set-active-layer image drawable)
	(if (= sel FALSE) (gimp-selection-load selection))
	(if (= sel FALSE) (gimp-image-remove-channel image selection))

	(gimp-image-undo-group-end image)
    (gimp-displays-flush)
    (gimp-context-pop)
	
	)
)
	
(script-fu-register "script-fu-perspective-shadow-advanced"
  _"_Perspective Advanced..."
  _"Add a perspective shadow to the selected region (or alpha)"
  "GimpChat - http://gimpchat.com"
  "GimpChat"
  "2013/11/08"
  "RGB* GRAY*"
  SF-IMAGE       "Image"                        0
  SF-DRAWABLE    "Drawable"                     0
  SF-ADJUSTMENT _"Angle"                        '(45 0 360 1 45 0 0)
  SF-ADJUSTMENT _"Relative distance of horizon" '(5 0.1 24.1 0.1 1 1 1)
  SF-ADJUSTMENT _"Relative length of shadow"    '(1 0.1 24   0.1 1 1 1)
  SF-ADJUSTMENT _"Blur radius"                  '(3 0 1024 1 10 0 0)
  SF-COLOR      _"Color"                        '(0 0 0)
  SF-ADJUSTMENT _"Opacity"                      '(80 0 100 1 10 0 0)
  SF-ENUM       _"Interpolation"                '("InterpolationType" "linear")
  SF-ADJUSTMENT _"Fade %"                      '(100 0 100 1 10 0 0)
  SF-TOGGLE     _"Allow resizing"               TRUE
)

(script-fu-menu-register "script-fu-perspective-shadow-advanced" "<Image>/Filters/Light and Shadow/Shadow")	