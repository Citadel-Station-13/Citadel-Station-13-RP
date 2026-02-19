
/**
 * Get the mob VV dropdown extras
 */
/mob/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---------")
	VV_DROPDOWN_OPTION(VV_HK_GIB, "Gib")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_SPELL, "Give Spell")
	VV_DROPDOWN_OPTION(VV_HK_GIVE_DISEASE, "Give Disease")
	VV_DROPDOWN_OPTION(VV_HK_GODMODE, "Toggle Godmode")
	VV_DROPDOWN_OPTION(VV_HK_DROP_ALL, "Drop Everything")
	VV_DROPDOWN_OPTION(VV_HK_PLAYER_PANEL, "Show player panel")
	VV_DROPDOWN_OPTION(VV_HK_BUILDMODE, "Toggle Buildmode")
	VV_DROPDOWN_OPTION(VV_HK_DIRECT_CONTROL, "Assume Direct Control")

/mob/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(href_list[VV_HK_GIVE_DISEASE])
		if(!check_rights(R_ADMIN))
			return FALSE
		usr.client.give_disease2(src)

	if(href_list[VV_HK_PLAYER_PANEL])
		usr.client.holder.show_player_panel(src)

	if(href_list[VV_HK_GODMODE])
		if(!check_rights(R_REJUVINATE))
			return FALSE
		usr.client.cmd_admin_godmode(src)

	if(href_list[VV_HK_GIVE_SPELL])
		if(!check_rights(R_ADMIN))
			return FALSE
		usr.client.give_spell(src)

	if(href_list[VV_HK_GIB])
		if(!check_rights(R_ADMIN))
			return FALSE
		usr.client.cmd_admin_gib(src)

	if(href_list[VV_HK_BUILDMODE])
		if(!check_rights(R_BUILDMODE))
			return FALSE
		togglebuildmode(src)

	if(href_list[VV_HK_DROP_ALL])
		if(!check_rights(R_ADMIN))
			return FALSE
		usr.client.cmd_admin_drop_everything(src)

	if(href_list[VV_HK_DIRECT_CONTROL])
		if(!check_rights(R_ADMIN))
			return FALSE
		usr.client.cmd_assume_direct_control(src)
