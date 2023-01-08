/* SURGERY STEPS */

/obj/
	var/surgery_odds = 0 // Used for tables/etc which can have surgery done of them.

/datum/surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	var/req_open = 1	//1 means the part must be cut open, 0 means it doesn't

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null

	// List of procs that can be called if allowed_tools fails
	var/list/allowed_procs = null

	// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = null

	// duration of the step
	var/min_duration = 0
	var/max_duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

//returns how well tool is suited for this step
/datum/surgery_step/proc/tool_quality(obj/item/tool)
	for (var/T in allowed_tools)
		if (istype(tool,T))
			return allowed_tools[T]

	for(var/P in allowed_procs)
		switch(P)
			if(IS_SCREWDRIVER)
				if(tool.is_screwdriver())
					return allowed_procs[P]
			if(IS_CROWBAR)
				if(tool.is_crowbar())
					return allowed_procs[P]
			if(IS_WIRECUTTER)
				if(tool.is_wirecutter())
					return allowed_procs[P]
			if(IS_WRENCH)
				if(tool.is_wrench())
					return allowed_procs[P]
	return 0


// Checks if this step applies to the user mob at all
/datum/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if(!hasorgans(target))
		return 0

	if(allowed_species)
		for(var/species in allowed_species)
			if(target.species.get_bodytype_legacy() == species)
				return 1

	if(disallowed_species)
		for(var/species in disallowed_species)
			if(target.species.get_bodytype_legacy() == species)
				return 0

	return 1


// checks whether this step can be applied with the given user and target
/datum/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return 0

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/datum/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (can_infect && affected)
		spread_germs_to_organ(affected, user)
	if (ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if (blood_level)
			H.bloody_hands(target,0)
		if (blood_level > 1)
			H.bloody_body(target,0)
	return

// does stuff to end the step, which is normally print a message + do whatever this step changes
/datum/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/datum/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null

/proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/*
//! no clue what this is for it always returned 0 so removed
/obj/item/proc/can_do_surgery(mob/living/carbon/M, mob/living/user)
	if(M == user)
		return 0
	if(!ishuman(M))
		return 1
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
	if(affected)
		for(var/datum/surgery_step/S in GLOB.surgery_steps)
			if(!affected.open && S.req_open)
				return 0
	return 0
*/

/obj/item/proc/do_surgery(mob/living/carbon/M, mob/living/user)
	if(!istype(M))
		return FALSE
	if (user.a_intent == INTENT_HARM)
		return FALSE
	var/zone = user.zone_sel.selecting
	if(zone in M.op_stage.in_progress) //Can't operate on someone repeatedly.
		to_chat(user, "<span class='warning'>You can't operate on this area while surgery is already in progress.</span>")
		return TRUE
	. = FALSE
	for(var/datum/surgery_step/S in GLOB.surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(src))
			var/step_is_valid = S.can_use(user, M, zone, src)
			if(step_is_valid && S.is_valid_target(M))
				if(step_is_valid == SURGERY_FAILURE) // This is a failure that already has a message for failing.
					return TRUE
				M.op_stage.in_progress += zone
				S.begin_step(user, M, zone, src)		//start on it
				var/success = TRUE

				// Bad tools make it less likely to succeed.
				if(!prob(S.tool_quality(src)))
					success = FALSE

				// Bad or no surface may mean failure as well.
				var/obj/surface = M.get_surgery_surface()
				if(!surface || !prob(surface.surgery_odds))
					success = FALSE

				// Not staying still fails you too.
				if(success)
					var/calc_duration = rand(S.min_duration, S.max_duration)
					if(!do_mob(user, M, calc_duration * tool_speed, zone))
						success = FALSE
						to_chat(user, "<span class='warning'>You must remain close to and keep focused on your patient to conduct surgery.</span>")

				if(success)
					S.end_step(user, M, zone, src)
				else
					S.fail_step(user, M, zone, src)

				M.op_stage.in_progress -= zone 									// Clear the in-progress flag.
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					H.update_surgery()
				return TRUE	  												//don't want to do weapony things after surgery

/proc/initialize_surgeries()
	. = list()
	for(var/path in subtypesof(/datum/surgery_step))
		. += new path
	tim_sort(., cmp = /proc/cmp_surgery_priority_asc)

/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/brainstem = 0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/list/in_progress = list()
