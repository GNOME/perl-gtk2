#
# $Header$
#

#########################
# GtkSimpleList Tests
# 	- rm
#########################



#########################

use Gtk2;;

use Test::More tests => 28;
BEGIN { use_ok('Gtk2::SimpleList') };

#########################

ok( Gtk2->init );

my $win = Gtk2::Window->new;
$win->set_title('19.GtkSimpleList.t test');
$win->set_default_size(450, 350);

my $vb = Gtk2::VBox->new(0, 6);
$win->add($vb);

my $sw = Gtk2::ScrolledWindow->new;
$sw->set_policy (qw/automatic automatic/);
$vb->pack_start($sw, 1, 1, 0);

ok( my $list = Gtk2::SimpleList->new(
			'Text Field'    => 'text',
			'Int Field'     => 'int',
			'Double Field'  => 'double',
			'Bool Field'    => 'bool',
			'Pixbuf Field'  => 'pixbuf',
		) );
$sw->add($list);

my $quitbtn = Gtk2::Button->new_from_stock('gtk-quit');
$quitbtn->signal_connect( clicked => sub { Gtk2->main_quit; 1 } );
$vb->pack_start($quitbtn, 0, 0, 0);

# begin exercise of SimpleList

# this could easily fail, so we'll catch and work around it
my $filename = "./gtk-demo/gtk-logo-rgb.gif";
my $pixbuf;
eval { $pixbuf = Gtk2::Gdk::Pixbuf->new_from_file ($filename); };
if( $@ )
{
	$pixbuf = undef;
}

@{$list->{data}} = (
	[ 'one', 1, 1.1, 1, $pixbuf ],
	[ 'two', 2, 2.2, 0, undef ],
	[ 'three', 3, 3.3, 1, undef ],
	[ 'four', 4, 4.4, 0, undef ],
);
ok( scalar(@{$list->{data}}) == 4 );

ok( $list->signal_connect( row_activated => sub
	{
		print STDERR "row_activated: @_";
		1;
	} ) );

my $count = 0;
Glib::Idle->add( sub
	{
		my $ldata = $list->{data};
		
		ok( scalar(@$ldata) == 4 );

		# test the initial values we put in there
		ok(
			$ldata->[0][0] eq 'one' and
			$ldata->[1][0] eq 'two' and
			$ldata->[2][0] eq 'three' and
			$ldata->[3][0] eq 'four' and
			$ldata->[0][1] == 1 and
			$ldata->[1][1] == 2 and
			$ldata->[2][1] == 3 and
			$ldata->[3][1] == 4 and
			$ldata->[0][2] == 1.1 and
			$ldata->[1][2] == 2.2 and
			$ldata->[2][2] == 3.3 and
			$ldata->[3][2] == 4.4 and
			$ldata->[0][3] == 1 and
			$ldata->[1][3] == 0 and
			$ldata->[2][3] == 1 and
			$ldata->[3][3] == 0 and
			$ldata->[0][4] == $pixbuf
		);
		
		push @$ldata, [ 'pushed', 1, 0.1, undef ];
		ok( scalar(@$ldata) == 5 );
		push @$ldata, [ 'pushed', 2, 0.2, undef ];
		ok( scalar(@$ldata) == 6 );
		push @$ldata, [ 'pushed', 3, 0.3, undef ];
		ok( scalar(@$ldata) == 7 );

		pop @$ldata;
		ok( scalar(@$ldata) == 6 );
		pop @$ldata;
		ok( scalar(@$ldata) == 5 );
		pop @$ldata;
		ok( scalar(@$ldata) == 4 );

		unshift @$ldata, [ 'unshifted', 1, 0.1, undef ];
		ok( scalar(@$ldata) == 5 );
		unshift @$ldata, [ 'unshifted', 2, 0.2, undef ];
		ok( scalar(@$ldata) == 6 );
		unshift @$ldata, [ 'unshifted', 3, 0.3, undef ];
		ok( scalar(@$ldata) == 7 );

		shift @$ldata;
		ok( scalar(@$ldata) == 6 );
		shift @$ldata;
		ok( scalar(@$ldata) == 5 );
		shift @$ldata;
		ok( scalar(@$ldata) == 4 );

		# make sure we're back to the initial values we put in there
		ok(
			$ldata->[0][0] eq 'one' and
			$ldata->[1][0] eq 'two' and
			$ldata->[2][0] eq 'three' and
			$ldata->[3][0] eq 'four' and
			$ldata->[0][1] == 1 and
			$ldata->[1][1] == 2 and
			$ldata->[2][1] == 3 and
			$ldata->[3][1] == 4 and
			$ldata->[0][2] == 1.1 and
			$ldata->[1][2] == 2.2 and
			$ldata->[2][2] == 3.3 and
			$ldata->[3][2] == 4.4 and
			$ldata->[0][3] == 1 and
			$ldata->[1][3] == 0 and
			$ldata->[2][3] == 1 and
			$ldata->[3][3] == 0
		);

		$ldata->[1][0] = 'getting deleted';
		ok( $ldata->[1][0] eq 'getting deleted' );

		$ldata->[1] = [ 'right now', -1, -1.1, 1, undef ];
		ok(
			$ldata->[1][0] eq 'right now' and
			$ldata->[1][1] == -1 and
			$ldata->[1][2] == -1.1 and
			$ldata->[1][3] == 1
	       	);

		$ldata->[1] = 'bye';
		ok( $ldata->[1][0] eq 'bye' );

		delete $ldata->[1];
		ok( scalar(@$ldata) == 3 );

		ok( exists($ldata->[0]) );
		ok( exists($ldata->[0][0]) );

		@{$list->{data}} = ();
		ok( scalar(@$ldata) == 0 );

		Gtk2->main_quit;
		return 0;
	} );

# end exercise of SimpleList

$win->show_all;

Gtk2->main;
ok(1);
