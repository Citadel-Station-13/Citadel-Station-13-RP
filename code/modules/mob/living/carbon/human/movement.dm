
/mob/living/carbon/human/legacy_movement_delay()
	. = ..()

	var/tally = 0

	if (istype(loc, /turf/space))
		return 0		//until tg movement slowdown + modifiers is a thing I guess ...
						//Also has no effect unless there is gravity in space... which kinda does make no sense, but is the case for the random asteroid mining, so lets return 0

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.


	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.haste) && M.haste == TRUE)
			return -3
		if(!isnull(M.slowdown))
			tally += M.slowdown

	var/health_deficiency = 1 - clamp(health / getMaxHealth(), 0, 1)
	if(health_deficiency >= 0.4)
		tally += health_deficiency * (100 / 35)

	if(can_feel_pain())
		if(!(CE_SPEEDBOOST in chem_effects)) //Hyperzine stops pain slowdown
			if(halloss >= 10)
				tally += (halloss / 45) //halloss shouldn't slow you down if you can't even feel it

	var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
	if (m_intent == MOVE_INTENT_RUN && hungry >= 70)//You can walk while hungry, but you cant run so fast while hungry
		tally += (hungry/50)*species.hunger_slowdown_multiplier

	if(reagents.has_reagent("numbenzyme"))
		tally += 1.5 //A tad bit of slowdown.

	if (feral >= 10) //crazy feral animals give less and less of a shit about pain and hunger as they get crazier
		// As feral scales to damage, this amounts to an effective +1 slowdown cap
		// TODO: uhh deal with this
		// tally = max(species.slowdown, species.slowdown+((tally-species.slowdown)/(feral/10)))
		if(shock_stage >= 10)
			tally -= 1.5 //this gets a +3 later, feral critters take reduced penalty

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted && E.splinted.loc != E)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted && E.splinted.loc != E)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10)
		tally += 3

	if(aiming && aiming.aiming_at)
		tally += 5 // Iron sights make you slower, it's a well-known fact.

	if (bodytemperature < species.cold_level_1)
		tally += (species.cold_level_1 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(MUTATION_INCREASE_RUN in mutations)
		tally = 0

	// Turf related slowdown
	var/turf/T = get_turf(src)
	tally += calculate_turf_slowdown(T)

	if(CE_SPEEDBOOST in chem_effects)
		tally -= 0.5

	if(CE_SLOWDOWN in chem_effects)
		if (tally >= 0 )
			tally = (tally + tally/4) //Add a quarter of penalties on top.
		tally += chem_effects[CE_SLOWDOWN]

	. += tally

// Similar to above, but for turf slowdown.
/mob/living/carbon/human/proc/calculate_turf_slowdown(turf/T)
	if(!T)
		return 0

	if(T.slowdown && (T.turf_flags & TURF_SLOWDOWN_INCLUDE_FLYING || !is_avoiding_ground())) //Has a slowdown, and it affects anyone, or we aren't touching the tile.
		var/turf_move_cost = T.slowdown
		if(istype(T, /turf/simulated/floor/water))
			if(species.water_movement)
				turf_move_cost = turf_move_cost + species.water_movement
			if(shoes)
				var/obj/item/clothing/shoes/feet = shoes
				if(feet.water_speed)
					turf_move_cost = turf_move_cost + feet.water_speed
			. += turf_move_cost

		if(istype(T, /turf/simulated/floor/outdoors/snow))
			if(species.snow_movement)
				turf_move_cost = turf_move_cost + species.snow_movement
			if(shoes)
				var/obj/item/clothing/shoes/feet = shoes
				if(feet.snow_speed)
					turf_move_cost = turf_move_cost + feet.snow_speed
			. += turf_move_cost

	// Wind makes it easier or harder to move, depending on if you're with or against the wind.
	if(T.outdoors && (T.z <= SSplanets.z_to_planet.len))
		var/datum/planet/P = SSplanets.z_to_planet[T.z]
		if(P)
			var/datum/weather_holder/WH = P.weather_holder
			if(WH && WH.wind_speed) // Is there any wind?
				// // With the wind.
				// if(direct & WH.wind_dir)
				// 	. = max(. - (WH.wind_speed / 3), -1) // Wind speedup is capped to prevent supersonic speeds from a storm.
				// // Against it.
				// else if(direct & global.reverse_dir[WH.wind_dir])
				// 	. += (WH.wind_speed / 3)
				. += (WH.wind_speed / 5)

	if(species.light_slowdown || species.dark_slowdown)
		var/lumcount = T.get_lumcount()
		var/mod
		if(lumcount == 0)
			mod = species.dark_slowdown
		else if(lumcount == 1)
			mod = species.light_slowdown
		else
			mod = (lumcount * species.light_slowdown) + (LERP(species.dark_slowdown, 0, lumcount))
		. += mod

/mob/living/carbon/human/Process_Spacemove(dir)
	//Do we have a working jetpack?
	// TODO: please for the love of god rework this utter dumpster fire
	var/obj/item/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/tank/jetpack))
			thrust = back
		else if(istype(s_store, /obj/item/tank/jetpack))
			thrust = s_store
		else if(istype(back,/obj/item/hardsuit))
			var/obj/item/hardsuit/hardsuit = back
			for(var/obj/item/hardsuit_module/maneuvering_jets/module in hardsuit.installed_modules)
				thrust = module.jets
				break

	if(thrust && !lying)
		if(dir != NONE)
			if(thrust.allow_thrust(0.01, src))
				return TRUE
		else
			if(thrust.stabilization_on && thrust.allow_thrust(0.01, src))
				return TRUE
	if(flying)
		return TRUE

	return ..()

