#
# $Header$
#

#########################
# GtkProgressBar Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 11;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new('toplevel') );

$win->set_title('GtkProgressBar.t Test Window');

ok( $vbox = Gtk2::VBox->new( 0, 5 ) );
$win->add($vbox);

@ori = qw/left-to-right right-to-left top-to-bottom bottom-to-top/;

foreach (@ori)
{
	ok( $prog = Gtk2::ProgressBar->new );
	$vbox->pack_start($prog, 0, 0, 0);
	$prog->set_orientation($_);
	push @prog, $prog;
}

$win->show_all;

G::Idle->add( sub {
		foreach (@prog)
		{
			$_->pulse;
		}
		ok(1);
		foreach (@prog)
		{
			$_->set_fraction(rand);
		}
		ok(1);
		Gtk2->main_quit;
		0;
	});

Gtk2->main;

ok(1);
