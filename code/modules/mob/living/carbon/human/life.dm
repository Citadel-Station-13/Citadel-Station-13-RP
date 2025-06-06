//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
///Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_MAX_OXYLOSS 1
///The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 4 ticks. last_tick_duration = ~2.0 on average
#define HUMAN_CRIT_MAX_OXYLOSS ( 2.0 / 6)
///Amount of damage applied for synths experiencing heat just above 360.15k such as space walking
#define HEAT_DAMAGE_SYNTH 1.5
///Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_1 5
///Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_2 10
///Amount of damage applied when your body temperature passes the 1000K point
#define HEAT_DAMAGE_LEVEL_3 20
///Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_1 0.5
///Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_2 1.5
///Amount of damage applied when your body temperature passes the 120K point
#define COLD_DAMAGE_LEVEL_3 3
//Note that gas heat damage is only applied once every FOUR ticks.
///Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_1 2
///Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_2 4
///Amount of damage applied when the current breath's temperature passes the 1000K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8
///Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_1 0.5
///Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5
///Amount of damage applied when the current breath's temperature passes the 120K point
#define COLD_GAS_DAMAGE_LEVEL_3 3

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/phoron_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/temperature_alert = 0
	var/in_stasis = 0
	var/heartbeat = 0
	var/last_synthcooling_message = 0 		// to whoever is looking at git blame in the future, i'm not the author, and this is shitcode, but what came before i changed it
	// made me vomit

/mob/living/carbon/human/Life(seconds, times_fired)
	//Apparently, the person who wrote this code designed it so that
	//blinded get reset each cycle and then get activated later in the
	//code. Very ugly. I dont care. Moving this stuff here so its easy
	//to find it.
	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	if((. = ..()))
		return

	//TODO: seperate this out
	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()
	// This is not an ideal place for this but it will do for now.
	if(wearing_rig && !wearing_rig.is_activated())
		wearing_rig = null

	voice = GetVoice()

/mob/living/carbon/human/PhysicalLife(seconds, times_fired)
	if((. = ..()))
		return

	fall() // Prevents people from floating

/mob/living/carbon/human/BiologicalLife(seconds, times_fired)
	if((. = ..()))
		return

	var/stasis = inStasisNow()
	if(getStasis() > 2)
		afflict_sleeping(20 * 20)

	handle_changeling()

	if(!stasis)
		handle_organs(seconds)

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !stasis)
		stabilize_body_temperature(seconds) //Body temperature adjusts itself (self-regulation)
		process_weaver_silk()
		handle_shock()
		handle_pain()
		handle_medical_side_effects()
		handle_heartbeat()
		handle_nif()
		if(!client)
			species.handle_npc(src)

	if(skip_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	pulse = handle_pulse()

/mob/living/carbon/human/proc/skip_some_updates()
	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return TRUE
	return FALSE

/mob/living/carbon/human/breathe()
	if(!inStasisNow())
		..()

// Calculate how vulnerable the human is to the current pressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit that's rated for the pressure, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
// Protection scales down from 100% at the boundary to 0% at 10% in excess of the boundary
/mob/living/carbon/human/proc/get_pressure_weakness(pressure)
	if(pressure == null)
		return 1 // No protection if someone forgot to give a pressure

	var/pressure_adjustment_coefficient = 1 // Assume no protection at first.

	// Check suit
	if(wear_suit && wear_suit.max_pressure_protection != null && wear_suit.min_pressure_protection != null)
		pressure_adjustment_coefficient = 0
		// Pressure is too high
		if(wear_suit.max_pressure_protection < pressure)
			// Protection scales down from 100% at the boundary to 0% at 10% in excess of the boundary
			pressure_adjustment_coefficient += round((pressure - wear_suit.max_pressure_protection) / (wear_suit.max_pressure_protection/10))

		// Pressure is too low
		if(wear_suit.min_pressure_protection > pressure)
			pressure_adjustment_coefficient += round((wear_suit.min_pressure_protection - pressure) / (wear_suit.min_pressure_protection/10))

		// Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit,/obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1
	//check for EVA capable uniforms
	else
		if(w_uniform && w_uniform.max_pressure_protection != null && w_uniform.min_pressure_protection != null)
			pressure_adjustment_coefficient = 0
			// Pressure is too high
			if(w_uniform.max_pressure_protection < pressure)
				// Protection scales down from 100% at the boundary to 0% at 10% in excess of the boundary
				pressure_adjustment_coefficient += round((pressure - w_uniform.max_pressure_protection) / (w_uniform.max_pressure_protection/10))

			// Pressure is too low
			if(w_uniform.min_pressure_protection > pressure)
				pressure_adjustment_coefficient += round((w_uniform.min_pressure_protection - pressure) / (w_uniform.min_pressure_protection/10))
		else
			// Missing key protection
			pressure_adjustment_coefficient = 1

	// Check hat
	if(head && head.max_pressure_protection != null && head.min_pressure_protection != null)
		// Pressure is too high
		if(head.max_pressure_protection < pressure)
			// Protection scales down from 100% at the boundary to 0% at 20% in excess of the boundary
			pressure_adjustment_coefficient += round((pressure - head.max_pressure_protection) / (head.max_pressure_protection/20))

		// Pressure is too low
		if(head.min_pressure_protection > pressure)
			pressure_adjustment_coefficient += round((head.min_pressure_protection - pressure) / (head.min_pressure_protection/20))

	else
		// Missing key protection
		pressure_adjustment_coefficient = 1

	pressure_adjustment_coefficient = min(pressure_adjustment_coefficient, 1)
	return pressure_adjustment_coefficient

// Calculate how much of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference
	// First get the absolute pressure difference.
	if(pressure < species.safe_pressure) // We are in an underpressure.
		pressure_difference = species.safe_pressure - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - species.safe_pressure


	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness(pressure)

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < species.safe_pressure)
		return species.safe_pressure - pressure_difference
	else
		return species.safe_pressure + pressure_difference

/mob/living/carbon/human/handle_disabilities()
	..()

	if(!HAS_TRAIT_FROM(src, TRAIT_BLIND, TRAIT_BLINDNESS_SPECIES))
		var/obj/item/organ/vis = internal_organs_by_name[species.vision_organ]
		if(!vis)
			add_blindness_source( TRAIT_BLINDNESS_VIS_ORGAN_MISSING)
		else if(HAS_TRAIT_FROM(src, TRAIT_BLIND, TRAIT_BLINDNESS_VIS_ORGAN_MISSING))
			remove_blindness_source(TRAIT_BLINDNESS_VIS_ORGAN_MISSING)

	if(stat != CONSCIOUS) //Let's not worry about tourettes if you're not conscious.
		return

	if (disabilities & DISABILITY_EPILEPSY)
		if (prob(1) && IS_CONSCIOUS(src))
			to_chat(src, "<font color='red'>You have a seizure!</font>")
			for(var/mob/O in viewers(src, null))
				if(O == src)
					continue
				O.show_message(SPAN_DANGER("[src] starts having a seizure!"), SAYCODE_TYPE_VISIBLE)
			afflict_unconscious(20 * 10)
			make_jittery(1000)
	if (disabilities & DISABILITY_COUGHING)
		if (prob(5) && IS_CONSCIOUS(src))
			drop_active_held_item()
			spawn( 0 )
				emote("cough")
				return
	if (disabilities & DISABILITY_TOURETTES)
		if (prob(10) && IS_CONSCIOUS(src))
			afflict_stun(20 * 10)
			spawn( 0 )
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				make_jittery(100)
				return
	if (disabilities & DISABILITY_NERVOUS)
		if (prob(10))
			stuttering = max(10, stuttering)

	var/rn = rand(0, 200)
	if(getBrainLoss() >= 5)
		if(0 <= rn && rn <= 3)
			custom_pain("Your head feels numb and painful.", 10)
	if(getBrainLoss() >= 15)
		if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
			to_chat(src, "<span class='warning'>It becomes hard to see for some reason.</span>")
			eye_blurry = 10
	if(getBrainLoss() >= 35)
		if(7 <= rn && rn <= 9) if(get_active_held_item())
			to_chat(src, "<span class='danger'>Your hand won't respond properly, you drop what you're holding!</span>")
			drop_active_held_item()
	if(getBrainLoss() >= 45)
		if(10 <= rn && rn <= 12)
			if(prob(50))
				to_chat(src, "<span class='danger'>You suddenly black out!</span>")
				afflict_unconscious(20 * 10)
			else if(!lying)
				to_chat(src, "<span class='danger'>Your legs won't respond properly, you fall down!</span>")
				afflict_paralyze(20 * 10)

