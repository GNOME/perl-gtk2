use strict;
use warnings;
use Gtk2::TestHelper tests => 85, noinit => 1;

my $show = 0;



my ($pixbuf, $pixels);

$pixbuf = Gtk2::Gdk::Pixbuf->new ('rgb', TRUE, 8, 61, 33);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new with alpha');
is ($pixbuf->get_colorspace, 'rgb');
is ($pixbuf->get_n_channels, 4);
ok ($pixbuf->get_has_alpha);
is ($pixbuf->get_bits_per_sample, 8);
is ($pixbuf->get_width, 61);
is ($pixbuf->get_height, 33);
is ($pixbuf->get_rowstride, 244);
$pixels = $pixbuf->get_pixels;
ok ($pixels);
is (length($pixels), ($pixbuf->get_height * $pixbuf->get_rowstride)); 


$pixbuf = Gtk2::Gdk::Pixbuf->new ('rgb', FALSE, 8, 33, 61);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new without alpha');
is ($pixbuf->get_colorspace, 'rgb');
is ($pixbuf->get_n_channels, 3);
ok (!$pixbuf->get_has_alpha);
is ($pixbuf->get_bits_per_sample, 8);
is ($pixbuf->get_width, 33);
is ($pixbuf->get_height, 61);
is ($pixbuf->get_rowstride, 100); # 100 is aligned, 99 is actual
$pixels = $pixbuf->get_pixels;
ok ($pixels);
is (length($pixels), ($pixbuf->get_height * $pixbuf->get_rowstride)); 


isa_ok ($pixbuf->copy, 'Gtk2::Gdk::Pixbuf', 'copy');


my $subpixbuf = $pixbuf->new_subpixbuf (10, 5, 7, 14);
isa_ok ($subpixbuf, 'Gtk2::Gdk::Pixbuf', 'new_subpixbuf');
# probably more validation of gdk-pixbuf's stuff, but it makes me happy
# to verify invariants like this.
is ($subpixbuf->get_width, 7);
is ($subpixbuf->get_height, 14);
is ($subpixbuf->get_rowstride, $pixbuf->get_rowstride);


my ($win, $vbox);
if ($show) {
	$win = Gtk2::Window->new;
	$vbox = Gtk2::VBox->new;
	$win->add ($vbox);
}

my @test_xpm = (
 '4 5 3 1',
 ' 	c None',
 '.	c red',
 '+	c blue',
 '.. +',
 '. ++',
 ' ++.',
 '++..',
 '+.. ');

$pixbuf = Gtk2::Gdk::Pixbuf->new_from_xpm_data (@test_xpm);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_xpm_data');
is ($pixbuf->get_width, 4);
is ($pixbuf->get_height, 5);
ok ($pixbuf->get_has_alpha);
$vbox->add (Gtk2::Image->new_from_pixbuf ($pixbuf)) if $show;

# raw pixel values to make the xpm above
my $rawdata = pack 'C*',
    255,0,0,255,    255,0,0,255,    0,0,0,0,        0,0,255,255,
    255,0,0,255,    0,0,0,0,        0,0,255,255,    0,0,255,255,
    0,0,0,0,        0,0,255,255,    0,0,255,255,    255,0,0,255,
    0,0,255,255,    0,0,255,255,    255,0,0,255,    255,0,0,255,
    0,0,255,255,    255,0,0,255,    255,0,0,255,    0,0,0,0,
;

$pixbuf = Gtk2::Gdk::Pixbuf->new_from_data ($rawdata, 'rgb', TRUE, 8, 4, 5, 16);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_data');
is ($pixbuf->get_colorspace, 'rgb');
ok ($pixbuf->get_has_alpha);
is ($pixbuf->get_width, 4);
is ($pixbuf->get_height, 5);
is ($pixbuf->get_rowstride, 16);
$vbox->add (Gtk2::Image->new_from_pixbuf ($pixbuf)) if $show;

# inlined data from gdk-pixbuf-csource, run on the xpm from above
my $inlinedata =
  "GdkP" # Pixbuf magic (0x47646b50)
. "\0\0\0[" # length: header (24) + pixel_data (67)
. "\2\1\0\2" # pixdata_type (0x2010002)
. "\0\0\0\20" # rowstride (16)
. "\0\0\0\4" # width (4)
. "\0\0\0\5" # height (5)
  # pixel_data:
