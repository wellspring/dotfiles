;GEL v2.0r2
;
;GEL is GAL Embeded Library;
;Based on GAL v1.0.7

;GEL functions

;Function #2
(define (gel-image-lower-item input_var1 input_var2)
  (if (defined? 'gimp-image-lower-item)
    (gimp-image-lower-item input_var1 input_var2)
    (if (= (car (gimp-drawable-is-layer input_var2)) TRUE)
      (gimp-image-lower-layer input_var1 input_var2)
      (gimp-image-lower-vectors input_var1 input_var2)
    )
  )
)

;Function #4
(define (gel-image-raise-item input_var1 input_var2)
  (if (defined? 'gimp-image-raise-item)
    (gimp-image-raise-item input_var1 input_var2)
    (if (= (car (gimp-drawable-is-layer input_var2)) TRUE)
      (gimp-image-raise-layer input_var1 input_var2)
      (gimp-image-raise-vectors input_var1 input_var2)
    )
  )
)

;Function #5
(define (gel-image-raise-item-to-top input_var1 input_var2)
  (if (defined? 'gimp-image-raise-item-to-top)
    (gimp-image-raise-item-to-top input_var1 input_var2)
    (if (= (car (gimp-drawable-is-layer input_var2)) TRUE)
      (gimp-image-raise-layer-to-top input_var1 input_var2)
      (gimp-image-raise-vectors-to-top input_var1 input_var2)
    )
  )
)

;Function #11
(define (gel-item-get-visible input_item)
(define output-return)
  (if (defined? 'gimp-item-get-visible)
    (set! output-return (gimp-item-get-visible input_item))
    (if (= (car (gimp-drawable-is-layer input_item)) TRUE)
      (set! output-return (gimp-drawable-get-visible input_item))
      (set! output-return (gimp-vectors-get-visible input_item))
    )
  )
output-return
)

;Function #22
(define (gel-item-set-name input_item input_string)
  (if (defined? 'gimp-item-set-name)
    (gimp-item-set-name input_item input_string)
    (if (= (car (gimp-drawable-is-layer input_item)) TRUE)
      (gimp-drawable-set-name input_item input_string)
      (gimp-vectors-set-name input_item input_string)
    )
  )
)

;Function #24
(define (gel-item-set-visible input_item input_var1)
  (if (defined? 'gimp-item-set-visible)
    (gimp-item-set-visible input_item input_var1)
    (if (= (car (gimp-drawable-is-layer input_item)) TRUE)
      (gimp-drawable-set-visible input_item input_var1)
      (gimp-vectors-set-visible input_item input_var1)
    )
  )
)

;Function #28
(define (gel-item-transform-flip-simple 
	input_item
	input_var1
	input_var2
	input_var3
	input_var4
	)
(define output-return)
(define legacy-list (list input_var4))
(define modern-list (list input_item input_var1 input_var2 input_var3))
  (if (defined? 'gimp-item-transform-flip-simple)
    (set! output-return (apply gimp-item-transform-flip-simple modern-list))
    (set! output-return (apply gimp-drawable-transform-flip-simple (append modern-list legacy-list)))
  )
output-return
)

;Function #34
(define (gel-image-insert-layer input_image input_item input_var1)
  (if (defined? 'gimp-image-insert-layer)
    (gimp-image-insert-layer input_image input_item -1 input_var1)
    (gimp-image-add-layer input_image input_item input_var1)
  )
)

;Additional functions (GEL original)

;Function #36
(define (gel-image-select-ellipse 
	input_image
	input_var1
	input_var2
	input_var3
	input_var4
	input_var5
	input_var6
	input_var7
	input_var8
	)
(define output-return)
(define arg-list (list input_image input_var1 input_var2 input_var3 input_var4 input_var5 input_var6 input_var7 input_var8))
  (if (defined? 'gimp-item-transform-shear)
    (set! output-return (apply gimp-image-select-ellipse (list input_image input_var5 input_var1 input_var2 input_var3 input_var4)))
    (set! output-return (apply gimp-ellipse-select arg-list))
  )
output-return
)

;Function #37
(define (gel-image-select-item
	input_image
	input_var1
	input_item
	)
(define output-return)
  (if (defined? 'gimp-image-select-item)
    (set! output-return (car (gimp-image-select-item input_image input_var1 input_item)))
    (if (= (car (gimp-drawable-is-layer input_item)) TRUE)
      (set! output-return (car (gimp-selection-layer-alpha input_item)))
      (begin
	(gimp-selection-load input_item)
	#t
      )
    )
  )
output-return
)

;Function #38
(define (gel-image-scale-full input_image input_imw input_imh input_mode)
  (if (defined? 'gimp-context-set-interpolation)
    (begin
      (define def-mode (car (gimp-context-get-interpolation)))
      (gimp-context-set-interpolation input_mode)
      (gimp-image-scale input_image input_imw input_imh)
      (gimp-context-set-interpolation def-mode)
    )
    (gimp-image-scale-full input_image input_imw input_imh input_mode)
  )
)

;Function #39
(define (gel-layer-scale-full input_image input_imw input_imh input_origin input_mode)
  (if (defined? 'gimp-context-set-interpolation)
    (begin
      (define def-mode (car (gimp-context-get-interpolation)))
      (gimp-context-set-interpolation input_mode)
      (gimp-layer-scale input_image input_imw input_imh input_origin)
      (gimp-context-set-interpolation def-mode)
    )
    (gimp-layer-scale-full input_image input_imw input_imh input_origin input_mode)
  )
)