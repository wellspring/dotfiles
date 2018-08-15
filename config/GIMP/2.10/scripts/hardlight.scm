;;;
;;;  hardlight.scm - try to duplicate P*S*P's blending mode
;;;
;;;
;;;  Jeff Trefftzs <trefftzs@tcsn.net>

;;; This program is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2 of the License, or
;;; (at your option) any later version.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;; 
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Define the function:

(define (script-fu-hardlight inImage inLayer inHigh inShade inMerge)
  (let* (
	 (image-layers (cadr (gimp-image-get-layers inImage)))
	 (visible-layers '())
	 (width (car (gimp-drawable-width inLayer)))
	 (height (car (gimp-drawable-height inLayer)))
	 (hlbottom (car (gimp-layer-copy inLayer TRUE)))
	 (hloverlay (car (gimp-layer-copy inLayer TRUE)))
	 (hlscreen (car (gimp-layer-copy inLayer TRUE)))
	 (ovlymask (car (gimp-layer-create-mask hloverlay WHITE-MASK)))
	 (scrnmask (car (gimp-layer-create-mask hlscreen WHITE-MASK)))
	 (i 0)
	 )

    (gimp-undo-push-group-start inImage)

    ;; Remember the visible layers, but hide them for now

    (while (< i (length image-layers))
	   (cond ((= TRUE (car (gimp-layer-get-visible
			       (aref image-layers i))))
		  (set! visible-layers
			(append 
			 (list
			  (aref image-layers i))))
		  (gimp-layer-set-visible
		   (aref image-layers i) FALSE)
		  )
		 )
	   (set! i (+ i 1))
	   )

    (gimp-layer-set-name hlbottom "Hard Light Layer")
    (gimp-layer-set-visible hlbottom TRUE)
    (gimp-layer-set-name hloverlay "Hard Light Overlay Layer")
    (gimp-layer-set-visible hloverlay TRUE)
    (gimp-layer-set-name hlscreen "Hard Light Screen Layer")
    (gimp-layer-set-visible hlscreen TRUE)

    (gimp-image-add-layer inImage hlbottom -1)
    (gimp-image-add-layer inImage hloverlay -1)
    (gimp-layer-set-mode hloverlay 
			 (if (= inShade 0)
			     OVERLAY-MODE
			     MULTIPLY-MODE))
    (gimp-image-add-layer inImage hlscreen -1)
    (gimp-layer-set-mode hlscreen 
			 (if (= inHigh 0)
			     SCREEN-MODE
			     ADDITION-MODE))

    (gimp-image-add-layer-mask inImage hloverlay ovlymask)
    (gimp-image-add-layer-mask inImage hlscreen scrnmask)

    (gimp-edit-copy hlbottom)
    (gimp-floating-sel-anchor (car (gimp-edit-paste ovlymask TRUE)))
    (gimp-threshold ovlymask 128 255)
    (gimp-floating-sel-anchor (car (gimp-edit-paste scrnmask TRUE)))
    (gimp-threshold scrnmask 0 127)

    (if (= inMerge TRUE)
	(gimp-image-merge-visible-layers inImage EXPAND-AS-NECESSARY))

    ;; Restore layer visibility

    (mapcar (lambda (layer) 
	      (gimp-layer-set-visible layer TRUE)) 
	    visible-layers)

    (gimp-image-set-active-layer inImage inLayer)
    (gimp-undo-push-group-end inImage)
    (gimp-displays-flush)
  )
)

(script-fu-register
 "script-fu-hardlight"
 _"<Image>/Script-Fu/Alchemy/Hard Light"
 "Attempts to duplicate Photoshop's Hard Light blending mode. One version of the formula is:
   color = (top < 128) ? (2 * bottom * top)/ 255
           : 255 - (2 * (255 - bottom) * (255 - top)/255);
which works out to multiply the dark stuff and screen the light stuff, or the GIMP's OVERLAY mode plus an ADDITION or SCREEN layer on top (to take care of the multiply by 2).  So that's what this does."
 "Jeff Trefftzs"
 "Copyright 2002, Jeff Trefftzs"
 "February 18, 2002"
 "RGB* GRAY*"
 SF-IMAGE "The Image" 0
 SF-DRAWABLE "The Layer" 0
 SF-OPTION "Highlight Layer Mode" '("Screen" "Addition")
 SF-OPTION "Shadow Layer Mode" '("Overlay" "Multiply")
 SF-TOGGLE "Merge intermediate results" TRUE
)