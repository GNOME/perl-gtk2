#
# $Header$
#

use Gtk2::TestHelper
	at_least_version => [2, 4, 0, "Action-based menus are new in 2.4"],
	tests => 10, noinit => 1;


my @actions = (Gtk2::RadioAction->new (name => 'one', value => 0));
isa_ok ($actions[$#action], 'Gtk2::RadioAction');
my $i = 1;
foreach (qw(two three four five)) {
	push @actions, Gtk2::RadioAction->new (group => $actions[$#actions],
	                                       name => $_,
	                                       value => $i++);
	isa_ok ($actions[$#action], 'Gtk2::RadioAction');
}
my $group = $actions[0]->get_group;
push @actions, Gtk2::RadioAction->new (name => 'six', value => 5);
isa_ok ($actions[$#action], 'Gtk2::RadioAction');
$actions[$#actions]->set_group ($group);


is ($actions[0]->get_current_value, 0);

$actions[0]->set_current_value (3);
is ($actions[0]->get_current_value, 3);

$actions[3]->set_active (TRUE);
ok (!$actions[0]->get_active);
ok ($actions[3]->get_active);

__END__

Copyright (C) 2003-2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
