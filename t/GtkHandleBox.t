#
# $Header$
#

#########################
# GtkHandleBox Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 8;

ok( my $hb = Gtk2::HandleBox->new );

$hb->add( Gtk2::Label->new('Just a test label') );

$hb->set_shadow_type('none');
ok( $hb->get_shadow_type eq 'none' );
$hb->set_shadow_type('etched-in');
ok( $hb->get_shadow_type eq 'etched-in' );

$hb->set_snap_edge('top');
ok( $hb->get_snap_edge eq 'top' );
$hb->set_snap_edge('left');
ok( $hb->get_snap_edge eq 'left' );

$hb->set_handle_position('left');
ok( $hb->get_handle_position eq 'left' );
$hb->set_handle_position('top');
ok( $hb->get_handle_position eq 'top' );

ok( ! $hb->get_child_detached );

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