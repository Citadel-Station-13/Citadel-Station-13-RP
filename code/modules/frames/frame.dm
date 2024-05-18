//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(frame_datum_lookup, init_frame_datums())

/proc/init_frame_datums()
	var/list/constructed = list()
	for(var/datum/frame2/frame_path as anything in subtypesof(/datum/frame2))
		if(initial(frame_path.abstract_type) == frame_path)
			continue
		var/datum/frame2/made = new frame_path
		constructed[frame_path] = made
	return constructed

/proc/fetch_frame_datum(datum/frame2/framelike)
	if(istype(framelike))
	else
		framelike = GLOB.frame_datum_lookup[framelike]
	return framelike

/**
 * arbitrary construction framework
 *
 * ### how state machines work here
 *
 * frames operate off two principles, and are effectively a state machine:
 * * stage - *usually* linear, 1 to n. stepping back from 1 deconstructs the frame. stepping forwards from n finishes the frame.
 * * context - arbitrary data storage list
 *
 * ### how construction/deconstruction stage lists works:
 *
 * * set 'key' = /datum/frame_stage typepath
 * * you'll probably want anonymous types.
 * * please see examples.
 *
 * ### special things about the stage list
 * * if there are no stages, we immediately finish() with stage null with no context when someone tries to place the item/structure.
 *
 * todo: no support for multiple 'interact' stages yet
 * todo: /datum/frame_context so it can hold entities / data inside (e.g. can drop stuff if needed)
 * todo: similarly, we need a way to store items inserted as part of a step, maybe as a part of context? so it can be dropped later.
 */
/datum/frame2
	/// frame name
	var/name = "construction frame"
	/// sheet metal cost
	var/material_cost = 1
	//  todo: non-steel support
	/// for future use: set to TRUE to allow all materials
	var/material_unlocked = FALSE
	/// can we be built?
	var/material_buildable = TRUE

	/// deconstructs into item frame, or materials?
	var/deconstruct_into_item = TRUE
	/// deconstruct: **if and only if** steps_backwards does not specify a first step,
	/// default to this tool
	var/deconstruct_default_tool = TOOL_WRENCH
	/// default deconstruction time
	var/deconstruct_default_time = 3 SECONDS
	/// default deconstruction cost multiplier
	var/deconstruct_default_cost = 1

	/// construction stages
	/// see /datum/frame2 readme (so up above in this file) for how to do this
	var/list/stages = list()

	// todo: implement anchor shit.T

	/// is this frame freely un/anchorable?
	var/freely_anchorable = FALSE
	/// do we need to be anchored to finish? we will not allow progression past last stage if so.
	var/requires_anchored_to_finish = TRUE
	/// anchoring time
	var/anchor_time = 2 SECONDS
	/// anchoring tool
	var/anchor_tool = TOOL_WRENCH

	/// are we a dense frame object? if it's a wall mount, the answer should probably be no.
	var/has_density = FALSE

	/// check for all dense objects on turf if we're dense
	var/check_turf_content_density_dynamic = TRUE
	/// still check for any density
	var/check_turf_content_density_always = TRUE
	/// check for another frame of this type on turf
	var/check_turf_frame_duplicate = TRUE
	/// check for another frame of this class on turf
	/// * wallframes in same direction
	/// * other non-wall-frames
	var/check_turf_frame_collision = TRUE

	/// is this frame a wall-frame?
	var/wall_frame = FALSE
	/// default pixel x offset for wall-frames; positive if right, negative if left
	/// can set to list of "[NORTH]" = number, as well.
	var/wall_pixel_x = 16
	/// default pixel y offset for wall-frames; positive if up, negative if down
	/// can set to list of "[NORTH]" = number, as well.
	var/wall_pixel_y = 16

	/// our icon
	var/icon
	/// do we append -stage to structure?
	/// structure preview state will always be "structure"
	var/has_structure_stage_states = FALSE
	/// do we append -stage to items?
	/// item preview state will always be "item"
	//  todo: currently unused given lack of support for storing state
	//  todo: in the future, we will want this. for now, everything is just 'item'.
	var/has_item_stage_states = FALSE

	/// weight class of item
	var/item_weight_class = WEIGHT_CLASS_NORMAL
	/// weight volume of item
	var/item_weight_volume = WEIGHT_VOLUME_NORMAL
	/// what tool, if any to deconstruct item into materials
	var/item_recycle_tool
	/// time to decon for tool as item
	var/item_recycle_time = 0 SECONDS
	/// cost mult to decon for tool as item
	var/item_recycle_cost = 1
	/// what tool, if any, to attempt to set us up in a location
	var/item_deploy_tool = TOOL_WRENCH
	/// is tool required for deployment?
	var/item_deploy_requires_tool = FALSE
	/// deployment time
	var/item_deploy_time = 0 SECONDS
	/// deployment tool cost multiplier
	var/item_deploy_cost = 1

