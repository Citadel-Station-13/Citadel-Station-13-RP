
/obj/item/vehicle_module/shield_projector/omnidirectional
	icon_state = "shield"
	energy_drain = OMNI_SHIELD_DRAIN

	step_delay = 0.2

/obj/item/vehicle_module/shield_projector/omnidirectional/critfail()
	..()
	shields.adjust_health(-200)

/obj/item/vehicle_module/shield_projector/omnidirectional/attach(obj/vehicle/sealed/mecha/M as obj)
	. = ..()
	if(chassis)
		shields = new shield_type(chassis)

/obj/item/vehicle_module/shield_projector/omnidirectional/detach()
	if(chassis)
		QDEL_NULL(shields)
	. = ..()

/obj/item/vehicle_module/shield_projector/omnidirectional/handle_movement_action()
	if(chassis && shields)
		shields.update_shield_positions()

/obj/item/vehicle_module/shield_projector/omnidirectional/proc/toggle_shield()
	if(shields)
		shields.set_on(!shields.active)
		if(shields.active)
			set_ready_state(0)
			step_delay = 4
			log_message("Activated.")
		else
			set_ready_state(1)
			step_delay = initial(step_delay)
			log_message("Deactivated.")

/obj/item/vehicle_module/shield_projector/omnidirectional/Topic(href, href_list)
	..()
	if(href_list["toggle_omnishield"])
		toggle_shield()

/obj/item/vehicle_module/shield_projector/omnidirectional/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_omnishield=1'>[shields?.active?"Dea":"A"]ctivate</a>"

