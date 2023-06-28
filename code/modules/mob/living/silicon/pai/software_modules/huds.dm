/datum/pai_software/sec_hud
	name = "Security HUD"
	ram_cost = 20
	id = "sec_hud"

/datum/pai_software/sec_hud/toggle(mob/living/silicon/pai/user)
	user.secHUD = !user.secHUD
	if(user.secHUD)
		get_atom_hud(DATA_HUD_SECURITY_ADVANCED).add_hud_to(user)
	else
		get_atom_hud(DATA_HUD_SECURITY_ADVANCED).remove_hud_from(user)

/datum/pai_software/sec_hud/is_active(mob/living/silicon/pai/user)
	return user.secHUD

/datum/pai_software/med_hud
	name = "Medical HUD"
	ram_cost = 20
	id = "med_hud"

/datum/pai_software/med_hud/toggle(mob/living/silicon/pai/user)
	if((user.medHUD = !user.medHUD))
		get_atom_hud(DATA_HUD_MEDICAL).add_hud_to(user)
	else
		get_atom_hud(DATA_HUD_MEDICAL).remove_hud_from(user)

/datum/pai_software/med_hud/is_active(mob/living/silicon/pai/user)
	return user.medHUD
