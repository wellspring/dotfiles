; Studio Tecnico Arch. Giuseppe Conte  
; via Roma, 28
; 72026 - San Pancrazio Salentino (BR) - Italy
;
; Plugin  : image-subdivide.scm
; Author  : Arch. Giuseppe Conte 
; Date    : 22 agosto 2003 - San Pancrazio Salentino (BR)
; Revision: 21 ottobre 2004 - 01 november 2006
;						14 gennaio 2008 update to TinyScheme
;						18 ottobre 2008 update to GIMP 2.6
; Version : 3.1
; Last version at: http://xoomer.virgilio.it/lwcon/
; Help guide at  : http://xoomer.virgilio.it/lwcon/
;
; Description: 
; Subdivide the active image in MxN Rows and Columns and save any rectangular portion in the new files.
; 
; -----------------------------------------------------------------------------
;
; License:
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
; -----------------------------------------------------------------------------
;
; Define the function:

(define (script-fu-image-subdivide inImage inLayer nRighe nColonne option)

	(let* (	(orFilename (car (gimp-image-get-filename inImage)))
					(orWidth (car (gimp-image-width inImage)))
					(orHeight (car (gimp-image-height inImage)))
					(newW (/ orWidth nColonne))
					(newH (/ orHeight nRighe))
					(name-length 0)
					(inizio 0)
					(extension "")
					(type 0)
					(contaR 0)
					(contaC 0)
					(inXorig 0)
					(inYorig 0)
					(inWidth 0)
					(inHeight 0)
					(cnt 0)
					(filename "")
					(newimage 0)
					(newlayer 0)
					(activelayer 0)
					(floating-sel 0)  
					(colonna "")
					(riga "")
					(post "")
				)


	;; salva il file origine

	(if (= (string-length orFilename) 0) (set! orFilename "imageSubdivide.xcf"))
	;(gimp-message orFilename)
	  (gimp-file-save 1 inImage inLayer orFilename orFilename)

;;determina l'estensione del file origine
	;(set! name-length (length orFilename))
	;modifica riga precedente x Tunyfu
	(set! name-length (string-length orFilename))
	(set! inizio (- name-length 4))
	(set! extension (substring orFilename inizio name-length))
	
;	(gimp-message extension)
;;fine estensione file

;imposta l'estensione se il file deve essere salvato in un altro formato

(cond
	( (= option 1)	(set! extension ".png"))
	( (= option 2)	(set! extension ".jpg"))
	( (= option 3)	(set! extension ".bmp"))
	( (= option 4)	(set! extension ".tif"))
	( (= option 5)	(set! extension ".tga"))		
)

;determina il tipo di immagine (RGB, GRAY, INDEXED)
(set! type (car (gimp-image-base-type inImage)))
	  
;;imposto il ciclo per la suddivisione dell'immagine
(set! contaR 1)
(set! contaC 1)
(set! inXorig 0)
(set! inYorig 0)
(set! inWidth newW)
(set! inHeight newH)
(set! cnt 1)
(set! filename (car (gimp-image-get-filename inImage)))
	  
(while ( <= contaR nRighe)
	
	(set! inWidth newW)
	(set! inHeight newH)
	
	(while ( <= contaC nColonne)
		
;seleziona e copia una porzione dell'immagine
  		(gimp-rect-select inImage inXorig inYorig inWidth inHeight REPLACE FALSE 0)
  		(gimp-edit-copy inLayer)

;imposta la nuova immagine ed incolla la selezione
		(set! newimage (car (gimp-image-new inWidth inHeight type)))
		(set! newlayer (car (gimp-layer-new newimage  inWidth inHeight type "Sfondo" 100 NORMAL)))
    (gimp-image-add-layer newimage newlayer 0)
    (gimp-drawable-fill newlayer BG-IMAGE-FILL)
		(set! activelayer (car (gimp-image-set-active-layer newimage newlayer)))
		(set! floating-sel (car (gimp-edit-paste newlayer FALSE)))
      (gimp-floating-sel-anchor floating-sel)
	
;;imposta ed assegna un nome al nuovo file (nomefile-riga-colonna)
	  (set! filename (car (gimp-image-get-filename inImage)))
	  (set! cnt (+ cnt 1)) 
	  (set! colonna (number->string contaC))
	  (set! riga (number->string contaR))	  
	  (set! post "")
	  (set! post (string-append riga colonna))
;	  (set! filename (string-append (substring filename 0 (string-search "." filename)) post extension))
	  (set! filename (string-append filename post extension))	  
	  	  
	  (gimp-image-set-filename newimage filename)	  
	  (gimp-file-save 1 newimage newlayer filename filename)

	(set! inXorig (+ inXorig newW))  ;origine x rettanglo di selezione
	(set! contaC (+ contaC 1))
	
	);end while col
	
	(set! contaC 1)
	(set! inYorig (+ inYorig newH))
	(set! inXorig 0)
	(set! contaR (+ contaR 1))
	
);end while row
	
  (gimp-displays-flush)
  (gimp-selection-none inImage)
  
  );let
);def

(script-fu-register
 "script-fu-image-subdivide"
 _"<Image>/_ATG/_Tools/_Image subdivide"
 "Subdivide the image in MxN Rows and Columns and save any rectangular portion in the new files."
 "Arch. Giuseppe Conte"
 "2008, Conte Giuseppe"
 "14 gennaio, 2008 - Ver. 3.1"
 "RGB* GRAY* INDEXED*"
 SF-IMAGE "The Image" 0
 SF-DRAWABLE "The Layer" 0
 SF-ADJUSTMENT "Rows   " '(3 0 99999999 1 10 0 1)
 SF-ADJUSTMENT "Columns" '(3 0 99999999 1 10 0 1)
 SF-OPTION "Save as" '("Default" ".png" ".jpg" ".bmp" ".tif" ".tga")
 
)

