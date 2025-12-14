/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/modules/artwork/items/crayons.dmi'
	icon_state = "crayonred"
	w_class = WEIGHT_CLASS_TINY
	attack_verb = list("attacked", "coloured")
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	pen_color = "#FF0000" //RGB
	clickable = FALSE

	// todo: reorganize vars
	/// color name
	var/crayon_color_name = "red"
	/// what we show as; e.g. 'crayon', 'marker'
	var/crayon_name = "crayon"
	/// uses left; null for infinite
	var/remaining = 30
	/// time to draw graffiti
	var/debris_time = 5 SECONDS
	/// path to decal; must be a subtype of /obj/effect/debris/cleanable/crayon!
	var/debris_path = /obj/effect/debris/cleanable/crayon
	/// pickable colors
	var/list/crayon_pickable_colors
	/// can pick any color
	var/crayon_free_recolor = FALSE
	/// active color
	var/crayon_color
	/// the reagents in us
	var/crayon_reagent_type = /datum/reagent/crayon_dust
	/// the reagents in us
	var/crayon_reagent_amount = 6
	/// sound to play
	var/crayon_sound
	/// can eat
	var/crayon_edible = TRUE

	// todo: per user this so you can't see what someone else was about to do lmao
	/// currently picked datapack string path
	var/current_graffiti_icon_string_path
	/// currently picked datapack icon state
	var/current_graffiti_icon_state
	/// currently picked angle
	var/current_graffiti_angle = 0

	/// has cap
	var/cappable = FALSE
	/// capped?
	var/capped = FALSE

/obj/item/pen/crayon/Initialize(mapload)
	. = ..()
	if(!isnull(crayon_pickable_colors))
		crayon_pickable_colors = typelist(NAMEOF(src, crayon_pickable_colors), crayon_pickable_colors)
	if(length(crayon_pickable_colors))
		crayon_color = crayon_pickable_colors[1]
	else if(isnull(crayon_color))
		crayon_color = pen_color || color || "#ffffff"
	create_reagents(crayon_reagent_amount)
	reagents.add_reagent(crayon_reagent_type, crayon_reagent_amount)

/obj/item/pen/crayon/examine(mob/user, dist)
	. = ..()
	if(dist <= 1 && !isnull(remaining))
		. += SPAN_NOTICE("It has [remaining] left.")

/obj/item/pen/crayon/update_name(updates)
	name = "[crayon_color_name] [initial(name)]"
	return ..()

/obj/item/pen/crayon/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Crayon")
		ui.open()

/obj/item/pen/crayon/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	var/list/datapacks = list()
	for(var/datum/crayon_decal_meta/datapack in GLOB.crayon_data)
		datapacks[++datapacks.len] = datapack.tgui_crayon_data()
	.["datapacks"] = datapacks
	.["cappable"] = cappable
	.["anyColor"] = crayon_free_recolor
	.["colorList"] = crayon_pickable_colors
	.["canonicalName"] = crayon_name

/obj/item/pen/crayon/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["capped"] = capped
	.["graffitiPickedIcon"] = current_graffiti_icon_string_path
	.["graffitiPickedState"] = current_graffiti_icon_state
	.["graffitiPickedAngle"] = current_graffiti_angle
	.["graffitiPickedColor"] = crayon_color

/obj/item/pen/crayon/ui_asset_injection(datum/tgui/ui, list/immediate, list/deferred)
	immediate += /datum/asset_pack/spritesheet/crayons
	return ..()

/obj/item/pen/crayon/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("cap")
			if(!cappable)
				return TRUE
			set_capped(!capped)
			usr.visible_message(SPAN_NOTICE("[usr] [capped? "caps" : "uncaps"] [src]."), range = MESSAGE_RANGE_ITEM_SOFT)
			return TRUE
		if("angle")
			current_graffiti_angle = text2num(params["angle"])
			return TRUE
		if("pick")
			var/picked_icon = params["icon"]
			var/picked_state = params["state"]
			if(isnull(GLOB.crayon_data_lookup_by_string_icon_path[picked_icon]))
				return TRUE
			var/datum/crayon_decal_meta/datapack = GLOB.crayon_data_lookup_by_string_icon_path[picked_icon]
			if(!(picked_state in datapack.states))
				return TRUE
			current_graffiti_icon_string_path = picked_icon
			current_graffiti_icon_state = picked_state
			return TRUE
		if("color")
			var/picked_color = params["color"]
			if(crayon_free_recolor)
				picked_color = sanitize_hexcolor(picked_color, 6, TRUE, "#ffffff")
			else if(!isnull(crayon_pickable_colors) && !(picked_color in crayon_pickable_colors))
				return TRUE
			else
				return TRUE
			crayon_color = picked_color
			return TRUE

/obj/item/pen/crayon/proc/set_capped(capped)
	src.capped = capped
	update_icon()

/obj/item/pen/crayon/proc/make_graffiti(atom/target, datum/crayon_decal_meta/datapack, state, angle, pixel_x = 0, pixel_y = 0)
	if(isnull(datapack))
		datapack = GLOB.crayon_data_lookup_by_string_icon_path[current_graffiti_icon_string_path]
		if(isnull(datapack))
			return
	if(isnull(state))
		state = current_graffiti_icon_state
	if(isnull(angle))
		angle = current_graffiti_angle
	var/obj/effect/debris/cleanable/crayon/created = new debris_path(target, datapack, crayon_color, state, angle, pixel_x, pixel_y)
	return created

