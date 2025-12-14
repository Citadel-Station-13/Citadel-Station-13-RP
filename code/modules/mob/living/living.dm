/mob/living
	emote_class = EMOTE_CLASS_IS_BODY

TYPE_REGISTER_SPATIAL_GRID(/mob/living, SSspatial_grids.living)
/mob/living/Initialize(mapload)
	. = ..()
	// make radiation sensitive
	AddComponent(/datum/component/radiation_listener)
	AddElement(/datum/element/z_radiation_listener)

	if(ai_holder_type && !ai_holder)
		ai_holder = new ai_holder_type(src)

	selected_image = image(icon = 'icons/mob/screen1.dmi', loc = src, icon_state = "centermarker")

	//* ~~~~~~~VORE~~~~~~~ *//
	add_verb(src, /mob/living/proc/escapeOOC)
	add_verb(src, /mob/living/proc/lick)
	add_verb(src, /mob/living/proc/smell)
	add_verb(src, /mob/living/proc/switch_scaling)
	if(!no_vore) //If the mob isn't supposed to have a stomach, let's not give it an insidepanel so it can make one for itself, or a stomach.
		add_verb(src, /mob/living/proc/insidePanel)
		//Tries to load prefs if a client is present otherwise gives freebie stomach
		spawn(2 SECONDS)
			init_vore()
	//*        END         *//

/mob/living/Destroy()
	if(nest) //Ew.
		if(istype(nest, /obj/structure/prop/nest))
			var/obj/structure/prop/nest/N = nest
			N.remove_creature(src)
		if(istype(nest, /obj/structure/blob/factory))
			var/obj/structure/blob/factory/F = nest
			F.spores -= src
		nest = null
	if(buckled)
		buckled.unbuckle_mob(src, TRUE)
	if(selected_image)
		QDEL_NULL(selected_image)

	// this all needs to be Cut and not null
	// TODO: fix whatever is accessing these lists after qdel
	// it should never happen.
	organs_by_name.Cut()
	internal_organs_by_name.Cut()
	for(var/obj/item/organ/O in organs)
		if(!QDELETED(O))
			qdel(O)
	organs.Cut()
	for(var/obj/item/organ/O in internal_organs)
		if(!QDELETED(O))
			qdel(O)
	internal_organs.Cut()
	profile = null

	return ..()

//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = VERB_CATEGORY_OBJECT

	if(AM.Adjacent(src))
		start_pulling(AM)

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(src.stat || src.restrained())
		return 0
	if(src.status_flags & STATUS_FAKEDEATH)
		return 0
	if(!..())
		return 0

	usr.visible_message("<b>[src]</b> points to [A]")
	return 1

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		return 0

/mob/living/verb/succumb()
	set hidden = 1
	if ((src.health < 0 && src.health > (5-src.getMaxHealth()))) // Health below Zero but above 5-away-from-death, as before, but variable
		src.death()
		to_chat(src, "<font color=#4F49AF>You have given up life and succumbed to death.</font>")
	else
		to_chat(src, "<font color=#4F49AF>You are not injured enough to succumb to death!</font>")

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return

//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(istype(src, /mob/living/carbon/human))
		//to_chat(world, "DEBUG: burn_skin(), mutations=[mutations]")
		if(MUTATION_NOSHOCK in src.mutations) //shockproof
			return 0
		if (MUTATION_COLD_RESIST in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.organs.len)
		var/extradam = 0	//added to when organ is at max dam
		for(var/obj/item/organ/external/affecting in H.organs)
			affecting.inflict_bodypart_damage(
				burn = divided_damage + extradam,
			)
		H.update_health()
		return 1
	else if(istype(src, /mob/living/silicon/ai))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		to_chat(world, "[src] ~ [src.bodytemperature] ~ [temperature]")
	return temperature


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/getShockBruteLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return bruteloss

/mob/living/proc/getActualBruteLoss()	// Mostly for humans with robolimbs.
	return getBruteLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustBruteLoss(var/amount,var/include_robo)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_brute_damage_percent))
				amount *= M.incoming_brute_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	bruteloss = min(max(bruteloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_oxy_damage_percent))
				amount *= M.incoming_oxy_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	oxyloss = min(max(oxyloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_tox_damage_percent))
				amount *= M.incoming_tox_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	toxloss = min(max(toxloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/getShockFireLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return fireloss

/mob/living/proc/getActualFireLoss()	// Mostly for humans with robolimbs.
	return getFireLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustFireLoss(var/amount,var/include_robo)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_fire_damage_percent))
				amount *= M.incoming_fire_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	fireloss = min(max(fireloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode

	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_clone_damage_percent))
				amount *= M.incoming_clone_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent

	cloneloss = min(max(cloneloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	brainloss = min(max(brainloss + amount, 0),(getMaxHealth()*2))

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_damage_percent))
				amount *= M.incoming_damage_percent
			if(!isnull(M.incoming_hal_damage_percent))
				amount *= M.incoming_hal_damage_percent
			if(!isnull(M.disable_duration_percent))
				amount *= M.incoming_hal_damage_percent
	else if(amount < 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.incoming_healing_percent))
				amount *= M.incoming_healing_percent
	halloss = min(max(halloss + amount, 0),(getMaxHealth()*2))
	update_health()

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & STATUS_GODMODE)	return 0	//godmode
	halloss = amount

