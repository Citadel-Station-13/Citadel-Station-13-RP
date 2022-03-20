///////////////////////////////////////////////////////////////////////////////////////////////////
//			These are spells meant to be used by the Xenochimera species			 			 //
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
	still_recharging_msg = "<span class='notice'>We are not yet ready to use this.</span>"
	hud_state = "wiz_jaunt"
	override_base = "cult"
	var/nutrition_cost_minimum = 50
	var/nutrition_cost_proportional = 20 //percentage of nutriment it should cost if it's higher than the minimum

/spell/targeted/chimera/cast(list/targets, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/nut = (H.nutrition * nutrition_cost_proportional) / 100
		var/final_cost
		if(nut > nutrition_cost_minimum)
			final_cost = nut
		else
			final_cost = nutrition_cost_minimum

		if((H.nutrition - final_cost) >= 0)
			H.nutrition -= final_cost
		else
			H.nutrition = 0		//We're already super starved, and feral, so cast it for free, you're likely using it to get food at this point.
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
	nutrition_cost_minimum = 15		//The hungrier you get the less it will cost
	nutrition_cost_proportional = 10
	var/active = FALSE


/spell/targeted/chimera/thermal_sight/cast(list/targets, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		toggle_sight(user)
		addtimer(CALLBACK(src, .proc/toggle_sight,H), duration, TIMER_UNIQUE)
		..()

/spell/targeted/chimera/thermal_sight/proc/toggle_sight(mob/living/carbon/human/H)
	if(!active)
		to_chat(H, "<span class='notice'>We focus outward, gaining a keen sense of all those around us.</span>")
		H.species.vision_flags |= SEE_MOBS
		H.species.has_glowing_eyes = TRUE
		active = TRUE
	else
		to_chat(H, "<span class='notice'>Our senses dull.</span>")
		H.species.vision_flags &= ~SEE_MOBS
		H.species.has_glowing_eyes = FALSE
		active = FALSE
	H.update_eyes()

///////////////
//Voice Mimic//
///////////////
//It's a toggle, but doesn't cost nutriment to be toggled off
/spell/targeted/chimera/voice_mimic
	name = "Voice Mimicry"
	desc = "We shape our throat and tongue to imitate a person, or a sound. This ability is a toggle."

	spell_flags = INCLUDEUSER
	hud_state = "ling_mimic_voice"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 5 SECONDS
	duration = 0
	nutrition_cost_minimum = 25
	nutrition_cost_proportional = 5
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
				..()	//Processes nutriment cost
			else
				to_chat(user, "<span class='notice'>We return our voice to our normal identity.</span>")
				H.UnsetSpecialVoice()
				active = FALSE
		else
			return


////////////////
//Regeneration//
////////////////
//Huge cooldown, huge cost, but will actually heal most of your issues.

/spell/targeted/chimera/regenerate
	name = "Regeneration"
	desc = "We shed our skin, purging it of damage, regrowing limbs."

	spell_flags = INCLUDEUSER
	hud_state = "ling_fleshmend"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 10 MINUTES
	duration = 0
	nutrition_cost_minimum = 500
	nutrition_cost_proportional = 75
	var/healing_amount = 60
	var/delay = 1 MINUTE


/spell/targeted/chimera/regenerate/cast_check(skipcharge = 0,mob/user = usr)
	if(..())
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if((nutrition_cost_minimum > H.nutrition) || nutrition_cost_minimum > ((H.nutrition * nutrition_cost_proportional) / 100) )
				to_chat(H,"<span class = 'notice'>We don't have enough nutriment. This ability is costly...</span>")
				return FALSE
			else return TRUE

/spell/targeted/chimera/regenerate/cast(list/targets, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(do_after(H, delay, null, FALSE, TRUE, INCAPACITATION_DISABLED))
			H.restore_blood()
			H.species.create_organs(H)
			H.restore_all_organs()
			H.adjustBruteLoss(-healing_amount)
			H.adjustFireLoss(-healing_amount)
			H.adjustOxyLoss(-healing_amount)
			H.adjustCloneLoss(-healing_amount)
			H.adjustBrainLoss(-healing_amount)
			H.blinded = FALSE
			H.SetBlinded(FALSE)
			H.eye_blurry = FALSE
			H.ear_deaf = FALSE
			H.ear_damage = FALSE

			H.regenerate_icons()

			playsound(H, 'sound/effects/blobattack.ogg', 30, 1)
			var/T = get_turf(src)
			new /obj/effect/gibspawner/human(T, H.dna,H.dna.blood_color,H.dna.blood_color)
			H.visible_message("<span class='warning'>With a sickening squish, [src] reforms their whole body, casting their old parts on the floor!</span>",
			"<span class='notice'>We reform our body.  We are whole once more.</span>",
			"<span class='italics'>You hear organic matter ripping and tearing!</span>")
			..()
		else
			to_chat(user,"<span class = 'warning'>We were interrupted!</span>")
			charge_counter = 9.8 MINUTES


////////////////
//Revive spell//
////////////////
//Will incapacitate you for 10 minutes, and then you can revive.
/spell/targeted/chimera/hatch
	name = "Hatch Stasis"
	desc = "We attempt to grow an entirely new body from scratch, or death."

	spell_flags = INCLUDEUSER | GHOSTCAST
	hud_state = "ling_regenerative_stasis"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 60 MINUTES
	duration = 0 SECONDS
	nutrition_cost_minimum = 1
	nutrition_cost_proportional = 1


/spell/targeted/chimera/hatch/cast_check(skipcharge, mob/user = usr)
	if(..())
		if(!ishuman(user))
			to_chat(user,"Non-humans can't use this!")
			return FALSE

		var/confirmation = alert("You will begin a lengthy process of around ten minutes you cannot cancel- Is this what you want?","Hatching Prompt","Yes", "No")
		if(confirmation != "Yes")
			to_chat(user, "<span class = 'notice'> Hatching cancelled. </span>")
			return FALSE
		else return TRUE

/spell/targeted/chimera/hatch/cast(list/targets, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.stat == DEAD)
			H.visible_message("<span class = 'warning'> [H] lays eerily still. Something about them seems off, even when dead.</span>","<span class = 'notice'>We begin to gather up whatever is left to begin regrowth.</span>")
		else
			H.visible_message("<span class = 'warning'> [H] suddenly collapses, seizing up and going eerily still. </span>", "<span class = 'notice'>We begin the regrowth process to start anew.</span>")
			H.SetParalysis(8000) //admin style self-stun

		//These are only messages to give the player and everyone around them an idea of which stage they're at
		//visible_message doesn't seem to relay selfmessages if you're paralysed, so we use to_chat
		addtimer(CALLBACK(H, /atom/.proc/visible_message,"<span class = 'warning'> [H]'s skin begins to ripple and move, as if something was crawling underneath.</span>"), 4 MINUTES)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat,H,"<span class = 'notice'>We begin to recycle the dead tissue.</span>"),4 MINUTES)

		addtimer(CALLBACK(H, /atom/.proc/visible_message,"<span class = 'warning'> <i>[H]'s body begins to lose its shape, skin sloughing off and melting, losing form and composure.</i></span>","<span class = 'notice'>There is little left. We will soon be ready.</span>"), 8 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat,H,"<span class = 'notice'>There is little left. We will soon be ready.</span>"), 8 MINUTES)

		addtimer(CALLBACK(src, .proc/add_pop,H,), 10 MINUTES)

