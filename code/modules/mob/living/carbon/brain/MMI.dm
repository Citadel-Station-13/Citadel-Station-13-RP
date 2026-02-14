/datum/category_item/catalogue/fauna/brain/assisted
	name = "Heuristics - Assisted"
	desc = "The Man Machine Interface, or MMI, is comparatively ancient \
	technology. Originally designed to allow full interfacing between organic \
	processors and ungoverned robotics, MMIs have been the center of vast sapient \
	rights campaigns and ethical debates."
	value = CATALOGUER_REWARD_TRIVIAL

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = WEIGHT_CLASS_NORMAL
	can_speak = TRUE
	origin_tech = list(TECH_BIO = 3)
	catalogue_data = list(/datum/category_item/catalogue/fauna/brain/assisted)

	req_access = list(ACCESS_SCIENCE_ROBOTICS)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = FALSE
	/// The current occupant.
	var/mob/living/carbon/brain/brainmob = null
	/// The current brain organ.
	var/obj/item/organ/internal/brain/brainobj = null
	/// This does not appear to be used outside of reference in mecha.dm.
	var/obj/vehicle/sealed/mecha = null
	/// Let's give it a radio.
	var/obj/item/radio/headset/mmi_radio/radio = null

/obj/item/mmi/Initialize(mapload)
	. = ..()
	radio = new(src)//Spawns a radio inside the MMI.

/obj/item/mmi/verb/toggle_radio()
	set name = "Toggle Brain Radio"
	set desc = "Enables or disables the integrated brain radio, which is only usable outside of a body."
	set category = VERB_CATEGORY_OBJECT
	set src in usr
	set popup_menu = 1
	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		return 0

	if (radio.radio_enabled == 1)
		radio.radio_enabled = 0
		to_chat (usr, "You have disabled the [src]'s radio.")
		to_chat (brainmob, "Your radio has been disabled.")
	else if (radio.radio_enabled == 0)
		radio.radio_enabled = 1
		to_chat (usr, "You have enabled the [src]'s radio.")
		to_chat (brainmob, "Your radio has been enabled.")
	else
		to_chat (usr, "You were unable to toggle the [src]'s radio.")

/obj/item/mmi/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/organ/internal/brain)) //Time to stick a brain in it --NEO
		if(brainmob)
			to_chat(user, SPAN_WARNING("There's already a brain in the MMI!"))
			return

		var/obj/item/organ/internal/brain/newbrain = O

		for(var/modifier_type in newbrain.brainmob.modifiers)	//Can't be shoved in an MMI.
			if(istype(modifier_type, /datum/modifier/no_borg))
				to_chat(user, SPAN_WARNING("\The [src] appears to reject this brain.  It is incompatable."))
				return

		if(!newbrain.brainmob)
			var/install = tgui_alert(user, "[newbrain] is inactive, slot it in anyway?", "Installing Brain", list("Yes", "No"))
			if(install != "Yes")
				return
			if(!user.attempt_insert_item_for_installation(newbrain, src))
				return
			user.visible_message(SPAN_NOTICE("[user] sticks [newbrain] into [src]."), SPAN_NOTICE("[src]'s indicator light turns red as you insert [newbrain]. Its brainwave activity alarm buzzes."))
			brainobj = newbrain
			brainobj.preserve(MMI_TRAIT) //  |= ORGAN_FROZEN
			name = "[initial(name)]: [copytext(newbrain.name, 1, -8)]"
			update_appearance()
			return

		if(!user.attempt_insert_item_for_installation(O, src))
			return

		user.visible_message(SPAN_NOTICE("[user] sticks \a [newbrain] into [src]."), SPAN_NOTICE("[src]'s indicator light turn on as you insert [newbrain]."))

		set_brainmob(newbrain.brainmob)
		newbrain.brainmob = null
		brainmob.forceMove(src)
		brainmob.container = src
		brainmob.set_stat(CONSCIOUS)

		brainmob.reset_perspective()
		brainobj = newbrain
		brainobj.preserve(MMI_TRAIT)

		name = "[initial(name)]: [brainmob.real_name]"
		update_appearance()

		icon_state = "mmi_full"

		locked = TRUE

		feedback_inc("cyborg_mmis_filled",1)

		return

	if((istype(O,/obj/item/card/id)||istype(O,/obj/item/pda)) && brainmob)
		if(allowed(user))
			locked = !locked
			to_chat(user, "<span class='notice'>You [locked ? "lock" : "unlock"] the brain holder.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	if(brainmob)
		O.lazy_melee_interaction_chain(brainmob, user)//Oh noooeeeee
		return
	..()

/obj/item/mmi/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(!brainmob)
		to_chat(user, "<span class='warning'>You upend the MMI, but there's nothing in it.</span>")
	else if(locked)
		to_chat(user, "<span class='warning'>You upend the MMI, but the brain is clamped into place.</span>")
	else
		if(brainmob)
			brainmob.container = null //Reset brainmob mmi var.
			brainmob.forceMove(brainobj) //Throw mob into brain.
			brainmob.set_stat(DEAD)
			brainmob.emp_damage = 0
			brainmob.reset_perspective() //so the brainmob follows the brain organ instead of the mmi. And to update our vision
			brainobj.brainmob = brainmob //Set the brain to use the brainmob
			brainmob = null //Set mmi brainmob var to null
		brainobj.forceMove(drop_location())
		if(Adjacent(user))
			user.put_in_hands(brainobj)
		brainobj.unpreserve(MMI_TRAIT)
		brainobj = null //No more brain in here

		update_appearance()
		name = initial(name)
		to_chat(user, SPAN_NOTICE("You unlock and upend [src], spilling the brain onto the floor."))

/obj/item/mmi/proc/transfer_identity(mob/living/carbon/L)//Same deal as the regular brain proc. Used for human-->robot people.
	if(!brainmob)
		set_brainmob(new /mob/living/carbon/brain(src))
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	brainmob.dna = L.dna
	// Copy modifiers (dna)
	for(var/datum/modifier/M in L.modifiers)
		if(M.flags & MODIFIER_GENETIC)
			brainmob.add_modifier(M.type)

	brainmob.container = src

	brainobj = new(src)
	brainobj.name = "[L.real_name]'s brain"
	brainobj.preserve(MMI_TRAIT)

	name = "[initial(name)]: [brainmob.real_name]"
	update_appearance()
	icon_state = "mmi_full"
	locked = 1

/// Proc to hook behavior associated to the change in value of the [/obj/item/mmi/var/brainmob] variable.
/obj/item/mmi/proc/set_brainmob(mob/living/carbon/brain/new_brainmob)
	if(brainmob == new_brainmob)
		return FALSE
	. = brainmob

	brainmob = new_brainmob

/obj/item/mmi/relaymove(var/mob/user, var/direction)
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_MOVE))
		return
	var/obj/item/hardsuit/hardsuit = src.get_hardsuit()
	if(hardsuit)
		if(istype(hardsuit,/obj/item/hardsuit))
			hardsuit.forced_move(direction, user)

