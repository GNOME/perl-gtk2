#
# $Header$
#

#########################
# GtkRadioButton Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 9;

ok( my $vbox = Gtk2::VBox->new(0, 5) );
# $win->add($vbox);

my $rdobtn;
ok( $rdobtn = Gtk2::RadioButton->new() );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new_from_widget($rdobtn) );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new_from_widget($rdobtn, "label") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new(undef, "foo") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new($rdobtn, "bar") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new([ $rdobtn ], "bar2") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( scalar(@{$rdobtn->get_group}) == 3 );

my $i;
my @rdobtns;
for( $i = 0; $i < 5; $i++ )
{
	$rdobtns[$i] = Gtk2::RadioButton->new(\@rdobtns, $i);
	$vbox->pack_start($rdobtns[$i], 0, 0, 0);
}

ok( scalar(@{$rdobtns[0]->get_group}) == 5 );

1;

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
