#
# $Header$
#

use strict;
use warnings;

#########################
# GtkAccelGroup Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if (Gtk2->init_check)
{
	plan tests => 4;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

ok( my $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok (my $accel = Gtk2::AccelGroup->new, 'Gtk2::AccelGrop->new');

sub conn_func
{
	ok(1, 'connect_func ctrl')
}

$accel->connect (42, qw/control-mask/, [], \&conn_func);

$accel->connect (42, qw/shift-mask/, 'visible', 
	sub { ok(1, 'connect_func alt') });

# $accel->connect_by_path
# TODO: $win->groups_from_object (

$accel->lock;
$win->show_all;

Glib::Idle->add (sub {

		# TODO: $win->activate (
		
		Gtk2->main_quit;
		$accel->unlock;

		ok ($accel->disconnect_key (42, qw/shift-mask/));
		ok ($accel->disconnect (\&conn_func));
		# TODO: core dumps, ok (not $accel->disconnect_key (42, qw/shift-mask/));

		0;
	});

Gtk2->main;

1;

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list) See LICENSE for more information.
