/obj/machinery/porta_turret/stationary/shielded
	var/make_shield_comp_health = 150
	var/make_shield_comp_recharge_delay = 0 SECONDS
	var/make_shield_comp_recharge_rate = 5
	var/make_shield_comp_recharge_rebuild_rate = 25
	var/make_shield_comp_recharge_rebuild_ratio = 0.75
	var/make_shield_comp_pattern = /datum/directional_shield_pattern/square/r_3x3
	var/make_shield_comp_color_full = /datum/directional_shield_config::color_full
	var/make_shield_comp_color_depleted = /datum/directional_shield_config::color_depleted

/obj/machinery/porta_turret/stationary/shielded/Initialize(mapload)
	. = ..()
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

/obj/machinery/porta_turret/stationary/shielded/hostile
	check_all = TRUE
