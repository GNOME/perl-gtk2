#!/usr/bin/perl -w
# vim: set ft=perl :

use strict;
use Gtk2::TestHelper
  tests => 21,
  at_least_version => [2, 10, 0, "GtkLinkButton is new in 2.10"];

my $button;

my $url = "http://google.com/";

$button = Gtk2::LinkButton->new ($url);
isa_ok ($button, 'Gtk2::LinkButton');
isa_ok ($button, 'Gtk2::Button');
is ($button->get_uri, $url);
is ($button->get_label, $url);  # interesting

$button = Gtk2::LinkButton->new ($url, "a label");
isa_ok ($button, 'Gtk2::LinkButton');
isa_ok ($button, 'Gtk2::Button');
is ($button->get_uri, $url);
is ($button->get_label, "a label");

$button = Gtk2::LinkButton->new_with_label ($url, "a label");
isa_ok ($button, 'Gtk2::LinkButton');
isa_ok ($button, 'Gtk2::Button');
is ($button->get_uri, $url);
is ($button->get_label, "a label");

# this also works...
$button = Gtk2::LinkButton->new_with_label ($url);
isa_ok ($button, 'Gtk2::LinkButton');
isa_ok ($button, 'Gtk2::Button');
is ($button->get_uri, $url);
is ($button->get_label, $url);  # interesting

$url = "http://www.gnome.org/";
$button->set_uri ($url);
is ($button->get_uri, $url);

sub hook {
	my ($widget, $link, $data) = @_;
	is ($widget, $button);
	is ($link, $url);
	isa_ok ($data, 'HASH');
	is ($data->{whee}, "woo hoo");
}

$button->set_uri_hook (\&hook, { whee => "woo hoo" });
$button->clicked;

$button->set_uri_hook (undef);
