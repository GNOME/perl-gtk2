#
# $Header$
#

#
# TODO:
#	- look at editable text cells?
#	- simplified get selected stuff
#

#########################
package Gtk2::SimpleList;

use Carp;
use Gtk2;
use base 'Gtk2::TreeView';

our $VERSION = '0.12';

=cut

this version of simplelist is a simple list widget, which has a list-of-lists
data structure (under the key I<data>) which corresponds directly to the
items in the list.  as it is tied, it is always synchronized.

this is a very simple interface, giving you six column types:

  text
  int
  double
  bool
  scalar
  pixbuf

only bool is editable, and that's set up for you.

=cut

our %column_types = (
  'text'   => {type=>'Glib::String',      renderer=>'Text',   attr=>'text'},
  'int'    => {type=>'Glib::Int',         renderer=>'Text',   attr=>'text'},
  'double' => {type=>'Glib::Double',      renderer=>'Text',   attr=>'text'},
  'bool'   => {type=>'Glib::Boolean',     renderer=>'Toggle', attr=>'active'},
  'scalar' => {type=>'Glib::Scalar',      renderer=>'Text',   
	  attr=> sub { 
  		my ($tree_column, $cell, $model, $iter, $i) = @_;
  		my ($info) = $model->get ($iter, $i);
  		$cell->set (text => $info || '' );
	  } },
  'pixbuf' => {type=>'Gtk2::Gdk::Pixbuf', renderer=>'Pixbuf', attr=>'pixbuf'},
);

# this is some cool shit
sub add_column_type
{
	shift;	# don't want/need classname
	my $name = shift;
	$column_types{$name} = { @_ };
}

sub new {
	my $class = shift;
	my @column_info = ();
	for (my $i = 0; $i < @_ ; $i+=2) {
		croak "expecting pairs of title=>type"
			unless $_[$i+1];
		my $type = $column_types{$_[$i+1]}{type};
		croak "unknown column type $_[$i+1], use one of "
		    . join(", ", keys %column_types)
			unless defined $type;
		push @column_info, {
			title => $_[$i],
			type => $type,
			rtype => "Gtk2::CellRenderer$column_types{$_[$i+1]}{renderer}",
			attr => $column_types{$_[$i+1]}{attr},
		};
	}
	my $model = Gtk2::ListStore->new (map { $_->{type} } @column_info);
	my $view = Gtk2::TreeView->new ($model);
	for (my $i = 0; $i < @column_info ; $i++) {
		if( 'CODE' eq ref $column_info[$i]{attr} )
		{
			$view->insert_column_with_data_func (-1,
				$column_info[$i]{title},
				$column_info[$i]{rtype}->new,
				$column_info[$i]{attr}, $i);
		}
		else
		{
			my $column = Gtk2::TreeViewColumn->new_with_attributes (
				$column_info[$i]{title},
				$column_info[$i]{rtype}->new,
				$column_info[$i]{attr} => $i,
			);
			$view->append_column ($column);
	
			if ($column_info[$i]{attr} eq 'active') {
				my $r = $column->get_cell_renderers;
				$r->set (activatable => 1);
				$r->signal_connect (toggled => sub {
					my ($renderer, $row, $col) = @_;
					my $iter = $model->iter_nth_child (undef, $row);
					my $val = $model->get ($iter, $col);
					$model->set ($iter, $col, !$val);
					}, $i);
			}
		}
	}

	my @a;
	tie @a, 'Gtk2::SimpleList::TiedList', $model;

	$view->{data} = \@a;
	return bless $view, $class;
}

sub set_data_array
{
	@{$_[0]->{data}} = @{$_[1]};
}

##################################
package Gtk2::SimpleList::TiedRow;
use strict;
use Gtk2;
use Carp;

=cut

TiedRow is the lowest-level tie, allowing you to treat a row as an array
of column data.

=cut

sub TIEARRAY {
	my $class = shift;
	my $model = shift;
	my $iter = shift;

	croak "usage tie (\@ary, 'class', model, iter)"
		unless $model && UNIVERSAL::isa ($model, 'Gtk2::TreeModel');

	return bless {
		model => $model,
		iter => $iter,
	}, $class;
}

sub FETCH {
	return $_[0]->{model}->get ($_[0]->{iter}, $_[1]);
}

sub STORE {
	return $_[0]->{model}->set ($_[0]->{iter}, $_[1], $_[2])
		if( $_[2] );
}

sub FETCHSIZE {
	return $_[0]{model}->get_n_columns;
}

sub EXISTS { 
	return( $_[1] < $_[0]{model}->get_n_columns );
}

sub EXTEND { }
sub CLEAR { }

sub new {
	my ($class, $model, $iter) = @_;
	my @a;
	tie @a, __PACKAGE__, $model, $iter;
	return \@a;
}

sub POP { croak "pop called on a TiedRow, but you can't change its size"; }
sub PUSH { croak "push called on a TiedRow, but you can't change its size"; }
sub SHIFT { croak "shift called on a TiedRow, but you can't change its size"; }
sub UNSHIFT { croak "unshift called on a TiedRow, but you can't change its size"; }
sub SPLICE { croak "splice called on a TiedRow, but you can't change it's size"; }
sub DELETE { croak "delete called on a TiedRow, but you can't change it's size"; }
sub STORESIZE { carp "STORESIZE operation not supported"; }


