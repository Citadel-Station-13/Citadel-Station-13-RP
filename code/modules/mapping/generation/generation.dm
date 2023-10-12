//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * a procedural generation instance
 */
/datum/map_generation
	/// master seed
	var/seed
	/// terrain layers - list of paths to init at new
	var/list/datum/map_layer/terrain_layers = list()
	/// entity layers - list of paths to init at new
	var/list/datum/map_layer/entity_layers = list()

	/// user-defined var on presets: danger +- of normal; 100 = 100% more, -100 = 50% less
	var/danger = 0
	/// user-defined var on presets: reward +- of normal; 100 = 100% more, -100 = 50% less
	var/reward = 0
	/// user-defined var on presets: rare things +- of normal; 100 = 100% more chance of rare things, -100 = 50% less
	var/rarity = 0

/datum/map_generation/New(seed = sha1(GUID()), danger, reward, rarity)
	src.seed = seed
	if(!isnull(danger))
		src.danger = danger
	if(!isnull(reward))
		src.reward = reward
	if(!isnull(rarity))
		src.rarity = rarity
	setup()

/**
 * Sets up layers; mostly used for presets.
 *
 * Default behavior: set up all paths in layers list.
 */
/datum/map_generation/proc/setup()
	for(var/i in 1 to length(terrain_layers))
		if(ispath(terrain_layers[i]))
			terrain_layers[i] = new terrain_layers[i]
	for(var/i in 1 to length(entity_layers))
		if(ispath(entity_layers[i]))
			entity_layers[i] = new entity_layers[i]

/**
 * operates on the given world coords
 *
 * anything in this coords cannot be assuredly safe, though most layers respect
 *
 * @params
 * * x - lowerleft x
 * * y - lowerleft y
 * * z - lowerleft z
 * * width - width in tiles
 * * height - height in tiles
 * * offset_x - offset generation by this much ; otherwise lower left is 0, 0 on layer maps
 * * offset_y - offset generation by this much ; otherwise lower left is 0, 0 on layer maps
 */
/datum/map_generation/proc/friendly_generate(x, y, z, width, height, offset_x = 0, offset_y = 0)
	var/list/bounds = new /list(MAP_BOUNDS)
	bounds[MAP_MINX] = x
	bounds[MAP_MAXX] = x + width - 1
	bounds[MAP_MINY] = y
	bounds[MAP_MAXY] = y + width - 1
	bounds[MAP_MINZ] = z
	bounds[MAP_MAXZ] = z
	return generate(
		bounds,
		offset_x,
		offset_y,
		z,
	)
	#warn impl

/datum/map_generation/proc/generate(list/bounds, offset_x, offset_y, offset_z)
	#warn impl

/datum/map_generation/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "MapgenInstance")
		ui.open()

/datum/map_generation/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.admin_state

/datum/map_generation/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn impl

/datum/map_generation/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	#warn impl

/datum/map_generation/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	#warn impl

/datum/map_generation/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(null, "-----")
	VV_DROPDOWN_OPTION(VV_HK_MAPGEN_MODIFY, "Edit with GUI")

/datum/map_generation/vv_do_topic(list/href_list)
	. = ..()
	if(.)
		return
	if(href_list[VV_HK_MAPGEN_MODIFY])
		ui_interact(usr)
		return TRUE
