#
# $Header$
#

use strict;
use warnings;

#########################
# GtkWindow Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 85;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

use constant TRUE => 1;
use constant FALSE => 0;

ok( my $win = Gtk2::Window->new );
ok( $win = Gtk2::Window->new('popup') );
ok( $win = Gtk2::Window->new('toplevel') );

$win->set_title;
ok(1);
$win->set_title('');
ok(1);
$win->set_title('Test Window');
ok(1);

is( $win->get_title, 'Test Window' );

$win->set_resizable(TRUE);
ok(1);

ok( $win->get_resizable );

$win->set_modal(TRUE);
ok(1);

ok( $win->get_modal );

$win->set_default_size(640, 480);
ok(1);

# the window manager needn't honor our request, but the
# widget should be holding the values and the bindings
# should return them correctly.
my @s = $win->get_default_size;
ok( $s[0] == 640 && $s[1] == 480 );

#$win->set_geometry_hints(...);

foreach (qw/north-west north north-east west center east
	    south-west south south-east static/)
{
	$win->set_gravity($_);
	ok(1);

	is( $win->get_gravity , $_, "gravity $_" );
}

foreach (qw/none center mouse center-always center-on-parent/)
{
	$win->set_position($_);
	ok(1, "set_position $_");
}
# i don't think this does what we think it does
$win->get_position;
ok(1);

ok( my $win2 = Gtk2::Window->new );

$win2->set_transient_for($win);
ok(1);

is( $win2->get_transient_for, $win );

$win2->set_destroy_with_parent(TRUE);
ok(1);

ok( $win2->get_destroy_with_parent );

my @toplvls = Gtk2::Window->list_toplevels;
is(scalar(@toplvls), 4);

$win2->set_decorated(TRUE);
ok(1);
ok( $win2->get_decorated );

$win2->set_has_frame(FALSE);
ok(1);

ok( !$win2->get_has_frame );

$win2->set_role('tool');
ok(1);

is( $win2->get_role, 'tool' );

foreach (qw/normal dialog menu toolbar/)
{
	$win2->set_type_hint($_);
	ok(1);

	is( $win2->get_type_hint, $_ );
}

SKIP: {
	skip 'stuff missing in 2.0.x', 6
		unless (Gtk2->get_version_info)[1] >= 2;

	foreach (qw/splashscreen utility dock desktop/)
	{
		$win2->set_type_hint($_);

		is( $win2->get_type_hint, $_ );
	}

	SKIP: {
		skip 'taskbar stuff missing on windows', 1
			if $^O eq 'MSWin32';

		$win2->set_skip_taskbar_hint('true');

		ok( $win2->get_skip_taskbar_hint );
	}

	$win2->set_skip_pager_hint('true');

	ok( $win2->get_skip_pager_hint );
}

ok( ! $win->get_default_icon_list );

# need pixbufs
#$win->set_default_icon_list(...)

# need file
#$win->set_default_icon_from_file(...)

# need a pixbuf
#$win->set_icon($pixbuf);

# doesn't have an icon ^
ok( ! $win->get_icon );

# doesn't have an icon ^
ok( ! $win->get_icon_list );

Glib::Idle->add(sub {
		$win2->show;

		# there are no widgets, so this should fail
		ok( ! $win->activate_focus );

		# there are no widgets, so this should fail
		ok( ! $win->activate_default );

		# there are no widgets, so this should fail
		ok( ! $win->get_focus );

		$win->present;
		ok(1);

		$win->iconify;
		ok(1);

		# doesnt work no error message
		$win->deiconify;
		ok(1);

		$win->stick;
		ok(1);

		$win->unstick;
		ok(1);

		# doesnt work no error message
		$win->maximize;
		ok(1);

		# doesnt work no error message
		$win->unmaximize;
		ok(1);

		# gtk2.2 req
		SKIP: {
			my $reason;
			if ($^O eq 'MSWin32') {
				$reason = 'GdkScreen not available on win32';
			} elsif ((Gtk2->get_version_info)[1] < 2) {
				$reason = 'stuff not available before 2.2.x';
			} else {
				$reason = undef;
			}

			skip $reason, 1 if defined $reason;

			# $win->set_screen(...)
			ok( $win->get_screen );

			$win->fullscreen;
			$win->unfullscreen;
		}

		$win->move(100, 100);

		$win->resize(480,600);

		# window managers don't horor our size request exactly,
		# or at least we aren't guaranteed they will
		ok( $win->get_size );
		ok( $win->get_frame_dimensions );

		$win2->reshow_with_initial_size;
		ok(1);

		Gtk2->main_quit;
		ok(1);
		0;
	});


$win->set_frame_dimensions(0, 0, 300, 500);

$win->show;
ok(1);

Gtk2->main;
ok(1);
