#
# $Header
#

use strict;
use warnings;

#########################
# GtkCombo Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 3;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( my $win = Gtk2::Window->new() );

$win->set_title('GtkCombo.t Test Window');

ok( my $combo = Gtk2::Combo->new );
$win->add($combo);

$combo->set_popdown_strings( qw/str1 str2 str3 str4/ );

$combo->set_value_in_list(1, 0);

Glib::Idle->add( sub
	{
		Gtk2->main_quit;
		0;
	} );

$win->show_all;

ok(1);

Gtk2->main;
