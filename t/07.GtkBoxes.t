#
# $Header$
#

#########################
# GtkBoxes Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 67;

ok( my $vbox = Gtk2::VBox->new(0,5) );

my ($r, $c);
for( $r = 0; $r < 3; $r++ )
{
	ok( my $hbox = Gtk2::HBox->new(0, 5), "created hbox for row $r" );
	$vbox->pack_start($hbox, 0, 0, 5);
	$hbox->set_name ("hbox $r");
	for( $c = 0; $c < 3; $c++ )
	{
		ok( my $label = Gtk2::Label->new("(r,c):($r,$c)"), 'created label' );
		$hbox->pack_start($label, 0, 0, 10);

		# make sure we are where we think we are
		is( $label->get_ancestor ('Gtk2::Box'), $hbox, 'ancestry' );
		is( $label->get_ancestor ('Gtk2::VBox'), $vbox, 'ancestry' );

		# interestingly, the second string returned from this
		# appears to be reversed, rather than the objects in
		# reverse order.  how handy.  that makes the second
		# one fairly useless, but let's verify that it's there.
		my ($path, $htap) = $label->path;
		ok( defined($htap), 'path returned two items' );
		ok( $path =~ /hbox $r/, "'hbox $r' is in the path" );
		##print "path $path\n";

		($path, $htap) = $label->class_path;
		ok( defined($htap), 'path returned two items' );
		ok( $path !~ /hbox $r/, "'hbox $r' is not in the class path" );
		##print "class path $path\n";
	}
}

1;

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
