#
# $Header$
#

#
# TODO:
#	- the scalar columns don't really work, add to test when do
#	- when we fetch an empty column, one we set to undef, 
#	gperl_new_object complains about converting (NULL) => undef, which 
#	seems like it's what should be happening
#	- look at editable text cells?
#

#########################
package Gtk2::SimpleList;

use Carp;
use Gtk2;
use base 'Gtk2::TreeView';

our $VERSION = '0.10';

BEGIN
{
	print STDERR "WARNING: Gtk2::SimpleList is alpha quality software and "
		."is subject to change in fundamental ways or disappear "
		."altogether. Send bugs/questions/suggestions, they'll only "
		."help, to gtk-perl-list\@gnome.org.\n"
}

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

my %column_types = (
  'text'   => {type=>'Glib::String',      renderer=>'Text',   attr=>'text'},
  'int'    => {type=>'Glib::Int',         renderer=>'Text',   attr=>'text'},
  'double' => {type=>'Glib::Double',      renderer=>'Text',   attr=>'text'},
  'bool'   => {type=>'Glib::Boolean',     renderer=>'Toggle', attr=>'active'},
  'scalar' => {type=>'Glib::Scalar',      renderer=>'Text',   attr=>'text'},
  'pixbuf' => {type=>'Gtk2::Gdk::Pixbuf', renderer=>'Pixbuf', attr=>'pixbuf'},
);


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

	my @a;
	tie @a, 'Gtk2::SimpleList::TiedList', $model;

	$view->{data} = \@a;
	return bless $view, $class;
}

sub set_with_array
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

Gtk2::SimpleList - 

=head1 SYNOPSIS

  use Gtk2 -init;

=head1 ABSTRACT

  TODO

=head1 DESCRIPTION

TODO

=head1 SEE ALSO

perl(1), Glib(3pm), Gtk2(3pm).

The Gtk2::Helper module contains stuff that makes writing Gtk2 programs
a little easier.

Gtk2 also provides code to make it relatively painless to create perl
wrappers for other GLib/Gtk-based libraries.  See Gtk2::CodeGen, 
Glib::PkgConfig, and ExtUtils::Depends.

=head1 AUTHORS

 muppet <scott at asofyet dot org>
 Ross McFarland <rwmcfa1 at neces dot com>
 Gavin Brown <gavin dot brown at uk dot com>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by the gtk2-perl team.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the 
Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
Boston, MA  02111-1307  USA.

=cut
