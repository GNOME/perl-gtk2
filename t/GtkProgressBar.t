#
# $Header$
#

#########################
# GtkProgressBar Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 26, noinit => 1;

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
full list).  See LICENSE for more information.
