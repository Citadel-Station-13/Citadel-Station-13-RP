//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

GLOBAL_LIST_INIT(frame_datums, init_frame_datums())

/proc/init_frame_datums()

#warn global list

/**
 * arbitrary construction frames
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
	var/has_structure_stage_states = TRUE
	/// do we append -stage to items?
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

#warn guh

/**
 * requires a specific circuitboard, or just doesn't require one at all
 */
/datum/frame2/preloaded

AUTO_FRAME_DATUM(preloaded/apc, 'icons/objects/frames/apc.dmi')
/datum/frame2/preloaded/apc
	name = "APC frame"
	material_cost = 2
	// we immediately form the entity on place; no stages
	steps_forward = list()
	steps_backward = list()
	wall_frame = TRUE
	#warn wallframe offsets

/datum/frame2/preloaded/apc/finish(atom/location, dir, stage, list/context)
	ASSERT(isturf(location))
	return new /obj/machinery/power/apc(location, dir, TRUE)


AUTO_FRAME_DATUM(preloaded/apc, 'icons/objects/frames/fire_alarm.dmi')
/datum/frame2/preloaded/fire_alarm
	name = "fire alarm frame"
	material_cost = 2
	steps_forward = list(
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_ITEM,
			FRAME_STEP_REQUEST = /obj/item/circuitboard/firealarm,
		),
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_TOOL,
			FRAME_STEP_REQUEST = TOOL_SCREWDRIVER,
		),
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_STACK,
			FRAME_STEP_REQUEST = /obj/item/stack/cable_coil,
			FRAME_STEP_AMOUNT = 1,
		),
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_TOOL,
			FRAME_STEP_REQUEST = TOOL_SCREWDRIVER,
		),
	)
	steps_backward = list(
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_TOOL,
			FRAME_STEP_REQUEST = TOOL_WRENCH,
		),
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_INTERACT,
		),
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_TOOL,
			FRAME_STEP_REQUEST = TOOL_SCREWDRIVER,
		),
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_TOOL,
			FRAME_STEP_REQUEST = TOOL_WIRECUTTERS,
		),
	)

AUTO_FRAME_DATUM(preloaded/apc, 'icons/objects/frames/solar_panel.dmi')
/datum/frame2/preloaded/solar_panel
	name = "solar assembly"
	material_buildable = FALSE
	steps_forward = list(
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_MATERIAL,
			FRAME_STEP_REQUEST = /datum/material/glass,
		),
	)
	// no deconstruction
	steps_backward = list(
		list(
			FRAME_STEP_TYPE = FRAME_STEP_TYPE_NONE,
		),
	)

	has_structure_stage_states = FALSE
