#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkFileChooser is new in 2.4"],
	tests => 3;


my $widget = Gtk2::FileChooserWidget->new ('save');

isa_ok ($widget, 'Gtk2::FileChooserWidget');
isa_ok ($widget, 'Gtk2::FileChooser');

is ($widget->get_action, 'save');
