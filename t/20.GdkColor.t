#
# $Header$
#

#########################
# GdkColor Tests
# 	- muppet
#########################

use Gtk2;
use Test::More;

BEGIN { use_ok ('Gtk2') }

if( Gtk2->init_check )
{
	plan tests => 6;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

my $cmap = Gtk2::Gdk::Colormap->get_system;
ok ($cmap, 'system colormap');

# ten random colors
my @colors = map {
	Gtk2::Gdk::Color->new (rand (65535), rand (65535), rand (65535))
} 0..9;

$cmap->alloc_color ($colors[0], 0, 1);
ok ($colors[0]->pixel > 0, 'alloc_color allocated a color');
@success = $cmap->alloc_colors (0, 1, @colors);
is (@success, @colors, 'same number of status values as input colors');
ok ($colors[1]->pixel > 0, 'alloc_colors allocated a color');

my $c = $cmap->query_color ($colors[0]->pixel);
ok($c, 'query_color does something');

$cmap->free_colors (@colors);
ok (1, 'free_colors didn\'t coredump');


