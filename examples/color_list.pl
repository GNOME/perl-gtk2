#!/usr/bin/perl

use strict;
use warnings;

use Gtk2 '-init';
use Gtk2::SimpleList;

# add a new type of column that reverses the text that's in a scalar
Gtk2::SimpleList->add_column_type(
	'color',
		type     => 'Gtk2::Gdk::Color',
		renderer => 'Gtk2::CellRendererText',   
		attr     => 'hidden',
	);


# create a simple list widget with one of each column type
my $slist = Gtk2::SimpleList->new (
			'Text Field'    => 'text',
			'Int Field'     => 'int',
			'Bool Field'    => 'bool',
			'row color'     => 'color',
	);

my $red = Gtk2::Gdk::Color->new (0xFFFF, 0, 0);
my $grn = Gtk2::Gdk::Color->new (0, 0xFFFF, 0);

my $win = Gtk2::Window->new;
$win->set_title ('Colorizing A List');
$win->set_border_width (6);
$win->set_default_size (300, 250);
$win->signal_connect (delete_event => sub { Gtk2->main_quit; });

my $vbox = Gtk2::VBox->new (0, 6);
$win->add ($vbox);

my $scwin = Gtk2::ScrolledWindow->new;
$vbox->pack_start ($scwin, 1, 1, 0);
$scwin->add ($slist);

@{$slist->{data}} = (
	[ 'One', 1, 0, $red ],
	[ 'Two', 2, 1, $grn ],
	[ 'Three', 3, 0, $red ],
	[ 'Four', 4, 1, $grn ],
	[ 'Five', 5, 0, $red ],
	[ 'Six', 6, 1, $grn ],
	[ 'Seven', 7, 0, $red ],
	[ 'Eight', 8, 1, $grn ],
);

for(my $i = 0; $i < $slist->get_model->get_n_columns-1; $i++)
{
	my $col = $slist->get_column($i);
	$col->add_attribute($col->get_cell_renderers, cell_background_gdk => 3);
}

$win->show_all;
Gtk2->main;
