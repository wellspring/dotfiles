; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
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
;    Lightsaber Effect - Creates a lightsaber effect.
;    Method taken from http://www.alienryderflex.com/rotoscope/
;    by Eric Kincl <Eric@Kincl.net>
;    http://eric.kincl.net
;    Version 1.2.0
;
;    This script will, given a layer with a white line on it,
;    take the line and apply a "lightsaber" effect to it.
;
; Arguments that must be past are as follows:
; inImage - Gimp image identifier resource.
; inLayer - Gimp layer identifier resource.
; inWidth - Width of the line which will be converted to a lightsaber.
; inColor - Final color the lightsaber will be.
; inMode  - Alpha mode switch.
;             "FALSE" for defualt mode (screen), "TRUE" for alpha mode.
;             (Alpha mode isn't the normally described method,
;             but appears better on lighter backgrounds)
;


(define (script-fu-lightsaber-effect inImage inLayer inWidth inColor inMode)

  (let*
      ((image inImage)
       (blade inLayer)
       (tightAura inLayer)
       (looseAura inLayer)
       (width inWidth)
       (color inColor)
       (mode inMode)
      )

					; start group undo (not working for some reason?)
    (gimp-image-undo-group-start image)

					; select nothing so it operates on everything
    (gimp-selection-none image)

    (gimp-drawable-set-name blade "blade")

					;01 blade: Blur = WIDTH
    (blur image blade width)

					;02 blade: level: value: input: lower: 30, upper: 50
    (level-input blade 30 50)

					;03 blade: duplicate layer - new name "loose aura"
    (set! looseAura (car (gimp-layer-copy blade FALSE)))
    (gimp-image-add-layer image looseAura -1)
    (gimp-drawable-set-name looseAura "looseAura")

					;04 loose aura: blur = WIDTH * 2
    (blur image looseAura (* width 2))

					;05 loose aura: level: value: input: upper: 10
    (level-input looseAura 0 10)

					;06 loose aura: blur = WIDTH * 2
    (blur image looseAura (* width 2))

					;07 loose aura: level: rgb: output: SABER-COLOR
    (level-colorize looseAura color)

					;08 loose aura: level: value: output: 127
    (level-output looseAura 0 128)

					;09 blade: duplicate layer - new name "tight aura"
    (set! tightAura (car (gimp-layer-copy blade FALSE)))
    (gimp-image-add-layer image tightAura -1)
    (gimp-drawable-set-name tightAura "tightAura")

					;10 tight aura: blur = WIDTH / 2
    (blur image tightAura (/ width 2))

					;11 tight aura: level: value: input: upper: 10
    (level-input tightAura 0 10)

					;12 tight aura: blur = WIDTH
    (blur image tightAura width)

					;13 tight aura: level: rgb: output: SABER-COLOR
    (level-colorize tightAura color)

					;14 layer-order: blade, tight aura, loose aura
    (gimp-image-raise-layer-to-top image looseAura)
    (gimp-image-raise-layer-to-top image tightAura)
    (gimp-image-raise-layer-to-top image blade)

					;15 blade: blur = WIDTH / (3/8)
    (blur image blade (* 3 (/ width 8)))

					; Done rendering, time to merge
    (gimp-layer-set-mode blade 4)

					; ensure we are visible so merge works fine
    (gimp-drawable-set-visible blade 1)
    (gimp-drawable-set-visible tightAura 1)
    (gimp-drawable-set-visible looseAura 1)

    (set! blade (car (gimp-image-merge-down image blade 0)))

    (gimp-layer-set-mode blade 4)

    (set! blade (car (gimp-image-merge-down image blade 0)))

					; If Alpha mode is set, then alpha BG instead of screening
    (if (= mode TRUE)
	(begin
	  (plug-in-colortoalpha TRUE image blade '(0 0 0))
	  (gimp-layer-set-mode blade 0)
	)
	(gimp-layer-set-mode blade 4)
    )

    (gimp-drawable-set-name blade "LightSaber")

    (gimp-image-undo-group-end image)
    (gimp-displays-flush)
  )
)


(define (blur image layer width)
  (plug-in-gauss TRUE image layer width width 1)
)

(define (level-input layer min max)
  (gimp-levels layer 0 min max 1.0 0 255)
)

(define (level-output layer min max)
  (gimp-levels layer 0 0 255 1.0 min max)
)

(define (level-colorize layer RGB)
  ;red
  (gimp-levels layer 1 0 255 1.0 0 (car RGB))
  ;green
  (gimp-levels layer 2 0 255 1.0 0 (cadr RGB))
  ;blue
  (gimp-levels layer 3 0 255 1.0 0 (caddr RGB))
)


(script-fu-register
 "script-fu-lightsaber-effect"				;func name
 "<Image>/Script-Fu/Blur/Lightsaber..."		        ;menu pos  
 "Creates a Lightsaber effect.\
  To successfully create the effect,\
  you need a black layer with a white line\
  (roughly 2-10 pixels wide)\
  The layer must be selected.\
  (Method taken from\
  http://www.alienryderflex.com/rotoscope)"		;description
 "Eric Kincl"						;author
 "Released under the GNU GPL"				;copyright notice
 "June 18, 2005"					;date created
 "RGBA"						        ;image type that the script works on
 SF-IMAGE 	"Gimp Image Resource"	0		;Image reference identifier
 SF-DRAWABLE 	"Gimp Layer Resource"	0		;Layer reference identifier
 SF-VALUE 	"Saber width"		"10"		;a text variable
 SF-COLOR	"Saber color"		'(0 255 0)	;color variable
 SF-TOGGLE      "Alpha mode"            FALSE           ;boolean variable
)
