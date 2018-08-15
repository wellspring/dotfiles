; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; www.gimp.org web big header
; Copyright (c) 1997 Jens Lautenbacher
; jens@gimp.org
;
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
; Changed on June 15, 2000 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.1.26
;
; Changed on December 8 2003 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.2
;
; Changed on January 28 2004 by Kevin Cozens <kcozens@interlog.com>
; Updated for GIMP 1.3

(define (script-fu-old-stone text foundry font weight slant width
			       font-size fg-color bg-color age
			       crop rm-bg index num-colors)
  (let* ((img (car (gimp-image-new 256 256 RGB)))
	 (text-layer (car (gimp-text img -1 0 0
				     text 20 TRUE font-size PIXELS
				     foundry font weight slant width "*" "*" "*")))
	 (width (car (gimp-drawable-width text-layer)))
	 (height (car (gimp-drawable-height text-layer)))
	 (bg-layer (car (gimp-layer-new img width
					height RGB-IMAGE
					"Background" 100 NORMAL-MODE)))
	 (fg-layer (car (gimp-layer-new img width
					height RGB-IMAGE
					"fg" 100 NORMAL-MODE)))
	 (map-layer (car (gimp-layer-new img width
					height RGB-IMAGE
					"map" 100 NORMAL-MODE)))
	 (plasma-layer (car (gimp-layer-new img width
					height RGB-IMAGE
					"plasma" 100 NORMAL-MODE)))
    
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background)))
	 mask)

    (gimp-image-undo-disable img)

    ;; prepare the layers
    (gimp-image-resize img width height 0 0)
    (gimp-image-add-layer img bg-layer 1)
    (gimp-palette-set-background bg-color)
    (gimp-edit-fill bg-layer BACKGROUND-FILL)
    
    (gimp-layer-set-preserve-trans text-layer TRUE)
    (gimp-palette-set-background '(0 0 0))
    (gimp-edit-fill text-layer BACKGROUND-FILL)
    (gimp-layer-set-preserve-trans text-layer FALSE)

    (gimp-image-add-layer img map-layer 1)
    (gimp-image-add-layer img plasma-layer 1)
    (gimp-image-add-layer img fg-layer 1)

    (gimp-layer-add-alpha map-layer)
    (gimp-layer-add-alpha plasma-layer)
    (gimp-layer-add-alpha fg-layer)
    (gimp-image-lower-layer img text-layer)
    (gimp-drawable-set-visible plasma-layer FALSE)
    (gimp-drawable-set-visible map-layer FALSE)
    
    (gimp-palette-set-background '(255 255 255))
    (gimp-edit-fill map-layer BACKGROUND-FILL)

    (gimp-palette-set-background fg-color)
    (gimp-edit-fill fg-layer BACKGROUND-FILL)

    ;;start with plasma
    (plug-in-plasma 1 img plasma-layer 1 1.5)
    (gimp-desaturate plasma-layer)
    (plug-in-c-astretch 1 img plasma-layer)

    ;; to generate the "stoney" texture...
    (plug-in-blur 1 img plasma-layer)
    (plug-in-oilify 1 img plasma-layer 4 0)
    ;; ..which is used to generate the final map
    (plug-in-bump-map 1 img map-layer plasma-layer 135 45 5 0 0 0 0
		      TRUE FALSE 2)

    ;; now preparing the text
    (plug-in-spread 1 img text-layer age age)
;;    (plug-in-gauss-iir 1 img text-layer 5 TRUE TRUE)
    (plug-in-oilify 1 img text-layer age 0)
    (plug-in-gauss-iir 1 img text-layer (/ font-size 17.) TRUE TRUE)

    (plug-in-bump-map 1 img fg-layer text-layer 135 45 5 0 0 255 0
		     TRUE TRUE 0)

    (set! mask (car (gimp-layer-create-mask fg-layer 0)))
    (gimp-layer-add-mask fg-layer mask)
    (gimp-edit-copy text-layer)
    (gimp-floating-sel-anchor (car (gimp-edit-paste mask TRUE)))
    (gimp-invert mask)
    (gimp-levels mask 0 0 100 0.35 0 255)

    (gimp-drawable-offset text-layer TRUE 1 5 5)
    (gimp-layer-set-opacity text-layer 50)

    (plug-in-bump-map 1 img fg-layer map-layer 135 45 age 0 0 0 0 TRUE FALSE 2)


    (if (or (= rm-bg TRUE) (= crop TRUE) (= index TRUE))
	(begin
	  (set! text-layer (car (gimp-image-flatten img)))
	  (gimp-layer-add-alpha text-layer)))	   
	  

    (if (= rm-bg TRUE)
	(begin   
	  (gimp-by-color-select text-layer bg-color
				1 CHANNEL-OP-REPLACE TRUE FALSE 0 FALSE)
	  (gimp-edit-clear text-layer)
	  (gimp-selection-clear img)))
        
    (if (= crop TRUE)
	 (plug-in-autocrop 1 img text-layer))

    (if (= index TRUE)
	(gimp-image-convert-indexed img 0 MAKE-PALETTE num-colors 0 0 ""))
    
    (gimp-palette-set-foreground old-fg)
    (gimp-palette-set-background old-bg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)
    ))


(script-fu-register "script-fu-old-stone"
		    "<Toolbox>/Xtns/Script-Fu/Logos/Old Stone"
		    "A text logo"
		    "Jens Lautenbacher"
		    "Jens Lautenbacher"
		    "1997/1998"
		    ""
		    SF-STRING "Text String" "The Gimp"
		    SF-STRING "Foundry" "adobe"
		    SF-STRING "Family"  "utopia"
		    SF-STRING "Weight"  "bold"
		    SF-STRING "Slant"   "r"
		    SF-STRING "Width"   "normal"
		    SF-ADJUSTMENT "Size (pixels)" '(85 2 1000 1 10 0 1)
		    SF-COLOR "Text Color"  '(82 121 158)
		    SF-COLOR "Background Color" '(255 255 255)
		    SF-VALUE "Age (in whole Centuries)" "5"
		    SF-TOGGLE "AutoCrop?" FALSE
		    SF-TOGGLE "Remove Background?" FALSE
		    SF-TOGGLE "Index image?" FALSE
		    SF-VALUE "# of colors" "31"
		    )
