/obj/vehicle/sealed/mecha/combat/phazon/janus
	name = "Phazon Prototype Janus Class"
	desc = "A sleek exosuit that radiates a strange, alien energy."
	icon_state = "janus"
	initial_icon = "janus"

	base_movement_speed = 4

	dir_in = 1 //Facing North.
	step_energy_drain = 3
	integrity = 350
	integrity_max = 350
	damage_absorption = list("brute"=0.6,"fire"=0.7,"bullet"=0.7,"laser"=0.9,"energy"=0.7,"bomb"=0.5)
	wreckage = /obj/effect/decal/mecha_wreckage/janus
	internal_damage_threshold = 25
	force = 20
	phasing_energy_drain = 300

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE
	cloak_possible = FALSE

/obj/vehicle/sealed/mecha/combat/phazon/janus/take_damage_legacy(amount, type="brute")
	..()
	if(phasing)
		phasing = FALSE
		radiation_pulse(src, RAD_INTENSITY_MECH_JANUS_FORCED_UNPHASE)
		log_append_to_last("WARNING: BLUESPACE DRIVE INSTABILITY DETECTED. DISABLING DRIVE.",1)
		visible_message("<span class='alien'>The [src.name] appears to flicker, before its silhouette stabilizes!</span>")

/obj/vehicle/sealed/mecha/combat/phazon/janus/dynbulletdamage(var/obj/projectile/Proj)
	if((Proj.damage_force && !Proj.nodamage) && !istype(Proj, /obj/projectile/beam) && prob(max(1, 33 - round(Proj.damage_force / 4))))
		src.occupant_message("<span class='alien'>The armor absorbs the incoming projectile's force, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] absorbs the incoming projectile's force, negating it!</span>")
		src.log_append_to_last("Armor negated.")
		return
	else if((Proj.damage_force && !Proj.nodamage) && istype(Proj, /obj/projectile/beam) && prob(max(1, (50 - round((Proj.damage_force / 2) * damage_absorption["laser"])) * (1 - (max(BULLET_TIER_DEFAULT - Proj.damage_tier, 0) * 0.25)))))	// Base 50% chance to deflect a beam,lowered by half the beam's damage scaled to laser absorption, then multiplied by the remaining percent of non-penetrated armor, with a minimum chance of 1%.
		src.occupant_message("<span class='alien'>The armor reflects the incoming beam, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] reflects the incoming beam, negating it!</span>")
		src.log_append_to_last("Armor reflected.")
		return
	..()

/obj/vehicle/sealed/mecha/combat/phazon/janus/dynattackby(obj/item/W as obj, mob/user as mob)
	if(prob(max(1, (50 - round((W.damage_force / 2) * damage_absorption["brute"])) * (1 - max(BULLET_TIER_DEFAULT - W.damage_tier, 0) * 0.25))))
		src.occupant_message("<span class='alien'>The armor absorbs the incoming attack's force, negating it!</span>")
		src.visible_message("<span class='alien'>The [src.name] absorbs the incoming attack's force, negating it!</span>")
		src.log_append_to_last("Armor absorbed.")
		return
	..()

/obj/vehicle/sealed/mecha/combat/phazon/janus/query_damtype()
	var/new_damtype = alert(src.occupant_legacy,"Gauntlet Phase Emitter Mode",null,"Force","Energy","Stun")
	switch(new_damtype)
		if("Force")
			damtype = "brute"
		if("Energy")
			damtype = "fire"
		if("Stun")
			damtype = "halloss"
	src.occupant_message("Melee damage type switched to [new_damtype]")
