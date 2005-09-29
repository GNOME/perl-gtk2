/*
 * Copyright (c) 2005 by the gtk2-perl team (see the file AUTHORS)
 *
 * Licensed under the LGPL, see LICENSE file for more information.
 *
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::Atk::Implementor	PACKAGE = Gtk2::Atk::Implementor	PREFIX = atk_implementor_

# ref_accessible "may return flyweight objects", so it refs the return.
# therefore, we own the return, if it's not NULL.
# gtk_widget_get_accessible() has different semantics and the method name
# "get_accessible()", so we can't rename this. 
# this may not really be useful at all, but i'm interested in it mainly
# so that the package exists and we can avoid "Cannot locate package for"
# warnings.
AtkObject_noinc_ornull *atk_implementor_ref_accessible (AtkImplementor * implementor);
