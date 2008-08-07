#!/usr/bin/perl
use strict;
use warnings;
use Gtk2::TestHelper
  tests => 37,
  at_least_version => [2, 12, 0, 'GtkBuildable: it appeared in 2.12'];

# $Id$

my $builder;
my $ui = <<EOD;
<interface>
  <object class="GtkAdjustment" id="adjustment1">
    <property name="lower">0</property>
    <property name="upper">5</property>
    <property name="step-increment">1</property>
    <property name="value">5</property>
  </object>
  <object class="GtkSpinButton" id="spinbutton1">
    <property name="visible">True</property>
    <property name="adjustment">adjustment1</property>
    <signal name="value-changed" handler="value_changed" object="adjustment1" after="yes"/>
    <signal name="wrapped" handler="wrapped"/>
  </object>
</interface>
EOD

# --------------------------------------------------------------------------- #

my $ui_file = 'tmp.ui';

open my $fh, '>', $ui_file or plan skip_all => 'unable to create ui file';
print $fh $ui;
close $fh;

$builder = Gtk2::Builder->new;
isa_ok ($builder, 'Gtk2::Builder');

eval {
  $builder->add_from_file ('bla.ui');
};
like ($@, qr/bla\.ui/);

eval {
  ok ($builder->add_from_file ($ui_file) > 0);
};
is ($@, '');
isa_ok ($builder->get_object ('adjustment1'), 'Gtk2::Adjustment');

$builder->set_translation_domain (undef);
is ($builder->get_translation_domain, undef);
$builder->set_translation_domain ('de');
is ($builder->get_translation_domain, 'de');

unlink $ui_file;

# --------------------------------------------------------------------------- #

$builder = Gtk2::Builder->new;

eval {
  $builder->add_from_string ('<bla>');
};
like ($@, qr/bla/);

eval {
  ok ($builder->add_from_string ($ui) > 0);
};
is ($@, '');
my @objects = $builder->get_objects;
isa_ok ($objects[0], 'Gtk2::Adjustment');
isa_ok ($objects[1], 'Gtk2::SpinButton');

$builder->connect_signals_full(sub {
  my ($builder,
      $object,
      $signal_name,
      $handler_name,
      $connect_object,
      $flags,
      $data) = @_;

  if ($signal_name ne 'value-changed') {
    return;
  }

  isa_ok ($builder, 'Gtk2::Builder');
  isa_ok ($object, 'Gtk2::SpinButton');
  is ($signal_name, 'value-changed');
  is ($handler_name, 'value_changed');
  isa_ok ($connect_object, 'Gtk2::Adjustment');
  ok ($flags == [ qw/after swapped/ ]);
  is ($data, 'data');
}, 'data');

# --------------------------------------------------------------------------- #

package BuilderTestCaller;

use Test::More; # for is(), isa_ok(), etc.
use Glib qw/:constants/;

sub value_changed {
  my ($spin, $data) = @_;

  isa_ok ($spin, 'Gtk2::SpinButton');
  isa_ok ($data, 'Gtk2::Adjustment');
}

sub wrapped {
  my ($spin, $data) = @_;

  isa_ok ($spin, 'Gtk2::SpinButton');
  is ($data, '!alb');
}

$builder = Gtk2::Builder->new;
$builder->add_from_string ($ui);
$builder->connect_signals ('!alb');

my $spin = $builder->get_object ('spinbutton1');
$spin->set_wrap (TRUE);
$spin->spin ('step-forward', 1);

# --------------------------------------------------------------------------- #

package BuilderTest;

use Test::More; # for is(), isa_ok(), etc.
use Glib qw/:constants/;

sub value_changed {
  my ($spin, $data) = @_;

  isa_ok ($spin, 'Gtk2::SpinButton');
  isa_ok ($data, 'Gtk2::Adjustment');
}

sub wrapped {
  my ($spin, $data) = @_;

  isa_ok ($spin, 'Gtk2::SpinButton');
  is ($data, 'bla!');
}

$builder = Gtk2::Builder->new;
$builder->add_from_string ($ui);
$builder->connect_signals ('bla!', 'BuilderTest');

$spin = $builder->get_object ('spinbutton1');
$spin->set_wrap (TRUE);
$spin->spin ('step-forward', 1);

# --------------------------------------------------------------------------- #

package BuilderTestOO;

use Test::More; # for is(), isa_ok(), etc.
use Glib qw/:constants/;

sub value_changed {
  my ($self, $spin, $data) = @_;

  is ($self->{answer}, 42);
  isa_ok ($spin, 'Gtk2::SpinButton');
  isa_ok ($data, 'Gtk2::Adjustment');
}

sub wrapped {
  my ($self, $spin, $data) = @_;

  is ($self->{answer}, 42);
  isa_ok ($spin, 'Gtk2::SpinButton');
  is ($data, 'bla!');
}

my $self = bless { answer => 42 }, 'BuilderTestOO';

$builder = Gtk2::Builder->new;
$builder->add_from_string ($ui);
$builder->connect_signals ('bla!', $self);

$spin = $builder->get_object ('spinbutton1');
$spin->set_wrap (TRUE);
$spin->spin ('step-forward', 1);

# --------------------------------------------------------------------------- #

$builder = Gtk2::Builder->new;
$builder->add_from_string ($ui);
$builder->connect_signals ('!alb',
  value_changed => \&BuilderTest::value_changed,
  wrapped => \&BuilderTestCaller::wrapped
);

$spin = $builder->get_object ('spinbutton1');
$spin->set_wrap (TRUE);
$spin->spin ('step-forward', 1);

__END__

Copyright (C) 2007 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
