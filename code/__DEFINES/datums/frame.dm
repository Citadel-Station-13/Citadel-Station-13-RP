//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* step data

/// FRAME_STEP_TYPE_X define
#define FRAME_STEP_TYPE "type"
/// ergo: stack type, item type, tool function, etc
#define FRAME_STEP_REQUEST "request"
/// for tools, this is time needed
#define FRAME_STEP_AMOUNT "amount"
/// for tools, this is cost
#define FRAME_STEP_COST "cost"

//* step types

/// use x of a specific stack type
#define FRAME_STEP_TYPE_STACK "!STACK"
/// use x of a material
#define FRAME_STEP_TYPE_MATERIAL "!MATERIAL"
/// use x of an item
#define FRAME_STEP_TYPE_ITEM "!ITEM"
/// rely on proc
#define FRAME_STEP_TYPE_PROC "!PROC"
/// amount is time needed
#define FRAME_STEP_TYPE_INTERACT "!INTERACT"
/// amount is time needed, request is tool function
#define FRAME_STEP_TYPE_TOOL "!TOOL"

//* special stages

/// deconstruct; usually default behavior on reverting past first stage
#define FRAME_STAGE_DECONSTRUCT "!DEL"
/// finish; usually default behavior on progressing past last stage
#define FRAME_STAGE_FINISH "!FIN"

//* special contexts

/// automatic context for storing items put into the frame
#define FRAME_CONTEXT_FOR_STAGE(N) "![N]-parts"
