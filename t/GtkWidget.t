use Gtk2::TestHelper tests => 62;

# we can't instantiate Gtk2::Widget, it's abstract.  use a DrawingArea instead.

my $widget = Gtk2::Widget->new ('Gtk2::Button', label => 'Test');

isa_ok( $widget, Gtk2::Widget::, 'we can create widgets' );

## begin item by item check
$widget->set (name => 'foo');
is ($widget->get ('name'), 'foo', '$widget->set|get single');

$widget->set (name => 'foo', height_request => 3);
ok (eq_array ([$widget->get ('name', 'height-request')],
	      ['foo', 3]), '$widget->set|get multiple');

$widget->set_name ('bar');
is ($widget->get ('name'), 'bar', '$widget->set_name');

$widget->set_parent (Gtk2::Widget->new ('Gtk2::Window'));
is (ref $widget->get ('parent'), 'Gtk2::Window', '$widget->unparent');
# TODO: doesn't work right for some widget types
#$widget->reparent (Gtk2::Widget->new ('Gtk2::Window'));
#is (ref $widget->get ('parent'), 'Gtk2::Window', '$widget->unparent');
$widget->unparent;
is ($widget->get ('parent'), undef, '$widget->unparent');
# TODO: how
#$widget->set_parent_window (Gtk2::Widget->new ('Gtk2::Window'));

is( $widget->get_parent, $win );
is( $widget->parent, $win );

$widget->show;
ok ($widget->get ('visible'), '$widget->show');
$widget->hide;
ok ($widget->get ('visible') == 0, '$widget->hide');
$widget->show_now;
ok ($widget->get ('visible'), '$widget->show_now');
$widget->hide_all;
ok ($widget->get ('visible') == 0, '$widget->hide');
$widget->show_all;
ok ($widget->get ('visible') == 1, '$widget->hide');

# we need to parent this widget for tests below,
my $win = Gtk2::Widget->new ('Gtk2::Window');
$win->add ($widget);
print 'trying: $widget->map'."\n";
$widget->map;
print 'trying: $widget->unmap'."\n";
$widget->unmap;
print 'trying: $widget->realize;'."\n";
$widget->realize;
print 'trying: $widget->unrealize;'."\n";
$widget->unrealize;
print 'trying: $widget->queue_draw;'."\n";
$widget->queue_draw;
print 'trying: $widget->queue_resize;'."\n";
$widget->queue_resize;
print 'trying: $widget->activate;'."\n";
$widget->activate;
print 'trying: $widget->ensure_style;'."\n";
$widget->ensure_style;
print 'trying: $widget->reset_rc_styles;'."\n";
$widget->reset_rc_styles;
print 'trying: $widget->push_colormap;'."\n";
$widget->push_colormap (Gtk2::Gdk::Colormap->get_system);
print 'trying: $widget->pop_colormap;'."\n";
$widget->pop_colormap;
ok (1, '$widget->all-of-^the^-above');

is (ref $widget->size_request, 'Gtk2::Requisition', '$widget->size_request');
is (ref $widget->get_child_requisition, 'Gtk2::Requisition',
	'$widget->get_child_requisition');

# TODO: not bound
#$widget->size_allocate (100, 100);

# $widget->add_accelerator|$widget->remove_accelerator|set_accel_path,
# $btn->set_accel_path|$widget->remove_accelerator,
# tested in accel-group-map

# TODO: how
#$widget->event

ok ($widget->intersect (Gtk2::Gdk::Rectangle->new (0, 0, 10000, 10000)),
	'$widget->intersect');

# TODO: focus
#$widget->can_focus (1);
#$widget->grab_focus;
#is ($widget->has_focus, -1, '$widget->grab_focus|has_focus');

$widget->set_state ('active');
is ($widget->state, 'active', '$widget->set_state|state');

$widget->set_sensitive (0);
is ($widget->sensitive, '', '$widget->set_sensitive|sensitive false');
$widget->set_sensitive (1);
is ($widget->sensitive, 1, '$widget->set_sensitive|sensitive true');

$widget->set_events ([qw/leave-notify-mask all-events-mask/]);
is ($widget->get_events, [qw/leave-notify-mask all-events-mask/],
	'$widget->set_events|get_events');
$widget->add_events ([qw/button-press-mask/]);
is ($widget->get_events,
	[qw/button-press-mask leave-notify-mask all-events-mask/],
	'$widget->add_events|get_events');

