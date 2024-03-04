/obj/item/modular_computer/proc/take_damage_legacy(damage_amount, damage_type = BRUTE)
	var/component_probability = min(50, max(damage_amount*0.1, 1 - integrity/integrity_max))
	if(component_probability && damage_type == BRUTE) // legacy
		integrity -= component_probability
		integrity = clamp(integrity, 0,  integrity_max)

	switch(damage_flag)
		if(BRUTE)
			component_probability = damage_amount * 0.5
		if(SEARING)
			component_probability = damage_amount * 0.66

	if(component_probability)
		for(var/I in all_components)
			var/obj/item/computer_hardware/H = all_components[I]
			if(prob(component_probability))
				H.take_damage_legacy(round(damage_amount*0.5))

	if(integrity <= 0)
		break_apart()

/obj/item/modular_computer/deconstructed(method)
	break_apart()

/obj/item/modular_computer/break_apart()
	if(!(integrity_flags & INTEGRITY_NO_DECONSTRUCT))
		physical.visible_message(SPAN_NOTICE("\The [src] breaks apart!"))
		var/turf/newloc = get_turf(src)
		new /obj/item/stack/material/steel(newloc, round(steel_sheet_cost/2))
		for(var/C in all_components)
			var/obj/item/computer_hardware/H = all_components[C]
			if(QDELETED(H))
				continue
			uninstall_component(H)
			H.forceMove(newloc)
			if(prob(25))
				H.take_damage_legacy(rand(10,30))
	relay_qdel()
	qdel(src)

//! old proc function helpers

/**
 * Stronger explosions cause serious damage to internal components
 * Minor explosions are mostly mitigitated by casing.
 */
/obj/item/modular_computer/legacy_ex_act(severity)
	. = ..()
	take_damage_legacy(rand(100,200) / severity, 30 / severity)

/// EMPs are similar to explosions, but don't cause physical damage to the casing. Instead they screw up the components
/obj/item/modular_computer/emp_act(severity)
	. = ..()
	take_damage_legacy(rand(100,200) / severity, 50 / severity, FALSE)

/**
 * "Stun" weapons can cause minor damage to components (short-circuits?)
 * "Burn" damage is equally strong against internal components and exterior casing
 * "Brute" damage mostly damages the casing.
 */
/obj/item/modular_computer/bullet_act(obj/projectile/Proj)
	. = ..()
	take_damage_legacy(Proj.damage, Proj.damage_type)
