#!/usr/bin/perl -w

use blib '../../G';
use blib '../..';
use blib '../';

# $Header$

package Histogram::Plot;

use Gtk2;
use warnings;
use strict;

use constant FALSE => 0;
use constant TRUE => 1;

use constant MIN_CHART_WIDTH  => 256;
use constant MIN_CHART_HEIGHT => 100;

my %drag_info;
use constant DRAG_PAD => 2;

sub SCREEN_TO_THRESHOLD {
	my ($plot, $sx) = @_;
	my $data = $plot->get_data ('data');
	my $val = ($sx - $data->{chartleft}) * 256 / $data->{chartwidth};
	return $val < 0 ? 0 : $val > 255 ? 255 : $val;
}
sub THRESHOLD_TO_SCREEN {
	my $data = $_[0]->get_data ('data');
	$_[1] / 256.0 * $data->{chartwidth} + $data->{chartleft}
}

####static GtkDrawingAreaClass * parent_class = NULL;
my $threshold_changed_signal = 0;

G::Type->register ("Gtk2::DrawingArea", __PACKAGE__);

=out

sub histogram_plot_class_init {
	my $class = shift;

	GObjectClass * object_class = G_OBJECT_CLASS (class);
	GtkWidgetClass * widget_class = GTK_WIDGET_CLASS (class);

	parent_class = g_type_class_peek_parent (class);

	widget_class->size_request = histogram_plot_size_request;
	object_class->finalize = histogram_plot_finalize;

	$threshold_changed_signal = 
		g_signal_new ("threshold_changed",
			      G_OBJECT_CLASS_TYPE (object_class),
			      G_SIGNAL_RUN_FIRST,
			      G_STRUCT_OFFSET (LiarHistogramPlotClass, 
					       threshold_changed),
			      NULL, NULL,
			      g_cclosure_marshal_VOID__VOID,
			      G_TYPE_NONE, 0);
}

=cut

sub INSTANCE_INIT {
	my $plot = shift;
	warn "INSTANCE_INIT $plot";

	$plot->set_data(data => {
		threshold       => 0,
		histogram       => [ 0..255 ],
		pixmap          => undef,
		th_gc           => undef,
		dragging        => FALSE,
		origin_layout   => $plot->create_pango_layout ("0.0%"),
		maxval_layout   => $plot->create_pango_layout ("100.0%"),
		current_layout  => $plot->create_pango_layout ("0"),
		maxscale_layout => $plot->create_pango_layout ("255"),
		minscale_layout => $plot->create_pango_layout ("0"),
		max             => 0,

		chartwidth      => 0,
		chartleft       => 0,
		bottom          => 0,
		height          => 0,
	});
}

sub member : lvalue { $_[0]->get_data ('data')->{$_[1]} }

sub threshold : lvalue { $_[0]->member ('threshold') }
sub histogram : lvalue { $_[0]->member ('histogram') }
sub pixmap : lvalue { $_[0]->member ('pixmap') }
sub th_gc : lvalue { $_[0]->member ('th_gc') }
sub dragging : lvalue { $_[0]->member ('dragging') }
sub origin_layout : lvalue { $_[0]->member ('origin_layout') }
sub maxval_layout : lvalue { $_[0]->member ('maxval_layout') }
sub current_layout : lvalue { $_[0]->member ('current_layout') }
sub maxscale_layout : lvalue { $_[0]->member ('maxscale_layout') }
sub minscale_layout : lvalue { $_[0]->member ('minscale_layout') }
sub max : lvalue { $_[0]->member ('max') }

=out

sub histogram_plot_finalize {
	my $plot = shift;

	LiarHistogramPlot * plot;

	g_return_if_fail (object != NULL);
	g_return_if_fail (LIAR_IS_HISTOGRAM_PLOT (object));

	plot = LIAR_HISTOGRAM_PLOT (object);
	
	if (plot->pixmap) {
		g_object_unref (G_OBJECT (plot->pixmap));
		plot->pixmap = NULL;
	}
	if (plot->th_gc) {
		g_object_unref (G_OBJECT (plot->th_gc));
		plot->th_gc = NULL;
	}
	if (plot->origin_layout) {
		g_object_unref (G_OBJECT (plot->origin_layout));
		g_object_unref (G_OBJECT (plot->maxval_layout));
		g_object_unref (G_OBJECT (plot->current_layout));
		g_object_unref (G_OBJECT (plot->maxscale_layout));
		g_object_unref (G_OBJECT (plot->minscale_layout));
		plot->origin_layout = NULL;
	}

	G_OBJECT_CLASS (parent_class)->finalize (object);
}

=cut


