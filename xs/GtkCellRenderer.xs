/*
 * Copyright (c) 2003 by the gtk2-perl team (see the file AUTHORS)
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the 
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
 * Boston, MA  02111-1307  USA.
 *
 * $Header$
 */

#include "gtk2perl.h"

#define newSVGdkRectangle_ornull(r)	\
	((r) ? newSVGdkRectangle(r) : newSVsv (&PL_sv_undef))
#define newSVGdkEvent_ornull(e)	\
	((e) ? newSVGdkEvent(e) : newSVsv (&PL_sv_undef))
#define newSVGChar_ornull(s)	\
	((s) ? newSVGChar(s) : newSVsv (&PL_sv_undef))


static void gtk2perl_cell_renderer_class_init
                                      (GtkCellRendererClass * class);
static void gtk2perl_cell_renderer_get_size
                                      (GtkCellRenderer      * cell,
				       GtkWidget            * widget,
				       GdkRectangle         * cell_area,
				       gint                 * x_offset,
				       gint                 * y_offset,
				       gint                 * width,
				       gint                 * height);
static void gtk2perl_cell_renderer_render
                                      (GtkCellRenderer      * cell,
#if GTK_CHECK_VERSION(2,3,0)
                                       GdkDrawable          * window,
#else
				       GdkWindow            * window,
#endif
				       GtkWidget            * widget,
				       GdkRectangle         * background_area,
				       GdkRectangle         * cell_area,
				       GdkRectangle         * expose_area,
				       GtkCellRendererState   flags);
static gboolean gtk2perl_cell_renderer_activate
                                      (GtkCellRenderer      * cell,
				       GdkEvent             * event,
				       GtkWidget            * widget,
				       const gchar          * path,
				       GdkRectangle         * background_area,
				       GdkRectangle         * cell_area,
				       GtkCellRendererState   flags);
static GtkCellEditable * gtk2perl_cell_renderer_start_editing
                                      (GtkCellRenderer      * cell,
				       GdkEvent             * event,
				       GtkWidget            * widget,
				       const gchar          * path,
				       GdkRectangle         * background_area,
				       GdkRectangle         * cell_area,
				       GtkCellRendererState   flags);

/*
 * this mangles a CellRendererClass to call the local marshallers.
 * you should only ever call this on a new subclass of CellRenderer, never
 * directly on a preexisting CellRendererClass.
 */
static void
gtk2perl_cell_renderer_class_init (GtkCellRendererClass * class)
{
	class->get_size      = gtk2perl_cell_renderer_get_size;
	class->render        = gtk2perl_cell_renderer_render;
	class->activate      = gtk2perl_cell_renderer_activate;
	class->start_editing = gtk2perl_cell_renderer_start_editing;
}

/*
 * the following functions look for on_whatever in the package belonging
 * to a cell.  this is our custom override, since CellRenderer does not
 * have signals for these virtual methods.
 */

static void
gtk2perl_cell_renderer_get_size (GtkCellRenderer      * cell,
				 GtkWidget            * widget,
				 GdkRectangle         * cell_area,
				 gint                 * x_offset,
				 gint                 * y_offset,
				 gint                 * width,
				 gint                 * height)
{
	HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (cell));
	SV ** slot = hv_fetch (stash, "on_get_size",
	                       sizeof ("on_get_size") - 1, 0);

	if (slot && GvCV (*slot)) {
		int count, i;
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		EXTEND (SP, 3);
		PUSHs (newSVGtkCellRenderer (cell));
		PUSHs (newSVGtkWidget (widget));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));

		PUTBACK;
		count = call_sv ((SV *)GvCV (*slot), G_ARRAY);
		SPAGAIN;
		if (count != 4)
			croak ("on_get_size must return four values -- "
			       "the x_offset, y_offset, width, and height");

		i = POPi;  if (height)   *height   = i;
		i = POPi;  if (width)    *width    = i;
		i = POPi;  if (y_offset) *y_offset = i;
		i = POPi;  if (x_offset) *x_offset = i;

		PUTBACK;
		FREETMPS;
		LEAVE;
	}
}

