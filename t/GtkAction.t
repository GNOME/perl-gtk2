#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
	tests => 9, noinit => 0;

my $action = Gtk2::Action->new (name => 'Open',
                                label => '_Open',
                                tooltip => 'Open Something',
                                stock_id => 'gtk-open');

isa_ok ($action, 'Gtk2::Action');
is ($action->get_name, 'Open');

$action->signal_connect (activate => sub { ok (TRUE) });
$action->activate;

# most of these are for action implementations
$icon_widget = $action->create_icon ('large-toolbar');
isa_ok ($icon_widget, 'Gtk2::Image');

my $group = Gtk2::ActionGroup->new ('dummy');
$group->add_action ($action);

$widget = $action->create_menu_item;
isa_ok ($widget, 'Gtk2::MenuItem');

$widget = $action->create_tool_item;
isa_ok ($widget, 'Gtk2::ToolItem');

@proxies = $action->get_proxies;
is (@proxies, 1);

my $proxy = Gtk2::Statusbar->new;
$action->connect_proxy ($proxy);
@proxies = $action->get_proxies;
is (@proxies, 2);

$action->disconnect_proxy ($proxy);
@proxies = $action->get_proxies;
is (@proxies, 1);

$action->connect_accelerator;
$action->disconnect_accelerator;
## /* protected ... for use by child actions */
$action->block_activate_from ($proxy);
$action->unblock_activate_from ($proxy);
## /* protected ... for use by action groups */
$action->set_accel_path ('<Action>/');
$action->set_accel_group (undef);
$action->set_accel_group (Gtk2::AccelGroup->new);

