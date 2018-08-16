#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

# GIMP plugin to edit images in succession
# (c) Ofnuts 2015
#
#   History:
#
#   v0.0: 2015-09-13: First published version
#   v0.1: 2015-12-30: Rename, remove feral print instruction
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

import os,sys,re,glob
from gimpfu import *

# regexp in slow-mo:
# - anything (digits and non-digits) up to last non-digit
# - digits up to last dot
# - last dot and anything that follows (extension)


pattern=re.compile('^(.*\D)?(\d+)(\.[^.]+)$')

def parse(s):
    match=pattern.match(s)
    if not match:
        return (None,None,None)
    else:
        return match.groups()

def nextFile(filename):
    root,digits,ext=parse(filename)
    if not digits:
        raise Exception('No numeric suffix found in %s' % filename)
    number=int(digits)+1
    target=root+'*'+str(number)+ext
    matches=glob.glob(target)
    
    # Glob above will also return images with more digits (for instance,
    # from image01.jpg, we search image*2.jpg, but this can return image12.jpg),
    # so we filter out those that haven't got the right number
    def keep(candidate):
        croot,cdigits,_=parse(candidate)
        return croot==root and int(cdigits)==number
    matches=filter(keep,matches)
    
    # Should have only one remaining
    if not matches: 
        raise Exception('No successor found for %s' % filename)
    if len(matches)>1:
        raise Exception('Ambiguous successors for %s: %s' % (filename,', '.join(matches)))
    return matches[0]
        
def test(filename):
    try:
        print '-----------'
        print filename
        print nextFile(filename)
    except Exception as e:
        print e
      
def nextImage(image):
    try:
        currentName=image.filename
        if not currentName:
            raise Exception('No known source file for current image')
        pdb.gimp_file_save(image, image.active_layer, image.filename, image.filename)

        # delete image display and image
        for displayID in range(1,image.ID+50):
            display=gimp._id2display(displayID)
            if isinstance(display,gimp.Display):
                #print 'Image: %d; display %d' % (image.ID,displayID)
                break
        if not display:
            raise Exception('Display not found')            
        gimp.delete(display)

        # find next image and load it
        nextName=nextFile(currentName)
        newImage=pdb.gimp_file_load(nextName,nextName)
        newDisplay=gimp.Display(newImage)
        #print 'New display: %d' % newDisplay.ID
    except Exception as e:
        gimp.message(str(e))

#test('testnum/only1.jpg')
#test('testnum/01.jpg')
#test('testnum/good01.jpg')
#test('testnum/good9.jpg')
#test('testnum/good09.jpg')
#test('testnum/good009.jpg')

### Registrations
whoiam='\n'+os.path.abspath(sys.argv[0])
    
register(
        'ofn-file-next',
        'Saves and closes the current image and loads the next image'+whoiam,'Saves and closes the current image and loads the next image',
        'Ofnuts','Ofnuts',
        '2015',
        'Next image',
        '',
        [(PF_IMAGE, "image", "Input image", None)],
        [(PF_IMAGE, "image", "New image", None)],
        nextImage,
        menu='<Image>/File/'
)

main()

