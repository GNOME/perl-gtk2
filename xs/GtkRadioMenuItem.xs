/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::RadioMenuItem	PACKAGE = Gtk2::RadioMenuItem	PREFIX = gtk_radio_menu_item_

GtkWidget *
gtk_radio_menu_item_new (class, member_or_listref=NULL, label=NULL)
	SV          * class
	SV          * member_or_listref
	const gchar * label
    PREINIT:
	GSList         * group = NULL;
	GtkRadioMenuItem * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( svp && SvOK(*svp) )
				member = SvGtkRadioMenuItem(*svp);
		}
		else
			member = SvGtkRadioMenuItem_ornull(member_or_listref);
		if( member )
			group = member->group;
	}

	if (label)
		RETVAL = gtk_radio_menu_item_new_with_label (group, label);
	else
		RETVAL = gtk_radio_menu_item_new (group);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_radio_menu_item_new_with_label (class, member_or_listref=NULL, label)
	SV          * class
	SV          * member_or_listref
	const gchar * label
    PREINIT:
	GSList         * group = NULL;
	GtkRadioMenuItem * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( SvOK(*svp) )
			{
				member = SvGtkRadioMenuItem(*svp);
			}
		}
		else
			member = SvGtkRadioMenuItem_ornull(member_or_listref);
		if( member )
			group = member->group;
	}

	RETVAL = gtk_radio_menu_item_new_with_label (group, label);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_radio_menu_item_new_with_mnemonic (class, member_or_listref=NULL, label)
	SV          * class
	SV          * member_or_listref
	const gchar * label
    PREINIT:
	GSList         * group = NULL;
	GtkRadioMenuItem * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( SvOK(*svp) )
			{
				member = SvGtkRadioMenuItem(*svp);
			}
		}
		else
			member = SvGtkRadioMenuItem_ornull(member_or_listref);
		if( member )
			group = member->group;
	}

	RETVAL = gtk_radio_menu_item_new_with_label (group, label);
    OUTPUT:
	RETVAL


# GSList * gtk_radio_menu_item_get_group (GtkRadioMenuItem *radio_menu_item)
void
gtk_radio_menu_item_get_group (radio_menu_item)
	GtkRadioMenuItem * radio_menu_item
    PREINIT:
	GSList * group;
	GSList * i;
	AV     * av;
    PPCODE:
	group = radio_menu_item->group;
	av = newAV();
	for( i = group; i ; i = i->next )
	{
		av_push(av, newSVGtkRadioMenuItem(GTK_RADIO_MENU_ITEM(i->data)));
	}
	XPUSHs(newRV_noinc((SV*)av));

void
gtk_radio_menu_item_set_group (radio_menu_item, member_or_listref)
	GtkRadioMenuItem * radio_menu_item
	SV             * member_or_listref
    PREINIT:
	GSList         * group = NULL;
	GtkRadioMenuItem * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( SvOK(*svp) )
			{
				member = SvGtkRadioMenuItem(*svp);
			}
		}
		else
			member = SvGtkRadioMenuItem_ornull(member_or_listref);
		if( member )
			group = member->group;
	}
	gtk_radio_menu_item_set_group(radio_menu_item, group);

