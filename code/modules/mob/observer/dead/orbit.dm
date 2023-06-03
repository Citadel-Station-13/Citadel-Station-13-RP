/datum/orbit_menu
	var/mob/observer/dead/owner

/datum/orbit_menu/New(mob/observer/dead/new_owner)
	if(!istype(new_owner))
		qdel(src)
	owner = new_owner

/datum/orbit_menu/ui_state(mob/user)
	return GLOB.observer_state

/datum/orbit_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Orbit")
		ui.open()

/datum/orbit_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("orbit")
			var/ref = params["ref"]
			var/atom/movable/poi = locate(ref) in GLOB.mob_list
			if (poi == null)
				. = TRUE
				return
			owner.ManualFollow(poi)
			owner.reset_perspective(null)
			. = TRUE
		if("refresh")
			update_static_data()
			. = TRUE

/datum/orbit_menu/ui_data(mob/user)
	var/list/data = list()

	var/list/players = list()
	var/list/simplemobs = list()
	var/list/items_of_interest = list()
	var/list/ghosts = list()
	var/list/misc = list()

	for(var/name in sortmobs())
		var/list/serialized = list()
		serialized["name"] = name

		serialized["ref"] = REF(name)

		var/mob/M = name
		if(!istype(M))
			misc += list(serialized)
			continue

		if(isobserver(M))
			ghosts += list(serialized)
		else if(issimple(M))
			simplemobs += list(serialized)
		else if(ishuman(M) && M.ckey)
			players = list(serialized)

	data["players"] = players
	data["simplemobs"] = simplemobs
	data["items_of_interest"] = items_of_interest
	data["ghosts"] = ghosts
	data["misc"] = misc

	return data

/datum/orbit_menu/ui_assets(mob/user)
	. = ..() || list()
	. += get_asset_datum(/datum/asset/simple/orbit)
