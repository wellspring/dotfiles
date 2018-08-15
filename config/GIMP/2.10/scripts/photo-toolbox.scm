;
; photo-toolbox
;
; Sebastien Gross <seb DASH gimp AT chezwam DOT org>

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


(define (for-each proc seq)
  (if (not (null? seq))
    (begin
      (proc (car seq))
      (for-each proc (cdr seq)))))

(set! desaturate-list '(
  ("None" (0 0 0))
  ("All" (0 0 0))
  ("Agfa 200X" (18 41 41))
  ("Agfapan 25" (25 39 36))
  ("Agfapan 100" (21 40 39))
  ("Agfapan 400" (20 41 39))
  ("Ilford Delta 100" (21 42 37))
  ("Ilford Delta 400" (22 42 36))
  ("Ilford Delta 400 Pro" (31 36 33)) 
  ("Ilford FP4" (28 41 31))
  ("Ilford HP5" (23 37 40))
  ("Ilford Pan F" (33 36 31)) 
  ("Ilford SFX" (36 31 33))
  ("Ilford XP2 Super" (21 42 37))
  ("Kodak Tmax 100" (24 37 39))
  ("Kodak Tmax 400" (27 36 37))
  ("Kodak Tri-X" (25 35 40))
  ("Normal Contrast" (43 33 30))
  ("High Contrast"  (40 34 60))
))


(set! colorize-list '(
  ("None" "")
  ("All" "")
  ("Palladium 1" "palladium_01.png")
  ("Platinium 1" "platinum_01.png")
  ("Sepia 1" "sepia_01.png")
))


(set! layer-toning-layer '(
  ("None" "")
  ("All" "")
  ("Selected color" "")
;  ("Sepia 1" (112 66 20))
  ("Sepia 1" (162 138 101))
  ("Sepia 2" (162 128 101))
  ("Sepia 3" (169 140 120))
  ("Sepia 4" (91 56 17))
))

(set! grain-list '(
  ("None" -1)
  ("All" -1)
;  ("Normal" 0)
;  ("Disolve" 1)
;  ("Behind" 2)
  ("Multiply" 3)
  ("Screen" 4)
  ("Overlay" 5)
;  ("Difference" 6)
;  ("Addition" 7)
;  ("Subtract" 8)
;  ("Darken Only" 9)
;  ("Lighten Only" 10)
;  ("Hue" 11)
;  ("Saturation" 12)
;  ("Color" 13)
  ("Value" 14)
  ("Divide" 15)
  ("Dodge" 16)
;  ("Burn" 17)
  ("Hard Light" 18)
  ("Soft Light" 19)
  ("Grain Extract" 20)
  ("Grain Merge" 21)
;  ("Color Erase" 22)
))

