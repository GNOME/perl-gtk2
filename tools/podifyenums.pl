use warnings;
use Glib::GenPod;

if ($ARGV[1]) {
	open IN, $ARGV[1] or die "can't read $ARGV[1]: $!\n";
} else {
	*IN = *STDIN;
}

print "=head1 NAME

$ARGV[0]\::enums - enumeration and flag values for $ARGV[0]

=head1 DESCRIPTION

Just a listing of all enum and flags types defined for $ARGV[0], in one place
for convenience.  For more information, see the description of flags and
enums in L<Glib>.

=head1 LISTING

";


while (<IN>) {
	s/#.*//;
	(undef, $cname, $base, undef) = split;
	next unless $cname;
	next unless $base eq 'GFlags'
	         or $base eq 'GEnum';

	eval {
		# do the name to package conversion first, in case we have
		# hijacked enum registrations with names that aren't the same
		# as the C type names.  (i've pulled that trick in a couple
		# of places, can't remember exactly where, so play it safe.)
		my $name = Glib::GenPod::convert_type ($cname);
		my @values = Glib::Type->list_values ($name);
		next unless @values;
		my $type = UNIVERSAL::isa ($name, 'Glib::Flags')
		         ? 'flags' : 'enum';
		print "=head2 $type $name\n\n"
		    . "=over\n\n"
		    . join ("\n\n",
		            map { "=item * '$_->{nick}' / '$_->{name}'" }
		                  @values)
		    . "\n\n=back\n\n";
	} or print STDERR $@;
}

print "
=head1 SEE ALSO

L<Glib>, L<Glib::Flags>

=head1 AUTHOR

Generated ".scalar(localtime)." by $0, using Gtk2 compiled against GTK+
version ".join (".", Gtk2->get_version_info).".

=cut
";
