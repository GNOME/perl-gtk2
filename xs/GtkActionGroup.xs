#include "gtk2perl.h"

/* helper for using gperl_signal_connect when you don't have the SV of
 * the instance... */
#define WRAPINSTANCE(object)	(sv_2mortal (newSVGObject (G_OBJECT (object))))


/* these macros expect there to exist an SV** named svp */

#define HFETCHPV(hv, key)	\
	(((svp = hv_fetch ((hv), (key), strlen ((key)), FALSE))	\
	  && SvOK (*svp))					\
	  ? SvPV_nolen (*svp)					\
	  : NULL)

#define HFETCHCV(hv, key)	\
	(((svp = hv_fetch ((hv), (key), strlen ((key)), FALSE))	\
	  && SvOK (*svp))					\
	  ? (gpointer)(*svp)					\
	  : NULL)

#define HFETCHIV(hv, key)	\
	(((svp = hv_fetch ((hv), (key), strlen ((key)), FALSE))	\
	  && SvOK (*svp))					\
	  ? SvIV (*svp)						\
	  : 0)

#define AFETCHPV(av, index)	\
	(((svp = av_fetch ((av), (index), FALSE)) && SvOK (*svp))	\
	 ? SvPV_nolen (*svp)						\
	 : NULL)

#define AFETCHCV(av, index)	\
	(((svp = av_fetch ((av), (index), FALSE)) && SvOK (*svp))	\
	 ? (gpointer)(*svp)						\
	 : NULL)

#define AFETCHIV(av, index)	\
	(((svp = av_fetch ((av), (index), FALSE)) && SvOK (*svp))	\
	 ? SvIV (*svp)							\
	 : 0)


/*
struct _GtkActionEntry 
{
  gchar     *name;
  gchar     *stock_id;
  gchar     *label;
  gchar     *accelerator;
  gchar     *tooltip;
  GCallback  callback;
};
*/

static void
read_action_entry_from_sv (SV * sv,
                           GtkActionEntry * action)
{
	SV ** svp;
	if (!sv || !SvOK (sv) || !SvROK (sv))
		croak ("invalid action entry");

	switch (SvTYPE (SvRV (sv))) {
	    case SVt_PVHV:
		{
		HV * hv = (HV*) SvRV (sv);
		action->name        = HFETCHPV (hv, "name");
		action->stock_id    = HFETCHPV (hv, "stock_id");
		action->label       = HFETCHPV (hv, "label");
		action->accelerator = HFETCHPV (hv, "accelerator");
		action->tooltip     = HFETCHPV (hv, "tooltip");
		action->callback    = HFETCHCV (hv, "callback");
		}
		break;
	    case SVt_PVAV:
		{
		AV * av = (AV*) SvRV (sv);
		action->name        = AFETCHPV (av, 0);
		action->stock_id    = AFETCHPV (av, 1);
		action->label       = AFETCHPV (av, 2);
		action->accelerator = AFETCHPV (av, 3);
		action->tooltip     = AFETCHPV (av, 4);
		action->callback    = AFETCHCV (av, 5);
		}
		break;
	    default:
		croak ("action entry must be a hash or an array");
	}
}


/*
struct _GtkToggleActionEntry 
{
  gchar     *name;
  gchar     *stock_id;
  gchar     *label;
  gchar     *accelerator;
  gchar     *tooltip;
  GCallback  callback;
  gboolean   is_active;
};
*/