/datum/frame2/New()
	for(var/i in 1 to length(stages))
		var/key = stages[i]
		var/value = stages[i]
		if(istype(key, /datum/frame_stage))
			continue
		else if(istext(key))
			stages[key] = new value

/datum/frame2/proc/apply_to_frame(obj/structure/frame2/frame)
	frame.density = has_density
	frame.update_icon()

/**
 * @return finished product
 */
/datum/frame2/proc/finish_frame(obj/structure/frame2/frame, datum/event_args/actor/actor, destroy_structure = TRUE)
	ASSERT(isturf(frame.loc))
	. = instance_product(frame)
	if(destroy_structure)
		qdel(frame)

/**
 * todo: /instance_from_frame()? we certainly can't have this be on /Initialize level at /obj, which sucks.. oh well.
 *
 * @return finished product
 */
/datum/frame2/proc/instance_product(obj/structure/frame2/frame)
	CRASH("abstract proc called.")

/datum/frame2/proc/deconstruct_frame(obj/structure/frame2/frame, datum/event_args/actor/actor, put_in_hand_if_possible = TRUE)
	#warn impl

/**
 * @params
 * * method - ATOM_DECONSTRUCT_* define
 * * where - atom to drop stuff at
 * * stage_key - stage id
 * * context - context list
 */
/datum/frame2/proc/drop_deconstructed_products(method, atom/where, stage_key, list/context)
	// todo: drop all other stored things from steps!!
	new /obj/item/stack/material/steel(where, material_cost)

/**
 * always use this proc, it's guarded against race conditions.
 *
 * If trying to deconstruct or finish the frame, you *must* do:
 * * FRAME_STAGE_DECONSTRUCT
 * * FRAME_STAGE_FINISH
 *
 * @params
 * * frame - the frame being operated on
 * * from_stage - move from this stage; if current stage key doesn't match expected, we abort as it might be a race condition.
 * * to_stage - move to this stage
 * * actor - actor data
 *
 * @return TRUE / FALSE success / fail
 */
/datum/frame2/proc/move_frame_to(obj/structure/frame2/frame, from_stage, to_stage, datum/event_args/actor/actor)
	if(frame.stage != from_stage)
		return FALSE
	if(isnull(stages[to_stage]))
		// check your fucking inputs
		CRASH("attempted to go to invalid stage!")
	if(from_stage == to_stage)
		// check your fucking inputs
		CRASH("attempted to move from the same state to the same state. why?")

	frame.stage = to_stage

	on_frame_step(frame, from_stage, to_stage)

	frame.update_appearance()

	switch(to_stage)
		if(FRAME_STAGE_DECONSTRUCT)
			deconstruct_frame(frame, actor)
		if(FRAME_STAGE_FINISH)
			finish_frame(frame, actor)

/**
 * Called when we transition stage.
 * * called before update_icon() / re-renders
 * * called before deconstruction/finish
 */
/datum/frame2/proc/on_frame_step(obj/structure/frame2/frame, from_stage, to_stage)
	return

/datum/frame2/proc/on_examine(obj/structure/frame2/frame, datum/event_args/actor/actor, list/examine_list, distance)
	var/datum/frame_stage/stage = stages[frame.stage]
	examine_list += stage.on_examine(frame, actor, examine_list, distance)
	examine_list += instruction_steps(frame, actor, distance)
	examine_list += instruction_special(frame, actor, distance)

/**
 * @return string or list of strings
 */
/datum/frame2/proc/instruction_steps(obj/structure/frame2/frame, datum/event_args/actor/actor, distance)
	var/datum/frame_stage/stage = stages[frame.stage]
	if(isnull(stage))
		return list()
	var/list/datum/frame_step/steps = stage.steps
	if(!length(steps))
		return list()
	. = list()
	for(var/datum/frame_step/step as anything in steps)
		. += step.examine(frame, actor)

/**
 * @return list(string, ...)
 */
/datum/frame2/proc/instruction_special(obj/structure/frame2/frame, datum/event_args/actor/actor, distance)
	return list()

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_item(obj/structure/frame2/frame, obj/item/item, datum/event_args/actor/actor)
	// todo: support for multiple possible steps
	var/datum/frame_step/step_to_take
	var/datum/frame_stage/current_stage = stages[frame.stage]
	for(var/datum/frame_step/potential_step as anything in current_stage.steps)
		if(potential_step.request_type != FRAME_REQUEST_TYPE_ITEM)
			continue
		if(potential_step.request != item.type)
			continue
		step_to_take = potential_step
	return standard_progress_step(frame, actor, item, step_to_take)

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_tool(obj/structure/frame2/frame, obj/item/tool, datum/event_args/actor/actor, function, flags, hint)
	var/datum/frame_step/step_to_take
	var/datum/frame_stage/current_stage = stages[frame.stage]
	for(var/datum/frame_step/potential_step as anything in current_stage.steps)
		if(potential_step.request_type != FRAME_REQUEST_TYPE_TOOL)
			continue
		if(potential_step.request != function)
			continue
		if(hint && (potential_step.name != hint))
			continue
		step_to_take = potential_step
	return standard_progress_step(frame, actor, tool, step_to_take)

