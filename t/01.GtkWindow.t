#
# $Header$
#

#########################
# GtkWindow Tests
# 	- rm
#########################

#########################

use Test::More tests => 95;
BEGIN { use_ok('Gtk2') };

#########################

ok( Gtk2->init );

ok( $win = Gtk2::Window->new );
ok( $win = Gtk2::Window->new('popup') );
ok( $win = Gtk2::Window->new('toplevel') );

$win->set_title;
ok(1);
$win->set_title('');
ok(1);
$win->set_title('Test Window');
ok(1);

ok( $win->get_title eq 'Test Window' );

$win->set_resizable('true');
ok(1);

ok( $win->get_resizable );

$win->set_modal('true');
ok(1);

ok( $win->get_modal );

$win->set_default_size(640, 480);
ok(1);

ok( $win->get_default_size );

#$win->set_geometry_hints(...);

foreach (qw/north-west north north-east west center east 
	    south-west south south-east static/)
{
	$win->set_gravity($_);
	ok(1);
	
	ok( $win->get_gravity eq $_ );
}

foreach (qw/none center mouse center-always center-on-parent/)
{
	$win->set_position($_);
	ok(1);
}
$win->get_position;
ok(1);

ok( $win2 = Gtk2::Window->new );

$win2->set_transient_for($win);
ok(1);

ok( $win2->get_transient_for == $win );

$win2->set_destroy_with_parent('true');
ok(1);

ok( $win2->get_destroy_with_parent );

@toplvls = Gtk2::Window->list_toplevels;
ok(scalar(@toplvls) == 4);

$win2->set_decorated('true');
ok(1);
ok( $win2->get_decorated );

$win2->set_has_frame('false');
ok(1);

# i set it false ^ but it's true here?
ok( $win2->get_has_frame );

$win2->set_role('tool');
ok(1);

ok( $win2->get_role eq 'tool' );

foreach (qw/normal dialog menu toolbar splashscreen utility dock desktop/)
{
	$win2->set_type_hint($_);
	ok(1);

	ok( $win2->get_type_hint eq $_ );
}

$win2->set_skip_taskbar_hint('true');
ok(1);

ok( $win2->get_skip_taskbar_hint );

$win2->set_skip_pager_hint('true');
ok(1);

ok( $win2->get_skip_pager_hint );

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

		# $win->set_screen(...)
		ok( $win->get_screen ) if( (Gtk2->get_version_info)[1] >= 2 );

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
		if( (Gtk2->get_version_info)[1] >= 2 )
		{
			$win->fullscreen;
			ok(1);
			$win->unfullscreen;
			ok(1);
		}

		$win->move(100, 100);

		$win->resize(480,600);

		ok( eq_array( [ $win->get_size ], [ 640, 480 ] ) );

		ok( eq_array( [ $win->get_frame_dimensions ],
			[ 0, 0, 300, 500 ] ) );

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
