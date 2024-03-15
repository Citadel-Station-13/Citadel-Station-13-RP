#define AQUARIUM_LAYER_STEP 0.01
/// Aquarium content layer offsets
#define AQUARIUM_MIN_OFFSET 0.01
#define AQUARIUM_MAX_OFFSET 1

/obj/structure/aquarium
	name = "aquarium"
	density = TRUE
	anchored = TRUE

	icon = 'icons/modules/fishing/aquarium.dmi'
	icon_state = "aquarium_base"

	integrity = 100
	integrity_max = 100
	integrity_failure = 0.3

	var/fluid_type = AQUARIUM_FLUID_FRESHWATER
	var/fluid_temp = DEFAULT_AQUARIUM_TEMP
	var/min_fluid_temp = MIN_AQUARIUM_TEMP
	var/max_fluid_temp = MAX_AQUARIUM_TEMP

	/// Can fish reproduce in this quarium.
	var/allow_breeding = FALSE

	var/glass_icon_state = "aquarium_glass"
	var/broken_glass_icon_state = "aquarium_glass_broken"

	//This is the area where fish can swim
	var/aquarium_zone_min_px = 2
	var/aquarium_zone_max_px = 31
	var/aquarium_zone_min_py = 10
	var/aquarium_zone_max_py = 24

	var/list/fluid_types = list(
		AQUARIUM_FLUID_SALTWATER,
		AQUARIUM_FLUID_FRESHWATER,
		AQUARIUM_FLUID_SULPHWATEVER,
		AQUARIUM_FLUID_AIR,
	)

	var/panel_open = TRUE

	///Current layers in use by aquarium contents
	var/list/used_layers = list()

	/// /obj/item/fish in the aquarium - does not include things with aquarium visuals that are not fish
	var/list/tracked_fish = list()

/obj/structure/aquarium/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/aquarium/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(istype(arrived,/obj/item/fish))
		tracked_fish += arrived

/obj/structure/aquarium/Exited(atom/movable/gone, direction)
	. = ..()
	tracked_fish -= gone

/obj/structure/aquarium/proc/request_layer(layer_type)
	/**
	 * base aq layer
	 * min_offset = this value is returned on bottom layer mode
	 * min_offset + 0.1 fish1
	 * min_offset + 0.2 fish2
	 * ... these layers are returned for auto layer mode and tracked by used_layers
	 * min_offset + max_offset = this value is returned for top layer mode
	 * min_offset + max_offset + 1 = this is used for glass overlay
	 */
	//optional todo: hook up sending surface changed on aquarium changing layers
	switch(layer_type)
		if(AQUARIUM_LAYER_MODE_BOTTOM)
			return layer + AQUARIUM_MIN_OFFSET
		if(AQUARIUM_LAYER_MODE_TOP)
			return layer + AQUARIUM_MAX_OFFSET
		if(AQUARIUM_LAYER_MODE_AUTO)
			var/chosen_layer = layer + AQUARIUM_MIN_OFFSET + AQUARIUM_LAYER_STEP
			while((chosen_layer in used_layers) && (chosen_layer <= layer + AQUARIUM_MAX_OFFSET))
				chosen_layer += AQUARIUM_LAYER_STEP
			used_layers += chosen_layer
			return chosen_layer

/obj/structure/aquarium/proc/free_layer(value)
	used_layers -= value

/obj/structure/aquarium/proc/get_surface_properties()
	. = list()
	.[AQUARIUM_PROPERTIES_PX_MIN] = aquarium_zone_min_px
	.[AQUARIUM_PROPERTIES_PX_MAX] = aquarium_zone_max_px
	.[AQUARIUM_PROPERTIES_PY_MIN] = aquarium_zone_min_py
	.[AQUARIUM_PROPERTIES_PY_MAX] = aquarium_zone_max_py

/obj/structure/aquarium/update_overlays()
	. = ..()
	if(panel_open)
		. += "panel"

	//Glass overlay goes on top of everything else.
	var/mutable_appearance/glass_overlay = mutable_appearance(icon, (atom_flags & ATOM_BROKEN) ? broken_glass_icon_state : glass_icon_state,layer=AQUARIUM_MAX_OFFSET-1)
	. += glass_overlay

