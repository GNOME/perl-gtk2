#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 19;


my $tool_item = Gtk2::ToolItem->new;
isa_ok ($tool_item, 'Gtk2::ToolItem');


$tool_item->set_homogeneous (TRUE);
ok ($tool_item->get_homogeneous);

$tool_item->set_homogeneous (FALSE);
ok (!$tool_item->get_homogeneous);


$tool_item->set_expand (TRUE);
ok ($tool_item->get_expand);

$tool_item->set_expand (FALSE);
ok (!$tool_item->get_expand);


my $tooltips = Gtk2::Tooltips->new;
$tool_item->set_tooltip ($tooltips, 'tip_text', 'tip_private');


$tool_item->set_use_drag_window (TRUE);
ok ($tool_item->get_use_drag_window);

$tool_item->set_use_drag_window (FALSE);
ok (!$tool_item->get_use_drag_window);


$tool_item->set_visible_horizontal (TRUE);
ok ($tool_item->get_visible_horizontal);

$tool_item->set_visible_horizontal (FALSE);
ok (!$tool_item->get_visible_horizontal);


$tool_item->set_visible_vertical (TRUE);
ok ($tool_item->get_visible_vertical);

$tool_item->set_visible_vertical (FALSE);
ok (!$tool_item->get_visible_vertical);


$tool_item->set_is_important (TRUE);
ok ($tool_item->get_is_important);

$tool_item->set_is_important (FALSE);
ok (!$tool_item->get_is_important);


is ($tool_item->get_icon_size,     'large-toolbar');
is ($tool_item->get_orientation,   'horizontal');
is ($tool_item->get_toolbar_style, 'icons');
is ($tool_item->get_relief_style,  'none');


my $menu_item = Gtk2::MenuItem->new;
$tool_item->set_proxy_menu_item ("menu_item_id", $menu_item);
is ($tool_item->retrieve_proxy_menu_item, $menu_item);
is ($tool_item->get_proxy_menu_item ("menu_item_id"), $menu_item);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