// Handle footstep sounds
/mob/living/carbon/human/handle_footstep(turf/T)
	if(is_incorporeal())
		return

	// if buckled, don't bother
	if(buckled)
		return

	if(!config_legacy.footstep_volume || !T.footstep_sounds || !T.footstep_sounds.len)
		return

	// if down
	if(IS_PRONE(src))
		// if grabbed, don't bother
		if(length(grabbed_by))
			return
		// play crawling sound
		playsound(T, 'sound/effects/footstep/crawl1.ogg', 25, TRUE, -4)

	// todo: REFACTOR EVERYTHING.
	// Future Upgrades - Multi species support
	var/list/footstep_sounds = T.footstep_sounds["human"]
	if(!footstep_sounds)
		return

	var/S = pick(footstep_sounds)
	if(!S)
		return

	// Play every 20 steps while walking, for the sneak
	if(m_intent == "walk" && step_count++ % 20 != 0)
		return

	// Play every other step while running
	if(m_intent == "run" && step_count++ % 2 != 0)
		return

	var/volume = config_legacy.footstep_volume

	// Reduce volume while walking or barefoot
	if(!shoes || m_intent == "walk")
		volume *= 0.5
	else if(shoes)
		var/obj/item/clothing/shoes/feet = shoes
		if(istype(feet))
			volume *= feet.step_volume_mod

	if(!has_organ(BP_L_FOOT) && !has_organ(BP_R_FOOT))
		return // no feet = no footsteps

	if(buckled || lying || throwing)
		return // people flying, lying down or sitting do not step

	if(!has_gravity(src) && prob(75))
		return // Far less likely to make noise in no gravity

	playsound(T, S, volume, FALSE)

//? crawling

/mob/living/carbon/human/try_crawl_under(mob/living/other)
	if(!in_selfmove) // we're being shoved under
		bump_position_swap(other, TRUE)
		return TRUE
	if(crawling_under_someone)
		return
	crawling_under_someone = other
	if(is_grabbed())
		selfmove_feedback(SPAN_WARNING("You can't crawl under [other] while grabbed!"))
		crawling_under_someone = null
		return FALSE
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_MOVE))
		selfmove_feedback(SPAN_WARNING("You can't crawl under [other] right now!"))
		crawling_under_someone = null
		return FALSE
	visible_message(
		SPAN_NOTICE("[src] is attempting to crawl under [other]."),
		SPAN_NOTICE("You are now attempting to crawl under [other].")
	)
	if(!do_self(src, 2 SECONDS, DO_AFTER_IGNORE_ACTIVE_ITEM, MOBILITY_CAN_MOVE))
		crawling_under_someone = null
		return FALSE
	bump_position_swap(other, TRUE)
	crawling_under_someone = null
	return TRUE

/mob/living/carbon/human/should_crawl_under(mob/living/other)
	return IS_PRONE(src) && !IS_PRONE(other)
