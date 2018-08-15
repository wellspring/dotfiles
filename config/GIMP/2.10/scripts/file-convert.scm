;;Batch file conversion Script-Fu
;;Caleb Case
;;01/24/2006
;;This code is under the GPL

;;Convert a file(s) that match pattern to the type
;;indicated by the ending ext (eg "jpg").
(define (file-convert pattern ext)
  (let* ((filelist (cadr (file-glob pattern 1))))
    (while filelist
	   (let* ((ofilename (car filelist))
		  (image (car (gimp-file-load RUN-NONINTERACTIVE
					      ofilename
					      ofilename)))
		  (i (- (string-length ofilename) 1)))
	     (let* ((drawable (car (gimp-image-get-active-layer image)))
		    (sfilename 
		      (string-append ofilename "." ext)))
	       (gimp-file-save RUN-NONINTERACTIVE
			       image
			       drawable
			       sfilename
			       sfilename)
	       (gimp-image-delete image)))
	   (set! filelist (cdr filelist)))))

(script-fu-register "file-convert"
		    "<Toolbox>/Xtns/Script-Fu/Utils/File Convert..."
		    "Converts file(s) to a new format. \n\nThe input files are selected by pattern or complete path (e.g. C:\*.tga).  \n\nThe output files are of the type indicated by the file extension (e.g. jpg).  \n\nOutput files are found in the same directory as the originals and originals are not removed."
		    "Caleb Case <calebcase@gmail.com>"
		    "GPL"
		    "01/24/2006"
		    ""
		    SF-FILENAME "Pattern/Path to file(s)" ""
		    SF-STRING "Convert to" "jpg")

