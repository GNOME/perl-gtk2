#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkFileChooser is new in 2.4"],
	tests => 5;


my $dialog = Gtk2::FileChooserDialog->new ('some title', undef, 'save',
                                           'gtk-cancel' => 'cancel',
                                           'gtk-ok' => 'ok');

isa_ok ($dialog, 'Gtk2::FileChooserDialog');
isa_ok ($dialog, 'Gtk2::FileChooser');

is ($dialog->get_action, 'save');

$dialog = Gtk2::FileChooserDialog->new_with_backend ('some title', undef,
                                                     'save',
                                                     'backend',
                                                     'gtk-cancel' => 'cancel',
                                                     'gtk-ok' => 'ok');

isa_ok ($dialog, 'Gtk2::FileChooserDialog');
isa_ok ($dialog, 'Gtk2::FileChooser');

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
