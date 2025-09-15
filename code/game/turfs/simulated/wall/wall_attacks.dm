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
	queue_zone_update()
	// old code left below because it's by time we had a hall of shame
	// "turf in loc" on a turf
	// you for real?
/*
	if(!SSair)
		return

	for(var/turf/simulated/turf in loc)
		update_thermal(turf)
		SSair.mark_for_update(turf)
*/

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(material_reinf)
			to_chat(user, "<span class='danger'>\The [material_reinf.display_name] feels porous and crumbly.</span>")
		else
			to_chat(user, "<span class='danger'>\The [material_outer.display_name] crumbles under your touch!</span>")
			dismantle_wall()
			return 1

	if(!can_open)
		if(!material_outer.wall_touch_special(src, user))
			to_chat(user, "<span class='notice'>You push the wall, but nothing happens.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
		return 0

	toggle_open(user)

	return 0

/turf/simulated/wall/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
	add_fingerprint(user)
	user.setClickCooldownLegacy(user.get_attack_speed_legacy())
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(iscarbon(user))
		var/mob/living/carbon/M = user
		switch(M.a_intent)
			if(INTENT_HELP)
				return
			if(INTENT_DISARM, INTENT_GRAB)
				try_touch(M, rotting)
			else
				user.melee_attack_chain(e_args)
				return
	else
		try_touch(user, rotting)

/turf/simulated/wall/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	user.setClickCooldownLegacy(user.get_attack_speed_legacy(I))

	if(I)
		if(is_hot(I))
			burn(is_hot(I))

	if(istype(I, /obj/item/electronic_assembly/wallmount))
		var/obj/item/electronic_assembly/wallmount/IC = I
		IC.mount_assembly(src, user)
		return

	if(istype(I, /obj/item/stack/tile/roofing))
		var/expended_tile = FALSE // To track the case. If a ceiling is built in a multiz zlevel, it also necessarily roofs it against weather
		var/turf/T = above()
		var/obj/item/stack/tile/roofing/R = I

		// Place plating over a wall
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ChangeTurf(/turf/simulated/floor/plating, flags = CHANGETURF_PRESERVE_OUTDOORS)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] patches a hole in the ceiling.</span>", "<span class='notice'>You patch a hole in the ceiling.</span>")
					expended_tile = TRUE
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return

		// Create a ceiling to shield from the weather
		if(outdoors)
			if(expended_tile || R.use(1)) // Don't need to check adjacent turfs for a wall, we're building on one
				make_indoors()
				if(!expended_tile) // Would've already played a sound
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				user.visible_message("<span class='notice'>[user] roofs \the [src], shielding it from the elements.</span>", "<span class='notice'>You roof \the [src] tile, shielding it from the elements.</span>")
		return


	if(locate(/obj/effect/overlay/wallrot) in src)
		if(istype(I, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = I
			if( WT.remove_fuel(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, WT.tool_sound, 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(I) && I.damage_force >= 10 || I.damage_force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [I.name].</span>")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if( istype(I, /obj/item/weldingtool) )
			var/obj/item/weldingtool/WT = I
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(I, /obj/item/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if (istype(I, /obj/item/melee/thermalcutter))
			var/obj/item/melee/thermalcutter/TC = I
			if(TC.remove_fuel(0,user))
				thermitemelt(user)
				return

		else if( istype(I, /obj/item/melee/ninja_energy_blade) )
			var/obj/item/melee/ninja_energy_blade/EB = I

			EB.spark_system.start()
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, /datum/soundbyte/sparks, 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(integrity < integrity_max && istype(I, /obj/item/weldingtool))

		var/obj/item/weldingtool/WT = I

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
			playsound(src.loc, WT.tool_sound, 100, 1)
			if(do_after(user, max(5, (integrity_max - integrity) / 5) * WT.tool_speed) && WT && WT.isOn())
				WT.remove_fuel(CEILING((integrity_max - integrity) / 100, 1))
				if(integrity >= integrity_max)
					return
				to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
				heal_integrity(integrity_max - integrity)
		else
			to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
			return
		user.update_examine_panel(src)
		return

	// Basic dismantling.
	if(isnull(construction_stage) || !material_reinf)

		var/cut_delay = 60 - material_outer.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(istype(I,/obj/item/weldingtool))
			var/obj/item/weldingtool/WT = I
			if(!WT.isOn())
				return
			if(!WT.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
				return
			dismantle_verb = "cutting"
			dismantle_sound = I.tool_sound
		//	cut_delay *= 0.7 // Tools themselves now can shorten the time it takes.
		else if(istype(I,/obj/item/melee/ninja_energy_blade))
			dismantle_sound = /datum/soundbyte/sparks
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if (istype(I, /obj/item/melee/thermalcutter))
			var/obj/item/melee/thermalcutter/TC = I
			if(!TC.isOn())
				return
			if(!TC.remove_fuel(0,user))
				to_chat(user, "<span class='notice'>You need more fuel to complete this task.</span>")
				return
			dismantle_sound = 'sound/items/Welder.ogg'
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(I,/obj/item/pickaxe))
			var/obj/item/pickaxe/P = I
			if(!active)
				return
			else
				dismantle_verb = P.drill_verb
				dismantle_sound = P.drill_sound
				cut_delay -= P.digspeed

		if(dismantle_verb)

			to_chat(user, "<span class='notice'>You begin [dismantle_verb] through the outer plating.</span>")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(!do_after(user,cut_delay * I.tool_speed))
				return

			to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
			dismantle_wall()
			user.visible_message("<span class='warning'>The wall was torn open by [user]!</span>")
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (I.is_wirecutter())
					playsound(src, I.tool_sound, 100, 1)
					construction_stage = 5
					user.update_examine_panel(src)
					to_chat(user, "<span class='notice'>You cut through the outer grille.</span>")
					update_appearance()
					return
			if(5)
				if (I.is_screwdriver())
					to_chat(user, "<span class='notice'>You begin removing the support lines.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user,40 * I.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, "<span class='notice'>You unscrew the support lines.</span>")
					return
				else if (I.is_wirecutter())
					construction_stage = 6
					user.update_examine_panel(src)
					to_chat(user, "<span class='notice'>You mend the outer grille.</span>")
					playsound(src, I.tool_sound, 100, 1)
					update_appearance()
					return
			if(4)
				var/cut_cover
				if(istype(I,/obj/item/weldingtool))
					var/obj/item/weldingtool/WT = I
					if(!WT.isOn())
						return
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if (istype(I, /obj/item/pickaxe/plasmacutter))
					if(!active)
						return
					else
						cut_cover = 1
				else if (istype(I, /obj/item/melee/thermalcutter))
					var/obj/item/melee/thermalcutter/TC = I
					if(!TC.isOn())
						return
					if(TC.remove_fuel(0,user))
						cut_cover = 1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the metal cover.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user, 60 * I.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, "<span class='notice'>You press firmly on the cover, dislodging it.</span>")
					return
				else if (I.is_screwdriver())
					to_chat(user, "<span class='notice'>You begin screwing down the support lines.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user,40 * I.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 5
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, "<span class='notice'>You screw down the support lines.</span>")
					return
			if(3)
				if (I.is_crowbar())
					to_chat(user, "<span class='notice'>You struggle to pry off the cover.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user,100 * I.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, "<span class='notice'>You pry off the cover.</span>")
					return
			if(2)
				if (I.is_wrench())
					to_chat(user, "<span class='notice'>You start loosening the anchoring bolts which secure the support rods to their frame.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user,40 * I.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, "<span class='notice'>You remove the bolts anchoring the support rods.</span>")
					return
			if(1)
				var/cut_cover
				if(istype(I, /obj/item/weldingtool))
					var/obj/item/weldingtool/WT = I
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						to_chat(user, "<span class='notice'>You need more welding fuel to complete this task.</span>")
						return
				else if(istype(I, /obj/item/pickaxe/plasmacutter))
					if(!active)
						return
					else
						cut_cover = 1
				if(cut_cover)
					to_chat(user, "<span class='notice'>You begin slicing through the support rods.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user,70 * I.tool_speed) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					user.update_examine_panel(src)
					update_appearance()
					to_chat(user, "<span class='notice'>The slice through the support rods.</span>")
					return
			if(0)
				if(I.is_crowbar())
					to_chat(user, "<span class='notice'>You struggle to pry off the outer sheath.</span>")
					playsound(src, I.tool_sound, 100, 1)
					if(!do_after(user,100 * I.tool_speed) || !istype(src, /turf/simulated/wall) || !user || !I || !T )
						return
					if(user.loc == T && user.get_active_held_item() == I )
						to_chat(user, "<span class='notice'>You pry off the outer sheath.</span>")
						dismantle_wall()
					return

	if(istype(I,/obj/item/frame))
		var/obj/item/frame/F = I
		F.try_build(src, user)
		return

	return ..()