/obj/structure/aquarium/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("Alt-click to [panel_open ? "close" : "open"] the control panel.")

/obj/structure/aquarium/AltClick(mob/user)
	if(!user.Reachability(src))
		return ..()
	if(user.incapacitated(INCAPACITATION_KNOCKDOWN))
		user.action_feedback(SPAN_WARNING("You can't do that right now!"), src)
		return TRUE
	panel_open = !panel_open
	update_appearance()
	return TRUE

/obj/structure/aquarium/dynamic_tool_query(obj/item/I, datum/event_args/actor/clickchain/e_args, list/hint_images = list())
	. = ..()
	if(allow_unanchor)
		LAZYSET(.[TOOL_WRENCH], anchored? "unanchor" : "anchor", anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH))

/obj/structure/aquarium/wrench_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	if(!allow_unanchor)
		return ..()
	if(use_wrench(I, e_args, delay = 4 SECONDS))
		log_construction(e_args.performer, src, "fastened")
		set_anchored(!anchored)
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_NOTICE("[e_args.performer] [anchored? "fastens [src] to the ground" : "unfastens [src] from the ground"]."),
			audible = SPAN_WARNING("You hear bolts being [anchored? "fastened" : "unfastened"]"),
			otherwise_self = SPAN_NOTICE("You [anchored? "fasten" : "unfasten"] [src]."),
		)
		return TRUE
	return ..()

/obj/structure/aquarium/attackby(obj/item/I, mob/living/user, params)
	SEND_SIGNAL(src, COMSIG_AQUARIUM_DISTURB_FISH)
	if(atom_flags & ATOM_BROKEN)
		var/obj/item/stack/material/glass/glass = I
		if(istype(glass))
			if(glass.get_amount() < 2)
				to_chat(user, SPAN_WARNING("You need two glass sheets to fix the case!"))
				return
			user.action_feedback(SPAN_NOTICE("You start fixing [src]..."), src)
			if(do_after(user, 2 SECONDS, target = src))
				glass.use(2)
				heal_integrity(integrity_max)
				update_appearance()
			return CLICKCHAIN_DID_SOMETHING
	else
		if(istype(I, /obj/item/fish_feed))
			user.action_feedback(SPAN_NOTICE("You feed the fish."), src)
			for(var/obj/item/fish/fish in src)
				fish.on_feeding(I.reagents)
			return CLICKCHAIN_DID_SOMETHING
		var/datum/component/aquarium_content/content_component = I.GetComponent(/datum/component/aquarium_content)
		if(content_component && content_component.is_ready_to_insert(src))
			if(user.transfer_item_to_loc(I, src))
				update_appearance()
				return CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/structure/aquarium/interact(mob/user)
	if(!(atom_flags & ATOM_BROKEN) && user.pulling && isliving(user.pulling))
		var/mob/living/living_pulled = user.pulling
		var/datum/component/aquarium_content/content_component = living_pulled.GetComponent(/datum/component/aquarium_content)
		if(content_component && content_component.is_ready_to_insert(src))
			try_to_put_mob_in(user)
	else if(panel_open)
		. = ..() //call base ui_interact
	else
		admire(user)

/// Tries to put mob pulled by the user in the aquarium after a delay
/obj/structure/aquarium/proc/try_to_put_mob_in(mob/user)
	if(!isliving(user.pulling))
		return
	var/mob/living/living_pulled = user.pulling
	if(living_pulled.buckled || living_pulled.has_buckled_mobs())
		user.action_feedback(SPAN_WARNING("[living_pulled] is attached to something!"))
		return
	user.visible_action_feedback(
		target = src,
		visible_hard = SPAN_WARNING("[user] starts to put [living_pulled] into [src]!"),
		visible_soft = SPAN_WARNING("[user] starts to put something into [src]!")
	)
	if(!do_after(user, 10 SECONDS, target = src))
		return
	if(QDELETED(living_pulled) || user.pulling != living_pulled || living_pulled.buckled || living_pulled.has_buckled_mobs())
		return
	var/datum/component/aquarium_content/content_component = living_pulled.GetComponent(/datum/component/aquarium_content)
	if(content_component || content_component.is_ready_to_insert(src))
		return
	user.visible_action_feedback(
		target = src,
		visible_hard = SPAN_WARNING("[user] stuffs [living_pulled] into [src]!"),
		visible_soft = SPAN_WARNING("[user] stuffs something into [src]!"),
	)
	living_pulled.forceMove(src)
	update_appearance()