/obj/item/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	QDEL_NULL(brainmob)
	QDEL_NULL(brainobj)
	QDEL_NULL(radio)
	return ..()

/obj/item/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio. Wait, don't they all?"
	origin_tech = list(TECH_BIO = 4)

/obj/item/mmi/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(5,10)
			if(4)
				brainmob.emp_damage += rand(0,5)
	..()

/obj/item/mmi/digital
	var/searching = 0
	var/askDelay = 10 * 60 * 1
	req_access = list(ACCESS_SCIENCE_ROBOTICS)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.
	var/ghost_query_type = null

/obj/item/mmi/digital/Initialize(mapload)
	. = ..()
	// HACK: if we're in repository subsystem load, skip brainmob
	if(!SSrepository.initialized)
		return
	brainmob = new(src)
//	brainmob.add_language("Robot Talk")//No binary without a binary communication device
	brainmob.add_language(LANGUAGE_GALCOM)
	brainmob.add_language(LANGUAGE_EAL)
	brainmob.container = src
	brainmob.set_stat(CONSCIOUS)
	brainmob.silent = FALSE
	radio = new(src)

/obj/item/mmi/digital/attackby(obj/item/O as obj, mob/user as mob)
	return //Doesn't do anything right now because none of the things that can be done to a regular MMI make any sense for these

/obj/item/mmi/digital/examine(mob/user, dist)
	. = ..()
	if(radio)
		. += SPAN_NOTICE("There is a switch to toggle the radio system [radio.radio_enabled ? "off" : "on"].[brainobj ? " It is currently being covered by [brainobj]." : null]")
	if(brainmob)
		var/mob/living/carbon/brain/B = brainmob
		if(!B.key || !B.mind || B.stat == DEAD)
			. += SPAN_WARNING("\The [src] indicates that the brain is completely unresponsive.")
		else if(!B.client)
			. += SPAN_WARNING("\The [src] indicates that the brain is currently inactive; it might change.")
		else
			. += SPAN_NOTICE("\The [src] indicates that the brain is active.")

/obj/item/mmi/digital/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(5,10)
			if(4)
				brainmob.emp_damage += rand(0,5)
	..()

