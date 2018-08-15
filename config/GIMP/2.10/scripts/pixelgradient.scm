;;;
;;;  pixelgradient.scm - pixelize with varying sizes from l to r
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

(define (script-fu-pixelgradient inImage inLayer minsize maxsize nsteps)
  ;; If there isn't already a selection, select the whole thing
  (if (car (gimp-selection-is-empty inImage))
      (begin
       (gimp-selection-all inImage)
       (set! noselection TRUE)
       )
      (set! noselection FALSE))
  (let* (
	 (selchannel (car (gimp-selection-save inImage)))
	 (selstuff  (gimp-selection-bounds inImage))
	 (width
	  (cond ((car selstuff)
		 (- (nth 3 selstuff) (nth 1 selstuff)))
		(t (car (gimp-image-width inImage)))))
	 (height
	  (cond ((car selstuff)
		 (- (nth 4 selstuff) (nth 2 selstuff)))
		(t (car (gimp-image-height inImage)))))
	 (x0 
	  (cond ((car selstuff)
		 (nth 1 selstuff))
		(t 0)))
	 (y0
	  (cond ((car selstuff)
		 (nth 2 selstuff))
		(t 0)))
	 (x1 width)
	 (y1 height)
	 (stepwidth (/ width nsteps))
	 (pixstep (/ (- maxsize minsize) nsteps))
	 (startx x0)
	 (startsize minsize)
	 )

  (gimp-undo-push-group-start inImage)

  ;; Step across the selection (or image), pixelizing as we go

  (while (< startx x1)
	 (begin
	   (gimp-selection-load selchannel)
	   (gimp-rect-select inImage startx y0 stepwidth height
			     INTERSECT
			     FALSE
			     0)

	   (plug-in-pixelize TRUE inImage inLayer startsize)
	   (set! startx (+ startx stepwidth))
	   (set! startsize (+ startsize pixstep))
	  )
	 )
  
  (if (equal? TRUE noselection)
      (gimp-selection-none inImage)
      (gimp-selection-load selchannel)
      )
  )
  (gimp-image-set-active-layer inImage inLayer)
  (gimp-undo-push-group-end inImage)
  (gimp-displays-flush)
)

(script-fu-register
 "script-fu-pixelgradient"
 _"<Image>/Script-Fu/Alchemy/Pixel Gradient"
 "Pixelizes a selection (or layer) from left to right with increasing pixel sizes."
 "Jeff Trefftzs"
 "Copyright 2003, Jeff Trefftzs"
 "November 17, 2003"
 "RGB* GRAY* INDEXED*"
 SF-IMAGE "The Image" 0
 SF-DRAWABLE "The Layer" 0
 SF-ADJUSTMENT "Minimum Pixel Size" '(5 1 256 1 5 0 1)
 SF-ADJUSTMENT "Maximum Pixel Size" '(64 1 256 1 5 0 1)
 SF-ADJUSTMENT "Number of Steps"  '(5 1 256 1 5 0 1)
)
