/obj/item/vehicle_module/tool/orescanner
	name = "mounted ore scanner"
	desc = "An exosuit-mounted ore scanner."
	icon_state = "mecha_analyzer"
	origin_tech = list(TECH_MATERIAL = 2, TECH_MAGNET = 2, TECH_POWER = 2)
	equip_cooldown = 5
	energy_drain = 30
	range = MELEE|RANGED
	equip_type = EQUIP_SPECIAL
	ready_sound = 'sound/items/goggles_charge.ogg'
	required_type = list(/obj/vehicle/sealed/mecha/working/ripley)

	var/obj/item/mining_scanner/my_scanner = null
	var/exact_scan = FALSE

/obj/item/vehicle_module/tool/orescanner/Initialize(mapload)
	my_scanner = new(src)
	return ..()

/obj/item/vehicle_module/tool/orescanner/Destroy()
	QDEL_NULL(my_scanner)
	return ..()

/obj/item/vehicle_module/tool/orescanner/action(var/atom/target)
	if(!action_checks(target) || get_dist(chassis, target) > 5)
		return FALSE

	if(!enable_special)
		target = get_turf(chassis)

	var/datum/beam_legacy/ScanBeam = chassis.Beam(target, "g_beam", 'icons/effects/beam.dmi', 2 SECONDS, 10, /obj/effect/ebeam, 2)

	if(do_after(chassis.occupant_legacy, 2 SECONDS))
		my_scanner.ScanTurf(target, chassis.occupant_legacy, exact_scan)

	QDEL_NULL(ScanBeam)

/obj/item/vehicle_module/tool/orescanner/advanced
	name = "advanced ore scanner"
	icon_state = "mecha_analyzer_adv"
	exact_scan = TRUE
