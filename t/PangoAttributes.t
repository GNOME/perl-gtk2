#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 12;

# $Header$

#
# pango_parse_markup() 
#

my ($attr_list, $text, $accel_char) =
	Gtk2::Pango->parse_markup
		('<big>this text is <i>really</i> cool</big> (no lie)');
isa_ok ($attr_list, 'Gtk2::Pango::AttrList');
is ($text, 'this text is really cool (no lie)', 'text is stripped of tags');
ok ((not defined $accel_char), 'no accel_char if no accel_marker');

($attr_list, $text) = Gtk2::Pango->parse_markup ('no markup here');
isa_ok ($attr_list, 'Gtk2::Pango::AttrList');
is ($text, 'no markup here', 'no tags, nothing stripped');

($attr_list, $text, $accel_char) =
	Gtk2::Pango->parse_markup ('Text with _accel__chars', '_');
isa_ok ($attr_list, 'Gtk2::Pango::AttrList');
is ($text, 'Text with accel_chars');
is ($accel_char, 'a');

# invalid markup causes an exception...
eval { Gtk2::Pango->parse_markup ('<bad>invalid markup') };
isa_ok ($@, 'Glib::Error');
isa_ok ($@, 'Glib::Markup::Error');
is ($@->domain, 'g-markup-error-quark');
ok ($@->matches ('Glib::Markup::Error', 'unknown-element'),
    'invalid markup causes exceptions');


__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