/mob/living/carbon/human/handle_mutations_and_radiation(seconds)
	if(inStasisNow())
		return
	// DNA2 - Gene processing.
	// The MUTATION_HULK stuff that was here is now in the hulk gene.
	var/mister_robot = !!isSynthetic()
	if(!mister_robot)
		for(var/datum/gene/gene in dna_genes)
			if(!gene.block)
				continue
			if(gene.is_active(src))
				gene.OnMobLife(src)
	// no radiation: stop
	if(!radiation)
		if(species.species_appearance_flags & RADIATION_GLOWS)
			set_light(0)
		return
	// todo: SPECIES GLOWS - probably refactor this shit
	if(species.species_appearance_flags & RADIATION_GLOWS)
		var/lrange = clamp(sqrt(radiation) / 8, 0, 7)
		var/lpower = clamp(sqrt(radiation) / 40, 0, 1)
		var/lcolor = species.get_flesh_colour(src)
		if(glow_toggle)
			lpower = max(lpower, glow_intensity)
			lrange = max(lrange, glow_range)
			lcolor = glow_color
		set_light(lrange, lpower, lcolor)
	// todo: DIONA - probably refactor this shit
	var/obj/item/organ/internal/diona/nutrients/rad_organ = locate() in internal_organs
	if(rad_organ && !rad_organ.is_broken())
		var/rads = radiation / 100
		nutrition += rads
		adjustBruteLoss(-rads)
		adjustFireLoss(-rads)
		adjustOxyLoss(-rads)
		adjustToxLoss(-rads)
		update_health()
		cure_radiation(RAD_MOB_PASSIVE_LOSS_FOR(radiation, seconds) + rads)
		return
	// not enough to care: stop
	if(radiation < RAD_MOB_NEGLIGIBLE)
		cure_radiation(RAD_MOB_PASSIVE_LOSS_FOR(radiation, seconds))
		return
	// todo: PROMETHEANS - refactor this shit
	var/obj/item/organ/internal/brain/slime/core = locate() in internal_organs
	if(core)
		return

	if(mister_robot)
		if(radiation >= RAD_MOB_WARNING_THRESHOLD)
			if(prob(RAD_MOB_WARNING_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("Warning: Ionization detected in control routes. Radiological threat suspected."))
#ifdef RAD_MOB_BURNS_SYNTHETICS
		if(radiation >= RAD_MOB_BURN_THRESHOLD)
			take_overall_damage(burn = RAD_MOB_BURN_DAMAGE_FOR(radiation, seconds), weapon_descriptor = "radiation burns")
#endif
		if(radiation >= RAD_MOB_TOXIN_THRESHOLD)
			adjustToxLoss(RAD_MOB_SYNTH_INSTABILITY_FOR(radiation, seconds))
#ifdef RAD_MOB_KNOCKDOWN_SYNTHETICS
		if(radiation >= RAD_MOB_KNOCKDOWN_THRESHOLD)
			if(prob(RAD_MOB_KNOCKDOWN_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("Ionization detected in systems. Rebooting..."))
				if(!lying)
					emote("collapse")
				afflict_paralyze(20 * RAD_MOB_KNOCKDOWN_AMOUNT(radiation, seconds))
#endif
	else
		if(radiation >= RAD_MOB_WARNING_THRESHOLD)
			if(prob(RAD_MOB_WARNING_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("You feel nauseous, and a hot presence burning through your flesh."))
		if(radiation >= RAD_MOB_BURN_THRESHOLD)
			take_overall_damage(burn = RAD_MOB_BURN_DAMAGE_FOR(radiation, seconds), weapon_descriptor = "radiation burns")
		if(radiation >= RAD_MOB_TOXIN_THRESHOLD)
			adjustToxLoss(RAD_MOB_TOXIN_DAMAGE_FOR(radiation, seconds))
			// todo: autopsy data
		if(radiation >= RAD_MOB_KNOCKDOWN_THRESHOLD)
			if(prob(RAD_MOB_KNOCKDOWN_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("You feel weak..."))
				if(!lying)
					emote("collapse")
				afflict_paralyze(20 * RAD_MOB_KNOCKDOWN_AMOUNT(radiation, seconds))
		if(radiation >= RAD_MOB_HAIRLOSS_THRESHOLD)
			if(prob(RAD_MOB_HAIRLOSS_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("Your hair starts falling out in clumps..."))
				addtimer(CALLBACK(src, PROC_REF(radiation_hairloss)), 8 SECONDS)
		if(radiation >= RAD_MOB_DECLONE_THRESHOLD)
			if(prob(RAD_MOB_DECLONE_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("You feel a sharp pain, and a strange, numb feeling."))
				adjustCloneLoss(RAD_MOB_DECLONE_DAMAGE(radiation, seconds))
				emote("gasp")
		if(radiation >= RAD_MOB_VOMIT_THRESHOLD)
			if(prob(RAD_MOB_VOMIT_CHANCE(radiation, seconds)))
				to_chat(src, SPAN_WARNING("You throw up!"))
				// todo: blood vomit
				vomit()

	cure_radiation(RAD_MOB_PASSIVE_LOSS_FOR(radiation, seconds))

/mob/living/carbon/human/proc/radiation_hairloss()
	f_style = "Shaved"
	h_style = "Bald"
	update_hair()

/** breathing **/

/mob/living/carbon/human/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.clothing_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.clothing_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	..()

/mob/living/carbon/human/handle_post_breath(datum/gas_mixture/breath)
	..()
	//spread some viruses while we are at it
	if(breath && virus2.len > 0 && prob(10))
		for(var/mob/living/carbon/M in view(1,src))
			src.spread_disease_to(M)


/mob/living/carbon/human/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(internal)
		//Because rigs store their tanks out of reach of contents.Find(), a check has to be made to make
		//sure the hardsuit is still worn, still online, and that its air supply still exists.
		var/obj/item/tank/rig_supply
		if(istype(back,/obj/item/hardsuit))
			var/obj/item/hardsuit/hardsuit = back
			if(hardsuit.is_activated() && (hardsuit.air_supply && internal == hardsuit.air_supply))
				rig_supply = hardsuit.air_supply

		if ((!rig_supply && !contents.Find(internal)) || !((wear_mask && (wear_mask.clothing_flags & ALLOWINTERNALS)) || (head && (head.clothing_flags & ALLOWINTERNALS))))
			internal = null

		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(internals)
			internals.icon_state = "internal0"
	return null


/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & STATUS_GODMODE)
		return

	if(suiciding)
		failed_last_breath = 1
		adjustOxyLoss(2)//If you are suiciding, you should die a little bit faster
		oxygen_alert = max(oxygen_alert, 1)
		suiciding --
		return 0

	if(does_not_breathe)
		failed_last_breath = 0
		adjustOxyLoss(-5)
		return

	if(!breath || (breath.total_moles == 0))
		failed_last_breath = 1
		if(health > config_legacy.health_threshold_crit)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		// todo: this is technically not physics-ally accurate
		// basically, people's lungs rupture when breathing null gasmixes even in atmos
		// this mechanic shouldn't be for that as we don't exactly need to simulate vacuum pumps killing people or something
		// so we just add a quick and dirty check for environment
		if(breath && should_have_organ(O_LUNGS))
			var/turf/our_location = get_turf(src)
			//* returned air is immutable - do not edit *//
			var/datum/gas_mixture/our_location_air = our_location.return_air_immutable()
			var/external_vacuum = our_location_air.return_pressure() < 5
			if(external_vacuum)
				var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
				if(!L.is_bruised() && prob(8))
					rupture_lung()

		oxygen_alert = max(oxygen_alert, 1)

		return 0

	var/safe_pressure_min = species.minimum_breath_pressure // Minimum safe partial pressure of breathable gas in kPa

	var/gas_to_process_ratio =  1 //Used for gas processing as reagents
	// Lung damage increases the minimum safe pressure.
	if(should_have_organ(O_LUNGS))
		var/obj/item/organ/internal/lungs/L = internal_organs_by_name[O_LUNGS]
		if(L && L.robotic >= ORGAN_ROBOT)
			gas_to_process_ratio = 0.66//If the lungs are artificial they filter a bit of unwanted gases
		if(isnull(L))
			safe_pressure_min = INFINITY //No lungs, how are you breathing?
		else if(L.is_broken())
			safe_pressure_min *= 1.5
		else if(L.is_bruised())
			safe_pressure_min *= 1.25
		else if(breath)
			if(breath.total_moles < BREATH_MOLES / 10 || breath.total_moles > BREATH_MOLES * 5)
				if(is_below_sound_pressure(get_turf(src)))	//No more popped lungs from choking/drowning
					if (prob(8))
						rupture_lung()

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/inhaled_gas_used = 0

	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	var/inhaling
	var/poison
	var/exhaling

	var/breath_type
	var/poison_type
	var/exhale_type

	var/failed_inhale = 0
	var/failed_exhale = 0

	if(species.breath_type)
		breath_type = species.breath_type
	else
		breath_type = GAS_ID_OXYGEN
	inhaling = breath.gas[breath_type]

	if(species.poison_type)
		poison_type = species.poison_type
	else
		poison_type = GAS_ID_PHORON
	poison = breath.gas[poison_type]

	if(species.exhale_type)
		exhale_type = species.exhale_type
		exhaling = breath.gas[exhale_type]
	else
		exhaling = 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	// Not enough to breathe
	if(inhale_pp < safe_pressure_min)
		if(prob(20))
			spawn(0) emote("gasp")

		var/ratio = inhale_pp/safe_pressure_min
		// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
		adjustOxyLoss(max(HUMAN_MAX_OXYLOSS*(1-ratio), 0))
		failed_inhale = 1

		oxygen_alert = max(oxygen_alert, 1)
	else
		// We're in safe limits
		oxygen_alert = 0

	inhaled_gas_used = inhaling/6

	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, bodytemperature, update = 0) //update afterwards

		// Too much exhaled gas in the air
		if(exhaled_pp > safe_exhaled_max)
			if (!co2_alert|| prob(15))
				var/word = pick("extremely dizzy","short of breath","faint","confused")
				to_chat(src, "<span class='danger'>You feel [word].</span>")

			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			co2_alert = 1
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.7)
			if (!co2_alert || prob(1))
				var/word = pick("dizzy","short of breath","faint","momentarily confused")
				to_chat(src, "<span class='warning'>You feel [word].</span>")

			//scale linearly from 0 to 1 between safe_exhaled_max and safe_exhaled_max*0.7
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)

			//give them some oxyloss, up to the limit - we don't want people falling unconcious due to CO2 alone until they're pretty close to safe_exhaled_max.
			if (getOxyLoss() < 50*ratio)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			co2_alert = 1
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.6)
			if (prob(0.3))
				var/word = pick("a little dizzy","short of breath")
				to_chat(src, "<span class='warning'>You feel [word].</span>")

		else
			co2_alert = 0

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(reagents)
			reagents.add_reagent("toxin", clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
			breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		phoron_alert = max(phoron_alert, 1)
	else
		phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas[GAS_ID_NITROUS_OXIDE])
		var/SA_pp = (breath.gas[GAS_ID_NITROUS_OXIDE] / breath.total_moles) * breath_pressure

		// Enough to make us paralysed for a bit
		if(SA_pp > SA_para_min)

			// 3 gives them one second to wake up and run away a bit!
			afflict_unconscious(20 * 3)

			// Enough to make us sleep as well
			if(SA_pp > SA_sleep_min)
				afflict_sleeping(20 * 5)

		// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
		else if(SA_pp > 0.15)
			if(prob(20))
				spawn(0) emote(pick("giggle", "laugh"))
		breath.adjust_gas(GAS_ID_NITROUS_OXIDE, -breath.gas[GAS_ID_NITROUS_OXIDE]/6, update = 0) //update after

	for(var/gasname in breath.gas)
		// todo: all this needs rewritten.
		if(gasname == breath_type)
			continue
		var/list/reagent_gas_data = global.gas_data.reagents[gasname]
		if(!reagent_gas_data)
			continue
		// up-convert since intuitively reagent gas uses mols in tile air, rather than in breath.
		var/effective_moles = breath.gas[gasname] * (CELL_VOLUME / BREATH_VOLUME)
		if(effective_moles < reagent_gas_data[GAS_REAGENT_LIST_THRESHOLD])
			continue
		// Little bit of sanity so we aren't trying to add 0.0000000001 units of CO2, and so we don't end up with 99999 units of CO2.
		var/reagent_id = reagent_gas_data[GAS_REAGENT_LIST_ID]
		var/reagent_amount = ((effective_moles - reagent_gas_data[GAS_REAGENT_LIST_THRESHOLD]) * reagent_gas_data[GAS_REAGENT_LIST_FACTOR] + reagent_gas_data[GAS_REAGENT_LIST_AMOUNT]) * gas_to_process_ratio
		reagent_amount = min(reagent_amount, reagent_gas_data[GAS_REAGENT_LIST_MAX] - reagents.get_reagent_amount(reagent_id))
		if(reagent_amount < 0.05)
			continue
		reagents.add_reagent(reagent_id, reagent_amount)
		breath.adjust_gas(gasname, -breath.gas[gasname], update = 0) //update after

	// Were we able to breathe?
	if (failed_inhale || failed_exhale)
		failed_last_breath = 1
	else
		failed_last_breath = 0
		adjustOxyLoss(-5)


	// Hot air hurts :(
	if((breath.temperature < species.breath_cold_level_1 || breath.temperature > species.breath_heat_level_1) && !(MUTATION_COLD_RESIST in mutations))

		if(breath.temperature <= species.breath_cold_level_1)
			if(prob(20))
				to_chat(src, "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>")
		else if(breath.temperature >= species.breath_heat_level_1)
			if(prob(20))
				to_chat(src, "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>")

		if(breath.temperature >= species.breath_heat_level_1)
			if(breath.temperature < species.breath_heat_level_2)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, DAMAGE_TYPE_BURN, BP_HEAD, used_weapon = "Excessive Heat")
				fire_alert = max(fire_alert, 2)
			else if(breath.temperature < species.breath_heat_level_3)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, DAMAGE_TYPE_BURN, BP_HEAD, used_weapon = "Excessive Heat")
				fire_alert = max(fire_alert, 2)
			else
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, DAMAGE_TYPE_BURN, BP_HEAD, used_weapon = "Excessive Heat")
				fire_alert = max(fire_alert, 2)

		else if(breath.temperature <= species.breath_cold_level_1)
			if(breath.temperature > species.breath_cold_level_2)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_1, DAMAGE_TYPE_BURN, BP_HEAD, used_weapon = "Excessive Cold")
				fire_alert = max(fire_alert, 1)
			else if(breath.temperature > species.breath_cold_level_3)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_2, DAMAGE_TYPE_BURN, BP_HEAD, used_weapon = "Excessive Cold")
				fire_alert = max(fire_alert, 1)
			else
				apply_damage(COLD_GAS_DAMAGE_LEVEL_3, DAMAGE_TYPE_BURN, BP_HEAD, used_weapon = "Excessive Cold")
				fire_alert = max(fire_alert, 1)


		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/density = breath.total_moles / (CELL_MOLES * BREATH_PERCENTAGE)
		temp_adj *= density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
		//to_chat(world, "Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]")
		bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(src,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(src,"cold")

	breath.update_values()
	return 1

/**
 * @params
 * * environment - the gas mixture we're in
 * * dt - seconds to simulate
 */
/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment, dt)
	// todo: rework all of this. again. on characters v2.

	// legacy: species special processes
	//Stuff like the xenomorph's plasma regen happens here.
	// todo: why the shit is this here
	species.handle_environment_special(src, environment, dt)

	// legacy: incorporeal (shadekin) check
	if(is_incorporeal())
		return

	// legacy: synth snowflake shit
	// todo: kill this shit with fire
	if(isSynthetic()) // synth specific temperature values in the absence of a synthetic species
		var/mob/living/carbon/human/H = src
		//! I hate this, fuck you. Don't override shit in human life(). @Zandario
		if(H.species.get_species_id() == SPECIES_ID_ADHERENT)
			return // Don't modify Adherent heat levels ffs

		else
			species.heat_level_1 = 400
			species.heat_level_2 = 420 // haha nice
			species.heat_level_3 = 1000
			species.cold_level_1 = 200
			species.cold_level_2 = 140
			species.cold_level_3 = 80
			species.cold_discomfort_level = 290
			species.heat_discomfort_level = 380
			species.heat_discomfort_strings = list(
				"You feel heat within your wiring.",
				"You feel uncomfortably warm.",
				"Your internal sensors chime at the increase in temperature."
				)
			species.cold_discomfort_strings = list(
				"A small heating element begins warming your system.",
				"Your focus is briefly stolen by the chill of the air.",
				"You feel uncomfortably cold.",
				"You feel a chill within your wiring."
				)
			if(bodytemperature > species.heat_discomfort_level && !(H.species.get_species_id() == SPECIES_ID_PROTEAN))
				if(world.time >= last_synthcooling_message || last_synthcooling_message == 0)
					last_synthcooling_message = world.time + 60 SECONDS
					if(src.nutrition <= 25) // do they have enough energy for this?
						to_chat(src, "<font color='red' face='fixedsys'>Warning: Temperature at critically high levels.</font>")
						to_chat(src, "<font color='red' face='fixedsys'>Warning: Power critical. Unable to deploy cooling systems.</font>")
					else
						to_chat(src, "<font color='red' face='fixedsys'>Warning: Temperature at critically high levels.</font>")
						add_modifier(/datum/modifier/synthcooling, 15 SECONDS) // enable cooling systems at cost of energy
						adjust_nutrition(-25)

	var/absolute_pressure = isnull(environment)? 0 : environment.return_pressure()
	var/affecting_pressure = calculate_affecting_pressure(absolute_pressure)

	// legacy: contamination
	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment?.gas)
		if(global.gas_data.flags[g] & GAS_FLAG_CONTAMINANT && environment.gas[g] > 1)
			pl_effects()
			break

	// legacy: bodytemperature equalizaiton
	// todo: we should rework most of this
	// we simulate in space, or in somewhere with a gasmixture. otherwise, we don't care.
	if(istype(loc, /turf/space))
		// in space, we use blackbody radiation
		var/heat_loss = THERMODYNAMICS_HUMAN_EXPOSED_SURFACE_AREA * STEFAN_BOLTZMANN_CONSTANT * ((bodytemperature - COSMIC_RADIATION_TEMPERATURE)**4)
		var/temperature_loss = heat_loss/HUMAN_HEAT_CAPACITY
		adjust_bodytemperature(-temperature_loss)
	else if(!isnull(environment))
		// todo: this shit is all suboptimal
		// otherwise, we use environment temperature
		var/environment_temperature = environment.temperature
		var/difference = environment_temperature - bodytemperature
		// relative density multiplier
		var/density_multiplier = environment.total_moles / CELL_MOLES

		density_multiplier = density_multiplier > 1? sqrt(density_multiplier) : density_multiplier

		var/thermal_insulation

		var/nominal = species.body_temperature || T20C
		var/to_nominal = nominal - bodytemperature
		var/is_stabilizing = ((to_nominal > 0? 1 : -1) == (difference > 0? 1 : -1)) && \
			((abs(nominal - environment_temperature) < MOB_BODYTEMP_EQUALIZATION_FAVORABLE_LEEWAY) || \
				(abs(nominal - bodytemperature) > MOB_BODYTEMP_EQUALIZATION_FAVORABLE_FORCED_THRESHOLD) \
			)

		var/adjust = is_stabilizing? \
			min(max( \
				difference * MOB_BODYTEMP_EQUALIZATION_FAVORABLE_RATIO * density_multiplier, \
				min(difference, MOB_BODYTEMP_EQUALIZATION_MIN_FAVORABLE) \
			), difference) : \
			clamp( \
				difference * MOB_BODYTEMP_EQUALIZATION_UNFAVORABLE_RATIO * density_multiplier, \
				min(difference, MOB_BODYTEMP_EQUALIZATION_MIN_UNFAVORABLE), \
				MOB_BODYTEMP_EQUALIZATION_MAX_UNFAVORABLE \
			)

		if(istype(loc, /obj/machinery/atmospherics/component/unary/cryo_cell))
			adjust = min(adjust, 2) // snowflake patch for cryo i fucking hate this aoguhwagoehs8ry0u34ajwioer

		if(is_stabilizing)
			adjust_bodytemperature(adjust)
		else if(difference < 0)
			// we are being cooled
			thermal_insulation = get_cold_protection(environment_temperature)
			if(thermal_insulation < 1)
				// we aren't entirely shielded
				adjust_bodytemperature(adjust * (1 - thermal_insulation))
		else
			// we are getting heated
			thermal_insulation = get_heat_protection(environment_temperature)
			if(thermal_insulation < 1)
				// we aren't entirely shielded
				adjust_bodytemperature(adjust * (1 - thermal_insulation))

	// legacy: godmode check
	if(status_flags & STATUS_GODMODE)
		fire_alert = 0
		pressure_alert = 0
		return

	// todo: completely rework eveyrthing about this to be surface vs deep burns

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= species.heat_level_1)
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 1)

		var/burn_dam = 0

		// switch() can't access numbers inside variables, so we need to use some ugly if() spam ladder.
		if(bodytemperature >= species.heat_level_1)
			if(bodytemperature >= species.heat_level_2)
				if(bodytemperature >= species.heat_level_3)
					burn_dam = HEAT_DAMAGE_LEVEL_3
				else
					burn_dam = HEAT_DAMAGE_LEVEL_2
			else
				if(isSynthetic())
					burn_dam = HEAT_DAMAGE_SYNTH
				else
					burn_dam = HEAT_DAMAGE_LEVEL_1

		take_overall_damage(burn = burn_dam, damage_mode = DAMAGE_MODE_GRADUAL, weapon_descriptor = "internal burns")
		fire_alert = max(fire_alert, 2)

	else if(bodytemperature <= species.cold_level_1 && !IS_DEAD(src)) // dead check is temporary bandaid for health rework
		//Body temperature is too cold.
		fire_alert = max(fire_alert, 1)

		if(!istype(loc, /obj/machinery/atmospherics/component/unary/cryo_cell))
			var/cold_dam = 0
			if(bodytemperature <= species.cold_level_1)
				if(bodytemperature <= species.cold_level_2)
					if(bodytemperature <= species.cold_level_3)
						cold_dam = COLD_DAMAGE_LEVEL_3
					else
						cold_dam = COLD_DAMAGE_LEVEL_2
				else
					cold_dam = COLD_DAMAGE_LEVEL_1

			take_overall_damage(burn = cold_dam, damage_mode = DAMAGE_MODE_GRADUAL, weapon_descriptor = "frostbite")
			fire_alert = max(fire_alert, 1)

	if(affecting_pressure >= species.hazard_high_pressure)
		var/pressure_damage = min( ( (affecting_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(brute = pressure_damage, damage_mode = DAMAGE_MODE_GRADUAL | DAMAGE_MODE_NO_OVERFLOW, weapon_descriptor = "barotrauma")
		pressure_alert = 2
	else if(affecting_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(affecting_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(affecting_pressure >= species.hazard_low_pressure)
		pressure_alert = -1
	else
		if( !(MUTATION_COLD_RESIST in mutations))
			if(!isSynthetic() || !nif || !nif.flag_check(NIF_O_PRESSURESEAL,NIF_FLAGS_OTHER)) // NIF pressure seals
				take_overall_damage(brute = LOW_PRESSURE_DAMAGE, damage_mode = DAMAGE_MODE_GRADUAL | DAMAGE_MODE_NO_OVERFLOW, weapon_descriptor = "barotrauma")
			if(getOxyLoss() < 55) 		// 12 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a minute
				var/pressure_dam = 3	// 16 OxyLoss per 4 ticks when no internals present; unconsciousness in 13 ticks, roughly twenty seconds
										// (Extra 1 oxyloss from failed breath)
										// Being in higher pressure decreases the damage taken, down to a minimum of (species.hazard_low_pressure / ONE_ATMOSPHERE) at species.hazard_low_pressure
				pressure_dam *= (ONE_ATMOSPHERE - affecting_pressure) / ONE_ATMOSPHERE

				if(wear_suit && wear_suit.min_pressure_protection && head && head.min_pressure_protection)
					var/protection = max(wear_suit.min_pressure_protection, head.min_pressure_protection) // Take the weakest protection
					pressure_dam *= (protection) / (ONE_ATMOSPHERE) 	// Divide by ONE_ATMOSPHERE to get a fractional protection
																		// Stronger protection (Closer to 0) results in a smaller fraction
																		// Firesuits (Min protection = 0.2 atmospheres) decrease oxyloss to 1/5

				adjustOxyLoss(pressure_dam)
			pressure_alert = -2
		else
			pressure_alert = -1

/*
/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change
*/

/**
 * metabolism for body temperature
 *
 * should only be called while alive
 *
 * @params
 * * dt - seconds for this cycle
 */
/mob/living/carbon/human/proc/stabilize_body_temperature(dt)
	if(isnull(loc))
		// okay we should probably like
		// not.
		return

	var/buffer = bodytemperature

	// legacy: species passive gain
	// todo: shouldn't exist probably
	buffer += species.passive_temp_gain * dt
	// legacy: robot limbs gain heat
	// todo: rewrite
	if(robobody_count)
		if(!nif?.flag_check(NIF_O_HEATSINKS, NIF_FLAGS_OTHER))
			buffer += round(robobody_count* 1.15) * dt
		var/obj/item/organ/internal/robotic/heatsink/HS = internal_organs_by_name[O_HEATSINK]
		if(!HS || HS.is_broken()) // However, NIF Heatsinks will not compensate for a core FBP component (your heatsink) being lost.
			buffer += round(robobody_count * 0.5) * dt

	// legacy: thermal regulation
	// todo: rework
	if(species.body_temperature != null)
		// species has metabolic thermoregulation
		var/difference = species.body_temperature - bodytemperature

		if(buffer < species.cold_level_1)
			adjust_nutrition(-2)
			buffer += max((difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		else if(buffer > species.heat_level_1)
			adjust_hydration(-(10 * DEFAULT_THIRST_FACTOR))
			buffer += min((difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)
		else
			buffer += difference / BODYTEMP_AUTORECOVERY_DIVISOR

	set_bodytemperature(buffer)

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.max_heat_protection_temperature && C.max_heat_protection_temperature >= temperature)
				. |= C.heat_protection_cover

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.min_cold_protection_temperature && C.min_cold_protection_temperature <= temperature)
				. |= C.cold_protection_cover

/mob/living/carbon/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	. = get_thermal_protection(thermal_protection_flags)
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/thing in modifiers)
		var/datum/modifier/M = thing
		if(!isnull(M.heat_protection))
			. *= 1 - M.heat_protection

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)

/mob/living/carbon/human/get_cold_protection(temperature)
	if(MUTATION_COLD_RESIST in mutations)
		return 1 //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	. = get_thermal_protection(thermal_protection_flags)
	. = 1 - . // Invert from 1 = immunity to 0 = immunity.

	// Doing it this way makes multiplicative stacking not get out of hand, so two modifiers that give 0.5 protection will be combined to 0.75 in the end.
	for(var/thing in modifiers)
		var/datum/modifier/M = thing
		if(!isnull(M.cold_protection))
			// Invert the modifier values so they align with the current working value.
			. *= 1 - M.cold_protection

	// Code that calls this expects 1 = immunity so we need to invert again.
	. = 1 - .
	. = min(., 1.0)

/mob/living/carbon/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & UPPER_TORSO)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & LOWER_TORSO)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & FOOT_LEFT)
			. += THERMAL_PROTECTION_FOOT_LEFT
		if(flags & FOOT_RIGHT)
			. += THERMAL_PROTECTION_FOOT_RIGHT
		if(flags & ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
		if(flags & HAND_LEFT)
			. += THERMAL_PROTECTION_HAND_LEFT
		if(flags & HAND_RIGHT)
			. += THERMAL_PROTECTION_HAND_RIGHT
	return min(1,.)

/mob/living/carbon/human/handle_chemicals_in_body()

	if(inStasisNow())
		return

	if(reagents)
		chem_effects.Cut()

		if(touching)
			touching.metabolize()
		if(ingested)
			ingested.metabolize()
		if(bloodstr)
			bloodstr.metabolize()

		if(!isSynthetic())

			var/total_phoronloss = 0
			GET_VSC_PROP(atmos_vsc, /atmos/phoron/contamination_loss, loss_per_part)
			for(var/obj/item/I in src)
				if(I.contaminated)
					if(check_belly(I))
						continue
					if(src.species && !(src.species.species_flags & CONTAMINATION_IMMUNE))
						if(isnull(I.held_index))
							//If the item isn't in your hands, you're probably wearing it. Full damage for you.
							total_phoronloss += loss_per_part
						else if(!((src.wear_suit.body_cover_flags & HANDS) | src.gloves | (src.w_uniform.body_cover_flags & HANDS)))	//If the item is in your hands, but you're wearing protection, you might be alright.
							//If you hold it in hand, and your hands arent covered by anything
							total_phoronloss += loss_per_part
			if(total_phoronloss)
				if(!(status_flags & STATUS_GODMODE))
					adjustToxLoss(total_phoronloss)

	if(status_flags & STATUS_GODMODE)
		return FALSE	//godmode

	if(species.light_dam)
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			light_amount = T.get_lumcount() * 10
		if(light_amount > species.light_dam) //if there's enough light, start dying
			take_overall_damage(1,1)
		else //heal in the dark
			heal_overall_damage(1,1)

	// nutrition decrease
	if (nutrition > 0 && stat != DEAD)
		var/nutrition_reduction = species.hunger_factor

		for(var/datum/modifier/mod in modifiers)
			if(!isnull(mod.metabolism_percent))
				nutrition_reduction *= mod.metabolism_percent

		adjust_nutrition(-nutrition_reduction)

	if (nutrition > species.max_nutrition)
		if(overeatduration < 600) //capped so people don't take forever to unfat
			overeatduration++
	else
		if(overeatduration > 1)
			overeatduration -= 2 //doubled the unfat rate

	// hydration decrease
	if (hydration > 0 && stat != DEAD)
		var/hydration_reduction = species.thirst_factor

		for(var/datum/modifier/mod in modifiers)
			if(!isnull(mod.metabolism_percent)) //Metabolism affects thirst too in this weird world.
				hydration_reduction *= mod.metabolism_percent
		adjust_hydration(-hydration_reduction)

	if(noisy == TRUE && nutrition < 250 && prob(10))
		var/sound/growlsound = sound(get_sfx("hunger_sounds"))
		var/growlmultiplier = 100 - (nutrition / 250 * 100)
		playsound(src, growlsound, vol = growlmultiplier, vary = 1, falloff = 0.1, ignore_walls = TRUE, preference = /datum/game_preference_toggle/vore_sounds/digestion_noises)

	// TODO: stomach and bloodstream organ.
	if(!isSynthetic())
		handle_trace_chems()

	update_health()

	return //TODO: DEFERRED

//DO NOT CALL handle_statuses() from this proc, it's called from living/Life(seconds, times_fired) as long as this returns a true value.
/mob/living/carbon/human/handle_regular_UI_updates()
	if(skip_some_updates())
		return FALSE

	if(status_flags & STATUS_GODMODE)	return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		apply_status_effect(/datum/status_effect/sight/blindness, 5 SECOND)//This modifier does not expire as long as the holder is dead
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		update_health()	//TODO

		if(health <= getMinHealth() || (should_have_organ("brain") && !has_brain()))
			death()
			apply_status_effect(/datum/status_effect/sight/blindness, 5 SECOND)
			silent = 0
			return 1

		//UNCONSCIOUS. NO-ONE IS HOME
		if((getOxyLoss() > (species.total_health/2)) || (health <= getCritHealth()))
			afflict_unconscious(20 * 3)

		if(hallucination)
			if(hallucination >= 20 && !(species.species_flags & (NO_POISON|IS_PLANT|NO_HALLUCINATION)) )
				if(prob(3))
					fake_attack(src)
				if(!handling_hal)
					spawn handle_hallucinations() //The not boring kind!

			adjustHallucination(-2)
		else
			for(var/atom/a in hallucinations)
				qdel(a)

		//Brain damage from Oxyloss
		if(should_have_organ(O_BRAIN))
			var/brainOxPercent = 0.015		//Default 1.5% of your current oxyloss is applied as brain damage, 50 oxyloss is 1 brain damage
			if(CE_STABLE in chem_effects)
				brainOxPercent = 0.008		//Halved in effect
			if(oxyloss >= (getMaxHealth() * 0.3) && prob(5)) // If oxyloss exceeds 30% of your max health, you can take brain damage.
				adjustBrainLoss(brainOxPercent * oxyloss)

		if(halloss >= species.total_health)
			to_chat(src, "<span class='notice'>You're in too much pain to keep going...</span>")
			src.visible_message("<B>[src]</B> slumps to the ground, too weak to continue fighting.")
			afflict_unconscious(20 * 10)
			setHalLoss(species.total_health - 1)

		if(!IS_CONSCIOUS(src))
			apply_status_effect(/datum/status_effect/sight/blindness, 5 SECOND)
			animate_tail_reset()
			adjustHalLoss(-3)
			adjustHallucination(-3)

		if(is_sleeping())
			handle_dreams()
			if( prob(2) && health > 0 && !hal_crit )
				spawn(0)
					emote("snore")

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			var/list/E
			E = get_visible_implants(0)
			if(!E.len)
				embedded_flag = 0

		//Eyes
		//Check hardsuit first because it's two-check and other checks will override it.
		if(istype(back,/obj/item/hardsuit))
			var/obj/item/hardsuit/O = back
			if(O.helmet && O.helmet == head && (O.helmet.body_cover_flags & EYES))
				if((!O.is_online() && O.offline_vision_restriction == 2) || (O.is_online() && O.vision_restriction == 2))
					apply_status_effect(/datum/status_effect/sight/blindness, O.seal_delay)

		// Check everything else.

		//Periodically double-check embedded_flag
		// if(embedded_flag && !(life_tick % 10))
			// if(!embedded_needs_process())
			// 	embedded_flag = 0

		if(species.vision_organ)
			var/obj/item/organ/vision = internal_organs_by_name[species.vision_organ]
			if(vision && vision.is_bruised())   // Vision organs impaired? Permablurry.
				eye_blurry = 1
		if(eye_blurry)	           // Blurry eyes heal slowly
			eye_blurry = max(eye_blurry-1, 0)

		//Ears
		if(sdisabilities & SDISABILITY_DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf-1, 0)
		else if(get_ear_protection() >= 2)	//resting your ears with earmuffs heals ear damage faster
			ear_damage = max(ear_damage-0.15, 0)
			ear_deaf = max(ear_deaf, 1)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			ear_damage = max(ear_damage-0.05, 0)

		//Resting
		if(IS_PRONE(src))
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		if (drowsyness)
			drowsyness = max(0, drowsyness - 1)
			eye_blurry = max(2, eye_blurry)
			if (prob(5))
				afflict_sleeping(20 * 1)
				afflict_unconscious(20 * 5)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1

/mob/living/carbon/human/set_stat(var/new_stat)
	. = ..()
	if(. && stat)
		update_skin(1)

/mob/living/carbon/human/handle_regular_hud_updates()
	// now handle what we see on our screen

	if(!client)
		return 0

	..()

	client.screen.Remove(GLOB.global_hud.darkMask, GLOB.global_hud.whitense)

	if(istype(client.eye,/obj/machinery/camera))
		var/obj/machinery/camera/cam = client.eye
		client.screen |= cam.client_huds

	if(stat == DEAD) //Dead
		if(!druggy)
			SetSeeInvisibleSelf(SEE_INVISIBLE_LEVEL_TWO)
		if(healths)
			healths.icon_state = "health7"	//DEAD healthmeter

	else if(stat == UNCONSCIOUS && health <= 0) //Crit
		//Critical damage passage overlay
		var/severity = 0
		switch(health)
			if(-20 to -10)			severity = 1
			if(-30 to -20)			severity = 2
			if(-40 to -30)			severity = 3
			if(-50 to -40)			severity = 4
			if(-60 to -50)			severity = 5
			if(-70 to -60)			severity = 6
			if(-80 to -70)			severity = 7
			if(-90 to -80)			severity = 8
			if(-95 to -90)			severity = 9
			if(-INFINITY to -95)	severity = 10
		overlay_fullscreen("crit", /atom/movable/screen/fullscreen/scaled/crit, severity)
	else //Alive
		clear_fullscreen("crit")
		//Oxygen damage overlay
		if(oxyloss)
			var/severity = 0
			switch(oxyloss)
				if(10 to 20)		severity = 1
				if(20 to 25)		severity = 2
				if(25 to 30)		severity = 3
				if(30 to 35)		severity = 4
				if(35 to 40)		severity = 5
				if(40 to 45)		severity = 6
				if(45 to INFINITY)	severity = 7
			overlay_fullscreen("oxy", /atom/movable/screen/fullscreen/scaled/oxy, severity)
		else
			clear_fullscreen("oxy")

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getShockBruteLoss() + src.getShockFireLoss() + damageoverlaytemp	//Doesn't call the overlay if you can't actually feel it
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/severity = 0
			switch(hurtdamage)
				if(10 to 25)
					severity = 1
				if(25 to 40)
					severity = 2
				if(40 to 55)
					severity = 3
				if(55 to 70)
					severity = 4
				if(70 to 85)
					severity = 5
				if(85 to INFINITY)
					severity = 6
			overlay_fullscreen("brute", /atom/movable/screen/fullscreen/scaled/brute, severity)
		else
			clear_fullscreen("brute")

		if(healths)
			if (chem_effects[CE_PAINKILLER] > 100)
				healths.icon_state = "health_numb"
			else
				// Generate a by-limb health display.
				var/mutable_appearance/healths_ma = new(healths)
				healths_ma.icon_state = "blank"
				healths_ma.cut_overlays()
				healths_ma.plane = HUD_PLANE

				var/no_damage = 1
				var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
				if(!(species.species_flags & NO_PAIN))
					trauma_val = max(traumatic_shock,halloss)/species.total_health
				var/limb_trauma_val = trauma_val*0.3
				// Collect and apply the images all at once to avoid appearance churn.
				var/list/health_images = list()
				for(var/obj/item/organ/external/E in organs)
					if(no_damage && (E.brute_dam || E.burn_dam))
						no_damage = 0
					health_images += E.get_damage_hud_image(limb_trauma_val)

				// Apply a fire overlay if we're burning.
				if(on_fire)
					health_images += image('icons/mob/OnFire.dmi',"[get_fire_icon_state()]")

				// Show a general pain/crit indicator if needed.
				if(trauma_val)
					if(!(species.species_flags & NO_PAIN))
						if(trauma_val > 0.7)
							health_images += image('icons/mob/screen1_health.dmi',"softcrit")
						if(trauma_val >= 1)
							health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
				else if(no_damage)
					health_images += image('icons/mob/screen1_health.dmi',"fullhealth")

				healths_ma.add_overlay(health_images)
				healths.appearance = healths_ma

		if(nutrition_icon)
			switch(nutrition/species.max_nutrition)
				if(1 to INFINITY)
					nutrition_icon.icon_state = "nutrition0"
				if(0.778 to 1)
					nutrition_icon.icon_state = "nutrition1"
				if(0.556 to 0.778)
					nutrition_icon.icon_state = "nutrition2"
				if(0.333 to 0.556)
					nutrition_icon.icon_state = "nutrition3"
				else
					nutrition_icon.icon_state = "nutrition4"

		if(hydration_icon)
			switch(hydration)
				if(450 to INFINITY)
					hydration_icon.icon_state = "hydration0"
				if(350 to 450)
					hydration_icon.icon_state = "hydration1"
				if(250 to 350)
					hydration_icon.icon_state = "hydration2"
				if(150 to 250)
					hydration_icon.icon_state = "hydration3"
				else
					hydration_icon.icon_state = "hydration4"

		if(synthbattery_icon)
			switch(nutrition)
				if(350 to INFINITY)
					synthbattery_icon.icon_state = "charge4"
				if(250 to 350)
					synthbattery_icon.icon_state = "charge3"
				if(100 to 250)
					synthbattery_icon.icon_state = "charge2"
				else
					synthbattery_icon.icon_state = "charge1"
			if(stat == DEAD)
				synthbattery_icon.icon_state = "charge0"

		if(pressure)
			pressure.icon_state = "pressure[pressure_alert]"

			// if(rest)	//Not used with new UI
			// 	if(resting || lying || sleeping)
			// 		rest.icon_state = "rest1"
			// 	else
			// 		rest.icon_state = "rest0"
		if(toxin)
			if(hal_screwyhud == 4 || (phoron_alert && !does_not_breathe))
				toxin.icon_state = "tox1"
			else
				toxin.icon_state = "tox0"
		if(oxygen)
			if(hal_screwyhud == 3 || (oxygen_alert && !does_not_breathe))
				oxygen.icon_state = "oxy1"
			else
				oxygen.icon_state = "oxy0"
		if(fire)
			if(fire_alert)
				fire.icon_state = "fire[fire_alert]" //fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
			else
				fire.icon_state = "fire0"

		if(bodytemp)
			if (!species)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)
						bodytemp.icon_state = "temp4"
					if(350 to 370)
						bodytemp.icon_state = "temp3"
					if(335 to 350)
						bodytemp.icon_state = "temp2"
					if(320 to 335)
						bodytemp.icon_state = "temp1"
					if(300 to 320)
						bodytemp.icon_state = "temp0"
					if(295 to 300)
						bodytemp.icon_state = "temp-1"
					if(280 to 295)
						bodytemp.icon_state = "temp-2"
					if(260 to 280)
						bodytemp.icon_state = "temp-3"
					else
						bodytemp.icon_state = "temp-4"
			else
				//TODO: precalculate all of this stuff when the species datum is created
				var/base_temperature = species.body_temperature
				if(base_temperature == null) //some species don't have a set metabolic temperature
					base_temperature = (species.heat_level_1 + species.cold_level_1)/2

				var/temp_step
				if (bodytemperature >= base_temperature)
					temp_step = (species.heat_level_1 - base_temperature)/4

					if (bodytemperature >= species.heat_level_1)
						bodytemp.icon_state = "temp4"
					else if (bodytemperature >= base_temperature + temp_step*3)
						bodytemp.icon_state = "temp3"
					else if (bodytemperature >= base_temperature + temp_step*2)
						bodytemp.icon_state = "temp2"
					else if (bodytemperature >= base_temperature + temp_step*1)
						bodytemp.icon_state = "temp1"
					else
						bodytemp.icon_state = "temp0"
				else if (bodytemperature < base_temperature)
					temp_step = (base_temperature - species.cold_level_1)/4

					if (bodytemperature <= species.cold_level_1)
						bodytemp.icon_state = "temp-4"
					else if (bodytemperature <= base_temperature - temp_step*3)
						bodytemp.icon_state = "temp-3"
					else if (bodytemperature <= base_temperature - temp_step*2)
						bodytemp.icon_state = "temp-2"
					else if (bodytemperature <= base_temperature - temp_step*1)
						bodytemp.icon_state = "temp-1"
					else
						bodytemp.icon_state = "temp0"

		if(disabilities & DISABILITY_NEARSIGHTED)	//this looks meh but saves a lot of memory by not requiring to add var/prescription
			var/corrected = FALSE
			if(glasses)					//to every /obj/item
				var/obj/item/clothing/glasses/G = glasses
				if(G.prescription)
					corrected = TRUE
			if(nif?.flag_check(NIF_V_CORRECTIVE,NIF_FLAGS_VISION))
				corrected = TRUE
			if(!corrected)
				overlay_fullscreen("impaired", /atom/movable/screen/fullscreen/scaled/impaired, 1)
			else
				clear_fullscreen("impaired")
		else
			clear_fullscreen("impaired")

		if(eye_blurry)
			overlay_fullscreen("blurry", /atom/movable/screen/fullscreen/tiled/blurry)
		else
			clear_fullscreen("blurry")
		if(druggy)
			overlay_fullscreen("high", /atom/movable/screen/fullscreen/tiled/high)
		else
			clear_fullscreen("high")

		if(config_legacy.welder_vision)
			var/found_welder
			if(species.short_sighted)
				found_welder = 1
			else
				if(istype(glasses, /obj/item/clothing/glasses/welding))
					var/obj/item/clothing/glasses/welding/O = glasses
					if(!O.up)
						found_welder = 1
				if(!found_welder && nif && nif.flag_check(NIF_V_UVFILTER,NIF_FLAGS_VISION))	found_welder = 1
				if(!found_welder && istype(head, /obj/item/clothing/head/welding))
					var/obj/item/clothing/head/welding/O = head
					if(!O.up)
						found_welder = 1
				if(!found_welder && istype(back, /obj/item/hardsuit))
					var/obj/item/hardsuit/O = back
					if(O.helmet && O.helmet == head && (O.helmet.body_cover_flags & EYES))
						if((!O.is_online() && O.offline_vision_restriction == 1) || (O.is_online() && O.vision_restriction == 1))
							found_welder = 1
				if(absorbed) found_welder = 1
			if(found_welder)
				client.screen |= GLOB.global_hud.darkMask

/mob/living/carbon/human/handle_vision()
	if(stat == DEAD)
		if(client)
			if(client.view != world.view) // If mob dies while zoomed in with device, unzoom them.
				for(var/obj/item/item in contents)
					if(item.zoom)
						item.zoom()
						break

	else //We aren't dead
		if(MUTATION_XRAY in mutations)
			AddSightSelf(SEE_TURFS | SEE_MOBS | SEE_OBJS)
			// todo: legacy, remove
			self_perspective.legacy_force_set_hard_darkvision(0)
		else
			self_perspective.legacy_force_set_hard_darkvision(null)

		if(seer==1)
			var/obj/effect/rune/R = locate() in loc
			if(R && R.word1 == cultwords["see"] && R.word2 == cultwords["hell"] && R.word3 == cultwords["join"])
				see_invisible = SEE_INVISIBLE_CULT
			else
				see_invisible = see_invisible_default
				seer = 0

		SetSightSelf(species.get_vision_flags(src))

		var/glasses_processed = 0
		var/obj/item/hardsuit/hardsuit = back
		if(istype(hardsuit) && hardsuit.visor)
			if(!hardsuit.helmet || (head && hardsuit.helmet == head))
				if(hardsuit.visor && hardsuit.visor.vision && hardsuit.visor.active && hardsuit.visor.vision.glasses)
					glasses_processed = process_glasses(hardsuit.visor.vision.glasses)

		if(glasses && !glasses_processed)
			glasses_processed = process_glasses(glasses)

		if(MUTATION_XRAY in mutations)
			AddSightSelf(SEE_TURFS|SEE_MOBS|SEE_OBJS)
			RemoveSightSelf(SEE_BLACKNESS)
			// todo: legacy, remove
			self_perspective.legacy_force_set_hard_darkvision(0)
		else
			self_perspective.legacy_force_set_hard_darkvision(null)

		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.vision_flags))
				AddSightSelf(M.vision_flags)

		if(!glasses_processed && nif)
			var/datum/nifsoft/vision_soft
			for(var/datum/nifsoft/NS in nif.nifsofts)
				if(NS.vision_exclusive && NS.active)
					vision_soft = NS
					break
			if(vision_soft)
				glasses_processed = process_nifsoft_vision(vision_soft) //Not really glasses but equitable

		if(!glasses_processed && (species.get_vision_flags(src) > 0))
			AddSightSelf(species.get_vision_flags(src))

		if(machine)
			var/viewflags = machine.check_eye(src, TRUE)
			if(viewflags < 0)
				reset_perspective()
			else if(viewflags && !looking_elsewhere)
				AddSightSelf(viewflags)
				sight |= viewflags
		else if(eyeobj)
			if(eyeobj.owner != src)
				reset_perspective()
		else
			var/isRemoteObserve = 0
			if((MUTATION_REMOTE_VIEW in mutations) && remoteview_target)
				if(remoteview_target.stat==CONSCIOUS)
					isRemoteObserve = 1
			if(!isRemoteObserve && remoteview_target)
				remoteview_target = null
				reset_perspective()

		//! shitcode ahead
		if(get_z(src))
			if(SSmapping.level_trait(get_z(src), ZTRAIT_BLOCK_LEGACY_WALLHACKS))
				RemoveSightSelf(SEE_OBJS | SEE_MOBS | SEE_TURFS)
		//! end

	return 1

