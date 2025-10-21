/obj/item/vehicle_module/legacy/tool/powertool/welding
	name = "welding laser"
	desc = "An exosuit-mounted welding laser."
	icon_state = "mecha_laser-rig"
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 4, TECH_PHORON = 2)
	equip_cooldown = 3
	energy_drain = 15
	range = MELEE|RANGED
	ready_sound = 'sound/items/Ratchet.ogg'
	tooltype = /obj/item/weldingtool/electric/mounted/exosuit

/obj/item/vehicle_module/legacy/tool/powertool/welding/Initialize(mapload)
	. = ..()
	my_tool.reach = 7

/obj/item/vehicle_module/legacy/tool/powertool/welding/action(var/atom/target)
	..()

	var/datum/beam_legacy/weld_beam = null
	var/atom/movable/beam_origin = chassis
	weld_beam = beam_origin.Beam(target, icon_state = "solar_beam", time = 0.3 SECONDS)

	if(!do_after(chassis.occupant_legacy, 0.3 SECONDS, target))
		qdel(weld_beam)
