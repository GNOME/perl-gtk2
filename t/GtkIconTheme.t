#
# $Header$
#

use Gtk2::TestHelper
	# FIXME 2.4
	at_least_version => [2, 3, 0, "GtkIconTheme is new in 2.4"],
	tests => 15;

my $icon_theme = Gtk2::IconTheme->new;
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme = Gtk2::IconTheme->get_default;
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme = Gtk2::IconTheme->get_for_screen (Gtk2::Gdk::Screen->get_default);
isa_ok ($icon_theme, 'Gtk2::IconTheme');

$icon_theme->set_screen (Gtk2::Gdk::Screen->get_default);

ok ($icon_theme->list_icons (undef));

SKIP: {
	skip "the search path api was broken prior to 2.3.3", 3
		if Gtk2->check_version(2, 3, 3);
	
	my @paths = qw(/tmp /etc /home);
	$icon_theme->set_search_path (@paths);
	
	is_deeply ([$icon_theme->get_search_path], \@paths);
	
	$icon_theme->append_search_path ('/usr/local/tmp');
	push @paths, '/usr/local/tmp';
	is_deeply ([$icon_theme->get_search_path], \@paths);
	
	$icon_theme->prepend_search_path ('/usr/tmp');
	unshift @paths, '/usr/tmp';
	is_deeply ([$icon_theme->get_search_path], \@paths);
}

ok (!$icon_theme->has_icon ('gtk-open'));
ok (!$icon_theme->has_icon ('something crazy'));

my $icon_info = $icon_theme->lookup_icon ("stock_edit", 24, "use-builtin");
isa_ok ($icon_info, "Gtk2::IconInfo");

my $pixbuf = $icon_theme->load_icon ("stock_edit", 24, "use-builtin");
isa_ok ($pixbuf, "Gtk2::Gdk::Pixbuf");

is ($icon_info->get_base_size, 24);
like ($icon_info->get_filename, qr/stock_edit/);

$icon_info->set_raw_coordinates (1);

# FIXME:
# isa_ok ($icon_info->get_builtin_pixbuf, "Gtk2::Gdk::Pixbuf");
# isa_ok($icon_info->get_embedded_rect, "Gtk2::Gdk::Rectangle");
# warn $icon_info->get_attach_points;
# warn $icon_info->get_display_name;

$icon_theme->add_builtin_icon ("stock_edit", 24, $pixbuf);

# cannot call set_custom_theme on a default theme
$icon_theme = Gtk2::IconTheme->new;
$icon_theme->set_custom_theme ('crazy custom theme');

is ($icon_theme->get_example_icon_name, undef);

ok (!$icon_theme->rescan_if_needed);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
