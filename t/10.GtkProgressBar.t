#
# $Header$
#

#########################
# GtkProgressBar Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 9;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

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

Glib::Idle->add( sub {
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
