AUTO_FRAME_DATUM(preloaded/apc, 'icons/objects/frames/fire_alarm.dmi')
/datum/frame2/fire_alarm
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
			FRAME_STEP_REQUEST = TOOL_WIRECUTTER,
		),
	)
