/mob/living/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/z_radiation_listener)

	//I'll just hang my coat up over here
	dsoverlay = image('icons/mob/darksight.dmi', GLOB.global_hud.darksight) //This is a secret overlay! Go look at the file, you'll see.
	var/mutable_appearance/dsma = new(dsoverlay) //Changing like ten things, might as well.
	dsma.alpha = 0
	dsma.plane = LIGHTING_PLANE
	dsma.blend_mode = BLEND_ADD
	dsoverlay.appearance = dsma

	selected_image = image(icon = 'icons/mob/screen1.dmi', loc = src, icon_state = "centermarker")

/mob/living/prepare_huds()
	..()
	prepare_data_huds()

/mob/living/proc/prepare_data_huds()
	update_hud_med_all()

/mob/living/Destroy()
	if(LAZYLEN(status_effects))
		for(var/s in status_effects)
			var/datum/status_effect/S = s
			if(S.on_remove_on_mob_delete) //the status effect calls on_remove when its mob is deleted
				qdel(S)
			else
				S.be_replaced()
	if(dsoverlay)
		dsoverlay.loc = null
		dsoverlay = null
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

	return ..()

//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(AM.Adjacent(src))
		start_pulling(AM)

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(src.stat || src.restrained())
		return 0
	if(src.status_flags & FAKEDEATH)
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

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = getMaxHealth() - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

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
			if(!affecting)	continue
			if(affecting.take_damage(0, divided_damage+extradam))	//TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
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
	if(status_flags & GODMODE)	return 0	//godmode

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
	updatehealth()

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode

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
	updatehealth()

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode

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
	updatehealth()

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/getShockFireLoss()	//Only checks for things that'll actually hurt (not robolimbs)
	return fireloss

/mob/living/proc/getActualFireLoss()	// Mostly for humans with robolimbs.
	return getFireLoss()

//'include_robo' only applies to healing, for legacy purposes, as all damage typically hurts both types of organs
/mob/living/proc/adjustFireLoss(var/amount,var/include_robo)
	if(status_flags & GODMODE)	return 0	//godmode
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
	updatehealth()

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode

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
	updatehealth()

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = min(max(brainloss + amount, 0),(getMaxHealth()*2))

/mob/living/proc/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
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
	updatehealth()

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = amount

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

