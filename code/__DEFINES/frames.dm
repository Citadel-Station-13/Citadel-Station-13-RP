//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* stage data keys

/// steps
#define FRAME_STAGE_DATA_STEPS "steps"
/// name prepend; if existing, will be prepended with a space
#define FRAME_STAGE_DATA_NAME_PREPEND "name-prepend"
/// name append; if existing, will be appended with a space
#define FRAME_STAGE_DATA_NAME_APPEND "name-append"
/// name override; if existing, will override base name
#define FRAME_STAGE_DATA_NAME_OVERRIDE "name-override"
/// "the [name] [stage desc]."
#define FRAME_STAGE_DATA_DESC "name"

//* step data

/// FRAME_STEP_TYPE_X define
#define FRAME_STEP_DATA_TYPE "type"
/// ergo: stack type, item type, tool function, etc
#define FRAME_STEP_DATA_REQUEST "request"
/// for tools, this is time needed
#define FRAME_STEP_DATA_REQUEST_AMOUNT "request-amount"
/// what to drop
/// can either be:
/// * /obj/item/stack typepath
/// * /datum/material typepath
/// * /obj/item typepath
#define FRAME_STEP_DATA_DROP "drop"
/// amount to drop.
/// defaults to 1.
#define FRAME_STEP_DATA_DROP_AMOUNT "drop-amount"
/// for tools, this is cost
#define FRAME_STEP_DATA_COST "cost"
/// step name for tool radials and others
#define FRAME_STEP_DATA_NAME "name"
/// what stage does this move us to?
#define FRAME_STEP_DATA_STAGE "stage"
/// is this forwards, or backwards, or neither? this is a hint for graphics / visuals / feedback.
#define FRAME_STEP_DATA_DIRECTION "direction"

//* step types

/// use x of a specific stack type
/// request is typepath of stack
/// amount is stack amount used
#define FRAME_STEP_TYPE_STACK "!STACK"
/// use x of a material
/// request is typepath of material
/// amount is stack amount used
#define FRAME_STEP_TYPE_MATERIAL "!MATERIAL"
/// use x of an item
/// request is typepath of item
/// amount is items used
#define FRAME_STEP_TYPE_ITEM "!ITEM"
/// rely on proc
#define FRAME_STEP_TYPE_PROC "!PROC"
/// interact with hand
/// amount is time needed
#define FRAME_STEP_TYPE_INTERACT "!INTERACT"
/// request is tool function
/// amount is time needed
#define FRAME_STEP_TYPE_TOOL "!TOOL"

//* special stages

/// deconstruct; usually default behavior on reverting past first stage
#define FRAME_STAGE_DECONSTRUCT "!DEL"
/// finish; usually default behavior on progressing past last stage
#define FRAME_STAGE_FINISH "!FIN"

//* special contexts

/// automatic context for storing items put into the frame
#define FRAME_CONTEXT_FOR_STAGE(N) "![N]-parts"

//* special things

#define AUTO_FRAME_DATUM(TYPEPATH, ICON) \
/obj/structure/frame2 { \
	icon = ##ICON; \
	frame = ##TYPEPATH; \
} \
/obj/item/frame2 { \
	icon = ##ICON; \
	frame = ##TYPEPATH; \
} \
##TYPEPATH { \
	icon = ##ICON; \
}