/mob/living/proc/adjustHallucination(amount)
	if(status_flags & STATUS_GODMODE)
		hallucination = 0
		return 0	//godmode
	hallucination = clamp(hallucination + amount, 0, 400) //cap at 400, any higher is just obnoxious

/mob/living/proc/setHallucination(amount)
	if(status_flags & STATUS_GODMODE)
		hallucination = 0
		return 0	//godmode
	hallucination = clamp(amount, 0, 400) //cap at 400, any higher is just obnoxious

// Use this to get a mob's max health whenever possible.  Reading maxHealth directly will give inaccurate results if any modifiers exist.
/mob/living/proc/getMaxHealth()
	var/result = maxHealth
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.max_health_flat))
			result += M.max_health_flat
	// Second loop is so we can get all the flat adjustments first before multiplying, otherwise the result will be different.
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.max_health_percent))
			result *= M.max_health_percent
	return result

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	health = (health/maxHealth) * (newMaxHealth) // Adjust existing health
	maxHealth = newMaxHealth

// Use this to get a mob's min health whenever possible. (modifiers for minHealth don't exist currently!)
/mob/living/proc/getMinHealth()
	return minHealth

/mob/living/proc/getCritHealth()
	return critHealth

/mob/living/proc/getSoftCritHealth()
	return softCritHealth

/mob/living/Confuse(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)

/mob/living/AdjustConfused(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)

// ++++ROCKDTBEN++++ MOB PROCS //END

// Applies direct "cold" damage while checking protection against the cold.
/mob/living/proc/inflict_cold_damage(amount)
	amount *= 1 - get_cold_protection(50) // Within spacesuit protection.
	if(amount > 0)
		adjustFireLoss(amount)

// Ditto, but for "heat".
/mob/living/proc/inflict_heat_damage(amount)
	amount *= 1 - get_heat_protection(10000) // Within firesuit protection.
	if(amount > 0)
		adjustFireLoss(amount)

// and one for electricity because why not
/mob/living/proc/inflict_shock_damage_legacy(amount)
	electrocute(0, amount, 0, NONE, pick(BP_TORSO, BP_HEAD, BP_GROIN))

// also one for water (most things resist it entirely, except for slimes)
/mob/living/proc/inflict_water_damage(amount)
	amount *= 1 - get_water_protection()
	if(amount > 0)
		adjustToxLoss(amount)

// one for abstracted away ""poison"" (mostly because simplemobs shouldn't handle reagents)
/mob/living/proc/inflict_poison_damage(amount)
	if(isSynthetic())
		return
	amount *= 1 - get_poison_protection()
	if(amount > 0)
		adjustToxLoss(amount)

/mob/proc/get_contents()
	. = list()
	var/list/obj/processing = get_equipped_items(TRUE, TRUE)
	var/i = 1
	var/safety = 100000
	while(i <= length(processing))
		// safety check becuase unlike [contents], byond doens't isn't correctness here.
		if(!--safety)
			CRASH("RED ALERT RED ALERT SOMEONE FUCKED UP")
		var/obj/iterating = processing[i++]
		. += iterating
		var/list/returned = iterating.return_inventory()
		. += returned

/mob/living/proc/can_inject(var/mob/user, var/error_msg, var/target_zone, var/ignore_thickness = FALSE)
	return 1

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter.zone_sel.selecting
	if ((t in list( O_EYES, O_MOUTH )))
		t = BP_HEAD
	var/obj/item/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.update_health()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.update_health()

/mob/living/proc/restore_all_organs()
	return

/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = VERB_CATEGORY_OOC
	set src in view()

	// Making it so SSD people have prefs with fallback to original style.
	if(ooc_notes)
		to_chat(usr, "[src]'s Metainfo:<br>[ooc_notes]")
	else if(client)
		to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
	else
		to_chat(usr, "[src] does not have any stored infomation!")

