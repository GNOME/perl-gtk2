#include "gtk2perl.h"

MODULE = Gtk2::Gdk::Region	PACKAGE = Gtk2::Gdk::Region	PREFIX = gtk_region_

#### GdkRegion is not in the typemap!!
#
#
###  GdkRegion *gdk_region_new (void) 
#GdkRegion_own *
#gdk_region_new (class)
#	SV * class
#    C_ARGS:
#	
#
###  GdkRegion *gdk_region_polygon (GdkPoint *points, gint npoints, GdkFillRule fill_rule) 
#GdkRegion_own *
#gdk_region_polygon (points, npoints, fill_rule)
#	GdkPoint *points
#	gint npoints
#	GdkFillRule fill_rule
#
###  GdkRegion *gdk_region_copy (GdkRegion *region) 
#GdkRegion_own *
#gdk_region_copy (region)
#	GdkRegion *region
#
###  GdkRegion *gdk_region_rectangle (GdkRectangle *rectangle) 
#GdkRegion_own *
#gdk_region_rectangle (rectangle)
#	GdkRectangle *rectangle
#
###  void gdk_region_destroy (GdkRegion *region) 
##void
##gdk_region_destroy (region)
##	GdkRegion *region
#
###  void gdk_region_get_clipbox (GdkRegion *region, GdkRectangle *rectangle) 
#GdkRectangle *
#gdk_region_get_clipbox (region)
#	GdkRegion *region
#    PREINIT:
#	GdkRectangle rectangle;
#    CODE:
#	gdk_region_get_clipbox (region, &rectangle);
#	RETVAL = &rectangle;
#    OUTPUT:
#	RETVAL
#
###  void gdk_region_get_rectangles (GdkRegion *region, GdkRectangle **rectangles, gint *n_rectangles) 
#void
#gdk_region_get_rectangles (region)
#	GdkRegion *region
#    PREINIT:
#	GdkRectangle *rectangles = NULL;
#	gint n_rectangles;
#	int i;
#    PPCODE:
#	gdk_region_get_rectangles (region, &rectangles, &n_rectangles);
#	EXTEND (SP, n_rectangles);
#	for (i = 0 ; i < n_rectangles ; i++)
#		PUSHs (sv_2mortal (newSVGdkRectangle (rectangles + i)));
#	g_free (rectangles);
#
###  gboolean gdk_region_empty (GdkRegion *region) 
#gboolean
#gdk_region_empty (region)
#	GdkRegion *region
#
###  gboolean gdk_region_equal (GdkRegion *region1, GdkRegion *region2) 
#gboolean
#gdk_region_equal (region1, region2)
#	GdkRegion *region1
#	GdkRegion *region2
#
###  gboolean gdk_region_point_in (GdkRegion *region, int x, int y) 
#gboolean
#gdk_region_point_in (region, x, y)
#	GdkRegion *region
#	int x
#	int y
#
###  GdkOverlapType gdk_region_rect_in (GdkRegion *region, GdkRectangle *rect) 
#GdkOverlapType
#gdk_region_rect_in (region, rect)
#	GdkRegion *region
#	GdkRectangle *rect
#
###  void gdk_region_offset (GdkRegion *region, gint dx, gint dy) 
#void
#gdk_region_offset (region, dx, dy)
#	GdkRegion *region
#	gint dx
#	gint dy
#
###  void gdk_region_shrink (GdkRegion *region, gint dx, gint dy) 
#void
#gdk_region_shrink (region, dx, dy)
#	GdkRegion *region
#	gint dx
#	gint dy
#
###  void gdk_region_union_with_rect (GdkRegion *region, GdkRectangle *rect) 
#void
#gdk_region_union_with_rect (region, rect)
#	GdkRegion *region
#	GdkRectangle *rect
#
###  void gdk_region_intersect (GdkRegion *source1, GdkRegion *source2) 
#void
#gdk_region_intersect (source1, source2)
#	GdkRegion *source1
#	GdkRegion *source2
#
###  void gdk_region_union (GdkRegion *source1, GdkRegion *source2) 
#void
#gdk_region_union (source1, source2)
#	GdkRegion *source1
#	GdkRegion *source2
#
###  void gdk_region_subtract (GdkRegion *source1, GdkRegion *source2) 
#void
#gdk_region_subtract (source1, source2)
#	GdkRegion *source1
#	GdkRegion *source2
#
###  void gdk_region_xor (GdkRegion *source1, GdkRegion *source2) 
#void
#gdk_region_xor (source1, source2)
#	GdkRegion *source1
#	GdkRegion *source2
#
####  void gdk_region_spans_intersect_foreach (GdkRegion *region, GdkSpan *spans, int n_spans, gboolean sorted, GdkSpanFunc function, gpointer data) 
##void
##gdk_region_spans_intersect_foreach (region, spans, n_spans, sorted, function, data=NULL)
##	GdkRegion *region
##	GdkSpan *spans
##	int n_spans
##	gboolean sorted
##	SV * function
##	SV * data
##    PREINIT:
##	GPerlCallback * callback;
##    CODE:
##	if (!function || function == &PL_sv_undef)
##		croak ("bad function ref");
##	callback = gperl_callback_new (function, data,
#
