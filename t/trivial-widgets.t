#
# $Header$
#

use strict;
use warnings;

#########################
# Trivial Widgets Tests
#
# Tested:
#	Gtk2::InputDialog
#	Gtk2::EventBox
#	Gtk2::Arrow
#	Gtk2::AspectFrame
#
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if (Gtk2->init_check)
{
	plan tests => 12;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

my $tmp;

# creating it is enough, it's only a parent with it's own new???
ok ($tmp = Gtk2::InputDialog->new, 'Gtk2::InputDialog->new');
ok ($tmp = Gtk2::EventBox->new, 'Gtk2::EventBox->new');

ok ($tmp = Gtk2::Arrow->new ('up', 'none'), 'Gtk2::Arrow->new');
ok (eq_array ([$tmp->get (qw/arrow-type shadow-type/)],
	['up', 'none']), '$arrow->new, verify');
$tmp->set ('down', 'in');
ok (eq_array ([$tmp->get (qw/arrow-type shadow-type/)],
	['down', 'in']), '$arrow->set, verify');

ok ($tmp = Gtk2::CheckButton->new, 'Gtk2::CheckButton->new');
ok ($tmp = Gtk2::CheckButton->new ('_Label'), 'Gtk2::CheckButton->new (lbl)');
ok ($tmp = Gtk2::CheckButton->new_with_mnemonic ('_Label'),
	'Gtk2::CheckButton->new_with_mnemonic ($lbl)');
ok ($tmp = Gtk2::CheckButton->new_with_label ('Label'),
	'Gtk2::CheckButton->new_with_label ($lbl)');

ok ($tmp = Gtk2::AspectFrame->new ('Label', 1, 1, 3, 0), 
	'Gtk2::AspectFrame->new');
ok (eq_array ([$tmp->get (qw/xalign yalign ratio obey-child/)],
	[1, 1, 3, 0]), '$aspect->new, verify');
$tmp->set_params (1, 1,  6, 1);
ok (eq_array ([$tmp->get (qw/xalign yalign ratio obey-child/)],
	[1, 1, 6, 1]), '$aspect->set_params, verify');

1;

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list) See LICENSE for more information.
