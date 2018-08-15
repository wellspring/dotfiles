;; ---------------------------------------------------------
;; *							   
;; * 		  	    Script-Fu Reflex v1.0
;; *							   
;; *			       pour GIMP 2.0.x 		   
;; *							   
;; *							   
;; *	             abcdugimp.free.fr 23/10/2004	           
;; *							   
;; ---------------------------------------------------------
;; Vous êtes libre d'utiliser ce script comme bon vous semble
;; feel free to use it for whatever you like.


(define (apply-reflex-logo image drawable degrade-map degrade-effect decalage decoupe conserv)
 
	(let* (
		;; conserver les outils dans des variables
		(old-bg (car (gimp-palette-get-background)))
		(old-fg (car (gimp-palette-get-foreground)))
		(old-deg (car (gimp-gradients-get-gradient)))
	
		;; connaitre les dimensions de l'image
		(image-width (car (gimp-drawable-width drawable)))
		(image-height (car (gimp-drawable-height drawable)))
		
		;; connaitre les coordonnees du calque
		(c-x (car (gimp-drawable-offsets drawable)))
		(c-y (cadr (gimp-drawable-offsets drawable)))

		(white-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Flou" 100 NORMAL))) ;; calque blanc
		(text-layer (car (gimp-layer-new-from-drawable drawable image)))
		(fond-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Arriere-plan" 100 NORMAL))) ;; calque horizon
		(horizon-layer (car (gimp-layer-new-from-drawable fond-layer image)))
		(bump-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE (string-append "Relief + " degrade-map) 100 OVERLAY-MODE))) ;; calque relief
		)
		
	;; add layer
	(gimp-image-add-layer image white-layer -1)
	(gimp-image-add-layer image text-layer -1)
	(gimp-image-add-layer image fond-layer -1)
	(gimp-image-add-layer image horizon-layer -1)
	(gimp-image-add-layer image bump-layer -1)
	
	;; effacer les traces
	(gimp-edit-clear fond-layer) 
	(gimp-edit-clear horizon-layer)

	;; mettre les calques aux bonnes coordonnees
	(gimp-layer-set-offsets white-layer c-x c-y)
	(gimp-layer-set-offsets text-layer c-x c-y)
	(gimp-layer-set-offsets fond-layer c-x c-y)
	(gimp-layer-set-offsets horizon-layer c-x c-y)
	(gimp-layer-set-offsets bump-layer c-x c-y)

;; <----------- calque flou 
(gimp-palette-set-background '(255 255 255)) ;; couleur blanche
(gimp-edit-fill white-layer 1) ;; remplir de blanc
(set! blur-layer (car (gimp-image-merge-down image text-layer 0))) ;; fusionner les 2 calques
(plug-in-gauss-rle2 1 image blur-layer 15 15) ;; flou 
;; ----------->

;; <----------- calque horizon
(gimp-gradients-set-gradient degrade-effect)
(gimp-edit-blend fond-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 (+ image-height decalage))
(gimp-edit-blend horizon-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
(gimp-drawable-set-name horizon-layer degrade-effect)
(plug-in-displace 1 image horizon-layer decalage decalage TRUE TRUE blur-layer blur-layer 0) ;; carte > deplacer
;; ----------->

;; <----------- calque relief
(gimp-palette-set-foreground '(152 152 152)) ;; couleur grise
(gimp-edit-fill bump-layer 0) ;; remplir de gris
(plug-in-bump-map 1 image bump-layer blur-layer 135 27 7 0 0 0 0 TRUE TRUE 2) ;; repoussage d'après une carte
(gimp-gradients-set-gradient degrade-map)
(plug-in-gradmap 1 image bump-layer) ;; apliquer le degrade-map 
;; ----------->

;; <----------- calque relief
(gimp-selection-layer-alpha drawable) ;; alpha vers selection
(gimp-selection-grow image 5) ;; agrandir la selection
(gimp-selection-invert image) ;; inverser la selection
(gimp-edit-clear horizon-layer) ;; effacer
(gimp-edit-clear bump-layer) ;; effacer
(gimp-selection-none image) ;; aucune selection
;; ----------->


(if (= decoupe FALSE) ;; Decoupe ?
	(begin
		(gimp-edit-clear fond-layer) ;; effacer
	)
)

(if (= conserv FALSE) ;; Conserver les calques ?
	(begin
		(gimp-image-remove-layer image blur-layer)
		(gimp-image-merge-down image horizon-layer 0)
		(set! layer (car (gimp-image-merge-down image bump-layer 0)))
		(gimp-drawable-set-name layer "Script-fu reflex")
	)
	(begin
		(if (= decoupe FALSE) (gimp-image-remove-layer image fond-layer))
	)
)

;; mise a jour
(gimp-palette-set-background old-bg)
(gimp-palette-set-foreground old-fg)
(gimp-gradients-set-gradient old-deg)

	)

 
)






;; ------------------------
;; script pour <image> 
;; ------------------------

(define (script-fu-reflex-logo-alpha image drawable degrade-map degrade-effect decalage decoupe conserv)
  		(gimp-image-undo-group-start image)
    		
		(set! var-select (car (gimp-selection-is-empty image)))
		(if (= var-select TRUE) ;; test si il y a selection
			(begin ;; aucune selection n'a été faite 
			)
			(begin ;; une selection a ete faite
				(set! canal (car (gimp-selection-save image))) ;; canal stockant la selection originelle de l'utilisateur
			)
		)
		
		(gimp-selection-none image)

		(apply-reflex-logo image drawable degrade-map degrade-effect decalage decoupe conserv)
    		
		(if (= var-select TRUE) ;; test si il y AVAIT selection
			(begin ;; aucune selection n'avait été faite 
			)
			(begin ;; une selection avait été faite (remettre la selection de l'utilisateur)
				(gimp-selection-load canal) ;; mask de canal vers selection
				(gimp-image-remove-channel image canal) ;; supprimer le mask de canal
			)
		)

		(gimp-image-undo-group-end image)
    		
		(gimp-displays-flush)
)

(script-fu-register "script-fu-reflex-logo-alpha"
		_"<Image>/Script-Fu/Alpha to Logo/Reflex"
		"Cree un effet a partir de votre calque"
		"Expression"
		"Free"
		"23/10/2004"
		"RGBA"
            SF-IMAGE      "Image" 0
            SF-DRAWABLE   "Drawable" 0
		SF-GRADIENT "Degrade pour le relief" "Three bars sin"
		SF-GRADIENT "Degrade a appliquer" "Horizon 2"
		SF-ADJUSTMENT "Decalage du degrade applique" '(20 1 60 1 10 0 0)
		SF-TOGGLE "Avec un arriere-plan ?" FALSE
		SF-TOGGLE "Conserver les calques ?" FALSE
)






;; ------------------------
;; script pour <toolbox> 
;; ------------------------

(define (script-fu-reflex-logo 
				text
			     	size
			    	font
				degrade-map
				degrade-effect
				decalage 
				decoupe
				conserv)

  (let* (
	(text (string-append " " text " "))
	
	(image (car (gimp-image-new 256 256 RGB)))
			
	(text-layer (car (gimp-text-fontname image -1 0 0 text 10 TRUE size PIXELS font))))
    
	(gimp-image-undo-disable image)
    
	(gimp-layer-set-name text-layer text)
	(gimp-image-resize image (car (gimp-drawable-width text-layer)) (car (gimp-drawable-height text-layer)) 0 0)    	

	(apply-reflex-logo image text-layer degrade-map degrade-effect decalage decoupe conserv)
    	
	(if (= conserv FALSE) (gimp-image-remove-layer image text-layer))
	
	(gimp-image-undo-enable image)
    
	(gimp-display-new image)
  )

)

(script-fu-register "script-fu-reflex-logo"
		_"<Toolbox>/Xtns/Script-Fu/Logos/Reflex"
		"Cree un effet sur un texte"
		"Expression"
		"Free"
		"23/10/2004"
		""
		SF-STRING     _"Text" "Reflex"
		SF-ADJUSTMENT _"Font Size (pixels)" '(200 2 1000 1 10 0 1)
		SF-FONT       _"Font" "-*-Arial-*-r-*-*-24-*-*-*-p-*-*-*"
		SF-GRADIENT "Degrade pour le relief" "Three bars sin"
		SF-GRADIENT "Degrade a appliquer" "Horizon 2"
		SF-ADJUSTMENT "Decalage du degrade applique" '(20 1 60 1 10 0 0)
		SF-TOGGLE "Avec un arriere-plan ?" FALSE
		SF-TOGGLE "Conserver les calques ?" FALSE
)
