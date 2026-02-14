///The area is a "Station" area, showing no special text.
#define AREA_STATION 1
///The area is in outdoors (lavaland/icemoon/jungle/space), therefore unclaimed territories.
#define AREA_OUTDOORS 2
///The area is special (shuttles/centcom), therefore can't be claimed.
#define AREA_SPECIAL 3

///The blueprints are currently reading the list of all wire datums.
#define LEGEND_VIEWING_LIST "watching_list"
///The blueprints are on the main page.
#define LEGEND_OFF "off"

/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	preserve_item = 1

	integrity_flags = INTEGRITY_INDESTRUCTIBLE | INTEGRITY_LAVAPROOF | INTEGRITY_FIREPROOF | INTEGRITY_ACIDPROOF
	interaction_flags_atom = parent_type::interaction_flags_atom | INTERACT_ATOM_ALLOW_USER_LOCATION | INTERACT_ATOM_IGNORE_MOBILITY

	///A string of flavortext to be displayed at the top of the UI, related to the type of blueprints we are.
	var/fluffnotice = "Property of Nanotrasen. For heads of staff only. Store in high-secure storage."
	///Boolean on whether the blueprints are currently being used, which prevents double-using them to rename/create areas.
	var/in_use_INTERNAL = FALSE
	///The type of area we'll create when we make a new area. This is a typepath.
	var/area/new_area_type = /area
	///The legend type the blueprints are currently looking at, which is either modularly
	///set by wires datums, the main page, or an overview of them all.
	var/legend_viewing = LEGEND_OFF

	///List of images that we're showing to a client, used for showing blueprint data.
	var/list/image/showing = list()
	///The client that is being shown the list of 'showing' images of blueprint data.
	var/client/viewing

/obj/item/blueprints/Destroy()
	clear_viewer()
	return ..()

/obj/item/blueprints/dropped(mob/user)
	. = ..()
	clear_viewer()
	legend_viewing = LEGEND_OFF

/obj/item/blueprints/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Blueprints", name)
		ui.open()

/obj/item/blueprints/ui_state(mob/user)
	return GLOB.inventory_state

/obj/item/blueprints/ui_data(mob/user)
	var/list/data = list()
	switch(get_area_type(user))
		if(AREA_OUTDOORS)
			data["area_notice"] = "You are in unclaimed territory."
		if(AREA_SPECIAL)
			data["area_notice"] = "This area has no notes."
		else
			var/area/current_area = get_area(user)
			data["area_notice"] = "You are now in \the [current_area.name]"
	var/area/area_inside_of = get_area(user)
	data["area_name"] = html_encode(area_inside_of.name)
	data["legend"] = legend_viewing
	data["viewing"] = !!viewing
	data["wire_data"] = list()
	if(legend_viewing != LEGEND_VIEWING_LIST && legend_viewing != LEGEND_OFF)
		for(var/device in GLOB.wire_color_directory)
			if("[device]" != legend_viewing)
				continue
			data["wires_name"] = device //GLOB.wire_name_directory[device]
			for(var/individual_color in GLOB.wire_color_directory[device])
				var/wire_name = GLOB.wire_color_directory[device][individual_color]
				if(findtext(wire_name, WIRE_DUD_PREFIX)) //don't show duds
					continue
				data["wire_data"] += list(list(
					"color" = individual_color,
					"message" = wire_name,
				))
	return data

/obj/item/blueprints/ui_static_data(mob/user)
	var/list/data = list()
	data["legend_viewing_list"] = LEGEND_VIEWING_LIST
	data["legend_off"] = LEGEND_OFF
	data["fluff_notice"] = fluffnotice
	data["station_name"] = station_name()
	data["wire_devices"] = list()
	for(var/wireset in GLOB.wire_color_directory)
		data["wire_devices"] += list(list(
			"name" = wireset, //GLOB.wire_name_directory[wireset],
			"ref" = wireset,
		))
	return data

