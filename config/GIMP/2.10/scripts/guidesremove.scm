; guidesremove.scm --- Remove a grid of guides to your image

; Author: Branko Collin <collin@xs4all.nl>
; Created: 29 August 2001
; Version: 0.1
; Keywords: GIMP, guides, grid

; Copyright (C) 2001 Branko Collin <collin@xs4all.nl>
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

; This script removes all available guides for an image. In the first 
; place it is intended as a companion to the Grid of Guides script,
; but it can of course be used in any situation where you want to 
; remove lots of guides at once. WARNING: the script does not check
; if you really want to remove all guides, so be careful using it.
;
; Thanks go to Brendon Humphrey who, in his Perl-fu Remove Guides 
; script, showed a trick to refresh the image window.

(define 
    (script-fu-guides-remove img drawable)

    ; how about setting up some variables?

    (let* ((curr-guide 0))
         
        (gimp-undo-push-group-start img)

        ; clear all currently available guides!

        (set! curr-guide (car (gimp-image-find-next-guide img 0)))

        (while (> curr-guide 0) 
            (gimp-image-delete-guide img curr-guide)
            (set! curr-guide (car (gimp-image-find-next-guide img 0))))

        ; refresh display
        (gimp-selection-all img)
        (gimp-selection-none img)

        (gimp-undo-push-group-end img)
        (gimp-displays-flush)))

(script-fu-register "script-fu-guides-remove"
    _"<Image>/Guides/Remove Guides"
    _"Removes a grid of guides."
    "Branko Collin"
    "Branko Collin"
    _"August 2001"
    "RGB* GRAY* INDEXED*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0)

;;; guidegrid.scm ends here