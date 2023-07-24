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

		ADD_TRAIT(H, TRAIT_MOB_UNCONSCIOUS, "__CHIMERA__")
		H.update_stat()
		H.update_mobility()

		//These are only messages to give the player and everyone around them an idea of which stage they're at
		//visible_message doesn't seem to relay selfmessages if you're paralysed, so we use to_chat
		addtimer(CALLBACK(H, /atom/.proc/visible_message,"<span class = 'warning'> [H]'s skin begins to ripple and move, as if something was crawling underneath.</span>"), 4 MINUTES)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat),H,"<span class = 'notice'>We begin to recycle the dead tissue.</span>"),4 MINUTES)

		addtimer(CALLBACK(H, /atom/.proc/visible_message,"<span class = 'warning'> <i>[H]'s body begins to lose its shape, skin sloughing off and melting, losing form and composure.</i></span>","<span class = 'notice'>There is little left. We will soon be ready.</span>"), 8 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat),H,"<span class = 'notice'>There is little left. We will soon be ready.</span>"), 8 MINUTES)

		addtimer(CALLBACK(src, PROC_REF(add_pop),H,), 10 MINUTES)

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

	H.revive(full_heal = TRUE)
	H.remove_all_restraints()
	LAZYREMOVE(H.mutations, MUTATION_HUSK)
	H.nutrition = 50		//Hungy, also guarantees ferality without any other tweaking
	H.setBrainLoss(braindamage)

	//Drop everything
	H.drop_inventory(TRUE, TRUE)
	H.visible_message("<span class = 'warning'>[H] emerges from a cloud of viscera!</b>")
	//Unfreeze some things
	REMOVE_TRAIT(H, TRAIT_MOB_UNCONSCIOUS, "__CHIMERA__")
	H.update_stat()
	H.update_mobility()
	H.does_not_breathe = FALSE
	H.afflict_paralyze(2)
	//Visual effects
	var/T = get_turf(H)
	new /obj/effect/gibspawner/human(T, H.dna,H.dna.blood_color,H.dna.blood_color)
	playsound(T, 'sound/effects/splat.ogg')

/spell/targeted/chimera/hatch_pop/after_cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	H.remove_spell(src)
	qdel(src)

