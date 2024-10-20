/obj/item/reagent_containers/food/snacks/ice_cream
	name = "waffle cone"
	desc = "An empty waffle cone, presumably used to hold ice cream. How depressing."
	icon = 'icons/modules/food/items/ice_cream.dmi'
	icon_state = "wafflecone"
	color = "#ffcc66"
	appearance_flags = KEEP_TOGETHER
	w_class = WEIGHT_CLASS_TINY
	throw_force = 0
	damage_force = 0
	bitesize = 3

	// :troll:
	atom_flags = NOREACT

	/// already bit into? no double dipping!
	var/can_keep_scooping = TRUE
	/// overall sugar-ation; continuously compounded to be the % of scoops with sugar
	var/snowflake_deliciousness = 0
	/// max scoops
	var/scoop_max = 8
	/// current scoop position
	/// once we're biting out of it, this goes down with every bite and is used to track overlays.
	var/scoop_current = 0

	/// prefill with scoops of these reagents
	/// list(path, path, path, ...)
	/// do not do path = amount; the association part of the list
	/// is reserved for future use
	var/list/start_with_scoop_of
	/// standard scoop size
	var/start_with_scoop_size = 3

/obj/item/reagent_containers/food/snacks/ice_cream/Initialize(mapload)
	. = ..()
	var/created_any = FALSE
	for(var/key in start_with_scoop_of)
		created_any = add_scoop(key, start_with_scoop_size, update_icon = FALSE) || created_any
	if(created_any)
		update_appearance()

//! LEGACY CODE START

/obj/item/reagent_containers/food/snacks/ice_cream/attempt_feed(mob/living/M, mob/living/user)
	if(can_keep_scooping)
		// being bitten into for the first time, compute values as needed
		can_keep_scooping = FALSE
		// 1 bite per scoop, plus 1 for the base scoop, plus 1 for the cone
		bitesize = reagents.total_volume / (scoop_current + 1 + 1)
	. = ..()
	// add_bite_mark()

//! END

/**
 * If reagent source is a holder, we will consume reagent_amount from it; otherwise, we magically make more.
 */
/obj/item/reagent_containers/food/snacks/ice_cream/proc/add_scoop(reagent_source, reagent_amount, sugarized = TRUE, update_icon = TRUE)
	var/color
	if(istype(reagent_source, /datum/reagent))
		var/datum/reagent/from_reagent = reagent_source
		color = from_reagent.color
		reagents.add_reagent(from_reagent.id, reagent_amount)
	else if(ispath(reagent_source, /datum/reagent) || istext(reagent_source))
		var/datum/reagent/from_reagent = SSchemistry.fetch_reagent(reagent_source)
		color = from_reagent.color
		reagents.add_reagent(from_reagent.id, reagent_amount)
	else if(istype(reagent_source, /datum/reagent_holder))
		var/datum/reagent_holder/from_holder = reagent_source
		color = from_holder.get_color()
		from_holder.transfer_to_holder(reagents, amount = reagent_amount)

	var/list/pos = overlay_position(++scoop_current)
	if(isnull(pos))
		return TRUE
	var/image/dollop = image(icon, icon_state = "dollop", pixel_x = pos[1], pixel_y = pos[2])
	dollop.color = color
	dollop.appearance_flags = KEEP_APART | RESET_COLOR
	add_overlay(dollop)

	// todo: this is awful
	if(sugarized)
		reagents.add_reagent(/datum/reagent/sugar, 2)
		snowflake_deliciousness = ((snowflake_deliciousness * (scoop_current - 1)) + sugarized? 1 : 0) / scoop_current

	if(name == initial(name))
		name = "ice cream"
		desc = "Delicious ice cream. This one has [scoop_current] scoops."

	return TRUE

// todo: byond's renderer can go die in a goddamn fire; BLEND_SUBTRACT doesn't work for alpha masks obviously
//       so we don't have a fast way of rendering dynamic bite marks without having to hard-sprite shit,
//       which kinda ruins the point of dynamic ice cream, don't you think?
/*
/obj/item/reagent_containers/food/snacks/ice_cream/proc/add_bite_mark()
	var/pos = scoop_current--
	var/list/offsets = overlay_position(pos)
	if(isnull(offsets))
		return
	var/image/bite_overlay = image(icon = icon, icon_state = "bite_mask")
	bite_overlay.blend_mode = BLEND_SUBTRACT
	bite_overlay.pixel_x = offsets[1]
	bite_overlay.pixel_y = offsets[2]
	add_overlay(bite_overlay)
*/

/obj/item/reagent_containers/food/snacks/ice_cream/throw_land(atom/A, datum/thrownthing/TT)
	smash()
	return COMPONENT_THROW_HIT_TERMINATE

/obj/item/reagent_containers/food/snacks/ice_cream/proc/smash()
	visible_message(SPAN_WARNING("[src] falls, getting smushed in the process."))
	new /obj/effect/debris/cleanable/ice_cream(drop_location(), src)
	qdel(src)

