#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkFileChooser is new in 2.4"],
	tests => 6;


my $widget = Gtk2::FileChooserWidget->new ('save');

isa_ok ($widget, 'Gtk2::FileChooserWidget');
isa_ok ($widget, 'Gtk2::FileChooser');

is ($widget->get_action, 'save');

SKIP: {
	skip 'new_with_backend is new in 2.3.5', 3
		unless Gtk2->CHECK_VERSION (2, 3, 5);

	$widget = Gtk2::FileChooserWidget->new_with_backend ('open',
	                                                     'backend');

	isa_ok ($widget, 'Gtk2::FileChooserWidget');
	isa_ok ($widget, 'Gtk2::FileChooser');

	is ($widget->get_action, 'open');
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