/mob/living/proc/handle_footstep(turf/T)
	return FALSE

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/tiled/flash)
	if(override_blindness_check || has_status_effect(/datum/status_effect/sight/blindness))
		overlay_fullscreen("flash", type)
		spawn(25)
			if(src)
				clear_fullscreen("flash", 25)
		return 1

/mob/living/proc/cannot_use_vents()
	if(mob_size > MOB_SMALL)
		return "You can't fit into that vent."
	return null

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/get_restraining_bolt()
	var/obj/item/implant/restrainingbolt/RB = locate() in src
	if(RB)
		if(!RB.malfunction)
			return TRUE

	return FALSE

//damage/heal the mob ears and adjust the deaf amount
/mob/living/adjustEarDamage(var/damage, var/deaf)
	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max(0, ear_deaf + deaf)

//pass a negative argument to skip one of the variable
/mob/living/setEarDamage(var/damage, var/deaf)
	if(damage >= 0)
		ear_damage = damage
	if(deaf >= 0)
		ear_deaf = deaf

/mob/living/proc/vomit(var/skip_wait, var/blood_vomit)
	if(IS_DEAD(src))
		return
	if(!check_has_mouth())
		return

	if(!lastpuke)
		lastpuke = 1
		if(isSynthetic())
			to_chat(src, "<span class='danger'>A sudden, dizzying wave of internal feedback rushes over you!</span>")
			src.afflict_paralyze(20 * 5)
		else
			if (nutrition <= 100)
				to_chat(src, "<span class='danger'>You gag as you want to throw up, but there's nothing in your stomach!</span>")
				src.afflict_paralyze(20 * 10)
			else
				to_chat(src, "<span class='warning'>You feel nauseous...</span>")

				if(ishuman(src))
					var/mob/living/carbon/human/Hu = src
					if(CE_ANTACID in Hu.chem_effects)
						if(prob(min(90, Hu.chem_effects[CE_ANTACID] * 15)))
							spawn(rand(30 SECONDS, 2 MINUTES))
								lastpuke = FALSE
							return

				spawn()
					if(!skip_wait)
						sleep(150)	//15 seconds until second warning
						to_chat(src, "<span class='warning'>You feel like you are about to throw up!</span>")
						sleep(100)	//and you have 10 more for mad dash to the bucket

					//Damaged livers cause you to vomit blood.
					if(!blood_vomit)
						if(ishuman(src))
							var/mob/living/carbon/human/H = src
							if(!H.isSynthetic())
								var/obj/item/organ/internal/liver/L = H.internal_organs_by_name["liver"]
								if(!L || L.is_broken())
									blood_vomit = 1

					afflict_stun(20 * 5)
					src.visible_message("<span class='warning'>[src] throws up!</span>","<span class='warning'>You throw up!</span>")
					playsound(loc, 'sound/effects/splat.ogg', 50, 1)

					var/turf/simulated/T = get_turf(src)	//TODO: Make add_blood_floor remove blood from human mobs
					if(istype(T))
						if(blood_vomit)
							T.add_blood_floor(src)
						else
							T.add_vomit_floor(src, 1)

					if(blood_vomit)
						if(getBruteLoss() < 50)
							adjustBruteLoss(3)
					else
						nutrition -= 40
						adjustToxLoss(-3)

		spawn(350)
			lastpuke = 0

// Mob holders in these slots will be spilled if the mob goes prone.
/mob/living/proc/get_mob_riding_slots()
	return list(back)

// Adds overlays for specific modifiers.
// You'll have to add your own implementation for non-humans currently, just override this proc.
/mob/living/proc/update_modifier_visuals()
	return

/mob/living/proc/update_water() // Involves overlays for humans.  Maybe we'll get submerged sprites for borgs in the future?
	return

/mob/living/proc/update_acidsub()
	return

/mob/living/proc/update_bloodsub()
	return

/mob/living/proc/can_feel_pain(var/check_organ)
	if(isSynthetic())
		return FALSE
	return TRUE

// Gets the correct icon_state for being on fire. See OnFire.dmi for the icons.
/mob/living/proc/get_fire_icon_state()
	return "generic"

// Called by job_controller.
/mob/living/proc/equip_post_job()
	return

// Used to check if something is capable of thought, in the traditional sense.
/mob/living/proc/is_sentient()
	return TRUE

/mob/living/get_icon_scale_x()
	. = ..()
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_x_percent))
			. *= M.icon_scale_x_percent

/mob/living/get_icon_scale_y()
	. = ..()
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_y_percent))
			. *= M.icon_scale_y_percent