static void
gtk2perl_cell_renderer_render (GtkCellRenderer      * cell,
#if GTK_CHECK_VERSION(2,3,0)
			       GdkDrawable          * drawable,
#else
			       GdkWindow            * drawable,
#endif
			       GtkWidget            * widget,
			       GdkRectangle         * background_area,
			       GdkRectangle         * cell_area,
			       GdkRectangle         * expose_area,
			       GtkCellRendererState   flags)
{
	HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (cell));
	SV ** slot = hv_fetch (stash, "on_render", sizeof ("on_render") - 1, 0);

	if (slot && GvCV (*slot)) {
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		EXTEND (SP, 7);
		PUSHs (newSVGtkCellRenderer (cell));
		PUSHs (newSVGdkDrawable_ornull (drawable));
		PUSHs (newSVGtkWidget_ornull (widget));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (background_area)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (expose_area)));
		PUSHs (sv_2mortal (newSVGtkCellRendererState (flags)));

		PUTBACK;
		call_sv ((SV *)GvCV (*slot), G_VOID|G_DISCARD);

		FREETMPS;
		LEAVE;
	}
}

static gboolean
gtk2perl_cell_renderer_activate (GtkCellRenderer      * cell,
				 GdkEvent             * event,
				 GtkWidget            * widget,
				 const gchar          * path,
				 GdkRectangle         * background_area,
				 GdkRectangle         * cell_area,
				 GtkCellRendererState   flags)
{
	gboolean retval = FALSE;
	HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (cell));
	SV ** slot = hv_fetch (stash, "on_activate",
	                       sizeof ("on_activate") - 1, 0);

	if (slot && GvCV (*slot)) {
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		XPUSHs (newSVGtkCellRenderer (cell));
		XPUSHs (sv_2mortal (newSVGdkEvent_ornull (event)));
		XPUSHs (newSVGtkWidget_ornull (widget));
		XPUSHs (sv_2mortal (newSVGChar_ornull (path)));
		XPUSHs (sv_2mortal (newSVGdkRectangle_ornull (background_area)));
		XPUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));
		XPUSHs (sv_2mortal (newSVGtkCellRendererState (flags)));

		PUTBACK;
		call_sv ((SV*) GvCV (*slot), G_SCALAR);
		SPAGAIN;

		retval = POPi;

		PUTBACK;
		FREETMPS;
		LEAVE;
	}

	return retval;
}

static GtkCellEditable *
gtk2perl_cell_renderer_start_editing (GtkCellRenderer      * cell,
				      GdkEvent             * event,
				      GtkWidget            * widget,
				      const gchar          * path,
				      GdkRectangle         * background_area,
				      GdkRectangle         * cell_area,
				      GtkCellRendererState   flags)
{
	GtkCellEditable * editable = NULL;

	HV * stash = gperl_object_stash_from_type (G_OBJECT_TYPE (cell));
	SV ** slot = hv_fetch (stash, "on_start_editing",
	                       sizeof ("on_start_editing") - 1, 0);

	if (slot && GvCV (*slot)) {
		SV * sv;
		dSP;

		ENTER;
		SAVETMPS;
		PUSHMARK (SP);

		EXTEND (SP, 7);
		PUSHs (newSVGtkCellRenderer (cell));
		PUSHs (sv_2mortal (newSVGdkEvent_ornull (event)));
		PUSHs (newSVGtkWidget_ornull (widget));
		PUSHs (sv_2mortal (newSVGChar_ornull (path)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (background_area)));
		PUSHs (sv_2mortal (newSVGdkRectangle_ornull (cell_area)));
		PUSHs (sv_2mortal (newSVGtkCellRendererState (flags)));

		PUTBACK;
		call_sv ((SV*) GvCV (*slot), G_SCALAR);
		SPAGAIN;

		sv = POPs;
		editable = SvOK (sv)
		         ? GTK_CELL_EDITABLE (SvGObject (sv))
		         : NULL;

		PUTBACK;
		FREETMPS;
		LEAVE;
	}

	return editable;
}



MODULE = Gtk2::CellRenderer	PACKAGE = Gtk2::CellRenderer	PREFIX = gtk_cell_renderer_

=for object Gtk2::CellRenderer - An object that renders a single cell onto a Gtk2::Gdk::Drawable

