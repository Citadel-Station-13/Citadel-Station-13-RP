/datum/chemical_reaction/stack_synthesis
	abstract_type = /datum/chemical_reaction/stack_synthesis
	require_whole_numbers = TRUE
	important_for_logging = TRUE

	/// stack path
	var/stack_path
	/// stack amount per 1 multiplier
	var/stack_amount = 1

/datum/chemical_reaction/stack_synthesis/on_reaction_instant(datum/reagent_holder/holder, multiplier)
	. = ..()
	var/turf/where_we_are = get_turf(holder.my_atom)
	if(!isturf(where_we_are))
		return
	on_synthesis(holder, multiplier, where_we_are)

/**
 * standard abstraction for synthesis reactions
 */
/datum/chemical_reaction/stack_synthesis/proc/on_synthesis(datum/reagent_holder/holder, multiplier, turf/where)
	// todo: split stack as needed
	new stack_path(where, multiplier * stack_amount)

/datum/chemical_reaction/stack_synthesis/deuterium
	name = "Deuterium"
	id = "stack-deuterium"
	required_reagents = list("hydrophoron" = 5, "water" = 10)
	stack_path = /obj/item/stack/material/deuterium
	stack_amount = 15

/datum/chemical_reaction/stack_synthesis/plastication
	name = "Plastic"
	id = "solidplastic"
	required_reagents = list("pacid" = 1, "plasticide" = 2)
	stack_path = /obj/item/stack/material/plastic

/datum/chemical_reaction/stack_synthesis/wax
	name = "Wax"
	id = "wax"
	required_reagents = list("hydrogen" = 1, MAT_CARBON = 1, "tallow" = 2)
	stack_path = /obj/item/stack/material/wax
