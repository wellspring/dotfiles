; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; A marble effect  for GIMP 1.2
; Copyright (C) 2001 Laetitia Marin titix@gimpforce.org
; Copyright (C) 2001 Ostertag Raymond coordinateur@gimp-fr.org
;
; --------------------------------------------------------------------
; version 0.1 2001-september-01
;     - Initial relase
; version 0.2 2004/09
;     - Ported to Gimp2
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
; d'aprés le didacticiel d'alastair : marble 
;
; Au depart : une selection dans une image ou un calque dont la partie transparente sera transformée
; en sélection
;
; Fonctionnement : choisir les seuils de piquage comme dans le script corrosion, et choisir la couleur du plasma a l'invite, pour donner la couleur dominante du marbre.
;
; Paramètres et réglages
; - pas de grille: limité entre 2 et 20, si vous souhaitez un pas plus grand modifiez le script à la
; rubrique valeurs limites des paramètres
; - seuil pour la selection fuzzy, gère la taille de la sélection pour chaque piquage
; - seuil pour la sélection par couleur, gère la taille de la sélection aléatoire pour chaque piquage
;
; les calques sont laissés intacts pour un ajustement manuel des modes de fusion.

(define (script-fu-marbre img calque picker_spacing picker_treshold picker_turbulence)
  (let* ((sizeX (car (gimp-image-width img)))
	 (sizeY (car (gimp-image-height img)))
	 
	 (fond
	  (car
	   (gimp-layer-new img sizeX sizeY RGBA-IMAGE "fond" 100 NORMAL-MODE)))
	 
	 (calque0
	  (car
	   (gimp-layer-new img sizeX sizeY RGBA-IMAGE "plasma" 100 NORMAL-MODE)))

	 (calque1
	  (car
	   (gimp-layer-new img sizeX sizeY RGBA-IMAGE "plasma" 100 NORMAL-MODE)))

	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background)))
	 (blanc '(255 255 255)))

    ;; initialisation undo
    (gimp-image-undo-group-start img)

    (gimp-selection-all img)
      
    ;; valeurs limites des paramètres
    (while (< picker_spacing 2)
        (begin (set! picker_spacing (+ picker_spacing 1))))
    (while (> picker_spacing 20)
        (begin (set! picker_spacing (- picker_spacing 1))))


    ;; calque fond blanc
    (gimp-image-add-layer img fond 0)
    (gimp-palette-set-foreground blanc)
    (gimp-edit-fill fond FOREGROUND-FILL)

    ;; calque plasma
    (gimp-image-add-layer img calque0 0)
    (set! seed (rand 30000))
    (plug-in-plasma TRUE img calque0 seed 2.5)

    ;; installation du calque 1 avec son plasma
    (gimp-image-add-layer img calque1 0)
    (set! seed (rand 30000))
    (plug-in-plasma TRUE img calque1 seed 2.5)
    (plug-in-rotate-colormap FALSE img calque1)

     ;; plasma 2
     (let* ((calque2 (car (gimp-layer-copy calque1 TRUE)))
	    (masque2 (car (gimp-layer-create-mask calque2 1))))

       ;; installation du calque 2 copie du 1
       (gimp-image-add-layer img calque2 0)
       (gimp-layer-add-mask calque2 masque2)
      
       (gimp-layer-set-opacity calque2 60)
       (gimp-layer-set-opacity calque1 30)
       (gimp-layer-set-opacity calque0 15)

       ;; installation du calque lave
       ;; deplacement des niveaux et copie dans un masque
       (script-fu-lava img fond 10 10 7 "Default" TRUE TRUE FALSE)
       
       (let* ((layers (gimp-image-get-layers img))
	      (layers-nb (car layers))
	      (layers-list (cadr layers)))
	 (begin 
	   (while (> layers-nb 0)
		  (let ((lava (aref layers-list (- layers-nb 1))))
		    (if (equal? (car (gimp-drawable-get-name lava)) "Lava Layer")
			(begin
			  (gimp-levels lava 0 169 241 1 0 255)
			  (gimp-edit-cut lava)
			  (gimp-image-remove-layer img lava)			  
			  (gimp-floating-sel-anchor 
			   (car (gimp-edit-paste masque2 TRUE)))))
		    (set! layers-nb (- layers-nb 1))))))
       
       ;; piquer dans le plasma 0
      (gimp-selection-clear img)
      (let ((y (/ sizeY picker_spacing)))
	(while (< y sizeY)
	       (begin
		 (let ((x (/ sizeX picker_spacing)))
		   (while (< x sizeX)
			  (begin
			    (gimp-fuzzy-select calque0 x y picker_treshold CHANNEL-OP-ADD TRUE FALSE 0 FALSE)
			    (set! pick_color (car (gimp-image-pick-color img calque0 x y FALSE FALSE 10 FALSE)))
			    (gimp-by-color-select calque0 pick_color picker_turbulence 0 FALSE FALSE 15 FALSE)
			    (set! x (+ x (/ sizeX picker_spacing))))))
		 (set! y (+ y (/ sizeY picker_spacing))))))

      ;; remplir de blanc le calque 0
      (gimp-selection-invert img)
      (gimp-palette-set-foreground blanc)
      (gimp-edit-fill calque0 FOREGROUND-FILL)
      (gimp-desaturate calque0)
      (gimp-selection-none img)
      (plug-in-gauss-iir2 TRUE img calque0 5 5)

      ;; retour a la couleur et affichage
      (gimp-palette-set-foreground old-fg)
      (gimp-palette-set-background old-bg)
      (gimp-image-undo-group-end img)
      (gimp-displays-flush))))

(script-fu-register "script-fu-marbre"
		    _"<Image>/Script-Fu/Render/Marble..."
		    "alastair effect : effet de marbre"
		    "titix et raymond"
		    "2001, titix et raymond"
		    "22 SEPTEMBRE 2001"
		    ""
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
                    SF-VALUE "Pas de grille du piquage [2-20]" "5"
                    SF-VALUE "Seuil du piquage" "30"
                    SF-VALUE "Turbulence du piquage" "30")


