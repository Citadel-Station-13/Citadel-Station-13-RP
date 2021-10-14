/obj/item/mecha_parts/mecha_equipment/weapon/whisperblade
	name = "whisper blade"
	desc = "This blade's fractal edging allows it to slice through heavy armor plating like butter without a sound."
	icon_state = "mecha_whisper"
	energy_drain = 300
	equip_cooldown = 150
	var/dam_force = 30
	origin_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_ILLEGAL = 5)

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/weapon/whisperblade/action(atom/target)
	if(!action_checks(target)) return

	if(istype(target,/mob/living))
		var/mob/living/M = target
		if(M.stat>1) return
		if(chassis.occupant.a_intent == INTENT_HARM || istype(chassis.occupant,/mob/living/carbon/brain)) //No tactile feedback for brains
			M.apply_damage(dam_force, BRUTE)
			M.adjustOxyLoss(round(dam_force/2))
			M.updatehealth()
			occupant_message("<span class='warning'>You pierce [target] with [src.name]. The blade goes all the way through.</span>")
			playsound(src, 'sound/weapons/slice.ogg', 5, 1, -2) //Whisper quiet.
			chassis.visible_message("<span class='warning'>[chassis] stabs [target].</span>")
		else if(chassis.occupant.a_intent == INTENT_DISARM && enable_special)
			playsound(src, 'sound/weapons/punchmiss.ogg', 10, 1, -2)
			M.apply_damage(dam_force/2, BRUTE)
			M.adjustOxyLoss(round(dam_force/3))
			M.updatehealth()
			occupant_message("<span class='warning'>You slaps [target] with the flat of [src.name]. Something cracks.</span>")
			playsound(src, "fracture", 3, 1, -2) //CRACK 2
			chassis.visible_message("<span class='warning'>[chassis] slaps [target].</span>")
			M.throw_at(get_step(M,get_dir(src, M)), 14, 1.5, chassis)
		else
			step_away(M,chassis)
			occupant_message("You push [target] out of the way.")
			chassis.visible_message("[chassis] pushes [target] out of the way.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1

//Recode using the drill, in case I want that later?
/*
/obj/item/mecha_parts/mecha_equipment/weapon/whisperblade/proc/slice_mob(mob/living/target, mob/user)
	add_attack_logs(user, target, "attacked", "[name]", "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")
	var/blade_force = force	//Couldn't manage it otherwise.
	if(ishuman(target))
		target.apply_damage(blade_force, BRUTE)
		return

	else if(istype(target, /mob/living/simple_mob))
		var/mob/living/simple_mob/S = target
		if(target.stat == DEAD)
			if(S.meat_amount > 0)
				S.harvest(user)
				return
			else
				S.gib()
				return
		else
			S.apply_damage(blade_force)
			return
*/

/obj/item/mecha_parts/mecha_equipment/weapon/infernoblade
	name = "inferno blade"
	desc = "This blade's edge has been replaced with a rapid-activation heating element designed for industrial cutting."
	icon_state = "mecha_inferno"
	energy_drain = 400
	equip_cooldown = 150
	var/dam_force = 15
	origin_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_ILLEGAL = 5)

	equip_type = EQUIP_SPECIAL

/obj/item/mecha_parts/mecha_equipment/weapon/infernoblade/action(atom/target)
	if(!action_checks(target)) return

	if(istype(target,/mob/living))
		var/mob/living/M = target
		if(M.stat>1) return
		if(chassis.occupant.a_intent == INTENT_HARM || istype(chassis.occupant,/mob/living/carbon/brain)) //No tactile feedback for brains
			M.apply_damage(dam_force, BURN)
			M.adjust_fire_stacks(1)
			M.updatehealth()
			occupant_message("<span class='warning'>You pierce [target] with [src.name]. The blade goes all the way through.</span>")
			playsound(src, 'sound/weapons/blade1.ogg', 5, 1, -2) //Whisper quiet.
			chassis.visible_message("<span class='warning'>[chassis] stabs [target].</span>")
		else if(chassis.occupant.a_intent == INTENT_DISARM && enable_special)
			playsound(src, 'sound/weapons/punchmiss.ogg', 10, 1, -2)
			M.apply_damage(dam_force/2, BRUTE)
			M.adjustOxyLoss(round(dam_force/3))
			M.updatehealth()
			occupant_message("<span class='warning'>You slaps [target] with the flat of [src.name]. Something cracks.</span>")
			playsound(src, "fracture", 3, 1, -2) //CRACK 2
			chassis.visible_message("<span class='warning'>[chassis] slaps [target].</span>")
			M.throw_at(get_step(M,get_dir(src, M)), 14, 1.5, chassis)
		else
			step_away(M,chassis)
			occupant_message("You push [target] out of the way.")
			chassis.visible_message("[chassis] pushes [target] out of the way.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1


//Equipment

//Reticent Linear Projector
/obj/item/mecha_parts/mecha_equipment/combat_shield/reticent
	name = "linear combat shield"
	desc = "A Silencium infused linear combat shield. Its faint presence cannot be easily detected."
	icon_state = "shield_mime"

/obj/item/mecha_parts/mecha_equipment/combat_shield/reticent/add_equip_overlay(obj/mecha/M as obj)
	if(!drone_overlay)
		drone_overlay = new(src.icon, icon_state = "shield_droid_mime")
	M.overlays += drone_overlay
	return

//The shield effect.
/obj/item/shield_projector/line/exosuit/reticent //Special Mime Exosuit design.
	name = "faint linear shield projector"
	offset_from_center = 1 //Snug against the exosuit.
	max_shield_health = 250
	color = "#CFCFCF"
	high_color = "#CFCFCF"
	low_color = "#FFC2C2"

//Reticence Rectangular Projector
/obj/item/mecha_parts/mecha_equipment/omni_shield/reticence
	name = "faint omni shield"
	desc = "A perfected Silencium combat shield. The manner by which it distorts the air is the only way to tell it's there at all."
	shield_type = /obj/item/shield_projector/rectangle/mecha/reticence

//The shield effect.
/obj/item/shield_projector/rectangle/mecha/reticence
	shield_health = 300
	max_shield_health = 300
	color = "#CFCFCF"
	high_color = "#CFCFCF"
	low_color = "#FFC2C2"
