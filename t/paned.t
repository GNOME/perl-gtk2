use Test::More;
use Gtk2;

if (Gtk2->init_check) {
	plan tests => 54;
} else {
	plan skip_all => 'no display, nothing to do';
}

use constant TRUE => 1;
use constant FALSE => 0;

my $window = Gtk2::Window->new;
my $hpaned = Gtk2::HPaned->new;
my $vpaned = Gtk2::VPaned->new;

my $hframe = Gtk2::Frame->new;
my $vframe1 = Gtk2::Frame->new;
my $vframe2 = Gtk2::Frame->new;

$hframe->modify_bg ('normal', Gtk2::Gdk::Color->parse ('red'));
$vframe1->modify_bg ('normal', Gtk2::Gdk::Color->parse ('green'));
$vframe2->modify_bg ('normal', Gtk2::Gdk::Color->parse ('blue'));


$window->add ($hpaned);

$hpaned->add ($hframe);
$hpaned->pack2 ($vpaned, TRUE, FALSE);

$vpaned->pack1 ($vframe1, TRUE, FALSE);
$vpaned->pack2 ($vframe2, FALSE, FALSE);

print "hpaned 1 -> ".$hpaned->child1_resize."\n";
print "hpaned 2 -> ".$hpaned->child2_resize."\n";
print "vpaned 1 -> ".$vpaned->child1_resize."\n";
print "vpaned 2 -> ".$vpaned->child2_resize."\n";

$window->show_all;

$hframe->set_size_request (50,50);
$vframe1->set_size_request (50,50);
$vframe2->set_size_request (50,50);

@windowprops = (
	[ FALSE,  TRUE,   TRUE, FALSE,  300, 400 ],
	[ FALSE,  TRUE,   TRUE, FALSE,  400, 300 ],
	[ FALSE, FALSE,  FALSE, FALSE,  106, 106 ],
	[ FALSE, FALSE,  FALSE, FALSE,  300, 400 ],
	[ FALSE, FALSE,  FALSE, FALSE,  400, 300 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  106, 106 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  300, 400 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  400, 300 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  106, 106 ],
);
@framesizes = (
	[   4,  14,    4,   4,    4,   4 ],
	[  50, 400,  244, 344,  244,  50 ],
	[  50, 300,  344, 244,  344,  50 ],
	[  50, 106,   50,  50,   50,  50 ],
	[ 147, 400,  147, 197,  147, 197 ],
	[ 197, 300,  197, 147,  197, 147 ],
	[  50, 106,   50,  50,   50,  50 ],
	[ 244, 400,   50,  50,   50, 344 ],
	[ 344, 300,   50,  50,   50, 244 ],
	[  50, 106,   50,  50,   50,  50 ],
);
use Data::Dumper;

$i;

Glib::Timeout->add (100, sub {
#Glib::Timeout->add (1000, sub {
	my ($w, $h);
	my $this;

	$this = shift @framesizes;

	if ($i++) {
		# don't validate the first wave -- the window probably
		# hasn't had time to get properly sized.
		($w, $h) = sizeof ($hframe);
		is ($w, $this->[0]);
		is ($h, $this->[1]);
		@foo = ($w, $h);

		($w, $h) = sizeof ($vframe1);
		is ($w, $this->[2]);
		is ($h, $this->[3]);
		push @foo, $w, $h;

		($w, $h) = sizeof ($vframe2);
		is ($w, $this->[4]);
		is ($h, $this->[5]);
		push @foo, $w, $h;
		print join(" ", "[", @foo, "]\n");
	}

	$this = shift @windowprops;
	if ($this) {
		$hpaned->child1_resize ($this->[0]);
		$hpaned->child2_resize ($this->[1]);
		$vpaned->child1_resize ($this->[2]);
		$vpaned->child2_resize ($this->[3]);
		$window->resize ($this->[4], $this->[5]);
		1;
	} else {
		Gtk2->main_quit;
	}
});


Gtk2->main;

sub sizeof {
	my $allocation = shift->allocation;
	return ($allocation->width, $allocation->height);
}
