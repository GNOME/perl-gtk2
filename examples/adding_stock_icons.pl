#!/usr/bin/perl

#
# Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the full
# list, See LICENSE for full terms.)
# 
# -rm
# 
# $Header$
#

use strict;
use warnings;

use Gtk2 '-init';

# this image was yanked from a gnome icon, and then modified, the P. this is
# only an example of an inline image, the pixbuf data could come from anywhere
# prehaps more likely a file using new_from_file
my $letter_portrait = [
                '48 48 9 1',
                ' 	c None',
                '.	c #808080',
                '+	c #FFFFFF',
                '@	c #000000',
                '#	c #E21818',
                '$	c #C0C0C0',
                '%	c #0000FF',
                '&	c #000080',
                '*	c #00FFFF',
                '      ...........................               ',
                '      .+++++++++++++++++++++++++.@              ',
                '      .+++++++++++++++++++++++++..@             ',
                '      .+++###########+++++++++++.$.@            ',
                '      .+++############%&%&%&%+++.+$.@           ',
                '      .+++#############+++++++++.++$.@          ',
                '      .+++####+++++#####++++++++.+++$.@         ',
                '      .+++####&%&%&%####&%&%%+++.++++$.@        ',
                '      .+++####++++++####++++++++.+++++$.@       ',
                '      .+++####++++++####++++++++.++++++$.@      ',
                '      .+++####%&%&%#####%&%&%+++.+++++++$.@     ',
                '      .+++#############+++++++++@@@@@@@@@@@@    ',
                '      .+++############+++++++++++..........@    ',
                '      .+++###########%&%&%&%&+++++$$$$$$$$$@    ',
                '      .+++####++++++++++++++++++++++++++++$@    ',
                '      .+++####++++++++++++++++++++++++++++$@    ',
                '      .+++####%&%&%&%&%&%&%&%&%&%&%&%&%+++$@    ',
                '      .+++####++++++++++++++++++++++++++++$@    ',
                '      .+++####++++++++++++++++++++++++++++$@    ',
                '      .+++####&%&%&%&%&%&%&%&%&%&%&%&%&+++$@    ',
                '      .+++####++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++%&%&%&%&%&%&%&++.............+++$@    ',
                '      .+++++++++++++++++++.$$*******$$.+++$@    ',
                '      .+++++++++++++++++++.$$$+$+$+$$$.+++$@    ',
                '      .+++&%&%&%&%&%&%&%++.*$+$+$+$+$*.+++$@    ',
                '      .+++++++++++++++++++.*+$+$+$+$+*.+++$@    ',
                '      .+++++++++++++++++++.*$+$+$+$+$*.+++$@    ',
                '      .+++%&%&%&%&%&%&%&++.*+$+$+$+$+*.+++$@    ',
                '      .+++++++++++++++++++.*$+$+$+$+$*.+++$@    ',
                '      .+++++++++++++++++++.*+$+$+$+$+*.+++$@    ',
                '      .+++&%&%&%&%&%&%&%++.*$+$+$+$+$*.+++$@    ',
                '      .+++++++++++++++++++.$$$+$+$+$$$.+++$@    ',
                '      .+++++++++++++++++++.$$*******$$.+++$@    ',
                '      .+++%&%&%&%&%&%&%&++.............+++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++&%&%&%&%&%&%&%&%&%&%&%&%&%&%&+++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++%&%&%&%&%&%&%&%&%&%&%&++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .+++++++++++++++++++++++++++++++++++$@    ',
                '      .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@    ',
                '      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    '
              ];


# the stock id our stock item will be accessed with
my $stock_id = 'letter-portrait';

# add the stock item
Gtk2::Stock->add ({
		stock_id => $stock_id,
		label    => '_Letter Portrait',
		modifier => [],
		keyval   => 0x04c,
		translation_domain => 'gtk2-perl-example',
	});

# create an icon set, with only 1 memeber in this particular case
my $icon_set = Gtk2::IconSet->new_from_pixbuf (
		Gtk2::Gdk::Pixbuf->new_from_xpm_data (@$letter_portrait));

# create a new icon factory.
my $icon_factory = Gtk2::IconFactory->new;
# add this stock icon to it (assiciated with our stock id)
$icon_factory->add ($stock_id, $icon_set);
# add this icon_factory to the list of defaults to search for stock id's in.
$icon_factory->add_default;

# rest is just an example of using the stock icon.
my $win = Gtk2::Window->new;
$win->signal_connect (destroy => sub { Gtk2->main_quit; });

my $button = Gtk2::Button->new_from_stock ('letter-portrait');
$button->signal_connect (clicked => sub { Gtk2->main_quit; });
$win->add ($button);

$win->show_all;
Gtk2->main;

