#!/usr/bin/perl -w

use Test::More tests => 21;
use Gtk2 -init;

package Mup::CellRendererPopup;

use Test::More;

use Glib::Object::Subclass
	Gtk2::CellRendererText::,
	;

__PACKAGE__->_install_overrides;

sub INIT_INSTANCE { ok (1); }

sub on_get_size { ok (1, 'on_get_size'); shift->parent_get_size (@_) }
sub on_render { ok (1, 'on_render'); shift->parent_render (@_) }
sub on_activate { ok (1, 'on_activate'); shift->parent_activate (@_) }
sub on_start_editing { ok (1, 'on_start_editing'); shift->parent_start_editing (@_) }



##########################################################################
# driver code
package main;

$window = Gtk2::Window->new;
$window->set_title ('cell renderer test');
$window->signal_connect (delete_event => sub { Gtk2->main_quit; 0; });

$vbox = Gtk2::VBox->new;
$window->add ($vbox);

$label = Gtk2::Label->new;
$label->set_markup ('<big>F-Words</big>');
$vbox->pack_start ($label, 0, 0, 0);

# create and load the model
$model = Gtk2::ListStore->new ('Glib::String', 'Glib::Scalar', 'Glib::Int');
foreach (qw/foo fluffy flurble frob frobnitz ftang fire truck/) {
	my $iter = $model->append;
	$model->set ($iter, 0, $_);
}


# now a view
$treeview = Gtk2::TreeView->new ($model);

#
# custom cell renderer
#
$renderer = Mup::CellRendererPopup->new;
$renderer->set (mode => 'editable');
$column = Gtk2::TreeViewColumn->new_with_attributes ('selector', $renderer,
                                                     text => 0,);
# this handler commits the user's selection to the model.  compare with
# the one for the typical text renderer -- the only difference is a var name.
$renderer->signal_connect (edited => sub {
		my ($cell, $text_path, $new_text, $model) = @_;
		my $path = Gtk2::TreePath->new_from_string ($text_path);
		my $iter = $model->get_iter ($path);
		$model->set ($iter, 2, $new_text);
	}, $model);
$treeview->append_column ($column);


$vbox->pack_start ($treeview, 1, 1, 0);

$window->show_all;

Glib::Idle->add (sub {
	$treeview->set_cursor (Gtk2::TreePath->new_from_string ('0'),
	                       $column, 1);
	Gtk2->main_quit;
});

Gtk2->main;
