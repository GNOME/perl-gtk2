#include "gtk2perl.h"

MODULE = Gtk2::ProgressBar	PACKAGE = Gtk2::ProgressBar	PREFIX = gtk_progress_bar_

## GtkWidget* gtk_progress_bar_new (void)
GtkWidget *
gtk_progress_bar_new (class, adjustment=NULL)
	SV                   * class
	GtkAdjustment_ornull * adjustment
    CODE:
	if(adjustment)
		RETVAL = gtk_progress_bar_new_with_adjustment(adjustment);
	else
		RETVAL = gtk_progress_bar_new();
    OUTPUT:
	RETVAL

## GtkWidget* gtk_progress_bar_new_with_adjustment (GtkAdjustment *adjustment)
GtkWidget *
gtk_progress_bar_new_with_adjustment (class, adjustment)
	SV            * class
	GtkAdjustment * adjustment
    C_ARGS:
	adjustment

## void gtk_progress_bar_set_text (GtkProgressBar *pbar, const gchar *text)
void
gtk_progress_bar_set_text (pbar, text)
	GtkProgressBar * pbar
	const gchar    * text

## void gtk_progress_bar_set_fraction (GtkProgressBar *pbar, gdouble fraction)
void
gtk_progress_bar_set_fraction (pbar, fraction)
	GtkProgressBar * pbar
	gdouble          fraction

## void gtk_progress_bar_set_pulse_step (GtkProgressBar *pbar, gdouble fraction)
void
gtk_progress_bar_set_pulse_step (pbar, fraction)
	GtkProgressBar * pbar
	gdouble          fraction

## void gtk_progress_bar_set_orientation (GtkProgressBar *pbar, GtkProgressBarOrientation orientation)
void
gtk_progress_bar_set_orientation (pbar, orientation)
	GtkProgressBar            * pbar
	GtkProgressBarOrientation   orientation

## gdouble gtk_progress_bar_get_fraction (GtkProgressBar *pbar)
gdouble
gtk_progress_bar_get_fraction (pbar)
	GtkProgressBar * pbar

## gdouble gtk_progress_bar_get_pulse_step (GtkProgressBar *pbar)
gdouble
gtk_progress_bar_get_pulse_step (pbar)
	GtkProgressBar * pbar

## GtkProgressBarOrientation gtk_progress_bar_get_orientation (GtkProgressBar *pbar)
GtkProgressBarOrientation
gtk_progress_bar_get_orientation (pbar)
	GtkProgressBar * pbar

## void gtk_progress_bar_set_bar_style (GtkProgressBar *pbar, GtkProgressBarStyle style)
void
gtk_progress_bar_set_bar_style (pbar, style)
	GtkProgressBar * pbar
	GtkProgressBarStyle style

## void gtk_progress_bar_set_discrete_blocks (GtkProgressBar *pbar, guint blocks)
void
gtk_progress_bar_set_discrete_blocks (pbar, blocks)
	GtkProgressBar * pbar
	guint blocks

## void gtk_progress_bar_set_activity_blocks (GtkProgressBar *pbar, guint blocks)
void
gtk_progress_bar_set_activity_blocks (pbar, blocks)
	GtkProgressBar * pbar
	guint blocks

## void gtk_progress_bar_update (GtkProgressBar *pbar, gdouble percentage)
void
gtk_progress_bar_update (pbar, percentage)
	GtkProgressBar * pbar
	gdouble          percentage

##void gtk_progress_bar_set_activity_step (GtkProgressBar *pbar, guint step)
void
gtk_progress_bar_set_activity_step (pbar, step)
	GtkProgressBar * pbar
	guint            step

##void gtk_progress_bar_pulse (GtkProgressBar *pbar)
void
gtk_progress_bar_pulse (pbar)
	GtkProgressBar * pbar

##G_CONST_RETURN gchar * gtk_progress_bar_get_text (GtkProgressBar *pbar)
const gchar *
gtk_progress_bar_get_text (pbar)
	GtkProgressBar * pbar