/**
 * @return list
 */
/datum/frame2/proc/on_tool_query(obj/structure/frame2/frame, obj/item/tool, datum/event_args/actor/clickchain/click)
	. = list()
	var/datum/frame_stage/stage = stages[frame.stage]
	for(var/datum/frame_step/step as anything in stage.steps)
		if(step.request_type != FRAME_REQUEST_TYPE_TOOL)
			continue
		if(isnull(.[step.request]))
			.[step.request] = list()
		.[step.request][step.name || "yell at coders"] = step.tool_image()

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_interact(obj/structure/frame2/frame, datum/event_args/actor/actor)
	// todo: support for multiple possible steps
	var/datum/frame_step/step_to_take
	var/datum/frame_stage/current_stage = stages[frame.stage]
	for(var/datum/frame_step/potential_step as anything in current_stage.steps)
		if(potential_step.request_type != FRAME_REQUEST_TYPE_INTERACT)
			continue
		step_to_take = potential_step
	return standard_progress_step(frame, actor, null, step_to_take)

/**
 * handles the do after, logging, and whatnot
 *
 * @return TRUE / FALSE
 */
/datum/frame2/proc/standard_progress_step(obj/structure/frame2/frame, datum/event_args/actor/actor, obj/item/using_item, datum/frame_step/frame_step)
	#warn impl

/**
 * @return finished product if finished
 */
/datum/frame2/proc/try_finish_frame(obj/structure/frame2/frame, datum/event_args/actor/actor, destroy_structure = TRUE)
	ASSERT(isturf(frame.loc))
	if(!completion_checks(frame, frame.loc, frame.dir, actor))
		return
	return finish_frame(frame, destroy_structure)

/**
 * ran only on deployment, not completion
 * * also ran when anchoring a frame down
 *
 * regarding direction
 * * is in direction of machine that will be built if non-wall
 * * will be in the direction of the wall from the tile if wall
 *
 * @return TRUE / FALSE
 */
/datum/frame2/proc/deployment_checks(obj/item/frame2/frame, turf/location, dir, datum/event_args/actor/actor, silent)
	if((check_turf_content_density_dynamic && has_density) || check_turf_content_density_always)
		for(var/obj/thing in location)
			if(thing.density)
				return FALSE
	if(check_turf_frame_collision || check_turf_frame_duplicate)
		for(var/obj/structure/frame2/other_frame in location)
			if(other_frame.frame == src && check_turf_frame_duplicate)
				return FALSE
			if(!other_frame.frame.wall_frame)
				if(!wall_frame)
					return FALSE
			else
				if(other_frame.dir == frame.dir)
					return FALSE
	return TRUE

/**
 * ran on deployment as well as completion
 *
 * @return FALSE if obstructed
 */
/datum/frame2/proc/completion_checks(obj/structure/frame2/frame, turf/location, dir, datum/event_args/actor/actor, silent)
	return valid_location(location, dir, actor, silent)

/**
 * checks if we semantically should even be able to be built here at all;
 * ran during both deployment and completion
 *
 * used for stuff like APCs rejecting areas that shouldn't be powerable/etc
 *
 * @params
 * * entity - either the item or structure frame. this is generic, and is only really used for chat feedback object name purposes.
 * * location - where it's being built/placed
 * * dir - direction that it's being built/placed in
 * * actor - (optional) person doing it
 * * silent - don't emit chat feedback
 */
/datum/frame2/proc/valid_location(obj/entity, turf/location, dir, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * gets a list of managed overlays to apply to a frame
 */
/datum/frame2/proc/get_overlays(obj/structure/frame/frame)
	return list()

/**
 * template action text
 */
/datum/frame2/proc/template_action_string(list/tokens, mob/performer, obj/structure/frame2/frame, obj/item/tool)
	if(isnull(tokens))
		return // null = null
	// i wish this was typescript so i could just return tokens.map((t) => ...) :confounded:
	// pov i'm losing my mcfucking mind
	. = tokens.Copy()
	for(var/i in 1 to length(.))
		switch(.[i])
			if(FRAME_TEXT_TOKEN_PERFORMER)
				.[i] = "[performer]"
			if(FRAME_TEXT_TOKEN_FRAME)
				.[i] = "[frame]"
			if(FRAME_TEXT_TOKEN_TOOL)
				.[i] = "[tool]"
			if(FRAME_TEXT_TOKEN_THEIR)
				.[i] = "[performer.p_their()]"
			if(FRAME_TEXT_TOKEN_THEM)
				.[i] = "[performer.p_them()]"
			if(FRAME_TEXT_TOKEN_THEYRE)
				.[i] = "[performer.p_theyre()]"
	return jointext(., "")