###################################
package Gtk2::SimpleList::TiedList;

use strict;
use Gtk2;
use Carp;

=cut

TiedList is an array in which each element is a row in the liststore.

=cut

sub TIEARRAY {
	my $class = shift;
	my $model = shift;

	croak "usage tie (\@ary, 'class', model)"
		unless $model && UNIVERSAL::isa ($model, 'Gtk2::TreeModel');

	return bless {
		model => $model,
	}, $class;
}

sub FETCH {
	my $iter = $_[0]->{model}->iter_nth_child (undef, $_[1]);
	return undef unless defined $iter;
	my @row;
	tie @row, 'Gtk2::SimpleList::TiedRow', $_[0]->{model}, $iter;
	return \@row;
}

sub STORE {
	my $iter = $_[0]->{model}->iter_nth_child (undef, $_[1]);
	$iter = $_[0]->{model}->insert ($_[1])
		if not defined $iter;
	my @row;
	tie @row, 'Gtk2::SimpleList::TiedRow', $_[0]->{model}, $iter;
	if ('ARRAY' eq ref $_[2]) {
		@row = @{$_[2]};
	} else {
		$row[0] = $_[2];
	}
	return 1;
}

sub FETCHSIZE { 
	return $_[0]->{model}->iter_n_children (undef);
}

sub PUSH { 
	my $iter = $_[0]->{model}->append;
	my @row;
	tie @row, 'Gtk2::SimpleList::TiedRow', $_[0]->{model}, $iter;
	if ('ARRAY' eq ref $_[1]) {
		@row = @{$_[1]};
	} else {
		$row[0] = $_[1];
	}
	return 1;
}

sub POP { 
	my $model = $_[0]->{model};
	my $index = $model->iter_n_children-1;
	$model->remove($model->iter_nth_child(undef, $index))
		if( $index >= 0 );
}

sub SHIFT { 
	my $model = $_[0]->{model};
	$model->remove($model->iter_nth_child(undef, 0))
		if( $model->iter_n_children );
}

sub UNSHIFT { 
	my $iter = $_[0]->{model}->prepend;
	my @row;
	tie @row, 'Gtk2::SimpleList::TiedRow', $_[0]->{model}, $iter;
	if ('ARRAY' eq ref $_[1]) {
		@row = @{$_[1]};
	} else {
		$row[0] = $_[1];
	}
	return 1;
}

sub DELETE { 
	my $model = $_[0]->{model};
	$model->remove($model->iter_nth_child(undef, $_[1]))
		if( $_[1] < $model->iter_n_children );
}

sub CLEAR { 
	$_[0]->{model}->clear;
}

sub EXISTS { 
	return( $_[1] < $_[0]->{model}->iter_n_children );
}

# we can't really, reasonably, extend the tree store in one go, it will be 
# extend as items are added
sub EXTEND {}

sub get_model {
	return $_[0]{model};
}

sub STORESIZE { carp "STORESIZE: operation not supported"; }
sub SPLICE { carp "SPLICE: operation not supported"; }

1;

__END__
# documentation is a good thing.

=head1 NAME

Gtk2::SimpleList - A simple interface to the complex MVC list interface of Gtk2

=head1 SYNOPSIS

  use Gtk2 -init;
  use Gtk2::SimpleList.pm;

  use constant TRUE  => 1;
  use constant FALSE => 0;

  my $slist = Gtk2::SimpleList->new (
                'Text Field'    => 'text',
                'Int Field'     => 'int',
                'Double Field'  => 'double',
                'Bool Field'    => 'bool',
                'Scalar Field'  => 'scalar',
                'Pixbuf Field'  => 'pixbuf',
              );

  @{$slist->{data}} = (
          [ 'text', 1, 1.1,  TRUE, $var, $pixbuf ],
          [ 'text', 2, 2.2, FALSE, $var, $pixbuf ],
  );

  # (almost) anything you can do to an array you can do to 
  # $slist->{data} which is an array reference tied to the list model
  push @{$slist->{data}}, [ 'text', 3, 3.3, TRUE, $var, $pixbuf ];

=head1 ABSTRACT

Gtk2 has a powerful, but complex MVC (Model, View, Cell) system used to
implement the graphical user interface element known as a list.
Gtk2::SimpleList does all of the complex setup work for you and allows you to
treat the list widget as an array of arrays. It is implemented with tied arrays
so the data to Perl is always synchronized with what is displayed in the
widget.

=head1 DESCRIPTION

Gtk2 has a powerful, but complex MVC (Model, View, Cell) system used to
implement user interface element known as a list. Gtk2::SimpleList does all of
the complex setup work for you and allows you to treat the list widget as an
array of arrays.

After creating a new Gtk2::SimpleList object with the desired columns you may
set the list of data as simple as a Perl array assignment. Rows may be added or
deleted with the all of the normal array operations. Data may be accessed by
treating the data member of the list object as an array reference. Data can be
modified by doing the same. 

