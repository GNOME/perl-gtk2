#!/usr/bin/perl -w

use strict;
use Data::Dumper;

use Gtk2 -init;
use Gtk2::SimpleList;

# add a new type of column that reverses the text that's in a scalar
Gtk2::SimpleList->add_column_type(
	'ralacs', 	# think about it for a second...
		type     => 'Glib::Scalar',      
		renderer => 'Text',   
		attr     => sub {
			my ($tree_column, $cell, $model, $iter, $i) = @_;
			my ($info) = $model->get ($iter, $i);
			$info = join('',reverse(split('', $info || '' )));
			$cell->set (text => $info );
		} 
	);

my $win = Gtk2::Window->new;
$win->set_title ('Gtk2::SimpleList exapmle');
$win->set_border_width (6);
$win->set_default_size (650, 600);
$win->signal_connect (delete_event => sub { Gtk2->main_quit; });

my $hbox = Gtk2::HBox->new (0, 6);
$win->add ($hbox);

my $scwin = Gtk2::ScrolledWindow->new;
$hbox->pack_start ($scwin, 1, 1, 0);
$scwin->set_policy (qw/automatic automatic/);

# create a simple list widget with one of each column type
my $slist = Gtk2::SimpleList->new (
			'Text Field'    => 'text',
			'Int Field'     => 'int',
			'Double Field'  => 'double',
			'Bool Field'    => 'bool',
			'Scalar Field'  => 'scalar',
			'Pixbuf Field'  => 'pixbuf',
			'Ralacs Field'  => 'ralacs',
	);
$scwin->add ($slist);

my $vbox = Gtk2::VBox->new (0, 6);
$hbox->pack_start($vbox, 0, 1, 0);

# now lets create some buttons to push, pop, shift, and unshift, ...
my $btn;
my $tooltips = Gtk2::Tooltips->new;
foreach (
		[ 'Push', 'Push a row onto the list' ],
		[ 'Pop', 'Pop a row off of the list' ],
		[ 'Unshift', 'Unshift a row onto the list' ],
		[ 'Shift', 'Shift a row off of the list' ],
		[ 'Change 1', 'Change all of the columns of row 1 with an array ref assignment' ],
		[ 'Change 2', 'Change all of the columns of row 1 with array element assignments' ],
		[ 'Change 3', 'Change the first column of row 1 with a scalar assignment, most useful with single column lists' ],
		[ 'Delete', 'Delete the ~middle element from the list' ],
		[ 'Empty', 'Delete all rows from the list with an empty array assignement' ],
		[ 'Fill', 'Fill the list with data using an array assignment' ],
	)
{
	$btn = Gtk2::Button->new ($_->[0]);
	$btn->signal_connect (clicked => \&btn_clicked, $_->[0]);
	$tooltips->set_tip ($btn, $_->[1]);
	$vbox->pack_start($btn, 0, 1, 0);
}
$tooltips->enable;

$btn = Gtk2::Button->new_from_stock ('gtk-quit');
$btn->signal_connect (clicked => sub  { Gtk2->main_quit; });
$vbox->pack_end($btn, 0, 1, 0);

# just for shorthand
my $dslist = $slist->{data};
my $op_count = 0;


my @pixbufs;
foreach (qw/gtk-ok gtk-cancel gtk-quit gtk-apply gtk-clear 
	    gtk-delete gtk-execute gtk-dnd/)
{
	push @pixbufs, $win->render_icon ($_, 'menu');
}
# so some will be blank
push @pixbufs, undef;

sub btn_clicked
{
	my ($button, $op) = @_;

	if( $op eq 'Push' )
	{
		push @$dslist, [ 'pushed', 5, 5.5, 0, 'scalar pushed', 
			$pixbufs[rand($#pixbufs+1)], 'scalar pushed' ];
	}
	elsif( $op eq 'Pop' )
	{
		pop @$dslist;
	}
	elsif( $op eq 'Unshift' )
	{
		unshift @$dslist, [ 'unshifted', 6, 6.6, 1, 'scalar unshifted', 
			$pixbufs[rand($#pixbufs+1)], 'scalar unshifted' ];
	}
	elsif( $op eq 'Shift' )
	{
		shift @$dslist;
	}
	elsif( $op eq 'Change 1' )
	{
		$dslist->[0] = [ 'changed1', 7, 7.7, 0, 'scalar changed1', 
			$pixbufs[rand($#pixbufs+1)], 'scalar changed1' ];
	}
	elsif( $op eq 'Change 2' )
	{
		$dslist->[0][0] = 'changed2';
		$dslist->[0][1] = 8;
		$dslist->[0][2] = 8.8;
		$dslist->[0][3] = 1;
		$dslist->[0][4] = 'scalar changed2';
		$dslist->[0][5] = $pixbufs[rand($#pixbufs+1)];
		$dslist->[0][6] = 'scalar changed2';
	}
	elsif( $op eq 'Change 3' )
	{
		# this is most useful if you've got a 1 column list
		$dslist->[0] = 'changed3';
	}
	elsif( $op eq 'Delete' )
	{
		# delete the ~middle element
		delete $dslist->[$#$dslist/2];
	}
	elsif( $op eq 'Empty' )
	{
		# can't use shorthand on this b/c we're replacing the ref
		# in the simple list's data.
		@{$slist->{data}} = ();
	}
	elsif( $op eq 'Fill' )
	{
		# can't use shorthand on this b/c we're replacing the ref
		# in the simple list's data.

# TODO: the next to last undef's should be changed to scalars once that's
# working and the last undefs should be pixbuf's of some sort
		@{$slist->{data}} = (
			[ 'one', 1, 1.1, 1, 'uno', undef, 'uno' ],
			[ 'two', 2, 2.2, 0, 'dos', undef, 'dos' ],
			[ 'three', 3, 3.3, 1, 'tres', undef, 'tres' ],
			[ 'four', 4, 4.4, 0, 'quatro', undef,  'quatro' ],
		);
	}

	1;
}

#my $count = 0;
#Glib::Timeout->add( 1000, sub
#	{
#		if( $count < 3 )
#		{
#			push @{$list->{data}}, [ 'more', $count++, 0 ];
#		}
#		elsif( $count < 6 )
#		{
#			shift @{$list->{data}};
#			$count++;
#		}
#		elsif( $count < 9 )
#		{
#			unshift @{$list->{data}}, [ 'another', $count++, 0 ];
#		}
#		elsif( $count < 12 )
#		{
#			pop @{$list->{data}};
#			$count++;
#		}
#		elsif( $count < 13 )
#		{
#			$list->{data}[1][0] = 'getting deleted';
#			$count++;
#		}
#		elsif( $count < 14 )
#		{
#			$list->{data}[1] = [ 'right now', -1, 1 ];
#			$count++;
#		}
#		elsif( $count < 15 )
#		{
#			$list->{data}[1] = 'bye';
#			$count++;
#		}
#		elsif( $count < 16 )
#		{
#			delete $list->{data}[1];
#			$count++;
#		}
#		elsif( $count < 17 )
#		{
#			warn "exists failed" 
#				unless( exists($list->{data}[0]) );
#			$count++;
#		}
#		elsif( $count < 18 )
#		{
#			@{$list->{data}} = ();
#			$count++;
#		}
#		else
#		{
#			return 0;
#		}
#		1;
#	} );

$win->show_all;
Gtk2->main;
