#!/usr/bin/perl

#
# $Header$
#
# There are 2 rules that must be followed in order to successfully Gtk2 in a
# threaded application. The first is only touch the gui elements from one of
# the two threads. The second is that all threads need to be spawned _before_
# any Glib/Gtk2 objects have been created.
#
# TODO/FIXME: if you click Quit, exits are enqueued and main_quit called, so
# there's still work being done, but the ui is no longer responsive.
#
# -rm
#

use strict;
use warnings;

use threads;
use Thread::Queue;

use Glib qw(TRUE FALSE);
use Gtk2 '-init';

# rule 2, all threads spawned before any Glib/Gtk2 variables
my $numworkers = 3;
my $workqueue = Thread::Queue->new;
my @thrds = ();
foreach (0..$numworkers)
{
	my $retqueue = Thread::Queue->new;
	push @thrds, {
		thrd => threads->new (\&worker_thread, $workqueue, $retqueue),
		retq => $retqueue,
		num  => $_,
	}
}
# we now have 3 workers waiting to do our bidding

# now build up the ui
my $win = Gtk2::Window->new;
$win->set_title ('Thread Usage');
$win->set_border_width (6);
$win->set_default_size (400, 170);

my $hbox = Gtk2::HBox->new (FALSE, 6);
$win->add ($hbox);

my $vbox = Gtk2::VBox->new (FALSE, 6);
$hbox->pack_start ($vbox, TRUE, TRUE, 0);
my ($frame, $label);
# for each of the worker threads, add a status display
foreach (0..$numworkers)
{
	$frame = Gtk2::Frame->new ("Worker $_");
	$vbox->pack_start ($frame, FALSE, FALSE, 0);
	$label = Gtk2::Label->new ('Idle');
	$frame->add ($label);
	$thrds[$_]->{label} = $label;
}

$vbox = Gtk2::VBox->new (FALSE, 6);
$hbox->pack_start ($vbox, FALSE, FALSE, 6);

$frame = Gtk2::Frame->new ('Pending Commands');
$vbox->pack_start ($frame, FALSE, FALSE, 0);
$label = Gtk2::Label->new (0);
$frame->add ($label);

# a button to push jobs onto the command queue
my $btn = Gtk2::Button->new ('_Spawn Job');
$vbox->pack_start ($btn, FALSE, FALSE, 0);
$btn->signal_connect (clicked => sub {
		$workqueue->enqueue (rand);
	});

# a sub that sends as many exit commands as we have threads.
# we have to make sure that each thread would only take up 
# a single exit.
sub queue_exits 
{
	foreach (@thrds)
	{
		$workqueue->enqueue ('exit');
	}
}

$btn = Gtk2::Button->new ('_Queue Exits');
$vbox->pack_start ($btn, FALSE, FALSE, 0);
# queue the threads exit, not the app though
$btn->signal_connect (clicked => \&queue_exits);

$btn = Gtk2::Button->new ('_Quit');
$vbox->pack_start ($btn, FALSE, FALSE, 0);
# queue the threads exit and exit the gui app
$btn->signal_connect (clicked => sub {
		# won't hurt to queue too many exits, this way
		# we'll be sure to have the threads, and thus the app
		# exit
		queue_exits (); 
		Gtk2->main_quit;
	});

# the magic of how we follow rule number 1, a timeout callback.
Glib::Timeout->add (250, sub {
		my $tmp;
		# check on the status of each of the threads
		foreach (@thrds)
		{
			# don't block, that would be really bad.
			$tmp = $_->{retq}->dequeue_nb;
			# if there was something waiting for us
			# update the ui with it
			$_->{label}->set_text ($tmp) if ($tmp);
		}
		# update the pending commands display
		$label->set_text ($workqueue->pending);
		1;
	});

$win->show_all;
Gtk2->main;

# clean up after ourselves, after main_quit is called we will block here
# until all threads have exited, it is important that each thread have 
# an exit command waitting for it by this point.
foreach (@thrds)
{
	print 'Waiting on thread '.$_->{num}.', which did '
	    . $_->{thrd}->join." jobs\n";
}

################################################################################

sub worker_thread
{
	my $workq = shift;
	my $retq = shift;

	$retq->enqueue ('Waiting');

	my $jobs = 0;
	while (1)
	{
		my $work = $workq->dequeue;
		if ($work eq 'exit')
		{
			$retq->enqueue ("Exiting");
			return $jobs;
		}
		$retq->enqueue ("Working on $work");
		sleep 10;	# fake working real hard
		$retq->enqueue ("Done with $work");
		$jobs++;
	}
}
