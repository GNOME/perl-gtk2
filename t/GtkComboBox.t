#!/usr/bin/perl -w

# $Header$

use Gtk2::TestHelper
	tests => 10,
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
$combo_box->set_column_span_column (0);

$combo_box->set_active (1);
is ($combo_box->get_active, 1);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