static void
read_toggle_action_entry_from_sv (SV * sv,
                                  GtkToggleActionEntry * action)
{
	SV ** svp;
	if (!sv || !SvOK (sv) || !SvROK (sv))
		croak ("invalid toggle action entry");

	switch (SvTYPE (SvRV (sv))) {
	    case SVt_PVHV:
		{
		HV * hv = (HV*) SvRV (sv);
		action->name        = HFETCHPV (hv, "name");
		action->stock_id    = HFETCHPV (hv, "stock_id");
		action->label       = HFETCHPV (hv, "label");
		action->accelerator = HFETCHPV (hv, "accelerator");
		action->tooltip     = HFETCHPV (hv, "tooltip");
		action->callback    = HFETCHCV (hv, "callback");
		action->is_active   = HFETCHIV (hv, "is_active");
		}
		break;
	    case SVt_PVAV:
		{
		AV * av = (AV*) SvRV (sv);
		if (av_len (av) < 5)
			croak ("not enough items in array form of toggle action entry; expecting:\n"
			       "     [ name, stock_id, label, accelerator, tooltip, value]\n"
			       "  ");
		action->name        = AFETCHPV (av, 0);
		action->stock_id    = AFETCHPV (av, 1);
		action->label       = AFETCHPV (av, 2);
		action->accelerator = AFETCHPV (av, 3);
		action->tooltip     = AFETCHPV (av, 4);
		action->callback    = AFETCHCV (av, 5);
		action->is_active   = AFETCHIV (av, 6);
		}
		break;
	    default:
		croak ("action entry must be a hash or an array");
	}
}


/*
struct _GtkRadioActionEntry 
{
  gchar *name;
  gchar *stock_id;
  gchar *label;
  gchar *accelerator;
  gchar *tooltip;
  gint   value; 
};
*/

static void
read_radio_action_entry_from_sv (SV * sv,
                                 GtkRadioActionEntry * action)
{
	SV ** svp;
	if (!sv || !SvOK (sv) || !SvROK (sv))
		croak ("invalid radio action entry");

	switch (SvTYPE (SvRV (sv))) {
	    case SVt_PVHV:
		{
		HV * hv = (HV*) SvRV (sv);
		action->name        = HFETCHPV (hv, "name");
		action->stock_id    = HFETCHPV (hv, "stock_id");
		action->label       = HFETCHPV (hv, "label");
		action->accelerator = HFETCHPV (hv, "accelerator");
		action->tooltip     = HFETCHPV (hv, "tooltip");
		action->value       = HFETCHIV (hv, "value");
		}
		break;
	    case SVt_PVAV:
		{
		AV * av = (AV*) SvRV (sv);
		if (av_len (av) < 5)
			croak ("not enough items in array form of radio action entry; expecting:\n"
			       "     [ name, stock_id, label, accelerator, tooltip, value]\n"
			       "  ");
		action->name        = AFETCHPV (av, 0);
		action->stock_id    = AFETCHPV (av, 1);
		action->label       = AFETCHPV (av, 2);
		action->accelerator = AFETCHPV (av, 3);
		action->tooltip     = AFETCHPV (av, 4);
		action->value       = AFETCHIV (av, 5);
		}
		break;
	    default:
		croak ("action entry must be a hash or an array");
	}
}


MODULE = Gtk2::ActionGroup	PACKAGE = Gtk2::ActionGroup	PREFIX = gtk_action_group_

GtkActionGroup_noinc *gtk_action_group_new (class, const gchar *name);
    C_ARGS:
	name

const gchar *gtk_action_group_get_name (GtkActionGroup *action_group);

GtkAction *gtk_action_group_get_action (GtkActionGroup *action_group, const gchar *action_name);

void gtk_action_group_list_actions (GtkActionGroup *action_group);
    PREINIT:
	GList * actions, * i;
    PPCODE:
	actions = gtk_action_group_list_actions (action_group);
	for (i = actions ; i != NULL ; i = i->next)
		XPUSHs (sv_2mortal (newSVGtkAction (i->data)));
	g_list_free (actions);

void gtk_action_group_add_action (GtkActionGroup *action_group, GtkAction *action);

void gtk_action_group_remove_action (GtkActionGroup *action_group, GtkAction *action);

