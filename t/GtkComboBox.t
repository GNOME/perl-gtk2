#!/usr/bin/perl -w

# $Header$

use Gtk2::TestHelper
	tests => 7,
	noinit => 1,
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkComboBox didn't exist until 2.3.0"],
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

SKIP: {
	skip "set_active_iter is currently borken", 2
		unless 0; # FIXME: change that once it's fixed.

	my $iter = $model->get_iter_first;
	$combo_box->set_active_iter ($iter);
	is ($model->get_path ($combo_box->get_active_iter)->to_string,
	    $model->get_path ($iter)->to_string);
	is ($combo_box->get_active, 0);
}

#$combo_box = Gtk2::ComboBox->new;
#$combo_box = Gtk2::ComboBox->new ($model)
#$combo_box = Gtk2::ComboBox->new_with_model ($model)

## grids
#$combo_box->set_wrap_width (width);
#$combo_box->set_row_span_column (row_span);
#$combo_box->set_column_span_column (column_span);

##$iter = $combo_box->get_active_iter;
##$combo_box->set_active_iter ($iter);

## getters and setters

$model = Gtk2::ListStore->new ('Glib::String');
$combo_box->set_model ($model);
is ($combo_box->get_model, $model);