///Apply mood bonus depending on aquarium status
/obj/structure/aquarium/proc/admire(mob/living/user)
	to_chat(user, SPAN_NOTICE("You take a moment to watch [src]."))
	if(do_after(user, 2 SECONDS, target = src))
		var/alive_fish = 0
		var/dead_fish = 0
		for(var/obj/item/fish/fish in tracked_fish)
			if(fish.status == FISH_ALIVE)
				alive_fish++
			else
				dead_fish++
		if(alive_fish > 0)
			to_chat(user, SPAN_NOTICE("Aww! There's living fish!"))
		else if(dead_fish > 0)
			to_chat(user, SPAN_WARNING("The fish are all dead!"))

/obj/structure/aquarium/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["fluid_type"] = fluid_type
	.["temperature"] = fluid_temp
	.["allow_breeding"] = allow_breeding
	var/list/content_data = list()
	for(var/atom/movable/fish in contents)
		content_data += list(list("name"=fish.name,"ref"=ref(fish)))
	.["contents"] = content_data

/obj/structure/aquarium/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	//I guess these should depend on the fluid so lava critters can get high or stuff below water freezing point but let's keep it simple for now.
	.["minTemperature"] = min_fluid_temp
	.["maxTemperature"] = max_fluid_temp
	.["fluidTypes"] = fluid_types

/obj/structure/aquarium/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("temperature")
			var/temperature = params["temperature"]
			if(isnum(temperature))
				fluid_temp = clamp(temperature, min_fluid_temp, max_fluid_temp)
				. = TRUE
		if("fluid")
			if(params["fluid"] in fluid_types)
				fluid_type = params["fluid"]
				SEND_SIGNAL(src, COMSIG_AQUARIUM_FLUID_CHANGED, fluid_type)
				. = TRUE
		if("allow_breeding")
			allow_breeding = !allow_breeding
			. = TRUE
		if("remove")
			var/atom/movable/inside = locate(params["ref"]) in contents
			if(inside)
				if(isitem(inside))
					user.put_in_hands_or_drop(inside)
				else
					inside.forceMove(get_turf(src))
				user.action_feedback(SPAN_NOTICE("You take out [inside] from [src]."), src)

/obj/structure/aquarium/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Aquarium", name)
		ui.open()

// todo: refactor on atom damage!!
/obj/structure/aquarium/atom_break(damage_flag)
	. = ..()
	aquarium_smash()

/obj/structure/aquarium/proc/aquarium_smash()
	var/possible_destinations_for_fish = list()
	var/droploc = drop_location()
	if(isturf(droploc))
		possible_destinations_for_fish = get_adjacent_open_turfs(droploc)
	else
		possible_destinations_for_fish = list(droploc)
	playsound(src, 'sound/effects/glassbr3.ogg', 100, TRUE)
	for(var/atom/movable/fish in contents)
		fish.forceMove(pick(possible_destinations_for_fish))
	/*
	if(fluid_type != AQUARIUM_FLUID_AIR)
		var/datum/reagents/reagent_splash = new()
		reagent_splash.add_reagent(/datum/reagent/water, 30)
		chem_splash(droploc, null, 3, list(reagent_splash))
	*/
	update_appearance()

#undef AQUARIUM_LAYER_STEP
#undef AQUARIUM_MIN_OFFSET
#undef AQUARIUM_MAX_OFFSET

/obj/structure/aquarium/prefilled/Initialize(mapload)
	. = ..()

	new /obj/item/aquarium_prop/rocks(src)
	new /obj/item/aquarium_prop/seaweed(src)

	new /obj/item/fish/goldfish(src)
	new /obj/item/fish/angelfish(src)
	new /obj/item/fish/guppy(src)
