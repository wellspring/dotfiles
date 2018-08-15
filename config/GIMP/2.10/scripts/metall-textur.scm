; Metall-Textur v0.1
; Copyright (c) 2005 Frank Kessler <gimp-info@frakes.de>
;
; Getestet mit TheGIMP 2.2.4 unter Mandrake Linux 10.1 am 2005-04-10.
;
; Dieses Programm basiert auf dem deutschen Tutorial unter www.frakes.de, das deutsche Tutorial 
; basiert auf Techniken von Gavin Brown (Jodrell).
; 
;
; SOFTWARE-LIZENZVEREINBARUNG
;
; LESEN SIE SICH DIESE LIZENZVEREINBARUNG SORGF�LTIG DURCH, BEVOR SIE DIESE SOFTWARE VERWENDEN. 
; Wenn Sie mit den Lizenzbestimmungen einverstanden sind installieren und nutzen Sie dieses Programm,
; sind Sie mit den Lizenzbestimmungen nicht einverstanden d�rfen Sie dieses Programm nicht nutzen.
; 
; Grundlegende Informationen
; Dieses urheberrechtlich gesch�tzte Computerprogramm ("Software"), ist das unver�u�erliche geistige 
; Eigentum von Frank Kessler. Alle Rechte vorbehalten. Frank Kessler berechtigt Sie (den Benutzer), 
; diese Software ausschlie�lich unter den in dieser Lizenzvereinbarung dargelegten Bedingungen zu nutzen.
; 
; 1. Lizenz. Diese Lizenz berechtigt Sie
; (a) die Software auf Ihrem Computersystem zu installieren und frei zu nutzen
; (b) eine Kopie dieser Software f�r Sicherungszwecke anzulegen
; (c) eine Kopie dieser Software in unver�nderter Form an Dritte weiterzugeben (die Weitergabe dieser
;     Software online �ber eine WebSite bedarf meiner schriftlichen Einwilligung)
; 
; 2. Beschr�nkungen. Es ist dem Benutzer verboten
; (a) diese Software in den folgenden oder in �hnlichen Systemen einzusetzen: in Kernkraftanlagen, 
;     in Flugzeugen, in Krankenh�usern, in Kommunikationssystemen, bei der Flug�berwachung, etc..
;     DER EINSATZ DIESER SOFTWARE IN DEN GENANNTEN BEREICHEN KANN BEI FEHLERN ZU TODESF�LLEN, 
;     K�RPERVERLETZUNGEN, SCHWERWIEGENDEN SACH- UND UMWELTSCH�DEN ODER GROSSEM DATENVERLUST F�HREN.
; 
; 3. Beschr�nkte Garantie und Haftung
; (a) Die Software wird -wie besehen- lizenziert und vertrieben. Frank Kessler �bernimmt keine Garantie 
;     - ausdr�cklich oder konkludent - f�r die Qualit�t, Leistung und Marktf�higkeit der Software sowie f�r 
;     ihre Eignung f�r einen bestimmten Zweck. Ebenso wenig kann Frank Kessler einen st�rungsfreien Betrieb 
;     oder die Behebung eventuell auftretender Fehler garantieren.
; (b) Da es sich bei diesem Produkt um privat vertriebene, kostenlose Software handelt, verzichtet der 
;     Benutzer auf jegliche Haftungs- oder Garantieanspr�che gegen�ber Frank Kessler f�r Sch�den die durch 
;     Nutzung dieser Software entstehen - Ausnahme bilden Sch�den, welche auf grobe Fahrl�ssigkeit oder 
;     Vorsatz zur�ckzuf�hren sind.
; 
; 4. Sollte irgendeine Bestimmung dieser Vereinbarung f�r nichtig erkl�rt werden, wird diese als von der 
;    Vereinbarung getrennt betrachtet, und die Vereinbarung bleibt anderweitig uneingeschr�nkt in Kraft.
;    
; 5. Diese Lizenzvereinbarung unterliegt dem Recht der Bundesrepublik Deutschland.
; 
; Frank Kessler - www.frakes.de
;
; 
;
; Brushed-Metal-Texture v0.1
; Copyright (c) 2005 Frank Kessler <gimp-info@frakes.de>
;
; Tested with TheGIMP 2.2.4 under Mandrake Linux 10.1 at 2005-04-10.
;
; This program based on the german Tutorial at www.frakes.de, the german Tutorial 
; based on techniques of Gavin Brown (Jodrell).
;
;
; UNOFFICIAL Short-Form of the SOFTWARE LICENSING AGREEMENT
;
; This program is subjected to the copyright of Frank Kessler. All rights reserved.
;
; You (the User) may
; (a) install and use this software for free
; (b) backup this software
; (c) redistribute this software in unmodified form (the online distribution over a WebSite requires my
;     consent in written form)
;
; It's forbidden to use this software in nuclear-facilities, planes, hospitals or similar institutions.
;
; This software is distributed as it is; you use it without any warranty or liability of Frank Kessler.
; The liability exclusion includes the commercial use and the use for a particular purpose.
;
; The licensing agreement is subjected to the law of the Federal Republic of Germany.
;

(define (script-fu-metall-textur breite hoehe zufallswert)

(let* ((bild (car (gimp-image-new breite hoehe 0)))
	(hg-layer (car (gimp-layer-new bild breite hoehe 0 "Hintergrund (Background)" 100 0)))
	(struktur-layer (car (gimp-layer-new bild breite hoehe 0 "Struktur (Structure)" 100 0)))
	(ff-alt (car (gimp-palette-get-foreground)))
	(hf-alt (car (gimp-palette-get-foreground))))
	
	(gimp-image-undo-disable bild)
	
	(gimp-image-add-layer bild hg-layer 1)
	(gimp-image-add-layer bild struktur-layer -1)
	
	;Layer vorbereiten
	(gimp-palette-set-foreground '(255 255 255))
	(gimp-edit-clear hg-layer)
	(gimp-edit-fill hg-layer 0)
	(gimp-edit-clear struktur-layer)
	(gimp-edit-fill struktur-layer 0)
	
	;Hintergrund erzeugen
	(plug-in-solid-noise TRUE bild hg-layer 0 0 zufallswert 1 1.0 1.0)
	
	;Struktur erzeugen
	(plug-in-scatter-rgb TRUE bild struktur-layer FALSE FALSE 0.40 0.40 0.40 0.40)
	(plug-in-mblur TRUE bild struktur-layer 0 10 0 10 10)
	(gimp-layer-set-opacity struktur-layer 30)
	
	;alten Zustand wiederherstellen
	(gimp-palette-set-foreground ff-alt)
	(gimp-palette-set-background hf-alt)
	
	(gimp-image-undo-enable bild)
	(gimp-display-new bild)))
	
(script-fu-register "script-fu-metall-textur"
		    "<Toolbox>/Xtns/Script-Fu/Patterns/Metall-Textur (Brushed-Metal-Texture)"
		    "erzeugt eine Textur die wie Metall aussieht"
		    "Frank Kessler"
		    "Frank Kessler"
		    "2005-04-10"
		    ""
		    SF-ADJUSTMENT "Bildbreite (Image width)"   '(200 1 1024 1 10 0 1)
		    SF-ADJUSTMENT "Bildhoehe (Image height)"   '(200 1 1024 1 10 0 1)
		    SF-ADJUSTMENT "Zufallswert (Random-Value)" '(2784479764 1000000000 9999999999 1 10 0 1))
		    