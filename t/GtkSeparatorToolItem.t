#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 3;


my $item = Gtk2::SeparatorToolItem->new;
isa_ok ($item, 'Gtk2::SeparatorToolItem');


$item->set_draw (TRUE);
ok ($item->get_draw);

$item->set_draw (FALSE);
ok (!$item->get_draw);
