/*
 * $Header$
 */

#include "gtk2perl.h"

MODULE = Gtk2::RadioButton	PACKAGE = Gtk2::RadioButton	PREFIX = gtk_radio_button_


GtkWidget *
gtk_radio_button_new (class, member_or_listref=NULL, label=NULL)
	SV          * class
	SV          * member_or_listref
	const gchar * label
    PREINIT:
	GSList         * group = NULL;
	GtkRadioButton * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( svp && SvOK(*svp) )
				member = SvGtkRadioButton(*svp);
		}
		else
			member = SvGtkRadioButton_ornull(member_or_listref);
		if( member )
			group = member->group;
	}

	if (label)
		RETVAL = gtk_radio_button_new_with_label (group, label);
	else
		RETVAL = gtk_radio_button_new (group);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_radio_button_new_with_label (class, member_or_listref=NULL, label)
	SV          * class
	SV          * member_or_listref
	const gchar * label
    PREINIT:
	GSList         * group = NULL;
	GtkRadioButton * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( SvOK(*svp) )
			{
				member = SvGtkRadioButton(*svp);
			}
		}
		else
			member = SvGtkRadioButton_ornull(member_or_listref);
		if( member )
			group = member->group;
	}

	RETVAL = gtk_radio_button_new_with_label (group, label);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_radio_button_new_with_mnemonic (class, member_or_listref=NULL, label)
	SV          * class
	SV          * member_or_listref
	const gchar * label
    PREINIT:
	GSList         * group = NULL;
	GtkRadioButton * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( SvOK(*svp) )
			{
				member = SvGtkRadioButton(*svp);
			}
		}
		else
			member = SvGtkRadioButton_ornull(member_or_listref);
		if( member )
			group = member->group;
	}

	RETVAL = gtk_radio_button_new_with_label (group, label);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_radio_button_new_from_widget (class, group, label=NULL)
	SV * class
	GtkRadioButton_ornull *group
	const gchar * label
    CODE:
	if (label)
		RETVAL = gtk_radio_button_new_with_label_from_widget (group, label);
	else
		RETVAL = gtk_radio_button_new_from_widget (group);
    OUTPUT:
	RETVAL

GtkWidget *
gtk_radio_button_new_with_label_from_widget (class, group, label)
	SV                    * class
	GtkRadioButton_ornull * group
	const gchar           * label
    C_ARGS:
	group, label

GtkWidget *
gtk_radio_button_new_with_mnemonic_from_widget (class, group, label)
	SV                    * class
	GtkRadioButton_ornull * group
	const gchar           * label
    C_ARGS:
	group, label

void
gtk_radio_button_set_group (radio_button, member_or_listref)
	GtkRadioButton * radio_button
	SV             * member_or_listref
    PREINIT:
	GSList         * group = NULL;
	GtkRadioButton * member = NULL;
    CODE:
	if( member_or_listref && member_or_listref != &PL_sv_undef )
	{
		if( SvTYPE(SvRV(member_or_listref)) == SVt_PVAV )
		{
			AV * av = (AV*)SvRV(member_or_listref);
			SV ** svp = av_fetch(av, 0, 0);
			if( SvOK(*svp) )
			{
				member = SvGtkRadioButton(*svp);
			}
		}
		else
			member = SvGtkRadioButton_ornull(member_or_listref);
		if( member )
			group = member->group;
	}
	gtk_radio_button_set_group(radio_button, group);

# GSList * gtk_radio_button_get_group (GtkRadioButton *radio_button)
void
gtk_radio_button_get_group (radio_button)
	GtkRadioButton * radio_button
    PREINIT:
	GSList * group;
	GSList * i;
	AV     * av;
    PPCODE:
	group = radio_button->group;
	av = newAV();
	for( i = group; i ; i = i->next )
	{
		av_push(av, newSVGtkRadioButton(GTK_RADIO_BUTTON(i->data)));
	}
	XPUSHs(newRV_noinc((SV*)av));