##void gtk_action_group_add_actions (GtkActionGroup *action_group, GtkActionEntry *entries, guint n_entries, gpointer user_data);
##void gtk_action_group_add_actions_full (GtkActionGroup *action_group, GtkActionEntry *entries, guint n_entries, gpointer user_data, GDestroyNotify destroy);
void
gtk_action_group_add_actions (action_group, action_entries, user_data=NULL)
	GtkActionGroup * action_group
	SV * action_entries
	SV * user_data
    PREINIT:
	AV * av;
	GtkActionEntry * entries;
	gint n_actions, i;
    CODE:
	if (!action_entries || !SvOK (action_entries) || !SvROK (action_entries)
	    || SvTYPE (SvRV (action_entries)) != SVt_PVAV)
		croak ("actions must be a reference to an array of action entries");
	av = (AV*) SvRV (action_entries);
	n_actions = av_len (av) + 1;
	entries = gperl_alloc_temp (sizeof (GtkActionEntry) * n_actions);
	for (i = 0 ; i < n_actions ; i++) {
		SV ** svp = av_fetch (av, i, 0);
		read_action_entry_from_sv (*svp, entries+i);
	}
	
	for (i = 0 ; i < n_actions ; i++) {
		GtkAction * action;
		gchar * accel_path;

		action = g_object_new (GTK_TYPE_ACTION,
		                       "name", entries[i].name,
		                       "label", entries[i].label,
		                       "tooltip", entries[i].tooltip,
		                       "stock_id", entries[i].stock_id,
		                       NULL);
		if (entries[i].callback)
			gperl_signal_connect (WRAPINSTANCE (action),
			                      "activate",
					      (SV*)(entries[i].callback),
					      user_data, 0);

		/* set the accel path for the menu item */
		accel_path = g_strconcat
				("<Actions>/",
				 gtk_action_group_get_name (action_group),
				 "/", entries[i].name, NULL);

		if (entries[i].accelerator) {
			guint accel_key = 0;
			GdkModifierType accel_mods;

			gtk_accelerator_parse (entries[i].accelerator,
			                       &accel_key, &accel_mods);
			if (accel_key)
				gtk_accel_map_add_entry (accel_path,
				                         accel_key,
				                         accel_mods);
		}

		gtk_action_set_accel_path (action, accel_path);
		g_free (accel_path);

		gtk_action_group_add_action (action_group, action);
		g_object_unref (action);
	}

## FIXME
##void gtk_action_group_add_toggle_actions (GtkActionGroup *action_group, GtkToggleActionEntry *entries, guint n_entries, gpointer user_data);
##void gtk_action_group_add_toggle_actions_full (GtkActionGroup *action_group, GtkToggleActionEntry *entries, guint n_entries, gpointer user_data, GDestroyNotify destroy);
void
gtk_action_group_add_toggle_actions (action_group, toggle_action_entries, user_data=NULL)
	GtkActionGroup * action_group
	SV * toggle_action_entries
	SV * user_data
    PREINIT:
	AV * av;
	GtkToggleActionEntry * entries;
	gint n_actions, i;
    CODE:
	if (!toggle_action_entries ||
	    !SvOK (toggle_action_entries) || !SvROK (toggle_action_entries) ||
	    SvTYPE (SvRV (toggle_action_entries)) != SVt_PVAV)
		croak ("entries must be a reference to an array of toggle action entries");
	av = (AV*) SvRV (toggle_action_entries);
	n_actions = av_len (av) + 1;
	entries = gperl_alloc_temp (sizeof (GtkToggleActionEntry) * n_actions);
	for (i = 0 ; i < n_actions ; i++) {
		SV ** svp = av_fetch (av, i, 0);
		read_toggle_action_entry_from_sv (*svp, entries+i);
	}
	
	for (i = 0 ; i < n_actions ; i++) {
		GtkAction * action;
		gchar * accel_path;

		action = g_object_new (GTK_TYPE_TOGGLE_ACTION,
		                       "name", entries[i].name,
		                       "label", entries[i].label,
		                       "tooltip", entries[i].tooltip,
		                       "stock_id", entries[i].stock_id,
		                       NULL);
		gtk_toggle_action_set_active (GTK_TOGGLE_ACTION (action),
		                              entries[i].is_active);
		if (entries[i].callback)
			gperl_signal_connect (WRAPINSTANCE (action),
			                      "activate",
					      (SV*)(entries[i].callback),
					      user_data, 0);

		/* set the accel path for the menu item */
		accel_path = g_strconcat
				("<Actions>/",
				 gtk_action_group_get_name (action_group),
				 "/", entries[i].name, NULL);

		if (entries[i].accelerator) {
			guint accel_key = 0;
			GdkModifierType accel_mods;

			gtk_accelerator_parse (entries[i].accelerator,
			                       &accel_key, &accel_mods);
			if (accel_key)
				gtk_accel_map_add_entry (accel_path,
				                         accel_key,
				                         accel_mods);
		}

		gtk_action_set_accel_path (action, accel_path);
		g_free (accel_path);

		gtk_action_group_add_action (action_group, action);
		g_object_unref (action);
	}

