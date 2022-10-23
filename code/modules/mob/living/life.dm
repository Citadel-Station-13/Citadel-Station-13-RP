/mob/living/Life(seconds, times_fired)
	if((. = ..()))
		return

	if(machine && !CanMouseDrop(machine, src))
		machine = null

	if(handle_regular_UI_updates()) // Status & health update, are we dead or alive etc.
		handle_disabilities() // eye, ear, brain damages
		handle_statuses() //all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc

	handle_regular_hud_updates()

	handle_vision()
	handle_light()

	handle_actions()
	update_canmove()

/mob/living/PhysicalLife(seconds, times_fired)
	if((. = ..()))
		return

	handle_instability()

	var/datum/gas_mixture/environment = loc?.return_air()
	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

	//Check if we're on fire
	handle_fire()
	update_gravity(mob_has_gravity())
	update_pulling()

	for(var/obj/item/grab/G in src)
		G.process(2)


/mob/living/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	if(stat != DEAD)
		//Breathing, if applicable
		handle_breathing()

		//Mutations and radiation
		handle_mutations_and_radiation()

		//Blood
		handle_blood()

		//Random events (vomiting etc)
		handle_random_events()

	//Chemicals in the body, this is moved over here so that blood can be added after death
	handle_chemicals_in_body()

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_blood()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return

/mob/living/proc/handle_stomach()
	return

/mob/living/proc/update_pulling()
	if(pulling)
		if(incapacitated())
			stop_pulling()

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_UI_updates()
	updatehealth()
	if(stat != DEAD)
		if(paralysis)
			set_stat(UNCONSCIOUS)
		else if (status_flags & FAKEDEATH)
			set_stat(UNCONSCIOUS)
		else
			set_stat(CONSCIOUS)
		return 1

/mob/living/proc/handle_statuses()
	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_stuttering()
	handle_silent()
	handle_drugged()
	handle_slurring()
	handle_confused()

/mob/living/proc/handle_stunned()
	if(stunned)
		AdjustStunned(-1)
	return stunned

/mob/living/proc/handle_weakened()
	if(weakened)
		AdjustWeakened(-1)
	return weakened

/mob/living/proc/handle_stuttering()
	if(stuttering)
		stuttering = max(stuttering-1, 0)
	return stuttering

/mob/living/proc/handle_silent()
	if(silent)
		silent = max(silent-1, 0)
	return silent

/mob/living/proc/handle_drugged()
	if(druggy)
		druggy = max(druggy-1, 0)
	return druggy

/mob/living/proc/handle_slurring()
	if(slurring)
		slurring = max(slurring-1, 0)
	return slurring

/mob/living/proc/handle_paralysed()
	if(paralysis)
		AdjustParalysis(-1)
	return paralysis

/mob/living/proc/handle_confused()
	if(confused)
		AdjustConfused(-1)
	return confused

/mob/living/proc/handle_disabilities()
	//Eyes
	if(sdisabilities & SDISABILITY_NERVOUS || stat || HAS_TRAIT(src, TRAIT_BLIND))	//blindness from disability or unconsciousness doesn't get better on its own
		SetBlinded(1)
	else if(eye_blind)			//blindness, heals slowly over time
		AdjustBlinded(-1)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

	//Ears
	if(sdisabilities & SDISABILITY_DEAF)		//disabled-deaf, doesn't get better on its own
		setEarDamage(-1, max(ear_deaf, 1))
	else
		// deafness heals slowly over time, unless ear_damage is over 100
		if(ear_damage < 100)
			adjustEarDamage(-0.05,-1)

	// WARNING WARNING SHITCODE AHEAD
	// THIS IS A SHIT WAY TO DO THIS BUT WE HAVE NO CHOICE SO HERE WE GO
	// REFACTOR LATER
	// deaf trait shim for now
	if(HAS_TRAIT(src, TRAIT_DEAF))
		ear_deaf = max(ear_deaf, 1)
	// mute trait shim for now
	if(HAS_TRAIT(src, TRAIT_MUTE))
		silent = max(silent, 1)
	// blind trait shim for now
	if(HAS_TRAIT(src, TRAIT_BLIND))
		eye_blind = max(eye_blind, 1)

/mob/living/handle_regular_hud_updates()
	if(!client)
		return FALSE
	..()

	handle_darksight()
	handle_hud_icons()

	return TRUE

/mob/living/proc/update_sight()
	SEND_SIGNAL(src, COMSIG_MOB_UPDATE_SIGHT)
	if(!seedarkness)
		SetSeeInvisibleSelf(SEE_INVISIBLE_NOLIGHTING)
	else
		SetSeeInvisibleSelf(initial(see_invisible))

	sight = initial(sight)

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.vision_flags))
			AddSightSelf(M.vision_flags)

	return

/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health()
	return

/mob/living/proc/handle_hud_icons_health()
	return

/mob/living/proc/handle_light()
	if(instability >= TECHNOMANCER_INSTABILITY_MIN_GLOW)
		var/distance = round(sqrt(instability / 2))
		if(distance)
			set_light(distance, distance * 4, l_color = "#660066")
			return TRUE

	else if(on_fire)
		set_light(min(round(fire_stacks), 3), round(fire_stacks), l_color = "#FF9933")
		return TRUE

	else if(glow_toggle)
		set_light(glow_range, glow_intensity, glow_color)

	else
		if(istype(src, /mob/living/carbon))
			var/mob/living/carbon/C = src
			if(C.species?.species_appearance_flags & RADIATION_GLOWS)
				return FALSE//When we glow with rads this is handled in handle_mutations_and_radiation()
		set_light(0)
		return FALSE

/mob/living/proc/handle_darksight()
	if(!seedarkness) //Cheap 'always darksight' var
		dsoverlay.alpha = 255
		return

	var/darksightedness = min(see_in_dark/world.view,1.0)	//A ratio of how good your darksight is, from 'nada' to 'really darn good'
	var/current = dsoverlay.alpha/255						//Our current adjustedness

	var/brightness = 0.0 //We'll assume it's superdark if we can't find something else.

	if(isturf(loc))
		var/turf/T = loc //Will be true 99% of the time, thus avoiding the whole elif chain
		brightness = T.get_lumcount()

	//Snowflake treatment of potential locations
	else if(istype(loc,/obj/mecha)) //I imagine there's like displays and junk in there. Use the lights!
		brightness = 1
	else if(istype(loc,/obj/item/holder)) //Poor carried teshari and whatnot should adjust appropriately
		var/turf/T = get_turf(src)
		brightness = T.get_lumcount()

	var/darkness = 1-brightness					//Silly, I know, but 'alpha' and 'darkness' go the same direction on a number line
	var/adjust_to = min(darkness,darksightedness)//Capped by how darksighted they are
	var/distance = abs(current-adjust_to)		//Used for how long to animate for
	if(distance < 0.01) return					//We're already all set

	//to_chat(world, "[src] in B:[round(brightness,0.1)] C:[round(current,0.1)] A2:[round(adjust_to,0.1)] D:[round(distance,0.01)] T:[round(distance*10 SECONDS,0.1)]")
	animate(dsoverlay, alpha = (adjust_to*255), time = (distance*10 SECONDS))
