#
# $Header$
#

#########################
# GtkRecentManager Tests
# 	- ebassi
#########################

#########################

use strict;
use warnings;

use Gtk2::TestHelper tests => 14,
    at_least_version => [2, 10, 0, "GtkRecentManager is new in 2.10"],
    ;

isa_ok(Gtk2::RecentManager->get_default, 'Gtk2::RecentManager',
       'check get_default');

our $manager = Gtk2::RecentManager->get_default;

# use this silly trick to get a file
my $icon_theme = Gtk2::IconTheme->get_default;
my $icon_info  = $icon_theme->lookup_icon('stock_edit', 24, 'use-builtin');

SKIP: {
	skip "add_item; theme icon not found", 13
		unless defined $icon_info;
	
	my $icon_file = $icon_info->get_filename;
	my $icon_uri  = 'file://' . $icon_file;

	$manager->add_item($icon_uri);
	ok($manager->has_item($icon_uri), 'check add item');
	
	$manager->add_full($icon_uri, {
			   display_name => 'Stock edit',
			   description  => 'GTK+ stock icon for edit',
			   mime_type    => 'image/png',
			   app_name     => 'Eog',
			   app_exec     => 'eog %u',
			   is_private   => 1,
		});
	ok($manager->has_item($icon_uri), 'check add full');

	my $recent_info = $manager->lookup_item($icon_uri);
	isa_ok($recent_info, 'Gtk2::RecentInfo', 'check recent_info');

	is($recent_info->get_uri,          $icon_uri,                  'check URI' );
	is($recent_info->get_display_name, 'Stock edit',               'check name');
	is($recent_info->get_description,  'GTK+ stock icon for edit', 'check description');
	is($recent_info->get_mime_type,    'image/png',                'check MIME');
	
	ok($recent_info->has_application('Eog'),         'check app/1');
	ok(!$recent_info->has_application('Dummy Test'), 'check app/2');

	ok($recent_info->is_local, 'check is local');
	
	my @app_info = $recent_info->get_application_info('Eog');
	is(@app_info, 3, 'check app info');

	my ($exec, $count, $stamp) = @app_info;
	is($exec, 'eog ' . $icon_uri, 'check exec');

	$manager->remove_item($icon_uri);
	ok(!$manager->has_item($icon_uri), 'check remove item');
}

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
