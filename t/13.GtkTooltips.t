#
# $Header$
#

use strict;
use warnings;

#########################
# GtkTooltips Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 12;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( my $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkTooltips.t Test Window');

ok( my $vbox = Gtk2::VBox->new(0, 5) );
$win->add($vbox);

ok( my $tips = Gtk2::Tooltips->new );

ok( my $btn = Gtk2::Button->new('Button 1') );
$vbox->pack_start($btn, 0, 0, 0);
$tips->set_tip($btn, 'Tip 1', 'Vebose Tip 1');
ok(1);

ok( $btn = Gtk2::Button->new('Button 2') );
$vbox->pack_start($btn, 0, 0, 0);
$tips->set_tip($btn, 'Tip 2', 'Vebose Tip 2');
ok( (Gtk2::Tooltips->data_get($btn))->{tip_text} eq 'Tip 2' );

ok( $btn = Gtk2::Button->new('Button 3') );
$vbox->pack_start($btn, 0, 0, 0);
$tips->set_tip($btn, 'This is a really long, really big tooltip which doesn\'t '
	.'tell you anything worth knowning. There\'s no private tip either',
	undef);
ok(1);

$tips->disable;
ok(1);
$tips->enable;
ok(1);

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	});

$win->show_all;

Gtk2->main;

ok(1);
