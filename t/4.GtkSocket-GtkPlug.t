#########################
# GtkWindow Tests
# 	- rm
#########################
#
# $Header$
#


#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 6;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );
ok( $win = Gtk2::Window->new );

ok( $socket = Gtk2::Socket->new );
$win->add($socket);

ok( $id = $socket->get_id );

$str = "perl -e '\$id = $id;\n\n".<<EOL;
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

G::Timeout->add( 100, sub {
		\$btn->clicked;
		0;
	} );

Gtk2->main;'
EOL

$pid = fork;
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

