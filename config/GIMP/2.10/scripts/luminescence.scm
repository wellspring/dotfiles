;; ---------------------------------------------------------
;; *									     *
;; * 		      Script-Fu Luminescence + v1.0		     *
;; *							   		     *
;; *		       	pour GIMP 2.0.x 	        	     *
;; *							   		     *
;; *							   		     *
;; *		 	abcdugimp.free.fr 25/10/2004	           *
;; *							   		     *
;; ---------------------------------------------------------
;; Vous êtes libre d'utiliser ce script comme bon vous semble
;; feel free to use it for whatever you like.



;; ---------------------------------------------------------
;; *	 	Affiche les images d'un Script-Fu  		     *
;; ---------------------------------------------------------

(define (script-fu-affiche-images-luminescence
				script 
				taille-x taille-y turb detail
				mode1 mode2
				color
				)

(let* (
	;; taille de l'image
	(image-width 256)
	(image-height 256)
	
	(mode1 (+ mode1 2))
	(mode2 (+ mode2 2))

	;; creation de l'image
	(image (car (gimp-image-new image-width image-height RGB)))

	;; init
	(inc 0)
	(deux 0)
	(un 0)
	)

(if (= script 0)
	(begin
		(while (< inc 16)
			(apply-luminescence-volute
					image
					image-width image-height
					inc 
					taille-x taille-y turb detail
					FALSE)
			( set! inc (+ inc 1))
		)
	)		
)

(if (= mode1 2) (set! mode1 6))
(if (= mode2 2) (set! mode2 7))

(set! list (cadr (gimp-gradients-get-list "")))

(if (= script 1)
	(begin
		(while list
			(set! nom (car list))
	   		(gimp-message nom)
			(apply-luminescence-volute-abstract
					image
					image-width image-height
					mode1 nom
					mode2 taille-x taille-y turb detail
					FALSE)
			(set! list (cdr list))
			
		)
	)		
)

(if (= script 2)
	(begin
		(while (< deux 4)
			(set! un 0)
			(while (< un 3)
				(if (= deux 0) (set! m2 "DIFFERENCE"))
				(if (= deux 1) (set! m2 "SOUSTRACTION"))
				(if (= deux 2) (set! m2 "EXTRACTION de GRAIN"))
				(if (= deux 3) (set! m2 "DIVISER"))

				(if (= un 0) (set! m1 "DIFFERENCE"))
				(if (= un 1) (set! m1 "SOUSTRACTION"))
				(if (= un 2) (set! m1 "EXTRACTION de GRAIN"))

				(set! nom (string-append m2 " + " m1))
				
				(apply-luminescence-entrelats
						image
						nom
						FALSE
						color
						image-width image-height
						taille-x taille-y turb detail
						deux un
						FALSE)
				(set! un (+ un 1))
			)
		(set! deux (+ deux 1))
		)

		(apply-luminescence-entrelats
						image
						"Repoussage"
						TRUE
						color
						image-width image-height
						taille-x taille-y turb detail
						0 0
						FALSE)
	)		
)


;; mise a jour
	(gimp-display-new image)

   )
)

