#!/usr/bin/perl -w
use Data::Dumper;

$input_map = shift;
die "usage: $0 input_map\n"
	unless $input_map;
open IN, "< $input_map"
	or die "can't open $input_map for reading: $!\n";

%types = (
	'G::Object' => {
			typemacro => 'G_TYPE_OBJECT',
			classname => 'GObject',
			parentname => undef,
			'package' => 'G::Object',
		},
);

while (<IN>) {
	chomp;
	my ($typemacro, $classname, $parentname, $base, $package) = split;
	$types{$package} = {
		typemacro => $typemacro,
		classname => $classname,
		parentname => $parentname,
		'package' => $package,
	};
	$classes{$classname} = {
		typemacro => $typemacro,
		classname => $classname,
		parentname => $parentname,
		'package' => $package,
	};
}

=out 

@keys = keys %types;
foreach $k (@keys) {
	my $parent = $types{$k}{parentname};
	foreach (@keys) {
		next unless $types{$k}{parentname};
		if ($types{$_}{classname} eq $parent) {
			$types{$k}{parentpackage} = $types{$_}{'package'};
			last;
		}
	}
}

#print Dumper (\%types);


# couldn't get the properly recursive form to work.  this one uses a stack.
@stack = ();
%tree = ();
$node = undef;
sub find_children {
	my $class = shift;
	push @stack, $class;
	my $k = "{'" . join("'}{'", @stack) . "'}";
	print "$k\n";
	eval '$tree'.$k.' = {} unless exists $tree'.$k.';';
	eval '$node = $tree'.$k.';';
	foreach my $k (@keys) {
		next unless $types{$k}{parentpackage};
		if ($types{$k}{parentpackage} eq $class) {
#			print "$k is a child of $class\n";
#			$node{$k} = {};
			find_children ($k);
		}
	}
	pop @stack;
}

find_children ('G::Object');
print Dumper(\%tree);

=cut

sub types_isa {
	my ($child, $testparent) = @_;
	return 1 if $child eq $testparent;
	my $parent = $child;
	while ($parent = $classes{$parent}{parentname}) {
		return 1 if $parent eq $testparent;
	}
	return undef;
}

foreach (keys %classes) {
	if (types_isa $_, 'GtkObject') {
		print "$_\tGtkObject\n"
	} elsif (types_isa $_, 'GObject') {
		print "$_\tGObject\n";
	}
}
