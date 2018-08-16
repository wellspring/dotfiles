#!/usr/bin/env python

'''
ShellOut.py
call an external program passing the active layer as a temp file.  Windows Only(?)

Author:
Rob Antonishen

Version:
0.7 fixed file save bug where all files were png regardless of extension
0.6 modified to allow for a returned layer that is a different size 
   than the saved layer for
  0.5 file extension parameter in program list.
0.4 modified to support many optional programs.

this script is modelled after the mm extern LabCurves trace plugin 
by Michael Munzert http://www.mm-log.com/lab-curves-gimp

and thanks to the folds at gimp-chat has grown a bit ;)

License:

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The GNU Public License is available at
http://www.gnu.org/copyleft/gpl.html

'''

from gimpfu import *
import shlex
import subprocess
import os, sys
import tempfile

#program list function (globals are evil)
def listcommands(option=None):
  #
  # Insert additonal shell command into this list.  They will show up in the drop menu in this order.
  # Use the syntax:
  # ["Menu Label", "command", "ext"]
  # 
  # Where what gets executed is command fileame so include and flags needed in the command.
  programlist = [
  ["XNView", "\"C:\\PF\\XnView\\xnview.exe\"", "png"],
  ["MS Paint", "\"..\\..\\..\\..\\WINDOWS\\system32\\mspaint.exe\"", "bmp"],
  ["InPaint", "\"C:\\PF\\Inpaint\\Inpaint.exe\"", "png"],
  #["Deep Paint", "\"C:\\Program Files\\DeepPaint\\deeppaint.exe\"", "jpg"],
  #["Inkscape", "\"C:\\Program Files\\Inkscape\\inkscape.exe\"", "png"],
  #["PaintDOTNet", "\"C:\\Program Files\\Paint.NET\\PaintDotNet.exe\"", "png"],
  #["MyPaint", "\"C:\\Program Files\\MyPaint\\mypaint.exe\"", "png"],
  #["Photo Filter Factory", "\"C:\\Program Files\\Photo Filter Factory\\Photo Filter Factory.exe\"", "png"],
  #["Photo Pos Pro", "\"C:\\Program Files\\Photo Pos Pro\\Photo Pos Pro.exe\"", "png"],
  ["Java Image Editor", "\"C:\\JavaJars\\imageeditor.bat\"", "png"],
  ["Java Mosaic", "\"C:\\JavaJars\\mosaic.bat\"", "png"],
  ["JDraw", "\"C:\\JavaJars\\jdraw.bat\"", "png"],
  #["Vector Magic", "\"C:\\Program Files\\Vector Magic\\vmde.exe\"", "png"],
  #["Photo Clinic", "\"C:\\MAGIX\\Photo_Clinic_45\\PhotoClinic.exe\"", "png"],
  ["Smilla Enlarger", "\"C:\\utils\\SmillaEnlarger\\SmillaEnlarger.exe\"", "png"],
  ["","",""]
  ]
  
  if option == None: # no parameter return menu list, otherwise return the appropaiate array
    menulist = []
    for i in programlist:
      if i[0] != "":
        menulist.append(i[0])
    return menulist
  else:
    return programlist[option]
	

def plugin_main(image, drawable, visible, command):
  pdb.gimp_image_undo_group_start(image)
  
  # Copy so the save operations doesn't affect the original
  if visible == 0:
    # Save in temporary.  Note: empty user entered file name
    temp = pdb.gimp_image_get_active_drawable(image)
  else:
    # Get the current visible
    temp = pdb.gimp_layer_new_from_visible(image, image, "Visible")
    image.add_layer(temp, 0)

  buffer = pdb.gimp_edit_named_copy(temp, "ShellOutTemp")

  #save selection if one exists
  hassel = pdb.gimp_selection_is_empty(image) == 0
  if hassel:
    savedsel = pdb.gimp_selection_save(image)

  tempimage = pdb.gimp_edit_named_paste_as_new(buffer)
  pdb.gimp_buffer_delete(buffer)
  if not tempimage:
    raise RuntimeError
  pdb.gimp_image_undo_disable(tempimage)

  tempdrawable = pdb.gimp_image_get_active_layer(tempimage)
  
  #get the program to run and filetype.
  progtorun = listcommands(command)
  
  # Use temp file names from gimp, it reflects the user's choices in gimp.rc
  # change as indicated if you always want to use the same temp file name
  # tempfilename = pdb.gimp_temp_name(progtorun[2])
  tempfilename = os.path.join(tempfile.gettempdir(), "ShellOutTempFile."+progtorun[2])
  

  # !!! Note no run-mode first parameter, and user entered filename is empty string
  pdb.gimp_progress_set_text ("Saving a copy")
  pdb.gimp_file_save(tempimage, tempdrawable, tempfilename, tempfilename)

  # Build command line call
  command = progtorun[1] + " \"" + tempfilename + "\""
  args = shlex.split(command)

  # Invoke external command
  pdb.gimp_progress_set_text ("calling " + progtorun[0] + "...")
  pdb.gimp_progress_pulse()
  child = subprocess.Popen(args, shell=False)
  child.communicate()

  # put it as a new layer in the opened image
  try:
    newlayer2 = pdb.gimp_file_load_layer(tempimage, tempfilename)
  except:
    RuntimeError
	
  tempimage.add_layer(newlayer2,-1)
  buffer = pdb.gimp_edit_named_copy(newlayer2, "ShellOutTemp")

  if visible == 0:
    drawable.resize(newlayer2.width,newlayer2.height,0,0)
    sel = pdb.gimp_edit_named_paste(drawable, buffer, 1)
    drawable.translate((tempdrawable.width-newlayer2.width)/2,(tempdrawable.height-newlayer2.height)/2)
  else:
    temp.resize(newlayer2.width,newlayer2.height,0,0)
    sel = pdb.gimp_edit_named_paste(temp, buffer, 1)
    temp.translate((tempdrawable.width-newlayer2.width)/2,(tempdrawable.height-newlayer2.height)/2)

  pdb.gimp_buffer_delete(buffer)
  pdb.gimp_edit_clear(temp)	
  pdb.gimp_floating_sel_anchor(sel)

  #load up old selection
  if hassel:
    pdb.gimp_selection_load(savedsel)
    image.remove_channel(savedsel)
  
  # cleanup
  os.remove(tempfilename)  # delete the temporary file
  gimp.delete(tempimage)   # delete the temporary image

  # Note the new image is dirty in Gimp and the user will be asked to save before closing.
  pdb.gimp_image_undo_group_end(image)
  gimp.displays_flush()


register(
        "python_fu_shellout",
        "Call an external program",
        "Call an external program",
        "Rob Antonishen",
        "Copyright 2011 Rob Antonishen",
        "2011",
        "<Image>/Filters/ShellOut...",
        "RGB*, GRAY*", 
        [ (PF_RADIO, "visible", "Layer:", 1, (("new from visible", 1),("current layer",0))),
          (PF_OPTION,"command",("Program:"),0,listcommands())
        ],
        [],
        plugin_main,
        )

main()