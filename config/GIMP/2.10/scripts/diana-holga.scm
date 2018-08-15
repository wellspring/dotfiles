; diana-holga
; 21, 22, 23, 24, 25, 28, 29, 9 d'ecembre 2005, 15, 18 mars 2007

(script-fu-register "diana-holga"
	"<Image>/~jps/diana-holga"

"This script-fu for The Gimp simulates the Diana/Holga Toys Cameras effect.
Last version can be found at:
http://jpsn.free.fr/photo/contrefacons/diana-holga.scm.

Ce script-fu pour The Gimp simule l'effet Toy Camera Diana/Holga.
La derni`ere version peut ^etre obtenue `a:
http://jpsn.free.fr/photo/contrefacons/diana-holga.scm."

	"Jean-Pierre Sutto <jpsmail(at)free.fr>"
	"(c) Jean-Pierre Sutto. This is GPL Free Software."
	"18 mars 2007"
	"*"

	SF-IMAGE "Image" 0
	SF-DRAWABLE "Drawable" 0
	SF-ADJUSTMENT "Stretch/Etirement" '(2 0 5 1 1 0 0)
	SF-ADJUSTMENT "Zoom/Zoom" '(2 0 5 1 1 0 0)
	SF-ADJUSTMENT "Contrast/Contraste" '(20 0 100 1 10 0 0)
	SF-ADJUSTMENT "Vignetting/Vignettage" '(80 0 100 1 10 0 0)
	SF-ADJUSTMENT "Blur/Brouillage" '(2 0 5 1 1 0 0)
	SF-TOGGLE "Mask/Masque" TRUE
)

(define
	(diana-holga
		VarImage
		VarDrawable
		VarAngle
		VarZoom
		VarContraste
		VarVignettage
		VarBrouillage
		VarMasque
	)
	(let*
		(
			(VarLargeur (car (gimp-image-width VarImage)))
			(VarHauteur (car (gimp-image-height VarImage)))
			(VarCentreX (/ VarLargeur 2))
			(VarCentreY (/ VarHauteur 2))
			(VarDiagonale
				(sqrt (+ (* VarLargeur VarLargeur) (* VarHauteur VarHauteur)))
			)
			(VarCalque (car (gimp-layer-new
				VarImage
				VarLargeur
				VarHauteur
				1 ; type
				"Calque" ; nom
				VarVignettage ; opacit'e
				MULTIPLY-MODE
			)))
			(VarGris (car (gimp-drawable-is-gray VarDrawable)))
;			(VarLuminosite (* VarContraste .5))
			(VarLuminosite 0)
;			(VarSaturation (* VarLuminosite .3))
			(VarSaturation VarContraste)
			(VarMarge (* .008 VarDiagonale))
			(VarCorAngle (/ VarAngle 100))
			(VarCropLargeur (* VarCorAngle VarLargeur 1.8))
			(VarCropHauteur (* VarCorAngle VarHauteur 1.8))
			(VarCorBrouillage (* VarBrouillage 10))
			(VarFakeArray (cons-array 256 'byte))
			(VarZoomTrunc (trunc VarZoom))
		)

		; d'ebut groupe d'annulation
		(gimp-undo-push-group-start VarImage)

		; r'ecup'eration des couleurs de fond et plume
		(set! VarForeOrigine (car (gimp-context-get-foreground)))
		(set! VarBackOrigine (car (gimp-context-get-background)))

		; conversion en rgb si gris
		(if (= VarGris TRUE)
			(begin
			(gimp-image-convert-rgb VarImage)
			)
		)

		; distorsion selon une courbe
		(if (> VarAngle 0)
			(begin
				(plug-in-curve-bend
					1 ; 1: run_mode
					VarImage ; 2: image
					VarDrawable ; 3: drawable
					0 ; 4: rotation
					TRUE ; 5: smoothing
					TRUE ; 6: antialias
					FALSE ; 7: work_on_copy
					0 ; 8: curve_type
					3 ; 9: argc_upper_point_x
					(float-array 0 .5 1) ; 10: upper_point_x
					3 ; 11: argc_upper_point_y
					(float-array .5 (- .5 VarCorAngle) .5) ; 12: upper_point_y
					3 ; 13: argc_lower_point_x
					(float-array 0 .5 1) ; 14: lower_point_x
					3 ; 15: argc_lower_point_y
					(float-array .5 (+ .5 VarCorAngle) .5) ; 16: lower_point_y
					256 ; 17: argc_upper_val_y
					VarFakeArray ; 18: upper_val_y
					256 ; 19: argc_lower_val_y
					VarFakeArray ; 20: lower_val_y
				)
				(plug-in-curve-bend
					1 ; 1: run_mode
					VarImage ; 2: image
					VarDrawable ; 3: drawable
					90 ; 4: rotation
					TRUE ; 5: smoothing
					TRUE ; 6: antialias
					FALSE ; 7: work_on_copy
					0 ; 8: curve_type
					3 ; 9: argc_upper_point_x
					(float-array 0 .5 1) ; 10: upper_point_x
					3 ; 11: argc_upper_point_y
					(float-array .5 (- .5 VarCorAngle) .5) ; 12: upper_point_y
					3 ; 13: argc_lower_point_x
					(float-array 0 .5 1) ; 14: lower_point_x
					3 ; 15: argc_lower_point_y
					(float-array .5 (+ .5 VarCorAngle) .5) ; 16: lower_point_y
					256 ; 17: argc_upper_val_y
					VarFakeArray ; 18: upper_val_y
					256 ; 19: argc_lower_val_y
					VarFakeArray ; 20: lower_val_y
				)
				(gimp-displays-flush)
	
				; d'ecoupage du surplus
				(if (= VarMasque TRUE)
					(begin
						(set! VarCropLargeur (* VarCropLargeur .5))
						(set! VarCropHauteur (* VarCropHauteur .5))
					)
				)
				(gimp-image-crop
					VarImage
					(- VarLargeur (* VarCropLargeur 2))
					(- VarHauteur (* VarCropHauteur 2))
					VarCropLargeur
					VarCropHauteur
				)
				(gimp-displays-flush)
			)
		)

		; flou zoom cin'etique
		(if (> VarZoomTrunc 0)
			(begin
				(plug-in-mblur
					1 ; run_mode (noninteractive=1)
					VarImage ; image
					VarDrawable ; drawable
					2 ; type (zoom=2)
					VarZoomTrunc ; length (longueur)
					0 ; angle (inutile avec zoom)
					VarCentreX ; center_x
					VarCentreY ; center_y
					1 ; blur-outward
				)
				(gimp-displays-flush)
			)
		)

		; Vignettage
		(if (> VarVignettage 0)
			(begin
				(gimp-context-set-foreground '(0 0 0))
				(gimp-context-set-background '(255 255 255))
				(gimp-image-add-layer VarImage VarCalque -1)
				(gimp-drawable-fill VarCalque WHITE-FILL)
				(gimp-edit-blend
					VarCalque; drawable
					FG-BG-RGB-MODE ; blend_mode
					NORMAL ; paint_mode
					GRADIENT-RADIAL ; gradient_type
					100 ; opacity
					0 ; offset
					REPEAT-NONE ; repeat
					TRUE ; reverse
					0 ; supersample
					0 ; max_depth
					0 ; threshold
					TRUE ; dither
					VarCentreX ; x1
					VarCentreY ; y1
					(* VarLargeur .9) ; x2
					(* VarHauteur .9) ; y2
				)
				(gimp-image-flatten VarImage)
				; WARNING: gimp-edit-blend change le Drawable !
				(set! VarDrawable (car (gimp-image-get-active-drawable VarImage)))
				(gimp-displays-flush)
			)
		)

		; Luminosit'e / Contraste
		(if (> VarContraste 0)
			(begin
				(if (= VarGris TRUE)
					(begin
						(gimp-levels-stretch VarDrawable)
					)
				)
				(if (= VarGris FALSE)
					(begin
						(gimp-hue-saturation
							VarDrawable
							0
							ALL-HUES
							VarLuminosite
							VarSaturation
						)
					)
				)
				(gimp-brightness-contrast VarDrawable 0 VarContraste)
				(gimp-displays-flush)
			)
		)

		; Brouiller
		(if (> VarBrouillage 0)
			(begin
				(plug-in-randomize-slur
					1 ; run_mode
					VarImage ; image
					VarDrawable ; drawable
					VarCorBrouillage ; mdm-pct
					1 ; r'ep'etition
					TRUE ; randomize
					0 ; seed
				)
				(gimp-displays-flush)
			)
		)

		; marge/masque
		(if (= VarMasque TRUE)
			(begin
				(script-fu-fuzzy-border
					;1 ; run_mode indiqu'e par erreur dans le navigateur !
					VarImage ; image
					VarDrawable ; drawable
					'(0 0 0) ; color
					VarMarge ; value, taille
					TRUE ; toggle, bord flou
					5 ; value, granularit'e
					FALSE; toggle, ombre
					0 ; value; poid de l'ombre
					FALSE ; toggle, travail copie
					TRUE ; toggle; aplatir l'image
				)
				(gimp-image-flatten VarImage)
				; WARNING: script-fu-fuzzy-border change le Drawable !
				(set! VarDrawable (car (gimp-image-get-active-drawable VarImage)))
				(gimp-displays-flush)
			)
		)

		; conversion en gris si origine gris
		(if (= VarGris TRUE)
			(begin
			(gimp-image-convert-grayscale VarImage)
			)
		)

		; Contraste / Normalisation : 2e passe
		(if (> VarContraste 0)
			(begin
				(gimp-levels-stretch VarDrawable)
			)
		)

		; reprise des couleurs fg et bg
		(gimp-context-set-foreground VarForeOrigine)
		(gimp-context-set-background VarBackOrigine)

		; fin groupe d'annulation
		(gimp-undo-push-group-end VarImage)

		; rafraichissement de l'affichage
		(gimp-displays-flush)

	)
)

(define float-array
	(lambda stuff
		(letrec ((kernel (lambda (array pos remainder)
			(if (null? remainder) array
				(begin
					(aset array pos (car remainder))
					(kernel array (+ pos 1) (cdr remainder))
				)
			))))
			(kernel (cons-array (length stuff) 'double) 0 stuff)
		)
	)
)
