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
 * ### special things in general
 * * wall frames should face away from the wall. most wall machinery face **away** from the wall.
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
	/// stage that a new construct starts at
	/// defaults to stages[1]
	var/stage_starting

	// todo: implement anchor shit.

	/// is this frame freely un/anchorable?
	var/freely_anchorable = FALSE
	/// do we need to be anchored to finish? we will not allow progression past last stage if so.
	var/requires_anchored_to_finish = TRUE
	/// requires anchored to do anything
	var/requires_anchored = TRUE
	/// starts anchored; null = [requires_anchored]
	var/starts_anchored
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
	/// does the wall frame.. require a wall? please put yes.
	var/wall_frame_requires_wall = TRUE
	/// default pixel x offset for wall-frames; positive if right, negative if left
	/// can set to list of "[NORTH]" = number, as well.
	var/wall_pixel_x = 16
	/// default pixel y offset for wall-frames; positive if up, negative if down
	/// can set to list of "[NORTH]" = number, as well.
	var/wall_pixel_y = 16

	/// are we climbable if we're dense?
	var/climb_allowed = TRUE
	/// climb delay
	var/climb_delay = 2 SECONDS

	/// our structure's depth, if not a wall mount
	var/depth_level = 16
	/// does our structure project depth?
	var/depth_projected = TRUE

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
		var/value = stages[key]
		if(istype(key, /datum/frame_stage))
			continue
		else if(istext(key))
			stages[key] = new value
	if(isnull(stage_starting) && length(stages))
		stage_starting = stages[1]

/datum/frame2/proc/apply_to_frame(obj/structure/frame2/frame)
	frame.set_density(has_density)
	frame.icon = icon
	frame.update_appearance()

	if(wall_frame)
		// wall frames face away from walls :/
		if(islist(wall_pixel_y))
			frame.set_base_pixel_x(wall_pixel_x["[frame.dir]"] || 0)
		else
			frame.set_base_pixel_x(frame.dir & EAST? -wall_pixel_x : (frame.dir & WEST? wall_pixel_x : 0))
		if(islist(wall_pixel_y))
			frame.set_base_pixel_y(wall_pixel_y["[frame.dir]"] || 0)
		else
			frame.set_base_pixel_y(frame.dir & NORTH? -wall_pixel_y : (frame.dir & SOUTH? wall_pixel_y : 0))
		frame.climb_allowed = FALSE
		frame.climb_delay = 0
		frame.depth_level = 0
		frame.depth_projected = FALSE
	else
		frame.climb_allowed = climb_allowed
		frame.climb_delay = climb_delay
		frame.depth_level = depth_level
		frame.depth_projected = depth_projected

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

/**
 * makes frame structure from item
 *
 * @return /obj/structure/frame, **if** we have stages. If not, we just finish it immediately.
 */
/datum/frame2/proc/deploy_frame(obj/item/frame2/frame_item, datum/event_args/actor/actor, atom/location, dir, destroy_item = TRUE)
	var/obj/structure/frame2/creating_frame = new(location, dir, src)
	creating_frame.set_anchored(isnull(starts_anchored)? requires_anchored : starts_anchored)

	if(destroy_item)
		qdel(frame_item)

	if(!length(stages))
		return // return nothing
	return creating_frame

/**
 * @params
 * * frame - the frame
 * * actor - the person doing it, if any
 * * put_in_hand_if_possible - put in user's hand instead of put it on the floor if possible
 * * override_slice_to_parts - if non null, TRUE = deconstruct(), FALSE = collapse to item
 *
 * @return frame item dropped, if any.
 */