/obj/item/blueprints/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user
	if (user.restrained() || user.stat)
		return TRUE
	// if(!user.can_perform_action(src, NEED_LITERACY|NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING))
	// 	return TRUE

	switch(action)
		if("create_area")
			if(in_use_INTERNAL)
				return
			in_use_INTERNAL = TRUE
			create_area(user, new_area_type)
			in_use_INTERNAL = FALSE
		if("edit_area")
			if(get_area_type(user) != AREA_STATION)
				return
			if(in_use_INTERNAL)
				return
			in_use_INTERNAL = TRUE
			edit_area(user)
			in_use_INTERNAL = FALSE
		if("exit_legend")
			legend_viewing = LEGEND_OFF
		if("view_legend")
			legend_viewing = LEGEND_VIEWING_LIST
		if("view_wireset")
			var/setting_wireset = params["view_wireset"]
			for(var/device in GLOB.wire_color_directory)
				if("[device]" == setting_wireset) //I know... don't change it...
					legend_viewing = setting_wireset
					return TRUE
		if("view_blueprints")
			playsound(src, 'sound/items/paper_flip.ogg', 40, TRUE)
			user.balloon_alert_to_viewers("flips blueprints over")
			set_viewer(user)
		if("hide_blueprints")
			playsound(src, 'sound/items/paper_flip.ogg', 40, TRUE)
			user.balloon_alert_to_viewers("flips blueprints over")
			clear_viewer()
		if("refresh")
			playsound(src, 'sound/items/paper_flip.ogg', 40, TRUE)
			clear_viewer()
			set_viewer(user)
	return TRUE

/**
 * Sets the user's client as the person viewing blueprint data, and builds blueprint data
 * around the user.
 * Args:
 * - user: The person who's client we're giving images to.
 */
/obj/item/blueprints/proc/set_viewer(mob/user)
	if(!user || !user.client)
		return
	if(viewing)
		clear_viewer()
	viewing = user.client
	showing = get_blueprint_data(get_turf(viewing.eye || user), viewing.view)
	viewing.images |= showing

/**
 * Clears the client we're showig images to and deletes the images of blueprint data
 * we made to show them.
 */
/obj/item/blueprints/proc/clear_viewer()
	if(viewing)
		viewing.images -= showing
		viewing = null
	showing.Cut()

/**
 * Gets the area type the user is currently standing in.
 * Returns: AREA_STATION, AREA_OUTDOORS, or AREA_SPECIAL
 * Args:
 * - user: The person we're getting the area of to check if it's a special area.
 */
/obj/item/blueprints/proc/get_area_type(mob/user)
	var/area/area_checking = get_area(user)
	var/static/list/outdoors_area = list(
		/area/space,
		/area/mine
	)
	if(area_checking.type in outdoors_area)
		return AREA_OUTDOORS
	var/static/list/special_areas = typecacheof(list(
		/area/shuttle,
		/area/admin,
		/area/arrival,
		/area/centcom,
		/area/asteroid,
		/area/tdome,
		/area/syndicate_station,
		/area/wizard_station,
		/area/prison
	))
	if(area_checking.type in special_areas)
		return AREA_SPECIAL
	return AREA_STATION

/**
 * edit_area
 * Takes input from the player and renames the area the blueprints are currently in.
 */
/obj/item/blueprints/proc/edit_area(mob/user)
	var/area/area_editing = get_area(src)
	var/prevname = "[area_editing.name]"
	var/new_name = tgui_input_text(user, "New area name", "Area Creation", max_length = MAX_NAME_LEN)
	if(isnull(new_name) || !length(new_name) || new_name == prevname)
		return

	rename_area(area_editing, new_name)
	user.balloon_alert(user, "area renamed to [new_name]")
	// user.log_message("has renamed [prevname] to [new_name]", LOG_GAME)
	return TRUE

///Cyborg blueprints - The same as regular but with a different fluff text.
/obj/item/blueprints/cyborg
	name = "station schematics"
	desc = "A digital copy of the station blueprints stored in your memory."
	fluffnotice = "Intellectual Property of Nanotrasen. For use in engineering cyborgs only. Wipe from memory upon departure from the station."


#undef LEGEND_VIEWING_LIST
#undef LEGEND_OFF

#undef AREA_STATION
#undef AREA_OUTDOORS
#undef AREA_SPECIAL
