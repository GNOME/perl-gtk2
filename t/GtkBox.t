#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 75, noinit => 1;

my $box = Gtk2::VBox -> new();
isa_ok($box, "Gtk2::Box");

my $label = Gtk2::Label -> new("Bla");
my $frame = Gtk2::Frame -> new("Bla");
my $button = Gtk2::Button -> new("Bla");
my $entry = Gtk2::Entry -> new();

$box -> pack_start($label, 0, 1, 5);
$box -> pack_end($frame, 1, 0, 10);
$box -> pack_start_defaults($button);
$box -> pack_end_defaults($entry);

is_deeply([$box -> query_child_packing($label)], [undef, 1, 5, "start"]);
is_deeply([$box -> query_child_packing($frame)], [1, undef, 10, "end"]);
is_deeply([$box -> query_child_packing($button)], [1, 1, 0, "start"]);
is_deeply([$box -> query_child_packing($entry)], [1, 1, 0, "end"]);

$box -> set_child_packing($button, 0, 0, 23, "end");
is_deeply([$box -> query_child_packing($button)], [undef, undef, 23, "end"]);

$box -> set_homogeneous(1);
is($box -> get_homogeneous(), 1);

$box -> set_spacing(5);
is($box -> get_spacing(), 5);

$box -> reorder_child($label, -1);

###############################################################################
# Ross' 0.7.GtkBoxes.t.

ok( my $vbox = Gtk2::VBox->new(0,5) );

my ($r, $c);
for( $r = 0; $r < 3; $r++ )
{
	ok( my $hbox = Gtk2::HBox->new(0, 5), "created hbox for row $r" );
	$vbox->pack_start($hbox, 0, 0, 5);
	$hbox->set_name ("hbox $r");
	for( $c = 0; $c < 3; $c++ )
	{
		ok( my $label = Gtk2::Label->new("(r,c):($r,$c)"), 'created label' );
		$hbox->pack_start($label, 0, 0, 10);

		# make sure we are where we think we are
		is( $label->get_ancestor ('Gtk2::Box'), $hbox, 'ancestry' );
		is( $label->get_ancestor ('Gtk2::VBox'), $vbox, 'ancestry' );

		# interestingly, the second string returned from this
		# appears to be reversed, rather than the objects in
		# reverse order.  how handy.  that makes the second
		# one fairly useless, but let's verify that it's there.
		my ($path, $htap) = $label->path;
		ok( defined($htap), 'path returned two items' );
		ok( $path =~ /hbox $r/, "'hbox $r' is in the path" );
		##print "path $path\n";

		($path, $htap) = $label->class_path;
		ok( defined($htap), 'path returned two items' );
		ok( $path !~ /hbox $r/, "'hbox $r' is not in the class path" );
		##print "class path $path\n";
	}
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
