#!/usr/bin/perl

use strict;
use warnings;

use Gtk2 '-init';

use constant TRUE => 1;
use constant FALSE => !TRUE;




### begin run type dialog
# if you want to pop up a simple dialog to get or provide some information this
# is probably the way you want to go. 

my $dialog = Gtk2::Dialog->new ('Run Dialog Demo', undef, 'modal',
	'gtk-ok' => 1,
	'_Reset' => 2,
);

# get the dialog's vbox to put some stuff into.
my $vbox = $dialog->vbox;

# put an hbox with a label and entry into the dialog's vbox area.
my $hbox = Gtk2::HBox->new (FALSE, 6);
$hbox->pack_start (Gtk2::Label->new ('Test:'), TRUE, TRUE, 0);
my $entry = Gtk2::Entry->new;
$hbox->pack_start ($entry, TRUE, TRUE, 0);
$vbox->pack_start ($hbox, TRUE, TRUE, 0);

# show the vbox so that it will be visible
$vbox->show_all;

# run the dialog
my $response = $dialog->run;
# when a button is clicked the dialog will go away and the response (clicked 
# button) will be returned from the call to run

print "The user clicked: $response\n";
print 'The text entry was: '.$entry->get_text."\n";




### begin callback type dialog
# we'll reuse the same dialog, but use it differently. this time only the ok
# button will exit the dialog, the reset button will empty the text entry. this
# type of dialog is useful in cases where persistence is desired.

# change the dialog's title
$dialog->set (title => 'Callback Dialog Demo');

# connect a signal to the dialog's response signal.
$dialog->signal_connect (response => sub {
		# get our params
		shift; # we don't need the dialog
		$response = shift;	# the clicked button

		print "The user clicked: $response\n";
		print 'The text entry was: '.$entry->get_text."\n";
		if ($response == 1)
		{
			# the user clicked ok
			Gtk2->main_quit;
		}
		else # if ($response == 2)
		{
			# the user clicked reset
			$entry->set_text ('');
		}
	});

# show the dialog
$dialog->show;
# and enter a main loop so that it will become interactice, the main loop will
# be quit by clicking ok. 
Gtk2->main;
