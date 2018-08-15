;  AURA-LOGO
;  draw the specified text in glowy effect and adds an aura around it
;  This logo was inspired from an add I saw on TV
;
;  Original version
;  Any comments? e-mail me at: Samer-Yhya@yahoo.com
;
;  Version 0.2, ported to Gimp2 by Raymond Ostertag
;  changed the menu entry

(define (apply-aura1-logo-effect img
				  logo-layer
				  bg-color
				  text-color)
  (let* ((width (car (gimp-drawable-width logo-layer)))
	 (height (* 2 (car (gimp-drawable-height logo-layer))))
	 (bg-layer (car (gimp-layer-new img width height RGBA-IMAGE "Background" 100 NORMAL-MODE)))
	 (shadow-layer (car (gimp-layer-new img width height RGBA-IMAGE "Shadow" 100 MULTIPLY-MODE)))
	 (aura-layer (car (gimp-layer-new img width height RGBA-IMAGE "Aura" 100 NORMAL-MODE)))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background))))
    (gimp-image-resize img width height 0 (/ height 4))
    (gimp-image-add-layer img shadow-layer 1)
    (gimp-image-add-layer img aura-layer 2)
    (gimp-image-add-layer img bg-layer 3)
    (gimp-palette-set-foreground text-color)
    (gimp-layer-set-preserve-trans logo-layer TRUE)
    (gimp-edit-fill logo-layer FOREGROUND-FILL)
    (gimp-palette-set-background bg-color)
    (gimp-edit-fill bg-layer BACKGROUND-FILL)
    (gimp-edit-clear shadow-layer)
    (gimp-edit-clear aura-layer)
    (gimp-selection-layer-alpha logo-layer)
    (gimp-palette-set-background '(0 0 0))
    (gimp-selection-feather img 7.5)
    (gimp-edit-fill shadow-layer BACKGROUND-FILL)

    (gimp-selection-layer-alpha logo-layer)
    (gimp-edit-fill aura-layer FOREGROUND-FILL)
    (gimp-selection-none img)
    (plug-in-gauss-rle2 1 img aura-layer 10 (/ height 2) 5)
    (gimp-edit-copy aura-layer 0)
    (gimp-edit-paste aura-layer 0)
    (gimp-edit-paste aura-layer 0)
    (gimp-edit-paste aura-layer 0)
    (gimp-floating-sel-anchor (car (gimp-edit-paste aura-layer 0)))
    (script-fu-erase-rows img aura-layer 1 1 0)

    (gimp-palette-set-foreground '(255 255 255))    
    (gimp-palette-set-background text-color)
    (gimp-edit-blend logo-layer FG-BG-RGB-MODE 0 8 100 20 REPEAT-NONE FALSE FALSE 0 0 FALSE 0 0 width height)

    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)))

(define (script-fu-aura1-logo-alpha img
				     logo-layer
				     bg-color
				     text-color)
  (begin
    (gimp-image-undo-group-start img)
    (apply-aura1-logo-effect img logo-layer bg-color text-color)
    (gimp-image-undo-group-end img)
    (gimp-displays-flush)))

(script-fu-register "script-fu-aura1-logo-alpha"
		    _"<Image>/Script-Fu/Alpha to Logo/Aura..."
		    "Creates a glowy effect and adds an aura around it"
		    "Hani Al-Ers & Samer Yhya"
		    "Hani Al-Ers & Samer Yhya"
		    "2001"
		    "RGBA"
                    SF-IMAGE      "Image" 0
                    SF-DRAWABLE   "Drawable" 0
		    SF-COLOR      _"Background Color" '(0 0 0)
		    SF-COLOR      _"Text Color" '(0 255 165))

(define (script-fu-aura1-logo text
			       size
			       font
			       bg-color
			       text-color)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
	 (text-layer (car (gimp-text-fontname img -1 0 0 text 10 TRUE size PIXELS font))))
    (gimp-image-undo-disable img)
    (gimp-drawable-set-name text-layer text)
    (apply-aura1-logo-effect img text-layer bg-color text-color)
    (gimp-image-undo-enable img)
    (gimp-display-new img)))

(script-fu-register "script-fu-aura1-logo"
		    _"<Toolbox>/Xtns/Script-Fu/Logos/Aura..."
		    "Creates the specified text in glowy effect and adds an aura around it"
		    "Hani Al-Ers & Samer Yhya"
		    "Hani Al-Ers & Samer Yhya"
		    "2001"
		    ""
		    SF-STRING     _"Text" "The GIMP"
		    SF-ADJUSTMENT _"Font Size (pixels)" '(100 2 1000 1 10 0 1)
		    SF-FONT       _"Font" "-*-Dragonwick-*-r-*-*-24-*-*-*-p-*-*-*"
		    SF-COLOR      _"Background Color" '(0 0 0)
		    SF-COLOR      _"Text Color" '(0 255 165))
