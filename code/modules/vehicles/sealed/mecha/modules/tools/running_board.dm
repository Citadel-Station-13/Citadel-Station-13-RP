// concept borrowed from vgstation-coders/vgstation13#26316 on GitHub
/obj/item/vehicle_module/runningboard
	name = "hacked powered exosuit running board"
	desc = "A running board with a power-lifter attachment, to quickly catapult exosuit pilots into the cockpit. Fits any exosuit."
	icon_state = "mecha_runningboard"
	origin_tech = list(TECH_MATERIAL = 6)
	equip_type = EQUIP_HULL

/obj/item/vehicle_module/runningboard/limited
	name = "powered exosuit running board"
	desc = "A running board with a power-lifter attachment, to quickly catapult exosuit pilots into the cockpit. Only fits to working exosuits."

/obj/item/vehicle_module/runningboard/limited/can_attach(obj/vehicle/sealed/mecha/M)
	if(istype(M, /obj/vehicle/sealed/mecha/working)) // is this a ripley?
		. = ..()
	else
		return FALSE
