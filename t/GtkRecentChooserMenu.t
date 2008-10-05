#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 5,
  at_least_version => [2, 10, 0, "GtkRecentChooserMenu"];

# $Id$

my $manager = Gtk2::RecentManager -> new();

my $chooser = Gtk2::RecentChooserMenu -> new();
isa_ok($chooser, "Gtk2::RecentChooser");
isa_ok($chooser, "Gtk2::RecentChooserMenu");

$chooser = Gtk2::RecentChooserMenu -> new_for_manager($manager);
isa_ok($chooser, "Gtk2::RecentChooser");
isa_ok($chooser, "Gtk2::RecentChooserMenu");

$chooser -> set_show_numbers(TRUE);
ok($chooser -> get_show_numbers());

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
