; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Soft focus script  for GIMP 1.2
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
; version 0.1  by Iccii 2001/07/22
;     - Initial relase
; version 0.1a Raymond Ostertag 2004/09
;     - Changed menu entry
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


	;; �\�t�g�t�H�[�J�X�X�N���v�g
(define (script-fu-soft-focus
			img		;; �Ώۉ摜
			drawable	;; �Ώۃh���A�u��
			blur		;; �ڂ������x��
	)
  (let* (
	;; �Ώۃ��C���[���R�s�[����
	 (layer-copy (car (gimp-layer-copy drawable TRUE)))
	;; �R�s�[�������C���[�ւ̃��C���[�}�X�N�����
	 (layer-mask (car (gimp-layer-create-mask layer-copy WHITE-MASK)))
        )

	;; �A���h��O���[�v�J�n
    (gimp-undo-push-group-start img)
	;; ���C���[���摜�ɒǉ�
    (gimp-image-add-layer img layer-copy -1)
	;; ���C���[�}�X�N���摜 (�R�s�[�������C���[) �ɒǉ�
    (gimp-image-add-layer-mask img layer-copy layer-mask)
	;; ���C���[�̃C���[�W���R�s�[���ĕۊǂ��Ă���
    (gimp-edit-copy layer-copy)
	;; ��������C���[�}�X�N�Ƀy�[�X�g����
    (gimp-floating-sel-anchor (car (gimp-edit-paste layer-mask 0)))
	;; ���C���[�}�X�N�����C���[�ɓK�p����
    (gimp-image-remove-layer-mask img layer-copy APPLY)
	;; �R�s�[�������C���[�ɃK�E�V�A���ڂ�����������
    (plug-in-gauss-iir2 1 img layer-copy blur blur)
	;; �R�s�[�������C���[�̕s�����x��ύX����
    (gimp-layer-set-opacity layer-copy 80)
	;; �R�s�[�������C���[�̃��[�h���X�N���[���ɕύX����
    (gimp-layer-set-mode layer-copy SCREEN-MODE)

	;; �㏈��
    (gimp-undo-push-group-end img)
    (gimp-displays-flush)
  )
)

(script-fu-register
  "script-fu-soft-focus"
  "<Image>/Script-Fu/Enhance/Soft Focus..."
  "Soft focus effect"
  "Iccii <iccii@hotmail.com>"
  "Iccii"
  "2001, Jul"
  "RGB* GRAYA"
  SF-IMAGE      "Image"		0
  SF-DRAWABLE   "Drawable"	0
  SF-ADJUSTMENT _"Blur Amount"  '(10 1 100 1 10 0 0)
)
