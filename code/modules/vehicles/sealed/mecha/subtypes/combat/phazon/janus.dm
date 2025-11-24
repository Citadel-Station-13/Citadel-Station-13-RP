/datum/armor/vehicle/mecha/combat/phazon/janus
	melee = 0.45
	melee_tier = 3
	bullet = 0.375
	bullet_tier = 4.5
	laser = 0.375
	laser_tier = 4.5
	energy = 0.5
	bomb = 0.5

/obj/vehicle/sealed/mecha/combat/phazon/janus
	name = "Phazon Prototype Janus Class"
	desc = "A sleek exosuit that radiates a strange, alien energy."
	description_fluff = "An incredibly high-tech exosuit constructed out of salvaged alien components fused with cutting-edge modern technology. This machine is theoretically capable of sublight travel. However, due to the vaguely anomalous nature of its miniaturized, supermatter-fueled Toroidal Bluespace Drive, it is uncertain how this ability manifests."
	icon_state = "janus"
	initial_icon = "janus"

	base_movement_speed = 4
	armor_type = /datum/armor/vehicle/mecha/combat/phazon/janus

	dir_in = 1 //Facing North.
	wreckage = /obj/effect/decal/mecha_wreckage/janus
	internal_damage_threshold = 25
	phasing_energy_drain = 300

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)
	modules_intrinsic = list()

	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE

/obj/vehicle/sealed/mecha/combat/phazon/janus/inflict_damage_instance(damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, attack_source, shieldcall_flags, hit_zone, list/additional)
	. = ..()
	if(.[SHIELDCALL_ARG_DAMAGE] > 5 && !(.[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_GRADUAL))
		if(phasing)
			phasing = FALSE
			radiation_pulse(src, RAD_INTENSITY_MECH_JANUS_FORCED_UNPHASE)
			visible_message("<span class='alien'>The [src.name] appears to flicker, before its silhouette stabilizes!</span>")

/obj/effect/decal/mecha_wreckage/janus
	name = "Janus wreckage"
	icon_state = "janus-broken"
	description_info = "Due to the incredibly intricate design of this exosuit, it is impossible to salvage components from it."
