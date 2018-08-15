;; resizebrush.scm -*-scheme-
;; resizes a (gbr)-brush
;; version 1.0    2005-11-13
;; 
;; Copyright (C) 2005 by Michael Hoelzen <MichaelHoelzen@aol.com>
;; http://www.remoserv.de
;;
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
; version 1.1
; the #resiZed.gbr will now be saved in the gimp-directory instead of
; the gimp-data-directory which is write-protected in unix
; 
; version 1.2
; changed \\brushes\\ to /brushes/ for unix-confirmity
(define 
    (script-fu-resize-brush image drawable resFactor)
	(define brushnameResi "#resiZed")
	(define filesave (string-append "" gimp-directory "/brushes/" brushnameResi ".gbr"))
	(define brushnameIn (car (gimp-context-get-brush)))
	(define (testIfresiZed a)
			(if (not (null? (string-search brushnameResi a)))
				(substring a 0 (string-search brushnameResi a))
				a
			)
	)
	(set! actualbrush (testIfresiZed brushnameIn))
	(gimp-context-set-brush actualbrush) 
	(let* 
		(   
			(brushnameOut (string-append actualbrush brushnameResi))
			(spacing (car (gimp-brush-get-spacing actualbrush)))
			(brushDimens (gimp-brush-get-info actualbrush))
			(brushWidth (car brushDimens))
			(brushHeight (cadr brushDimens))
			(resiZedWidth (* brushWidth resFactor))
			(resiZedHeight(* brushHeight resFactor))
			(centerX (/ brushWidth 2))
			(centerY (/ brushHeight 2))
			(centerXpluseins(+ centerX 1))
			(centerYpluseins(+ centerY 1))
		 )
		(and (> resiZedWidth 1)(> resiZedHeight 1)
		    (begin
				(set! arrayToPaint (cons-array 4 'double))
				(aset arrayToPaint 0 centerX)
				(aset arrayToPaint 1 centerY)
				(aset arrayToPaint 2 centerXpluseins)
				(aset arrayToPaint 3 centerYpluseins)
				(set! image (car (gimp-image-new brushWidth brushHeight RGB)))
				(set! layer (car (gimp-layer-new image brushWidth brushHeight 1 "layer 1" 100 0)))
				(gimp-image-undo-disable image)
				(gimp-image-add-layer image layer 0)
				(gimp-drawable-fill layer 3)
				(gimp-paintbrush-default layer 4 arrayToPaint)
				(gimp-image-scale image resiZedWidth resiZedHeight)
				(file-gbr-save 1 image layer filesave filesave spacing brushnameOut)
				(gimp-image-undo-enable image)
				(gimp-image-delete image)
				(gimp-brushes-refresh)
				(gimp-context-set-brush brushnameOut)))
	)
)
;
(script-fu-register "script-fu-resize-brush"
					_"_ResiZebrush"
                    "ResiZe a brush"
                    "Michael Hoelzen>"
                    "Michael Hoelzen"
                    "2005"
                    ""
                    SF-IMAGE       "Image"         0
                    SF-DRAWABLE    "Drawable"      0
                    SF-ADJUSTMENT _"resFactor"    '(1.3 0.1 3.0 0.1 1 1 0)
)
(script-fu-menu-register "script-fu-resize-brush"
                         _"<Image>/Script-Fu/BrushUtil")
