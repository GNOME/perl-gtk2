use Test::More;
use Gtk2;

if (!Gtk2->init_check) {
	plan skip_all => 'no display, nothing to test';
} else {
	plan tests => 12;
}


# we can't instantiate Gtk2::Widget, it's abstract.  use a DrawingArea instead.

$widget = Gtk2::Widget->new (Gtk2::DrawingArea::, name => 'test widget');

isa_ok( $widget, Gtk2::Widget::, 'we can create widgets' );

$name = $widget->get ('name');
print "name $name\n";

is( $widget->get ('name'), 'test widget', 'constructor properties work' );

#
# widget flags stuff
# there are two ways to retrieve flags and two ways to set them; compare
# both, to ensure that they are always in sync.
#

$flags = $widget->get_flags;
print "flags $flags\n";

$widget->set_flags (['can-focus', 'app-paintable']);

$flags = $widget->get_flags;

ok( $flags >= 'can-focus', 'we set flags successfully' );
ok( $widget->can_focus, 'we can read flags correctly' );
ok( $widget->get ('can-focus'), 'this one also has a property, value match?' );

$widget->can_focus (0);

$flags = $widget->get_flags;

ok( !($flags & 'can-focus') );
ok( !$widget->can_focus );
ok( !$widget->get ('can-focus') );

$widget->unset_flags (['app-paintable', 'sensitive']);

# alternate syntax for get_flags
$flags = $widget->flags;
ok( !($flags & 'app-paintable') );
ok( !($flags & 'sensitive') );
ok( !$widget->app_paintable );
ok( !$widget->sensitive );

print "flags $flags\n";


$widget->destroy;
