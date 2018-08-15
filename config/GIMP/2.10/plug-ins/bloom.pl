#!/usr/bin/perl
# =====================================================================
# Bloom for GIMP Perl-Fu
# =====================================================================
#
# N-...n-...n-need m-m... m-more... Uh, oh, sorry, just one of the
# dark sides of my TES4:Oblivion/Zelda: Twilight Princess
# addiction. Well, one thing the game industry has shown is that we
# need more Bloom.  And this script will hopefully help you get
# that. You end up with a new flattened image that has a separate
# bloom layer, which you can then tweak to your heart's
# content. Alternatively, you can use the "flatten" toggle to just
# trust your defaults to get a flat image in no time.
#
# This script is, as it is, a quick hack based on Matthew Welch's tutorial
# <URL:http://www.squaregear.net/gimptips/blom.shtml>. There are many
# ways to achieve the same effect with slightly different outcomes;
# (all depending on what to blur and when); perhaps in the future
# I'll make a little bit different versions. =)
#
# =====================================================================
# Release 1: 2008-04-12
# =====================================================================
# Copyright (C) 2008 Urpo Lankinen.
# This script is distributed under GNU General Public Licence v2 or
# later, which is the same license as The GIMP itself uses. You should
# have received a copy of this license with the GIMP. As usual, there
# is NO WARRANTY whatsoever, expressed or implied.
# =====================================================================
# E-mail: <wwwwolf@iki.fi> Homepage: <URL:http://www.iki.fi/wwwwolf/>
# =====================================================================
# SVN: $Id: bloom.pl 35 2008-04-12 18:23:39Z wwwwolf $
# =====================================================================

use strict;
use warnings;
use Gimp qw(:auto);
use Gimp::Fu;

##########################################################################

sub perl_fu_wolfy_bloom {
  my ($sourceimg,$drawable,$bloom_amount,$bloom_opacity,$flatten_final) = @_;

  gimp_context_push();

  my $img = gimp_image_duplicate($sourceimg);
  my $orig_layer = gimp_image_flatten($img);
  my $width = gimp_image_width($img);
  my $height = gimp_image_height($img);
  gimp_display_new($img);

  gimp_image_undo_group_start($img);

  # Add a new layer here. We need to add an alpha channel to it and clear
  # its contents, and it's tricky to do that later when we're supposed to
  # have the fillable content at hand, so we do it here in the beginning.
  my $bloom_layer = gimp_layer_new($img,$width,$height,0,
				   "Bloom",$bloom_opacity,
				   Gimp::SOFTLIGHT_MODE);
  gimp_image_add_layer($img,$bloom_layer,0);
  gimp_layer_add_alpha($bloom_layer);
  gimp_selection_all($img);
  gimp_edit_clear($bloom_layer);

  # Copy image
  gimp_image_set_active_layer($img,$orig_layer);
  gimp_edit_copy(gimp_image_get_active_layer($img));

  # Create a new channel
  my $selchn = gimp_channel_new($img,$width,$height,
				"For selection",100,[0,0,0]);
  gimp_image_add_channel($img,$selchn,0);
  gimp_image_set_active_channel($img,$selchn);

  # Paste to the new channel
  my $fs = gimp_edit_paste($selchn,1);
  $fs->anchor();

  # Starken the layer's colours. Possible alternative method: Threshold/Blur.
  gimp_curves_spline($selchn,0,[127,0,254,254]);

  # Take the new channel and turn it into a selection.
  gimp_selection_none($img);
  gimp_selection_load($selchn);

  # Get rid of the channel in question.
  gimp_image_unset_active_channel($img);
  #gimp_drawable_set_visible($selchn,0);
  gimp_image_remove_channel($img,$selchn);

  # Grow the selection by the user-chosen bloom amount. This is where the
  # magic happens. =)
  gimp_selection_grow($img,$bloom_amount);

  # Okay, let's add the bloom effect on the bloom layer.
  gimp_image_set_active_layer($img,$bloom_layer);  

  # Flood-fill with white
  gimp_context_set_foreground([255,255,255]);
  gimp_edit_bucket_fill($bloom_layer,Gimp::FG_BUCKET_FILL,
			Gimp::NORMAL_MODE, 100.0, 0, 1, 0, 0);
  # Blur
  gimp_selection_all($img);
  plug_in_gauss_rle(1,$bloom_layer,$bloom_amount*2,1,1);
  # ...and that's essentially the whole bloom process.
  # Time for post-processing.
  
  # If we flatten the image, we flatten the image. Can't get more
  # specific than that!
  gimp_image_flatten($img) if($flatten_final);

  # Done
  gimp_selection_none($img);
  gimp_image_undo_group_end($img);
  gimp_context_pop();

  undef;
}

##########################################################################

register "wolfy_bloom",
  "Apply light bloom effect on an image.",
  "Apply light bloom effect on an image.",
  "Urpo Lankinen <wwwwolf\@iki.fi>, based on a tutorial by Matthew Welch",
  "(c) 2008 Urpo Lankinen",
  "2008-04-12, Release 1",
  "<Image>/Filters/Light and Shadow/Light/Bloom...",
  "*",
  [
   [PF_INT32, "bloom_amount", "Bloom growth in pixels", 10],
   [PF_SLIDER, "bloom_opacity", "Bloom opacity", 70, [0,100,1]],
   [PF_TOGGLE, "flatten_final", "Flatten final image", 0]
  ],
  \&perl_fu_wolfy_bloom;

exit main;

##########################################################################