/obj/item/pen/crayon/proc/color_entity(atom/target)
	return FALSE

/obj/item/pen/crayon/proc/attempt_make_graffiti(atom/target, datum/event_args/actor/actor, datum/crayon_decal_meta/datapack, state, angle, pixel_x, pixel_y)
	var/cost = 1

	if(isnull(datapack))
		datapack = GLOB.crayon_data_lookup_by_string_icon_path[current_graffiti_icon_string_path]
		if(isnull(datapack))
			actor.chat_feedback(
				SPAN_WARNING("Pick a stencil first!"),
				src,
			)
			return FALSE
	if(isnull(state))
		state = current_graffiti_icon_state
	if(isnull(angle))
		angle = current_graffiti_angle

	if(!has_remaining(cost))
		actor.chat_feedback(
			SPAN_WARNING("There isn't enough left of [src] to draw graffiti."),
			src,
		)
		return FALSE
	if(capped)
		actor.chat_feedback(
			SPAN_WARNING("[src] is capped."),
			src,
		)
		return FALSE

	if(debris_time)
		actor.visible_feedback(
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_WARNING("[actor.performer] starts to draw on [target] with [src]!"),
			visible_self = SPAN_WARNING("You start to draw on [target] with [src]!"),
		)
		if(!do_after(actor.performer, debris_time, target, mobility_flags = MOBILITY_CAN_USE | MOBILITY_CAN_HOLD))
			return FALSE
		if(capped)
			actor.chat_feedback(
				SPAN_WARNING("[src] is capped."),
				src,
			)
			return FALSE

	if(!use_remaining(cost))
		actor.chat_feedback(
			SPAN_WARNING("There isn't enough left of [src] to draw graffiti."),
			src,
		)
		return FALSE

	actor.visible_feedback(
		range = MESSAGE_RANGE_CONSTRUCTION,
		visible = SPAN_WARNING("[actor.performer] draws some graffiti on [target]!"),
		visible_self = SPAN_WARNING("You draw some graffiti on [target]!"),
	)

	playsound(src, crayon_sound, 50, TRUE, -1)

	. = make_graffiti(target, datapack, state, angle, pixel_x, pixel_y)
	if(.)
		log_construction(actor, ., "created graffiti ([datapack] - [state])")

/obj/item/pen/crayon/proc/attempt_color_entity(atom/target, datum/event_args/actor/actor)
	// todo: implement attempt_color_entity
	return FALSE

/obj/item/pen/crayon/proc/has_remaining(amount)
	if(isnull(remaining))
		return TRUE
	return amount <= remaining

/obj/item/pen/crayon/proc/use_remaining(amount)
	if(isnull(remaining))
		return TRUE
	. = remaining >= amount
	remaining = max(0, remaining - amount)

/obj/item/pen/crayon/proc/switch_color(new_color)
	crayon_color = new_color

/obj/item/pen/crayon/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return ..()
	if(crayon_edible && iscarbon(user) && target == user)
		var/mob/living/carbon/eater = user
		to_chat(user, SPAN_WARNING("You take a bite out of [src] and swallow it. Was that a good idea?"))
		// todo: logging
		reagents.trans_to(eater.ingested, 1 / 5 * reagents.maximum_volume)
		if(!reagents.total_volume)
			qdel(src)
		return CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/pen/crayon/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return ..()
	var/datum/event_args/actor/e_args = new(user)
	if(isturf(target))
		var/decoded_px = text2num(params["icon-x"]) - 16
		var/decoded_py = text2num(params["icon-y"]) - 16
		attempt_make_graffiti(target, e_args, pixel_x = decoded_px, pixel_y = decoded_py)
		return CLICKCHAIN_DID_SOMETHING
	else if(ismob(target))
		return ..()
	else if(isobj(target))
		attempt_color_entity(target, e_args)
		return CLICKCHAIN_DID_SOMETHING
	return ..()

/obj/item/pen/crayon/red
	icon_state = "crayonred"
	pen_color = "#DA0000"
	crayon_color_name = "red"

/obj/item/pen/crayon/orange
	icon_state = "crayonorange"
	pen_color = "#FF9300"
	crayon_color_name = "orange"

/obj/item/pen/crayon/yellow
	icon_state = "crayonyellow"
	pen_color = "#FFF200"
	crayon_color_name = "yellow"

/obj/item/pen/crayon/green
	icon_state = "crayongreen"
	pen_color = "#A8E61D"
	crayon_color_name = "green"

/obj/item/pen/crayon/blue
	icon_state = "crayonblue"
	pen_color = "#00B7EF"
	crayon_color_name = "blue"

/obj/item/pen/crayon/purple
	icon_state = "crayonpurple"
	pen_color = "#DA00FF"
	crayon_color_name = "purple"

/obj/item/pen/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	pen_color = "#FFFFFF"
	crayon_color_name = "mime"
	remaining = null
	crayon_pickable_colors = list(
		"#FFFFFF",
		"#000000",
	)

/obj/item/pen/crayon/rainbow
	icon_state = "crayonrainbow"
	pen_color = "#FFF000"
	crayon_color_name = "rainbow"
	remaining = null
	crayon_free_recolor = TRUE
