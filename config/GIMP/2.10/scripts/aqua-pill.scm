;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; aqua-pill.scm
; Version 07.06.07 (For The Gimp 2.2) 07.06.2007
; A Script-Fu that create a 'Aqua Pill' Style Web Button
;
; Copyright (C) 2007 Marcos Pereira (majpereira) <majpereira@hotmail.com>
; ((C)2001 Iccii <iccii@hotmail.com>)
;----------------------------------------------------------------------------------
; Baseado no script:
; => 'aqua pill' versão de 06/2001 para o Gimp 1.2, de Iccii.
;----------------------------------------------------------------------------------
;
; This program is free software; you can redistribute it and/or 
; modify it under the terms of the GNU General Public License   
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;==================================================================================
; remove cantos da seleção (cantos desfocados)
(define (remove-selection-corner img amount)
      (gimp-selection-feather img amount)
      (gimp-selection-sharpen img))
;==================================================================================
;seleção na forma "pill" (pílula)
(define (round-select img x y width height ratio antialias)
    (let* ((diameter (* ratio height))
	(wimdiam (- width diameter)))
      (gimp-ellipse-select img x y diameter height 0 antialias 0 0)
      (gimp-ellipse-select img (+ x wimdiam) y diameter height 0 antialias 0 0)
      (gimp-rect-select img (+ x (/ diameter 2)) y wimdiam height 0 antialias 0)))
