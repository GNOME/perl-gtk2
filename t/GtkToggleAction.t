#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 8;

my $action = Gtk2::ToggleAction->new;
isa_ok ($action, 'Gtk2::ToggleAction');

$action->signal_connect (toggled => sub { ok (TRUE) });
$action->toggled;


$action->set_active (TRUE);
ok ($action->get_active);

$action->set_active (FALSE);
ok (!$action->get_active);


$action->set_draw_as_radio (TRUE);
ok ($action->get_draw_as_radio);

$action->set_draw_as_radio (FALSE);
ok (!$action->get_draw_as_radio);