;; registre 
(script-fu-register "script-fu-affiche-images-luminescence"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Luminescence +/Affiche toutes les images..."
		    "Affiche toutes les images possible du script-fu selectionne. abcdugimp.free.fr"
		    "Expression"
		    "Free"
		    "27/10/2004"
		    ""
	SF-OPTION "Script" '("Volute" "Volute abstraite" "Entrelacs")
	SF-ADJUSTMENT "Taille X" '(5 0.1 16 0.1 1 1 0)
	SF-ADJUSTMENT "Taille Y" '(5 0.1 16 0.1 1 1 0)
	SF-TOGGLE "Turbulent ?" TRUE
	SF-ADJUSTMENT "Detail" '(1 1 15 1 4 0 1)
	SF-OPTION "Mode de calque du degrade
		     UNIQUEMENT POUR VOLUTE ABSTRAITE" '("2 - Defaut (difference)" "3 - Multiplier" "4 - Ecran" "5 - Superposer" "6 - Difference" "7 - Addition" "8 - Soustraction" "9 - Noircir seulement" "10 - Eclaircir seulement" "11 - Teinte" "12 - Saturation" "13 - Couleur" "14 - Valeur" "15 - Diviser" "16 - Eclaircir" "17 - Assombrir" "18 - Lumiere dure" "19 - Lumiere douce" "20 - Extraction de grain" "21 - Fusion de grain" "22 - Erase color")
	SF-OPTION "Mode de calque psychadelique
		     UNIQUEMENT POUR VOLUTE ABSTRAITE" '("2 - Defaut (addition)" "3 - Multiplier" "4 - Ecran" "5 - Superposer" "6 - Difference" "7 - Addition" "8 - Soustraction" "9 - Noircir seulement" "10 - Eclaircir seulement" "11 - Teinte" "12 - Saturation" "13 - Couleur" "14 - Valeur" "15 - Diviser" "16 - Eclaircir" "17 - Assombrir" "18 - Lumiere dure" "19 - Lumiere douce" "20 - Extraction de grain" "21 - Fusion de grain" "22 - Erase color")
	SF-COLOR "Couleur - UNIQUEMENT POUR ENTRELACS" '(33 100 58)
)

;; ---------------------------------------------------------
;; *	 	Affiche les images d'un Script-Fu  		     *
;; ----END--------------------------------------------------




;; ---------------------------------------------------------
;; *									     *
;; * 		         Script-Fu reflet v1.0		     *
;; *							   		     *
;; ---------------------------------------------------------

