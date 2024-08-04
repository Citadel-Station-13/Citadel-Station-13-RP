//* Raw Damage *//

/mob/living/silicon/robot/take_targeted_damage(brute, burn, damage_mode, body_zone, weapon_descriptor, defer_updates)
	var/list/components = get_damageable_components()
	if(!components.len)
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(has_active_type(/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = locate() in src
		if(shield && shield.active)
			//Shields absorb a certain percentage of damage based on their power setting.
			var/absorb_brute = brute*shield.shield_level
			var/absorb_burn = burn*shield.shield_level
			var/cost = (absorb_brute+absorb_burn) * 25

			cell.charge -= cost
			if(cell.charge <= 0)
				cell.charge = 0
				to_chat(src, "<font color='red'>Your shield has overloaded!</font>")
			else
				brute -= absorb_brute
				burn -= absorb_burn
				to_chat(src, "<font color='red'>Your shield absorbs some of the impact!</font>")

	if(!(damage_mode & DAMAGE_MODE_INTERNAL))
		var/datum/robot_component/armour/A = get_armour()
		if(A)
			A.take_damage_legacy(brute,burn)
			return

	var/datum/robot_component/C = pick(components)
	C.take_damage_legacy(brute,burn)

/mob/living/silicon/robot/take_overall_damage(brute, burn, damage_mode, weapon_descriptor, defer_updates)
	if(status_flags & STATUS_GODMODE)
		return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(has_active_type(/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = locate() in src
		if(shield)
			//Shields absorb a certain percentage of damage based on their power setting.
			var/absorb_brute = brute*shield.shield_level
			var/absorb_burn = burn*shield.shield_level
			var/cost = (absorb_brute+absorb_burn) * 25

			cell.charge -= cost
			if(cell.charge <= 0)
				cell.charge = 0
				to_chat(src, "<font color='red'>Your shield has overloaded!</font>")
			else
				brute -= absorb_brute
				burn -= absorb_burn
				to_chat(src, "<font color='red'>Your shield absorbs some of the impact!</font>")

	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_damage_legacy(brute,burn)
		return

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.take_damage_legacy(brute,burn)

		brute	-= (picked.brute_damage - brute_was)
		burn	-= (picked.electronics_damage - burn_was)

		parts -= picked

