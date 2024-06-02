//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* request types

/// use x of a specific stack type
/// request is typepath of stack
/// amount is stack amount used
#define FRAME_REQUEST_TYPE_STACK "!STACK"
/// use x of a material
/// request is typepath of material
/// amount is stack amount used
#define FRAME_REQUEST_TYPE_MATERIAL "!MATERIAL"
/// use x of an item
/// request is typepath of item
/// amount is items used
#define FRAME_REQUEST_TYPE_ITEM "!ITEM"
/// rely on proc
#define FRAME_REQUEST_TYPE_PROC "!PROC"
/// interact with hand
/// amount is time needed
#define FRAME_REQUEST_TYPE_INTERACT "!INTERACT"
/// request is tool function
/// amount is time needed
#define FRAME_REQUEST_TYPE_TOOL "!TOOL"

//* special stages

/// deconstruct; usually default behavior on reverting past first stage
#define FRAME_STAGE_DECONSTRUCT "!DEL"
/// finish; usually default behavior on progressing past last stage
#define FRAME_STAGE_FINISH "!FIN"

//* special contexts

/// automatic context for storing items put into the frame
#define FRAME_CONTEXT_FOR_STAGE(N) "![N]-parts"

//* special things

#define AUTO_FRAME_DATUM(TYPEPATH, EXTENSION, ICON) \
/obj/structure/frame2/##EXTENSION { \
	icon = ##ICON; \
	frame = ##TYPEPATH; \
} \
/obj/structure/frame2/##EXTENSION/unanchored { \
	anchored = FALSE; \
} \
/obj/item/frame2/##EXTENSION { \
	icon = ##ICON; \
	frame = ##TYPEPATH; \
} \
##TYPEPATH { \
	icon = ##ICON; \
}

#define AUTO_FRAME_DATUM_UNANCHORABLE(TYPEPATH, EXTENSION, ICON) \
AUTO_FRAME_DATUM(TYPEPATH, EXTENSION, ICON); \
/obj/structure/frame2/##EXTENSION/unanchored { \
	anchored = FALSE; \
}

//* text template fragments

/// "firstname lastname"
#define FRAME_TEXT_TOKEN_PERFORMER "!performer"
/// "the fire alarm frame"
#define FRAME_TEXT_TOKEN_FRAME "!frame"
/// "the fire alarm electronics" or "the welding torch"
#define FRAME_TEXT_TOKEN_TOOL "!tool"
/// pronoun for 'their'
#define FRAME_TEXT_TOKEN_THEIR "!their"
/// pronoun for 'them'
#define FRAME_TEXT_TOKEN_THEM "!them"
/// pronoun for 'they're' (he's, she's, etc)
#define FRAME_TEXT_TOKEN_THEYRE "!theyre"
