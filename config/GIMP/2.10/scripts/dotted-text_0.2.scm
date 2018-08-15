; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Dotted text --- create an dotted text
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
;   - Changelog -
; version 0.0  2001/04/06 Iccii <iccii@hotmail.com>
;     - This script has not been relased yet
; version 0.1  2001/08/21 Iccii <iccii@hotmail.com>
;     - Initial relase
; version 0.2  2001/10/02 Iccii <iccii@hotmail.com>
;     - Added Transparent BG option
;     - Moved the menu path from <Image> to <Toolbox>
; version 0.3 by Raymond Ostertag 2004/09
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


(define (script-fu-dotted-text
			text		; ï∂éö
			font-size	; ÉtÉHÉìÉgÇÃëÂÇ´Ç≥
			fontname	; ÉtÉHÉìÉgñº
			text-color	; ï∂éöÇÃêF
			block-size	; ì_ÇÃïù
			padding		; ì_ÇÃä‘äu
			trans-bg?	; îwåiÇìßñæÇ…Ç∑ÇÈÇ©Ç«Ç§Ç©
	)

  (let* (
	 (old-fg (car (gimp-palette-get-foreground)))
	 (img (car (gimp-image-new 256 256 RGB)))
	 (tmp-color (gimp-palette-set-foreground '(0 0 0)))
	 (text-layer (car (gimp-text-fontname img -1 0 0
			        text 0 TRUE font-size PIXELS fontname)))
	 (text-width  (car (gimp-drawable-width  text-layer)))
	 (text-height (car (gimp-drawable-height text-layer)))
	 (shiftx 20)
	 (shifty 20)
	 (height-all (+ text-height (* 2 shiftx)))
	 (width-all  (+ text-width  (* 2 shifty)))
	 (text-layer1 (car (gimp-layer-new img height-all width-all
			         RGBA-IMAGE "Text Layer1" 100 NORMAL-MODE)))
	 (text-layer2 (car (gimp-layer-new img height-all width-all
			         RGBA-IMAGE "Text Layer2" 100 LIGHTEN-ONLY-MODE)))
	)

    (gimp-image-undo-disable img)
    (gimp-image-resize img width-all height-all shiftx shifty)
    (gimp-layer-set-offsets text-layer1 shiftx shifty)
    (gimp-layer-set-offsets text-layer2 shiftx shifty)
    (gimp-layer-resize text-layer1 width-all height-all 0 0)
    (gimp-layer-resize text-layer2 width-all height-all 0 0)
    (if (<= block-size padding)
	(begin
	  (gimp-message "Padding is larger than Block Size! Abort.")
	  (gimp-image-remove-layer img text-layer))
	(begin
 	  (gimp-image-add-layer img text-layer1 -1)
	  (gimp-image-add-layer img text-layer2 -1)

	  (gimp-palette-set-foreground text-color)
	  (gimp-drawable-fill text-layer1 WHITE-FILL)
	  (gimp-drawable-fill text-layer2 FOREGROUND-FILL)
	  (gimp-image-lower-layer img text-layer1)
	  (set! result-layer (car (gimp-image-merge-down img text-layer
	                                                 EXPAND-AS-NECESSARY)))

	  (plug-in-pixelize 1 img result-layer block-size)
	  (gimp-threshold result-layer 127 255)
	  (plug-in-grid 1 img result-layer padding block-size 0 '(255 255 255) 255
					   padding block-size 0 '(255 255 255) 255
					   0       0          0 '(255 255 255) 255)

	  (if (eqv? trans-bg? TRUE)
	      (begin
	        (gimp-edit-copy result-layer)
	        (set! result-layer2 (car (gimp-image-merge-down img text-layer2
	                                                        EXPAND-AS-NECESSARY)))
	        (set! mask (car (gimp-layer-create-mask result-layer2 ADD-BLACK-MASK)))
	        (gimp-layer-add-mask result-layer2 mask)
	        (gimp-floating-sel-anchor (car (gimp-edit-paste mask 0)))
	        (gimp-invert mask)
	      )
	      (set! result-layer2 (car (gimp-image-merge-down img text-layer2
	                                                      EXPAND-AS-NECESSARY)))
	  )
	  (gimp-display-new img)
	)
    )
    (gimp-palette-set-foreground old-fg)
    (gimp-image-undo-enable img)
    (gimp-displays-flush)
  )
)

	; ìoò^Ç»Ç«
(script-fu-register
	"script-fu-dotted-text"
	"<Toolbox>/Xtns/Script-Fu/Text/Dotted Text..."
	"Create an dotted text"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"Oct, 2001"
	""
	SF-STRING	_"Text"		"Dot Text"
	SF-ADJUSTMENT	_"Font Size (pixels)"	'(150 2 500 1 1 0 1)

	SF-FONT		_"Font"
	; Checking winsnap plug-in (Windows or not?)
(if (symbol-bound? 'extension-winsnap (the-environment))
	; For Windows user
		"-*-Times New Roman-bold-r-*-*-24-*-*-*-p-*-iso8859-1"
	; Default setting
		"-*-tekton-*-r-*-*-24-*-*-*-p-*-*-*"
)

	SF-COLOR	_"Text Color"	'(0 0 0)
	SF-ADJUSTMENT	_"Block Size"	'(5 1 63 1 10 0 1)
	SF-ADJUSTMENT	_"Padding"	'(1 0 31 1 10 0 1)
	SF-TOGGLE	"Transparent BG"	FALSE
)
