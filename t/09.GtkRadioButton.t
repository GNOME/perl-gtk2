#
# $Header$
#

use strict;
use warnings;

#########################
# GtkRadioButton Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 10;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( my $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkRadioButton.t Test Window');
$win->set_border_width(5);

ok( my $vbox = Gtk2::VBox->new(0, 5) );
$win->add($vbox);

my $rdobtn;
ok( $rdobtn = Gtk2::RadioButton->new() );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new_from_widget($rdobtn) );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new_from_widget($rdobtn, "label") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new(undef, "foo") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new($rdobtn, "bar") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new([ $rdobtn ], "bar2") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( scalar(@{$rdobtn->get_group}) == 3 );

my $i;
my @rdobtns;
for( $i = 0; $i < 5; $i++ )
{
	$rdobtns[$i] = Gtk2::RadioButton->new(\@rdobtns, $i);
	$vbox->pack_start($rdobtns[$i], 0, 0, 0);
}

ok( scalar(@{$rdobtns[0]->get_group}) == 5 );

Glib::Idle->add( sub
	{
		Gtk2->main_quit;
		0;
	} );

$win->show_all;

Gtk2->main;

1;
