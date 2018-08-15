;  Vincent VIVIEN (15 years old) Student France
;  http://perso.wanadoo.fr/bruno.vivien/vincent/gimp/index.htm
;  vincent.vivien@wanadoo.fr
;
;  ****************************
;  *"The fire font" v1.1  *
;  *script written for The Gimp*
;  ****************************
;  Version 1.2 : Ported to Gimp 2 by Raymond Ostertag
;
;  Code:

(define (script-fu-fire-logo texte taille police lumin bpmp sky)
   (let* ((img (car (gimp-image-new 256 256 RGB)))
   	  (fg (car (gimp-palette-set-foreground '(0 0 0))))
   	  (text-layer (car (gimp-text-fontname img -1 0 0 texte 30 TRUE taille PIXELS police)))
          (largeur (car (gimp-drawable-width text-layer)))
          (hauteur (+ (car (gimp-drawable-height text-layer)) 50))
          (logo-layer (car (gimp-layer-new img largeur hauteur RGBA-IMAGE "Background" 100 NORMAL-MODE)))) 

   (gimp-invert text-layer)
   (gimp-layer-set-offsets text-layer 0 50)
   (gimp-palette-set-background '(0 0 0))
   (gimp-image-add-layer img logo-layer 1)
   (gimp-edit-fill logo-layer FOREGROUND-FILL)
   (gimp-image-resize img largeur hauteur 0 0)
   (set! feu (car (gimp-image-merge-down img text-layer 0)))
   (plug-in-rotate 1 img feu 1 TRUE)
   (plug-in-wind 1 img feu 9 0 9 0 1)
   (plug-in-rotate 1 img feu 3 TRUE)
   (plug-in-gauss-rle2 1 img feu 1 1)
   (gimp-message "Please make a dissolved letters' effect !")
   (plug-in-iwarp 0 img feu)
   (if (= lumin TRUE)
          (begin (gimp-color-balance feu 0 1 92 -2 -61)
                 (gimp-color-balance feu 1 1 38 -6 -48)
                 (gimp-color-balance feu 2 1 7 -4 -24)))
   (if (= lumin FALSE)
          (begin (gimp-color-balance feu 0 0 92 -2 -61)
                 (gimp-color-balance feu 1 0 38 -6 -48)
                 (gimp-color-balance feu 2 0 7 -4 -24)))
   (if (= bpmp TRUE)
   	  (begin (plug-in-bump-map 1 img feu feu 53.68 21.70 3 0 0 0 0 1 0 2)
                 (plug-in-gauss-rle2 1 img feu 1 1)))
   (if (= sky TRUE)
   	  (begin (set! cloud-layer (car (gimp-layer-new img largeur hauteur RGBA-IMAGE "Cloud" 50 NORMAL-MODE)))
          	 (set! star-layer (car (gimp-layer-new img largeur hauteur RGBA-IMAGE "Star" 100 NORMAL-MODE)))
                 (gimp-image-add-layer img cloud-layer 1)
                 (gimp-image-add-layer img star-layer 2)
                 (gimp-edit-fill cloud-layer FOREGROUND-FILL)
                 (gimp-edit-fill star-layer FOREGROUND-FILL)
                 (gimp-by-color-select feu '(0 0 0) 0 2 TRUE 0 0 0)
                 (gimp-edit-clear feu)
                 (gimp-selection-none img)
                 (plug-in-scatter-hsv 1 img star-layer 2 53 46 110)
                 (plug-in-solid-noise 1 img cloud-layer 0 0 1 1 4.0 4.0)
                 (gimp-color-balance cloud-layer 0 0 0 34 57)))
   (gimp-display-new img)
   (gimp-message "That's all folks. Thanks you! :-)")))
   

(script-fu-register "script-fu-fire-logo"
		    _"<Toolbox>/Xtns/Script-Fu/Logos/Fire..."
		    "Creates a burning font's effect :-0 (Excuse me for my English!)"
		    "Vincent Vivien <vincent.vivien@wanadoo.fr>"
		    "Vincent Vivien"
		    "2001"
		    ""
		    SF-STRING     _"Text" "Fireman"
		    SF-ADJUSTMENT _"Font Size (pixels)" '(100 2 1000 1 10 0 1)
		    SF-FONT       _"Font" "-*-911 Porscha-*-r-*-*-24-*-*-*-p-*-*-*"
                    SF-TOGGLE     _"Tick for keep brightness" FALSE
                    SF-TOGGLE     _"Make a nice embossing effect" FALSE
                    SF-TOGGLE	  _"Add a starry sky with nice subdued clouds" FALSE)
                    
		