/datum/frame2/proc/deconstruct_frame(obj/structure/frame2/frame, datum/event_args/actor/actor, put_in_hand_if_possible = TRUE, override_slice_to_parts)
	var/breaking_to_parts = isnull(override_slice_to_parts)? !deconstruct_into_item : override_slice_to_parts
	if(breaking_to_parts)
		frame.deconstruct(ATOM_DECONSTRUCT_DISASSEMBLED)
	else
		var/obj/item/frame2/collapsed
		if(actor?.performer && put_in_hand_if_possible)
			collapsed = new(actor.performer, src)
			actor.performer.put_in_hands_or_drop(collapsed)
		else
			collapsed = new(frame.drop_location(), src)
		return collapsed

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

	var/not_obliterating = FALSE
	switch(to_stage)
		if(FRAME_STAGE_DECONSTRUCT)
		if(FRAME_STAGE_FINISH)
		else
			if(isnull(stages[to_stage]))
				// check your fucking inputs
				CRASH("attempted to go to invalid stage!")
			if(from_stage == to_stage)
				// check your fucking inputs
				CRASH("attempted to move from the same state to the same state. why?")
			not_obliterating = TRUE

	frame.stage = to_stage
	on_frame_step(frame, from_stage, to_stage)

	if(not_obliterating)
		frame.update_appearance()

	log_construction(actor, frame, "mov [from_stage] -> [to_stage]")

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
		if(!potential_step.valid_interaction(actor, item, src, frame))
			continue
		step_to_take = potential_step
		break
	if(!step_to_take)
		return FALSE
	var/time_needed = step_to_take.time
	. = TRUE
	standard_progress_step(frame, actor, item, step_to_take, time_needed)

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_tool(obj/structure/frame2/frame, obj/item/tool, datum/event_args/actor/actor, function, flags, hint)
	var/datum/frame_step/step_to_take
	var/datum/frame_stage/current_stage = stages[frame.stage]
	for(var/datum/frame_step/potential_step as anything in current_stage.steps)
		if(!potential_step.valid_interaction(actor, tool, src, frame))
			continue
		if(hint && (potential_step.name != hint))
			continue
		step_to_take = potential_step
		break
	if(isnull(step_to_take))
		return FALSE
	// tool speed is handled by use_tool
	var/time_needed = step_to_take.time
	return standard_progress_step(frame, actor, tool, step_to_take, time_needed)

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
		if(!potential_step.valid_interaction(actor, null, src, frame))
			continue
		step_to_take = potential_step
		break
	if(isnull(step_to_take))
		return FALSE
	var/time_needed = step_to_take.time
	return standard_progress_step(frame, actor, null, step_to_take, time_needed)

/**
 * handles the do after, item manipulation, logging, and whatnot
 *
 * @return TRUE / FALSE
 */
/datum/frame2/proc/standard_progress_step(obj/structure/frame2/frame, datum/event_args/actor/actor, obj/item/using_item, datum/frame_step/frame_step, time_needed)
	var/stage_we_were_in = frame.stage
	if(frame_step.stage == FRAME_STAGE_FINISH && !frame.anchored && requires_anchored_to_finish)
		actor.chat_feedback(SPAN_WARNING("[frame] needs to be anchored to be finished."), frame)
		return FALSE
	if((isnull(frame_step.requires_anchored)? requires_anchored : frame_step.requires_anchored) && !frame.anchored)
		var/rendered = frame_step.action_descriptor || "<[frame_step.name]>"
		actor.chat_feedback(SPAN_WARNING("[frame] needs to be anchored in order for you to [rendered]."), frame)
		return FALSE
	if(!frame_step.check_consumption(actor, using_item, src, frame))
		return FALSE
	if(frame_step.stage == FRAME_STAGE_FINISH)
		if(!completion_checks(frame, frame.loc, frame.dir, actor))
			return FALSE
	frame_step.feedback_begin(
		actor,
		src,
		frame,
		using_item,
		time_needed,
	)
	if(!frame_step.perform_usage(actor, using_item, src, frame, time_needed))
		return FALSE
	if(frame.stage != stage_we_were_in)
		return FALSE
	if(!frame_step.handle_consumption(actor, using_item, src, frame))
		return FALSE
	if(frame_step.stage == FRAME_STAGE_FINISH)
		if(!completion_checks(frame, frame.loc, frame.dir, actor))
			return FALSE
	frame_step.feedback_finish(
		actor,
		src,
		frame,
		using_item,
		time_needed,
	)
	frame_step.on_finish(src, frame, actor, using_item)
	move_frame_to(frame, stage_we_were_in, frame_step.stage, actor)
	return TRUE

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
	if(wall_frame && wall_frame_requires_wall)
		var/turf/checking = get_step(location, turn(dir, 180))
		if(!checking.get_wallmount_anchor())
			actor.chat_feedback(
				SPAN_WARNING("[checking] isn't a valid anchor for this wall mount!"),
				target = frame,
			)
			return FALSE
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
	return valid_location(frame, location, dir, actor, silent)

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
