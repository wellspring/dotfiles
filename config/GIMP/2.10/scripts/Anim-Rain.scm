; Animted Rain 0.1
; By daoo

(define (script-fu-anim-rain img drawable frames lenght angel layermode playback)
  (let* (
    (nr 1)
    (oldfg (car (gimp-context-get-foreground)))
    (oldbg (car (gimp-context-get-background)))
    (layermode
      (cond
        ((= layermode 0) MULTIPLY-MODE)
        ((= layermode 1) DIVIDE-MODE)
        ((= layermode 2) SCREEN-MODE)
        ((= layermode 3) OVERLAY-MODE)
        ((= layermode 4) DODGE-MODE)
        ((= layermode 5) BURN-MODE)
        ((= layermode 6) SOFTLIGHT-MODE)
        ((= layermode 7) GRAIN-MERGE-MODE)
        ((= layermode 8) ADDITION-MODE)
        ((= layermode 9) SUBTRACT-MODE)
        ((= layermode 10) VALUE-MODE)
      )
    )
    (invert
      (cond
        ((equal? layermode SCREEN-MODE) 1)
        ((equal? layermode OVERLAY-MODE) 1)
        ((equal? layermode DODGE-MODE) 1)
        ((equal? layermode SOFTLIGHT-MODE) 1)
        ((equal? layermode ADDITION-MODE) 1)
        ((equal? layermode SUBTRACT-MODE) 1)
      )
    )
  )
  (gimp-image-undo-group-start img)
  (gimp-context-set-foreground '(255 255 255))

  (while (<= nr frames)
    (begin
      (set! newcopy (car (gimp-layer-copy drawable 1)))
      (gimp-image-add-layer img newcopy -1)

      (set! rain (car (gimp-layer-copy drawable 1)))
      (gimp-image-add-layer img rain -1)
      (gimp-edit-fill rain 2)
      (plug-in-scatter-rgb 1 img rain 0 0 0.63 0.63 0.63 0)
      (plug-in-mblur 1 img rain 0 lenght angel 0 0)
      (gimp-layer-set-mode rain layermode)
      (if (= invert 1)
        (gimp-invert rain)
      )
      (gimp-image-merge-down img rain 0)
      (set! nr (+ nr 1))
    ) ; Endbegin
  ) ; Endwhile

  (gimp-image-remove-layer img drawable)

  (gimp-image-undo-group-end img)

  (gimp-context-set-background oldbg)
  (gimp-context-set-foreground oldfg)
  (gimp-displays-flush)

  (if (= playback TRUE)
    (plug-in-animationplay 0 img newcopy)
  ) ; Endif
))
(script-fu-register "script-fu-anim-rain"
  "Animated Rain..."
  "Adds an animated rain effect to your image."
  "daoo"
  "2006, daoo"
  "2006"
  "RGBA RGB"
  SF-IMAGE      "img"                           0
  SF-DRAWABLE   "drawable"                      0
  SF-ADJUSTMENT "Number of Frames"              '(5 3 100 1 1 0 0)
  SF-ADJUSTMENT "Rain Lenght"                   '(10 0 256 1 1 0 0)
  SF-ADJUSTMENT "Rain Angel"                    '(135 0 360 1 1 0 0)
  SF-OPTION     "Type of layer mode"            '("Multiply" "Divide" "Screen" "Overlay" "Dodge" "Burn" "Soft Light" "Grain Merge" "Addition" "Subtract" "Value")
  SF-TOGGLE     "Start Playback when finished?" TRUE
)

(script-fu-menu-register "script-fu-anim-rain"
  "<Image>/Script-Fu/_daoo's script-fu/_Animation")