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
 * * set 'key' = list(stage data), where stage data is a key list with keys of FRAME_STAGE_DATA_* defines.
 * * you'll want to set FRAME_STAGE_DATA_STEPS to a list of list(step data); so a list of lists.
 * * each step will have FRAME_STEP_DATA_*
 * * please see examples.
 *
 * ### special things about the stage list
 * * if there are no stages, we immediately finish() with stage null with no context when someone tries to place the item/structure.
 *
 * only tool functions are allowed in steps_backward; items will generally not be checked.
 * this is intentional, though can be changed easily if there ever exists a good reason to.
 *
 */
/datum/frame2
	/// frame name
	var/name
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

#warn impl

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

	frame.update_icon()

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

/datum/frame2/proc/on_examine(obj/structure/frame2/frame, datum/event_args/actor/actor, list/examine_list)
	examine_list += instruction_steps(frame, actor)
	examine_list += instruction_special(frame, actor)

/**
 * @return string or list of strings
 */
/datum/frame2/proc/instruction_steps(obj/structure/frame2/frame, datum/event_args/actor/actor)
	#warn impl default

/**
 * @return list(string, ...)
 */
/datum/frame2/proc/instruction_special(obj/structure/frame2/frame, datum/event_args/actor/actor)
	return list()

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_item(obj/structure/frame2/frame, obj/item/item, datum/event_args/actor/clickchain/click)
	#warn impl

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_tool(obj/structure/frame2/frame, obj/item/tool, datum/event_args/actor/clickchain/click, function, flags, hint)
	#warn impl

/**
 * @return list
 */
/datum/frame2/proc/on_tool_query(obj/structure/frame2/frame, obj/item/tool, datum/event_args/actor/clickchain/click)
	#warn impl

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_interact(obj/structure/frame2/frame, datum/event_args/actor/clickchain/click)
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
 * includes obstruction_cycles
 *
 * regarding direction
 * * is in direction of machine that will be built if non-wall
 * * will be in the direction of the wall from the tile if wall
 *
 * @return TRUE / FALSE
 */
/datum/frame2/proc/deployment_checks(obj/item/frame2/frame, turf/location, dir, datum/event_args/actor/actor, silent)
	if(!wall_frame)
		#warn not wall frame; check non-blocking
	#warn wall frame..

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

#warn guh

/**
 * gets a list of managed overlays to apply to a frame
 */
/datum/frame2/proc/get_overlays(obj/structure/frame/frame)
	return list()
