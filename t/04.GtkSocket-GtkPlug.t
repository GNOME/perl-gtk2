#########################
# GtkWindow Tests
# 	- rm
#########################
#
# $Header$
#

use strict;
use warnings;

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Gtk2;
use Test::More;

if ($^O eq 'MSWin32')
{
	plan skip_all => "socket and plug not implemented on win32";
	# ...despite patches that have been around for a long time
}
elsif( not Gtk2->init_check )
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}
else
{
	plan tests => 4;
}

#########################

ok( my $win = Gtk2::Window->new );

ok( my $socket = Gtk2::Socket->new );
$win->add($socket);

ok( my $id = $socket->get_id );

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

