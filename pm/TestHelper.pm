#
# $Header$
#

package Gtk2::TestHelper;
use Test::More;
use Carp;

our $VERSION = '0.01';

sub import
{
	shift;
	my %opts = (@_);

	croak "tests must be provided at import" unless (exists ($opts{tests}));

	if ($opts{nowin32} && $^O eq 'MSWin32')
	{
		plan skip_all => "not appliciable on win32";
	}

	if ($opts{at_least_version})
	{
		my ($rmajor, $rminor, $rmicro, $text) = 
						@{$opts{at_least_version}};
		my ($major, $minor, $micro) = Gtk2->get_version_info;
		unless ($major >= $rmajor &&
			$minor >= $rminor &&
			$micro >= $rmicro)
		{
			plan skip_all => $text;
		}
	}

	if( $opts{noinit} || Gtk2->init_check )
	{
		plan tests => $opts{tests};
	}	
	else
	{	
		plan skip_all => 'Gtk2->init_check failed, probably '
				.'unable to open DISPLAY';
	}

	# ignore keyboard
	Gtk2->key_snooper_install (sub { 1; });
}

package main;

# these are to make people behave
use strict;
use warnings;
# go ahead and use Gtk2 for them.
use Gtk2;
# and obviously they'll need Test::More
use Test::More;

1;
__END__

=head1 NAME

Gtk2::Test::Helper - Code to make testing Gtk2 and friends simpler.

=head1 SYNOPSIS

  use Gtk2::TestHelper tests => 10;

=head1 DESCRIPTION

A simplistic module that brings together code that would otherwise have to be
copied into each and every test. The magic happens during the importing process
and therefore all options are passed to the use call. The module also use's
strict, warnings, Gtk2, and Test::More so that the individual tests will not
have to. The only required option is the number of tests. The module installs a
key snooper that causes all keyboard input to be ignored.

=head1 OPTIONS

=over

=item tests

The number of tests to be completed.

=item noinit

Do not call Gtk2->init_check, assume that it is not necessary.

=item nowin32

Set to true if all tests are to be skipped on the win32 platform.

=back

=head1 SEE ALSO

L<perl>(1), L<Gtk2>(3pm).

=head1 AUTHORS

The Gtk2-Perl Team.

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by the gtk2-perl team.

LGPL, See LICENSE file for more information.