=head1 DESCRIPTION

The Gtk2::CellRenderer is the base class for objects which render cells
onto drawables.  These objects are used primarily by the Gtk2::TreeView,
though they aren't tied to them in any specific way.

Typically, one cell renderer is used to draw many cells onto the screen.
Thus, the cell renderer doesn't keep state; instead, any state is set
immediately prior to use through the object property system.  The cell
is measured with C<get_size>, and then renderered with C<render>.

=head1 DERIVING NEW CELL RENDERERS

Gtk+ provides three cell renderers: Gtk2::CellRendererText,
Gtk2::CellRendererToggle, and Gtk2::CellRendererPixbuf.
However, Gtk2::CellRenderer does not provide signals for it methods,
and thus, because of implementation details requiring that a signal exist
for each virtual method that a language binding wishes to override when
subclassing, it is not possible to use Glib::Object's normal virtual
override machinery in non-C languages.

Therefore Gtk2::CellRenderer provides a specialized way to derive a
new cell renderer in Perl.  After deriving your class from something that
descends from Gtk2::CellRenderer, call I<YourClass>->_install_overrides
to mangle the underlying object such that it will call perl subs instead
of C ones.

Because things are not quite normal, chaining up to the parent is also
somewhat different.  You can't use SUPER, because the C classes don't 
define the methods we're using and if you did use SUPER you'd create 
an infinite loop (by starting the method invocation all over again).
Thus the perl subs are static methods for each class in the heirarchy.
Instead, you'll do $self->parent_I<foo>, where I<foo> is the method 
you're in, e.g., 

  # here's a pointless subclass implementation which
  # expensively illustrates how to chain up with cell renderers.
  sub on_get_size {
     return shift->parent_get_size (@_);
  }

  sub on_render {
     shift->parent_render (@_);
  }

  sub on_activate {
     return shift->parent_activate (@_);
  }

  sub on_start_editing {
     return shift->parent_start_editing (@_);
  }

For the curious, the parent_* functions use C<caller> to find the calling
package, in order to determine the parent package on which to call the
proper method.  That means that these functions can only be used within
your cell renderer implementation!

=cut

=for flags GtkCellRendererState
=cut

=for enum GtkCellRendererMode
=cut

## void gtk_cell_renderer_get_size (GtkCellRenderer *cell, GtkWidget *widget, GdkRectangle *cell_area, gint *x_offset, gint *y_offset, gint *width, gint *height)
=for apidoc
=for signature (cell_area, x_offset, y_offset, width, height) = $cell->renderer_get_size ($widget)
=cut
void
gtk_cell_renderer_get_size (cell, widget)
	GtkCellRenderer * cell
	GtkWidget       * widget
    PREINIT:
	gint x_offset;
	gint y_offset;
	gint width;
	gint height;
	GdkRectangle cell_area;
    PPCODE:
	cell_area.width = cell_area.height = 0;
	gtk_cell_renderer_get_size(cell, widget, &cell_area,
		&x_offset, &y_offset, &width, &height);
	EXTEND(SP,5);
	PUSHs(sv_2mortal(newSVGdkRectangle_copy (&cell_area)));
	PUSHs(sv_2mortal(newSViv(x_offset)));
	PUSHs(sv_2mortal(newSViv(y_offset)));
	PUSHs(sv_2mortal(newSViv(width)));
	PUSHs(sv_2mortal(newSViv(height)));

## void gtk_cell_renderer_render (GtkCellRenderer *cell, GdkWindow *window, GtkWidget *widget, GdkRectangle *background_area, GdkRectangle *cell_area, GdkRectangle *expose_area, GtkCellRendererState flags)
void
gtk_cell_renderer_render (cell, drawable, widget, background_area, cell_area, expose_area, flags)
	GtkCellRenderer      * cell
	GdkDrawable          * drawable
	GtkWidget            * widget
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GdkRectangle         * expose_area
	GtkCellRendererState   flags

