#!/usr/bin/perl -w

use Gtk2::TestHelper
	tests => 12,
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkExpander didn't exist until 2.3.0"],
	;

my $fbn;
$fbn = Gtk2::FontButton->new;
isa_ok ($fbn, 'Gtk2::FontButton');
$fbn = Gtk2::FontButton->new_with_font ("monospace");
isa_ok ($fbn, 'Gtk2::FontButton');


$fbn->set_title ("slartibartfast");
is ($fbn->get_title, "slartibartfast");


$fbn->set_use_font (FALSE);
ok (!$fbn->get_use_font);

$fbn->set_use_font (TRUE);
ok ($fbn->get_use_font);


$fbn->set_use_size (FALSE);
ok (!$fbn->get_use_size);

$fbn->set_use_size (TRUE);
ok ($fbn->get_use_size);


$fbn->set_show_style (FALSE);
ok (!$fbn->get_show_style);

$fbn->set_show_style (TRUE);
ok ($fbn->get_show_style);


$fbn->set_show_size (FALSE);
ok (!$fbn->get_show_size);

$fbn->set_show_size (TRUE);
ok ($fbn->get_show_size);


$fbn->set_font_name ("sans");
like ($fbn->get_font_name, qr/sans/i);


