;
;  hexpat.scm - tile the plane hexagonally
;
;
;  Jeff Trefftzs <trefftzs@tcsn.net>
;  - original release
;  version 0.2 Raymond Ostertag <r.ostertag@caramail.com>
;  - ported to Gimp 2.0, changed menu entry
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Helper function
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-new-layer inImage inLayer layername)
  (set! new (car (gimp-layer-copy inLayer TRUE)))
  (gimp-image-add-layer inImage new -1)
  (gimp-drawable-set-name new layername)
  new
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  Main function
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (script-fu-hexpat inImage inLayer)
  (let*
      (
       (sel (if (eq? 1 (gimp-selection-is-empty inImage))
		0			; no selection
		1))			; selection active

       ;;  tweak later to handle selections

       (w0 (car (gimp-drawable-width inLayer)))
       (w2 (* 2 w0))			; Eventually double image/sel width
       (h0 (car (gimp-drawable-height inLayer)))
       (h2 (* (sqrt 3) h0))		; Eventual height
       
       ;; calculate offset for various expansions

       (hoff1 (/ w0 2))			; offset central obj to get sides
       (voff1 (/ h2 2))			; offset needed to get top/bottom

       ;;  Copy the original layer

       (central (car (gimp-layer-copy inLayer TRUE))) ; copy orig layer
       )

    (gimp-image-undo-group-start inImage)

    (gimp-image-add-layer inImage central -1)
    (gimp-drawable-set-name central "Central Motif")

    ;; Resize to final dimensions (twice the width, 1.732 * height)

    (gimp-layer-resize central w2 h2 ; new width and height
		       (/ w0 2)	; x offset - keep motif centered
		       (/ (- h2 h0) 2)) ; y offset - keep centered

    (gimp-image-resize inImage w2 h2 (/ w0 2) (/ (- h2 h0) 2))

    ;; Make 3 more copies of this layer

    (set! h1layer (make-new-layer inImage central "Horizontal Copy"))
    (set! v1layer (make-new-layer inImage central "Vertical Copy Left"))
    (set! v2layer (make-new-layer inImage central "Vertical Copy Right"))

    ;; Start offsetting the various layers

    (gimp-drawable-offset h1layer 1 OFFSET-TRANSPARENT w0 0)
    (gimp-drawable-offset v1layer 1 OFFSET-TRANSPARENT hoff1 voff1)
    (gimp-drawable-offset v2layer 1 OFFSET-TRANSPARENT (- hoff1) voff1)

    (gimp-image-set-active-layer inImage inLayer)
    (gimp-image-undo-group-end inImage)
    (gimp-displays-flush)
    )
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Register the function
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(script-fu-register
 "script-fu-hexpat"
 _"<Image>/Script-Fu/Render/Tile on a Hex Grid"
 "Takes an image (a square or circular one is best) and tiles it into a\
repeating pattern on a hex grid.  Best if you start with a circular motif on\
a transparent background.  Play with it for a while, then experiment with\
more complex motifs."
 "Jeff Trefftzs"
 "Copyright 2001, Jeff Trefftzs"
 "May 19, 2001"
 "RGB* GRAY* INDEXED*"
 SF-IMAGE "The Image" 0
 SF-DRAWABLE "The Layer" 0
)
