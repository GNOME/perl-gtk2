#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkFileChooser is new in 2.4"],
	tests => 6;


my $dialog = Gtk2::FileChooserDialog->new ('some title', undef, 'save',
                                           'gtk-cancel' => 'cancel',
                                           'gtk-ok' => 'ok');

isa_ok ($dialog, 'Gtk2::FileChooserDialog');
isa_ok ($dialog, 'Gtk2::FileChooser');

is ($dialog->get_action, 'save');

SKIP: {
	skip 'new_with_backend is new in 2.3.5', 3
		unless Gtk2->CHECK_VERSION (2, 3, 5);

	$dialog = Gtk2::FileChooserDialog->new_with_backend ('some title', undef,
	                                                     'open',
	                                                     'backend',
	                                                     'gtk-cancel' => 'cancel',
	                                                     'gtk-ok' => 'ok');

	isa_ok ($dialog, 'Gtk2::FileChooserDialog');
	isa_ok ($dialog, 'Gtk2::FileChooser');

	is ($dialog->get_action, 'open');
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