. "\202\377\0\0\377\4\0\0\0\0\0\0\377\377\377\0\0\377\0\0\0\0\202\0\0\377"
. "\377\1\0\0\0\0\202\0\0\377\377\1\377\0\0\377\202\0\0\377\377\202\377"
. "\0\0\377\1\0\0\377\377\202\377\0\0\377\1\0\0\0\0";

$pixbuf = Gtk2::Gdk::Pixbuf->new_from_inline ($inlinedata, TRUE);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_inline');
is ($pixbuf->get_colorspace, 'rgb');
ok ($pixbuf->get_has_alpha);
is ($pixbuf->get_width, 4);
is ($pixbuf->get_height, 5);
is ($pixbuf->get_rowstride, 16);
$vbox->add (Gtk2::Image->new_from_pixbuf ($pixbuf)) if $show;


#
# these functions can throw Gtk2::Gdk::Pixbuf::Error and Glib::File::Error
# exceptions.
#
my $filename = 'testsave.jpg';
$pixbuf->save ($filename, 'jpeg', quality => 75.0);
ok (1);

$pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($filename);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_file');

SKIP: {
  skip "new_from_file_at_size is new in 2.4", 3
    unless Gtk2->CHECK_VERSION(2,4,0);

  $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file_at_size ($filename, 20, 25);
  isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_file_at_size');
  is ($pixbuf->get_width, 20);
  is ($pixbuf->get_height, 25);
}

SKIP: {
  skip "new_from_file_at_scale is new in 2.6", 3
    unless Gtk2->CHECK_VERSION(2,6,0);

  $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file_at_scale ($filename, 20, 25, FALSE);
  isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_file_at_scale');
  is ($pixbuf->get_width, 20);
  is ($pixbuf->get_height, 25);
}

SKIP: {
  skip "new stuff", 3
    unless Gtk2->CHECK_VERSION (2,6,0);

  my ($format, $width, $height) = Gtk2::Gdk::Pixbuf->get_file_info ($filename);
  isa_ok ($format, "Gtk2::Gdk::PixbufFormat");
  is ($width, 4);
  is ($height, 5);
}

unlink $filename;


$filename = 'testsave.png';
my $mtime = scalar localtime;
my $desc = 'Something really cool';
$pixbuf->save ($filename, 'png',
	       'tEXt::Thumb::MTime' => $mtime,
	       'tEXt::Description' => $desc);
ok (1);

$pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($filename);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_file');

is ($pixbuf->get_option ('tEXt::Description'), $desc, 'get_option works');
is ($pixbuf->get_option ('tEXt::Thumb::MTime'), $mtime, 'get_option works');
ok (! $pixbuf->get_option ('tEXt::noneXIStenTTag'),
    'get_option returns undef if the key is not found');

unlink $filename;


# raw pixel values to make the xpm above, but with green for the
# transparent pixels, so we can use add_alpha.
$rawdata = pack 'C*',
    255,0,0,    255,0,0,    0,255,0,    0,0,255,
    255,0,0,    0,255,0,    0,0,255,    0,0,255,
    0,255,0,    0,0,255,    0,0,255,    255,0,0,
    0,0,255,    0,0,255,    255,0,0,    255,0,0,
    0,0,255,    255,0,0,    255,0,0,    0,255,0,
;

$pixbuf = Gtk2::Gdk::Pixbuf->new_from_data ($rawdata, 'rgb', FALSE, 8, 4, 5, 12);
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'new_from_data');
ok (!$pixbuf->get_has_alpha);
is ($pixbuf->get_rowstride, 12);
$vbox->add (Gtk2::Image->new_from_pixbuf ($pixbuf)) if $show;

my $pixbuf2 = $pixbuf->add_alpha (TRUE, 0, 255, 0);
isa_ok ($pixbuf2, 'Gtk2::Gdk::Pixbuf', 'add_alpha');
ok ($pixbuf2->get_has_alpha);
$vbox->add (Gtk2::Image->new_from_pixbuf ($pixbuf2)) if $show;


$pixbuf->copy_area (2, 3,
                    $pixbuf2->get_width - 2,
		    $pixbuf2->get_height - 3,
		    $pixbuf2, 0, 2);


$pixbuf2->saturate_and_pixelate ($pixbuf2, 0.75, FALSE);

sub pack_rgba {
	use integer;
	return (($_[0] << 0) | ($_[1] << 8) | ($_[2] << 16) | ($_[3] << 24));
}
$pixbuf->fill (pack_rgba (255, 127, 96, 196));

