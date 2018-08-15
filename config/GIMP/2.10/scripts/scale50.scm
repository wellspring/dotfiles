; Scale 50% is a script for The GIMP
;
; Description: scales the image down to 50% and applies unsharp mask
;
; Last changed: 21.12.2004
;
; Copyright (C) 2004 Dr. Martin Rogge <marogge@onlinehome.de>
; Modified by Yop Nono from scaling 25% to 50%
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

(define (script-mr-scale50 img draw)
  (gimp-image-undo-group-start img)
  (gimp-image-flatten img)
  (set! width  (/ (car (gimp-image-width  img)) 2))
  (set! height (/ (car (gimp-image-height img)) 2))
  (gimp-image-scale img width height)
  (gimp-image-undo-group-end img)
  (set! draw (car (gimp-image-get-active-drawable img)))
  (plug-in-unsharp-mask 1 img draw 1.0 0.3 0)
  (gimp-displays-flush)
)

(script-fu-register 
  "script-mr-scale50"
  "<Image>/Script-Fu/Scale 50%"
  "Scale image to 50% of original size and unsharp mask"
  "Dr. Martin Rogge <marogge@onlinehome.de>"
  "Dr. Martin Rogge, Yop Nono"
  "21/12/2004"
  "RGB*"
  SF-IMAGE    "Image"         0
  SF-DRAWABLE "Drawable"      0
)
