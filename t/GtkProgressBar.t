#
# $Header$
#

#########################
# GtkProgressBar Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 26;

ok( my $vbox = Gtk2::VBox->new( 0, 5 ) );

my @ori = qw/left-to-right right-to-left top-to-bottom bottom-to-top/;

my @prog;
foreach (@ori)
{
	ok( my $prog = Gtk2::ProgressBar->new );
	$vbox->pack_start($prog, 0, 0, 0);

	$prog->set_orientation($_);
	is( $prog->get_orientation, $_ );

	push @prog, $prog;
}

foreach (@prog)
{
	$_->pulse;
	ok(1);

	$_->set_fraction(0.23);
	is( $_->get_fraction, 0.23 );

	$_->set_text("Bla");
	is( $_->get_text, "Bla" );

	$_->set_pulse_step(0.42);
	is( $_->get_pulse_step, 0.42 );
}

ok(1);

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