## gboolean gtk_cell_renderer_activate (GtkCellRenderer *cell, GdkEvent *event, GtkWidget *widget, const gchar *path, GdkRectangle *background_area, GdkRectangle *cell_area, GtkCellRendererState flags)
gboolean
gtk_cell_renderer_activate (cell, event, widget, path, background_area, cell_area, flags)
	GtkCellRenderer      * cell
	GdkEvent             * event
	GtkWidget            * widget
	const gchar          * path
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GtkCellRendererState   flags

## void gtk_cell_renderer_set_fixed_size (GtkCellRenderer *cell, gint width, gint height)
void
gtk_cell_renderer_set_fixed_size (cell, width, height)
	GtkCellRenderer * cell
	gint              width
	gint              height

## void gtk_cell_renderer_get_fixed_size (GtkCellRenderer *cell, gint *width, gint *height)
void
gtk_cell_renderer_get_fixed_size (GtkCellRenderer * cell, OUTLIST gint width, OUTLIST gint height)

##GtkCellEditable* gtk_cell_renderer_start_editing (GtkCellRenderer *cell, GdkEvent *event, GtkWidget *widget, const gchar *path, GdkRectangle *background_area, GdkRectangle *cell_area, GtkCellRendererState flags)
GtkCellEditable_ornull *
gtk_cell_renderer_start_editing (cell, event, widget, path, background_area, cell_area, flags)
	GtkCellRenderer      * cell
	GdkEvent             * event
	GtkWidget            * widget
	const gchar          * path
	GdkRectangle         * background_area
	GdkRectangle         * cell_area
	GtkCellRendererState   flags


=for apidoc

=for signature YourCellRendererPackage->_install_overrides

Modify the underlying GObjectClass structure for the package
I<YouCellRendererPackage> to call Perl methods as virtual overrides for the
C<get_size>, C<render>, C<activate>, and C<start_editing> methods.  The
overrides will look for I<YourCellRendererPackage>::on_get_size,
I<YourCellRendererPackage>::on_render, I<YourCellRendererPackage>::on_activate,
and I<YourCellRendererPackage>::on_start_editing.  If the method is not
present, it will silently be skipped.

Usually called on __PACKAGE__ immediately after registering a new cellrenderer
subclass.

=cut
void
_install_overrides (const char * package)
    PREINIT:
	GType gtype;
	GtkCellRendererClass * class;
    CODE:
	gtype = gperl_object_type_from_package (package);
	if (!gtype)
		croak ("package '%s' is not registered with Gtk2-Perl",
		       package);
	if (! g_type_is_a (gtype, GTK_TYPE_CELL_RENDERER))
		croak ("%s(%s) is not a GtkCellRenderer",
		       package, g_type_name (gtype));
	/* peek should suffice, as the bindings should keep this class
	 * alive for us. */
	class = g_type_class_peek (gtype);
	if (! class)
		croak ("internal problem: can't peek at type class for %s(%d)",
		       g_type_name (gtype), gtype);
	gtk2perl_cell_renderer_class_init (class);


#
# here we provide a hokey way to chain up from one of the overrides we
# installed above.  since the class of an object is determined by looking
# at the bottom of the chain, we can't rely on that to give us the
# class of the parent; so we rely on the package returned by caller().
# therefore, it is only valid to call these from the derived package.
#
=for apidoc parent_get_size

=for signature ($xoffset, $yoffset, $width, $height) = $cell->parent_get_size ($widget, $rectangle)

=for arg ... (__hide__)
=for arg widget (GtkWidget)
=for arg rectangle (GdkRectangle_ornull)

Invoke the C<get_size> method of the parent class; only valid in virtual
overrides for C<on_get_size>.

=cut

=for apidoc parent_render

=for signature $cell->parent_render ($window, $widget, $rectangle, $background_area, $cell_area, $expose_area, $flags)

=for arg ... (__hide__)
=for arg drawable (GdkDrawable)
=for arg widget (GtkWidget)
=for arg background_area (GdkRectangle_ornull)
=for arg cell_area (GdkRectangle_ornull)
=for arg expose_area (GdkRectangle_ornull)
=for arg flags (GtkCellRendererState)

Invoke the C<render> method of the parent class; only valid in virtual
overrides for C<on_render>.

=cut

=for apidoc parent_activate

