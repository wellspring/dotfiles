
; The GIMP -- an image manipulation program
; Copyright © 1995 Spencer Kimball and Peter Mattis


; --- About the script ---------------------------------------------------------------------------
;
; script-fu-guides-new-multi
;
;   EN: creates a series of horizontal and/or vertical guides in one go.
;   FR: crée une série de guides horizontaux et/ou verticaux en un seul passage.
;
; Versions
; v1.1: (2007/07/06)
;     - integrated guides removal subroutine
; v1.0: first release (2007/07/01)
;
; Copyright © 2007 Olivier Boursin
; ------------------------------------------------------------------------------------------------

 
; --- About the license --------------------------------------------------------------------------
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
; ------------------------------------------------------------------------------------------------

; subroutines (sr-*)
(define (sr-remove-guides pImg)
  (let* (
         (vGuideId 0)
        )
        (set! vGuideId (car (gimp-image-find-next-guide pImg 0)))
        (while (> vGuideId 0) 
	        (gimp-image-delete-guide pImg vGuideId)
	        (set! vGuideId (car (gimp-image-find-next-guide pImg 0)))
	      )
	)
)
(define (sr-trace-guides pImg pHorizontal pSize pRepeat pOffset pSpacing)
  (let* (
         (vPos 0)
         (vLoop 0)
        )
        ; first of all, add offset to position of first guide
        (set! vPos (+ vPos pOffset))
        ; reset counter
        (set! vLoop 0)
        ; loop until image size or number of guides is reached (whatever comes first)
        (while (and (<= vPos pSize) (< vLoop pRepeat))
          (if (= pHorizontal TRUE)
            (gimp-image-add-hguide pImg vPos)
            (gimp-image-add-vguide pImg vPos)
          )
          ; prepare position of next guide (if any) by adding spacing
          (set! vPos (+ vPos pSpacing))
          ; increment counter
          (set! vLoop (+ vLoop 1))
        )
  )
)

; main function
(define (script-fu-guides-new-multi pImage
                                    pDrawable
                                    pRemove
                                    pRepeatH
                                    pOffsetH
                                    pSpacingH
                                    pRepeatV
                                    pOffsetV
                                    pSpacingV
        )
  (let* (
         (vHeight (car (gimp-image-height pImage)))
         (vWidth (car (gimp-image-width pImage)))
        )
  ; Startup
    (gimp-image-undo-group-start pImage)
    ; Remove existing guides ?
    (if (= pRemove TRUE) (sr-remove-guides pImage))
    ; Horizontal guides ?
    (if (> pRepeatH 0) (sr-trace-guides pImage 1 vHeight pRepeatH pOffsetH pSpacingH))
    ; Vertical guides ?
    (if (> pRepeatV 0) (sr-trace-guides pImage 0 vWidth  pRepeatV pOffsetV pSpacingV))
  ; Cleanup
    (gimp-image-undo-group-end pImage)
    (gimp-displays-flush)
  )
)

(script-fu-register "script-fu-guides-new-multi"
		    _"New multiple guides..." 
		    (string-append
		     "\"Leeloo Dallas MultiGuides...\""
		     "\n\n" 
		     "EN:\n"
		     "creates a series of new guides, "
		     "horizontally and/or vertically:"
		     "\n- Number of guides ( 0 => no guides for this direction )"
		     "\n- Position of first guide: in pixels"
		     "\n- Spacing between guides: in pixels"
		     "\nGuides will be repeated horizontally/vertically up to given number unless "
		     "height/width of image is reached first."
		     "\n\n"
		     "FR:\n"
		     "trace une série de nouveaux guides, "
		     "horizontalement et/ou verticalement:"
		     "\n- Nombre de guides ( 0 => pas de guides pour cette direction )"
		     "\n- Position du premier guide: en pixels"
		     "\n- Espacement entre les guides: en pixels"
		     "\nLes guides seront répétés horizontalement/verticalement jusqu'au nombre indiqué sauf "
		     "si la hauteur/largeur de l'image est d'abord atteinte."
		    )
		    "GimpOli <o.boursin@ibelgique.com>"
		    "GPL + © 2007 Olivier Boursin"
		    (string-append
		     "v1.1 : 2007/07/06\n"
		     "v1.0 : 2007/07/01"
		    )
		    "" ; empty = all images
		    SF-IMAGE      "Input Image"    0 
		    SF-DRAWABLE   "Input Drawable" 0
		    SF-TOGGLE     (string-append _"Clear existing guides\n"
		                                  "Effacer les guides existant")                 FALSE
		    ;                                   
		    ;                                                                 highest limit________  s   ______ctrl-step
		    ;                                                                  lowest limit___     | t  |  ____decimal positions
		    ;                                                                 default value_  |    | e  | |   _cursor field (0:yes /1:no)
		    ;                                                                               | |    | p  | |  |
		    ;                                                                               D S    E | cS , !C
		    SF-ADJUSTMENT (string-append _"Number of HORIZONTAL guides:\n"
		                                  "Nombre de guides HORIZONTAUX")                '( 0 0  100 1 10 0 0)
		    SF-ADJUSTMENT (string-append _"Position of the first one of these guides:\n"
		                                  "Position du premier de ces guides")           '(50 0 1000 1 10 0 0)
		    SF-ADJUSTMENT (string-append _"Spacing between these guides:\n"
		                                  "Espacement entre ces guides")                 '(50 0 1000 1 10 0 0)

		    SF-ADJUSTMENT (string-append _"Number of VERTICAL guides:\n"
		                                  "Nombre de guides VERTICAUX")                  '( 0 0  100 1 10 0 0)
		    SF-ADJUSTMENT (string-append _"Position of the first one of these guides:\n"
		                                  "Position du premier de ces guides")           '(50 0 1000 1 10 0 0)
		    SF-ADJUSTMENT (string-append _"Spacing between these guides:\n"
		                                  "Espacement entre ces guides")                 '(50 0 1000 1 10 0 0)
)    

(script-fu-menu-register "script-fu-guides-new-multi" "<Image>/Image/Guides")
