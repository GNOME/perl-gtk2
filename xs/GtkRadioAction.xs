#include "gtk2perl.h"

MODULE = Gtk2::RadioAction	PACKAGE = Gtk2::RadioAction	PREFIX = gtk_radio_action_

## GSList  *gtk_radio_action_get_group (GtkRadioAction *action);
void
gtk_radio_action_get_group (GtkRadioAction *action)
    PREINIT:
	GSList * group, * i;
	AV * av;
    PPCODE:
	group = gtk_radio_action_get_group (action);
	av = newAV ();
	for (i = group ; i != NULL ; i = i->next)
		av_push (av, newSVGtkRadioAction (i->data));
	XPUSHs (newRV_noinc ((SV*)av));

## void gtk_radio_action_set_group (GtkRadioAction *action, GSList *group);
void gtk_radio_action_set_group (GtkRadioAction *action, SV *member_or_listref);
    PREINIT:
	GSList * group = NULL;
    CODE:
	if (member_or_listref && SvTRUE (member_or_listref)) {
		GtkRadioAction * member = NULL;
		if (SvROK (member_or_listref) &&
		    SvTYPE (SvRV (member_or_listref)) == SVt_PVAV) {
			AV * av = (AV*) SvRV (member_or_listref);
			SV ** svp = av_fetch (av, 0, 0);
			if (svp && *svp && SvOK (*svp))
				member = SvGtkRadioAction (*svp);
		} else
			member = SvGtkRadioAction_ornull (member_or_listref);
		if (member)
			group = gtk_radio_action_get_group (member);
	}
	gtk_radio_action_set_group (action, group);

gint gtk_radio_action_get_current_value (GtkRadioAction *action);

