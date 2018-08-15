; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; Scrolled text --- create an scrolling animation text
; Copyright (C) 2001 Iccii <iccii@hotmail.com>
; 
; --------------------------------------------------------------------
;   - Changelog -
; version 0.1  2001/11/24 Iccii <iccii@hotmail.com>
;     - Initial relase
; version 0.1a 2001/11/26 Iccii <iccii@hotmail.com>
;     - Added Added Effects option (mblur, wind, block)
; version 0.1b 2001/12/04 Iccii <iccii@hotmail.com>
;     - Added Pingpong option
;     - Added Lens option in Added Effects
; version 0.1c 2001/12/12 Iccii <iccii@hotmail.com>
;     - Added Scroll Image option
;     - Added Blur option in Added Effects
; version 0.2 Raymond Ostertag 2004/09
;     - Ported to Gimp2
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


(define (script-fu-scrolled-text
			text		; 文字
			font-size	; フォントの大きさ
			fontname	; フォント名
			text-color	; 文字の色
			bg-color	; 背景の色
			bg-trans?	; 背景を透明にするかどうか
			padding		; 文字周りの空間の大きさ
			frame		; フレームの数
			angle		; スクロール方向　(0-360)
			delay		; フレームの再生遅延時間
			effect		; 特殊効果の追加
			amount		; 効果の適用量
			pingpong?	; 往復効果にするかどうか
			scroll?		; スクロールするかどうか
	)

  (let* (
	 (old-fg (car (gimp-palette-get-foreground)))
	 (old-bg (car (gimp-palette-get-background)))
	 (img (car (gimp-image-new 256 256 RGB)))
	 (dummy (gimp-palette-set-foreground text-color))
	 (text-layer (car (gimp-text-fontname img -1 0 0
			        text padding TRUE font-size PIXELS fontname)))
	 (text-width  (car (gimp-drawable-width  text-layer)))
	 (text-height (car (gimp-drawable-height text-layer)))
	 (bg-layer (car (gimp-layer-new img text-width text-height
	                                RGBA-IMAGE "Background" 100 NORMAL-MODE)))
	 (angle (cond ((= angle 0) 0)
	              ((= angle 1) 180)
	              ((= angle 2) 90)
	              ((= angle 3) 270) ))
	 (radians (/ (* 2 *pi* angle) 360))
	;; フレーム一コマ分のずらす量を定義
	 (x-shift (/ (* text-width (cos radians)) frame))
	 (y-shift (/ (* text-height (sin radians)) frame))
	 (threshold (- 255 (/ (+ (car bg-color) (cadr bg-color) (caddr bg-color)) 6)))
	 (count 0)
	)

    (gimp-image-undo-disable img)
    (gimp-image-resize img text-width text-height 0 0)
	;; デフォルトで背景は透明、背景を透明にしないのであれば色付き背景を追加
    (if (equal? bg-trans? FALSE)
        (begin
          (gimp-palette-set-background bg-color)
          (gimp-drawable-fill bg-layer BACKGROUND-FILL)
          (gimp-image-add-layer img bg-layer -1)
          (gimp-image-lower-layer img bg-layer)
          (set! text-layer (car (gimp-image-merge-down img text-layer
                                                       EXPAND-AS-NECESSARY)))))
	;; フレーム数だけ繰り返す
    (while (< count frame)
      (let* ((apply-amount (if (equal? pingpong? TRUE)
                               (* amount (sin (* (/ count frame) *pi*)))
                               (* amount (/ count frame))))
             (copyed-layer (car (gimp-layer-copy text-layer TRUE)))
             (copyed-name (string-append text "_" (number->string count)  " "
                                         "(" (number->string delay) "ms)" " "
                                         "(replace)"                         )))
        (gimp-drawable-set-name copyed-layer copyed-name)
        (gimp-image-add-layer img copyed-layer -1)
        (if (equal? scroll? TRUE)
            (gimp-drawable-offset copyed-layer TRUE OFFSET-TRANSPARENT
                                     (* x-shift count) (* y-shift count)))
	;; ずらした後のイメージに対して効果を適用する
        (cond ((= effect 1)
                 (plug-in-mblur 1 img copyed-layer 0 apply-amount angle))
              ((= effect 2)
                 (set! copyed-layer (car (gimp-rotate copyed-layer FALSE (- radians))))
                 (plug-in-wind 1 img copyed-layer threshold 1 apply-amount 0 0)
                 (set! copyed-layer (car (gimp-rotate copyed-layer FALSE radians))))
              ((= effect 3)
                 (plug-in-pixelize 1 img copyed-layer amount)
                 (gimp-threshold copyed-layer threshold 255)
                 (if (equal? bg-trans? TRUE)
                     (begin
                       (set! mask (car (gimp-layer-create-mask copyed-layer ADD-WHITE-MASK)))
                       (gimp-layer-add-mask copyed-layer mask)
                       (plug-in-grid 1 img mask 1 amount 0 '(0 0 0) 255
                                                1 amount 0 '(0 0 0) 255
                                                0      0 0 '(0 0 0) 255)
                       (gimp-layer-remove-mask copyed-layer MASK-APPLY))
                     (plug-in-grid 1 img copyed-layer 1 amount 0 bg-color 255
	       	                                      1 amount 0 bg-color 255
	      	                                      0      0 0 bg-color 255)))
              ((= effect 4)
                 (plug-in-applylens 1 img copyed-layer (+ (/ amount 50) 1) TRUE FALSE FALSE))
              ((= effect 5)
                 (if (not (equal? apply-amount 0))
                     (plug-in-gauss-iir2 1 img copyed-layer 
                                         (* apply-amount (abs (cos angle)))
                                         (* apply-amount (abs (sin angle))))))
              ('else ()))
        (set! count (+ count 1))
      ) ; end of let*
    ) ; end of while (< count frame)
    (gimp-image-remove-layer img text-layer)
    (gimp-palette-set-foreground old-fg)
    (gimp-palette-set-background old-bg)
    (gimp-image-undo-enable img)
    (gimp-display-new img)
  )
)

	; 登録など
(script-fu-register
	"script-fu-scrolled-text"
	"<Toolbox>/Xtns/Script-Fu/Animation/Scrolled Text..."
	"Create an animation (scrolled text)"
	"Iccii <iccii@hotmail.com>"
	"Iccii"
	"2001, Nov"
	""
	SF-STRING	_"Text"			"Scroll..."
	SF-ADJUSTMENT	_"Font Size (pixels)"	'(100 2 500 1 1 0 1)

	SF-FONT		_"Font"
	; Checking winsnap plug-in (Windows or not?)
(if (symbol-bound? 'extension-winsnap (the-environment))
	; For Windows user
		"-*-Times New Roman-bold-r-*-*-24-*-*-*-p-*-iso8859-1"
	; Default setting
		"-*-eras-*-r-*-*-24-*-*-*-p-*-*-*"
)

	SF-COLOR	_"Text Color"		'(0 0 0)
	SF-COLOR	_"Background Color"	'(255 255 255)
	SF-TOGGLE	_"Transparent BG"	FALSE
	SF-ADJUSTMENT	_"Padding Around Text"	'(20 0 500 1 1 0 1)
	SF-ADJUSTMENT	_"Number of Frames"	'(20 1 500 1 1 0 1)
	SF-OPTION	_"Angle"		'("Left to Right" "Right to Left"
	                                          "Upside to Down" "Lower to Upper")
	SF-ADJUSTMENT	_"Delay Time (ms)"	'(100 1 1000 1 1 0 1)
	SF-OPTION	_"Added Effects"	'("None" "Mblur" "Wind" "Block" "Lens" "Blur")
	SF-ADJUSTMENT	_"Amount of Effects"	'(40 1 100 1 1 0 0)
	SF-TOGGLE	_"Ping Pong Effects"	FALSE
	SF-TOGGLE	_"Scroll Image"		TRUE
)
