#!/usr/bin/perl -w
use strict;
use warnings;
use Gtk2;
use Test::More;

###############################################################################

if (Gtk2 -> init_check()) {
	plan(tests => 47);
}
else {
	plan(skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY');
}

###############################################################################

require './t/ignore_keyboard.pl';

my $model = Gtk2::TreeStore -> new("Glib::String", "Glib::Int");
isa_ok($model, "Gtk2::TreeStore");

foreach (qw(bla blee bliii bloooo)) {
	my $iter = $model -> append(undef);
	isa_ok($iter, "Gtk2::TreeIter");

	$model -> set($iter,
		      0 => $_,
		      1 => length($_));

	is($model -> get($iter, 0), $_);
	is($model -> get($iter, 1), length($_));

	is(($model -> get($iter, 0, 1))[0], $_);
	is(($model -> get($iter, 0, 1))[1], length($_));

	is($model -> get_value($iter, 0), $_);
	is($model -> get_value($iter, 1), length($_));

	#######################################################################

	foreach my $multiplier(1 .. 3) {
		my $iter_child = $model -> append($iter);

		$model -> set($iter_child,
			      0 => $_ x $multiplier,
			      1 => length($_ x $multiplier));

		my $iter_child_child = $model -> append($iter_child);

		$model -> set($iter_child_child,
			      0 => reverse($_) x $multiplier,
			      1 => length(reverse($_) x $multiplier));
	}
}

my $flags = $model -> get_flags();
is($flags -> [0], "iters-persist");
is($flags -> [1], undef);

###############################################################################

my ($path_one, $path_two);

$path_one = Gtk2::TreePath -> new("1");

SKIP: {
	skip("new_from_indices is new in 2.2.x", 1)
		unless ((Gtk2 -> get_version_info())[1] >= 2);

	$path_one = Gtk2::TreePath -> new_from_indices(1);
	is($model -> get($model -> get_iter($path_one), 0), "blee");
}

$path_one -> prepend_index(1);
is($model -> get($model -> get_iter($path_one), 0), "bleeblee");

$path_one -> append_index(0);
is($model -> get($model -> get_iter($path_one), 0), "eelbeelb");

is($path_one -> get_depth(), 3);
is(($path_one -> get_indices())[0], 1);
is(($path_one -> get_indices())[1], 1);
is(($path_one -> get_indices())[2], 0);

$path_two = Gtk2::TreePath -> new("1:1");

$path_two -> down();
is($path_two -> to_string(), "1:1:0");

$path_two -> up();
is($path_two -> to_string(), "1:1");

is($path_two -> is_ancestor($path_one), 1);
is($path_one -> is_descendant($path_two), 1);

###############################################################################

my ($iter_one, $iter_two);

$iter_one = $model -> get_iter(Gtk2::TreePath -> new("2:2"));

$iter_two = $model -> iter_parent($iter_one);
is($model -> get($iter_two, 0), "bliii");

is($model -> iter_has_child($iter_two), 1);
is($model -> iter_n_children($iter_two), 3);

$iter_one = $model -> iter_nth_child($iter_two, 1);
is($model -> get($iter_one, 0), "bliiibliii");

$iter_two = $model -> iter_children($iter_one);
is($model -> get($iter_two, 0), "iiilbiiilb");

###############################################################################

Glib::Idle -> add(sub {
	Gtk2 -> main_quit();
	return 0;
});

Gtk2 -> main();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
