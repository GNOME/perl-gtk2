#
# $Header$
#

#########################
# GdkEvent Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 57;
use Data::Dumper;

# Expose #######################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('expose'), 
	'Gtk2::Gdk::Event::Expose', 'Gtk2::Gdk::Event->new expose');
	
$event->area (Gtk2::Gdk::Rectangle->new (0, 0, 100, 100));
my $rect = $event->area;
ok (eq_array ([$rect->x, $rect->y, $rect->width, $rect->height],
	      [0, 0, 100, 100]), '$expose_event->area');

$event->region (Gtk2::Gdk::Region->new);
isa_ok ($event->region, 'Gtk2::Gdk::Region', '$expose_event->region');
$event->region (undef);
is ($event->region, undef, '$expose_event->region');

$event->count (10);
is ($event->count, 10, '$expose_event->count');

# Visibility ###################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('visibility-notify'), 
	'Gtk2::Gdk::Event::Visibility', 'Gtk2::Gdk::Event->new visibility');

$event->state ('partial');
is ($event->state, 'partial', '$visibility_event->state');

# Motion #######################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('motion-notify'), 
	'Gtk2::Gdk::Event::Motion', 'Gtk2::Gdk::Event->new motion');

$event->is_hint (2);
is ($event->is_hint, 2, '$motion_event->is_hint');

# Button #######################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('button-press'), 
	'Gtk2::Gdk::Event::Button', 'Gtk2::Gdk::Event->new button');

$event->button (2);
is ($event->button, 2, '$button_event->button');

# Scroll #######################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('scroll'), 
	'Gtk2::Gdk::Event::Scroll', 'Gtk2::Gdk::Event->new scroll');

$event->direction ('down');
is ($event->direction, 'down', '$scroll_event->direction');

# Key ##########################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('key-press'), 
	'Gtk2::Gdk::Event::Key', 'Gtk2::Gdk::Event->new key');

$event->keyval (44);
is ($event->keyval, 44, '$key_event->keyval');

$event->hardware_keycode (10);
is ($event->hardware_keycode, 10, '$key_event->hardware_keycode');

$event->group (11);
is ($event->group, 11, '$key_event->group');

# Crossing #####################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('enter-notify'), 
	'Gtk2::Gdk::Event::Crossing', 'Gtk2::Gdk::Event->new crossing');

$event->subwindow (Gtk2::Gdk::Window->new (undef, {
			width => 20,
			height => 20,
			wclass => "output",
			window_type => "toplevel"
		}));
isa_ok ($event->subwindow, 'Gtk2::Gdk::Window', '$crossing_event->window');

$event->mode ('grab');
is ($event->mode, 'grab', '$crossing_event->mode');

$event->detail ('nonlinear');
is ($event->detail, 'nonlinear', '$crossing_event->detail');

$event->focus (1);
is ($event->focus, 1, '$crossing_event->focus');

# try out the base class stuff, crossing is good b/c it has most of the stuff

is ($event->time, 0, '$event->time');

is ($event->state, [], '$event->state');

ok (eq_array ([$event->coords], [0, 0]), '$event->coords');
is ($event->x, 0, '$event->x');
is ($event->y, 0, '$event->y');

ok (eq_array ([$event->get_root_coords], [0, 0]), '$event->get_root_coords');
is ($event->x_root, 0, '$event->x_root');
is ($event->y_root, 0, '$event->y_root');

#SKIP: {
#	skip "GdkScreen didn't exist until 2.2.x", 1
#		unless (Gtk2->get_version_info)[1] >= 2;
# TODO/FIXME:
#	$event->set_screen (Gtk2::Gdk::Screen->new);
#	isa_ok ($event->get_screen, 'Gtk2::Gdk::Screen', '$event->get_screen');
#}

$event->window (Gtk2::Gdk::Window->new (undef, {
			width => 20,
			height => 20,
			wclass => "output",
			window_type => "toplevel"
		}));
isa_ok ($event->window, 'Gtk2::Gdk::Window', '$event->window');

$event->send_event (3);
is ($event->send_event, 3, '$event->send_event');

# Focus ########################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('focus-change'), 
	'Gtk2::Gdk::Event::Focus', 'Gtk2::Gdk::Event->new focus');

$event->in (10);
is ($event->in, 10, '$focus_event->in');

# Configure ####################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('configure'), 
	'Gtk2::Gdk::Event::Configure', 'Gtk2::Gdk::Event->new configure');

$event->width (10);
is ($event->width, 10, '$configure_event->width');

$event->height (12);
is ($event->height, 12, '$configure_event->height');

# Property #####################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('property-notify'), 
	'Gtk2::Gdk::Event::Property', 'Gtk2::Gdk::Event->new property');

$event->state (10);
is ($event->state, 10, '$property_event->state');

$event->atom (Gtk2::Gdk::Atom->new ('foo'));
isa_ok ($event->atom, 'Gtk2::Gdk::Atom', '$property_event->atom');

# Proximity ####################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('proximity-in'), 
	'Gtk2::Gdk::Event::Proximity', 'Gtk2::Gdk::Event->new proximity');

# Client #######################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('client-event'), 
	'Gtk2::Gdk::Event::Client', 'Gtk2::Gdk::Event->new client');

$event->data_format (8);
is ($event->data_format, 8, '$client_event->data_format');

# Setting ######################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('setting'), 
	'Gtk2::Gdk::Event::Setting', 'Gtk2::Gdk::Event->new setting');

$event->action ('new');
is ($event->action, 'new', '$property_event->action');

$event->name ('a name');
is ($event->name, 'a name', '$property_event->name');

# WindowState ##################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('window-state'), 
	'Gtk2::Gdk::Event::WindowState', 'Gtk2::Gdk::Event->new windowstate');

$event->changed_mask ('maximized');
is ($event->changed_mask, 'maximized', '$property_event->changed_mask');

$event->new_window_state ('withdrawn');
is ($event->new_window_state, 'withdrawn', '$property_event->new_window_state');

# DND ##########################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('drag-enter'), 
	'Gtk2::Gdk::Event::DND', 'Gtk2::Gdk::Event->new dnd');

$event->context (Gtk2::Gdk::DragContext->new);
isa_ok ($event->context, 'Gtk2::Gdk::DragContext', '$property_event->context');

# Selection ####################################################################

isa_ok (my $event = Gtk2::Gdk::Event->new ('selection-clear'), 
	'Gtk2::Gdk::Event::Selection', 'Gtk2::Gdk::Event->new selection');

$event->selection (Gtk2::Gdk::Atom->new ('foo'));
isa_ok ($event->selection, 'Gtk2::Gdk::Atom', '$selection_event->selection');
# try setting to undef once
$event->selection (undef);
is ($event->selection, undef, '$selection_event->selection');

$event->target (Gtk2::Gdk::Atom->new ('foo'));
isa_ok ($event->target, 'Gtk2::Gdk::Atom', '$selection_event->target');

$event->property (Gtk2::Gdk::Atom->new ('foo'));
isa_ok ($event->property, 'Gtk2::Gdk::Atom', '$selection_event->property');

# TODO/FIXME: how do we come up with a GdkNativeWindow?
#$event->requestor ('');
is ($event->requestor, 0, '$selection_event->requestor');

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.

