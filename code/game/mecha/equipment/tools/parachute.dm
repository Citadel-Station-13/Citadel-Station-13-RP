/obj/item/mecha_parts/mecha_equipment/tool/parachute
	name = "heavy-duty parachute pack"
	desc = "This assembly of three industrial parachutes is designed for heavy cargo drops over terrain too difficult for shuttles to land on."
	icon_state = "mecha_jetpack"
	equip_cooldown = 15
	energy_drain = 50

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/tool/parachute/proc/toggle()
	if(!chassis)
		return
	!equip_ready? pack() : unpack()
	return equip_ready

/obj/item/mecha_parts/mecha_equipment/tool/parachute/proc/pack()
	occupant_message("Packed")
	log_message("Packed")
	parachute = TRUE

/obj/item/mecha_parts/mecha_equipment/tool/parachute/proc/unpack()
	occupant_message("Unpacked")
	log_message("Unpacked")
	parachute = FALSE
