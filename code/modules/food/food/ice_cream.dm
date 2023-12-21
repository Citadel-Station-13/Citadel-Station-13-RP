/obj/item/reagent_containers/food/snacks/ice_cream
	name = "waffle cone"
	desc = "An empty waffle cone, presumably used to hold ice cream. How depressing."
	icon = 'icons/modules/food/items/ice_cream.dmi'
	icon_state = "wafflecone"
	appearance_flags = KEEP_TOGETHER
	w_class = WEIGHT_CLASS_TINY
	throw_force = 0
	damage_force = 0
	bitesize = 2

	// :troll:
	atom_flags = NOREACT

	/// already bit into? no double dipping!
	var/no_double_dipping = FALSE
	/// overall sugar-ation; continuously compounded to be the % of scoops with sugar
	var/snowflake_deliciousness = 0
	/// max scoops
	var/scoop_max = 7
	/// current scoop position
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

/obj/item/reagent_containers/food/snacks/ice_cream/update_icon(updates)
	. = ..()


/obj/item/reagent_containers/food/snacks/ice_cream/proc/add_scoop(reagent_source, reagent_amount, update_icon = TRUE)
	if(istype(reagent_source, /datum/reagent))
		var/datum/reagent/from_reagent = reagent_source
	else if(ispath(reagent_source, /datum/reagent) || istext(reagent_source))
		var/datum/reagent/from_reagent = SSchemistry.fetch_reagent(reagent_source)
	else if(istype(reagent_source, /datum/reagents))
		var/datum/reagents/from_holder = reagent_source

	#warn impl

	return TRUE

#warn macro path generation for: vanilla, chocolate, apple, orange, lime

#warn icon states are dollop, melt1-3, wafflecone, waffledrop1-3

/obj/effect/debris/cleanable/ice_cream
	name = "smashed ice cream"
	desc = "How depressing."
	icon = 'icons/modules/food/items/ice_cream.dmi'
	icon_state = "melt1"

	#warn impl

	var/waffle_stage = 1

	/// list of colors
	var/list/dollops_left_colors

/obj/effect/debris/cleanable/ice_cream/Initialize(mapload, obj/item/reagent_containers/food/snacks/ice_cream/from_cone)
	. = ..()
	#warn impl
	addtimer(CALLBACK(src, PROC_REF(melt_more)), rand(2, 5 MINUTES))

/obj/effect/debris/cleanable/ice_cream/proc/melt_more()
	#warn uhh

	cut_overlays()

	waffle_stage = min(3, waffle_stage + 1)
	#warn waffle overlay

	if(length(dollops_left_colors))
		addtimer(CALLBACK(src, PROC_REF(melt_more)), rand(2, 5 MINUTES))