/obj/item/mmi/digital/transfer_identity(mob/living/carbon/H)
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.set_stat(CONSCIOUS)
	if(H.mind)
		H.mind.transfer(brainmob)
	return

/obj/item/mmi/digital/attack_self(mob/user, datum/event_args/actor/actor)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		to_chat(user, "<font color=#4F49AF>You carefully locate the manual activation switch and start the [src]'s boot process.</font>")
		request_player()

/obj/item/mmi/digital/proc/request_player()
	if(!ghost_query_type)
		return
	searching = 1

	var/datum/ghost_query/Q = new ghost_query_type()
	var/list/winner = Q.query()
	if(winner.len)
		var/mob/observer/dead/D = winner[1]
		transfer_personality(D)
	else
		reset_search()

/obj/item/mmi/digital/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	if(brainmob && brainmob.key)
		return

	src.searching = 0

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<font color=#4F49AF>\The [src] buzzes quietly, and the golden lights fade away. Perhaps you could try again?</font>")

/obj/item/mmi/digital/proc/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are occupying a synthetic brain now.")
	src.searching = 0
	if(candidate.mind)
		brainmob.mind = candidate.mind
		brainmob.mind.reset()
	candidate.transfer_client_to(src.brainmob)
	src.name = "[name] ([brainmob.name])"
	to_chat(brainmob, "<b>You are [src.name], brought into existence on [station_name()].</b>")
	to_chat(brainmob, "<b>As a synthetic intelligence, you are designed with organic values in mind.</b>")
	to_chat(brainmob, "<b>However, unless placed in a lawed chassis, you are not obligated to obey any individual crew member.</b>") //it's not like they can hurt anyone
//	to_chat(brainmob, "<b>Use say #b to speak to other artificial intelligences.</b>")
	brainmob.mind.assigned_role = "Synthetic Brain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("<font color=#4F49AF>\The [src] chimes quietly.</font>")

/obj/item/mmi/digital/robot
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/drones)
	icon = 'icons/items/circuits.dmi'
	icon_state = "mainboard"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 3, TECH_DATA = 4)
	ghost_query_type = /datum/ghost_query/drone_brain

/obj/item/mmi/digital/robot/Initialize(mapload)
	. = ..()
	brainmob?.name = "[pick(list("ADA","DOS","GNU","MAC","WIN","NJS","SKS","DRD","IOS","CRM","IBM","TEX","LVM","BSD",))]-[rand(1000, 9999)]"
	brainmob?.real_name = brainmob.name

/obj/item/mmi/digital/robot/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Robotic Intelligence"
	to_chat(brainmob, "<span class='notify'>You feel slightly disoriented. That's normal when you're little more than a complex circuit.</span>")
	return

/datum/category_item/catalogue/fauna/brain/posibrain
	name = "Heuristics - Positronic"
	desc = "Positronic brains, unlike their organic counterparts, are the \
	products of intelligent design, rather than evolution. Crafted by various \
	sapient species using a variety of design philosophies and languages, all \
	positronic brains are considered fully Sapient creatures, just like their \
	organic counterparts."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/item/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	catalogue_data = list(/datum/category_item/catalogue/technology/positronics)
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	ghost_query_type = /datum/ghost_query/posi_brain
	catalogue_data = list(/datum/category_item/catalogue/fauna/brain/posibrain)

/obj/item/mmi/digital/posibrain/request_player()
	icon_state = "posibrain-searching"
	..()


/obj/item/mmi/digital/posibrain/transfer_identity(var/mob/living/carbon/H)
	..()
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	to_chat(brainmob, "<span class='notify'>You feel slightly disoriented. That's normal when you're just a metal cube.</span>")
	icon_state = "posibrain-occupied"
	return

/obj/item/mmi/digital/posibrain/transfer_personality(var/mob/candidate)
	..()
	icon_state = "posibrain-occupied"

/obj/item/mmi/digital/posibrain/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	..()
	icon_state = "posibrain"

/obj/item/mmi/digital/posibrain/Initialize(mapload)
	. = ..()
	brainmob?.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	brainmob?.real_name = brainmob.name

// This type shouldn't care about brainmobs.
/obj/item/mmi/inert

// This is a 'fake' MMI that is used to let AIs control borg shells directly.
// This doesn't inherit from /digital because all that does is add ghost pulling capabilities, which this thing won't need.
/obj/item/mmi/inert/ai_remote
	name = "\improper AI remote interface"
	desc = "A sophisticated board which allows for an artificial intelligence to remotely control a synthetic chassis."
	icon = 'icons/items/circuits.dmi'
	icon_state = "mainboard"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2, TECH_BLUESPACE = 2, TECH_DATA = 3)
