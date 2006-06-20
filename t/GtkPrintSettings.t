#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 7,
  at_least_version => [2, 9, 0, "GtkPrintSettings is new in 2.10"]; # FIXME 2.10

# $Header$

my $settings = Gtk2::PrintSettings -> new();
isa_ok($settings, "Gtk2::PrintSettings");

my $key = "printer";
SKIP: {
  skip "settings tests", 6
    unless $settings -> has_key($key);

  my $value = $settings -> get($key);
  ok(defined $value);
  $settings -> set($key, $value);
  is($settings -> get($key), $value);

  $settings -> set($key, undef);
  is($settings -> get($key), undef);

  $settings -> unset($key);
  is($settings -> get($key), undef);

  my $i_know_you = 0;
  my $callback = sub {
    my ($key, $value, $data) = @_;
    return if $i_know_you++;
    ok(defined $key);
    ok(defined $value);
    is($data, "blub");
  };
  $settings -> foreach($callback, "blub");
}

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
