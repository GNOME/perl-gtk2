#
# $Header$
#

#########################
# GtkAccelGroup Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 11;

my $win = Gtk2::Window->new;

ok (my $accel = Gtk2::AccelGroup->new, 'Gtk2::AccelGrop->new');

sub conn_func
{
	ok (1, 'connect_func ctrl')
}

$accel->connect (42, qw/control-mask/, [], \&conn_func);

$accel->connect (42, qw/shift-mask/, 'visible',
	sub { ok (1, 'connect_func alt') });

Gtk2::AccelMap->add_entry ('<accel-map>/File/Save', 42, 'control-mask');
Gtk2::AccelMap->add_entry ('<accel-map>/File/Save As', 43, 'control-mask');
Gtk2::AccelMap->add_entry ('<accel-map>/File/Save It', 44, 'control-mask');
my $file = './t/test.accel_map';
Gtk2::AccelMap->save ($file);
Gtk2::AccelMap->load ($file);
ok (Gtk2::AccelMap->change_entry ('<accel-map>/File/Save As', 
				  45, 'control-mask', 1), 'map change_entry');
unlink ($file);

$accel->connect_by_path ('<accel-map>/File/Save It', 
	                 sub { ok (1, 'connect_by_path') });

$win->add_accel_group ($accel);
$accel->lock;

my $btn = Gtk2::Button->new;
$btn->add_accelerator ('clicked', $accel, 64, ['control-mask'], []);
ok ($btn->remove_accelerator ($accel, 64, ['control-mask']), 
	'$btn->add_accelerator|$widget->remove_accelerator');
$btn->set_accel_path ('<accel-map>/File/Save It', $accel);
ok ($btn->remove_accelerator ($accel, 44, ['control-mask']), 
	'$btn->set_accel_path|$widget->remove_accelerator');

is (Gtk2::AccelGroups->from_object ($win), $accel,
	'Gtk2->accel_groups_from_object');

Gtk2::AccelGroups->activate ($win, 42, qw/control-mask/);
Gtk2::AccelGroups->activate ($win, 42, qw/shift-mask/);
Gtk2::AccelGroups->activate ($win, 44, qw/control-mask/);

$accel->unlock;

ok ($accel->disconnect_key (42, qw/shift-mask/),
	'disconnect_key shift-mask');
ok ($accel->disconnect (\&conn_func), 'disconnect conn_func');
SKIP: {
	# TODO: when this is fixed, test for version
	skip 'disconnect_key from empty group, bug in gtk+', 1
		unless (Gtk2->get_version_info)[1] >= 4;
	ok (not ($accel->disconnect_key (42, qw/shift-mask/)),
		'second disconnect_key shift-mask should fail');
}

1;

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list) See LICENSE for more information.