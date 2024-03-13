//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(frame_datums, init_frame_datums())

/proc/init_frame_datums()

#warn global list

/**
 * arbitrary construction framework
 *
 * ### how state machines work here
 *
 * frames operate off two principles, and are effectively a state machine:
 * * stage - *usually* linear, 1 to n. stepping back from 1 deconstructs the frame. stepping forwards from n finishes the frame.
 * * context - arbitrary data storage list
 *
 * ### how construction/deconstruction step lists (steps_forward, steps_backward) works:
 *
 * * they must be the same length
 * * their length is the number of stages
 * * if the length is 0, we immediately finish() with stage 0 and no context when someone tries to place the item/structure.
 * * when deconstructing, the input item in the given construction step will be refunded.
 *
 * ### allowed / understood / recognized steps in list:
 *
 * * /obj/item/stack typepath associated to amount; requires that much of that stack in one go to go to next phase
 * * /datum/material typepath associated to amount; requires that much of that material in one go to go to next phase
 * * /obj/item typepath associated to amount; requires that much of that item inserted to go to next phase
 * * tool function associated to number as time, or a list(time, cost); requires that tool to be used
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

	/// construction steps
	/// see /datum/frame2 readme (so up above in this file) for how to do this
	var/list/steps_forward
	/// deconstruction steps
	/// see /datum/frame2 readme (so up above in this file) for how to do this
	/// this list *can* be set to null if we don't want people going backwards.
	var/list/steps_backward

	/// is this frame freely un/anchorable?
	var/freely_anchorable = FALSE
	/// do we need to be anchored to finish? we will not allow progression past last stage if so.
	var/requires_anchored_to_finish = TRUE
	/// anchoring time
	var/anchor_time = 2 SECONDS
	/// anchoring tool
	var/anchor_tool = TOOL_WRENCH

	/// is this frame a wall-frame?
	var/wall_frame = FALSE
	/// default pixel x offset for wall-frames; positive if right, negative if left
	/// can set to list of "[NORTH]" = number, as well.
	var/wall_pixel_x = 16
	/// default pixel y offset for wall-frames; positive if up, negative if down
	/// can set to list of "[NORTH]" = number, as well.
	var/wall_pixel_y = 16

	/// do we append -stage to structure?
	/// structure preview state will always be "structure"
	var/has_structure_stage_states = TRUE
	/// do we append -stage to items?
	/// item preview state will always be "item"
	var/has_item_stage_states = FALSE

	/// weight class of item
	var/item_weight_class = WEIGHT_CLASS_NORMAL
	/// weight volume of item
	var/item_weight_volume = WEIGHT_VOLUME_NORMAL

#warn impl

/**
 * @return finished product
 */
/datum/frame2/proc/finish_frame(obj/structure/frame/frame)

/datum/frame2/proc/move_frame_forwards(obj/structure/frame/frame, from_stage)

/datum/frame2/proc/move_frame_backwards(obj/structure/frame/frame, from_stage)

/datum/frame2/proc/move_frame_to(obj/structure/frame/frame, from_stage, to_stage)

/datum/frame2/proc/on_examine(obj/structure/frame/frame, list/examine_list)

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_item(obj/structure/frame/frame, obj/item/item, datum/event_args/actor/actor)

/**
 * @return TRUE if handled
 */
/datum/frame2/proc/on_tool(obj/structure/frame/frame, obj/item/tool, datum/event_args/actor/actor, function)

/**
 * regarding direction
 * * is in direction of machine that will be built if non-wall
 * * will be in the direction of the wall from the tile if wall
 *
 * @return TRUE / FALSE
 */
/datum/frame2/proc/allow_placement(turf/location, dir, datum/event_args/actor/actor, silent)
	if(!wall_frame)
		#warn not wall frame; check non-blocking
	#warn wall frame..

#warn guh

/**
 * requires a specific circuitboard, or just doesn't require one at all
 */
/datum/frame2/preloaded
