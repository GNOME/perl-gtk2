#
# $Header$
#

#########################
# GtkAboutDialog Tests
# 	- rm
#########################

#########################

use strict;
use warnings;

use Gtk2::TestHelper tests => 16,
    at_least_version => [2, 5, 0, "GtkAboutDialog is new in 2.6"], # FIXME: 2.6
    ;

isa_ok (my $dialog = Gtk2::AboutDialog->new, 'Gtk2::AboutDialog',
	'Gtk2::AboutDialog->new');

$dialog->set_name ('AboutDialog');
is ($dialog->get_name, 'AboutDialog', '$dialog->set|get_name');

$dialog->set_version ('Ver: 1.2');
is ($dialog->get_version, 'Ver: 1.2', '$dialog->set|get_version');

$dialog->set_version ('Ver: 1.2');
is ($dialog->get_version, 'Ver: 1.2', '$dialog->set|get_version');

$dialog->set_copyright ('2004');
is ($dialog->get_copyright, '2004', '$dialog->set|get_copyright');

$dialog->set_comments ('this is a comment');
is ($dialog->get_comments, 'this is a comment', '$dialog->set|get_comments');

$dialog->set_license ('LGPL');
is ($dialog->get_license, 'LGPL', '$dialog->set|get_license');

$dialog->set_authors (qw/one two three/);
ok (eq_array ([$dialog->get_authors], [qw/one two three/]),
    '$dialog->set|get_authors');

$dialog->set_documenters (qw/two three four/);
ok (eq_array ([$dialog->get_documenters], [qw/two three four/]),
    '$dialog->set|get_documenters');

$dialog->set_artists (qw/three four five/);
ok (eq_array ([$dialog->get_artists], [qw/three four five/]),
    '$dialog->set|get_artists');

$dialog->set_translator_credits ('people');
is ($dialog->get_translator_credits, 'people',
    '$dialog->set|get_transltor_credits');

is ($dialog->get_logo, undef, '$dialog->get_logo undef');
my $pb = Gtk2::Gdk::Pixbuf->new ('rgb', TRUE, 8, 61, 33);
$dialog->set_logo ($pb);
isa_ok ($dialog->get_logo, 'Gtk2::Gdk::Pixbuf', '$dialog->set|get_logo');

$dialog->set_logo_icon_name ('gtk-ok');
is ($dialog->get_logo_icon_name, 'gtk-ok',
    '$dialog->set|get_logo_icon_name');

$dialog->set_email_hook (sub { warn @_; }, "urgs");
$dialog->set_email_hook (sub { warn @_; });

$dialog->set_url_hook (sub { warn @_; }, "urgs");
$dialog->set_url_hook (sub { warn @_; });

$dialog->set_website_label ('website');
is ($dialog->get_website_label, 'website', '$dialog->set|get_website_label');

$dialog->set_website ('http://gtk2-perl.sourceforge.net/');
is ($dialog->get_website, 'http://gtk2-perl.sourceforge.net/', 
    '$dialog->set|get_website');
