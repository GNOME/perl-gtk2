###!/usr/bin/perl -w

# $Header$

use Gtk2::TestHelper
	tests => 16,
	noinit => 1,
	at_least_version => [2, 4, 0, "GtkComboBox is new in 2.4"],
	;

my $combo_box;

## convenience -- text
$combo_box = Gtk2::ComboBox->new_text;
isa_ok ($combo_box, 'Gtk2::ComboBox');

$combo_box->append_text ("some text");
$combo_box->append_text ("more text");
$combo_box->prepend_text ("more text");
$combo_box->prepend_text ("more text");
$combo_box->insert_text (1, "even more text");
$combo_box->insert_text (5, "even more text");
$combo_box->remove_text (0);
$combo_box->remove_text (2);

$combo_box->set_active (2);
is ($combo_box->get_active, 2);

my $model = $combo_box->get_model;
isa_ok ($model, 'Gtk2::TreeModel');

is ($model->get_path ($combo_box->get_active_iter)->to_string,
    $combo_box->get_active);

my $iter = $model->get_iter_first;
$combo_box->set_active_iter ($iter);
is ($model->get_path ($combo_box->get_active_iter)->to_string,
    $model->get_path ($iter)->to_string);

$combo_box = Gtk2::ComboBox->new;
isa_ok ($combo_box, 'Gtk2::ComboBox');
# set a model to avoid a nastygram when destroying; some versions of gtk+
# do not check for NULL before unreffing the model.
$combo_box->set_model ($model);

$combo_box = Gtk2::ComboBox->new ($model);
isa_ok ($combo_box, 'Gtk2::ComboBox');

$combo_box = Gtk2::ComboBox->new_with_model ($model);
isa_ok ($combo_box, 'Gtk2::ComboBox');

## getters and setters

$model = Gtk2::ListStore->new ('Glib::String');
$combo_box->set_model ($model);
is ($combo_box->get_model, $model);

$combo_box->set_wrap_width (23);
$combo_box->set_row_span_column (0);
warn "# XXX set_column_span_column causes a hang when there is data in the model\n";
#$combo_box->set_column_span_column (0);

# get active returns -1 when nothing is selected
is ($combo_box->get_active, -1);

foreach my $t (qw(fee fie foe fum)) {
	$model->set ($model->append, 0, $t);
}

$combo_box->set_active (1);
is ($combo_box->get_active, 1, 'set and get active');

SKIP: {
	print "# new api in gtk+ 2.6\n";
	skip "new api in gtk+ 2.6", 5
		unless Gtk2->CHECK_VERSION (2, 5, 4); # FIXME 2.6.0

	my $active_path = Gtk2::TreePath->new_from_string
				("".$combo_box->get_active."");
	is ($combo_box->get_active_text,
	    $model->get ($model->get_iter ($active_path)),
	    'get active text');

	$combo_box->set_add_tearoffs (1);
	ok ($combo_box->get_add_tearoffs, 'tearoff accessors');
	$combo_box->set_add_tearoffs (0);
	ok (!$combo_box->get_add_tearoffs, 'tearoff accessors');

	$combo_box->set_focus_on_click (1);
	ok ($combo_box->get_focus_on_click, 'focus-on-click accessors');
	$combo_box->set_focus_on_click (0);
	ok (!$combo_box->get_focus_on_click, 'focus-on-click accessors');

	# FIXME not bound yet; don't know how to test it, either.
	#$combo_box->set_row_separator_func (sub {
	#	use Data::Dumper;
	#	print Dumper(\@_);
	#}, { something => 'else'});
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
