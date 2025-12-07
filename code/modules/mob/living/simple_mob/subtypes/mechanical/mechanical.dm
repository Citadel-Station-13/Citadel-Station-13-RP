// Mechanical mobs don't care about the atmosphere and cannot be hurt by tasers.
// They're also immune to poisons as they're entirely metal, however this also makes most of them vulnerable to shocks.
// They can also be hurt by EMP.

/mob/living/simple_mob/mechanical
	mob_class = MOB_CLASS_SYNTHETIC
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	taser_kill = FALSE
	poison_resist = 1.0
	shock_resist = -0.5

	//* mechanical simplemobs have these so commonly that we just add the functionality at root /mechanical level *//

	var/make_shield_comp = FALSE
	var/make_shield_comp_health = 100
	var/make_shield_comp_recharge_delay = 7 SECONDS
	var/make_shield_comp_recharge_rate = 10
	var/make_shield_comp_recharge_rebuild_rate = 10
	var/make_shield_comp_recharge_rebuild_ratio = 1
	var/make_shield_comp_pattern = /datum/directional_shield_pattern/square/r_3x3
	var/make_shield_comp_color_full = /datum/directional_shield_config::color_full
	var/make_shield_comp_color_depleted = /datum/directional_shield_config::color_depleted

/mob/living/simple_mob/mechanical/Initialize(mapload)
	. = ..()
	if(make_shield_comp)
		var/datum/component/directional_shield/standalone/recharging/shield_comp = AddComponent(/datum/component/directional_shield/standalone)
		// If we ever end up making a lot of these, consider making a preset variant of the component.
		if(make_shield_comp_health != shield_comp.health)
			shield_comp.health = health
		if(make_shield_comp_recharge_delay != shield_comp.recharge_delay)
			shield_comp.recharge_delay = recharge_delay
		if(make_shield_comp_recharge_rate != shield_comp.recharge_rate)
			shield_comp.recharge_rate = recharge_rate
		if(make_shield_comp_recharge_rebuild_rate != shield_comp.recharge_rebuild_rate)
			shield_comp.recharge_rebuild_rate = recharge_rebuild_rate
		if(make_shield_comp_recharge_rebuild_ratio != shield_comp.recharge_rebuild_ratio)
			shield_comp.recharge_rebuild_ratio = recharge_rebuild_ratio
		if(make_shield_comp_color_full != shield_comp.color_full)
			shield_comp.color_full = make_shield_comp_color_full
		if(make_shield_comp_color_depleted != shield_comp.color_depleted)
			shield_comp.color_depleted = make_shield_comp_color_depleted
		shield_comp.set_pattern(make_shield_comp_pattern)
		shield_comp.start()

/mob/living/simple_mob/mechanical/isSynthetic()
	return TRUE

/mob/living/simple_mob/mechanical/speech_bubble_appearance()
	return !has_iff_faction(MOB_IFF_FACTION_NEUTRAL) ? "synthetic_evil" : "machine"

// Fix for Virgo 2's Surface
/mob/living/simple_mob/mechanical
	maxbodytemp = 700
