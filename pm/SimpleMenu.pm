#
# $Header$
#
# r.m.
# 

# TODO:
#	pod
#	test

package Gtk2::SimpleMenu;

use strict;
use warnings;
use Carp;
use Gtk2;
use base 'Gtk2::ItemFactory';

our $VERSION = 0.50;

sub new
{
	my $class = shift;
	my %opts = ( @_ );
	
	# create an accel group to pass to the item factory call, it's later
	# stored so that our owner can add the accel group to something
	my $accel_group = Gtk2::AccelGroup->new;
	
	# create the item factory providing a accel_group.
	my $self = Gtk2::ItemFactory->new('Gtk2::MenuBar', '<main>', $accel_group);

	# put the options into the simple item object
	foreach (keys %opts)
	{
		$self->{$_} = $opts{$_};
	}
	
	bless($self, $class);
	
	# convert our menu_tree into a set of entries for itemfactory
	$self->parse;
	# create the entries 
	$self->create_items($self->{user_data}, @{$self->{entries}});
	# store the widget so our owner can easily get to it
	$self->{widget} = $self->get_widget('<main>');
	# cache the accel_group so the user can add it to something,
	# the window, if they so choose
	$self->{accel_group} = $accel_group;

	return $self;
}


sub parse
{
	my $self = shift;

	our @entries = ();
	our @groups = ();
	our $default_callback = $self->{default_callback};

	# called below (for 'root' branch) and the recusively for each branch
	sub parse_level
	{
		my $path = shift;
		my $label = shift;
		my $itms = shift;
	
		# we need a type to test to prevent warnings,
		# just use one that will fall through to defaul
		$itms->{item_type} = ''
			unless( exists($itms->{item_type}) );

		if( $itms->{item_type} eq 'root' )
		{
			# special type for first call, doesn't add entry
			my $i = 0;
			for($i = 0; $i < scalar(@{$itms->{children}}); $i += 2)
			{
				parse_level ('/',
					$itms->{children}[$i],
					$itms->{children}[$i+1]);
			}
		}
		elsif( $itms->{item_type} =~ /Branch/ )
		{
			# add the branch item
			push @entries, [ $path.$label,
					 undef,
					 undef,
					 undef,
					 $itms->{item_type}, ];
			# remove mnemonics from path
			$label =~ s/_//g;
			# then for each of its children parse that level
			my $i = 0;
			for( $i = 0; $i < scalar(@{$itms->{children}}); $i += 2)
			{
				parse_level ($path.$label.'/',
					$itms->{children}[$i],
					$itms->{children}[$i+1]);
			}
		}
		elsif( $itms->{item_type} =~ /Radio/ )
		{
			# cache the groupid
			my $grp = $itms->{groupid};

			# add this radio item to the existing group, if one,
			# otherwise use item_type
			push @entries, [ $path.$label,
					 $itms->{accelerator},
					 (exists($itms->{callback}) ? 
						 $itms->{callback} : 
						 $default_callback ),
					 $itms->{callback_action},
					 (exists($groups[$grp]) ? 
						 $groups[$grp] :
						 $itms->{item_type}), 
					 $itms->{extra_data}, ];

			# create the group identifier (path)
			# so that next button in this group will
			# be added to existing group
			unless( exists($groups[$grp]) )
			{
				$groups[$grp] = $path.$label;
				$groups[$grp] =~ s/_//g;
			}
		}
		else
		{
			# everything else just gets created with its values
			push @entries, [ $path.$label,
					 $itms->{accelerator},
					 (exists($itms->{callback}) ? 
						 $itms->{callback} : 
						 $default_callback ),
					 $itms->{callback_action},
					 $itms->{item_type},
					 $itms->{extra_data}, ];
		}
	}

	# fake up a root branch with the menu_tree as it's children
	parse_level (undef, undef, { 
			item_type => 'root', 
			children => $self->{menu_tree} });

	# store the itemfactory entries array
	$self->{entries} = \@entries;
}

1;
