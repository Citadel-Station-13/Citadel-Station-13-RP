/datum/orbit_menu
	var/mob/observer/dead/owner

/datum/orbit_menu/New(mob/observer/dead/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/orbit_menu/ui_state()
	return GLOB.observer_state

/datum/orbit_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Orbit")
		ui.open()

/datum/orbit_menu/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("orbit")
			var/ref = params["ref"]
			var/atom/movable/poi = locate(ref) in GLOB.mob_list
			if (poi == null)
				poi = locate(ref) in SSshuttle.ships
			if (poi == null)
				. = TRUE
				return
			owner.ManualFollow(poi)
			owner.reset_perspective(null)
			. = TRUE
		if("refresh")
			update_static_data()
			. = TRUE

/datum/orbit_menu/ui_static_data(mob/user, datum/tgui/ui)
	var/list/data = list()

	var/list/players = list()
	var/list/simplemobs = list()
	var/list/items_of_interest = list()
	var/list/ghosts = list()
	var/list/misc = list()
	var/list/npcs = list()

	for(var/name in sortmobs())
		var/list/serialized = list()
		serialized["name"] = name

		serialized["ref"] = REF(name)

		var/mob/M = name

		if(M == user)
			continue//Should only really happen with observers, but just to be sure

		if(!istype(M))
			misc += list(serialized)
			continue

		if(isobserver(M))
			if(M.invisibility >= INVISIBILITY_MAXIMUM)
				continue
			ghosts += list(serialized)
		else if(issimple(M))
			simplemobs += list(serialized)
		else if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.ai_holder || !H.mobility_flags)
				npcs += list(serialized)
			else
				players += list(serialized)
		else if(isrobot(M))
			players += list(serialized)
		else if(isAI(M))
			players += list(serialized)
		else if(istype(M, /mob/living/silicon/pai))
			players += list(serialized)

	for(var/obj/overmap/entity/visitable/ship/shuttle in SSshuttle.ships)
		if(istype(shuttle))
			var/list/serialized = list()
			serialized["name"] = shuttle.name

			serialized["ref"] = REF(shuttle)
			items_of_interest += list(serialized)


	data["players"] = players
	data["simplemobs"] = simplemobs
	data["items_of_interest"] = items_of_interest
	data["ghosts"] = ghosts
	data["misc"] = misc
	data["npcs"] = npcs

	return data

/datum/orbit_menu/ui_assets(mob/user)
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/orbit)