/obj/item/reagent_containers/food/snacks/ice_cream/proc/overlay_position(i)
	switch(i)
		if(0)
			// this is bite mark for 'we're out'
			return list(0, -4)
		if(1)
			return list(0, 0)
		if(2)
			return list(-3, 3)
		if(3)
			return list(3, 3)
		if(4)
			return list(0, 5)
		if(5)
			return list(-5, 5)
		if(6)
			return list(5, 5)
		if(7)
			return list(-3, 8)
		if(8)
			return list(3, 8)

#define ICE_CREAM_PATHS(REAGENT_PATH, PATH_APPEND) \
/obj/item/reagent_containers/food/snacks/ice_cream/##PATH_APPEND { \
	start_with_scoop_of = list(REAGENT_PATH); \
} \
/obj/item/reagent_containers/food/snacks/ice_cream/##PATH_APPEND/double { \
	start_with_scoop_of = list(REAGENT_PATH, REAGENT_PATH); \
} \
/obj/item/reagent_containers/food/snacks/ice_cream/##PATH_APPEND/triple { \
	start_with_scoop_of = list(REAGENT_PATH, REAGENT_PATH, REAGENT_PATH); \
}

ICE_CREAM_PATHS(/datum/reagent/nutriment/vanilla, vanilla)
ICE_CREAM_PATHS(/datum/reagent/drink/milk/chocolate, chocolate)
ICE_CREAM_PATHS(/datum/reagent/drink/juice/lemon, lemon)
ICE_CREAM_PATHS(/datum/reagent/drink/juice/orange, orange)
ICE_CREAM_PATHS(/datum/reagent/drink/juice/apple, apple)

/obj/effect/debris/cleanable/ice_cream
	name = "smashed ice cream"
	desc = "How depressing."
	icon = 'icons/modules/food/items/ice_cream.dmi'
	icon_state = "melt1"
	appearance_flags = KEEP_TOGETHER
	atom_flags = NOREACT

	var/waffle_stage = 0
	var/melt_stage = 0

	/// list of colors
	var/list/dollops_left_colors
	/// final color
	var/final_color

/obj/effect/debris/cleanable/ice_cream/Initialize(mapload, obj/item/reagent_containers/food/snacks/ice_cream/from_cone)
	. = ..()
	dollops_left_colors = list()
	for(var/appearance/A as anything in from_cone?.overlays)
		if(A.icon_state != "dollop")
			continue
		dollops_left_colors += A.color
	create_reagents(1000)
	// we're not reacting btw :)
	from_cone.reagents.transfer_to_holder(reagents)
	// get final color
	final_color = reagents.get_color()
	// trigger reactions in a bit
	addtimer(CALLBACK(src, PROC_REF(start_reaction)), rand(0.5, 1.5 SECONDS))
	// trigger melt cycle
	melt_more()

/obj/effect/debris/cleanable/ice_cream/proc/start_reaction()
	reagents.set_no_react(FALSE)

/obj/effect/debris/cleanable/ice_cream/proc/melt_more()
	cut_overlays()

	melt_stage = min(3, melt_stage + 1)
	icon_state = "melt[melt_stage]"

	var/image/middle = image(icon, icon_state = "melt[melt_stage]")
	middle.layer = FLOAT_LAYER - 2
	middle.color = final_color
	middle.appearance_flags = KEEP_APART | RESET_COLOR
	add_overlay(middle)

	// todo: this doesn't work; we need melting dollop states..
	if(length(dollops_left_colors))
		color = BlendRGB(color || "#ffffff", dollops_left_colors[1], 0.5)
		dollops_left_colors.Cut(1, 2)
		for(var/color in dollops_left_colors)
			var/image/dollop = image(icon = icon, icon_state = "dollop")
			dollop.color = color
			dollop.pixel_x = rand(-8, 8)
			dollop.pixel_y = rand(-8, 8) - 4
			dollop.appearance_flags = KEEP_APART | RESET_COLOR
			dollop.layer = FLOAT_LAYER - 1
			var/image/puddle = image(dollop)
			puddle.icon_state = "melt[melt_stage]"
			puddle.layer = FLOAT_LAYER - 2
			puddle.pixel_y = 4
			add_overlay(puddle)

	if(length(dollops_left_colors) || melt_stage < 3 || waffle_stage < 3)
		addtimer(CALLBACK(src, PROC_REF(melt_more)), rand(2, 5 MINUTES))

	waffle_stage = min(3, waffle_stage + 1)
	var/image/waffle = image(icon = icon, icon_state = "waffledrop[waffle_stage]")
	waffle.color = "#ffcc66"
	waffle.appearance_flags = KEEP_APART | RESET_COLOR
	waffle.layer = FLOAT_LAYER
	add_overlay(waffle)