## FIXME
##void gtk_action_group_add_radio_actions (GtkActionGroup *action_group, GtkRadioActionEntry *entries, guint n_entries, gint value, GCallback on_change, gpointer user_data);
##void gtk_action_group_add_radio_actions_full (GtkActionGroup *action_group, GtkRadioActionEntry *entries, guint n_entries, gint value, GCallback on_change, gpointer user_data, GDestroyNotify destroy);
void
gtk_action_group_add_radio_actions (action_group, radio_action_entries, value, on_change, user_data=NULL)
	GtkActionGroup * action_group
	SV * radio_action_entries
	gint value
	SV * on_change
	SV * user_data
    PREINIT:
	AV * av;
	GtkRadioActionEntry * entries;
	GtkAction * first_action = NULL;
	GSList * group = NULL;
	gint n_actions, i;
    CODE:
	if (!radio_action_entries ||
	    !SvOK (radio_action_entries) || !SvROK (radio_action_entries) ||
	    SvTYPE (SvRV (radio_action_entries)) != SVt_PVAV)
		croak ("radio_action_entries must be a reference to an array of action entries");
	av = (AV*) SvRV (radio_action_entries);
	n_actions = av_len (av) + 1;
	warn ("n_actions : %d\n", n_actions);
	entries = gperl_alloc_temp (sizeof (GtkRadioActionEntry) * n_actions);
	for (i = 0 ; i < n_actions ; i++) {
		SV ** svp = av_fetch (av, i, 0);
		read_radio_action_entry_from_sv (*svp, entries+i);
	}
	
	for (i = 0 ; i < n_actions ; i++) {
		GtkAction * action;
		gchar * accel_path;

		action = g_object_new (GTK_TYPE_RADIO_ACTION,
		                       "name", entries[i].name,
		                       "label", entries[i].label,
		                       "tooltip", entries[i].tooltip,
		                       "stock_id", entries[i].stock_id,
		                       "value", entries[i].value,
		                       NULL);

		if (i == 0)
			first_action = action;
		gtk_radio_action_set_group (GTK_RADIO_ACTION (action), group);
		group = gtk_radio_action_get_group (GTK_RADIO_ACTION (action));
		if (value == entries[i].value)
			gtk_toggle_action_set_active
					(GTK_TOGGLE_ACTION (action), TRUE);

		/* set the accel path for the menu item */
		accel_path = g_strconcat
				("<Actions>/",
				 gtk_action_group_get_name (action_group),
				 "/", entries[i].name, NULL);

		if (entries[i].accelerator) {
			guint accel_key = 0;
			GdkModifierType accel_mods;

			gtk_accelerator_parse (entries[i].accelerator,
			                       &accel_key, &accel_mods);
			if (accel_key)
				gtk_accel_map_add_entry (accel_path,
				                         accel_key,
				                         accel_mods);
		}

		gtk_action_set_accel_path (action, accel_path);
		g_free (accel_path);

		gtk_action_group_add_action (action_group, action);
		g_object_unref (action);
	}

	if (on_change && SvOK (on_change))
		gperl_signal_connect (WRAPINSTANCE (first_action),
		                      "changed", on_change, user_data, 0);

## FIXME
##void gtk_action_group_set_translate_func (GtkActionGroup *action_group, GtkTranslateFunc func, gpointer data, GtkDestroyNotify notify);

##void gtk_action_group_set_translation_domain (GtkActionGroup *action_group, const gchar *domain); 