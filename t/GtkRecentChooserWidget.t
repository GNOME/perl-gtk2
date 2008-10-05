#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 4,
  at_least_version => [2, 10, 0, "GtkRecentChooserWidget"];

# $Id$

my $manager = Gtk2::RecentManager -> new();

my $chooser = Gtk2::RecentChooserWidget -> new();
isa_ok($chooser, "Gtk2::RecentChooser");
isa_ok($chooser, "Gtk2::RecentChooserWidget");

$chooser = Gtk2::RecentChooserWidget -> new_for_manager($manager);
isa_ok($chooser, "Gtk2::RecentChooser");
isa_ok($chooser, "Gtk2::RecentChooserWidget");

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