(define (script-fu-luminescence-reflet
				image-width image-height
				lum-blanche
				coin1 color1 coin2 color2 coin3 color3 coin4 color4
				taille-x taille-y turb detail mode
				conserv
				)


;; init generale
    (let* (
	;; conserver les outils dans des variables
	(old-fg (car (gimp-palette-get-foreground)))
	(old-deg (car (gimp-gradients-get-gradient)))
	
	;; creation de l'image
	(image (car (gimp-image-new image-width image-height RGB)))

	;; creation des calques
	(fond-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Arriere-plan" 100 NORMAL))) ;; fond noir
	(flare1-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Degrade 1" 100 NORMAL))) ;;
	(uni-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Brouillage uni" 100 NORMAL))) ;;

	;; decalage pour le remplissage du degrade
	(decalage-x (/ image-width 6))
	(decalage-y (/ image-height 6))
	   )

	;; add layer
	(gimp-image-add-layer image fond-layer -1)
	(gimp-image-add-layer image flare1-layer -1)
	
	

;; initialisations
(gimp-palette-set-foreground '(0 0 0))
(gimp-gradients-set-gradient "Flare Radial 102")
	
;; init calques ;; vider les calques pour qu'il n'y est pas de trace indesirable
(gimp-edit-clear flare1-layer)
	


;;--------------------------------------------------
;;			base
;;--------------------------------------------------

(gimp-edit-fill fond-layer 0) ;; remplir le fond de noir

;;--------------------------------------------------

;; degrade suivant lum-blanche
(if (= lum-blanche 1)
	(begin ;; beaucoup de lumiere blanche
		(gimp-edit-blend flare1-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE image-width 0 (- decalage-x) (+ image-height decalage-y))
	)
	(begin ;; peu de lumiere blanche
		(gimp-edit-blend flare1-layer 3 0 0 100 0 0 FALSE FALSE 0 0 TRUE (+ image-width decalage-x) (- decalage-y) (- decalage-x) (+ image-height decalage-y))
	)
)
;; dupliquer les 3 autres calques de degrade
(set! flare2-layer (car (gimp-layer-new-from-drawable flare1-layer image)))
(gimp-image-add-layer image flare2-layer -1)
(gimp-drawable-set-name flare2-layer "Degrade 2")
(gimp-flip flare2-layer 1)

(set! flare3-layer (car (gimp-layer-new-from-drawable flare2-layer image)))
(gimp-image-add-layer image flare3-layer -1)
(gimp-drawable-set-name flare3-layer "Degrade 3")
(gimp-flip flare3-layer 0)

(set! flare4-layer (car (gimp-layer-new-from-drawable flare3-layer image)))
(gimp-image-add-layer image flare4-layer -1)
(gimp-drawable-set-name flare4-layer "Degrade 4")
(gimp-flip flare4-layer 1)

;; regler le mode et les calques qui seront affichés
(if (= color1 1)
(gimp-layer-set-mode flare1-layer GRAIN-EXTRACT-MODE)
)
(if (= coin1 FALSE)
(gimp-image-remove-layer image flare1-layer)
)
(if (= color2 1)
(gimp-layer-set-mode flare2-layer GRAIN-EXTRACT-MODE)
)
(if (= coin2 FALSE)
(gimp-image-remove-layer image flare2-layer)
)
(if (= color3 0)
(gimp-layer-set-mode flare3-layer GRAIN-EXTRACT-MODE)
)
(if (= coin3 FALSE)
(gimp-image-remove-layer image flare3-layer)
)
(if (= color4 1)
(gimp-layer-set-mode flare4-layer GRAIN-EXTRACT-MODE)
)
(if (= coin4 FALSE)
(gimp-image-remove-layer image flare4-layer)
)

;;--------------------------------------------------

(gimp-image-add-layer image uni-layer -1)
(gimp-edit-clear uni-layer)
(plug-in-solid-noise 1 image uni-layer 0 turb 0 detail taille-x taille-y)
(if (= mode 0)
(gimp-layer-set-mode uni-layer DIVIDE-MODE)
)
(if (= mode 1)
(gimp-layer-set-mode uni-layer GRAIN-EXTRACT-MODE)
)
(if (= mode 2)
(gimp-layer-set-mode uni-layer SUBTRACT-MODE)
)

;;--------------------------------------------------

(if (= conserv FALSE)
(gimp-image-flatten image)
)

;; mise a jour
	(gimp-display-new image)

	
	;;remettre toutes les outils comme au debut
	(gimp-palette-set-foreground old-fg)
	(gimp-gradients-set-gradient old-deg)

  )
)


;; registre 
(script-fu-register "script-fu-luminescence-reflet"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Luminescence +/Reflet 1.0"
		    "Genere une texture, effet de lumiere : reflet d'eau. abcdugimp.free.fr"
		    "Expression"
		    "Free"
		    "25/10/2004"
		    ""
	SF-ADJUSTMENT _"Width" '(512 10 1024 1 100 0 0)
	SF-ADJUSTMENT _"Height" '(384 10 768 1 100 0 0)
	SF-OPTION "Lumiere blanche dans les coins" '("Peu" "Beaucoup")
	SF-TOGGLE "Coin superieur droit ?" FALSE
	SF-OPTION "Couleur du reflet" '("Rouge" "Bleu")
	SF-TOGGLE "Coin inferieur droit ?" FALSE
	SF-OPTION "Couleur du reflet" '("Rouge" "Bleu")
	SF-TOGGLE "Coin inferieur gauche ?" TRUE
	SF-OPTION "Couleur du reflet" '("Bleu" "Rouge")
	SF-TOGGLE "Coin superieur gauche ?" TRUE
	SF-OPTION "Couleur du reflet" '("Rouge" "Bleu")
	SF-ADJUSTMENT "Taille X" '(16 0.1 16 0.1 1 1 0)
	SF-ADJUSTMENT "Taille Y" '(4 0.1 16 0.1 1 1 0)
	SF-TOGGLE "Turbulent ?" TRUE
	SF-ADJUSTMENT "Detail" '(1 1 15 1 4 0 1)
	SF-OPTION "Mode de calque du brouillage" '("Diviser" "Extraction" "Soustraction")
	SF-TOGGLE "Conserver les calques ?" FALSE
)
;; ---------------------------------------------------------
;; * 		         Script-Fu reflet v1.0		     *
;; ----END--------------------------------------------------




;; ---------------------------------------------------------
;; *									     *
;; * 		         Script-Fu volute v1.0		     *
;; *							   		     *
;; ---------------------------------------------------------

(define (apply-luminescence-volute
				image
				image-width image-height
				type 
				taille-x taille-y turb detail
				conserv
				)


;; init generale
    (let* (
	;; creation des calques
	(uni-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Brouillage uni" 100 NORMAL))) ;; 
	(deg-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Degrade" 100 NORMAL))) ;;
	)

	;; add layer
	(gimp-image-add-layer image uni-layer -1)
	(gimp-image-add-layer image deg-layer -1)
	
	

;; init calques ;; vider les calques pour qu'il n'y est pas de trace indesirable
(gimp-edit-clear deg-layer)
	


;;--------------------------------------------------
;;			base
;;--------------------------------------------------

;; regler le degrade en cours et le mode de calque suivant l'option "type"
;; <-------------- degrade
(if (= type 0)
	(begin
		(gimp-gradients-set-gradient "Golden")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 1)
	(begin
		(gimp-gradients-set-gradient "Horizon 2")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 2)
	(begin
		(gimp-gradients-set-gradient "Incandescent")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 3)
	(begin
		(gimp-gradients-set-gradient "Incandescent")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer HARDLIGHT-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 4)
	(begin
		(gimp-gradients-set-gradient "Metallic Something")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 5)
	(begin
		(gimp-gradients-set-gradient "Deep Sea")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 6)
	(begin
		(gimp-gradients-set-gradient "Crown molding")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 (/ image-height 4) 0 (* (/ image-height 4) 3))
	)
)
(if (= type 7)
	(begin
		(gimp-gradients-set-gradient "Browns")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 8)
	(begin
		(gimp-gradients-set-gradient "Wood 1")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 9)
	(begin
		(gimp-gradients-set-gradient "Yellow Orange")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)
	)
)
(if (= type 10)
	(begin
		(gimp-gradients-set-gradient "Three bars sin")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 4 100 0 0 FALSE FALSE 0 0 FALSE (/ image-width 2) (/ image-height 2) 0 image-height) ;; symetrique
	)
)
(if (= type 11)
	(begin
		(gimp-gradients-set-gradient "Three bars sin")
		(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-edit-blend deg-layer 3 0 5 100 0 0 FALSE FALSE 0 0 FALSE (/ image-width 2) (/ image-height 2) 0 image-height) ;; assymetrique
	)
)
;; ------------->

;; <--------------- pattern
(if (= type 12)
	(begin
		(gimp-patterns-set-pattern "Burlwood")
		(gimp-drawable-set-name deg-layer (car (gimp-patterns-get-pattern)))
		(gimp-layer-set-mode deg-layer GRAIN-EXTRACT-MODE)
	(gimp-drawable-fill deg-layer 4)
	)
)
(if (= type 13)
	(begin
		(gimp-patterns-set-pattern "Burlwood")
		(gimp-drawable-set-name deg-layer (car (gimp-patterns-get-pattern)))
		(gimp-layer-set-mode deg-layer DODGE-MODE)
	(gimp-drawable-fill deg-layer 4)
	)
)
(if (= type 14)
	(begin
		(gimp-patterns-set-pattern "Craters")
		(gimp-drawable-set-name deg-layer (car (gimp-patterns-get-pattern)))
		(gimp-layer-set-mode deg-layer GRAIN-EXTRACT-MODE)
	(gimp-drawable-fill deg-layer 4)
	)
)
(if (= type 15)
	(begin
		(gimp-patterns-set-pattern "Ice")
		(gimp-drawable-set-name deg-layer (car (gimp-patterns-get-pattern)))
		(gimp-layer-set-mode deg-layer DIFFERENCE-MODE)
	(gimp-drawable-fill deg-layer 4)
	)
)
;; ----------->

;;--------------------------------------------------

(if (= conserv FALSE)
	(gimp-drawable-set-name uni-layer (string-append "Volute numero " (number->string type)))
)
(plug-in-solid-noise 1 image uni-layer 0 turb 0 detail taille-x taille-y)

;;--------------------------------------------------


(if (= conserv FALSE)
	(gimp-image-merge-down image deg-layer 0)
)

   )
)



(define (script-fu-luminescence-volute
				image-width image-height
				type 
				taille-x taille-y turb detail
				conserv
				)

(let* (
	;; conserver les outils dans des variables
	(old-deg (car (gimp-gradients-get-gradient)))
	(old-pat (car (gimp-patterns-get-pattern)))

	;; creation de l'image
	(image (car (gimp-image-new image-width image-height RGB)))
	)

	(apply-luminescence-volute
				image
				image-width image-height
				type 
				taille-x taille-y turb detail
				conserv)


;; mise a jour
	(gimp-display-new image)
	;;remettre toutes les outils comme au debut
	(gimp-gradients-set-gradient old-deg)
	(gimp-patterns-set-pattern old-pat)

   )
)

;; registre 
(script-fu-register "script-fu-luminescence-volute"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Luminescence +/Volute 1.0"
		    "Genere une texture, effet de lumiere : volute. abcdugimp.free.fr"
		    "Expression"
		    "Free"
		    "27/10/2004"
		    ""
	SF-ADJUSTMENT _"Width" '(256 10 1024 1 100 0 0)
	SF-ADJUSTMENT _"Height" '(256 10 768 1 100 0 0)
	SF-OPTION "Type" '("0 - Or" "1 - Bleu symetrique" "2 - Feu et fumee" "3 - Feu" "4 - Froid" "5 - Flamme bleue" "6 - Barre" "7 - Flamme brune" "8 - Orange" "9 - Orange vif" "10 - Etoile 8" "11 - Etoile 3" "12 - Ocean" "13 - Volcan" "14 - Pierre" "15 - Eau")
	SF-ADJUSTMENT "Taille X" '(5 0.1 16 0.1 1 1 0)
	SF-ADJUSTMENT "Taille Y" '(5 0.1 16 0.1 1 1 0)
	SF-TOGGLE "Turbulent ?" TRUE
	SF-ADJUSTMENT "Detail" '(1 1 15 1 4 0 1)
	SF-TOGGLE "Conserver les calques ?" FALSE
)
;; ---------------------------------------------------------
;; * 		         Script-Fu volute v1.0		     *
;; ----END--------------------------------------------------




;; ---------------------------------------------------------
;; *									     *
;; * 		    Script-Fu volute abstraite v1.0	     	     *
;; *							   		     *
;; ---------------------------------------------------------

(define (apply-luminescence-volute-abstract
				image
				image-width image-height
				mode1 degrade 
				mode2 taille-x taille-y turb detail
				conserv
				)


;; init generale
    (let* (
	;; creation des calques
	(uni-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Brouillage uni" 100 NORMAL))) ;; 
	(deg-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Degrade" 100 NORMAL))) ;;
	)

	;; add layer
	(gimp-image-add-layer image uni-layer -1)
	
	
;; init calques ;; vider les calques pour qu'il n'y est pas de trace indesirable
(gimp-edit-clear deg-layer)
	


;;--------------------------------------------------
;;			base
;;--------------------------------------------------

;;--------------------------------------------------

(plug-in-solid-noise 1 image uni-layer 0 turb 0 detail taille-x taille-y)

(set! uni2-layer (car (gimp-layer-new-from-drawable uni-layer image))) ;; dupliquer
(gimp-image-add-layer image uni2-layer -1)
(gimp-drawable-set-name uni2-layer "Brouillage uni psychadelique")
(gimp-layer-set-mode uni2-layer mode2)
(plug-in-alienmap 1 image uni2-layer 128 80 0 0 2 2) ;; psychadelique

(if (= conserv FALSE)
	(gimp-drawable-set-name uni-layer (string-append "Volute abstraite " degrade))
)

;;--------------------------------------------------

;; regler le degrade en cours et le mode de calque
	(gimp-image-add-layer image deg-layer -1)
	(gimp-gradients-set-gradient degrade)
	(gimp-drawable-set-name deg-layer (car (gimp-gradients-get-gradient)))
	(gimp-layer-set-mode deg-layer mode1)
	(gimp-edit-blend deg-layer 3 0 0 100 0 0 FALSE FALSE 0 0 FALSE 0 0 0 image-height)


(if (= conserv FALSE)
	(begin
		(gimp-image-merge-down image uni2-layer 0)
		(gimp-image-merge-down image deg-layer 0)
	)
)

   )
)



(define (script-fu-luminescence-volute-abstract
				image-width image-height
				degrade 
				taille-x taille-y turb detail
				conserv
				)

(let* (
	;; conserver les outils dans des variables
	(old-deg (car (gimp-gradients-get-gradient)))

	;; creation de l'image
	(image (car (gimp-image-new image-width image-height RGB)))
	)
	
	(apply-luminescence-volute-abstract
				image
				image-width image-height
				DIFFERENCE-MODE degrade
				ADDITION-MODE taille-x taille-y turb detail
				conserv)


;; mise a jour
	(gimp-display-new image)
	;;remettre toutes les outils comme au debut
	(gimp-gradients-set-gradient old-deg)

   )
)

;; registre 
(script-fu-register "script-fu-luminescence-volute-abstract"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Luminescence +/Volute abstraite 1.0"
		    "Genere une texture, effet de lumiere : volute abstraite. abcdugimp.free.fr"
		    "Expression"
		    "Free"
		    "27/10/2004"
		    ""
	SF-ADJUSTMENT _"Width" '(256 10 1024 1 100 0 0)
	SF-ADJUSTMENT _"Height" '(256 10 768 1 100 0 0)
	SF-GRADIENT _"Gradient" "Golden"
	SF-ADJUSTMENT "Taille X" '(5 0.1 16 0.1 1 1 0)
	SF-ADJUSTMENT "Taille Y" '(5 0.1 16 0.1 1 1 0)
	SF-TOGGLE "Turbulent ?" TRUE
	SF-ADJUSTMENT "Detail" '(1 1 15 1 4 0 1)
	SF-TOGGLE "Conserver les calques ?" FALSE
)
;; ---------------------------------------------------------
;; * 		    Script-Fu volute abstraite v1.0	     	     *
;; ----END--------------------------------------------------


;; ---------------------------------------------------------
;; *									     *
;; * 		    Script-Fu Entrelacs v1.0	     	     *
;; *							   		     *
;; ---------------------------------------------------------

(define (apply-luminescence-entrelats
				image
				nom
				repoussage
				color
				image-width image-height
				taille-x taille-y turb detail
				mode2 mode1
				conserv
				)


;; init generale
    (let* (
	;; creation des calques
	(uni-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Brouillage uni 1" 100 NORMAL))) ;; 
	(fond-layer (car (gimp-layer-new image image-width image-height RGBA-IMAGE "Fond" 100 NORMAL))) ;;
	)

	;; add layer
	(gimp-image-add-layer image fond-layer -1)
	(gimp-image-add-layer image uni-layer -1)
	
	
;; init calques ;; vider les calques pour qu'il n'y est pas de trace indesirable
(gimp-edit-clear uni-layer)
	


;;--------------------------------------------------
;;			base
;;--------------------------------------------------

(gimp-palette-set-foreground color)
(gimp-edit-fill fond-layer 0)

;;--------------------------------------------------

(plug-in-solid-noise 1 image uni-layer 0 turb 0 detail taille-x taille-y)

(set! uni2-layer (car (gimp-layer-new-from-drawable uni-layer image))) ;; dupliquer
(gimp-image-add-layer image uni2-layer -1)
(gimp-drawable-set-name uni2-layer "Brouillage uni 2")

;;--------------------------------------------------
;; mode de calque

(if (= mode2 0) (set! m2 DIFFERENCE-MODE))
(if (= mode2 1) (set! m2 SUBTRACT-MODE))
(if (= mode2 2) (set! m2 GRAIN-EXTRACT-MODE))
(if (= mode2 3) (set! m2 DIVIDE-MODE))

(if (= mode1 0) (set! m1 DIFFERENCE-MODE))
(if (= mode1 1) (set! m1 SUBTRACT-MODE))
(if (= mode1 2) (set! m1 GRAIN-EXTRACT-MODE))

(gimp-layer-set-mode uni-layer m1)
(gimp-layer-set-mode uni2-layer m2)

;;--------------------------------------------------
;; repoussage
(if (= repoussage TRUE)
	(begin
		(plug-in-emboss 1 image uni2-layer 45 90 70 1) ;; repoussage
		(gimp-layer-set-mode uni2-layer DIVIDE-MODE)
		(gimp-layer-set-mode uni-layer VALUE-MODE)
	)
)

;;--------------------------------------------------


(if (= conserv FALSE)
	(begin
		(gimp-image-merge-down image uni-layer 0)
		(set! layer (car (gimp-image-merge-down image uni2-layer 0)))
		(gimp-drawable-set-name layer nom)
	)
)

   )
)



(define (script-fu-luminescence-entrelats
				repoussage
				color
				image-width image-height
				taille-x taille-y turb detail
				mode2 mode1
				conserv
				)

(let* (
	;; conserver les outils dans des variables
	(old-fg (car (gimp-palette-get-foreground)))

	;; creation de l'image
	(image (car (gimp-image-new image-width image-height RGB)))
	)
	
	(apply-luminescence-entrelats
				image
				"Effet entrelacs"
				repoussage
				color
				image-width image-height
				taille-x taille-y turb detail
				mode2 mode1
				conserv)


;; mise a jour
	(gimp-display-new image)
	;;remettre toutes les outils comme au debut
	(gimp-palette-set-foreground old-fg)

   )
)

;; registre 
(script-fu-register "script-fu-luminescence-entrelats"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Luminescence +/Entrelacs 1.0"
		    "Genere une texture, effet de lumiere : entrelacs. abcdugimp.free.fr"
		    "Expression"
		    "Free"
		    "07/11/2004"
		    ""
	SF-TOGGLE "Repoussage ? (annule les modes de calque)" FALSE
	SF-COLOR "Couleur - Il est conseille de ne faire
		    varier que la teinte et la saturation" '(33 100 58)
	SF-ADJUSTMENT _"Width" '(256 10 1024 1 100 0 0)
	SF-ADJUSTMENT _"Height" '(256 10 768 1 100 0 0)
	SF-ADJUSTMENT "Taille X" '(8 0.1 16 0.1 1 1 0)
	SF-ADJUSTMENT "Taille Y" '(8 0.1 16 0.1 1 1 0)
	SF-TOGGLE "Turbulent ?" TRUE
	SF-ADJUSTMENT "Detail" '(1 1 15 1 4 0 1)
	SF-OPTION "Mode de calque Brouillage uni 2" '("0 - Difference" "1 - Soustraction" "2 - Extraction de grain" "3 - Diviser")
	SF-OPTION "Mode de calque Brouillage uni 1" '("0 - Difference" "1 - Soustraction" "2 - Extraction de grain")
	SF-TOGGLE "Conserver les calques ?" FALSE
)
;; ---------------------------------------------------------
;; * 		    Script-Fu Entrelacs v1.0	     	     *
;; ----END--------------------------------------------------

