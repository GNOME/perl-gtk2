#!/usr/bin/perl -w

use Gtk2::TestHelper
	tests => 8,
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkColorButton didn't exist until 2.3.0"],
	;

sub color_eq {
	my ($a, $b) = @_;
	return $a->red == $b->red
	               &&
	     $a->green == $b->green
	               &&
	      $a->blue == $b->blue
}

my ($cbn, $color);
$cbn = Gtk2::ColorButton->new;
isa_ok ($cbn, "Gtk2::ColorButton");

$color = Gtk2::Gdk::Color->new (0, 0, 65535);
$cbn = Gtk2::ColorButton->new_with_color ($color);
isa_ok ($cbn, "Gtk2::ColorButton");
ok (color_eq ($color, $cbn->get_color));


$color = Gtk2::Gdk::Color->new (65535, 0, 0);
$cbn->set_color ($color);
ok (color_eq ($color, $cbn->get_color));


$cbn->set_alpha (32768);
is ($cbn->get_alpha, 32768);


$cbn->set_use_alpha (TRUE);
ok ($cbn->get_use_alpha);

$cbn->set_use_alpha (FALSE);
ok (!$cbn->get_use_alpha);


$cbn->set_title ("title");
is ($cbn->get_title, "title");

