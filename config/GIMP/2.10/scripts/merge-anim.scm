; merge-anim.scm - Merge the bg or top layer of an image with all other layers.
; Copyright (C) 1998-2002 Raphael Quinet
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
; --- Description ---
; This script allows you to add a background to an existing animation,
; or to add some object on top of all frames.   You can optionally add
; fade-in/fade-out effects or some movement by varying the opacity and
; position of the merged layers.
; The script does nothing more than repeatedly copying the new layer
; and merging it with each of the other layers.  You could also do this
; by hand, but this is a boring task.  That's why I wrote this script.
;
; --- Change log ---
; 1.0 - 1998-08-10
;       First public release.
; 1.1 - 1998-08-11
;       Merged 'merge-bg.scm' and 'merge-top.scm' into a single script
;       named 'merge-anim.scm'.  Someone should write 'merge-scm.scm'...
; 1.2 - 1998-08-11
;       Added GRAYA to the list of supported image types (RGB and GRAY
;       without alpha would not work because we need two layers).
; 2.0 - 2002-01-04
;       Finally adapted the script to Gimp-1.2.  Support all image types
;       as long as two layers are available.  Better description of the
;       parameters.  Undo is now possible.  It is also possible to use a
;       layer from another image as the source for the merges.
;

(define (merge-anim-copy-layer image other-layer layer-pos)
  (let* ((other-image (car (gimp-drawable-image other-layer)))
	 (other-width (car (gimp-drawable-width other-layer)))
	 (other-height (car (gimp-drawable-height other-layer)))
	 (copied-type (+ 1 (* 2 (car (gimp-image-base-type image)))))
	 (copied-layer (car (gimp-layer-new image other-width other-height
					    copied-type "Copied layer"
					    100 NORMAL))))
    (gimp-image-add-layer image copied-layer layer-pos)
    (gimp-selection-all image)
    (gimp-edit-clear copied-layer)
    (gimp-selection-none image)
    (gimp-selection-all other-image)
    (gimp-edit-copy other-layer)
    (gimp-selection-none other-image)
    (gimp-floating-sel-anchor (car (gimp-edit-paste copied-layer FALSE)))))


(define (merge-anim-do-it image drawable merge-mode visible-only delete-src
			  i-opacity f-opacity
			  transform-anim
			  i-offset-x i-offset-y
			  f-offset-x f-offset-y)
  (let* ((layers (gimp-image-get-layers image))
	 (num-layers (car layers))
	 (layer-array (cadr layers))
	 (diff-opacity (- i-opacity f-opacity))
	 (diff-offset-x (- i-offset-x f-offset-x))
	 (diff-offset-y (- i-offset-y f-offset-y))
	 (visi-array (cons-array num-layers))
	 (layer-count (- num-layers 1))
	 (src-layer (aref layer-array (if (= merge-mode 0) layer-count 0)))
	 (num-vlayers layer-count)
	 (vlayer-count layer-count))
	  
    ; hide all layers (visi-array keeps track of which ones were visible)
    (while (>= layer-count 0)
	   (let* ((layer (aref layer-array layer-count))
		  (visible (car (gimp-layer-get-visible layer))))
	     (aset visi-array layer-count visible)
	     (if (and (= visible-only TRUE)
		      (= visible FALSE))
		 (set! num-vlayers (- num-vlayers 1)))
	     (gimp-layer-set-visible layer FALSE))
	   (set! layer-count (- layer-count 1)))
    
    (set! vlayer-count num-vlayers)
    (set! layer-count (- num-layers (if (= merge-mode 0) 2 1)))

    (if (> num-vlayers 0)
	(while (>= layer-count (if (= merge-mode 0) 0 1))
	       (let* ((layer (aref layer-array layer-count))
		      (was-visible (aref visi-array layer-count)))
		 
		 (if (or (= visible-only FALSE)
			 (= was-visible TRUE))
		     (let* ((new-layer (car (gimp-layer-copy src-layer TRUE)))
			    (new-name (car (gimp-layer-get-name layer)))
			    (opacity (+ f-opacity
					(/ (* diff-opacity vlayer-count)
					   num-vlayers)))
			    (offset-x (+ f-offset-x
					 (/ (* diff-offset-x vlayer-count)
					    num-vlayers)))
			    (offset-y (+ f-offset-y
					 (/ (* diff-offset-y vlayer-count)
					    num-vlayers)))
			    (offset-layer (if (= transform-anim TRUE)
					      layer new-layer)))
		       ; add the copy of the source layer
		       (gimp-image-add-layer image new-layer
					     (+ layer-count
						(if (= merge-mode 0) 1 0)))
		       ; make both layers visible
		       (gimp-layer-set-visible new-layer TRUE)
		       (gimp-layer-set-visible layer TRUE)
		       ; change the opacity of the top layer
		       (gimp-layer-set-opacity (if (= merge-mode 0)
						   layer new-layer)
					       opacity)
		       ; if specified, move one of the layers
		       (if (not (and (= offset-x 0) (= offset-y 0)))
			   (gimp-channel-ops-offset offset-layer
						    TRUE OFFSET-TRANSPARENT
						    offset-x offset-y))
		       ; merge them
		       (set! merged-layer
			     (car (gimp-image-merge-visible-layers 
				   image CLIP-TO-IMAGE)))
		       (aset layer-array layer-count merged-layer)
		       (gimp-layer-set-name merged-layer new-name)
		       ; hide the result
		       (gimp-layer-set-visible merged-layer FALSE)
		       (set! vlayer-count (- vlayer-count 1)))))
	       (set! layer-count (- layer-count 1)))

	; ...else num-vlayers <= 0
	(gimp-message _"There are no visible layers in the image!"))

    ; restore the visibility of all layers
    (set! layer-count (- num-layers 1))
    (while (>= layer-count 0)
	   (let* ((layer (aref layer-array layer-count))
		  (visible (aref visi-array layer-count)))
	     (gimp-layer-set-visible layer visible))
	   (set! layer-count (- layer-count 1)))

    ; delete the source layer if necessary
    (if (and (= delete-src TRUE) (> num-vlayers 0))
	(gimp-image-remove-layer image (aref layer-array (if (= merge-mode 0) 
							     (- num-layers 1)
							     0))))))

