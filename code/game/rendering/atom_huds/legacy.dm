/*
 * Data HUDs have been rewritten in a more generic way.
 * In short, they now use an observer-listener pattern.
 * See code/datum/hud.dm for the generic hud datum.
 * Update the HUD icons when needed with the appropriate hook. (see below)
 */

/* DATA HUD DATUMS */

/atom/proc/add_to_all_human_data_huds()
	for(var/datum/atom_hud/data/human/hud in GLOB.huds)
		hud.add_to_hud(src)

/atom/proc/remove_from_all_data_huds()
	for(var/datum/atom_hud/data/hud in GLOB.huds)
		hud.remove_from_hud(src)

/mob/proc/update_hud_med_health()
	update_atom_hud_provider(src, /datum/atom_hud_provider/medical_health)

/mob/proc/update_hud_med_status()
	update_atom_hud_provider(src, /datum/atom_hud_provider/medical_biology)

/mob/proc/update_hud_med_all()
	update_hud_med_health()
	update_hud_med_status()

/mob/proc/update_hud_sec_implants()
	update_atom_hud_provider(src, /datum/atom_hud_provider/security_implant)

/mob/proc/update_hud_sec_job()
	update_atom_hud_provider(src, /datum/atom_hud_provider/security_job)

/mob/proc/update_hud_sec_status()
	update_atom_hud_provider(src, /datum/atom_hud_provider/security_status)

/mob/proc/update_hud_antag()
	update_atom_hud_provider(src, /datum/atom_hud_provider/special_role)

/proc/RoundHealth(health, icon = GLOB.hud_icon_files[LIFE_HUD])
	var/list/icon_states = icon_states(icon)
	for(var/icon_state in icon_states)
		if(health >= text2num(icon_state))
			return icon_state
	return icon_states[icon_states.len] // If we had no match, return the last element

/mob/proc/check_viruses()
	return FALSE

/mob/living/carbon/human/check_viruses()
	return !!length(virus2 & virusDB)