$widget->set_extension_events ('cursor');
is ($widget->get_extension_events, 'cursor',
	'$widget->set_extension_events|get_extension_events');

is (ref $widget->get_toplevel, 'Gtk2::Window', '$widget->get_toplevel');
is (ref $widget->get_ancestor ('Gtk2::Window'), 'Gtk2::Window', 
	'$widget->get_ancestor');

$widget->set_colormap (Gtk2::Gdk::Colormap->get_system);
is (ref $widget->get_colormap, 'Gtk2::Gdk::Colormap', 
	'$widget->set_colormap|get_colormap');
$widget->set_default_colormap (Gtk2::Gdk::Colormap->get_system);
is (ref $widget->get_default_colormap, 'Gtk2::Gdk::Colormap', 
	'$widget->set_default_colormap|get_default_colormap');

is (ref $widget->get_visual, 'Gtk2::Gdk::Visual', '$widget->get_visual');

# TODO: should this be -1?
is (scalar ($widget->get_pointer), -1, '$widget->get_pointer');

is ($widget->is_ancestor (Gtk2::Window->new), '', 
	'$widget->is_ancestor, false');
is ($widget->is_ancestor ($win), 1, '$widget->is_ancestor, true');

# TODO: should this be false
is ($widget->translate_coordinates ($win, 10, 10), undef, 
	'$widget->translate_coordinates');

# TODO: comments says useless in perl
#is ($widget->hide_on_delete, -1, '$widget->hide_on_delete');

is (ref $widget->get_style, 'Gtk2::Style', '$widget->get_style');
is (ref $widget->get_default_style, 'Gtk2::Style', 
	'$widget->get_default_style');

$widget->set_direction ('rtl');
is ($widget->get_direction, 'rtl', '$widget->set_direction|get_direction, rtl');
$widget->set_direction ('ltr');
is ($widget->get_direction, 'ltr', '$widget->set_direction|get_direction, ltr');
$widget->set_default_direction ('rtl');
is ($widget->get_default_direction, 'rtl', 
	'$widget->set_default_direction|get_default_direction, rtl');
$widget->set_default_direction ('ltr');
is ($widget->get_default_direction, 'ltr', 
	'$widget->set_default_direction|get_default_direction, ltr');

Gtk2->grab_add ($widget);
is( Gtk2->grab_get_current, $widget, 'grabbing worked' );
Gtk2->grab_remove ($widget);

$widget->realize;
isa_ok( $widget->window, "Gtk2::Gdk::Window" );

## end item by item check


#
# widget flags stuff
# there are two ways to retrieve flags and two ways to set them; compare
# both, to ensure that they are always in sync.
#

$widget = Gtk2::Widget->new ('Gtk2::DrawingArea', name => 'test widget');

my $flags = $widget->get_flags;
print "flags $flags\n";

$widget->set_flags (['can-focus', 'app-paintable']);

$flags = $widget->get_flags;

ok( $flags >= 'can-focus', 'we set flags successfully' );
ok( $widget->can_focus, 'we can read flags correctly' );
ok( $widget->get ('can-focus'), 'this one also has a property, value match?' );

$widget->can_focus (0);

$flags = $widget->get_flags;

ok( !($flags & 'can-focus'), '$flags & can-focus');
ok( !$widget->can_focus, '!$widget->can_focus');
ok( !$widget->get ('can-focus'), '!$widget->get (can-focus)');

$widget->unset_flags (['app-paintable', 'sensitive']);

# alternate syntax for get_flags
$flags = $widget->flags;
ok (!($flags & 'app-paintable'), '$flags & app-paintable' );
ok (!($flags & 'sensitive'), '$flags & sensitive');
ok (!$widget->app_paintable, '$widget->app_paintable');
ok (!$widget->sensitive, '$widget->sensitive');

print "flags $flags\n";

is( $widget->allocation->x, -1 );
is( $widget->allocation->y, -1 );
is( $widget->allocation->width, 1 );
is( $widget->allocation->height, 1 );

$widget->destroy;

my $requisition = Gtk2::Requisition->new;
isa_ok( $requisition, "Gtk2::Requisition");
is( $requisition->width (5), 0 );
is( $requisition->height (5), 0 );
is( $requisition->width, 5 );
is( $requisition->height, 5 );

$requisition = Gtk2::Requisition->new (5, 5);
isa_ok( $requisition, "Gtk2::Requisition" );
is( $requisition->width, 5 );
is( $requisition->height, 5 );

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
