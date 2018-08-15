;; ---------------------------------------------------------
;; *							   
;; * 		  	    Script-Fu Golden v1.0
;; *							   
;; *			       pour GIMP 2.0.x 		   
;; *							   
;; *							   
;; *	             abcdugimp.free.fr 08/11/2004	           
;; *							   
;; ---------------------------------------------------------
;; Vous êtes libre d'utiliser ce script comme bon vous semble
;; feel free to use it for whatever you like.


;; coordonnees de Courbe
(define (spline-level1)
  (let* ((a (cons-array 4 'byte)))
    (set-pt a 0 58 0)
    (set-pt a 1 126 255)
    a))

(define (spline-level2)
  (let* ((a (cons-array 6 'byte)))
    (set-pt a 0 48 0)
    (set-pt a 1 104 160)
    (set-pt a 2 255 255)
    a))

(define (spline-level3)
  (let* ((a (cons-array 10 'byte)))
    (set-pt a 0 62 0)
    (set-pt a 1 120 234)
    (set-pt a 2 180 238)
    (set-pt a 3 220 150)
    (set-pt a 4 255 215)
    a))

(define (apply-golden-logo image drawable relief type2 type degrade-map conserv)
 
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

		(bump-image (car (gimp-image-new image-width image-height GRAY)))
		(environment-image (car (gimp-image-new 400 400 RGB)))

		(fond-layer (car (gimp-layer-new bump-image image-width image-height GRAY-IMAGE "Bump-Map" 100 NORMAL-MODE))) ;; calque de fond
		(text-layer (car (gimp-layer-new-from-drawable drawable bump-image)))
		(map-layer (car (gimp-layer-new environment-image 400 400 RGB-IMAGE "Environment-Map" 100 NORMAL-MODE))) ;; calque pour carte d'environement
		(golden-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Effet Golden" 100 NORMAL-MODE))) ;; calque de l'effet
		)
		
		
;; initialisation		
(gimp-palette-set-background '(255 255 255))
(gimp-palette-set-foreground '(0 0 0))
(gimp-gradients-set-gradient degrade-map)

;; add layer
(gimp-image-add-layer bump-image fond-layer -1)
(gimp-image-add-layer bump-image text-layer -1)
(gimp-image-add-layer environment-image map-layer -1)
(gimp-image-add-layer image golden-layer -1)

(gimp-edit-clear golden-layer) ;; effacer les traces indesirables  
(gimp-layer-set-offsets golden-layer c-x c-y) ;; mettre le calques aux bonnes coordonnees


;; <----------- bump-image
(gimp-edit-fill fond-layer 0) ;; remplier de noir
(gimp-layer-set-preserve-trans text-layer 1)
(gimp-edit-fill text-layer 1) ;; remplir de blanc
(gimp-layer-set-offsets text-layer 0 0) ;; mettre le calque aux coordonnées 0, 0 (dans le cas ou le calque d'origine est un calque text)
(set! bump-layer (car (gimp-image-merge-down bump-image text-layer 0)))
(plug-in-gauss-iir2 1 bump-image bump-layer 5 5) ;; flou

;; modif eventuel de bump-image suivant le type de relief
(if (= relief 1)
(gimp-curves-spline bump-layer 0 4 (spline-level1)) ;; outil courbe
)
(if (= relief 2)
(gimp-curves-spline bump-layer 0 6 (spline-level2)) ;; outil courbe
)
(if (= relief 3)
(gimp-curves-spline bump-layer 0 10 (spline-level3)) ;; outil courbe
)

(gimp-image-flatten bump-image) ;; supprimer la canal alpha
(set! bump-layer-non-a (car (gimp-image-get-active-layer bump-image))) ;; obtenir le calque
;; ----------->

;; <----------- environment-image
(if (= type2 0)
	(begin
	(if (= type 0) (set! type 8))
	(if (= type 1) (set! type 4))
	(if (= type 3) (set! type 5))
	(plug-in-solid-noise 1 environment-image map-layer 1 0 type 1 2.8 2.8) ;; brouillage uni
	(plug-in-c-astretch 1 environment-image map-layer) ;; auto > etendre les contraste
	(plug-in-gauss-iir2 1  environment-image map-layer 5 5) ;; flou
	(plug-in-gradmap 1 environment-image map-layer) ;; apliquer le degrade-map 
	)
	(begin
		(gimp-edit-blend map-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 400)
	)
)
;; ----------->

;; <----------- appliqué l'effet
;;(gimp-message "Utilisez les parametres par defaut sauf pour ; Onglet options : cochez Arriere-plan transparent ; Onglet Repoussage : cochez Activer et choisir le calque texte blanc sur fond noir, Hauteur maxi = 0,02 ; Onglet Environnement : cochez Activer et choisir le calque avec la texture")  
(plug-in-lighting 1 image golden-layer bump-layer-non-a map-layer TRUE TRUE 0 0 '(0 0 0) 1.00 0.00 1.00 0 0 0 0.30 1.00 0.40 0.60 27.00 TRUE FALSE TRUE) ;; effets d'éclairage
;; ----------->



(if (= conserv FALSE) ;; Conserver les images ?
	(begin
		(gimp-image-delete bump-image)
		(gimp-image-delete environment-image)
	)
	(begin
		(gimp-display-new bump-image)
		(gimp-display-new environment-image)
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

(define (script-fu-golden-logo-alpha image drawable relief type2 type degrade-map conserv)
	(let* (
		(var-select (car (gimp-selection-is-empty image)))
		)

  		(gimp-image-undo-group-start image)
    		
		
		(if (= var-select TRUE) ;; test si il y a selection
			(begin ;; aucune selection n'a été faite 
			)
			(begin ;; une selection a ete faite
				(set! canal (car (gimp-selection-save image))) ;; canal stockant la selection originelle de l'utilisateur
			)
		)
		
		(gimp-selection-none image)

		(apply-golden-logo image drawable relief type2 type degrade-map conserv)
    		
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
)

(script-fu-register "script-fu-golden-logo-alpha"
		_"<Image>/Script-Fu/Alpha to Logo/Golden"
		"Cree un effet a partir de votre calque"
		"Expression"
		"Free"
		"08/11/2004"
		"RGBA"
            SF-IMAGE      "Image" 0
            SF-DRAWABLE   "Drawable" 0
		SF-OPTION "Type de relief (Courbe)" '("Defaut" "Plat" "Adoucie" "Double")
		SF-OPTION "Type de texure" '("Type 'Golden'" "Type 'Land 1'")
		SF-OPTION "Rendu de la texure (pour Type 'Golden')" '("Standard" "Intense" "Doux" "Sombre et soutenu")
		SF-GRADIENT _"Gradient" "Golden"
		SF-TOGGLE "Conserver les images ?" FALSE
)






;; ------------------------
;; script pour <toolbox> 
;; ------------------------

(define (script-fu-golden-logo
				relief 
				type2
				text
			     	size
			    	font
				type
				degrade-map
				conserv)

  (let* (
	(text (string-append " " text " "))
	
	(image (car (gimp-image-new 256 256 RGB)))
			
	(text-layer (car (gimp-text-fontname image -1 0 0 text 10 TRUE size PIXELS font))))
    
	(gimp-image-undo-disable image)
    
	(gimp-layer-set-name text-layer text)
	(gimp-image-resize image (car (gimp-drawable-width text-layer)) (car (gimp-drawable-height text-layer)) 0 0)    	

	(apply-golden-logo image text-layer relief type2 type degrade-map conserv)
    	
	(gimp-image-undo-enable image)
    
	(gimp-display-new image)
  )

)

(script-fu-register "script-fu-golden-logo"
		_"<Toolbox>/Xtns/Script-Fu/Logos/Golden"
		"Cree un effet sur un texte"
		"Expression"
		"Free"
		"08/11/2004"
		""
		SF-OPTION "Type de relief (Courbe)" '("Defaut" "Plat" "Adoucie" "Double")
		SF-OPTION "Type de texure" '("Type 'Golden'" "Type 'Land 1'")
		SF-STRING     _"Text" "Golden"
		SF-ADJUSTMENT _"Font Size (pixels)" '(200 2 1000 1 10 0 1)
		SF-FONT       _"Font" "-*-Arial-*-r-*-*-24-*-*-*-p-*-*-*"
		SF-OPTION "Rendu de la texure (pour Type 'Golden')" '("Standard" "Intense" "Doux" "Sombre et soutenu")
		SF-GRADIENT _"Gradient" "Golden"
		SF-TOGGLE "Conserver les images ?" FALSE
)
