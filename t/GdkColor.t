#
# $Header$
#

#########################
# GdkColor Tests
# 	- muppet
#########################

use Gtk2::TestHelper tests => 16;

my $cmap = Gtk2::Gdk::Colormap->get_system;
ok ($cmap, 'system colormap');

my $visual = $cmap->get_visual;
ok ($visual, 'got a visual');

my $tmp_cmap = Gtk2::Gdk::Colormap->new ($visual, 1);
ok ($tmp_cmap, 'new colormap');

ok ($cmap->get_screen, 'got a screen');

# ten random colors
my @colors = map {
	Gtk2::Gdk::Color->new (rand (65535), rand (65535), rand (65535))
} 0..9;

$cmap->alloc_color ($colors[0], 0, 1);
ok ($colors[0]->pixel > 0, 'alloc_color allocated a color');
my @success = $cmap->alloc_colors (0, 1, @colors);
is (@success, @colors, 'same number of status values as input colors');
ok ($colors[1]->pixel > 0, 'alloc_colors allocated a color');

my $c = $cmap->query_color ($colors[0]->pixel);
ok($c, 'query_color does something');

$cmap->free_colors (@colors);
ok (1, 'free_colors didn\'t coredump');

my $black = Gtk2::Gdk::Color->parse("Black");
ok ($black, 'Black parsed ok');

ok ($black->equal($black), 'Black == Black');
is ($black->hash, 0, 'Black\'s hash == 0');

like($black->pixel, qr/^\d+$/);
is($black->red, 0);
is($black->green, 0);
is($black->blue, 0);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
