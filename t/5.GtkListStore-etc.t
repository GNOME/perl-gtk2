#########################
# GtkListStore, GtkTreeView Tests
# 	- rm
#########################
#
# $Header$
#

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('Gtk2') };

#########################

ok( Gtk2->init );

ok( $win = Gtk2::Window->new );

@cols = (
		{ title => 'Author', type => 'G::String',  },
		{ title => 'Work',   type => 'G::String',  },
		{ title => 'Sold',   type => 'G::Uint',    },
		{ title => 'Print',  type => 'G::Boolean', },
	);

ok( $store = Gtk2::ListStore->new( map {$_->{type}} @cols ) );

@data = (
	{ Author => 'John Doe', Work => 'Who am I', Sold => '32', Print => 0 },
	{ Author => 'John Doe', Work => 'Who am I', Sold => '44', Print => 1 },
);

foreach (@data)
{
	my $iter = $store->append;
	$store->set($iter, 
		1, $_->{Work},
		0, $_->{Author},
		2, $_->{Sold},
		3, $_->{Print} );
}

ok( $tree = Gtk2::TreeView->new_with_model($store) );
$win->add($tree);

$i = 0;
foreach (@cols)
{
	if( $_->{type} =~ /G::String/ )
	{
		$renderer = Gtk2::CellRendererText->new;
		$column = Gtk2::TreeViewColumn->new_with_attributes(
			$_->{title}, $renderer, text => $i );
		$tree->append_column($column);
	}
	elsif( $_->{type} =~ /G::Uint/ )
	{
		$renderer = Gtk2::CellRendererText->new;
		$column = Gtk2::TreeViewColumn->new_with_attributes(
			$_->{title}, $renderer, text =>  $i );
		$tree->append_column($column);
	}
	elsif( $_->{type} =~ /G::Boolean/ )
	{
  		$renderer = Gtk2::CellRendererToggle->new;
		$column = Gtk2::TreeViewColumn->new_with_attributes(
			$_->{title}, $renderer, active =>  $i );
		$tree->append_column($column);
	}
	$i++;
}

$win->show_all;

G::Idle->add( sub {
		if( (Gtk2->get_version_info)[1] >= 2 )
		{
			$store->reorder(1, 0);
		}
		Gtk2->main_quit;
	} );

Gtk2->main;
