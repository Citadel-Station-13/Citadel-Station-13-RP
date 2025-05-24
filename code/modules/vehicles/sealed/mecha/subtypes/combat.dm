/obj/vehicle/sealed/mecha/combat
	force = 30
	var/melee_cooldown = 10
	var/melee_can_hit = 1
	//var/list/destroyable_obj = list(/obj/vehicle/sealed/mecha, /obj/structure/window, /obj/structure/grille, /turf/simulated/wall, /obj/structure/girder)
	internal_damage_threshold = 50
	maint_access = 0
	//add_req_access = 0
	//operation_req_access = list(ACCESS_SECURITY_HOS)
	damage_absorption = list("brute"=0.7,"fire"=1,"bullet"=0.7,"laser"=0.85,"energy"=1,"bomb"=0.8)
	var/am = "d3c2fbcadca903a41161ccc9df9cf948"

	max_hull_equip = 2
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 1
	max_special_equip = 1
	cargo_capacity = 1

	encumbrance_gap = 1.5

	starting_components = list(
		/obj/item/vehicle_component/hull/durable,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor/reinforced,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)

/*
/obj/vehicle/sealed/mecha/combat/range_action(target as obj|mob|turf)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(view(3,target))
	if(selected_weapon)
		selected_weapon.fire(target)
	return
*/

/obj/vehicle/sealed/mecha/combat/melee_action(atom/T)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		T = SAFEPICK(oview(1,src))
	if(!melee_can_hit)
		return
	if(istype(T, /mob/living))
		var/mob/living/M = T
		if(src.occupant_legacy.a_intent == INTENT_HARM || istype(src.occupant_legacy, /mob/living/carbon/brain)) //Brains cannot change intents; Exo-piloting brains lack any form of physical feedback for control, limiting the ability to 'play nice'.
			playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)
			if(damtype == "brute")
				step_away(M,src,15)
			/*
			if(M.stat>1)
				M.gib()
				melee_can_hit = 0
				if(do_after(melee_cooldown))
					melee_can_hit = 1
				return
			*/
			if(ishuman(T))
				var/mob/living/carbon/human/H = T
	//			if (M.integrity <= 0) return

				var/obj/item/organ/external/temp = H.get_organ(pick(BP_TORSO, BP_TORSO, BP_TORSO, BP_HEAD))
				if(temp)
					var/update = 0
					switch(damtype)
						if("brute")
							H.afflict_unconscious(20 * 1)
							temp.inflict_bodypart_damage(
								brute = rand(force / 2, force),
							)
						if("fire")
							temp.inflict_bodypart_damage(
								burn = rand(force / 2, force),
							)
						if("tox")
							if(H.reagents)
								if(H.reagents.get_reagent_amount("carpotoxin") + force < force*2)
									H.reagents.add_reagent("carpotoxin", force)
								if(H.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
									H.reagents.add_reagent("cryptobiolin", force)
						if("halloss")
							H.electrocute(stun_power = force / 2)
						else
							return
					if(update)	H.update_damage_overlay()
				H.update_health()

			else
				switch(damtype)
					if("brute")
						M.afflict_unconscious(20 * 1)
						M.take_overall_damage(rand(force/2, force))
					if("fire")
						M.take_overall_damage(0, rand(force/2, force))
					if("tox")
						if(M.reagents)
							if(M.reagents.get_reagent_amount("carpotoxin") + force < force*2)
								M.reagents.add_reagent("carpotoxin", force)
							if(M.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
								M.reagents.add_reagent("cryptobiolin", force)
					else
						return
				M.update_health()
			src.occupant_message("You hit [T].")
			src.visible_message("<font color='red'><b>[src.name] hits [T].</b></font>")
		else
			step_away(M,src)
			src.occupant_message("You push [T] out of the way.")
			src.visible_message("[src] pushes [T] out of the way.")

		melee_can_hit = 0
		spawn(melee_cooldown)
			melee_can_hit = 1
		return

	else
		if(istype(T, /obj/machinery/disposal)) // Stops mechs from climbing into disposals
			return
		if(src.occupant_legacy.a_intent == INTENT_HARM || istype(src.occupant_legacy, /mob/living/carbon/brain)) // Don't smash unless we mean it
			if(damtype == "brute")
				src.occupant_message("You hit [T].")
				src.visible_message("<font color='red'><b>[src.name] hits [T]</b></font>")
				playsound(src, 'sound/weapons/heavysmash.ogg', 50, 1)
				T.inflict_atom_damage(
					force,
					4,
					ARMOR_MELEE,
				)

				melee_can_hit = 0

				spawn(melee_cooldown)
					melee_can_hit = 1
	return

/obj/vehicle/sealed/mecha/combat/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(adding.client)
		adding.client.mouse_pointer_icon = file("icons/mecha/mecha_mouse.dmi")

/obj/vehicle/sealed/mecha/combat/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(removing.client)
		removing.client.mouse_pointer_icon = initial(removing.client.mouse_pointer_icon)

/obj/vehicle/sealed/mecha/combat/Topic(href,href_list)
	..()
	var/datum/topic_input/top_filter = new (href,href_list)
	if(top_filter.get("close"))
		am = null
		return
