#!/usr/bin/perl -w

use Gtk2 -init;

my $msg = Gtk2->check_version (2,3,0); # FIXME 2.4
die "This example requires gtk+ 2.4.0, but we're linked against "
  . join (".", Gtk2->get_version_info)."\n"
  . "$msg\n"
	if $msg;

$window = Gtk2::Window->new;
$window->signal_connect (delete_event => sub { Gtk2->main_quit; 1 });

$expander = Gtk2::Expander->new ('A Combo Box!');
$window->add ($expander);

$vbox = Gtk2::VBox->new;
$expander->add ($vbox);

$model = Gtk2::ListStore->new ('Glib::String');
foreach (qw/this is a test of the emergency broadcast system/) {
	$model->set ($model->append, 0, $_);
}

$combo = Gtk2::ComboBoxEntry->new ($model, 0);
$vbox->add ($combo);

$model = Gtk2::ListStore->new ('Glib::String');
foreach (qw/this is a test of the emergency broadcast system/) {
	$model->set ($model->append, 0, $_);
}

$combo = Gtk2::ComboBox->new ($model);
$vbox->add ($combo);

$combo = Gtk2::ComboBox->new_text;
foreach (qw/this is a test of the emergency broadcast system/) {
	$combo->append_text ($_);
}
$vbox->add ($combo);


$window->show_all;

Gtk2->main;