/mob/living/carbon/human/proc/process_glasses(var/obj/item/clothing/glasses/G)
	. = FALSE
	if(G && G.active)
		if(G.vision_flags)
			AddSightSelf(G.vision_flags)
			RemoveSightSelf(G.vision_flags_remove)
			. = TRUE

/mob/living/carbon/human/proc/process_nifsoft_vision(var/datum/nifsoft/NS)
	. = FALSE
	if(NS && NS.active)
		if(NS.vision_flags_mob)
			AddSightSelf(NS.vision_flags_mob)
			RemoveSightSelf(NS.vision_flags_mob_remove)
			. = TRUE

/mob/living/carbon/human/handle_random_events()
	if(inStasisNow())
		return

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 30 && isSynthetic())
			if(!confused)
				if(prob(5))
					to_chat(src, SPAN_USERDANGER("You lose directional control!"))
					Confuse(10)
		if (getToxLoss() >= 45 && !isSynthetic())
			spawn vomit()

	/*
	//Commented out for now to determine how well it fits in on Cit.
	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if(T.get_lumcount() <= 0)
			playsound_local(src,pick(scarySounds),50, 1, -1)
	*/

/mob/living/carbon/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()
		if(hud_used && ling_chem_display)
			ling_chem_display.invisibility = 0