sub calc_dims {
	my $plot = shift;

	my $data = $plot->get_data ('data');

	my $context = $data->{origin_layout}->get_context;
	my $fontdesc = $context->get_font_description;
	my $metrics = $context->get_metrics ($fontdesc, undef);

	$data->{textwidth} = 5 * $metrics->get_approximate_digit_width
			   / Gtk2::Pango->scale; #PANGO_SCALE;
	$data->{textheight} = ($metrics->get_descent + $metrics->get_ascent)
		            / Gtk2::Pango->scale; #PANGO_SCALE;
	
	#pango_font_metrics_unref (metrics);
	
	$data->{chartleft} = $data->{textwidth} + 2;
	$data->{chartwidth} = $plot->allocation->width - $data->{chartleft};
	$data->{bottom} = $plot->allocation->height - $data->{textheight} - 3;
	$data->{height} = $data->{bottom};
}


sub size_request {
	my ($plot, $requisition) = @_;

	my $data = $plot->get_data ('data');
	$requisition->width = $data->{textwidth} + 2 + MIN_CHART_WIDTH;
	$requisition->height = $data->{textheight} + MIN_CHART_HEIGHT;

##	return $requisition;
}


sub expose_event {
	my ($plot, $event) = @_;

	$plot->window->draw_drawable ($plot->style->fg_gc($plot->state),
				      $plot->pixmap,
				      $event->area->x, $event->area->y,
				      $event->area->x, $event->area->y,
				      $event->area->width, $event->area->height);
	return FALSE;
}

sub configure_event {
	my ($plot, $event) = @_;

#	if ($plot->pixmap)
#		g_object_unref (G_OBJECT (plot->pixmap));

	$plot->pixmap = Gtk2::Gdk::Pixmap->new ($plot->window,
					        $plot->allocation->width,
					        $plot->allocation->height,
						-1); # same depth as window

	# update dims
	$plot->calc_dims;

	$plot->histogram_draw;

	return TRUE;
}

sub draw_th_marker {
	my ($plot, $w, $draw_text) = @_;

	my $data = $plot->get_data ('data');

	if ( ! $data->{th_gc} ) {
		#GdkGCValues values;
		#gdk_gc_get_values ($plot->style->fg_gc($plot->state),
   		#		   &values);
		#plot->th_gc = gdk_gc_new_with_values (plot->pixmap, &values,
   		#				      GDK_GC_FOREGROUND 
   		#				      | GDK_GC_BACKGROUND 
   		#				      | GDK_GC_LINE_STYLE 
   		#				      | GDK_GC_LINE_WIDTH);
		#$plot->th_gc = $plot->style->fg_gc ($plot->state)->copy;
		$data->{th_gc} = Gtk2::Gdk::GC->new ($data->{pixmap});
		$data->{th_gc}->copy ($plot->style->fg_gc ($plot->state));
		$data->{th_gc}->set_function ('invert');
	}
	$w->draw_line ($data->{th_gc},
		       $plot->THRESHOLD_TO_SCREEN ($data->{threshold}), 0,
		       $plot->THRESHOLD_TO_SCREEN ($data->{threshold}), $data->{bottom});

	$data->{current_layout}->set_text (sprintf '%d', $data->{threshold});
	my ($textwidth, $textheight) = $data->{current_layout}->get_pixel_size;
	$data->{marker_textwidth} = $textwidth;

	# erase text
	$w->draw_rectangle ($plot->style->bg_gc($plot->state), 
			    TRUE,
			    $plot->THRESHOLD_TO_SCREEN ($data->{threshold})
			    	- $data->{marker_textwidth} - 1,
			    $data->{bottom} + 1,
			    $data->{marker_textwidth} + 1,
			    $textheight);

	$w->draw_layout ($plot->th_gc, 
			 $plot->THRESHOLD_TO_SCREEN ($data->{threshold})
				 	- $data->{marker_textwidth},
				 $data->{bottom} + 1,
				 $data->{current_layout})
		if $draw_text;
}

#
# the user can click either very near the vertical line of the marker
# or on (actually in the bbox of) the marker text.
#
sub marker_hit {
	my ($plot, $screen_x, $screen_y) = @_;

	my $data = $plot->get_data ('data');

	my $screen_th = $plot->THRESHOLD_TO_SCREEN ($data->{threshold});
	if ($screen_y > $data->{bottom}) {
		# check for hit on text
		if ($screen_x > $screen_th - $data->{marker_textwidth} &&
		    $screen_x <= $screen_th) {
			return $screen_th;
		}
	} else {
		# check for hit on line
		if ($screen_x > $screen_th - DRAG_PAD &&
		    $screen_x < $screen_th + DRAG_PAD) {
			return $screen_th;
		}
	}
	return undef;
}

sub button_press_event {
	#( GtkWidget         * widget, /* actually same as plot */
	#	    GdkEventButton    * event,
	#	    LiarHistogramPlot * plot ) /* actually same as widget */
	my ($plot, $event) = @_;

	my $data = $plot->get_data ('data');

	return FALSE
		if ($event->button != 1 || $data->{pixmap} == undef);

	my $sx = $plot->marker_hit ($event->x, $event->y);
	return FALSE
		unless defined $sx;

	# erase the previous threshold line from the pixmap...
	$data->{threshold_back} = $data->{threshold};
	$plot->draw_th_marker ($data->{pixmap}, FALSE);
	$plot->window->draw_drawable ($plot->style->fg_gc($plot->state),
				      $data->{pixmap},
			$plot->THRESHOLD_TO_SCREEN ($data->{threshold}) - $data->{marker_textwidth}, 0,
			$plot->THRESHOLD_TO_SCREEN ($data->{threshold}) - $data->{marker_textwidth}, 0,
			$data->{marker_textwidth} + 1, $plot->allocation->height);
	# and draw the new one on the window.
	$plot->draw_th_marker ($plot->window, TRUE);
	$data->{dragging} = TRUE;

	$drag_info{offset_x} = 
		$plot->THRESHOLD_TO_SCREEN ($data->{threshold}) - $event->x;

	return TRUE;
}

sub button_release_event {
	#(GtkWidget         * widget, /* same as plot */
	# GdkEventButton    * event,
	# LiarHistogramPlot * plot) /* same as widget */
	my ($plot, $event) = @_;

	my $data = $plot->get_data ('data');

	return FALSE
		if ($event->button != 1 
		    || !$data->{dragging}
		    || $data->{pixmap} == undef);

	# erase the previous threshold line from the window...
	$plot->draw_th_marker ($plot->window, FALSE);
	$data->{threshold} = 
		$plot->SCREEN_TO_THRESHOLD ($event->x + $drag_info{offset_x});
	# and draw the new one on the pixmap.
	$plot->draw_th_marker ($data->{pixmap}, TRUE);
	$plot->window->draw_drawable ($plot->style->fg_gc ($plot->state),
				      $data->{pixmap},
				      0, 0, 0, 0,
				      $plot->allocation->width,
				      $plot->allocation->height);
	$data->{dragging} = FALSE;
#	$plot->signal_emit ($threshold_changed_signal, 0)
#		if $plot->threshold_back != $plot->threshold;

	return TRUE;
}

my $sizer;

sub motion_notify_event {
	my ($plot, $event) = @_;

	my ($x, $y, $state);

	if ($event->is_hint) {
		(undef, $x, $y, $state) = $event->window->get_pointer;
	} else {
		$x = $event->x;
		$y = $event->y;
		$state = $event->state;
	}
	#warn "x $x y $y state $state\n";

	if ($plot->dragging) {
		return FALSE
			##if (!(state & GDK_BUTTON1_MASK) ||
			if (!(grep /button1-mask/, @$state) ||
			    $plot->pixmap == undef);
		
		$plot->draw_th_marker ($plot->window, FALSE);
		
		$x += $drag_info{offset_x};
		
		# confine to valid region
		my $t = $plot->SCREEN_TO_THRESHOLD ($x);
		$x = $plot->THRESHOLD_TO_SCREEN (0) if $t < 0;
		$x = $plot->THRESHOLD_TO_SCREEN (255) if $t > 255;
		
		$plot->threshold = $plot->SCREEN_TO_THRESHOLD ($x);
		$plot->draw_th_marker ($plot->window, TRUE);

	} else {
		my $c = undef;
		my $sx = $plot->marker_hit ($x, $y);
		if (defined $sx) {
			$sizer = Gtk2::Gdk::Cursor->new ('GDK_SB_H_DOUBLE_ARROW')
				if not defined $sizer;
			$c = $sizer;
		}
		$plot->window->set_cursor ($c);
	}

	return TRUE;
}



sub histogram_draw {
	my $plot = shift;
	my $gc = $plot->style->fg_gc ($plot->state);

	my $data = $plot->get_data ('data');
#	use Data::Dumper;
#	print Dumper($data);

	# erase (the hard way)
	$plot->pixmap->draw_rectangle ($plot->style->bg_gc ($plot->state),
	                               TRUE, 0, 0,
				       $plot->allocation->width,
				       $plot->allocation->height);

	if ($data->{max} != 0) {
		##GdkPoint points[256+2];
		my @hist = @{ $data->{histogram} };
		my @points = ();
		for (my $i = 0; $i < 256; $i++) {
			push @points,
				$i/256.0 * $data->{chartwidth} + $data->{chartleft},
				$data->{bottom} - $data->{height} * $hist[$i] / $data->{max};
		}
		$data->{pixmap}->draw_polygon ($gc, TRUE, @points,
		              $plot->allocation->width, $data->{bottom} + 1,
		              $data->{chartleft}, $data->{bottom} + 1);
	}
	# mark threshold
	# should draw this after the scale...
	draw_th_marker ($plot, $data->{pixmap}, TRUE);
	# the annotations
	$data->{pixmap}->draw_line ($gc, 0, 0, $data->{chartleft}, 0);
	$data->{pixmap}->draw_line ($gc, 0, $data->{bottom},
				  $data->{chartleft}, $data->{bottom});
	$data->{pixmap}->draw_line ($gc, $data->{chartleft}, $data->{bottom}, 
				  $data->{chartleft},
				  $data->{bottom} + $data->{textheight} + 1);
	$data->{pixmap}->draw_line ($gc,
		       $plot->allocation->width - 1, $data->{bottom},
		       $plot->allocation->width - 1, $data->{bottom} + $data->{textheight} + 1);
	$data->{pixmap}->draw_layout ($gc,
			 $data->{chartleft} - (1 + $data->{textwidth}),
			 1, $plot->maxval_layout);
	$data->{pixmap}->draw_layout ($gc,
			 $data->{chartleft} - (1 + $data->{textwidth}),
			 $data->{bottom} - 1 - $data->{textheight}, 
			 $data->{origin_layout});
	$data->{pixmap}->draw_layout ($gc,
			 $data->{chartleft} + 2, $data->{bottom} + 1,
			 $data->{minscale_layout});
}

#####

###
## @brief create a new histogram plot
##
## @return pointer to the LiarHistogramPlot.
###
sub new {
	my $class = shift;
	#my $plot = G::Object->_new ('Histogram::Plot');
	my $plot = Gtk2::Widget->new ('Histogram::Plot');
	print "$plot\n";

	$plot->signal_connect (expose_event => \&expose_event);
	$plot->signal_connect (configure_event => \&configure_event);
	$plot->signal_connect (motion_notify_event => \&motion_notify_event);
	$plot->signal_connect (button_press_event => \&button_press_event);
	$plot->signal_connect (button_release_event => \&button_release_event);

	$plot->set_events ([qw/exposure-mask
			       leave-notify-mask
			       button-press-mask
			       button-release-mask
			       pointer-motion-mask
			       pointer-motion-hint-mask/]);

	return $plot;
}

###
## @brief create a new histogram plot with a given dataset
##
## @param hist the histogram with which to initialize.  must be 256 elements long.
## @param threshold initial threshold.
##
## @return pointer to the LiarHistogramPlot.
###
sub new_with_data {
	my $class = shift;
	my $threshold = shift;
	my @hist = @_;

	my $plot = Histogram::Plot->new;

	$plot->set_plot_data ($threshold, @hist);

	return $plot;
}


###
## @brief redraw the window.
##
## useful after histogram_window_setdata.
###
sub update {
	my $plot = shift;
	# if the pixmap doesn't exist, we haven't been put on screen yet.
	# don't bother drawing anything.
	if ($plot->pixmap) {
		$plot->histogram_draw;
		$plot->queue_draw;
	}
}


###
## @brief change the data displayed in the window.
##
## @note you will need to call histogram_window_update to see the changes
## you make here.
## @param histogram new histogram.  if not NULL, copy to the histwin's
##                  internal histogram cache. MUST be 256 items long.
## @param threshold new threshold.  ignored if undef.
###
sub set_plot_data {
	my ($plot, $threshold, @hist) = @_;
	#warn "$plot->set_plot_data";

	$plot->threshold = $threshold if defined $threshold;
	#$plot->set_data (threshold => $threshold) if defined $threshold;

	if (@hist) {
		my $total = 0;
		my $max = 0;
		for (my $i = 0; $i < 256; $i++) {
			$total += $hist[$i];
			$max = $hist[$i]
				if $hist[$i] > $max;
		}
		$plot->max = $max;
		#$plot->set_data (max => $max);
		$plot->histogram = \@hist;
		#$plot->set_data (histogram => \@hist);
		$plot->maxval_layout->set_text 
			( sprintf "%4.1f%%", (100.0 * $plot->max) / $total );
	}


	# update dims since text may have changed
	$plot->calc_dims;

	$plot->update;
}


###
## @brief retrieve the data displayed in the window.
##
## @param histogram if not NULL, destination for the histogram.
##                  MUST be a pointer to an array at least 256 items long.
##                  if NULL, don't retrieve the histogram.
## @param threshold if not NULL, destination for the threshold.
###
sub get_plot_data {
	my $plot;
	return $plot->threshold, @{ $plot->histogram };
}






package main;

use Gtk2;

Gtk2->init;


my $window = Gtk2::Window->new;
$window->signal_connect (delete_event => sub { Gtk2->main_quit; 1 });

my $plot = Histogram::Plot->new_with_data (127,
                                  map { sin $_/256*3.1415 } (0..255));

$window->add ($plot);

$window->show_all;

Gtk2->main;
