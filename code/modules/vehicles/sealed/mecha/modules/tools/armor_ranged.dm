/obj/item/vehicle_module/antiproj_armor_booster
	name = "\improper RW armor booster"
	desc = "Ranged-weaponry armor booster. Boosts exosuit armor against ranged attacks. Completely blocks taser shots, but requires energy to operate."
	icon_state = "mecha_abooster_proj"
	origin_tech = list(TECH_MATERIAL = 4)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

	step_delay = 1

	equip_type = EQUIP_HULL

/obj/item/vehicle_module/antiproj_armor_booster/handle_projectile_contact(var/obj/projectile/Proj, var/inc_damage)
	if(!action_checks(src))
		return inc_damage
	if(prob(chassis.deflect_chance*deflect_coeff))
		chassis.occupant_message("<span class='notice'>The armor deflects incoming projectile.</span>")
		chassis.visible_message("The [chassis.name] armor deflects the projectile.")
		chassis.log_append_to_last("Armor saved.")
		inc_damage = 0
	else
		inc_damage *= src.damage_coeff
	set_ready_state(0)
	chassis.use_power(energy_drain)
	spawn()
		do_after_cooldown()
	return max(0, inc_damage)

/obj/item/vehicle_module/antiproj_armor_booster/handle_ranged_contact(var/obj/A, var/inc_damage = 0)
	if(!action_checks(A))
		return inc_damage
	if(prob(chassis.deflect_chance*deflect_coeff))
		chassis.occupant_message("<span class='notice'>The [A] bounces off the armor.</span>")
		chassis.visible_message("The [A] bounces off \the [chassis]'s armor")
		chassis.log_append_to_last("Armor saved.")
		inc_damage = 0
	else if(istype(A, /obj))
		inc_damage *= damage_coeff
	set_ready_state(0)
	chassis.use_power(energy_drain)
	spawn()
		do_after_cooldown()
	return max(0, inc_damage)

/obj/item/vehicle_module/antiproj_armor_booster/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"
