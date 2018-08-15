; Scale 25% is a script for The GIMP
;
; Description: scales the image down to 25% and applies unsharp mask
;
; Version 2.0
; Last changed: 15.02.2007
;
; Copyright (C) 2004 Dr. Martin Rogge <marogge@onlinehome.de>
;
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

(define (script-mr-scale25 img draw)
  (define (round x) (trunc (+ x 0.5)))
  (gimp-image-undo-group-start img)
  (gimp-image-flatten img)
  (set! width  (round (/ (car (gimp-image-width  img)) 4)))
  (set! height (round (/ (car (gimp-image-height img)) 4)))
  (gimp-image-scale img width height)
  (gimp-image-undo-group-end img)
  (set! draw (car (gimp-image-get-active-drawable img)))
  (plug-in-unsharp-mask 1 img draw 1.0 0.3 0)
  (gimp-displays-flush)
)

(script-fu-register 
  "script-mr-scale25"
  "<Image>/Script-Fu/Scale 25%"
  "Scale image to 25% of original size and unsharp mask"
  "Dr. Martin Rogge <marogge@onlinehome.de>"
  "Dr. Martin Rogge"
  "21/12/2004 to 15/02/2007"
  "RGB* GRAY*"
  SF-IMAGE    "Image"         0
  SF-DRAWABLE "Drawable"      0
)