SKIP: {
  skip "new 2.6 stuff", 2
    unless Gtk2->CHECK_VERSION (2, 6, 0);

  isa_ok ($pixbuf->flip (TRUE), "Gtk2::Gdk::Pixbuf");
  isa_ok ($pixbuf->rotate_simple ("clockwise"), "Gtk2::Gdk::Pixbuf");
}

$pixbuf = Gtk2::Gdk::Pixbuf->new ('rgb', TRUE, 8, 32, 32);
$pixbuf2->scale ($pixbuf, 0, 0, 10, 15, 1, 2, 1.2, 3.5, 'bilinear');

$pixbuf2->composite ($pixbuf,	# dest
		     10, 5,	# dest x & y
		     4, 5,	# dest width & height
		     0, 0,	# offsets
		     2.0, 4.0,	# x & y scale factors
		     'nearest',	# interp type
		     0.4);	# overall alpha

$pixbuf2->composite_color ($pixbuf,	# dest
			   10, 5,	# dest x & y
			   4, 5,	# dest width & height
			   0, 0,	# offsets
			   2.0, 4.0,	# x & y scale factors
			   'nearest',	# interp type
			   0.4,		# overall alpha
			   3, 4,	# check x & y
			   5,		# check size
			   pack_rgba (75, 75, 75, 255),		# color 1
			   pack_rgba (192, 192, 192, 255));	# color 2


$pixbuf = $pixbuf2->scale_simple (24, 25, 'tiles');
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'scale_simple');


$pixbuf = $pixbuf2->composite_color_simple (24, 25, 'hyper', 0.4, 
			   5,		# check size
			   pack_rgba (75, 75, 75, 255),		# color 1
			   pack_rgba (192, 192, 192, 255));	# color 2
isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'composite_color_simple');


####################
### Animations
###
#
###  GdkPixbufAnimation *gdk_pixbuf_animation_new_from_file (const char *filename, GError **error) 
#GdkPixbufAnimation_noinc *
#gdk_pixbuf_animation_new_from_file (class, filename)
#	GPerlFilename filename
#    PREINIT:
#	GError * error = NULL;
#    CODE:
#	RETVAL = gdk_pixbuf_animation_new_from_file (filename, &error);
#	if (!RETVAL)
#		gperl_croak_gerror (filename, error);
#    OUTPUT:
#	RETVAL
#
#
#$animation->get_width
#$animation->get_height
#$animation->is_static_image
#$animation->get_static_image
#
### there's no typemap for GTimeVal.
### GTimeVal is in GLib, same as unix' struct timeval.
### timeval is seconds and microseconds, which we can get from Time::HiRes.
### so, we'll take seconds and microseconds.  if neither is available,
### pass NULL to the wrapped function to get the current time.
####  GdkPixbufAnimationIter *gdk_pixbuf_animation_get_iter (GdkPixbufAnimation *animation, const GTimeVal *start_time) 
#=for apidoc
#
#The seconds and microseconds values are available from Time::HiRes, which is
#standard since perl 5.8.0.  If both are undef or omitted, the function uses the
#current time.
#
#=cut
#GdkPixbufAnimationIter_noinc *
#gdk_pixbuf_animation_get_iter (animation, start_time_seconds=0, start_time_microseconds=0)
#	GdkPixbufAnimation *animation
#	guint start_time_seconds
#	guint start_time_microseconds
#    CODE:
#	if (start_time_microseconds) {
#		GTimeVal start_time;
#		start_time.tv_sec = start_time_seconds;
#		start_time.tv_usec = start_time_microseconds;
#		RETVAL = gdk_pixbuf_animation_get_iter (animation,
#		                                        &start_time);
#	} else
#		RETVAL = gdk_pixbuf_animation_get_iter (animation, NULL);
#    OUTPUT:
#	RETVAL

####
#### Gtk2::Gdk::PixbufAnimationIter
####

#int $iter->get_delay_time (GdkPixbufAnimationIter *iter) 
#
#GdkPixbuf $iter->get_pixbuf
#
#gboolean $iter->on_currently_loading_frame
#
#gboolean $iter->advance (current_time_seconds=0, current_time_microseconds=0)
#

