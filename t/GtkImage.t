#
# $Header$
#

#########################
# GtkImage Tests
# 	- rm
#########################

use Data::Dumper;
use Gtk2::TestHelper tests => 12;

my $win = Gtk2::Window->new ("toplevel");

$win->set_default_size (100, 100);

ok (my $img = Gtk2::Image->new, 'Gtk2::Image->new');
	
is ($img->get_image, undef, 'get_image empty');
is ($img->get_pixbuf, undef, 'get_pixbuf empty');
is ($img->get_pixmap, undef, 'get_pixmap empty');
is ($img->get_animation, undef, 'get_animation empty');
is ($img->get_storage_type, 'empty', 'get_storage_type empty');
ok (eq_array ([$img->get_stock ()], [undef, 'button']), 'get_stock empty');

ok ($img = Gtk2::Image->new_from_stock ('gtk-cancel', 'menu'), 
    'Gtk2::Image->new_from_stock');
is ($img->get_storage_type, 'stock', 'get_storage_type');
ok (eq_array ([$img->get_stock ()], ['gtk-cancel', 'menu']), 'get_stock');

$img->set_from_stock ('gtk-quit', 'dialog');
is ($img->get_storage_type, 'stock', 'set_from_stock, get_storage_type');
ok (eq_array ([$img->get_stock ()], ['gtk-quit', 'dialog']), 
    'set_from_stock, get_stock');

#print 'dump '.Dumper (
#	$img->get_image,
#	$img->get_pixbuf,
#	$img->get_pixmap,
#	$img->get_animation,
#	$img->get_storage_type,
#	$img->get_stock,
#);
#ok ($img = Gtk2::Image->new_from_stock ('gtk-quit', 'dialog'));


__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.

