#
# $Header$
#

package Gtk2;

use 5.008;
use strict;
use warnings;

use G;

require Exporter;
require DynaLoader;

our @ISA = qw(Exporter DynaLoader);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Gtk2 ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';

sub dl_load_flags { 0x01 }

bootstrap Gtk2 $VERSION;

# Preloaded methods go here.

#
# a little bit of API redirection.
#
# these are supposed to be deprecated in favor of the GLib versions, and
# in general the deprecated stuff is to be left completely out of gtk2-perl;
# but these APIs are much more sensible than the corresponding GLib versions,
# and held over from versions past, so i've put sugar for them here.
#

sub timeout_add {
	shift; # lose the class
	return G::Timeout->add (@_);
}

sub idle_add {
	shift; # lose the class
	return G::Idle->add (@_);
}

sub input_add { # FIXME the call signature here isn't exactly the same ---
		# gtk_input_add's arguments aren't 1:1 with g_io_add_watch!
	shift; # lose the class
	return G::IO->add_watch (@_);
}

sub timeout_remove { G::Source->remove ($_[1]); }
sub idle_remove { G::Source->remove ($_[1]); }
sub input_remove { G::Source->remove ($_[1]); }

package Gtk2::ItemFactory;

sub create_item {
	my ($factory, $entry, $callback_data) = @_;
	my ($path, $accelerator, $callback, $action, $type, $extra, $cleanpath);

	if ('ARRAY' eq ref $entry) {
		($path, $accelerator, $callback, $action, $type, $extra) 
			= @$entry;
	} elsif ('HASH' eq ref $entry) {
		($path, $accelerator, $callback, $action, $type, $extra)
			= @$entry{qw(path accelerator callback action
			             type extra)};
	} else {
		use Carp;
		croak "badly formed Gtk Item Factory Entry; use either list for for hash form:\n"
		    . "    list form:\n"
		    . "        [ path, accel, callback, action, type ]\n"
		    . "    hash form:\n"
		    . "        {\n"
		    . "           path => \$path,\n"
		    . "           accel => \$accel,  # optional\n"
		    . "           callback => \$callback,\n"
		    . "           action => \$action,\n"
		    . "           type => \$type,    # optional\n"
		    . "         }\n"
		    . "  ";
	}

	# we have this funky perl wrapper for the XS function entirely for
	# this line right here --- strip underscores from the possibly unicode
	# path, for use with gtk_item_factory_get_widget.
	($cleanpath = $path) =~ s/_//g;

	# the rest of the work happens in XS
	$factory->_create_item ($path, $accelerator || '',
				$action, $type || '', $extra,
	                        $cleanpath,
	                        $callback||undef, $callback_data||undef);
}

sub create_items {
	my $self = shift;
	my $data = shift;
	foreach my $entry (@_) {
		$self->create_item ($entry, $data);
	}
}

package Gtk2;


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Gtk2 - Perl interface to the 2.x series of the Gimp Toolkit library

=head1 SYNOPSIS

  use Gtk2;
  Gtk2->init;
  my $window = Gtk2::Window->new ('toplevel');
  my $button = Gtk2::Button->new ('Quit');
  $button->signal_connect (clicked => sub { Gtk2->main_quit });
  $window->add ($button);
  $window->show_all;
  Gtk2->main;

=head1 ABSTRACT

  Perl bindings to the 2.x series of the Gtk+ widget set.
  This module allows you to write graphical user interfaces in a perlish
  and object-oriented way, freeing you from the casting and memory 
  management in C, yet remaining very close in spirit to original API.

=head1 DESCRIPTION

The Gtk2 module allows a perl developer to use the Gtk+ graphical user
interface library.  Find out more about Gtk+ at http://www.gtk.org.

The GTK+ Reference Manual is also a handy companion when writing Gtk
programs in any language.  http://developer.gnome.org/doc/API/2.0/gtk/
The perl bindings follow the C API very closely, and the C reference
documentation should be considered the canonical source.

To discuss gtk2-perl, ask questions and flame/praise the authors,
join gtk-perl-list@gnome.org at lists.gnome.org.

If you have a web site set up for your module, mention it here.

FIXME we have no other documentation, but we probably need it.

=head1 SEE ALSO

perl(1), G(1).

=head1 AUTHOR

muppet E<lt>scott@asofyet.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by muppet

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
