#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkComboBoxEntry is new in 2.4"],
	tests => 7;

my $entry_box;

$entry_box = Gtk2::ComboBoxEntry->new;
isa_ok ($entry_box, 'Gtk2::ComboBoxEntry');

my $model = Gtk2::ListStore->new (qw/Glib::String Glib::Int Glib::String/);
foreach (qw/a b c d e f g/) {
	$model->set ($model->append, 0, $_, 1, ord($_), 2, $_**2);
}
$entry_box->set_model ($model);
is ($entry_box->get_model, $model);
$entry_box->set_text_column (2);
is ($entry_box->get_text_column, 2);

my $text_column = 1;
$entry_box = Gtk2::ComboBoxEntry->new ($model, $text_column);
isa_ok ($entry_box, 'Gtk2::ComboBoxEntry');
is ($entry_box->get_text_column, $text_column);

$text_column = 0;
$entry_box = Gtk2::ComboBoxEntry->new_with_model ($model, $text_column);
isa_ok ($entry_box, 'Gtk2::ComboBoxEntry');
is ($entry_box->get_text_column, $text_column);

$entry_box->get_child->set_editable (TRUE);
$entry_box->get_child->set_text ('whee');

#my $dlg = Gtk2::Dialog->new ('foo', undef, [], 'gtk-cancel' => 'cancel');
#$dlg->vbox->add ($entry_box);
#
#$dlg->show_all;
#$dlg->run;
