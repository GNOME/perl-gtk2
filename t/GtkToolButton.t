#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 13;

my $tool_button = Gtk2::ToolButton->new (undef, undef);
isa_ok ($tool_button, 'Gtk2::ToolButton');

my $icon_widget = Gtk2::Image->new_from_stock ('gtk-ok', 'large-toolbar');
$tool_button = Gtk2::ToolButton->new ($icon_widget, 'some label string');
isa_ok ($tool_button, 'Gtk2::ToolButton');

$tool_button = Gtk2::ToolButton->new_from_stock ('gtk-cancel');
isa_ok ($tool_button, 'Gtk2::ToolButton');


$tool_button->set_label (undef);
is ($tool_button->get_label, undef);

$tool_button->set_label ('something');
is ($tool_button->get_label, 'something');


$tool_button->set_use_underline (TRUE);
ok ($tool_button->get_use_underline);

$tool_button->set_use_underline (FALSE);
ok (!$tool_button->get_use_underline);


$tool_button->set_stock_id (undef);
is ($tool_button->get_stock_id, undef);

$tool_button->set_stock_id ('gtk-open');
is ($tool_button->get_stock_id, 'gtk-open');


$icon_widget = Gtk2::Image->new_from_stock ('gtk-cancel', 'large-toolbar');
$tool_button->set_icon_widget ($icon_widget);
is ($tool_button->get_icon_widget, $icon_widget);

$tool_button->set_icon_widget (undef);
is ($tool_button->get_icon_widget, undef);


my $label_widget = Gtk2::Label->new ('foo');
$tool_button->set_label_widget ($label_widget);
is ($tool_button->get_label_widget, $label_widget);

$tool_button->set_label_widget (undef);
is ($tool_button->get_label_widget, undef);
