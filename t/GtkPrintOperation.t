#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 10,
  at_least_version => [2, 10, 0, "GtkPrintOperation is new in 2.10"];

# $Id$

my $op = Gtk2::PrintOperation -> new();
isa_ok($op, "Gtk2::PrintOperation");

my $setup = Gtk2::PageSetup -> new();
$op -> set_default_page_setup(undef);
is($op -> get_default_page_setup(), undef);
$op -> set_default_page_setup($setup);
is($op -> get_default_page_setup(), $setup);

my $settings = Gtk2::PrintSettings -> new();
$op -> set_print_settings(undef);
is($op -> get_print_settings(), undef);
$op -> set_print_settings($settings);
is($op -> get_print_settings(), $settings);

ok(defined $op -> get_status());
ok(defined $op -> get_status_string());
ok(defined $op -> is_finished());

sub get_op {
  my $op = Gtk2::PrintOperation -> new();
  $op -> set_job_name("Test");
  $op -> set_n_pages(2);
  $op -> set_current_page(1);
  $op -> set_use_full_page(TRUE);
  $op -> set_unit("mm");
  $op -> set_export_filename("test.pdf");
  $op -> set_track_print_status(TRUE);
  $op -> set_show_progress(FALSE);
  $op -> set_allow_async(TRUE);
  $op -> set_custom_tab_label("Print");
  return $op;
}

$op = get_op();
ok(defined $op -> run("export", undef));
$op -> cancel();

$op = get_op();
ok(defined $op -> run("export", Gtk2::Window -> new()));
$op -> cancel();

# FIXME: Don't know how to trigger an actual error.
# warn $op -> get_error();

unlink "test.pdf";

=comment

# Can't non-interactively test these, I think.  I manually verified that they
# work though.

Gtk2::Print -> run_page_setup_dialog_async(
                 undef, undef, $settings,
                 sub { warn join ", ", @_; Gtk2 -> main_quit(); }, "data");
Gtk2 -> main();

Gtk2::Print -> run_page_setup_dialog_async(
                 $window, $setup, $settings,
                 sub { warn join ", ", @_; Gtk2 -> main_quit(); }, "data");
Gtk2 -> main();

warn Gtk2::Print -> run_page_setup_dialog(undef, undef, $settings);

warn Gtk2::Print -> run_page_setup_dialog($window, $setup, $settings);

=cut

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