/mob/living/base_transform(matrix/applying)
	SHOULD_CALL_PARENT(FALSE)

	var/desired_scale_x = size_multiplier * icon_scale_x
	var/desired_scale_y = size_multiplier * icon_scale_y

	applying.Scale(desired_scale_x, desired_scale_y)
	applying.Translate(0, 16 * (desired_scale_y - 1))

	SEND_SIGNAL(src, COMSIG_MOVABLE_BASE_TRANSFORM, applying)
	return applying

/mob/living/apply_transform(matrix/to_apply)
	animate(src, transform = to_apply, time = 1 SECONDS, flags = ANIMATION_LINEAR_TRANSFORM | ANIMATION_PARALLEL)
	update_ssd_overlay()

// This handles setting the client's color variable, which makes everything look a specific color.
// This proc is here so it can be called without needing to check if the client exists, or if the client relogs.
/mob/living/update_client_color()
	if(!client)
		return

	var/list/colors_to_blend = list()
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.client_color))
			if(islist(M.client_color)) //It's a color matrix! Forget it. Just use that one.
				animate(client, color = M.client_color, time = 10)
				return
			colors_to_blend += M.client_color

	if(colors_to_blend.len)
		var/final_color
		if(colors_to_blend.len == 1) // If it's just one color we can skip all of this work.
			final_color = colors_to_blend[1]

		else // Otherwise we need to do some messy additive blending.
			var/R = 0
			var/G = 0
			var/B = 0

			for(var/C in colors_to_blend)
				var/RGB = hex2rgb(C)
				R = clamp( R + RGB[1], 0,  255)
				G = clamp( G + RGB[2], 0,  255)
				B = clamp( B + RGB[3], 0,  255)
			final_color = rgb(R,G,B)

		if(final_color)
			var/old_color = client.color // Don't know if BYOND has an internal optimization to not care about animate() calls that effectively do nothing.
			if(final_color != old_color) // Gonna do a check just incase.
				animate(client, color = final_color, time = 10)

	else // No colors, so remove the client's color.
		animate(client, color = null, time = 10)

/mob/living/get_sound_env(var/pressure_factor)
	if (hallucination)
		return PSYCHOTIC
	else if (druggy)
		return DRUGGED
	else if (drowsyness)
		return DIZZY
	else if (confused)
		return DIZZY
	else if (!IS_CONSCIOUS(src))
		return UNDERWATER
	else
		return ..()

/mob/living/proc/has_vision()
	return !(has_status_effect(/datum/status_effect/sight/blindness))

/mob/living/proc/dirties_floor()	// If we ever decide to add fancy conditionals for making dirty floors (floating, etc), here's the proc.
	return makes_dirt

/mob/living/proc/needs_to_breathe()
	return !isSynthetic()

/**
 *! Enable this one if you're enabling the butchering component. Otherwise it's useless.
/mob/living/proc/harvest(mob/living/user) //used for extra objects etc. in butchering
	return
 */

/*
/mob/living/update_gravity(has_gravity)
	if(!ticker)
		return
	if(has_gravity)
		clear_alert("weightless")
	else
		throw_alert("weightless", /obj/screen/alert/weightless)
*/

/mob/living/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(incapacitated())
		to_chat(src, SPAN_WARNING("You can't do that right now!"))
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, SPAN_WARNING("You are too far away!"))
		return FALSE
	if(!no_dexterity && !IsAdvancedToolUser())
		to_chat(src, SPAN_WARNING("You don't have the dexterity to do this!"))
		return FALSE
	return TRUE

//* Pixel Offsets

/mob/living/get_centering_pixel_y_offset(dir)
	. = ..()
	// since we're shifted up by transforms..
	. -= (size_multiplier * icon_scale_y - 1) * 16

/mob/living/get_managed_pixel_y()
	. = ..()
	. += depth_current

//TODO: maybe expand this system to be in the VV menu for event managers to mess with - provided they trust the observers enough...
/**
 * Allows an observer to take control of the mob at any time. Must use the "existing" ghostrole subtype.
 * R: the ghostrole datum to use
 */
/mob/living/proc/add_ghostrole(datum/prototype/role/ghostrole/existing/R = /datum/prototype/role/ghostrole/existing/)
	var/list/L = list()
	L["mob"] += src
	return AddComponent(/datum/component/ghostrole_spawnpoint, R, 1, L)

/mob/living/proc/get_ghostrole() //! currently not using GetComponent because that seems bugged right now. :^) @silicons
	. = datum_components?[/datum/component/ghostrole_spawnpoint]
	return . && (length(.) ? .[1] : .)

/mob/living/proc/remove_ghostrole()
	return DelComponent(/datum/component/ghostrole_spawnpoint)
