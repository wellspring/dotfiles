; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; A set of layer effects script  for GIMP 1.2
; Copyright (C) 2001 Laetitia Marin titix@gimpforce.org
; Copyright (C) 2001 Ostertag Raymond coordinateur@gimp-fr.org
;
; --------------------------------------------------------------------
; version 0.1 2001-september-01
;     - Initial relase
; version 0.2 2004/09 Raymond Ostertag
;     - Ported to Gimp2
;     - Changed menu entry
; --------------------------------------------------------------------
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
; --------------------------------------------------------------------
;
; This is the French version you'll find the official English version at http://gug.sunsite.dk/scripts.php
;
; Ceci est la version française vous trouverez une version anglaise officielle à http://gug.sunsite.dk/scripts.php
;
; Script-fu corrosion d'aprés le didacticiel de Ron Scott : Scott Effect ( vf sur gimp-fr )
;
; Au depart : une selection dans une image ou un calque dont la partie transparente sera transformée
; en sélection
;
; Fonctionnement : voir documentation sur gimp-fr
;
; Paramètres et réglages
; - pas de grille: limité entre 2 et 20, si vous souhaitez un pas plus grand modifiez le script à la
; rubrique valeurs limites des paramètres
; - seuil pour la selection fuzzy, gère la taille de la sélection pour chaque piquage
; - seuil pour la sélection par couleur, gère la taille de la sélection aléatoire pour chaque piquage
; - profondeur du relief.
;
; les calques sont laissés intacts pour un ajustement manuel des modes de fusion.

(define (script-fu-corrosion img calque0 picker_spacing picker_treshold picker_turbulence bumpmap_depth)
  (let* ((sizeX (car (gimp-image-width img)))
	(sizeY (car (gimp-image-height img)))
	(calque1
	 (car
	  (gimp-layer-new img sizeX sizeY RGBA-IMAGE "plasma" 100 OVERLAY-MODE)))
        (masque1
         (car
          (gimp-layer-create-mask calque1 1)))
	(old-fg (car (gimp-palette-get-foreground)))
	(old-bg (car (gimp-palette-get-background)))
        (blanc '(255 255 255))
        )

    ; initialisation undo
    (gimp-image-undo-group-start img)

    ; valeurs limites des paramètres
    (while (< picker_spacing 2)
        (begin (set! picker_spacing (+ picker_spacing 1))))
    (while (> picker_spacing 20)
        (begin (set! picker_spacing (- picker_spacing 1))))

    ; installation du calque 1
    (gimp-image-add-layer img calque1 0)
    (gimp-layer-add-mask calque1 masque1)

    ; plasma
    (set! seed (* picker_treshold picker_turbulence))
    (plug-in-plasma TRUE img calque1 seed 2.5)
    (let* ((calque2 (car (gimp-layer-copy calque1 TRUE)))
	   (masque2 (car (gimp-layer-get-mask calque2))))

    ; installation du calque 2
      (gimp-image-add-layer img calque2 0)
      
    ; remplissage des masques de calque
      (gimp-palette-set-foreground blanc)
      (set! activ_selection (car (gimp-selection-is-empty img)))
      (cond
       ((= activ_selection 0) ; selection activ
	(gimp-edit-bucket-fill masque1 0 0 100 0 FALSE 0 0)
	(gimp-edit-bucket-fill masque2 0 0 100 0 FALSE 0 0)
	(gimp-selection-none img))
       ((= activ_selection 1) ; no selection activ
	(gimp-selection-layer-alpha calque0)
	(gimp-edit-bucket-fill masque1 0 0 100 0 FALSE 0 0)
	(gimp-edit-bucket-fill masque2 0 0 100 0 FALSE 0 0)
	)
       ) ; end of cond
      
    ; piquer dans le plasma
      (gimp-selection-clear img)
      (let ((y (/ sizeY picker_spacing)))
	(while (< y sizeY)
	       (begin
		 (let ((x (/ sizeX picker_spacing)))
		   (while (< x sizeX)
			  (begin
			    (gimp-fuzzy-select calque1 x y picker_treshold CHANNEL-OP-ADD TRUE FALSE 0 FALSE)
			    (set! pick_color (car (gimp-image-pick-color img calque1 x y FALSE FALSE 10 FALSE)))
			    (gimp-by-color-select calque1 pick_color picker_turbulence 0 FALSE FALSE 15 FALSE)
			    (set! x (+ x (/ sizeX picker_spacing))))))
		 (set! y (+ y (/ sizeY picker_spacing))))))

    ; nettoyer et remplir les calques 1 et 2
      (gimp-selection-invert img)
      (gimp-edit-clear calque1)
      (gimp-edit-clear calque2)
      (gimp-selection-clear img)
      (gimp-desaturate calque1)
      (gimp-desaturate calque2)
      
    ; bumpmap sur le calque2
      (plug-in-bump-map TRUE img calque2 calque2 135 45 bumpmap_depth 0 0 0 0 TRUE FALSE GRADIENT-LINEAR)
      
    ; retour a la couleur et affichage
      (gimp-palette-set-foreground old-fg)
      (gimp-palette-set-background old-bg)
      (gimp-image-undo-group-end img)
      (gimp-displays-flush))))

(script-fu-register "script-fu-corrosion"
		    _"<Image>/Script-Fu/Alchemy/Corrosion..."
		    "Scott-effect : effet de corrosion"
		    "titix et raymond"
		    "2001, titix et raymond"
		    "01 SEPTEMBRE 2001"
		    ""
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
                    SF-VALUE "Pas de grille du piquage [2-20]" "5"
                    SF-VALUE "Seuil du piquage" "30"
                    SF-VALUE "Turbulence du piquage" "30"
                    SF-VALUE "Relief" "10")

