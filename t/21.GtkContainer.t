#!/usr/bin/perl -w

use Gtk2::TestHelper tests => 20;

# we'll create some containers (windows and boxes are containers) and
# mess around with some of the methods to make sure they do things.

my $window = Gtk2::Window->new;
my $vbox = Gtk2::VBox->new;


is ($window->child_type, 'Gtk2::Widget', 'a window wants a widget');

# i think we'd know if $container->add didn't work
$window->add ($vbox);
ok (1, 'added a widget to the window');

$window->set_focus_child($vbox);
ok(1);

my $adjustment = Gtk2::Adjustment->new(0, 0, 100, 5, 10, 20);

$window->set_focus_vadjustment($adjustment);
is($window->get_focus_vadjustment, $adjustment);

$window->set_focus_hadjustment($adjustment);
is($window->get_focus_hadjustment, $adjustment);

$window->resize_children;
ok(1);

$window->set_border_width(10);
is($window->get_border_width, 10);

SKIP: {
	skip 'Gtk2::Gdk::Event->new is new in 2.2.0', 1
		if Gtk2->check_version(2, 2, 0);

	my $expose_event = Gtk2::Gdk::Event->new("expose");
	$window->propagate_expose($vbox, $expose_event);

	ok(1);
}

# child_type returns undef when no more children may be added
#ok (!defined ($window->child_type),
 #   'child_type returns undef when the container is full');
is ($window->get_child, $vbox,
    'the window\'s child is set');


is ($vbox->child_type, 'Gtk2::Widget', 'a box wants a widget');

$vbox->pack_start (Gtk2::Label->new ("one"), 1, 1, 0);

is ($vbox->child_type, 'Gtk2::Widget', 'a box is always hungry');

# let's dump in a few more quickly
$vbox->pack_start (Gtk2::Button->new ("two"), 1, 1, 0);
$vbox->pack_start (Gtk2::ToggleButton->new ("three"), 1, 1, 0);
$vbox->pack_start (Gtk2::CheckButton->new ("four"), 1, 1, 0);
$vbox->pack_start (Gtk2::Entry->new (), 1, 1, 0);

my @children = $vbox->get_children;
is (scalar (@children), 5, 'we packed five children');

my @chain = $vbox->get_focus_chain;
is (scalar (@chain), 0, 'we have not set a focus chain');

# set focus chain to focusable children in reverse order
@chain = reverse map { $_->can_focus ? $_ : () } @children;
$vbox->set_focus_chain (@chain);
eq_array( [$vbox->get_focus_chain], \@chain, 'focus chain took');

$vbox->unset_focus_chain;
is_deeply([$vbox->get_focus_chain], []);

# togglebuttons suck.  wipe them out... all of them.
my $nremoved = 0;
$vbox->foreach (sub {
	if ('Gtk2::ToggleButton' eq ref $_[0]) {
		$vbox->remove ($_[0]);
		$nremoved++;
	}
	});
is ($nremoved, 1, 'removed one toggle');
@children = $vbox->get_children;
is (scalar (@children), 4, 'four children remain');

is ($vbox->get_resize_mode, 'parent');
$vbox->set_resize_mode ('queue');
is ($vbox->get_resize_mode, 'queue');

$vbox->check_resize;
ok(1);

$vbox->set_reallocate_redraws(1);
ok(1);

#$window->show_all;
#Gtk2->main;

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
