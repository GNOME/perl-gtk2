package Gtk2::Dialog::Responses;

use strict;
require Exporter;
our @ISA = qw/Exporter/;

# normally you wouldn't export anything by default, but the only purpose
# of this module is to import constants into your namespace...
our @EXPORT = qw(
  GTK_RESPONSE_NONE
  GTK_RESPONSE_REJECT
  GTK_RESPONSE_ACCEPT
  GTK_RESPONSE_DELETE_EVENT
  GTK_RESPONSE_OK
  GTK_RESPONSE_CANCEL
  GTK_RESPONSE_CLOSE
  GTK_RESPONSE_YES
  GTK_RESPONSE_NO
  GTK_RESPONSE_APPLY
  GTK_RESPONSE_HELP
);


sub GTK_RESPONSE_NONE { -1 }
# GTK won't return these unless you pass them in
# as the response for an action widget. They are
# for your convenience.
#
sub GTK_RESPONSE_REJECT { -2 }
sub GTK_RESPONSE_ACCEPT { -3 }

# If the dialog is deleted.
sub GTK_RESPONSE_DELETE_EVENT { -4 }

# These are returned from GTK dialogs, and you can also use them
# yourself if you like.
#
sub GTK_RESPONSE_OK     { -5 }
sub GTK_RESPONSE_CANCEL { -6 }
sub GTK_RESPONSE_CLOSE  { -7 }
sub GTK_RESPONSE_YES    { -8 }
sub GTK_RESPONSE_NO     { -9 }
sub GTK_RESPONSE_APPLY  { -10 }
sub GTK_RESPONSE_HELP   { -11 }

1;

__END__

=head1 NAME

Gtk2::Dialog::Responses - Numeric response codes for Gtk2::Dialog's reponse signal

=head1 SYNOPSIS

  $dialog->signal_connect (response => sub {
                         my ($widget, $response) = @_;
                         use Gtk2::Dialog::Responses;
                         if ($response == GTK_RESPONSE_OK) {
                                 # everything is beautiful
                         } else {
                                 # everything sucks.
                         }
                         });

=head1 DESCRIPTION

There are two ways of using a Gtk2::Dialog -- synchronously (and modally), by
calling $dialog->run; or asynchrously (and possibly modally), by connecting
to the dialog's "response" signal.

The response ids may be any of an enumerated predefined set or any positive
integer that you like.

Unfortunately, while $dialog->run returns an enum value or number, there is
no way to hook code into the perl bindings for the response signal callback
to turn the integer code into an enumerated string type.

So, we have this module which allows you to use named constants in the
response signal handler instead of hard-coding in the negative number values
actually sent in.

=head2 EXPORTS

  GTK_RESPONSE_NONE
  GTK_RESPONSE_REJECT
  GTK_RESPONSE_ACCEPT
  GTK_RESPONSE_DELETE_EVENT
  GTK_RESPONSE_OK
  GTK_RESPONSE_CANCEL
  GTK_RESPONSE_CLOSE
  GTK_RESPONSE_YES
  GTK_RESPONSE_NO
  GTK_RESPONSE_APPLY
  GTK_RESPONSE_HELP

=head1 BUGS

This module shouldn't exist, except that this portion of the API just isn't
clean.

=head1 SEE ALSO

perl(1), Gtk2(3pm).

The BUGS section of L<Gtk2::Pango>.

=head1 AUTHORS

The gtk2-perl team.  muppet was the sucker who typed it in, straight from
the documentation for GtkDialog at 
http://developer.gnome.org/doc/API/2.0/gtk/GtkDialog.html#GtkResponseType .

=head1 LICENSE

Copyright 2003 by muppet

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