(define (tone-spline)
  (let* ((a (cons-array 8 'byte)))
  (set-pt a 0 0 0)
  (set-pt a 1 127 127)
  (set-pt a 2 255 0)
  a))

(define (grain-spline)
  (let* ((a (cons-array 8 'byte)))
  (set-pt a 0 0 0)
  (set-pt a 1 127 127)
  (set-pt a 2 255 0)
  a))



(define (get-list-names l)
  (set! result '())
  (for-each (lambda (item) (set! result (append result (list (car item)))))
    l)
  result)

(define (get-list-item l i)
  (if (< i (length l))
    (lref-default l i)))

(define (triple-expand l)
  (set! a1 (car l))
  (set! a2 (cadr l))
  (set! a3 (caddr l))
  (list a1 a2 a3 a1 a2 a3 a1 a2 a3)
)

(define (duplicate-layer image layer name mode paste)
; This snipplet does not seems to work
;  (set! new-layer (car (gimp-layer-copy layer TRUE)))
;  (gimp-drawable-set-name new-layer name)
;  (gimp-image-add-layer image new-layer )
;  new-layer)
  (set! width (car (gimp-image-width image)))
  (set! height (car (gimp-image-height image)))
  (set! new-layer (car (gimp-layer-new image width height
    RGBA-IMAGE name 100 mode)))
  (gimp-image-add-layer image new-layer 0)
  (if paste
    (begin
      (set! floating-sel (car (gimp-edit-paste new-layer FALSE)))
      (gimp-floating-sel-anchor floating-sel))
    ())
  new-layer)



(define (do-desaturate image layer index inDoBrCo inBrightness inContrast)
  (set! ds-option (get-list-item desaturate-list index))
  (set! a1 (/ (car (cadr ds-option)) 100))
  (set! a2 (/ (cadr (cadr ds-option)) 100))
  (set! a3 (/ (caddr (cadr ds-option)) 100))
  (set! d-layer (duplicate-layer image layer
    (string-append "Desaturate " (car ds-option))
    NORMAL-MODE TRUE))
  (gimp-levels d-layer 0 0 255 0.9 0 255)

  (plug-in-colors-channel-mixer TRUE image d-layer FALSE
    a1 a2 a3 a1 a2 a3 a1 a2 a3)
  (if (= inDoBrCo TRUE)
    (gimp-brightness-contrast d-layer inBrightness inContrast)
    ())
  d-layer)


; This does not work since plug-in-sample-colorize is not scriptable :-(
;(define (do-colorize image layer index tones-dir)
;  (set! c-option (get-list-item colorize-list index))
;  (set! tone-file (string-append tones-dir "/" (cadr c-option)))
;  (set! d-layer (duplicate-layer image layer
;    (string-append "Colorize " (car c-option) " " tone-file ) NORMAL-MODE))
;  (set! tone-img (car (gimp-file-load TRUE tone-file tone-file)))
;  (set! tone-layer (car (gimp-image-get-active-drawable tone-img)))
;  (plug-in-sample-colorize 0 image d-layer tone-layer
;                           TRUE TRUE TRUE TRUE
;                           0 255 1.0
;                           0 255)
;  (gimp-drawable-set-name d-layer "Colorize done")
;  )


(define (create-layer-mask layer tone tone-size)
  (set! mask (car (gimp-layer-create-mask layer 0)))
  (gimp-layer-add-alpha layer)
  (gimp-layer-add-mask layer mask)
  (set! floating-sel (car (gimp-edit-paste mask FALSE)))
  (gimp-floating-sel-anchor floating-sel)
  (gimp-curves-spline mask 0 tone-size tone)
  (gimp-layer-set-apply-mask layer mask))



(define (do-layer-toning image layer index toning-color adjust)
  (set! t-option (get-list-item layer-toning-layer index))
  (if (= 2 index)
    (set! color toning-color)
    (set! color (cadr t-option)))
  (set! t-layer (duplicate-layer image layer
    (string-append "Layer toning: " (car t-option))
    COLOR-MODE FALSE))
  (gimp-context-set-background color)
  (gimp-edit-fill t-layer BACKGROUND-FILL)
  (if adjust
    (create-layer-mask t-layer (tone-spline) 6)
    ())
  t-layer)


(define (do-add-grain image layer index granularity holdness blur adjust)
  (set! g-option (get-list-item grain-list index))
  (set! g-layer (duplicate-layer image layer 
    (string-append "Grain: " (car g-option))
    (cadr g-option) FALSE))
  (gimp-context-set-background '(127 127 127))
  (gimp-edit-fill g-layer BACKGROUND-FILL)
  (plug-in-scatter-hsv TRUE image g-layer holdness 0 0 granularity)
  (if (> blur 0)
    (plug-in-gauss-rle TRUE image g-layer blur TRUE TRUE)
    ())
  (if (= adjust TRUE)
    (create-layer-mask g-layer (grain-spline) 6)
    ())
  g-layer)



(define (script-fu-photo-toolbox inImage inLayer
  inDoDefocus inDefocusRadius
  inDesaturate inDoBrCo inBrightness inContrast
  inLayerToning inLayerToningColor inLayerToningAdjust
  inGrainMode inGrainGranularity inGrainHoldness inGrainBlur inGrainAdjust
  inCopy)

  (gimp-image-undo-group-start inImage)
  (gimp-context-push)
  (gimp-selection-all inImage)

  (set! theImage (if (= inCopy TRUE)
    (car (gimp-image-duplicate inImage))
    inImage))

  (set! theLayer (car (gimp-image-flatten theImage)))

  (if (= inDoDefocus TRUE)
    (plug-in-gauss-rle TRUE theImage theLayer inDefocusRadius TRUE TRUE)
    ())

  (gimp-edit-copy theLayer)

  (if (> inDesaturate 0)
    (if (= inDesaturate 1)
      (begin
        (set! idx 2)
        (while (< idx (length desaturate-list))
               (gimp-drawable-set-visible (
                 do-desaturate theImage theLayer idx inDoBrCo
                   inBrightness inContrast) FALSE)
               (set! idx (+ 1 idx))))
      (do-desaturate theImage theLayer inDesaturate
                     inDoBrCo inBrightness inContrast))
    ())

;  (if (> inColorize 0)
;    (do-colorize theImage theLayer inColorize inTonesDir)
;    ())

  (if (> inLayerToning 0)
    (if (= inLayerToning 1)
      (begin
        (set! idx 2)
        (while (< idx (length layer-toning-layer))
               (gimp-drawable-set-visible (do-layer-toning theImage theLayer idx inLayerToningColor inLayerToningAdjust) FALSE)
               (set! idx (+ 1 idx))))
      (do-layer-toning theImage theLayer inLayerToning inLayerToningColor inLayerToningAdjust))
    ())

  ; Add grain
  (if (> inGrainMode 0)
    (begin
      (if (= inGrainMode 1)
        (begin
          (set! idx 2)
          (set! g-layer (do-add-grain theImage theLayer idx 
            inGrainGranularity inGrainHoldness inGrainBlur inGrainAdjust))
          (gimp-drawable-set-visible g-layer FALSE)
          (set! idx (+ 1 idx))
          (while (< idx (length grain-list))
            (set! g-option (get-list-item grain-list idx))
            (set! g-layer-2 (car (gimp-layer-copy g-layer TRUE)))
            (gimp-image-add-layer theImage g-layer-2 0)
            (gimp-layer-set-name g-layer-2 
              (string-append "Grain: " (car g-option))) 
            (gimp-layer-set-mode g-layer-2 (cadr g-option))
            (gimp-drawable-set-visible g-layer-2 FALSE)
            (set! idx (+ 1 idx)))
;          (gimp-layer-delete g-layer)
      )
    (do-add-grain theImage theLayer idx inGrainGranularity inGrainHoldness inGrainBlur inGrainAdjust)))
    ())

;    (if (= inGrainMode 1)
;      (begin
;        (set! idx 2)
;        (while (< idx (length grain-list))
;          (gimp-drawable-set-visible (do-add-grain theImage theLayer idx inGrainGranularity inGrainHoldness inGrainBlur inGrainAdjust) FALSE)
;          (set! idx (+ 1 idx))))
;      (do-add-grain theImage theLayer inGrainMode inGrainGranularity inGrainHoldness inGrainBlur inGrainAdjust))
;    ())

  (if (= inCopy TRUE)
    (begin (gimp-image-clean-all theImage)
      (gimp-display-new theImage))
    ())

  (gimp-selection-none inImage)
  (gimp-image-undo-group-end inImage)
  (gimp-displays-flush theImage)
  (gimp-context-pop))






(script-fu-register "script-fu-photo-toolbox"
  _"_Toolbox..."
	"Perform several actions on a photo in one time.

Script arguments
================

Blur photo
----------
* Do defocus: add a little blur on the photo.
* Defocus value: radisu of the defocus blur.

Desaturate
----------
(see http://serge.mankovski.com/photoblog/bw-film-simulation-in-gimp/)
* Desaturate: remove all colors (get a B&W photo)
* Do Brightness / Contrast: Run the B/C filter
* Brightness: Adjust the brightness
* Contrast: Adjust the contrast

Tone
----
(see http://www.gimpguru.org/Tutorials/SepiaToning/)
* Layer toning: tone image
* Tone Color: select manually a tone color
* Layer toning adjust: Adjust mid-tones

Grain
-----
(see http://www.gimpguru.org/Tutorials/FilmGrain/)
* Do grain: run the grain filter
* Grain adjust: Adjust mid-tones
* Grain granularity: granularity and intensity of the grain
* Grain holdness: Grain fine-tuning, higher amounts make the grain finer and less noticable.
* Grain blur: blur to smooth grain


* Work on copy: Apply filters on a copy.

TODO
====
* Add more tones
* See why gimp-layer-set-apply-mask does not work for both grain and tones
* Add more desaturate methods
* Add more adjustement methods

"

  "Sebastien Gross <seb DASH gimp AT chezwam DOT org>"
  "GPL"
  "2007 - 1.00"
  "RGB* GRAY*"
  SF-IMAGE      "The image"     0
  SF-DRAWABLE   "The layer"     0

  SF-TOGGLE      _"Do defocus" FALSE
  SF-ADJUSTMENT _"Defocus value" '(1.5 0 5 0.1 1 1 0)

  SF-OPTION     _"Desaturate" (get-list-names desaturate-list)
  SF-TOGGLE     _"Do Brightness / Contrast" TRUE
  SF-ADJUSTMENT _"Brightness"            '(-20 -100 100 1 10 0 0)
  SF-ADJUSTMENT _"Contrast"            '(-40 -100 100 1 10 0 0)


  SF-OPTION     _"Layer toning" (get-list-names layer-toning-layer)
  SF-COLOR      _"Tone Color" '(158 157 137)
  SF-TOGGLE     _"Layer toning adjust" TRUE

  SF-OPTION     _"Grain mode" (get-list-names grain-list)
  SF-ADJUSTMENT _"Grain granularity"  '(100 0 255 1 10 0 0)
  SF-ADJUSTMENT _"Grain holdness"  '(2 1 8 1 2 0 0)
  SF-ADJUSTMENT _"Grain blur"  '(0 0 5 0.1 1 1 0)
  SF-TOGGLE     _"Grain adjust" TRUE


;  SF-OPTION     _"Colorize tone" (get-list-names colorize-list)
;  SF-DIRNAME  _"Tones location" (string-append "" gimp-directory "/tones")

  SF-TOGGLE     _"Work on copy" TRUE
  )
(script-fu-menu-register "script-fu-photo-toolbox"
			 _"<Image>/Script-Fu/Photo")

; vim:ts=2:set expandtab:
