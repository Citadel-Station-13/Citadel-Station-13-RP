// TODO: MAKE FALSEWALLS A F*CKING STRUCTURE
// WHOEVER WROTE THIS IS HIGH
// I might do this soon, if I don't, bully me. @Zandario
//Interactions
/turf/simulated/wall/proc/toggle_open(mob/user)
	if(can_open == WALL_OPENING)
		return

	can_open = WALL_OPENING

	if(density)
		update_underlay(TRUE)
		blocks_air = FALSE
		set_density(FALSE)
		set_opacity(FALSE)
		flick("fwall_opening", src)
	else
		update_underlay(FALSE)
		blocks_air = TRUE
		set_density(TRUE)
		set_opacity(TRUE)
		flick("fwall_closing", src)

	update_appearance()
	update_air()

	can_open = WALL_CAN_OPEN

// IF I CATCH YOU USING THIS YOU'RE DEAD @Zandario
/// Set mode to TRUE to add the baseturf underlay, set to FALSE to remove.
/turf/simulated/wall/proc/update_underlay(mode = TRUE)
	if(!mode)
		underlays.Cut()

	var/mutable_appearance/under_ma
	under_ma = new()
	under_ma.icon = 'icons/turf/flooring/plating.dmi'
	under_ma.icon_state = "plating"

	underlays += under_ma


/turf/simulated/wall/proc/update_air()
	update_thermal(src)
	queue_zone_update()
	// old code left below because it's by time we had a hall of shame
	// "turf in loc" on a turf
	// you for real?
/*
	if(!air_master)
		return

	for(var/turf/simulated/turf in loc)
		update_thermal(turf)
		air_master.mark_for_update(turf)
*/

/turf/simulated/wall/proc/update_thermal(var/turf/simulated/source)
	if(istype(source))
		if(density && opacity)
			source.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/turf/simulated/wall/proc/fail_smash(var/mob/user)
	var/damage_lower = 25
	var/damage_upper = 75
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		playsound(src, S.attack_sound, 75, 1)
		if(!(S.melee_damage_upper >= STRUCTURE_MIN_DAMAGE_THRESHOLD * 2))
			to_chat(user, SPAN_NOTICE("You bounce against the wall."))
			return FALSE
		damage_lower = S.melee_damage_lower
		damage_upper = S.melee_damage_upper
	to_chat(user, SPAN_DANGER("You smash against the wall!"))
	user.do_attack_animation(src)
	take_damage(rand(damage_lower,damage_upper))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	to_chat(user, SPAN_DANGER("You smash through the wall!"))
	user.do_attack_animation(src)
	if(isanimal(user))
		var/mob/living/simple_mob/S = user
		playsound(src, S.attack_sound, 75, 1)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			to_chat(user, SPAN_DANGER("\The [reinf_material.display_name] feels porous and crumbly."))
		else
			to_chat(user, SPAN_DANGER("\The [material.display_name] crumbles under your touch!"))
			dismantle_wall()
			return 1

	if(!can_open)
		if(!material.wall_touch_special(src, user))
			to_chat(user, SPAN_NOTICE("You push the wall, but nothing happens."))
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		return 0

	toggle_open(user)

	return 0