/spell/targeted/chimera/hatch/proc/add_pop(mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.visible_message("<span class = 'warning'> <b>[H] looks ready to burst!</b></span>")
		to_chat(H,"<span class = 'notice'><b>We are ready.</b></span>")
		var/spell/targeted/chimera/hatch_pop/S = new /spell/targeted/chimera/hatch_pop(H)
		var/master_type = /atom/movable/screen/movable/spell_master/chimera
		H.add_spell(S, "cult", master_type)


///////////////////////
//Actual Revive Spell//
///////////////////////
//Not to be used normally. Given by the 'hatch' spell
/spell/targeted/chimera/hatch_pop
	name = "Emerge"
	desc = "We emerge in our new form."

	spell_flags = INCLUDEUSER | GHOSTCAST
	hud_state = "ling_revive"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 10 SECONDS	//It gets removed after_cast anyway
	duration = 0
	nutrition_cost_minimum = 1
	nutrition_cost_proportional = 1

/spell/targeted/chimera/hatch_pop/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user

	var/braindamage = (H.brainloss * 0.6) //Can only heal half brain damage.

	H.revive()
	LAZYREMOVE(H.mutations, HUSK)
	H.nutrition = 50		//Hungy, also guarantees ferality without any other tweaking
	H.setBrainLoss(braindamage)

	//Drop everything
	for(var/obj/item/W in H)
		H.drop_from_inventory(W)
	H.visible_message("<span class = 'warning'>[H] emerges from a cloud of viscera!</b>")
	H.SetParalysis(0)
	//Unfreeze some things
	H.does_not_breathe = FALSE
	H.update_canmove()
	H.weakened = 2
	//Visual effects
	var/T = get_turf(H)
	new /obj/effect/gibspawner/human(T, H.dna,H.dna.blood_color,H.dna.blood_color)
	playsound(T, 'sound/effects/splat.ogg')

/spell/targeted/chimera/hatch_pop/after_cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	H.remove_spell(src)
	qdel(src)


////////////////////
//Timed No Breathe//
////////////////////
//Same principle as thermal sight. Could be status effects?
/spell/targeted/chimera/no_breathe
	name = "Stop Respiration"
	desc = "We change our form to no longer need to breathe at all. We cannot sustain this for long."

	spell_flags = INCLUDEUSER
	hud_state = "ling_toggle_breath"
	invocation = "none"
	invocation_type = SpI_NONE
	charge_max = 125 SECONDS	//5 seconds inbetween uses
	duration = 120 SECONDS
	nutrition_cost_minimum = 100
	nutrition_cost_proportional = 20	//Costly.
	var/active = FALSE


/spell/targeted/chimera/no_breathe/cast(list/targets, mob/user = usr)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		toggle_breath(user)
		addtimer(CALLBACK(src, .proc/toggle_breath,H), duration, TIMER_UNIQUE)
	..()

/spell/targeted/chimera/no_breathe/proc/toggle_breath(mob/living/carbon/human/H)
	if(!active)
		to_chat(H, "<span class='notice'>We preserve the air we have, no longer needing to breathe.</span>")
		H.does_not_breathe = TRUE
		active = TRUE
	else
		to_chat(H, "<span class='notice'>Our reserves are drained.</span>")
		H.does_not_breathe = FALSE
		active = FALSE


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
	still_recharging_msg = "<span class='notice'>We have shrieked already! It tires us! Get away!</span>"
	//Slightly more potent than an EMP grenade
	var/emp_heavy = 3
	var/emp_med = 6
	var/emp_light = 9
	var/emp_long = 12
	smoke_spread = 1
	smoke_amt = 1
	override_base = "cult"
	charge_max = 5 MINUTES	//Let's not be able to spam this


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
				if(T.get_ear_protection() >= 2 || T == user)
					continue
				to_chat(T, "<span class='danger'>You hear an extremely loud screeching sound!  It slightly \
				[pick("confuses","confounds","perturbs","befuddles","dazes","unsettles","disorients")] you.</span>")
				T.Confuse(10)
	playsound(get_turf(user),'sound/effects/screech.ogg', 75, TRUE)

	empulse(get_turf(user), emp_heavy, emp_med, emp_light, emp_long)

	user.visible_message("<span class='danger'>[user] vibrates and bubbles, letting out an inhuman shriek, reverberating through your ears!</span>")

	add_attack_logs(user,null,"Used dissonant shriek (Xenochimera) ")

	for(var/obj/machinery/light/L in range(range, src))
		L.on = 1
		L.broken()