=for signature boolean = $cell->parent_activate ($event, $widget, $path, $background_area, $cell_area, $flags)

=for arg ... (__hide__)
=for arg event (GdkEvent)
=for arg widget (GtkWidget)
=for arg background_area (GdkRectangle_ornull)
=for arg cell_area (GdkRectangle_ornull)
=for arg expose_area (GdkRectangle_ornull)
=for arg flags (GtkCellRendererState)

Invoke the C<activate> method of the parent class; only valid in virtual
overrides for C<on_activate>.

=cut

=for apidoc parent_start_editing

=for signature GtkEditable_ornull = $cell->parent_start_editing ($widget, $rectangle)

=for arg ... (__hide__)
=for arg event (GdkEvent)
=for arg widget (GtkWidget)
=for arg path (char*)
=for arg background_area (GdkRectangle_ornull)
=for arg cell_area (GdkRectangle_ornull)
=for arg flags (GtkCellRendererState)

Invoke the C<start_editing> method of the parent class; only valid in virtual
overrides for C<on_start_editing>.

=cut

void
parent_get_size (GtkCellRenderer * cell, ...)
    ALIAS:
	parent_render        = 1
	parent_activate      = 2
	parent_start_editing = 3
    PREINIT:
	GtkCellRendererClass * class;
	GType thisclass, parent_class;
	SV * saveddefsv;
    PPCODE:
	/* may i ask who's calling? */
	saveddefsv = newSVsv (DEFSV);
	eval_pv ("$_ = caller;", 0);
	thisclass = gperl_type_from_package (SvPV_nolen (DEFSV));
	SvSetSV (DEFSV, saveddefsv);
	/* look up his parent */
	parent_class = g_type_parent (thisclass);
	if (! g_type_is_a (parent_class, GTK_TYPE_CELL_RENDERER))
		croak ("parent of %s is not a GtkCellRenderer",
		       g_type_name (thisclass));
	/* that's our boy.  call one of his functions. */
	class = g_type_class_peek (parent_class);
	switch (ix) {
	    case 0:
		if (class->get_size) {
			gint x_offset, y_offset, width, height;
			class->get_size (cell,
			                 SvGtkWidget (ST (1)),
					 SvGdkRectangle_ornull (ST (2)),
					 &x_offset,
					 &y_offset,
					 &width,
					 &height);
			EXTEND (SP, 4);
			PUSHs (sv_2mortal (newSViv (x_offset)));
			PUSHs (sv_2mortal (newSViv (y_offset)));
			PUSHs (sv_2mortal (newSViv (width)));
			PUSHs (sv_2mortal (newSViv (height)));
		}
		break;
	    case 1:
		if (class->render)
			class->render (cell,
			               SvGdkDrawable_ornull (ST (1)), /* drawable */
				       SvGtkWidget_ornull (ST (2)), /* widget */
				       SvGdkRectangle_ornull (ST (3)), /* background_area */
				       SvGdkRectangle_ornull (ST (4)), /* cell_area */
				       SvGdkRectangle_ornull (ST (5)), /* expose_area */
				       SvGtkCellRendererState (ST (6))); /* flags */
		break;
	    case 2:
		if (class->activate) {
			gboolean ret;
			ret = class->activate (cell,
			                       SvGdkEvent (ST (1)),
					       SvGtkWidget (ST (2)),
					       SvGChar (ST (3)),
					       SvGdkRectangle_ornull (ST (4)),
					       SvGdkRectangle_ornull (ST (5)),
					       SvGtkCellRendererState (ST (6)));
			EXTEND (SP, 1);
			PUSHs (sv_2mortal (newSViv (ret)));
		}
		break;
	    case 3:
		if (class->start_editing) {
			GtkCellEditable * editable;
			editable = class->start_editing (cell,
				                         SvGdkEvent_ornull (ST (1)),
						         SvGtkWidget (ST (2)),
						         SvGChar (ST (3)),
						         SvGdkRectangle_ornull (ST (4)),
						         SvGdkRectangle_ornull (ST (5)),
						         SvGtkCellRendererState (ST (6)));
			EXTEND (SP, 1);
			PUSHs (newSVGtkCellEditable_ornull (editable));
		}
		break;
	}


