#
# Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the full
# list)
# 
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Library General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
# 
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
# more details.
# 
# You should have received a copy of the GNU Library General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307  USA.
#
# $Header$
#

package Gtk2;

# Gtk uses unicode strings; thus we require perl>=5.8.x,
# which is unicode internally.
use 5.008;
use strict;
use warnings;

use Glib;

require DynaLoader;

our $VERSION = '1.01';

our @ISA = qw(DynaLoader);

sub import {
	my $class = shift;
	foreach (@_) {
		if (/^-?init$/) {
			$class->init;
		} else {
			$class->VERSION ($_);
		}
	}
}

# this is critical -- tell dynaloader to load the module so that its 
# symbols are available to all other modules.  without this, nobody
# else can use important functions like gtk2perl_new_object!
# 
# hrm.  win32 doesn't really use this, because we have to link the whole
# thing at compile time to ensure all the symbols are defined.
#
# on darwin, at least with the particular 5.8.0 binary i'm using, perl
# complains "Can't make loaded symbols global on this platform" when this
# is set to 0x01, but goes on to work fine.  returning 0 here avoids the
# warning and doesn't appear to break anything.
sub dl_load_flags { $^O eq 'darwin' ? 0x00 : 0x01 }

# now load the XS code.
bootstrap Gtk2 $VERSION;

# Preloaded methods go here.

package Gtk2::ItemFactory;

sub create_item {
	my ($factory, $entry, $callback_data) = @_;
	my ($path, $accelerator, $callback, $callback_action, $item_type, 
	    $extra_data, $cleanpath);

	if ('ARRAY' eq ref $entry) {
		($path, $accelerator, $callback, $callback_action, 
		 $item_type, $extra_data) = @$entry;
	} elsif ('HASH' eq ref $entry) {
		foreach (keys %$entry)
		{
			if( $_ eq 'path' )
			{
				$path = $entry->{path};
			}
			elsif( $_ eq 'accelerator' )
			{
				$accelerator = $entry->{accelerator};
			}
			elsif( $_ eq 'callback' )
			{
				$callback = $entry->{callback};
			}
			elsif( $_ eq 'callback_action' )
			{
				$callback_action = $entry->{callback_action};
			}
			elsif( $_ eq 'item_type' )
			{
				$item_type = $entry->{item_type};
			}
			elsif( $_ eq 'extra_data' )
			{
				$extra_data = $entry->{extra_data};
			}
			else
			{
				use Carp;
				carp("Gtk Item Factory Entry; unknown key ($_) "
				   . "ignored, legal keys are: path, "
				   . "accelerator, accel, callback, "
				   . "callback_action, item_type, extra_data");
			}
		}
	} else {
		use Carp;
		croak "badly formed Gtk Item Factory Entry; use either list for for hash form:\n"
		    . "    list form:\n"
		    . "        [ path, accel, callback, action, type ]\n"
		    . "    hash form:\n"
		    . "        {\n"
		    . "           path            => \$path,\n"
		    . "           accelerator     => \$accel,   # optional\n"
		    . "           callback        => \$callback,\n"
		    . "           callback_action => \$action,\n"
		    . "           item_type       => \$type,    # optional\n"
		    . "           extra_data      => \$extra,   # optional\n"
		    . "         }\n"
		    . "  ";
	}

	# we have this funky perl wrapper for the XS function entirely for
	# this line right here --- strip underscores from the possibly unicode
	# path, for use with gtk_item_factory_get_widget.
	($cleanpath = $path) =~ s/_//g;

	# the rest of the work happens in XS
	$factory->_create_item ($path, $accelerator || '',
				$callback_action || 0, $item_type || '', 
				$extra_data, $cleanpath,
	                        $callback||undef, $callback_data||undef);
}

sub create_items {
	croak "usage: \$itemfactory->create_items(callback_data, entry, "
		."[entry, ...]" if( scalar(@_) < 3 );

	my $self = shift;
	my $callback_data = shift;
	foreach my $entry (@_) {
		$self->create_item ($entry, $callback_data);
	}
}

package Gtk2::Gdk::Atom;

use overload
	'==' => \&Gtk2::Gdk::Atom::eq,
	fallback => 1;

package Gtk2;


1;
__END__
# documentation is a good thing.

=head1 NAME

Gtk2 - Perl interface to the 2.x series of the Gimp Toolkit library

=head1 SYNOPSIS

  use Gtk2 -init;
  # Gtk2->init; works if you didn't use -init on use
  my $window = Gtk2::Window->new ('toplevel');
  my $button = Gtk2::Button->new ('Quit');
  $button->signal_connect (clicked => sub { Gtk2->main_quit });
  $window->add ($button);
  $window->show_all;
  Gtk2->main;

=head1 ABSTRACT

  Perl bindings to the 2.x series of the Gtk+ widget set.
  This module allows you to write graphical user interfaces in a 
  perlish and object-oriented way, freeing you from the casting
  and memory management in C, yet remaining very close in spirit
  to original API.

=head1 DESCRIPTION

The Gtk2 module allows a perl developer to use the Gtk+ graphical user
interface library.  Find out more about Gtk+ at http://www.gtk.org.

The GTK+ Reference Manual is also a handy companion when writing Gtk
programs in any language.  http://developer.gnome.org/doc/API/2.0/gtk/
The perl bindings follow the C API very closely, and the C reference
documentation should be considered the canonical source.

To discuss gtk2-perl, ask questions and flame/praise the authors,
join gtk-perl-list@gnome.org at lists.gnome.org.

Also have a look at the gtk2-perl website and sourceforge project page,
http://gtk2-perl.sourceforge.net

=head1 SEE ALSO

L<perl>(1), L<Glib>(3pm).

L<Gtk2::Gdk::Keysyms>(3pm) contains a hash of key codes, culled from
gdk/gdkkeysyms.h

L<Gtk2::api>(3pm) describes how to map the C API into perl, and some of the
important differences in the perl bindings.

L<Gtk2::Helper>(3pm) contains stuff that makes writing Gtk2 programs
a little easier.

L<Gtk2::SimpleList>(3pm) makes the GtkListStore and GtkTreeModel a I<lot>
easier to use.

L<Gtk2::Pango>(3pm) exports various little-used but important constants you
may need to work with pango directly.

Gtk2 also provides code to make it relatively painless to create perl
wrappers for other GLib/Gtk-based libraries.  See L<Gtk2::CodeGen>,
L<Glib::PkgConfig>, and L<ExtUtils::Depends>.  If you're writing bindings,
you'll probably also be interested in L<Gtk2::devel>, which is a supplement
to L<Glib::devel> and L<Glib::xsapi>.  The Binding Howto, at
http://gtk2-perl.sourceforge.net/doc/binding_howto.pod.html, ties it all
together.

=head1 AUTHORS

The gtk2-perl team:

 muppet E<lt>scott at asofyet dot orgE<gt>
 Ross McFarland E<lt>rwmcfa1 at neces dot comE<gt>
 Jörn Reder E<lt>joern at zyn dot deE<gt>
 Göran Thyni E<lt>gthyni at kirra dot netE<gt>
 Chas Owens E<lt>alas at wilma dot widomaker dot comE<gt>
 Guillaume Cottenceau E<lt>gc at mandrakesoft dot comE<gt>
 Marc Lehmann E<lt>pcg at goof dot comE<gt>

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