/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fingerprint(user)
	user.setClickCooldown(user.get_attack_speed())
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if (MUTATION_HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
			return 1
	if(iscarbon(user))
		var/mob/living/carbon/M = user
		switch(M.a_intent)
			if(INTENT_HELP)
				return
			if(INTENT_DISARM, INTENT_GRAB)
				try_touch(M, rotting)
			if(INTENT_HARM)
				//since only humans have organs_by_name but carbons still have intents this check only applies to humans
				//it's hacky but it works
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					var/obj/item/organ/external/E = H.organs_by_name[M.hand ? BP_L_HAND : BP_R_HAND]
					if (!(E.is_usable()))
						to_chat(user, SPAN_WARNING("You can't use that hand."))
						return
				if(rotting && !reinf_material)
					M.visible_message(SPAN_DANGER("[M.name] punches \the [src] and it crumbles!"), SPAN_DANGER("You punch \the [src] and it crumbles!"))
					dismantle_wall()
					playsound(src, get_sfx("punch"), 20)
				else
					M.visible_message(SPAN_DANGER("[M.name] punches \the [src]!"), SPAN_DANGER("You punch \the [src]!"))
					M.apply_damage(3, BRUTE, M.hand ? BP_L_HAND : BP_R_HAND)
					playsound(src, get_sfx("punch"), 20)

	else
		try_touch(user, rotting)

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message)

	radiate()
	user.setClickCooldown(user.get_attack_speed())
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD * 2)
		try_touch(user, rotting)
		return

	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if(damage >= max(material.hardness, reinf_material.hardness) )
			return success_smash(user)
	else if(damage >= material.hardness)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(obj/item/W as obj, mob/user as mob)

	user.setClickCooldown(user.get_attack_speed(W))
	if (!user)
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	//get the user's location
	if(!istype(user.loc, /turf))
		return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(istype(W, /obj/item/electronic_assembly/wallmount))
		var/obj/item/electronic_assembly/wallmount/IC = W
		IC.mount_assembly(src, user)
		return

	if(istype(W, /obj/item/stack/tile/roofing))
		var/expended_tile = FALSE // To track the case. If a ceiling is built in a multiz zlevel, it also necessarily roofs it against weather
		var/turf/T = GetAbove(src)
		var/obj/item/stack/tile/roofing/R = W

		// Place plating over a wall
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ChangeTurf(/turf/simulated/floor/plating, flags = CHANGETURF_PRESERVE_OUTDOORS)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message(SPAN_NOTICE("[user] patches a hole in the ceiling."), SPAN_NOTICE("You patch a hole in the ceiling."))
					expended_tile = TRUE
			else
				to_chat(user, SPAN_WARNING("There aren't any holes in the ceiling to patch here."))
				return

		// Create a ceiling to shield from the weather
		if(outdoors)
			if(expended_tile || R.use(1)) // Don't need to check adjacent turfs for a wall, we're building on one
				make_indoors()
				if(!expended_tile) // Would've already played a sound
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				user.visible_message(SPAN_NOTICE("[user] roofs \the [src], shielding it from the elements."), SPAN_NOTICE("You roof \the [src] tile, shielding it from the elements."))
		return


	if(locate(/obj/effect/overlay/wallrot) in src)
		if(istype(W, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, SPAN_NOTICE("You burn away the fungi with \the [WT]."))
				playsound(src, WT.tool_sound, 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, SPAN_NOTICE("\The [src] crumbles away under the force of your [W.name]."))
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if( istype(W, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if (istype(W, /obj/item/melee/thermalcutter))
			var/obj/item/melee/thermalcutter/TC = W
			if(TC.remove_fuel(0,user))
				thermitemelt(user)
				return

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W

			EB.spark_system.start()
			to_chat(user, SPAN_NOTICE("You slash \the [src] with \the [EB]; the thermite ignites!"))
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(damage && istype(W, /obj/item/weldingtool))

		var/obj/item/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("You start repairing the damage to [src]."))
			playsound(src.loc, WT.tool_sound, 100, 1)
			if(do_after(user, max(5, damage / 5) * WT.tool_speed) && WT && WT.isOn())
				to_chat(user, SPAN_NOTICE("You finish repairing the damage to [src]."))
				take_damage(-damage)
		else
			to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
			return
		user.update_examine_panel(src)
		return

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(istype(W,/obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(!WT.isOn())
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return
			dismantle_verb = "cutting"
			dismantle_sound = W.tool_sound
		//	cut_delay *= 0.7 // Tools themselves now can shorten the time it takes.
		else if(istype(W,/obj/item/melee/energy/blade))
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if (istype(W, /obj/item/melee/thermalcutter))
			var/obj/item/melee/thermalcutter/TC = W
			if(!TC.isOn())
				return
			if(!TC.remove_fuel(0,user))
				to_chat(user, SPAN_NOTICE("You need more fuel to complete this task."))
				return
			dismantle_sound = 'sound/items/Welder.ogg'
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = W
			if(!active)
				return
			else
				dismantle_verb = P.drill_verb
				dismantle_sound = P.drill_sound
				cut_delay -= P.digspeed

		if(dismantle_verb)

			to_chat(user, SPAN_NOTICE("You begin [dismantle_verb] through the outer plating."))
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(!do_after(user,cut_delay * W.tool_speed))
				return

			to_chat(user, SPAN_NOTICE("You remove the outer plating."))
			dismantle_wall()
			user.visible_message(SPAN_WARNING("The wall was torn open by [user]!"))
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (W.is_wirecutter())
					playsound(src, W.tool_sound, 100, 1)
					construction_stage = 5
					user.update_examine_panel(src)
					to_chat(user, SPAN_NOTICE("You cut through the outer grille."))
					update_appearance()
					return
			if(5)
				if (W.is_screwdriver())
					to_chat(user, SPAN_NOTICE("You begin removing the support lines."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user,40 * W.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You unscrew the support lines."))
					return
				else if (W.is_wirecutter())
					construction_stage = 6
					user.update_examine_panel(src)
					to_chat(user, SPAN_NOTICE("You mend the outer grille."))
					playsound(src, W.tool_sound, 100, 1)
					update_appearance()
					return
			if(4)
				var/cut_cover
				if(istype(W,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if(!WT.isOn())
						return
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
						return
				else if (istype(W, /obj/item/pickaxe/plasmacutter))
					if(!active)
						return
					else
						cut_cover = 1
				else if (istype(W, /obj/item/melee/thermalcutter))
					var/obj/item/melee/thermalcutter/TC = W
					if(!TC.isOn())
						return
					if(TC.remove_fuel(0,user))
						cut_cover = 1
					else
						to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
						return
				if(cut_cover)
					to_chat(user, SPAN_NOTICE("You begin slicing through the metal cover."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user, 60 * W.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You press firmly on the cover, dislodging it."))
					return
				else if (W.is_screwdriver())
					to_chat(user, SPAN_NOTICE("You begin screwing down the support lines."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user,40 * W.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 5
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You screw down the support lines."))
					return
			if(3)
				if (W.is_crowbar())
					to_chat(user, SPAN_NOTICE("You struggle to pry off the cover."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user,100 * W.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You pry off the cover."))
					return
			if(2)
				if (W.is_wrench())
					to_chat(user, SPAN_NOTICE("You start loosening the anchoring bolts which secure the support rods to their frame."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user,40 * W.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, SPAN_NOTICE("You remove the bolts anchoring the support rods."))
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weldingtool))
					var/obj/item/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
						return
				else if(istype(W, /obj/item/pickaxe/plasmacutter))
					if(!active)
						return
					else
						cut_cover = 1
				if(cut_cover)
					to_chat(user, SPAN_NOTICE("You begin slicing through the support rods."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user,70 * W.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, SPAN_NOTICE("The slice through the support rods."))
					return
			if(0)
				if(W.is_crowbar())
					to_chat(user, SPAN_NOTICE("You struggle to pry off the outer sheath."))
					playsound(src, W.tool_sound, 100, 1)
					if(!do_after(user,100 * W.tool_speed) || !istype(src, /turf/simulated/wall) || !user || !W || !T )
						return
					if(user.loc == T && user.get_active_held_item() == W )
						to_chat(user, SPAN_NOTICE("You pry off the outer sheath."))
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src, user)
