; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
;
; plasma-tile.scm  Generate seamles stiling plasma, solid plasma, or
;                  lots of other weird effects
;
;  Adrian Likins <adrian@gimp.org>  1/11/98
;  With some code borrowed from Sven Neuman
;
; see http://www.gimp.org/~adrian/scripts.html
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
; Changed on January 29, 2004 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 2.0pre3


(define (script-fu-plasma-tile image
			drawable
			seed
			x_size
			y_size
			detail
			turb
			keep-selection
			seperate-layer)
  (let* (
	 (type (car (gimp-drawable-type-with-alpha drawable)))
	 (image-width (car (gimp-image-width image)))
	 (image-height (car (gimp-image-height image)))
	 (old-gradient (car (gimp-gradients-get-gradient)))
	 (old-bg (car (gimp-palette-get-background))))
    
    (gimp-image-undo-disable image)
    (gimp-layer-add-alpha drawable)
    
    (if (= (car (gimp-selection-is-empty image)) TRUE)
	(begin
	  (gimp-selection-layer-alpha drawable)
	  (set! active-selection (car (gimp-selection-save image)))
	  (set! from-selection FALSE))
	(begin
	  (set! from-selection TRUE)
	  (set! active-selection (car (gimp-selection-save image)))))
    
    (set! selection-bounds (gimp-selection-bounds image))
    (set! select-offset-x (cadr selection-bounds))
    (set! select-offset-y (caddr selection-bounds))
    (set! select-width (- (cadr (cddr selection-bounds)) select-offset-x))
    (set! select-height (- (caddr (cddr selection-bounds)) select-offset-y))
    
    (if (= seperate-layer TRUE)
	(begin
	  (set! plasma-layer (car (gimp-layer-new image
						select-width
						select-height
						type
						"Plasma Layer"
						100
						NORMAL-MODE)))
	  
	  (gimp-layer-set-offsets plasma-layer select-offset-x select-offset-y)
	  (gimp-image-add-layer image plasma-layer -1)
	  (gimp-selection-none image)
	  (gimp-edit-clear plasma-layer)
	  
	  (gimp-selection-load active-selection)
	  (gimp-image-set-active-layer image plasma-layer)))
    
    (set! active-layer (car (gimp-image-get-active-layer image)))

    ;turn off all color components
    (gimp-image-set-component-active image 0 0)
    (gimp-image-set-component-active image 1 0)
    (gimp-image-set-component-active image 2 0)

    ;turn on the one were fiddling with
    (gimp-image-set-component-active image 0 1)
    (plug-in-solid-noise 1 image active-layer TRUE turb seed detail x_size y_size)
    (gimp-image-set-component-active image 0 0)
    (gimp-image-set-component-active image 1 1)
    (plug-in-solid-noise 1 image active-layer TRUE turb (+ seed 1) detail x_size y_size)
    (gimp-image-set-component-active image 1 0)
    (gimp-image-set-component-active image 2 1)
    (plug-in-solid-noise 1 image active-layer TRUE turb (+ seed 2) detail x_size y_size)

    (gimp-image-set-component-active image 0 1)
    (gimp-image-set-component-active image 1 1)
    (gimp-image-set-component-active image 2 1)

    (gimp-palette-set-background old-bg)

    (if (= keep-selection FALSE)
	(gimp-selection-none image))
   
    (gimp-image-set-active-layer image drawable)
    (gimp-image-remove-channel image active-selection)
    (gimp-image-undo-enable image)
    (gimp-displays-flush)))

(script-fu-register "script-fu-plasma-tile"
		    "<Image>/Script-Fu/Render/Plasma Tile..."
		    "Generates seemless tiling plasma or solid plasma"
		    "Adrian Likins <adrian@gimp.org>"
		    "Adrian Likins"
		    "1/11/98"
		    "RGB RGBA GRAY GRAYA"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE "Seed" "2"
		    SF-VALUE "X-size" "4"
		    SF-VALUE "Y-size" "4"
		    SF-VALUE "Detail" "7"
		    SF-TOGGLE "Turbulent?" FALSE
		    SF-TOGGLE "Keep Selection?" TRUE
		    SF-TOGGLE "Seperate Layer?" TRUE)
