GLOBAL_DATUM_INIT(orbit_menu, /datum/orbit_menu, new)

/datum/orbit_menu
	///mobs worth orbiting. Because spaghetti, all mobs have the point of interest, but only some are allowed to actually show up.
	///this obviously should be changed in the future, so we only add mobs as POI if they actually are interesting, and we don't use
	///a typecache.
	var/static/list/mob_allowed_typecache

/datum/orbit_menu/ui_state(mob/user)
	return GLOB.observer_state

/datum/orbit_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Orbit")
		ui.open()

/datum/orbit_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()

	if(.)
		return

	switch(action)
		if("orbit")
			var/ref = params["ref"]
			// not implemented
			// var/auto_observe = params["auto_observe"]
			// no sspoi :(
			var/atom/poi = locate(ref) in GLOB.mob_list

			if (poi == null)
				poi = locate(ref) in SSshuttle.ships
			if (poi == null)
				. = TRUE
				return

			var/mob/observer/dead/user = usr
			user.ManualFollow(poi)
			user.reset_perspective(null)
			user.orbiting_ref = ref
			return TRUE
		if ("refresh")
			ui.send_full_update()
			return TRUE

	return FALSE

/datum/orbit_menu/ui_data(mob/user)
	var/list/data = list()

	if(isobserver(user))
		data["orbiting"] = get_currently_orbiting(user)

	return data

/datum/orbit_menu/ui_static_data(mob/user)
	var/is_admin = user?.client?.holder

	var/list/alive = list()
	var/list/antagonists = list()
	var/list/critical = list()
	var/list/deadchat_controlled = list()
	var/list/dead = list()
	var/list/ghosts = list()
	var/list/misc = list()
	var/list/npcs = list()

	// sortmobs is a generic list
	for(var/mobthing in sortmobs())
		var/list/serialized = list()
		var/mob/mob_poi = mobthing
		// var/number_of_orbiters = length(mob_poi.get_all_orbiters())

		// ignore magical objects
		if (isEye(mob_poi) || isvoice(mob_poi))
			continue

		var/name = mob_poi.real_name || mob_poi.name
		if(mob_poi.stat == DEAD)
			if(isobserver(mob_poi))
				name += " \[ghost\]"
			else
				name += " \[dead\]"

		serialized["ref"] = REF(mob_poi)
		serialized["full_name"] = name
		// if(number_of_orbiters)
		// 	serialized["orbiters"] = number_of_orbiters

		if(isobserver(mob_poi))
			// TODO what does this mean? invismin???
			if(mob_poi.invisibility >= INVISIBILITY_MAXIMUM)
				continue
			ghosts += list(serialized)
			continue

		if(mob_poi.stat == DEAD)
			dead += list(serialized)
			continue

		if(isnull(mob_poi.mind))
			if(isliving(mob_poi))
				var/mob/living/npc = mob_poi
				serialized["health"] = FLOOR((npc.health / npc.maxHealth * 100), 1)

			npcs += list(serialized)
			continue

		serialized["client"] = !!mob_poi.client
		serialized["name"] = mob_poi.real_name

		if (is_admin)
			serialized["ckey"] = mob_poi.ckey

		if(isliving(mob_poi))
			serialized += get_living_data(mob_poi)

		alive += list(serialized)

	for(var/atom/movable/atom_poi as anything in SSshuttle.ships)
		var/list/other_data = get_misc_data(atom_poi)
		var/misc_data = list(other_data[1])

		misc += misc_data

		if(other_data[2]) // Critical = TRUE
			critical += misc_data

	return list(
		"alive" = alive,
		"antagonists" = antagonists,
		"critical" = critical,
		"deadchat_controlled" = deadchat_controlled,
		"dead" = dead,
		"ghosts" = ghosts,
		"misc" = misc,
		"npcs" = npcs,
		"can_observe" = FALSE, // autoobserve
	)

// do we need it immediately? nah
// /datum/orbit_menu/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
// 	immediate += /datum/asset_pack/simple/orbit
// 	return ..()

/// Shows the UI to the specified user.
/datum/orbit_menu/proc/show(mob/user)
	ui_interact(user)

/// Helper to get the current thing we're orbiting (if any)
/datum/orbit_menu/proc/get_currently_orbiting(mob/observer/dead/user)
	if(isnull(user.orbiting_ref))
		return

	// double locate since we dont hold the ref directly
	var/atom/poi = locate(user.orbiting_ref) in GLOB.mob_list
	if (isnull(poi))
		poi = locate(user.orbiting_ref) in SSshuttle.ships

	if(isnull(poi))
		user.orbiting_ref = null
		return

	if (ismob(poi) && (isEye(poi) || isvoice(poi)))
		user.orbiting_ref = null
		return

	var/list/serialized = list()

	if(!ismob(poi))
		var/list/misc_info = get_misc_data(poi)
		serialized += misc_info[1]
		return serialized

	var/mob/mob_poi = poi
	serialized["full_name"] = mob_poi.name
	serialized["ref"] = REF(poi)

	if(mob_poi.mind)
		serialized["client"] = !!mob_poi.client
		serialized["name"] = mob_poi.real_name

	if(isliving(mob_poi))
		serialized += get_living_data(mob_poi)

	return serialized

/// Helper function to get job / icon / health data for a living mob
/datum/orbit_menu/proc/get_living_data(mob/living/player) as /list
	var/list/serialized = list()

	serialized["health"] = FLOOR((player.health / player.maxHealth * 100), 1)
	if(issilicon(player))
		serialized["job"] = player.job
		serialized["icon"] = "borg"
		return serialized

	var/obj/item/card/id/id_card = player.GetIdCard()
	serialized["job"] = id_card?.assignment || id_card?.rank
	serialized["icon"] = "hudunknown" //id_card?

	var/job = player.mind?.assigned_role
	if (isnull(job))
		return serialized

	serialized["mind_job"] = job
	// var/datum/outfit/outfit = job.get_outfit()
	// if (isnull(outfit))
	// 	return serialized

	// var/datum/id_trim/trim = outfit.id_trim
	// if (!isnull(trim))
	// 	serialized["mind_icon"] = trim::sechud_icon_state
	return serialized

/// Gets a list: Misc data and whether it's critical. Handles all snowflakey type cases
/datum/orbit_menu/proc/get_misc_data(atom/movable/atom_poi) as /list
	var/list/misc = list()
	var/critical = FALSE

	misc["ref"] = REF(atom_poi)
	misc["full_name"] = atom_poi.name

	// Display the supermatter crystal integrity
	if(istype(atom_poi, /obj/machinery/power/supermatter))
		var/obj/machinery/power/supermatter/crystal = atom_poi
		var/integrity = round(crystal.get_integrity())
		misc["extra"] = "Integrity: [integrity]%"

		if(integrity < 10)
			critical = TRUE

		return list(misc, critical)

	// Display the shuttle
	if (istype(atom_poi, /obj/overmap/entity/visitable/ship))
		var/obj/overmap/entity/visitable/ship/shuttle = atom_poi
		// see shuttle.get_scan_data
		if (!shuttle.is_moving())
			misc["extra"] = "Ship is stationary."
		else
			misc["extra"] = "Heading: [shuttle.get_heading()] Velocity: [shuttle.get_speed_legacy() * 1000]"

		// TODO somehow figure out the station ship & its shuttle then flag it as critical
		return list(misc, critical)

	return list(misc, critical)
