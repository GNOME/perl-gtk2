#
# $Header$
#

#########################
# GtkBoxes Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 68;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok( $vbox = Gtk2::VBox->new(0,5) );
$win->add($vbox);

for( $r = 0; $r < 3; $r++ )
{
	ok( $hbox = Gtk2::HBox->new(0, 5), "created hbox for row $r" );
	$vbox->pack_start($hbox, 0, 0, 5);
	$hbox->set_name ("hbox $r");
	for( $c = 0; $c < 3; $c++ )
	{
		ok( $label = Gtk2::Label->new("(r,c):($r,$c)"), 'created label' );
		$hbox->pack_start($label, 0, 0, 10);

		# make sure we are where we think we are
		is( $label->get_ancestor ('Gtk2::Box'), $hbox, 'ancestry' );
		is( $label->get_ancestor ('Gtk2::VBox'), $vbox, 'ancestry' );

		# interestingly, the second string returned from this
		# appears to be reversed, rather than the objects in
		# reverse order.  how handy.  that makes the second
		# one fairly useless, but let's verify that it's there.
		($path, $htap) = $label->path;
		ok( defined($htap), 'path returned two items' );
		ok( $path =~ /hbox $r/, "'hbox $r' is in the path" );
		##print "path $path\n";

		($path, $htap) = $label->class_path;
		ok( defined($htap), 'path returned two items' );
		ok( $path !~ /hbox $r/, "'hbox $r' is not in the class path" );
		##print "class path $path\n";
	}
}

$win->show_all;

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	} );

Gtk2->main;

1;
