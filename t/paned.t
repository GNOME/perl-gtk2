
use Gtk2::TestHelper tests => 55;

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

$vpaned->add1 ($vframe1);
$vpaned->add2 ($vframe2);

$vpaned->remove ($vframe1);
$vpaned->remove ($vframe2);

$vpaned->pack1 ($vframe1, TRUE, FALSE);
$vpaned->pack2 ($vframe2, FALSE, FALSE);

$vpaned->set_position (23);
is ($vpaned->get_position, 23);

print "hpaned 1 -> ".$hpaned->child1_resize."\n";
print "hpaned 2 -> ".$hpaned->child2_resize."\n";
print "vpaned 1 -> ".$vpaned->child1_resize."\n";
print "vpaned 2 -> ".$vpaned->child2_resize."\n";

$window->show_all;

$hframe->set_size_request (50,50);
$vframe1->set_size_request (50,50);
$vframe2->set_size_request (50,50);

my $pad;
if ((Gtk2->get_version_info)[1] < 2) {
	# crap.  we didn't have a way to query style property information
	# until 2.2, so we can't implement gtk_wigdet_style_get () here.
	# we have to improvise.
	Glib::Timeout->add (100, sub { Gtk2->main_quit; 0 });
	Gtk2->main;
	$pad = $window->allocation->height
	     - $vframe1->allocation->height
	     - $vframe2->allocation->height;
} else {
	$pad = $hpaned->style_get ('handle-size');
}
print "handle-size $pad\n";

my @windowprops = (
	[ FALSE,  TRUE,   TRUE, FALSE,  300, 400 ],
	[ FALSE,  TRUE,   TRUE, FALSE,  400, 300 ],
	[ FALSE, FALSE,  FALSE, FALSE,  100, 100 ],
	[ FALSE, FALSE,  FALSE, FALSE,  300, 400 ],
	[ FALSE, FALSE,  FALSE, FALSE,  400, 300 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  100, 100 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  300, 400 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  400, 300 ],
	[  TRUE, FALSE,  FALSE,  TRUE,  100, 100 ],
);
my @framesizes = (
	[   4,   8+$pad,    4,   4,    4,   4 ],
	[  50, 400+$pad,  250, 350,  250,  50 ],
	[  50, 300+$pad,  350, 250,  350,  50 ],
	[  50, 100+$pad,   50,  50,   50,  50 ],
	[ 150, 400+$pad,  150, 200,  150, 200 ],
	[ 200, 300+$pad,  200, 150,  200, 150 ],
	[  50, 100+$pad,   50,  50,   50,  50 ],
	[ 250, 400+$pad,   50,  50,   50, 350 ],
	[ 350, 300+$pad,   50,  50,   50, 250 ],
	[  50, 100+$pad,   50,  50,   50,  50 ],
);
use Data::Dumper;

my $i = 0;

$window->signal_connect (size_allocate => sub {
	my ($w, $h);
	my $this;

	$this = shift @framesizes;

	if ($i++) {
		# don't validate the first wave -- the window probably
		# hasn't had time to get properly sized.
		($w, $h) = sizeof ($hframe);
		is ($w, $this->[0]);
		is ($h, $this->[1]);
		my @foo = ($w, $h);

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
		$window->resize ($this->[4] + $pad, $this->[5] + $pad);
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