;==================================================================================
;início de "script-fu-aqua-pill"
(define (script-fu-aqua-pill img	; imagem
			     bg-color	; cor de fundo
			     width	; comprimento ou medida x
			     height	; altura ou medida y
			     xpadding	; espaçamento x
			     ypadding	; espaçamento y
			     ratio	; razão
			     blur	; opacidade
			     shadow	; sombra
			     flatten	; achatamento
			     antialias)	; suvavização
;----------------------------------------------------------------------------------
  (let* ( ;início das variáveis (I)
	(old-fg-color (car (gimp-context-get-foreground)))
	(old-bg-color (car (gimp-context-get-background)))
	(shadow-height (if (eqv? shadow TRUE) 1 0))
	(bluramount (if (> width height) (* blur height) (* blur width)))
	(shiftx (/ height 2))
	(shifty (/ height 2))
	(width-all (+ width  (* 2 shiftx)))
	(height-all (+ height (* 2 shifty) (* height shadow-height 0.5)))
	(whratio (sqrt (/ height width)))
	(highlight-upper1-layer (car (gimp-layer-new img width-all height-all 1 "Highlight Upper1"  75 4)))
	(highlight-upper2-layer (car (gimp-layer-new img width-all height-all 1 "Highlight Upper2"  40 4)))
	(highlight-lower (car (gimp-layer-new img width-all height-all 1 "Highlight Lower" 100 5)))
	(base1-layer (car (gimp-layer-new img width-all height-all 1 "Base Layer1"  75 4)))
	(base2-layer (car (gimp-layer-new img width-all height-all 1 "Base Layer2" 100 0)))
	) ; fim das variáveis (I)
;----------------------------------------------------------------------------------
	; ajusta as cores de fundo
	(gimp-image-undo-disable img)
	(gimp-selection-none img)
	(gimp-context-set-foreground bg-color)
	(gimp-context-set-background '(255 255 255))
	(gimp-drawable-fill base2-layer 3)
	(gimp-drawable-fill base1-layer 3)
	(gimp-drawable-fill highlight-lower 3)
	(gimp-drawable-fill highlight-upper2-layer 3)
	(gimp-drawable-fill highlight-upper1-layer 3)
;----------------------------------------------------------------------------------
; início do efeito de gota de sombra - "drop shadow"
	; 2 camadas transparentes para produzir o efeito
	(if (eqv? shadow TRUE)
	(begin
	(set! shadow1-layer (car (gimp-layer-new img width-all height-all 1 "Shadow Layer1" 100 4)))
	(set! shadow2-layer (car (gimp-layer-new img width-all height-all 1 "Shadow Layer2" 100 0)))
	(gimp-image-add-layer img shadow2-layer -1)
	(gimp-image-add-layer img shadow1-layer -1)
	(gimp-drawable-fill shadow2-layer 3)
	(gimp-drawable-fill shadow1-layer 3)

	; produz efeito penumbra com a cor selecionada na camada de baixo
	(round-select img shiftx shifty width height ratio antialias)
	(gimp-selection-shrink img (* height 0.1))
	(gimp-edit-fill shadow1-layer 0)
	(gimp-hue-saturation shadow1-layer 0 0 75 0)
	(gimp-selection-grow img (+ 1 (* bluramount 0.3))) ; expande a imagem selecionada em todas as direções
	(plug-in-gauss-iir2 1 img shadow1-layer (+ 1 (* bluramount 0.3)) (+ 1 (* bluramount 0.3)))
	(gimp-drawable-offset shadow1-layer 0 1 0 (* height 0.4))
	(gimp-selection-none img)

	; produz efeito penumbra com a cor selecionada na camada de cima
	(round-select img shiftx shifty width height ratio antialias)
	(gimp-edit-fill shadow2-layer 0)
	(gimp-hue-saturation shadow2-layer 0 0 0 -25)
	(gimp-selection-grow img (+ 1 (* bluramount 0.3))) ; expande a imagem selecionada em todas as direções
	(plug-in-gauss-iir2 1 img shadow2-layer (+ 1 (* bluramount 0.3)) (+ 1 (* bluramount 0.3)))
	(gimp-drawable-offset shadow2-layer 0 1 0 (* height 0.4))
	(gimp-selection-none img)))
; fim do efeito gota de sombra - "drop shadow"
;----------------------------------------------------------------------------------
; início da construção da pílula aqua
	; /////////desenho da rodela //////////
	; 2 camadas transparentes para desenhar rodela
	(gimp-image-add-layer img base2-layer -1)
	(gimp-image-add-layer img base1-layer -1)

	; desenha rodela de baixo sem efeito
	(round-select img shifty shifty width height ratio antialias)
	(gimp-edit-fill base2-layer 0)
	(gimp-hue-saturation base2-layer 0 0 -75 -50)
	(gimp-selection-shrink img (* height 0.01))

	; desenha rodela de cima com efeito nas bordas e semi transparente
	(gimp-edit-fill base1-layer 0)
	(gimp-hue-saturation base1-layer 0 0 -50 -50)
	(gimp-selection-grow img (* height 0.01))	; expande a imagem em todas as direções
	(plug-in-gauss-iir2 1 img base1-layer (+ 1 (* bluramount 0.05)) (+ 1 (* bluramount 0.05)))
	(gimp-selection-none img)

	; suaviza a borda da imagem de baixo
	(if (eqv? antialias TRUE)
		(let ((layer-width  (car (gimp-drawable-width  base2-layer)))
		(layer-height (car (gimp-drawable-height base2-layer))))
		(gimp-layer-scale base2-layer (* 2 layer-width) (* 2 layer-height) 0)
		(gimp-layer-scale base2-layer layer-width layer-height 0)))

	; /////////efeito de luz ou aqua na base da rodela //////////
	; camadas transparente para produzir o efeito de luz na base
	(set! highlight-lower-copy (car (gimp-layer-copy highlight-lower FALSE)))
	(gimp-image-add-layer img highlight-lower-copy -1)
	(gimp-image-add-layer img highlight-lower      -1)

	; efeito de luz na base da rodela
	(round-select img shifty shifty width height ratio antialias)
	(gimp-rect-select img shifty shifty width (* height 0.5) 1 0 0)
	(gimp-selection-shrink img (* height 0.05))
	(remove-selection-corner img (* 0.4 height))
	(gimp-edit-fill highlight-lower 1)
	(gimp-selection-grow img (+ 1 (* bluramount 0.4)))	; expande a imagem em todas as direções
	(plug-in-gauss-iir2 1 img highlight-lower (+ 1 (* bluramount 0.4)) (+ 1 (* bluramount 0.4)))
	(gimp-selection-none img)

	; /////////efeito de luz ou aqua no topo da rodela //////////
	; camadas transparente para produzir o efeito de luz no topo
	(gimp-image-add-layer img highlight-upper2-layer -1)

	; efeito de luz no topo da rodela
	(round-select img shiftx shifty width height ratio antialias)
	(gimp-rect-select img shiftx (+ shifty (* height 0.35)) width height 1 0 0)
	(gimp-selection-shrink img (* height 0.02 whratio))
	(remove-selection-corner img (+ (* height 0.4)))
	(gimp-edit-fill highlight-upper2-layer 1)
	(gimp-selection-grow img (+ 1 (* bluramount 0.08)))	; expande a imagem em todas as direções
	(plug-in-gauss-iir2 1 img highlight-upper2-layer (+ 1 (* bluramount 0.08)) (+ 1 (* bluramount 0.08)))
	(gimp-selection-none img)

	(gimp-image-add-layer img highlight-upper1-layer -1)
	(round-select img shiftx shifty width height ratio antialias)
	(gimp-rect-select img shiftx (+ shifty (* height 0.28)) width height 1 0 0)
	(gimp-selection-shrink img (* height 0.09))
	(remove-selection-corner img (* 0.15 height))
	(gimp-edit-fill highlight-upper1-layer 1)
	(gimp-selection-grow img (+ 1 (* bluramount 0.05)))	; ?
	(plug-in-gauss-iir2 1 img highlight-upper1-layer (+ 1 (* bluramount 0.05)) (+ 1 (* bluramount 0.05)))
	(gimp-selection-none img)

	; completa a imagem, achata conforme opção requerida e encerra o script
	(gimp-image-undo-enable img)
	(gimp-image-undo-group-start img)
	(if (eqv? flatten TRUE) (gimp-image-flatten img))
	(gimp-image-undo-group-end img)
	(gimp-context-set-foreground old-fg-color)
	(gimp-context-set-background old-bg-color)
	(gimp-display-new img)
	(gimp-displays-flush)
    ))
;==================================================================================
; produz rodela aqua pill
(define (script-fu-aqua-pill-round baseradius
				   bg-color
				   ratio
				   blur
				   shadow
				   flatten
				   antialias)
    (let* (
	(shadow-height (if (eqv? shadow TRUE) 1 0))
	(height baseradius)
	(radius (/ (* ratio height) 4))
	(width (+ 1 (* ratio  height)))
	(height-all (+ height height (* height shadow-height 0.5)))
	(width-all  (+ width  height))
	(img (car (gimp-image-new width-all height-all 0))))
	(script-fu-aqua-pill img bg-color width height 0 0 ratio blur shadow flatten antialias)
	))
;----------------------------------------------------------------------------------
(script-fu-register "script-fu-aqua-pill-round"
		    _"<Toolbox>/Xtns/Script-Fu/Web Page Themes/Aqua Pill/Round..."
		    "(en) Create a round aqua pill image \
(pt-BR) Cria uma imagem de 'rodela' 'aqua pill'"
		"Marcos Pereira <majpereira@hotmail.com>"
		"Marcos Pereira (majpereira)"
		"07.06.2007"
		    ""
		    SF-ADJUSTMENT "Base Radius (pixel)"	'(100 2 500 1 1 0 1)
		    SF-COLOR      "Background Color"	'(0 127 255)
		    SF-ADJUSTMENT "Round Ratio"		'(1 0.05 9 0.05 0.5 2 0)
		    SF-ADJUSTMENT "Blur Amount"		'(1 0.05 5 0.05 0.5 2 0)
		    SF-TOGGLE     "Drop Shadow"		TRUE
		    SF-TOGGLE     "Flatten"		TRUE
		    SF-TOGGLE     "Antialias"		TRUE)
;==================================================================================
; produz régua horizontal
(define (script-fu-aqua-pill-hrule width height bg-color ratio blur shadow flatten antialias)
;    (let* ((flatten TRUE)
    (let* ((shadow-height (if (eqv? shadow TRUE) 1 0))
	(height-all (+ height height (* height shadow-height 0.5)))
	(width-all  (+ width height))
	(img (car (gimp-image-new width-all height-all 0))))
	(gimp-message-set-handler 0)
	(if (< (* height ratio) width)
	(script-fu-aqua-pill img bg-color width height 0 0 ratio blur shadow flatten antialias)
	(gimp-message "Warning: Bar Length is too short to create your image!"))
    ))
;----------------------------------------------------------------------------------
(script-fu-register "script-fu-aqua-pill-hrule"
		    "<Toolbox>/Xtns/Script-Fu/Web Page Themes/Aqua Pill/Hrule..."
		    "(en) Create an Hrule with the 'aqua pill' image \
(pt-BR) Cria uma imagem de 'régua horizontal' 'aqua pill'"
		"Marcos Pereira <majpereira@hotmail.com>"
		"Marcos Pereira (majpereira)"
		"07.06.2007"
		    ""
		    SF-ADJUSTMENT "Bar Length"		'(500 2 1500 1 1 0 1)
		    SF-ADJUSTMENT "Bar Height"		'(25 2 500 1 1 0 1)
		    SF-COLOR      "Background Color"	'(0 127 255)
		    SF-ADJUSTMENT "Round Ratio"		'(1 0.05 5 0.05 0.5 2 0)
		    SF-ADJUSTMENT "Blur Amount"		'(1 0.05 5 0.05 0.5 2 0)
		    SF-TOGGLE     "Drop Shadow"		TRUE
		    SF-TOGGLE     "Flatten"		TRUE
		    SF-TOGGLE     "Antialias"		TRUE)
;==================================================================================
; produz botão aqua com texto
(define (script-fu-aqua-pill-button text
				    size
				    font
				    text-color
				    bg-color
				    xpadding
				    ypadding
				    ratio
				    blur
				    shadow
				    flatten
				    antialias)
    (let* ((shadow-height (if (eqv? shadow TRUE) 1 0))
	   (old-fg-color (car (gimp-context-get-foreground)))
	   (old-bg-color (car (gimp-context-get-background)))
	   (img (car (gimp-image-new 256 256 0)))
           (tmp (gimp-context-set-foreground text-color)) ; only change fg-color for text color
	   (text-layer (car (gimp-text-fontname img -1 0 0 text 0 TRUE size 0 font)))
	   (text-width  (car (gimp-drawable-width  text-layer)))
	   (text-height (car (gimp-drawable-height text-layer)))
	   (radius (/ (* ratio text-height) 4))
	   (height (+ (* 2 ypadding) text-height))
	   (width  (+ (* 2 (+ radius xpadding)) text-width))
	   (shiftx     (/ height 2))
	   (shifty     (/ height 2))
	   (height-all (+ height (* 2 shiftx) (* height shadow-height 0.5)))
	   (width-all  (+ width  (* 2 shifty))))
	; constrói a imagem do botão 'aqua pill'
	(gimp-context-set-foreground text-color)
	(gimp-context-set-background '(255 255 255))
	(gimp-image-resize img width-all height-all
			        (+ shiftx xpadding radius)
			        (+ shifty ypadding))
	(gimp-layer-set-offsets text-layer
			        (+ shiftx xpadding radius)
			        (+ shifty ypadding))
	(gimp-layer-resize text-layer width-all height-all
			        (+ shiftx xpadding radius)
			        (+ shifty ypadding))
	(script-fu-aqua-pill img bg-color width height xpadding ypadding ratio blur shadow FALSE antialias)

	; desenha o texto e seus efeitos
	(gimp-image-undo-group-start img)
	(gimp-image-raise-layer-to-top img text-layer)
	(gimp-image-lower-layer img text-layer)
	(gimp-image-lower-layer img text-layer)
	(set! text-layer-copy   (car (gimp-layer-copy text-layer FALSE)))
	(set! text-layer-shadow (car (gimp-layer-copy text-layer FALSE)))
	(gimp-image-add-layer img text-layer-copy   3)
	(gimp-image-add-layer img text-layer-shadow 4)
	(gimp-layer-set-mode text-layer-shadow 3)
	(gimp-drawable-offset text-layer-copy   0 1 (- (* text-height 0.025)) (- (* text-height 0.025)))
	;(gimp-drawable-offset text-layer-copy   0 1 (- (* xpadding 0.1)) (- (* ypadding 0.1)))
	(gimp-drawable-offset text-layer-shadow 0 1 (- (* xpadding 0.1)) (* height 0.1))
	(gimp-invert text-layer-copy)
	(gimp-selection-layer-alpha text-layer-shadow)
	(gimp-context-set-foreground bg-color)
	(gimp-edit-fill text-layer-shadow 0)
	(gimp-selection-grow img (+ 1 (* height blur 0.1)))	; expande a imagem em todas as direções
	(plug-in-gauss-iir2 1 img text-layer-shadow (+ 1 (* height blur 0.1)) (+ 1 (* height blur 0.1)))
	(gimp-selection-none img)
	(gimp-image-undo-group-end img)
	(gimp-image-undo-group-start img)
	(if (eqv? flatten TRUE)
		(gimp-drawable-set-name (car (gimp-image-flatten img)) text))
	(gimp-context-set-foreground old-fg-color)
	(gimp-context-set-background old-bg-color)
	(gimp-image-undo-group-end img)
	(gimp-displays-flush)
	))
;----------------------------------------------------------------------------------
(script-fu-register "script-fu-aqua-pill-button"
		"<Toolbox>/Xtns/Script-Fu/Web Page Themes/Aqua Pill/Button Text..."
		"(en) Create an 'aqua pill' button with text \
(pt-BR) Cria um botão 'aqua pill' com texto"
		"Marcos Pereira <majpereira@hotmail.com>"
		"Marcos Pereira (majpereira)"
		"07.06.2007"
		""
		SF-STRING     "Text"			"Click Me!"
		SF-ADJUSTMENT "Font Size (pixels)"	'(50 2 500 1 1 0 1)
		SF-FONT       "Font" 			"Serif"	; Default setting
		SF-COLOR      "Text Color"		'(0 0 0)
		SF-COLOR      "Background Color"	'(0 127 255)
		SF-ADJUSTMENT "Padding X"		'(10 0 100 1 10 0 1)
		SF-ADJUSTMENT "Padding Y"		'(10 0 100 1 10 0 1)
		SF-ADJUSTMENT "Round Ratio"		'(1 0.05 5 0.05 0.5 2 0)
		SF-ADJUSTMENT "Blur Amount"		'(1 0.05 5 0.05 0.5 2 0)
		SF-TOGGLE     "Drop Shadow"		TRUE
		SF-TOGGLE     "Flatten"			TRUE
		SF-TOGGLE     "Antialias"		TRUE)
;==================================================================================