/mob/living/Stun(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(stunned > 0)
		add_status_indicator("stunned")

/mob/living/SetStunned(amount)
	..()
	if(stunned <= 0)
		remove_status_indicator("stunned")
	else
		add_status_indicator("stunned")

/mob/living/AdjustStunned(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(stunned <= 0)
		remove_status_indicator("stunned")
	else
		add_status_indicator("stunned")

/mob/living/Weaken(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(weakened > 0)
		add_status_indicator("weakened")

/mob/living/SetWeakened(amount)
	..()
	if(weakened <= 0)
		remove_status_indicator("weakened")
	else
		add_status_indicator("weakened")

/mob/living/AdjustWeakened(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(weakened <= 0)
		remove_status_indicator("weakened")
	else
		add_status_indicator("weakened")

/mob/living/Unconscious(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(paralysis > 0)
		add_status_indicator("paralysis")

/mob/living/SetUnconscious(amount)
	..()
	if(paralysis <= 0)
		remove_status_indicator("paralysis")
	else
		add_status_indicator("paralysis")

/mob/living/AdjustUnconscious(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(paralysis <= 0)
		remove_status_indicator("paralysis")
	else
		add_status_indicator("paralysis")

/mob/living/Sleeping(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(sleeping > 0)
		add_status_indicator("sleeping")

/mob/living/SetSleeping(amount)
	..()
	if(sleeping <= 0)
		remove_status_indicator("sleeping")
	else
		add_status_indicator("sleeping")

/mob/living/AdjustSleeping(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(sleeping <= 0)
		remove_status_indicator("sleeping")
	else
		add_status_indicator("sleeping")

/mob/living/Confuse(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(confused > 0)
		add_status_indicator("confused")

/mob/living/SetConfused(amount)
	..()
	if(confused <= 0)
		remove_status_indicator("confused")
	else
		add_status_indicator("confused")

/mob/living/AdjustConfused(amount)
	if(amount > 0)
		for(var/datum/modifier/M in modifiers)
			if(!isnull(M.disable_duration_percent))
				amount = round(amount * M.disable_duration_percent)
	..(amount)
	if(confused <= 0)
		remove_status_indicator("confused")
	else
		add_status_indicator("confused")

/mob/living/Blind(amount)
	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.disable_duration_percent))
			amount = round(amount * M.disable_duration_percent)
	..(amount)

/mob/living/AdjustBlinded(amount)
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
/mob/living/proc/inflict_shock_damage(amount)
	electrocute_act(amount, null, 1 - get_shock_protection(), pick(BP_HEAD, BP_TORSO, BP_GROIN))

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


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


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
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute = 0, var/burn = 0, var/sharp = 0, var/edge = 0, var/emp = 0)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive()
	rejuvenate()

//	if(buckled)			// Throws an error when you try to rejuvinate someone riding a vehicle @ktoma36
//		buckled.unbuckle_mob()

	if(iscarbon(src))
		var/mob/living/carbon/C = src
		C.drop_slots_to_ground(list(SLOT_ID_HANDCUFFED, SLOT_ID_LEGCUFFED), INV_OP_FORCE)

	ExtinguishMob()
	fire_stacks = 0
	if(ai_holder) // AI gets told to sleep when killed. Since they're not dead anymore, wake it up.
		ai_holder.go_wake()

/mob/living/proc/rejuvenate()
	if(reagents)
		reagents.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetUnconscious(0)
	SetStunned(0)
	SetWeakened(0)

	// shut down ongoing problems
	radiation = 0
	nutrition = 400
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	SetBlinded(0)
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)

	// make the icons look correct
	regenerate_icons()

	update_hud_med_all()

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreen()

/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()
	// Making it so SSD people have prefs with fallback to original style.
	if(config_legacy.allow_Metadata)
		if(ooc_notes)
			to_chat(usr, "[src]'s Metainfo:<br>[ooc_notes]")
		else if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")
	return


/mob/living/proc/handle_footstep(turf/T)
	return FALSE

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		setClickCooldown(20)
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//unbuckling yourself
	if(buckled)
		resist_buckle()
		return TRUE

	//Breaking out of a locker?
	if(isobj(loc))
		var/obj/C = loc
		C.container_resist(src)
		return TRUE

	else if(canmove)
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else
			resist_restraints()

	else if(canmove)
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else
			resist_restraints()

	if(attempt_vr(src,"vore_process_resist",args))
		return TRUE

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")
	update_canmove()

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/tiled/flash)
	if(override_blindness_check || !(disabilities & SDISABILITY_NERVOUS))
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

/mob/living/proc/slip(var/slipped_on,stun_duration=8)
	return 0

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
	if(!check_has_mouth())
		return

	if(!lastpuke)
		lastpuke = 1
		if(isSynthetic())
			to_chat(src, "<span class='danger'>A sudden, dizzying wave of internal feedback rushes over you!</span>")
			src.Weaken(5)
		else
			if (nutrition <= 100)
				to_chat(src, "<span class='danger'>You gag as you want to throw up, but there's nothing in your stomach!</span>")
				src.Weaken(10)
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

					Stun(5)
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

/mob/living/update_canmove()
	// TEMPORARY PATCH UNTIL MOBILITY FLAGS
	if(restrained())
		stop_pulling()
		drop_all_held_items()
	// End
	if(!resting && cannot_stand() && can_stand_overridden())
		lying = 0
		canmove = 1
	else
		if(buckled)
			lying = buckled.buckle_lying(src)
		else
			lying = incapacitated(INCAPACITATION_KNOCKDOWN)
			canmove = !incapacitated(INCAPACITATION_DISABLED)

	if(lying)
		density = FALSE
		drop_all_held_items()
		for(var/obj/item/holder/H in get_mob_riding_slots())
			drop_item_to_ground(H)
		update_water() // Submerges the mob.
	else
		density = initial(density)

	for(var/obj/item/grab/G in grabbed_by)
		if(G.state >= GRAB_AGGRESSIVE)
			canmove = FALSE
			break

	if(lying != lying_prev)
		lying_prev = lying
		update_transform()
		SEND_SIGNAL(src, COMSIG_MOB_UPDATE_LYING, lying)

	return canmove

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

/mob/living/update_transform()
	// First, get the correct size.
	var/desired_scale_x = size_multiplier * icon_scale_x
	var/desired_scale_y = size_multiplier * icon_scale_y

	// Now for the regular stuff.
	var/matrix/M = matrix()
	M.Scale(desired_scale_x, desired_scale_y)
	M.Translate(0, 16*(desired_scale_y-1))
	animate(src, transform = M, time = 10)
	handle_status_indicators()

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

/mob/living/swap_hand()
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"

	// We just swapped hands, so the thing in our inactive hand will notice it's not the focus
	var/obj/item/I = get_inactive_held_item()
	if(I)
		if(I.zoom)
			I.zoom()
	return

/mob/proc/activate_hand(selhand)

/mob/living/activate_hand(selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

// todo: multihands

/mob/proc/activate_hand_of_index(index)

/mob/living/activate_hand_of_index(index)
	switch(index)
		if(1)
			activate_hand("l")
		if(2)
			activate_hand("r")

/mob/living/get_sound_env(var/pressure_factor)
	if (hallucination)
		return PSYCHOTIC
	else if (druggy)
		return DRUGGED
	else if (drowsyness)
		return DIZZY
	else if (confused)
		return DIZZY
	else if (sleeping)
		return UNDERWATER
	else
		return ..()

/mob/living/proc/has_vision()
	return !(eye_blind || (disabilities & SDISABILITY_NERVOUS) || stat || blinded)

/mob/living/proc/dirties_floor()	// If we ever decide to add fancy conditionals for making dirty floors (floating, etc), here's the proc.
	return makes_dirt

/mob/living/proc/needs_to_breathe()
	return !isSynthetic()

/mob/living/vv_get_header()
	. = ..()
	. += {"
		<a href='?_src_=vars;rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

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

/mob/living/get_centering_pixel_y_offset(dir, atom/aligning)
	. = ..()
	// since we're shifted up by transforms..
	. += ((size_multiplier * icon_scale_y) - 1) * 16

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
