///////////////////////////////////////////////////////////////////////////////////////////////////
//			These are species-aimed spells meant to be used by the Xenochimera species			 //
///////////////////////////////////////////////////////////////////////////////////////////////////
/spell/targeted/chimera
	name = "A Chimera Spell"
	desc = "You shouldn't be seeing this."

	charge_max = 50
	spell_flags = INCLUDEUSER
	invocation = "none"
	invocation_type = SpI_NONE
	range = 1
	max_targets = 1
	cooldown_min = 0
	duration = 0

	hud_state = "wiz_jaunt"
	var/nutrition_cost_minimum = 50
	var/nutrition_cost_proportional = 20 //percentage of nutriment it should cost if it's higher than the minimum

/spell/targeted/chimera/cast(list/targets, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/nut = H.nutrition / nutrition_cost_proportional
		var/final_cost
		if(nut > nutrition_cost_minimum)
			final_cost = nut
		else
			final_cost = nutrition_cost_minimum
		H.nutrition -= final_cost
	else
		return

////////////////////////
//Timed thermal sight.//
////////////////////////

/spell/targeted/chimera/thermal_sight
	name = "Thermal Sight"
	desc = "We focus ourselves, able to sense prey and threat through walls or mist. We cannot sustain this for long."

	spell_flags = INCLUDEUSER
	hud_state = "ling_augmented_eyesight"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 35 SECONDS
	duration = 30 SECONDS
	nutrition_cost_minimum = 100
	nutrition_cost_proportional = 10
	var/active = FALSE


/spell/targeted/chimera/thermal_sight/cast(list/targets, mob/user = usr)
	if(user.stat != DEAD)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			toggle_sight(user)
			addtimer(CALLBACK(src, .proc/toggle_sight,H), duration, TIMER_UNIQUE)
	..()

/spell/targeted/chimera/thermal_sight/proc/toggle_sight(mob/living/carbon/human/H)
	if(!active)
		to_chat(H, "<span class='notice'>We focus outward, gaining a keen sense of all those around us.</span>")
		H.species.vision_flags |= SEE_MOBS
		active = TRUE
	else
		to_chat(H, "<span class='notice'>Our senses dull.</span>")
		H.species.vision_flags &= ~SEE_MOBS
		active = FALSE

///////////////
//Voice Mimic//
///////////////

/spell/targeted/chimera/voice_mimic
	name = "Voice Mimicry"
	desc = "We shape our throat and tongue to imitate a person, or a sound. This ability is a toggle."

	spell_flags = INCLUDEUSER
	hud_state = "ling_mimic_voice"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 10 SECONDS
	duration = 0
	nutrition_cost_minimum = 100
	nutrition_cost_proportional = 15
	var/active = FALSE

/spell/targeted/chimera/voice_mimic/cast(list/targets, mob/user = usr)
	if(user.stat != DEAD)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(!active)
				var/mimic_voice = sanitize(input(usr, "Enter a name to mimic. Leave blank to cancel.", "Mimic Voice", null), MAX_NAME_LEN)
				if(!mimic_voice)
					return

				to_chat(user, "<span class='notice'>We shift and morph our tongues, ready to reverberate as: <b>[mimic_voice]</b>.</span>")
				H.SetSpecialVoice(mimic_voice)
				active = TRUE
				..()
			else
				to_chat(user, "<span class='notice'>We return our voice to our normal identity.</span>")
				H.UnsetSpecialVoice()
				active = FALSE
		else
			return


///////////////
//EMP Shriek //
///////////////
//Only to be used during feral state, has a very long cooldown. Mostly to get away.

/spell/aoe_turf/dissonant_shriek
	name = "Dissonant Shriek"
	desc = "We shift our vocal cords to release a high-frequency sound that overloads nearby electronics."
	invocation = "none"
	invocation_type = SpI_NONE
	hud_state = "ling_resonant_shriek"
	spell_flags = INCLUDEUSER
	range = 8
	//Slightly more potent than an EMP grenade
	var/emp_heavy = 3
	var/emp_med = 6
	var/emp_light = 9
	var/emp_long = 12
	charge_max = 5 MINUTES


/spell/aoe_turf/dissonant_shriek/before_cast(list/targets, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.is_muzzled())
			to_chat(src, "<span class='danger'>Mmmf mrrfff!</span>")
			return

		if(H.silent)
			to_chat(src, "<span class='danger'>You can't speak!</span>")
			return

		if(!isturf(H.loc))
			to_chat(src, "<span class='warning'>Shrieking here would be a bad idea.</span>")
			return
		..()
	else
		return

/spell/aoe_turf/dissonant_shriek/cast(list/targets, mob/user = usr)

	for(var/mob/living/T in targets)
		if(iscarbon(T))
			if(T.mind)
				if(T.get_ear_protection() >= 2)
					continue
				to_chat(T, "<span class='danger'>You hear an extremely loud screeching sound!  It slightly \
				[pick("confuses","confounds","perturbs","befuddles","dazes","unsettles","disorients")] you.</span>")
				if(T != user)
					T.Confuse(10)
				SEND_SOUND(T, sound('sound/effects/screech.ogg'))

	empulse(get_turf(user), emp_heavy, emp_med, emp_light, emp_long)

	user.visible_message("<span class='danger'>[user] vibrates and bubbles, letting out an inhuman shriek, reverberating through your ears!</span>")

	add_attack_logs(user,null,"Used dissonant shriek (Xenochimera) ")

	for(var/obj/machinery/light/L in range(range, src))
		L.on = 1
		L.broken()
