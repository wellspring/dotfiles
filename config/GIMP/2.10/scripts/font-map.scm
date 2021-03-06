;; font-select
;; Spencer Kimball

(define (max-font-width text use-name font-list font-size)
  (let* ((list     font-list)
	 (width    0)
	 (maxwidth 0)
	 (font     "")
	 (extents  '()))
    (while list
	   (set! font (car list))
	   (set! list (cdr list))
	   (if (= use-name TRUE)
	       (set! text font))
	   (set! extents (gimp-text-get-extents-fontname text
							 font-size PIXELS
							 font))
	   (set! width (nth 0 extents))
	   (if (> width maxwidth)
	       (set! maxwidth width)))
    maxwidth))


(define (max-font-height text use-name font-list font-size)
  (let* ((list      font-list)
	 (height    0)
	 (maxheight 0)
	 (font      "")
	 (extents   '()))
    (while list
	   (set! font (car list))
	   (set! list (cdr list))
	   (if (= use-name TRUE)
	       (set! text font))
	   (set! extents (gimp-text-get-extents-fontname text
							 font-size PIXELS
							 font))
	   (set! height (nth 1 extents))
	   (if (> height maxheight)
	       (set! maxheight height)))
    maxheight))


(define (script-fu-font-map text
			    use-name
			    labels
			    font-filter
			    font-size
			    border
			    colors)
  (let* ((font        "")
	 (count       0)
         (font-list  (cadr (gimp-fonts-get-list font-filter)))
	 (num-fonts  (length font-list))
	 (label-size (/ font-size 2))
	 (border     (+ border (* labels (/ label-size 2))))
	 (y           border)
	 (maxheight  (max-font-height text use-name font-list font-size))
	 (maxwidth   (max-font-width  text use-name font-list font-size))
	 (width      (+ maxwidth (* 2 border)))
	 (height     (+ (+ (* maxheight num-fonts) (* 2 border))
			(* labels (* label-size num-fonts))))
	 (img        (car (gimp-image-new width height (if (= colors 0)
							   GRAY RGB))))
	 (drawable   (car (gimp-layer-new img width height (if (= colors 0)
							       GRAY-IMAGE RGB-IMAGE)
					  "Background" 100 NORMAL-MODE)))) 

    (gimp-context-push)

    (gimp-image-undo-disable img)

    (if (= colors 0)
	(begin
	  (gimp-context-set-background '(255 255 255))
	  (gimp-context-set-foreground '(0 0 0))))

    (gimp-image-add-layer img drawable 0)
    (gimp-edit-clear drawable)

    (if (= labels TRUE)
	(begin
	  (set! drawable (car (gimp-layer-new img width height
					      (if (= colors 0)
						  GRAYA-IMAGE RGBA-IMAGE)
					      "Labels" 100 NORMAL-MODE)))
	  (gimp-image-add-layer img drawable -1)))
	  (gimp-edit-clear drawable)

    (while font-list
	   (set! font (car font-list))
	   (set! font-list (cdr font-list))

	   (if (= use-name TRUE)
	       (set! text font))

	   (gimp-text-fontname img -1
			       border
			       y
			       text
			       0 TRUE font-size PIXELS
			       font)

	   (set! y (+ y maxheight))

	   (if (= labels TRUE)
	       (begin
		 (gimp-floating-sel-anchor (car (gimp-text-fontname img drawable
								    (- border
								       (/ label-size 2))
								    (- y
								       (/ label-size 2))
								    font
								    0 TRUE
								    label-size PIXELS
								    "Sans")))
		(set! y (+ y label-size))))


	   (set! count (+ count 1)))

    (gimp-image-set-active-layer img drawable)

    (gimp-image-undo-enable img)
    (gimp-display-new img)

    (gimp-context-pop)))

(script-fu-register "script-fu-font-map"
		    _"_Font Map..."
		    "Generate a listing of fonts matching a filter"
		    "Spencer Kimball"
		    "Spencer Kimball"
		    "1997"
		    ""
		    SF-STRING     _"_Text" "How quickly daft jumping zebras vex."
		    SF-TOGGLE     _"Use font _name as text" FALSE
		    SF-TOGGLE     _"_Labels"                TRUE
		    SF-STRING     _"_Filter (regexp)"       "Sans"
		    SF-ADJUSTMENT _"Font _size (pixels)"    '(32 2 1000 1 10 0 1)
		    SF-ADJUSTMENT _"_Border (pixels)"       '(10 0  200 1 10 0 1)
		    SF-OPTION     _"_Color scheme"          '(_"Black on white"
							      _"Active colors"))

(script-fu-menu-register "script-fu-font-map"
			 _"<Toolbox>/Xtns/Script-Fu/Utils")
