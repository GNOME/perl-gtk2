#
# $Header$
#

use Gtk2::TestHelper
	at_least_version => [2, 4, 0, "Action-based menus are new in 2.4"],
	tests => 17, noinit => 0;

my $action = Gtk2::Action->new (name => 'Open',
                                label => '_Open',
                                tooltip => 'Open Something',
                                stock_id => 'gtk-open');

is ($action->is_sensitive, 1);
is ($action->get_sensitive, 1);

is ($action->is_visible, 1);
is ($action->get_visible, 1);

isa_ok ($action, 'Gtk2::Action');
is ($action->get_name, 'Open');

$action->signal_connect (activate => sub { ok (TRUE) });
$action->activate;

# most of these are for action implementations
my $icon_widget = $action->create_icon ('large-toolbar');
isa_ok ($icon_widget, 'Gtk2::Image');

my $group = Gtk2::ActionGroup->new ('dummy');
$group->add_action ($action);

my $widget = $action->create_menu_item;
isa_ok ($widget, 'Gtk2::MenuItem');

$widget = $action->create_tool_item;
isa_ok ($widget, 'Gtk2::ToolItem');

my @proxies = $action->get_proxies;
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

SKIP: {
	skip "new 2.6 stuff", 3
		unless Gtk2->CHECK_VERSION (2, 6, 0);

	$action->set_sensitive(FALSE);
	is ($action->is_sensitive, FALSE);

	$action->set_visible(FALSE);
	is ($action->is_visible, FALSE);

	ok (defined $action->get_accel_path);
}

SKIP: {
	skip "new 2.10 stuff", 1
		unless Gtk2->CHECK_VERSION (2, 9, 0); # FIXME 2.10

	isa_ok ($widget->get_action, 'Gtk2::Action');
}

__END__

Copyright (C) 2003-2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
