#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "Action-based menus are new in 2.4"],
#	tests => 9, noinit => 1;
	tests => 9;

my $action_group = Gtk2::ActionGroup->new ("Fred");

isa_ok ($action_group, "Gtk2::ActionGroup");
is ($action_group->get_name, "Fred");

my $action = Gtk2::Action->new (name => 'Barney');

$action_group->add_action ($action);

my @list = $action_group->list_actions;
is (@list, 1);
is ($list[0], $action);
is ($action_group->get_action ('Barney'), $action);
$action_group->remove_action ($action);
@list = $action_group->list_actions;
is (@list, 0);

my @action_entries = (
  {
    name        => 'open',
    stock_id    => 'gtk-open',
    label       => 'Open',
    accelerator => '<control>o',
    tooltip     => 'Open something',
    callback    => sub { ok (TRUE) },
  },
  {
    name        => 'new',
    stock_id    => 'gtk-new',
  },
  {
    name        => 'old',
    label       => 'Old',
  },
  [ 'close', 'gtk-close', 'Close', '<control>w', 'Close something', sub { ok (TRUE) } ],
  [ 'quit', 'gtk-quit', undef, '<control>q', ],
  [ 'sep',  undef, 'blank', ],
);

my @toggle_entries = (
  [ "Bold", 'gtk-bold', "_Bold",               # name, stock id, label
     "<control>B", "Bold",                     # accelerator, tooltip 
    \&activate_action, TRUE ],                 # is_active 
);

use constant COLOR_RED   => 0;
use constant COLOR_GREEN => 1;
use constant COLOR_BLUE  => 2;

my @color_entries = (
  # name,    stock id, label,    accelerator,  tooltip, value 
  [ "Red",   undef,    "_Red",   "<control>R", "Blood", COLOR_RED   ],
  [ "Green", undef,    "_Green", "<control>G", "Grass", COLOR_GREEN ],
  [ "Blue",  undef,    "_Blue",  "<control>B", "Sky",   COLOR_BLUE  ],
);

#$action_group->add_actions (\@action_entries, 42)
$action_group->add_actions (\@action_entries);
@list = $action_group->list_actions;
is (@list, 6);

$action_group->add_toggle_actions (\@toggle_entries, 42);
#$action_group->add_toggle_actions (\@toggle_entries);
@list = $action_group->list_actions;
is (@list, 7);


#$action_group->add_radio_actions (\@color_entries, COLOR_BLUE, \&on_change, 42);
$action_group->add_radio_actions (\@color_entries, COLOR_GREEN, \&on_change);
@list = $action_group->list_actions;
is (@list, 10);
