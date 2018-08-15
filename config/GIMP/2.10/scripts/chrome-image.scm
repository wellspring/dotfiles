; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Chrome image script  for GIMP 1.2
; Copyright (C) 2001-2002 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/07/22
;     - Initial relase
; version 0.1a by Iccii 2001/07/23
;     - Fixed some bugs in curve caluclation
; version 0.1a by Iccii 2001/10/08
;     - Added Color option (which enable only RGB image type)
; version 0.1b 2002/02/25 Iccii <iccii@hotmail.com>
;     - Added Contrast option
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


	;; �N���[�����ɂ���X�N���v�g
(define (script-fu-chrome-image
			img		;; �Ώۉ摜
			drawable	;; �Ώۃh���A�u��
			color		;; �N���[���̐F
			contrast	;; �R���g���X�g
			deform		;; ���摜������x����
			random		;; �N���[�����˂̉�
			emboss?		;; �G���{�X�����̗L��
	)

  (let* (
	 (width (car (gimp-drawable-width drawable)))
	 (height (car (gimp-drawable-height drawable)))
	 (old-fg (car (gimp-palette-get-foreground)))
	 (image-type (if (eqv? (car (gimp-drawable-is-gray drawable)) TRUE)
                         GRAYA-IMAGE
                         RGBA-IMAGE))
	 (layer-color (car (gimp-layer-new img width height image-type
	                                   "Color Layer" 100 OVERLAY-MODE)))
	 (point-num (+ 2 (* random 2)))
	 (step (/ 255 (+ (* random 2) 1)))
	 (control_pts (cons-array (* point-num 2) 'byte))
         (count 0)
        )

	;; ��������
    (gimp-undo-push-group-start img)
    (if (eqv? (car (gimp-drawable-is-gray drawable)) FALSE)
        (gimp-desaturate drawable))
    (plug-in-gauss-iir2 1 img drawable deform deform)
    (if (eqv? emboss? TRUE)
        (plug-in-emboss 1 img drawable 30 45.0 20 1))

	;; �J�[�u�c�[���̏�������
    (while (< count random)
      (aset control_pts (+ (* count 4) 2) (* step (+ (* count 2) 1)))
      (aset control_pts (+ (* count 4) 3) (+ 128 contrast))
      (aset control_pts (+ (* count 4) 4) (* step (+ (* count 2) 2)))
      (aset control_pts (+ (* count 4) 5) (- 128 contrast))
      (set! count (+ count 1)))
    (aset control_pts 0 0)
    (aset control_pts 1 0)
    (aset control_pts (- (* point-num 2) 2) 255)
    (aset control_pts (- (* point-num 2) 1) 255)
    (gimp-curves-spline drawable VALUE-LUT (* point-num 2) control_pts)

	;; �摜�^�C�v�� RGBA �̎������F�t������
    (if (eqv? image-type RGBA-IMAGE)
        (begin
          (gimp-palette-set-foreground color)
          (gimp-edit-fill layer-color FG-IMAGE-FILL)
          (gimp-image-add-layer img layer-color -1)
        )
     )

	;; �㏈��
    (gimp-palette-set-foreground old-fg)
    (gimp-undo-push-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
  "script-fu-chrome-image"
  "<Image>/Script-Fu/Stencil Ops/Chrome Image..."
  "Create chrome image"
  "Iccii <iccii@hotmail.com>"
  "Iccii"
  "2002, Feb"
  "RGB* GRAY*"
  SF-IMAGE      "Image"		0
  SF-DRAWABLE   "Drawable"	0
  SF-COLOR      "Color"         '(255 127 0)
  SF-ADJUSTMENT "Contrast"      '(96 0 127 1 1 0 0)
  SF-ADJUSTMENT "Deformation"   '(10 1 50 1 10 0 0)
  SF-ADJUSTMENT "Ramdomeness"   '(4 1 7 1 10 0 1)
  SF-TOGGLE     "Enable Emboss" TRUE
)
