// TODO: clone_pod, generic /living printer lol
//       or maybe humantype if it's too complicated.

#define CLONE_BIOMASS 30
/obj/machinery/clonepod
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue.\n <span class='notice'>\[Accepts Upgrades\]</span>"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/clonepod
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(ACCESS_SCIENCE_GENETICS) // For premature unlocking.
	var/mob/living/occupant
	/// The clone is released once its health reaches this level.
	var/heal_level = 20
	var/heal_rate = 1
	var/locked = FALSE
	/// So we remember the connected clone machine.
	var/obj/machinery/computer/cloning/connected = null
	/// Need to clean out it if it's full of exploded clone.
	var/mess = FALSE
	/// One clone attempt at a time thanks.
	var/attempting = FALSE
	/// Don't eject them as soon as they are created.
	var/eject_wait = FALSE
	/// Beakers for our liquid biomass.
	var/list/containers = list()
	/// How many beakers can the machine hold?
	var/container_limit = 3

/obj/machinery/clonepod/Initialize(mapload)
	. = ..()
	update_icon()

/obj/machinery/clonepod/attack_ai(mob/user)

	add_hiddenprint(user)
	return attack_hand(user)

/obj/machinery/clonepod/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if((isnull(occupant)) || (machine_stat & NOPOWER))
		return
	if((!isnull(occupant)) && (occupant.stat != 2))
		var/completion = (100 * ((occupant.health + 50) / (heal_level + 100))) // Clones start at -150 health
		to_chat(user, "Current clone cycle is [round(completion)]% complete.")
	return

/// Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(var/datum/dna2/record/R)
	if(mess || attempting)
		return FALSE
	var/datum/mind/clonemind = locate(R.mind)

	if(!istype(clonemind, /datum/mind)) // Not a mind.
		return FALSE
	if(clonemind.current && clonemind.current.stat != DEAD) // Mind is associated with a non-dead body.
		return FALSE
	if(clonemind.active) // Somebody is using that mind.
		if(clonemind.ckey != R.ckey)
			return FALSE
	else
		for(var/mob/observer/dead/G in GLOB.player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return FALSE

	for(var/modifier_type in R.genetic_modifiers) // Can't be cloned, even if they had a previous scan
		if(istype(modifier_type, /datum/modifier/no_clone))
			return FALSE

	// Remove biomass when the cloning is started, rather than when the guy pops out
	remove_biomass(CLONE_BIOMASS)

	attempting = TRUE // One at a time!!
	locked = TRUE

	eject_wait = TRUE
	spawn(30)
		eject_wait = FALSE

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	occupant = H

	if(!R.dna.real_name) // To prevent null names
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name
	H.gender = R.gender
	H.descriptors = R.body_descriptors

	// Get the clone body ready
	H.adjustCloneLoss(150) // New damage var so you can't eject a clone early then stab them to abuse the current damage system --NeoFite
	H.afflict_unconscious(20 * 4)

	// Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.update_health()

	clonemind.transfer(H)
	to_chat(H, SPAN_BOLDDANGER("Consciousness slowly creeps over you as your body regenerates.<br>") + SPAN_USERDANGER("Your recent memories are fuzzy, and it's hard to remember anything from today...<br>") + SPAN_NOTICE(SPAN_ROSE("So this is what cloning feels like?")))

	// -- Mode/mind specific stuff goes here
	callHook("clone", list(H))
	update_antag_icons(H.mind)
	// -- End mode specific stuff

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna
	H.UpdateAppearance()
	H.sync_organ_dna()
	if(heal_level < 60)
		randmutb(H) //Sometimes the clones come out wrong.
		H.dna.UpdateSE()
		H.dna.UpdateUI()

	H.set_cloned_appearance()
	update_icon()

	// A modifier is added which makes the new clone be unrobust.
	var/modifier_lower_bound = 25 MINUTES
	var/modifier_upper_bound = 40 MINUTES

	// Upgraded cloners can reduce the time of the modifier, up to 80%
	var/clone_sickness_length = abs(((heal_level - 20) / 100 ) - 1)
	clone_sickness_length = clamp( clone_sickness_length, 0.2,  1.0) // Caps it off just incase.
	modifier_lower_bound = round(modifier_lower_bound * clone_sickness_length, 1)
	modifier_upper_bound = round(modifier_upper_bound * clone_sickness_length, 1)

	H.add_modifier(H.species.cloning_modifier, rand(modifier_lower_bound, modifier_upper_bound))

	// Modifier that doesn't do anything.
	H.add_modifier(/datum/modifier/cloned)

	// This is really stupid.
	for(var/modifier_type in R.genetic_modifiers)
		H.add_modifier(modifier_type)

	for(var/datum/prototype/language/L in R.languages)
		H.add_language(L.name)

	H.flavor_texts = R.flavor.Copy()
	H.suiciding = 0
	attempting = 0
	return 1

/// Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/process(delta_time)
	if(machine_stat & NOPOWER) // Autoeject if power is lost
		if(occupant)
			locked = 0
			go_out()
		return

	if((occupant) && (occupant.loc == src))
		if((occupant.stat == DEAD) || (occupant.suiciding) || !occupant.key)  //Autoeject corpses and suiciding dudes.
			locked = 0
			go_out()
			connected_message("Clone Rejected: Deceased.")
			return

		else if(occupant.health < heal_level && occupant.getCloneLoss() > 0)
			occupant.afflict_unconscious(20 * 4)

			 //Slowly get that clone healed and finished.
			occupant.adjustCloneLoss(-2 * heal_rate)

			//Premature clones may have brain damage.
			occupant.adjustBrainLoss(-(CEILING(0.5*heal_rate, 1)))

			//So clones don't die of oxyloss in a running pod.
			if(occupant.reagents.get_reagent_amount("inaprovaline") < 30)
				occupant.reagents.add_reagent("inaprovaline", 60)
			occupant.afflict_sleeping(20 * 30)
			//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
			occupant.adjustOxyLoss(-4)

			use_power(7500) //This might need tweaking.
			return

		else if((occupant.health >= heal_level || occupant.health == occupant.getMaxHealth()) && (!eject_wait))
			playsound(src, 'sound/machines/medbayscanner1.ogg', 50, 1)
			audible_message("\The [src] signals that the cloning process is complete.")
			connected_message("Cloning Process Complete.")
			locked = 0
			go_out()
			return

	else if((!occupant) || (occupant.loc != src))
		occupant = null
		if(locked)
			locked = 0
		return

	return

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/attackby(obj/item/W as obj, mob/user as mob)
	if(isnull(occupant))
		if(default_deconstruction_screwdriver(user, W))
			return
		if(default_deconstruction_crowbar(user, W))
			return
		if(default_part_replacement(user, W))
			return
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(!check_access(W))
			to_chat(user, SPAN_WARNING("Access Denied."))
			return
		if((!locked) || (isnull(occupant)))
			return
		if((occupant.health < -20) && (occupant.stat != 2))
			to_chat(user, SPAN_WARNING("Access Refused."))
			return
		else
			locked = FALSE
			to_chat(user, "System unlocked.")
	else if(istype(W,/obj/item/reagent_containers/glass))
		if(LAZYLEN(containers) >= container_limit)
			to_chat(user, SPAN_WARNING("\The [src] has too many containers loaded!"))
		else if(do_after(user, 1 SECOND))
			if(!user.attempt_insert_item_for_installation(W, src))
				return
			user.visible_message("[user] has loaded \the [W] into \the [src].", "You load \the [W] into \the [src].")
			containers += W
		return
	else if(W.is_wrench())
		if(locked && (anchored || occupant))
			to_chat(user, SPAN_WARNING("Can not do that while [src] is in use."))
		else
			if(anchored)
				anchored = FALSE
				connected.pods -= src
				connected = null
			else
				anchored = TRUE
			playsound(src, W.tool_sound, 100, TRUE)
			if(anchored)
				user.visible_message("[user] secures [src] to the floor.", "You secure [src] to the floor.")
			else
				user.visible_message("[user] unsecures [src] from the floor.", "You unsecure [src] from the floor.")
	else if(istype(W, /obj/item/multitool))
		var/obj/item/multitool/M = W
		M.connecting = src
		to_chat(user, SPAN_NOTICE("You load connection data from [src] to [M]."))
		M.update_icon()
		return
	else
		..()

/obj/machinery/clonepod/emag_act(var/remaining_charges, var/mob/user)
	if(isnull(occupant))
		return
	to_chat(user, "You force an emergency ejection.")
	locked = 0
	go_out()
	return 1

/// Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(var/message)
	if((isnull(connected)) || (!istype(connected, /obj/machinery/computer/cloning)))
		return FALSE
	if(!message)
		return FALSE

	connected.temp = "[name] : [message]"
	connected.updateUsrDialog()
	return 1

/obj/machinery/clonepod/RefreshParts()
	..()
	var/rating = 0
	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/scanning_module) || istype(P, /obj/item/stock_parts/manipulator))
			rating += P.rating

	heal_level = rating * 10 - 20
	heal_rate = round(rating / 4)