SKIP: {
  skip "GdkPixbufFormat stuff is new in 2.2.0", 12
    unless Gtk2->CHECK_VERSION (2,2,0);

  my @formats = Gtk2::Gdk::Pixbuf->get_formats;
  ok (scalar (@formats), "got a list back");
  is (ref $formats[0], 'Gtk2::Gdk::PixbufFormat', "list of formats");
  ok (exists $formats[0]{name}, "contains key 'name'");
  ok (exists $formats[0]{description}, "contains key 'description'");
  ok (exists $formats[0]{mime_types}, "contains key 'mime_types'");
  is (ref $formats[0]{mime_types}, 'ARRAY', "'mime_types' is a list");
  ok (exists $formats[0]{extensions}, "contains key 'extensions'");
  is (ref $formats[0]{extensions}, 'ARRAY', "'extensions' is a list");

  SKIP: {
    skip "new format stuff", 4
      unless Gtk2->CHECK_VERSION (2,6,0);

    ok (exists $formats[0]{is_scalable});
    ok (exists $formats[0]{is_disabled});
    ok (exists $formats[0]{license});

    $formats[0]->set_disabled (TRUE);
    @formats = Gtk2::Gdk::Pixbuf->get_formats;
    is ($formats[0]->{is_disabled}, TRUE);
  }
}

if ($show) {
	$win->show_all;
	$win->signal_connect (delete_event => sub {Gtk2->main_quit});
	Gtk2->main;
}


SKIP: {
	skip "can't test display-related stuff without a display", 7
		unless Gtk2->init_check;

	my $window = Gtk2::Gdk::Window->new (undef, {
				width => 100,
				height => 50,
				wclass => 'output',
				window_type => 'toplevel',
			});
	my $pixmap = Gtk2::Gdk::Pixmap->new ($window, 100, 50, -1);
	my $bitmap = Gtk2::Gdk::Pixmap->new ($window, 100, 50, 1);
	my $gc = Gtk2::Gdk::GC->new ($pixmap);

	$pixbuf = Gtk2::Gdk::Pixbuf->new ('rgb', FALSE, 8, 100, 50);

	$pixbuf->render_threshold_alpha ($bitmap, 0, 0, 0, 0,
	                                 $bitmap->get_size,
	                                 0.75);

	$pixbuf->render_to_drawable ($pixmap, $gc, 0, 0, 50, 20,
	                             $pixmap->get_size, 'normal', 1, 3);

	$pixbuf->render_to_drawable_alpha ($pixmap, 0, 0, 0, 0,
	                                   $pixmap->get_size, 'bilevel', 0.75,
	                                   'normal', 1, 0);

	my $colormap = $pixmap->get_colormap;
	$pixbuf = $pixbuf->add_alpha (FALSE, 0, 0, 0);
	($pixmap, $bitmap) =
		$pixbuf->render_pixmap_and_mask_for_colormap ($colormap, 0.75);
	isa_ok ($pixmap, 'Gtk2::Gdk::Pixmap');
	isa_ok ($bitmap, 'Gtk2::Gdk::Bitmap');

	# context sensitive, make sure we get the right thing back
	$pixmap = $pixbuf->render_pixmap_and_mask_for_colormap ($colormap, 0.75);
	isa_ok ($pixmap, 'Gtk2::Gdk::Pixmap');


	($pixmap, $bitmap) = $pixbuf->render_pixmap_and_mask (0.75);
	isa_ok ($pixmap, 'Gtk2::Gdk::Pixmap');
	isa_ok ($bitmap, 'Gtk2::Gdk::Bitmap');

	# context sensitive, make sure we get the right thing back
	$pixmap = $pixbuf->render_pixmap_and_mask (0.75);
	isa_ok ($pixmap, 'Gtk2::Gdk::Pixmap');

	## FIXME create a GdkImage somehow
	#$pixbuf = Gtk2::Gdk::Pixbuf->get_from_image ($src, $cmap, $src_x, $src_y, $dest_x, $dest_y, $width, $height)
	#$pixbuf = $pixbuf->get_from_image ($src, $cmap, $src_x, $src_y, $dest_x, $dest_y, $width, $height)

	$pixbuf = Gtk2::Gdk::Pixbuf->get_from_drawable
			($pixmap, undef, 0, 0, 0, 0, $pixmap->get_size);
	isa_ok ($pixbuf, 'Gtk2::Gdk::Pixbuf', 'get_from_drawable');

	$pixbuf->get_from_drawable
			($pixmap, undef, 0, 0, 0, 0, $pixmap->get_size);
}
