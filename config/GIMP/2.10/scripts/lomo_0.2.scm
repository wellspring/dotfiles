; lomo.scm  A Script-Fu script to turn a GIMP-image into a 'LOMO' snap.
;
; version 1.0
; Copyright (C)March 2003 under GPL by Avi Bercovich <avi@sillypages.org>
;
; version 1.1 Raymond Ostertag 2004/09
; - ported to Gimp2
; - changed menu entry
;
; TODO version 2.x
; - multilens effect, 2x2, 3x3

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

(define (script-fu-lomo image drawable fringeWidth fringeBoost)

(let* 
 	(
 		(imgWidth (car (gimp-image-width image)))
		(imgHeight (car (gimp-image-height image)))

		(midpoint_X (/ imgWidth 2))
		(midpoint_Y (/ imgHeight 2))

		(l_whiteFlare (car (gimp-layer-new image imgWidth imgHeight RGBA-IMAGE "White flare" 100 0 )))
		(l_fringe (car (gimp-layer-new image imgWidth imgHeight RGBA-IMAGE "frame" 100 NORMAL-MODE )))
 	)


(gimp-image-undo-group-start image)

; adjust colours
(gimp-color-balance drawable SHADOWS TRUE 30 0 0)
(gimp-brightness-contrast drawable 0 30)

; draw whiteFlare layer
(gimp-drawable-fill l_whiteFlare TRANSPARENT-FILL)
(gimp-image-add-layer image l_whiteFlare 0)
(gimp-palette-set-foreground '(255 255 255) )
(gimp-edit-blend l_whiteFlare 2 NORMAL-MODE GRADIENT-RADIAL 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE midpoint_X midpoint_Y imgWidth imgHeight)
(gimp-layer-set-mode l_whiteFlare OVERLAY-MODE)
(gimp-layer-set-opacity l_whiteFlare 80)

; draw fringe
(gimp-drawable-fill l_fringe TRANSPARENT-FILL)
(gimp-image-add-layer image l_fringe 0)
(gimp-rect-select image (+ 0 fringeWidth) (+ 0 fringeWidth) (- imgWidth (* 2 fringeWidth)) (- imgHeight (* 2 fringeWidth)) CHANNEL-OP-ADD TRUE (abs (/ imgWidth 10)))
(gimp-selection-invert image)
(gimp-palette-set-foreground '(0 0 0))
(gimp-edit-bucket-fill l_fringe FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
(gimp-selection-none image)
(gimp-layer-set-mode l_fringe OVERLAY-MODE)
(gimp-image-add-layer image (car (gimp-layer-copy l_fringe FALSE)) 0)

(if (= fringeBoost TRUE) 
	(gimp-image-add-layer image (car (gimp-layer-copy l_fringe FALSE)) 0))

; clean up.
(gimp-image-undo-group-end image)

; flush display to the user
(gimp-displays-flush)

)
)

(script-fu-register "script-fu-lomo"
		    _"<Image>/Script-Fu/Photo/Lomography..."
		    "Turn an image into a 'LOMO' snap. \n\nwww.lomography.com for those that are not sure what lomo's are.\n\nEnjoy!"
		    "Avi Bercovich <avi@sillypages.org>"
		    "Avi Bercovich"
		    "April 2003" 
		    "RGB* GRAY* INDEXED*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
				SF-ADJUSTMENT "Fringe offset" '(4 1 10 1 10 0 1)
				SF-TOGGLE "Boost fringe?" FALSE
)
