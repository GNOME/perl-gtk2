#
# $Header$
#

use strict;
use warnings;

#########################
# GtkHandleBox Tests
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
$win->set_title('GtkHandleBox.t Test Window');

ok( my $hb = Gtk2::HandleBox->new );
$win->add($hb);

$hb->add( Gtk2::Label->new('Just a test label') );

use Data::Dumper;

$hb->set_shadow_type('none');
ok( $hb->get_shadow_type eq 'none' );
$hb->set_shadow_type('etched-in');
ok( $hb->get_shadow_type eq 'etched-in' );

$hb->set_snap_edge('top');
ok( $hb->get_snap_edge eq 'top' );
$hb->set_snap_edge('left');
ok( $hb->get_snap_edge eq 'left' );

$hb->set_handle_position('left');
ok( $hb->get_handle_position eq 'left' );
$hb->set_handle_position('top');
ok( $hb->get_handle_position eq 'top' );

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	});

$win->show_all;
ok(1);

Gtk2->main;
ok(1);
