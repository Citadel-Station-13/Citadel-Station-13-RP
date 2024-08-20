/obj/machinery/porta_turret/stationary/shielded
	var/obj/item/shield_projector/rectangle/shield_projector
	var/shield_health = 150
	var/shield_regen_delay = 10 SECONDS
	var/shield_regen_amount = 10
	var/shield_size_x = 1
	var/shield_size_y = 1

/obj/machinery/porta_turret/stationary/shielded/hostile
	check_all = TRUE

/obj/machinery/porta_turret/stationary/shielded/Initialize(mapload)
	shield_projector = new /obj/item/shield_projector/rectangle(src)
	shield_projector.shield_health = shield_health
	shield_projector.max_shield_health = shield_health
	shield_projector.shield_regen_delay = shield_regen_delay
	shield_projector.shield_regen_amount = shield_regen_amount
	shield_projector.size_x = shield_size_x
	shield_projector.size_y = shield_size_y

	// we do this here so that the above changes get included
	shield_projector.always_on = TRUE
	shield_projector.create_shields()
	return ..()
