; 0.1 : Original version
; 0.2 : Ported to Gimp2 by Raymond Ostertag

(define (script-fu-feurio-logo inText inFont inFontSize inTextColor inRed1 inRed2 inGreen1 inGreen2 inBlue1 inBlue2 inHeight inBlurRadius inAbsolute inImageWidth inImageHeight inFlatten)
  (let*
    (
      (img  ( car (gimp-image-new 10 10 RGB) ) )
      (theText)
      (theTextWidth)
      (theTextHeight)
      (imgWidth)
      (imgHeight)
      (theBufferX)
      (theBufferY)
      (theSel)

      (theLayer (car (gimp-layer-new img 10 10 RGB-IMAGE "Layer 1" 100 NORMAL-MODE) ) )
      (theTextLayer (car (gimp-layer-new img 10 10 RGB-IMAGE "Layer 2" 100 NORMAL-MODE) ) )
      (theFeurioLayer (car (gimp-layer-new img 10 10 RGB-IMAGE "Layer 3" 100 NORMAL-MODE) ) )
      (theTextMask)
      (theFeurioMask)

      (old-fg (car (gimp-palette-get-foreground) ) )
      (old-bg (car (gimp-palette-get-background) ) )
    )

    (define (splineRed)
      (let* ((a (cons-array 6 'byte)))
        (set-pt a 0 0 0)
        (set-pt a 1 inRed1 inRed2)
        (set-pt a 2 255 255)
        a
      )
    )
    (define (splineGreen)
      (let* ((a (cons-array 6 'byte)))
        (set-pt a 0 0 0)
        (set-pt a 1 inGreen1 inGreen2)
        (set-pt a 2 255 255)
        a
      )
    )
    (define (splineBlue)
      (let* ((a (cons-array 6 'byte)))
        (set-pt a 0 0 0)
        (set-pt a 1 inBlue1 inBlue2)
        (set-pt a 2 255 255)
        a
      )
    )

    (gimp-image-add-layer  img theLayer 0)
    (gimp-image-add-layer  img theTextLayer 0)

    (gimp-palette-set-background '(0 0 0) )
    (gimp-palette-set-foreground '(255 255 255) )

    (gimp-selection-all  img)
    (gimp-edit-clear     theLayer)
    (gimp-edit-clear     theTextLayer)
    (gimp-edit-clear     theFeurioLayer)
    (gimp-selection-none img)

    (set! theText (car (gimp-text-fontname img theLayer 0 0 inText 0 TRUE inFontSize PIXELS inFont)))

    (set! theTextWidth  (car (gimp-drawable-width  theText) ) )
    (set! theTextHeight (car (gimp-drawable-height theText) ) )

    (set! imgWidth inImageWidth )
    (set! imgHeight inImageHeight )

  	(if (= inAbsolute FALSE)
      (set! imgWidth (+ theTextWidth (* 3 inHeight) ) )
    )

  	(if (= inAbsolute FALSE)
      (set! imgHeight (+ theTextHeight (* 4 inHeight) ) )
    )

    (set! theBufferX (/ (- imgWidth theTextWidth) 2) )
    (set! theBufferY (/ (- imgHeight theTextHeight) 2) )

    (gimp-image-resize img imgWidth imgHeight 0 0)
    (gimp-layer-resize theLayer imgWidth imgHeight 0 0)
    (gimp-layer-resize theTextLayer imgWidth imgHeight 0 0)
    (gimp-layer-resize theFeurioLayer imgWidth imgHeight 0 0)

    (gimp-layer-set-offsets   theText theBufferX theBufferY)
    (gimp-floating-sel-anchor theText theLayer)

    (gimp-edit-copy theLayer)

    (gimp-palette-set-foreground inTextColor )
    (gimp-edit-bucket-fill theTextLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)

    (plug-in-bump-map 1 img theTextLayer theLayer 135.0 45.0 3 0 0 0 0 TRUE FALSE 2)

    (gimp-layer-add-alpha theTextLayer)
 	  (set! theTextMask (car (gimp-layer-create-mask theFeurioLayer ADD-WHITE-MASK)))
    (gimp-layer-add-mask theTextLayer theTextMask)

    (set! theSel (car (gimp-edit-paste theTextMask FALSE)))
    (gimp-floating-sel-anchor theSel)

    (gimp-layer-remove-mask theTextLayer MASK-APPLY)

    (gimp-palette-set-foreground '(255 255 255) )

    (set! theFeurioLayer (car (gimp-layer-copy theLayer 0) ) )
    (gimp-image-add-layer img theFeurioLayer 0)

    (gimp-image-set-active-layer img theFeurioLayer)
    (gimp-by-color-select theFeurioLayer '(255 255 255) 15 0 FALSE FALSE 10 FALSE)
    (gimp-selection-grow img (/ inHeight 5))
    (gimp-edit-bucket-fill theFeurioLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-palette-set-foreground '(128 128 128) )
    (gimp-selection-shrink img (/ inHeight 5))
    (gimp-edit-bucket-fill theFeurioLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
    (gimp-selection-none img)
    (gimp-palette-set-foreground '(255 255 255) )

    (plug-in-ripple 1 img theFeurioLayer inHeight inHeight 1 0 1 TRUE FALSE)
    (plug-in-ripple 1 img theFeurioLayer (* 2 inHeight) (/ inHeight 3) 1 0 1 TRUE FALSE)
    (plug-in-spread 1 img theFeurioLayer inHeight inHeight)

    (gimp-layer-add-alpha theFeurioLayer)
 	  (set! theFeurioMask (car (gimp-layer-create-mask theFeurioLayer ADD-WHITE-MASK)))
    (gimp-layer-add-mask theFeurioLayer theFeurioMask)
    (gimp-edit-blend theFeurioMask FG-BG-RGB-MODE NORMAL-MODE GRADIENT-LINEAR 100 0 REPEAT-NONE FALSE FALSE 0 0 FALSE 0 theBufferY 0 (- imgHeight theBufferY))

    (plug-in-gauss-iir 1 img theFeurioLayer inBlurRadius 1 1)

    (gimp-curves-spline theFeurioLayer HISTOGRAM-BLUE 6 (splineBlue))
    (gimp-curves-spline theFeurioLayer HISTOGRAM-GREEN 6 (splineGreen))
    (gimp-curves-spline theFeurioLayer HISTOGRAM-RED 6 (splineRed))

    (gimp-layer-remove-mask theFeurioLayer MASK-APPLY)

    (plug-in-gauss-iir 1 img theLayer inBlurRadius 1 1)

    (gimp-curves-spline theLayer HISTOGRAM-BLUE 6 (splineBlue))
    (gimp-curves-spline theLayer HISTOGRAM-GREEN 6 (splineGreen))
    (gimp-curves-spline theLayer HISTOGRAM-RED 6 (splineRed))

  	(if (= inFlatten TRUE)
      (gimp-image-flatten img)
  		()
  	)

    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)

    (gimp-display-new img)
    (list  img theLayer theText)

    ; Bereinigen Dirty-Flag
    ;(gimp-image-clean-all img)

  )
)

(script-fu-register
  "script-fu-feurio-logo"
  "<Toolbox>/Xtns/Script-Fu/Logos/Feurio..."
  "Creates a burning text logo."
  "Michael Schalla <mschalla@bigfoot.de>"
  "Michael Schalla"
  "October 2000"
  ""
  SF-STRING "Text"               "Feurio"
  SF-FONT   "Font"               "-*-Arial Black-*-r-*-*-24-*-*-*-p-*-*-*"
  SF-ADJUSTMENT "Font Size"      '(100 2 1000 1 10 0 1)
  SF-COLOR  "Color"              '(224 0 0)
  SF-ADJUSTMENT "Red 1"          '(64 0 255 1 1 0 1)
  SF-ADJUSTMENT "Red 2"          '(224 0 255 1 1 0 1)
  SF-ADJUSTMENT "Green 1"        '(128 0 255 1 1 0 1)
  SF-ADJUSTMENT "Green 2"        '(128 0 255 1 1 0 1)
  SF-ADJUSTMENT "Blue 1"         '(224 0 255 1 1 0 1)
  SF-ADJUSTMENT "Blue 2"         '(64 0 255 1 1 0 1)
  SF-ADJUSTMENT "Flame Height"   '(25 1 1000 1 1 1 1)
  SF-ADJUSTMENT "Blur Radius"    '(5 1 100 1 1 1 1)
  SF-TOGGLE "Absolute Size?"     FALSE
  SF-VALUE  "Image Width"        "400"
  SF-VALUE  "Image Height"       "150"
  SF-TOGGLE "Flatten Layers?"    FALSE
)

