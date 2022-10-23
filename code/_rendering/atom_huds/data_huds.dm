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

/datum/atom_hud/data

/datum/atom_hud/data/human/medical
	hud_icons = list(STATUS_HUD, LIFE_HUD)

/datum/atom_hud/data/human/job_id
	hud_icons = list(ID_HUD)

/datum/atom_hud/data/human/security

/datum/atom_hud/data/human/security/basic
	hud_icons = list(ID_HUD, WANTED_HUD)

/datum/atom_hud/data/human/security/advanced
	hud_icons = list(ID_HUD, IMPTRACK_HUD, IMPLOYAL_HUD, IMPCHEM_HUD, WANTED_HUD)

/datum/atom_hud/antag
	hud_icons = list(ANTAG_HUD)

// one of these days we'll make /datum/hud_supplier
// and we can standardize everything
// today is not that day for i have no patience or motivation left

/mob/proc/update_hud_med_health()
	return

/mob/living/update_hud_med_health()
	. = ..()
	var/image/I = hud_list[LIFE_HUD]
	if(!I)
		return
	if(stat == DEAD)
		I.icon_state = "-100"
	else
		I.icon_state = RoundHealth((health-config_legacy.health_threshold_crit)/(getMaxHealth()-config_legacy.health_threshold_crit)*100)

/mob/proc/update_hud_med_status()
	var/image/holder = hud_list[STATUS_HUD]
	if(!holder)
		return
	var/foundVirus = check_viruses()
	if(isSynthetic())
		holder.icon_state = "robo"
	else if(stat == DEAD)
		holder.icon_state = "dead"
	else if(foundVirus)
		holder.icon_state = "ill1"
	else if(has_brain_worms())
		var/mob/living/simple_mob/animal/borer/B = has_brain_worms()
		holder.icon_state = B.controlling? "brainworm" : "healthy"
	else
		holder.icon_state = "healthy"

/mob/proc/update_hud_med_all()
	update_hud_med_health()
	update_hud_med_status()

/mob/proc/update_hud_sec_implants()
	var/image/Itrack = hud_list[IMPTRACK_HUD]
	var/image/Ichem = hud_list[IMPCHEM_HUD]
	var/image/Iloyal = hud_list[IMPLOYAL_HUD]
	Itrack?.icon_state = ""
	Ichem?.icon_state = ""
	Iloyal?.icon_state = ""
	for(var/obj/item/implant/I in src)
		if(!I.implanted)
			continue
		if(I.malfunction)
			continue
		if(istype(I, /obj/item/implant/tracking))
			Itrack?.icon_state = "tracking"
		if(istype(I, /obj/item/implant/loyalty))
			Iloyal?.icon_state = "loyal"
		if(istype(I, /obj/item/implant/chem))
			Ichem?.icon_state = "chem"

/mob/proc/update_hud_sec_job()
	return

/mob/living/carbon/human/update_hud_sec_job()
	. = ..()
	var/image/holder = hud_list[ID_HUD]
	if(!holder)
		return
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			holder.icon_state = "[ckey(I.GetJobName())]"
		else
			holder.icon_state = "unknown"
	else
		holder.icon_state = "unknown"

/mob/proc/update_hud_sec_status()
	var/image/holder = hud_list[WANTED_HUD]
	holder?.icon_state = ""

/mob/living/carbon/human/update_hud_sec_status()
	var/image/holder = hud_list[WANTED_HUD]
	if(!holder)
		return
	holder.icon_state = ""
	var/perpname = name
	if(wear_id)
		var/obj/item/card/id/I = wear_id.GetID()
		if(I)
			perpname = I.registered_name

	for(var/datum/data/record/E in data_core.general)
		if(E.fields["name"] == perpname)
			for (var/datum/data/record/R in data_core.security)
				if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
					holder.icon_state = "hudwanted"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
					holder.icon_state = "hudincarcerated"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
					holder.icon_state = "hudparolled"
					break
				else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
					holder.icon_state = "huddischarged"
					break

/mob/proc/update_hud_antag()
	var/image/holder = hud_list[ANTAG_HUD]
	if(!holder)
		return
	holder.icon_state = ""
	if(mind?.special_role)
		// ANTAG DATUM REFACTOR WHEN AUHGAOUSHGODHGHOAD
		if(hud_icon_reference[mind.special_role])
			holder.icon_state = hud_icon_reference[mind.special_role]
		else
			holder.icon_state = "syndicate"

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
