; Gimp Script-Fu for stereoscopic image composition
; Author:   Ricardo Fernandes Lopes, rfl@linuxmail.org
; Date:     12-Oct-2001
; Revision: 25-Apr-2004

; Align and Compose stereoscopic image in anaglyph or side-by-side
; stereo-pair from already openned Left and Right images.
; The guidelines (one horizontal and one vertical for each image) can be used to define 
; reference lines. The script will align the final image based on that references and
; the final image will be cropped as appropriate.

; 25-Apr-2004
; Revision due to changes in GIMP 2.0:
;   gimp-ops-channels-duplicate replaced by gimp-image-duplicate
;   changes in the aguments of plug-in-decompose
;   constant RGB_IMAGE becames GIMP_RGB_IMAGE (0)
;   constant NORMAL becames GIMP_NORMAL_IMAGE (0)

;=====================================================================
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
;=====================================================================


;===== ANAGLYPH =====================================================
(define (script-fu-anaglyph inLeftImage
                            inRightImage
                            type)

  (let* ((LeftImage (car (gimp-image-duplicate inLeftImage)))
         (RightImage (car (gimp-image-duplicate inRightImage)))
         (old_bg (car (gimp-palette-get-background)))
         (RedImage 0)
         (GreenImage 0)
         (BlueImage 0)
         (NewImage 0))

    (align-and-crop LeftImage RightImage)

    ; Convert images to grayscale
    (if (= type 0)
      () 
      (begin
        (gimp-desaturate (car (gimp-image-get-active-layer LeftImage)))
        (gimp-desaturate (car (gimp-image-get-active-layer RightImage)))
      )
    )

    ; Decompose: Red-Green-Blue
    (set! RedImage   (car (plug-in-decompose 1 
                                             LeftImage
                                             (car (gimp-image-get-active-layer LeftImage))
                                             "Red" 1)))
    (set! GreenImage (car (plug-in-decompose 1 
                                             RightImage
                                             (car (gimp-image-get-active-layer RightImage))
                                             "Green" 1)))
    (set! BlueImage (car (plug-in-decompose 1 
                                            RightImage
                                            (car (gimp-image-get-active-layer RightImage))
                                            "Blue" 1)))
    ; Discard temporary images
    (gimp-image-delete LeftImage)
    (gimp-image-delete RightImage)

    ; Clear color channel according to anaglyph type
    (gimp-palette-set-background '(0 0 0))
    (cond
      ((= type 2)                                                     ; Red-Blue anaglyph
        (gimp-drawable-fill (car (gimp-image-get-active-layer GreenImage))
                            BG-IMAGE-FILL))
      ((= type 3)                                                     ; Red-Green anaglyph
        (gimp-drawable-fill (car (gimp-image-get-active-layer BlueImage))
                            BG-IMAGE-FILL))
    )
    (gimp-palette-set-background old_bg)

    ; Compose anaglyph
    (set! NewImage (car (plug-in-compose 1
                                         RedImage
                                         (car (gimp-image-get-active-layer RedImage))
                                         GreenImage
                                         BlueImage
                                         RedImage
                                         "RGB")))
    ; Discard temporary images
    (gimp-image-delete RedImage)
    (gimp-image-delete GreenImage)
    (gimp-image-delete BlueImage)

    ; Show anaglyph
    (gimp-display-new NewImage)
    (gimp-image-clean-all NewImage)
  )
)

;===== STEREOPAIR ===================================================
(define (script-fu-stereopair inLeftImage
                              inRightImage
                              inMethod
                              inBarSize
                              inBarColor)

  (let* ((LeftImage (car (gimp-image-duplicate inLeftImage)))
         (RightImage (car (gimp-image-duplicate inRightImage)))
         (NewImage 0))

    (align-and-crop LeftImage RightImage)

    (set! NewImage
          (car (cond
            ((= inMethod 0) (create-side-by-side RightImage            ; Crossed
                                                 LeftImage
                                                 inBarSize
                                                 inBarColor))
            ((= inMethod 1) (create-side-by-side LeftImage             ; Parallel
                                                 RightImage
                                                 inBarSize
                                                 inBarColor))
            ((= inMethod 2) (gimp-flip (car (gimp-image-get-active-layer RightImage)) HORIZONTAL)
                            (create-side-by-side LeftImage
                                                 RightImage
                                                 inBarSize
                                                 inBarColor))
          ))
    )

    ; Discard temporary images
    (gimp-image-delete RightImage)
    (gimp-image-delete LeftImage)

    ; Show stereo-pair
    (gimp-display-new NewImage)
    (gimp-image-clean-all NewImage)
  )
)

;--------------------------------------------------------------------
; Place two drawables side by side separated by a vertical bar

(define (create-side-by-side inLeftImage
                             inRightImage
                             inBarSize
                             inBarColor)
  (let* ((LeftDrawable (car (gimp-image-get-active-layer inLeftImage)))
         (RightDrawable (car (gimp-image-get-active-layer inRightImage)))
         (old-bg (car (gimp-palette-get-background)))
         (WidthLeft  (car (gimp-image-width  inLeftImage)))
         (WidthRight (car (gimp-image-width  inRightImage)))
         (Height (max (car (gimp-image-height inLeftImage))         ; Find max height
                      (car (gimp-image-height inRightImage))))
         (NewImage  (car (gimp-image-new (+ WidthLeft WidthRight inBarSize)
                                         Height
                                         RGB)))
         (NewLayer (car (gimp-layer-new NewImage
                                        (+ WidthLeft WidthRight inBarSize)
                                        Height
                                        0     ; GIMP_RGB_IMAGE
                                        "New"
                                        100
                                        0)))) ; GIMP_NORMAL_MODE

    (gimp-palette-set-background inBarColor) ; Separation bar color

    ; Prepare new image
    (gimp-image-add-layer NewImage NewLayer 0)
    (gimp-selection-all NewImage)
    (gimp-edit-clear NewLayer)

    ; Place Left image
    (gimp-selection-all (car (gimp-drawable-image LeftDrawable)))
    (gimp-edit-copy LeftDrawable)
    (gimp-layer-set-offsets (car (gimp-edit-paste NewLayer FALSE)) 0 0)
    (gimp-floating-sel-anchor (car (gimp-image-floating-selection NewImage)))

    ; Place Right image
    (gimp-selection-all (car (gimp-drawable-image RightDrawable)))
    (gimp-edit-copy RightDrawable)
    (gimp-layer-set-offsets (car (gimp-edit-paste NewLayer FALSE))
                            (+ WidthLeft inBarSize )
                            0)
    (gimp-floating-sel-anchor (car (gimp-image-floating-selection NewImage)))

    ; Restore Background color
    (gimp-palette-set-background old-bg)

    ; Return the side-by-side created image
    (list NewImage)
  )
)

;--------------------------------------------------------------------
; Align two images matching the last entered guidelines then
; crop both images to the same size
(define (align-and-crop image1
                        image2)

  (let* ((Yoffset1 0) ; Vertical offset for image 1
         (Yoffset2 0) ; Vertical offset for image 2
         (Xoffset1 0) ; Horizontal offset for image 1
         (Xoffset2 0) ; Horizontal offset for image 2
         (Xoffset 0)
         (Yoffset 0)
         (Height 0)  ; Vertical size for final image
         (Width  0)) ; Horizontal size for final image

    ; Get guidelines from Images as references
    (let* ((id 0)
           (Xref1 0)
           (Yref1 0)
           (Xref2 0)
           (Yref2 0))
      ; Get guidelines position for image 1
      (set! id (car (gimp-image-find-next-guide image1 0)))
      (while (not (equal? 0 id))
        (if (= (car (gimp-image-get-guide-orientation image1 id)) HORIZONTAL)
          (set! Yref1 (car (gimp-image-get-guide-position image1 id)))
          (set! Xref1 (car (gimp-image-get-guide-position image1 id)))
        )
        (set! id (car (gimp-image-find-next-guide image1 id)))
      )
      ; Get guidelines position for image 2
      (set! id (car (gimp-image-find-next-guide image2 0)))
      (while (not (equal? 0 id))
        (if (= (car (gimp-image-get-guide-orientation image2 id)) HORIZONTAL)
          (set! Yref2 (car (gimp-image-get-guide-position image2 id)))
          (set! Xref2 (car (gimp-image-get-guide-position image2 id)))
        )
        (set! id (car (gimp-image-find-next-guide image2 id)))
      )
      (set! Xoffset (- Xref2 Xref1))
      (set! Yoffset (- Yref2 Yref1))
    )

    ; Calculate Vertical offset for each image
    (if (< Yoffset 0)
      (set! Yoffset1 (abs Yoffset))
      (set! Yoffset2 Yoffset)
    )

    ; Calculate Horizontal offset for each image
    (if (< Xoffset 0)
      (set! Xoffset1 (abs Xoffset))
      (set! Xoffset2 Xoffset)
    )

    ; Vertical Cropping size
    (set! Height (min (- (car (gimp-image-height image2))
                         Yoffset2)
                      (- (car (gimp-image-height image1))
                         Yoffset1)))

    ; Horizontal cropping size
    (set! Width (min (- (car (gimp-image-width image2))
                        Xoffset2)
                     (- (car (gimp-image-width image1))
                        Xoffset1)))

    ; Align and crop images
    (gimp-crop image1 Width Height Xoffset1 Yoffset1)
    (gimp-crop image2 Width Height Xoffset2 Yoffset2)
  )
)

; FUNCTION REGISTRATION =============================================

(script-fu-register "script-fu-anaglyph"
                    _"<Toolbox>/Xtns/Script-Fu/Stereoscopic/_Anaglyph..."
                    "Creates a Stereoscopic Anaglyph from Left and Right images. Use the guidelines as alignment reference. The resulting image can be viewed with red-blue or red-green glasses (red lens at left eye)."
                    "Ricardo F. Lopes: rfl@linuxmail.org"
                    "Ricardo F. Lopes"
                    "December 2004 - v2.0"
                    "RGB"
                    SF-IMAGE   _"_Left Image"    0
                    SF-IMAGE   _"_Right Image"   1
                    SF-OPTION  _"Anaglyph _Type" '(_"Red-Cyan (Color)"
                                                   _"Red-Cyan (B&W)"
                                                   _"Red-Blue"
                                                   _"Red-Green")
)

(script-fu-register "script-fu-stereopair"
                    _"<Toolbox>/Xtns/Script-Fu/Stereoscopic/_Stereo Pair..."
                    "Creates a Stereo-pair from Left and Right images. Use the guidelines as alignment reference. The resulting image can be viewed with a proper stereo viewer or (for those initiated) free-viewed."
                    "Ricardo F. Lopes: rfl@linuxmail.org"
                    "Ricardo F. Lopes"
                    "December 2004 - v2.0"
                    "RGB"
                    SF-IMAGE      _"_Left Image"  0
                    SF-IMAGE      _"_Right Image" 1
                    SF-OPTION     _"_View Method" '(_"Crossed"
                                                    _"Parallel"
                                                    _"Mirror")
                    SF-ADJUSTMENT _"Bar _Size"    '(10 0 200 1 10 0 0)
                    SF-COLOR      _"Bar _Color"   '(0 0 0)
)

