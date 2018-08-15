;; ---------------------------------------------------------
;; *							   			
;; * 		        Script-Fu Erase-color v1.0		  
;; *							   
;; *		      	 pour GIMP 2.0.x 	        	  
;; *							   
;; *							   
;; *			 abcdugimp.free.fr 06/10/2004	          
;; *							   
;; ---------------------------------------------------------
;; Vous êtes libre d'utiliser ce script comme bon vous semble
;; feel free to use it for whatever you like.



(define (script-fu-erase-color-mode image drawable color conserv)

;; init generale
    (let* (
	;; conserver les outils dans des variables
	(old-fg (car (gimp-palette-get-foreground)))
		
	;; connaitre les dimensions de l'image
	(image-width (car (gimp-image-width image)))
	(image-height (car (gimp-image-height image)))
	
	(mode (car (gimp-drawable-type drawable)))
	;; creation des calques
	(layer (car (gimp-layer-new image image-width image-height mode "Script mode > Suppr. couleur" 100 COLOR-ERASE-MODE)))
	    )

	;; debut d'historique d'annulation
	(gimp-image-undo-group-start image)		

	;; add layer
	(gimp-image-add-layer image layer -1)
	;; ajouter un canal alpha
	(gimp-layer-add-alpha layer)

	(gimp-selection-invert image) ;; inverser la selection 
	(gimp-edit-clear layer) ;; nettoyer le calque
	(gimp-selection-invert image) ;; inverser la selection 

	;; couleur
	(gimp-palette-set-foreground color)

	;; remplissage
	(gimp-edit-fill layer 0)

	;; fusionner les calques
	(if (= conserv FALSE)
		(gimp-image-merge-down image layer 1)
	)

	;; fin d'historique d'annulation
	(gimp-image-undo-group-end image)
    	(gimp-displays-flush)
	
	;;remettre tous les outils comme au debut
	(gimp-palette-set-foreground old-fg)

    )

)


(script-fu-register "script-fu-erase-color-mode"
	"<Image>/Script-Fu/Utils/Erase color"
    	"Supprime une couleur par mode de calque. abcdugimp.free.fr"
    	"Expression"
    	"Free"
    	"06/10/2004"
    	"RGB* GRAY*"
    	SF-IMAGE "Image" 0 
    	SF-DRAWABLE "Drawable" 0
	SF-COLOR "    Couleur a effacer" '(255 255 255)
	SF-TOGGLE "Conserver le calque ?" FALSE
)
