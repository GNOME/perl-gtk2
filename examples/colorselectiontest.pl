#!/usr/bin/perl -w

#
# Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the full
# list)
# 
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
# 
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
# more details.
# 
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
#
# $Header$
#

use Gtk2;

Gtk2->init;

my @colors = (
	Gtk2::Gdk::Color->new (0,0,0),
	Gtk2::Gdk::Color->new (65535,0,0),
	Gtk2::Gdk::Color->new (0,65535,0),
	Gtk2::Gdk::Color->new (0,0,65535),
	Gtk2::Gdk::Color->new (65535,65535,65535),
);

my $string = Gtk2::ColorSelection->palette_to_string (@colors);
@colors = Gtk2::ColorSelection->palette_from_string ($string);

use Data::Dumper;
print "$string\n" . Dumper (\@colors)."\n";