/obj/machinery/clonepod/verb/eject()
	set name = "Eject Cloner"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)

	if(usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)
	return

/obj/machinery/clonepod/proc/go_out()
	if(locked)
		return

	if(mess) //Clean that mess and dump those gibs!
		mess = 0
		gibs(src.loc)
		update_icon()
		return

	if(!occupant)
		return

	occupant.forceMove(loc)
	occupant.update_perspective()

	eject_wait = 0 //If it's still set somehow.

	if(ishuman(occupant)) //Need to be safe.
		var/mob/living/carbon/human/patient = occupant
		if(!(patient.species.species_flags & NO_SCAN)) //If, for some reason, someone makes a genetically-unalterable clone, let's not make them permanently disabled.
			domutcheck(occupant) //Waiting until they're out before possible transforming.

	occupant = null

	update_icon()
	return

// Returns the total amount of biomass reagent in all of the pod's stored containers
/obj/machinery/clonepod/proc/get_biomass()
	var/biomass_count = 0
	for(var/obj/item/reagent_containers/container in containers)
		biomass_count += container.reagents?.reagent_volumes?[/datum/reagent/nutriment/biomass::id]
	return biomass_count

// Removes [amount] biomass, spread across all containers. Doesn't have any check that you actually HAVE enough biomass, though.
/obj/machinery/clonepod/proc/remove_biomass(amount = CLONE_BIOMASS)		//Just in case it doesn't get passed a new amount, assume one clone
	for(var/obj/item/reagent_containers/glass/beaker in containers)
		amount -= beaker.reagents.remove_reagent(/datum/reagent/nutriment/biomass, amount)
		if(!amount)
			return TRUE
	return !amount

// Empties all of the beakers from the cloning pod, used to refill it
/obj/machinery/clonepod/verb/empty_beakers()
	set name = "Eject Beakers"
	set category = VERB_CATEGORY_OBJECT
	set src in oview(1)

	if(usr.stat != 0)
		return

	add_fingerprint(usr)
	drop_beakers()
	return

// Actually does all of the beaker dropping
// Returns 1 if it succeeds, 0 if it fails. Added in case someone wants to add messages to the user.
/obj/machinery/clonepod/proc/drop_beakers()
	if(LAZYLEN(containers))
		var/turf/T = get_turf(src)
		if(T)
			for(var/obj/item/reagent_containers/glass/G in containers)
				G.forceMove(T)
				containers -= G
		return	1
	return 0

/obj/machinery/clonepod/proc/malfunction()
	if(occupant)
		connected_message("Critical Error!")
		mess = 1
		update_icon()
		occupant.ghostize()
		spawn(5)
			qdel(occupant)
	return

/obj/machinery/clonepod/relaymove(mob/user as mob)
	if(user.stat)
		return
	go_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100/severity))
		malfunction()
	..()

/obj/machinery/clonepod/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				legacy_ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					legacy_ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					legacy_ex_act(severity)
				qdel(src)
				return
		else
	return

/obj/machinery/clonepod/update_icon()
	..()
	icon_state = "pod_0"
	if(occupant && !(machine_stat & NOPOWER))
		icon_state = "pod_1"
	else if(mess)
		icon_state = "pod_g"


/obj/machinery/clonepod/full/Initialize(mapload, newdir)
	. = ..()
	for(var/i = 1 to container_limit)
		containers += new /obj/item/reagent_containers/glass/bottle/biomass(src)
