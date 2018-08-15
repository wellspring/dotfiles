;
; Version 0.1 : Original version
;
; Version 0.2 Raymond Ostertag 2004/09
;   - Ported to Gim2

(define (script-fu-bumpmap-button-logo inText inFont inFontSize inBackGroundColor inTextColor inRadius inDepth inCarved inHasBorder inBorderWidth inAbsolute inImageWidth inImageHeight inFlatten)
  (let*
    (
      (theImage  ( car (gimp-image-new inImageWidth inImageHeight RGB) ) )
      (theText)
      (theTextWidth)
      (theTextHeight)
      (theImageWidth)
      (theImageHeight)
      (theBorderWidth)
      (theBufferX)
      (theBufferY)

      (theLayer (car (gimp-layer-new theImage 10 10 RGB-IMAGE "Ebene 1" 100 NORMAL-MODE) ) )
      (theBumpmapLayer (car (gimp-layer-new theImage 10 10 RGB-IMAGE "Bumpmap" 100 NORMAL-MODE) ) )
      (theScreenLayer (car (gimp-layer-new theImage 10 10 RGB-IMAGE "Ebene 2" 100 10) ) )
      (theBehindLayer (car (gimp-layer-new theImage 10 10 RGB-IMAGE "Ebene 3" 100 9) ) )
      (theAzimuth)

      (old-fg (car (gimp-palette-get-foreground) ) )
      (old-bg (car (gimp-palette-get-background) ) )
    )
    (gimp-image-add-layer  theImage theLayer 0)
    (gimp-image-add-layer  theImage theBumpmapLayer 0)
    (gimp-image-add-layer  theImage theScreenLayer 0)
    (gimp-image-add-layer  theImage theBehindLayer 0)
    (gimp-palette-set-background inBackGroundColor )
    (gimp-palette-set-foreground inTextColor)
    (gimp-selection-all  theImage)
    (gimp-edit-clear     theLayer)
    (gimp-selection-none theImage)
    (set! theText (car (gimp-text-fontname theImage theLayer 0 0 inText 0 TRUE inFontSize PIXELS inFont)))
    (set! theTextWidth  (car (gimp-drawable-width  theText) ) )
    (set! theTextHeight (car (gimp-drawable-height theText) ) )

    (set! theImageWidth inImageWidth )
    (set! theImageHeight inImageHeight )
    (set! theBorderWidth 0)

    (if (= inHasBorder TRUE)
      (set! theBorderWidth (+ inBorderWidth 4) )
    )

  	(if (= inAbsolute FALSE)
      (begin
        (set! theImageWidth (+ theTextWidth (* theTextHeight 0.5 ) (* 2 theBorderWidth) ) )
        (set! theImageHeight (+ (* theTextHeight 1.5 ) (* 2 theBorderWidth) ) )
      )
    )

    (set! theBufferX      (/ (- theImageWidth theTextWidth) 2) )
    (set! theBufferY      (/ (- theImageHeight theTextHeight) 2) )

    (gimp-image-resize theImage theImageWidth theImageHeight 0 0)
    (gimp-layer-resize theLayer theImageWidth theImageHeight 0 0)
    (gimp-layer-resize theBumpmapLayer theImageWidth theImageHeight 0 0)
    (gimp-layer-resize theScreenLayer theImageWidth theImageHeight 0 0)
    (gimp-layer-resize theBehindLayer theImageWidth theImageHeight 0 0)

    (gimp-layer-set-offsets   theText theBufferX theBufferY)
    (gimp-floating-sel-anchor theText theLayer)
    (gimp-palette-set-background '(255 255 255) )
    (gimp-palette-set-foreground '(0 0 0) )
    (gimp-edit-clear     theBumpmapLayer)
    (gimp-edit-clear     theScreenLayer)
    (gimp-edit-clear     theBehindLayer)
    (set! theText (car (gimp-text-fontname theImage theBumpmapLayer 0 0 inText 0 TRUE inFontSize PIXELS inFont)))
    (gimp-layer-set-offsets   theText theBufferX theBufferY)
    (gimp-floating-sel-anchor theText theBumpmapLayer)

    (if (= inHasBorder TRUE)
      (begin
        (gimp-rect-select theImage 4 4 (- theImageWidth 8 ) (- theImageHeight 8 ) CHANNEL-OP-REPLACE FALSE 0 )
        (gimp-rect-select theImage theBorderWidth theBorderWidth (- theImageWidth (* 2 theBorderWidth) ) (- theImageHeight (* 2 theBorderWidth) ) CHANNEL-OP-SUBTRACT FALSE 0 )
        (gimp-palette-set-foreground inTextColor)
        (gimp-edit-bucket-fill theLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
        (gimp-palette-set-foreground '(0 0 0) )
        (gimp-edit-bucket-fill theBumpmapLayer FG-BUCKET-FILL NORMAL-MODE 100 0 FALSE 0 0)
        (gimp-selection-none theImage)
      )
    )

    (if (> inRadius 0)
      (plug-in-gauss-rle 1 theImage theBumpmapLayer inRadius TRUE TRUE)
    )
   	(set! theAzimuth 135 )
    (if (= inCarved TRUE)
    	(set! theAzimuth 315 )
    )
    (plug-in-bump-map 1 theImage theScreenLayer theBumpmapLayer theAzimuth 45.0 inDepth 0 0 0 0 TRUE FALSE 0)
    (gimp-invert theScreenLayer)
    (plug-in-bump-map 1 theImage theBehindLayer theBumpmapLayer theAzimuth 45.0 inDepth 0 0 0 0 TRUE TRUE 0)
    (gimp-drawable-set-visible theBumpmapLayer 0)
    (if (= inFlatten TRUE)
    	(gimp-image-flatten theImage)
      ()
    )
    (gimp-palette-set-background old-bg)
    (gimp-palette-set-foreground old-fg)
    (gimp-display-new     theImage)
    (list  theImage theLayer theText)
  )
)

(script-fu-register
  "script-fu-bumpmap-button-logo"
  "<Toolbox>/Xtns/Script-Fu/Logos/Bumpmap Button..."
  "Creates a simple bumpmaped text logo."
  "Michael Schalla <mschalla@bigfoot.de>"
  "Michael Schalla"
  "October 2000"
  ""
  SF-STRING "Text"             "Bumpmap"
  SF-FONT   "Font"             "-*-Arial Black-*-r-*-*-24-*-*-*-p-*-*-*"
  SF-ADJUSTMENT "Font Size"    '(100 2 1000 1 10 0 1)
  SF-COLOR  "BG Color"         '(0 0 128)
  SF-COLOR  "Color"            '(224 224 0)
  SF-ADJUSTMENT "Blur Radius"  '(1 0 100 1 1 0 1)
  SF-ADJUSTMENT "Depth"        '(3 1 100 1 1 0 1)
  SF-TOGGLE "Carve Text?"      FALSE
  SF-TOGGLE "Use Border?"      TRUE
  SF-VALUE  "Border Width"     "10"
  SF-TOGGLE "Absolute Size?"   FALSE
  SF-VALUE  "Image Width"      "450"
  SF-VALUE  "Image Height"     "150"
  SF-TOGGLE "Flatten Image?"   FALSE
)
