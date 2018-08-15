; Kuhflecken-Textur v0.2
; Copyright (c) 2005-2006 Frank Kessler <info@kessnux.de>
;
; Getestet mit TheGIMP 2.2.8 unter Mandriva Linux 2006 Free am 2006-06-29.
;
; Dieses Programm basiert auf dem deutschen Tutorial unter www.Kessnux.de, das deutsche Tutorial 
; basiert auf Techniken von Zach Beane (xach).
;
; Dieses Programm ist freie Software; Sie können es weiter verteilen und/oder
; es unter den Bedingungen der GNU General Public License wie sie von der
; Free Software Foundation veröffentlicht wird modifizieren; es gilt entweder
; Version 2 der Lizenz oder (nach Ihrer Wahl) irgendeine neuere Version.
;
; Dieses Programm wird in der Hoffnung verteilt, daß es nützlich ist, aber OHNE
; IRGENDEINE GARANTIE und gleichermaßen ohne die implizierte Garantie der 
; ALLGEMEINEN GEBRAUCHSTAUGLICHKEIT oder der EIGNUNG ZU EINEM BESTIMMTEN ZWECK.
; Lesen Sie die GNU General Public License für mehr Details.
;
; Sie sollten eine Kopie der GNU General Public License zusammen mit diesem 
; Programm empfangen haben; wenn nicht, schreiben Sie an die 
; Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
;
;
;
; Cow-Blotches-Texture v0.2
; Copyright (c) 2005-2006 Frank Kessler <info@kessnux.de>
;
; Tested with TheGIMP 2.2.8 under Mandriva Linux 2006 Free at 2006-06-29.
;
; This program based on the german Tutorial at www.Kessnux.de, the german Tutorial 
; based on techniques of Zach Beane (xach).
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
; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA 
;

(define (script-fu-kuhflecken-textur breite hoehe variation)

(let* ((bild (car (gimp-image-new breite hoehe 0)))
	(hg-layer (car (gimp-layer-new bild breite hoehe 0 "Hintergrund (Background)" 100 0)))
	(flecken-layer (car (gimp-layer-new bild breite hoehe 0 "Flecken (Blotches)" 100 0)))
	(ff-alt (car (gimp-palette-get-foreground)))
	(hf-alt (car (gimp-palette-get-foreground))))
	
	(gimp-image-undo-disable bild)
	
	(gimp-image-add-layer bild hg-layer 1)
	(gimp-image-add-layer bild flecken-layer -1)
	
	;Layer vorbereiten
	(gimp-palette-set-foreground '(255 255 255))
	(gimp-edit-clear hg-layer)
	(gimp-edit-fill hg-layer 0)
	(gimp-edit-clear flecken-layer)
	(gimp-edit-fill flecken-layer 0)
	
	;Flecken erzeugen
	(plug-in-scatter-rgb TRUE bild flecken-layer FALSE FALSE 0.90 0.90 0.90 0.90)
	(plug-in-spread TRUE bild flecken-layer 10 10)
	(plug-in-spread TRUE bild flecken-layer 10 10)
	(plug-in-spread TRUE bild flecken-layer 10 10)
	(plug-in-gauss TRUE bild flecken-layer 10 10 1)
	(plug-in-c-astretch TRUE bild flecken-layer)
	(gimp-threshold flecken-layer (+ 150 (* -1 (- 150 variation))) 255)
	(plug-in-gauss TRUE bild flecken-layer 1 1 1)
	
	;alten Zustand wiederherstellen
	(gimp-palette-set-foreground ff-alt)
	(gimp-palette-set-background hf-alt)
	
	(gimp-image-undo-enable bild)
	(gimp-display-new bild)))
	
(script-fu-register "script-fu-kuhflecken-textur"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Kuhflecken-Textur (Cow-Blotches-Texture)"
		    "erzeugt eine Textur mit dem Farbmuster einer Kuh"
		    "Frank Kessler"
		    "Frank Kessler"
		    "2006-06-29"
		    ""
		    SF-ADJUSTMENT "Bildbreite (Image width)"  '(200 1 1024 1 10 0 1)
		    SF-ADJUSTMENT "Bildhoehe (Image height)"  '(200 1 1024 1 10 0 1)
		    SF-ADJUSTMENT "Intensitaet (Intensity)"   '(150 135 165 1 5 0 0))
		    