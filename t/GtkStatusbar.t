#
# $Id$
#

use strict;
use warnings;

#########################
# GtkStatusbar Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 9, noinit => 1;

ok( my $sts = Gtk2::Statusbar->new );

$sts->set_has_resize_grip(1);
is( $sts->get_has_resize_grip, 1 );

ok( my $sts_cid1 = $sts->get_context_id('Main') );
ok( $sts->push($sts_cid1, 'Ready 1-0') );
ok( $sts->push($sts_cid1, 'Ready 1-1') );

ok( my $sts_cid2 = $sts->get_context_id('Not Main') );
ok( my $sts_mid1 = $sts->push($sts_cid2, 'Ready 2-0') );
ok( $sts->push($sts_cid2, 'Ready 2-1') );

$sts->pop($sts_cid2);
$sts->pop($sts_cid1);

$sts->pop($sts_cid2);
$sts->remove($sts_cid2, $sts_mid1);

ok(1);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
