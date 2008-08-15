#!/usr/bin/perl
#
# $Header$
#

# ...despite patches that have been around for a long time, no win32
use Gtk2::TestHelper tests => 6, nowin32 => 1;

SKIP: {

skip "blib can't be found", 4
	unless -d "blib";

ok( my $win = Gtk2::Window->new );

ok( my $socket = Gtk2::Socket->new );
$win->add($socket);

ok( my $id = $socket->get_id );

SKIP: {
	skip 'new 2.14 stuff', 2
		unless Gtk2->CHECK_VERSION(2, 13, 6); # FIXME: 2.14

	is( $socket->get_plug_window, undef );
	$socket->signal_connect (plug_added => sub {
		isa_ok( $socket->get_plug_window, 'Gtk2::Gdk::Window' );
	});
}

my $str = "$^X -Mblib -e '\$id = $id;\n\n".<<EOL;
use Gtk2;

Gtk2->init;

\$plug = Gtk2::Plug->new($id);
\$plug->set_border_width(10);

\$btn = Gtk2::Button->new("gtk-quit");
\$btn->signal_connect( "clicked" => sub {
		Gtk2->main_quit;
		1;
	} );
\$plug->add(\$btn);

\$plug->show_all;

Glib::Timeout->add( 100, sub {
		\$btn->clicked;
		0;
	} );

Gtk2->main;'
EOL

use strict;
use warnings;

my $pid = fork;

skip 'fork failed', 1 unless defined $pid;

if( $pid < 0 )
{
	die "fork failed, no use trying";
}
if( $pid == 0 )
{
	exec($str);
	exit 0;
}
else
{
	$socket->signal_connect('plug-removed' => sub {
		Gtk2->main_quit;
		1;
	});
	$win->show_all;
	Gtk2->main;
	ok( waitpid($pid, 0) );
}

}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