(define (script-fu-merge-anim image drawable
			      merge-mode other-layer visible-only delete-src
			      i-opacity f-opacity
			      transform-anim
			      i-offset-x i-offset-y
			      f-offset-x f-offset-y)
  (let* ((num-layers (car (gimp-image-get-layers image))))
    (if (<= num-layers 1)
	(gimp-message _"The source image must have at least two layers")
	(begin
	  (gimp-undo-push-group-start image)
	  (if (> merge-mode 1)
	      (begin
		(merge-anim-copy-layer image other-layer (if (= merge-mode 2)
							     num-layers 0))
		(set! merge-mode (- merge-mode 2))))
	  (merge-anim-do-it image drawable merge-mode visible-only delete-src
			    i-opacity f-opacity
			    transform-anim
			    i-offset-x i-offset-y
			    f-offset-x f-offset-y)
	  (gimp-undo-push-group-end image)
	  (gimp-displays-flush)))))


(script-fu-register
	"script-fu-merge-anim"
	_"<Image>/Script-Fu/Animators/Merge layer with others..."
	"Merge the background or top layer with all other layers in the image, with an optional offset and fading effect."
	"Raphael Quinet <quinet@gamers.org>"
	"Raphael Quinet, 1998-2002"
	"2002-01-04"
	"RGB* GRAY* INDEXED*"
	SF-IMAGE      "Image" 0
	SF-DRAWABLE   "Drawable" 0
	SF-OPTION     _"Merge" '(_"background layer with all layers above"
				 _"top layer with all layers below"
				 _"other layer as background layer"
				 _"other layer as top layer")
	SF-DRAWABLE   _"Other layer" 0
	SF-TOGGLE     _"Visible layers only?" TRUE
	SF-TOGGLE     _"Delete background/top layer after merge?" TRUE
	SF-ADJUSTMENT _"Initial opacity" '(100 0 100 1 10 1 0)
	SF-ADJUSTMENT _"Final opacity" '(100 0 100 1 10 1 0)
	SF-OPTION     _"Offset" '(_"background/top layer"
				  _"all other layers")
	SF-ADJUSTMENT _"Initial X offset" '(0 -4096 4096 1 10 0 1)
	SF-ADJUSTMENT _"Initial Y offset" '(0 -4096 4096 1 10 0 1)
	SF-ADJUSTMENT _"Final X offset" '(0 -4096 4096 1 10 0 1)
	SF-ADJUSTMENT _"Final Y offset" '(0 -4096 4096 1 10 0 1)
)