//			ling_chem_display.maptext = "<div align='center' valign='middle' style='position:relative; top:0px; left:6px'><font color='#dd66dd'>[round(mind.changeling.chem_charges)]</font></div>"
			switch(mind.changeling.chem_storage)
				if(1 to 50)
					switch(mind.changeling.chem_charges)
						if(0 to 9)
							ling_chem_display.icon_state = "ling_chems0"
						if(10 to 19)
							ling_chem_display.icon_state = "ling_chems10"
						if(20 to 29)
							ling_chem_display.icon_state = "ling_chems20"
						if(30 to 39)
							ling_chem_display.icon_state = "ling_chems30"
						if(40 to 49)
							ling_chem_display.icon_state = "ling_chems40"
						if(50)
							ling_chem_display.icon_state = "ling_chems50"
				if(51 to 80) //This is a crappy way of checking for engorged sacs...
					switch(mind.changeling.chem_charges)
						if(0 to 9)
							ling_chem_display.icon_state = "ling_chems0e"
						if(10 to 19)
							ling_chem_display.icon_state = "ling_chems10e"
						if(20 to 29)
							ling_chem_display.icon_state = "ling_chems20e"
						if(30 to 39)
							ling_chem_display.icon_state = "ling_chems30e"
						if(40 to 49)
							ling_chem_display.icon_state = "ling_chems40e"
						if(50 to 59)
							ling_chem_display.icon_state = "ling_chems50e"
						if(60 to 69)
							ling_chem_display.icon_state = "ling_chems60e"
						if(70 to 79)
							ling_chem_display.icon_state = "ling_chems70e"
						if(80)
							ling_chem_display.icon_state = "ling_chems80e"
	else
		if(mind && hud_used)
			ling_chem_display?.invisibility = 101

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & STATUS_GODMODE)
		return 0	//godmode
	if(!can_feel_pain())
		return

	if(health < getSoftCritHealth())// health 0 makes you immediately collapse
		shock_stage = max(shock_stage, 61)

	if(traumatic_shock >= 80)
		shock_stage += 1
	else if(health < getSoftCritHealth())
		shock_stage = max(shock_stage, 61)
	else
		shock_stage = min(shock_stage, 160)
		shock_stage = max(shock_stage - (traumatic_shock? 1 : 2), 0)
		return

	if(stat)
		return 0

	if(shock_stage == 10)
		custom_pain("[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!", 40)

	if(shock_stage >= 30)
		if(shock_stage == 30) emote("me",1,"is having trouble keeping their eyes open.")
		eye_blurry = max(2, eye_blurry)
		stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please&#44; just end the pain", "Your whole body is going numb")]!</span>")

	if (shock_stage >= 60)
		if(shock_stage == 60) emote("me",1,"'s body becomes limp.")
		if (prob(2))
			to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please&#44; just end the pain", "Your whole body is going numb")]!</span>")
			afflict_paralyze(20 * 20)

	if(shock_stage >= 80)
		if (prob(5))
			to_chat(src, "<span class='danger'>[pick("The pain is excruciating", "Please&#44; just end the pain", "Your whole body is going numb")]!</span>")
			afflict_paralyze(20 * 20)

	if(shock_stage >= 120)
		if (prob(2))
			to_chat(src, "<span class='danger'>[pick("You black out", "You feel like you could die any moment now", "You are about to lose consciousness")]!</span>")
			afflict_unconscious(20 * 5)

	if(shock_stage == 150)
		emote("me",1,"can no longer stand, collapsing!")
		afflict_paralyze(20 * 20)

	if(shock_stage >= 150)
		afflict_paralyze(20 * 20)

/mob/living/carbon/human/proc/handle_pulse()
	if(life_tick % 5)
		return pulse	//update pulse every 5 life ticks (~1 tick/sec, depending on server load)

	var/temp = PULSE_NORM

	var/brain_modifier = 1

	var/modifier_shift = 0
	var/modifier_set

	if(modifiers && modifiers.len)
		for(var/datum/modifier/mod in modifiers)
			if(isnull(modifier_set) && !isnull(mod.pulse_set_level))
				modifier_set = round(mod.pulse_set_level)	// Should be a whole number, but let's not take chances.
			else if(mod.pulse_set_level > modifier_set)
				modifier_set = round(mod.pulse_set_level)

			modifier_set = max(0, modifier_set)	// No setting to negatives.

			if(mod.pulse_modifier)
				modifier_shift += mod.pulse_modifier

	modifier_shift = round(modifier_shift)

	if(!internal_organs_by_name[O_HEART])
		temp = PULSE_NONE
		if(!isnull(modifier_set))
			temp = modifier_set
		return temp //No blood, no pulse.

	if(stat == DEAD)
		temp = PULSE_NONE
		if(!isnull(modifier_set))
			temp = modifier_set
		return temp	//that's it, you're dead, nothing can influence your pulse, aside from outside means.

	var/obj/item/organ/internal/heart/Pump = internal_organs_by_name[O_HEART]

	var/obj/item/organ/internal/brain/Control = internal_organs_by_name[O_BRAIN]

	if(Control)
		brain_modifier = Control.get_control_efficiency()

		if(brain_modifier <= 0.7 && brain_modifier >= 0.4) // 70%-40% control, things start going weird as the brain is failing.
			brain_modifier = rand(5, 15) / 10

	if(Pump)
		temp += Pump.standard_pulse_level - PULSE_NORM

	if(round(blood_holder.get_total_volume()) <= species.blood_volume*species.blood_level_danger)	//how much blood do we have
		temp = temp + 3	//not enough :(

	if(status_flags & STATUS_FAKEDEATH)
		temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

	if(!isnull(modifier_set))
		temp = modifier_set

	temp = max(0, temp + modifier_shift)	// No negative pulses.

	if(Pump)
		for(var/datum/reagent/R in reagents.get_reagent_datums())
			if(R.id in bradycardics)
				if(temp <= Pump.standard_pulse_level + 3 && temp >= Pump.standard_pulse_level)
					temp--
			if(R.id in tachycardics)
				if(temp <= Pump.standard_pulse_level + 1 && temp >= PULSE_NONE)
					temp++
			if(R.id in heartstopper) //To avoid using fakedeath
				temp = PULSE_NONE
			if(R.id in cheartstopper) //Conditional heart-stoppage
				if(reagents.get_reagent_amount(R.id) >= R.overdose)
					temp = PULSE_NONE
		return temp * brain_modifier
	//handles different chems' influence on pulse
	for(var/datum/reagent/R in reagents.get_reagent_datums())
		if(R.id in bradycardics)
			if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
				temp--
		if(R.id in tachycardics)
			if(temp <= PULSE_FAST && temp >= PULSE_NONE)
				temp++
		if(R.id in heartstopper) //To avoid using fakedeath
			temp = PULSE_NONE
		if(R.id in cheartstopper) //Conditional heart-stoppage
			if(reagents.get_reagent_amount(R.id) >= R.overdose)
				temp = PULSE_NONE

	return max(0, round(temp * brain_modifier))

/mob/living/carbon/human/proc/handle_heartbeat()
	if(pulse == PULSE_NONE)
		return

	var/obj/item/organ/internal/heart/H = internal_organs_by_name[O_HEART]

	if(!H || (H.robotic >= ORGAN_ROBOT))
		return

	if(pulse >= PULSE_2FAST || shock_stage >= 10 || (istype(get_turf(src), /turf/space) && get_preference_toggle(/datum/game_preference_toggle/ambience/area_ambience)))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2

		if(heartbeat >= rate)
			heartbeat = 0
			SEND_SOUND(src, sound('sound/effects/singlebeat.ogg',0,0,0,50))
		else
			heartbeat++

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/thermal_protection = get_heat_protection(fire_stacks * 1500) // Arbitrary but below firesuit max temp when below 20 stacks.

	if(thermal_protection == 1) // Immune.
		return
	else
		bodytemperature += (BODYTEMP_HEATING_MAX + (fire_stacks * 15)) * (1-thermal_protection)

//Our call for the NIF to do whatever
/mob/living/carbon/human/proc/handle_nif()
	//Process regular life stuff
	nif?.on_life()

#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS
