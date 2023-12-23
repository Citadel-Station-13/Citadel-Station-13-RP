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
	var/no_double_dipping = FALSE
	/// overall sugar-ation; continuously compounded to be the % of scoops with sugar
	var/snowflake_deliciousness = 0
	/// max scoops
	var/scoop_max = 7
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
	if(!no_double_dipping)
		// being bitten into for the first time, compute values as needed
		no_double_dipping = TRUE
		// 1 bite per scoop, plus 1 for the base scoop, plus 1 for the cone
		bitesize = reagents.total_volume / (scoop_current + 1 + 1)
	. = ..()
	add_bite()

//! END

/obj/item/reagent_containers/food/snacks/ice_cream/proc/add_scoop(reagent_source, reagent_amount, update_icon = TRUE)
	if(istype(reagent_source, /datum/reagent))
		var/datum/reagent/from_reagent = reagent_source
	else if(ispath(reagent_source, /datum/reagent) || istext(reagent_source))
		var/datum/reagent/from_reagent = SSchemistry.fetch_reagent(reagent_source)
	else if(istype(reagent_source, /datum/reagents))
		var/datum/reagents/from_holder = reagent_source

	#warn impl

	return TRUE

/obj/item/reagent_containers/food/snacks/ice_cream/proc/add_bite()
	#warn impl

/obj/item/reagent_containers/food/snacks/ice_cream/proc/overlay_position(i)
	switch(i)
		if(1)
			return list(0, 0)


#warn icon states are dollop, melt1-3, wafflecone, waffledrop1-3

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

	var/waffle_stage = 1
	var/melt_stage = 1

	/// list of colors
	var/list/dollops_left_colors

/obj/effect/debris/cleanable/ice_cream/Initialize(mapload, obj/item/reagent_containers/food/snacks/ice_cream/from_cone)
	. = ..()
	create_reagents(1000)
	addtimer(CALLBACK(src, PROC_REF(start_reaction)), rand(0.5, 1.5 SECONDS))
	melt_more()

/obj/effect/debris/cleanable/ice_cream/proc/start_reaction()
	atom_flags &= ~NOREACT
	reagents?.handle_reactions()

/obj/effect/debris/cleanable/ice_cream/proc/melt_more()
	cut_overlays()

	melt_stage = min(3, melt_stage + 1)
	icon_state = "melt[melt_stage]"

	if(length(dollops_left_colors))
		color = BlendRGB(color || "#ffffff", dollops_left_colors[1], 0.5)
		dollops_left_colors.Cut(1, 2)
		for(var/color in dollops_left_colors)
			var/image/dollop = image(icon = icon, icon_state = "dollop")
			dollop.color = color
			dollop.pixel_x = rand(-8, 8)
			dollop.pixel_y = rand(-8, 8)
			dollop.appearance_flags = KEEP_APART | RESET_COLOR
			add_overlay(dollop)

		addtimer(CALLBACK(src, PROC_REF(melt_more)), rand(2, 5 MINUTES))

	waffle_stage = min(3, waffle_stage + 1)
	var/image/waffle = image(icon = icon, icon_state = "waffledrop[waffle_stage]")
	waffle.color = "#ffcc66"
	waffle.appearance_flags = KEEP_APART | RESET_COLOR
	add_overlay(waffle)