A mechanism has also been put into place allowing columns to be Perl scalars.
The scalar is converted to text through Perl's normal mechanisms and then
displayed in the list. This same mechanism can be expanded by defining
arbitrary new column types before calling the new function. 

=head1 FUNCTIONS

=over

=item $slist = Gtk2::SimpleList->new (cname, ctype, [cname, ctype, ...])

Creates a new Gtk2::SimpleList object with the specified columns. The parameter
cname is the name of the column, what will be displayed in the list headers if
they are turned on. The parameter ctype is the type of the column, one of:
text, int, double, bool, scalar, pixbuf, or the name of a custom type you add
with C<add_column_type>. These should be provided in pairs according to the
desired columns for you list.

=item $slist->set_data_array (arrayref)

Set the data in the list to the array reference arrayref. This is completely
equivalent to @{$list->{data}} = @{$arrayref} and is only here for convenience
and for those programmers who don't like to type-cast and have static, set once
data.

=item Gtk2::SimpleList->add_column_type (type_name, ...)

Add a new column type to the list of possible types. Initially six column types
are defined, text, int, double, bool, scalar, and pixbuf. The bool column type
uses a toggle cell renderer, the pixbuf uses a pixbuf cell renderer, and the
rest use text cell renderers. In the process of adding a new column type you
may use any cell renderer you wish. 

The first parameter is the column type name, the list of six are examples.
There are no restrictions on the names and you may even overwrite the existing
ones should you choose to do so. The remaining parameters are the type
definition consisting of key value pairs. There are three required: type,
renderer, and attr. The type key should be always be set to 'Glib::Scalar'. The
renderer key may be any of Text, Toggle, or Pixbuf depending on which
CellRenderer type you wish your results to be displayed in. The attr key is
where the magic lies. For custom column types attr must be a code reference
implementing a function that sets the value of the renderer. 

This function will accept 5 parameters: $treecol, $cell, $model, $iter,
$col_num.  It should make use of these parameters to retrieve the data
associated with the row given by $iter in the column $col_num. To do this $data
= $model->get($iter, $col_num) should be used. You then should set the
appropriate attributes of the $cell to whatever you wish based off of what is
contained in $data. $data may be anything that you can put into a Perl scalar,
even references to arrays or hashes. Two examples follow:

  # just displays the value in a scalar as 
  # Perl would convert it to a string
  Gtk2::SimpleList->add_column_type( 'a_scalar', 
          type     => 'Glib::Scalar',
	  renderer => 'Text',
          attr     => sub {
               my ($treecol, $cell, $model, $iter, $col_num) = @_;
               my $info = $model->get ($iter, $i);
               $cell->set (text => $info);
	  }
     );

  # sums up the values in an array ref and displays 
  # that in a text renderer
  Gtk2::SimpleList->add_column_type( 'sum_of_array', 
          type     => 'Glib::Scalar',
	  renderer => 'Text',
          attr     => sub {
               my ($treecol, $cell, $model, $iter, $col_num) = @_;
               my $sum = 0;
               my $info = $model->get ($iter, $i);
               foreach (@$info)
               {
                   $sum += $_;
               }
               $cell->set (text => $sum);
          } 
     );

=back

=head1 MODIFYING LIST DATA

After creating a new Gtk2::SimpleList object there will be a member called data
which is a tied array. That means data may be treated as an array, but in
reality the data resides in something else. There is no need to understand the
details of this it just means that you put data into, take data out of, and
modify it just like any other array. This includes using array operations like
push, pop, unshift, and shift. For those of you very familiar with perl this
section will prove redundant, but just in case:

  Adding and removing rows:
  
    # push a row onto the end of the list
    push @{$slist->{data}}, [col1_data, col2_data, ..., coln_data];
    # pop a row off of the end of the list
    $rowref = pop @{$slist->{data}};
    # unshift a row onto the beginning of the list
    unshift @{$slist->{data}}, [col1_data, col2_data, ..., coln_data];
    # shift a row off of the beginning of the list
    $rowref = shift @{$slist->{data}};
    # delete the row at index n, 0 indexed
    delete $slist->{data}[n]
    # set the entire list to be the data in a array
    @{$slist->{data}} = ( [row1, ...], [row2, ...], [row3, ...] );

  Getting at the data in the list:
  
    # get an array reference to the entire nth row
    $rowref = $slist->{data}[n] 
    # get the scalar in the mth column of the nth row, 0 indexed
    $val = $slist->{data}{n}{m}
    # set an array reference to the entire nth row
    $slist->{data}[n] = [col1_data, col2_data, ..., coln_data];
    # get the scalar in the mth column of the nth row, 0 indexed
    $slist->{data}{n}{m} = $rowm_coln_value;

=head1 SEE ALSO

Perl(1), Glib(3pm), Gtk2(3pm).

=head1 AUTHORS

 muppet <scott at asofyet dot org>
 Ross McFarland <rwmcfa1 at neces dot com>
 Gavin Brown <gavin dot brown at uk dot com>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by the Gtk2-Perl team.

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.

=cut
