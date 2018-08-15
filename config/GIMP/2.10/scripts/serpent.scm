; 2000 MARIN Laetitia 
; titix@amin.unice.fr
;
; version 0.1a Raymond Ostertag 2004/09
; - changed menu entry

(define (script-fu-serpent img calque) 
  (let* ((old-fg-color (car (gimp-palette-get-foreground)))
	 (sizeX (car (gimp-image-width img)))
	 (sizeY (car (gimp-image-height img)))
	 (calque0
	  (car
	   (gimp-layer-new img sizeX sizeY RGBA-IMAGE "serpent" 100 NORMAL)))
	 (calque1
	  (car
	   (gimp-layer-new img sizeX sizeY RGBA-IMAGE "plasma" 100 NORMAL)))
	 (calque2
	  (car
	   (gimp-layer-new img sizeX sizeY RGBA-IMAGE "plasma" 100 NORMAL))))

  (gimp-image-undo-group-start img)
  (gimp-image-add-layer img calque0 0)
  (gimp-image-add-layer img calque1 0)
  (gimp-image-add-layer img calque2 0)
  
  (plug-in-plasma TRUE img calque0 (+(rand 100000) 200) 2.5)
  (plug-in-plasma TRUE img calque1 (+(rand 100000) 500) 2.5)
  (gimp-edit-clear calque2)

  (gimp-desaturate calque0)
  (gimp-color-balance calque0 0 TRUE 0 100 -30)
  ;(plug-in-mosaic TRUE img calque0 15 4 1 0.65 135 0.20 TRUE TRUE 1 0 0)
  (plug-in-mosaic 
				TRUE	; run_mode 
				img		; image 
				calque0 ; drawable 
				15		; tile_size 
				4		; tile_height 
				1		; tile_spacing 
				0.65	; tile_neatness 
				TRUE	; tile_allow_split 
				135		; light_dir 
				0.2		; color_variation 
				TRUE	; antialiasing 
				TRUE	; color_averaging 
				1		;tile_type 
				0		;tile_surface 
				0		;grout_color
				)
  (plug-in-bump-map TRUE img calque0 calque1 135 45 8 0 0 0 0 TRUE FALSE LINEAR)
  (gimp-palette-set-foreground '(0 0 0))
  (gimp-edit-blend calque2 FG-TRANS NORMAL-MODE LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE (/ sizeX 2) 0 (/ sizeX 2) sizeY) 
  (gimp-palette-set-foreground old-fg-color)
  (gimp-layer-set-opacity calque2 60)
  (gimp-image-remove-layer img calque1)
  (gimp-image-undo-group-end img)
  (gimp-displays-flush)))

(script-fu-register "script-fu-serpent"
		    _"<Image>/Script-Fu/Render/Snake"
		    "peau de serpent"
		    "titix"
		    "2001, titix"
		    "22 sept 2001"
		    ""
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0)
