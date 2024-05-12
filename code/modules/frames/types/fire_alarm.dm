AUTO_FRAME_DATUM(/datum/frame2/fire_alarm, 'icons/objects/frames/fire_alarm.dmi')
/datum/frame2/fire_alarm
	name = "fire alarm frame"
	material_cost = 2
	stages = list(
		"frame" = list(
			FRAME_STAGE_DATA_STEPS = list(
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_ITEM,
					FRAME_STEP_DATA_REQUEST = /obj/item/circuitboard/firealarm,
					FRAME_STEP_DATA_NAME = "insert circuit",
					FRAME_STEP_DATA_STAGE = "circuit",
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_FORWARDS,
				),
				list(
					FRMAE_STEP_DATA_TYPE = FRAME_STEP_TYPE_TOOL,
					FRAME_STEP_DATA_REQUEST = TOOL_WRENCH,
					FRAME_STEP_DATA_NAME = "detach frame",
					FRAME_STEP_DATA_STAGE = FRAME_STAGE_DECONSTRUCT,
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_BACKWARDS,
				),
			),
			FRAME_STAGE_DATA_DESC = "is currently an empty shell.",
		),
		"circuit" = list(
			FRAME_STAGE_DATA_STEPS = list(
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_TOOL,
					FRAME_STEP_DATA_REQUEST = TOOL_SCREWDRIVER,
					FRAME_STEP_DATA_NAME = "secure circuit",
					FRAME_STEP_DATA_STAGE = "secured",
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_FORWARDS,
				),
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_INTERACT,
					FRAME_STEP_DATA_NAME = "remove circuit",
					FRAME_STEP_DATA_STAGE = "frame",
					FRAME_STEP_DATA_DROP = /obj/item/circuitboard/firealarm,
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_BACKWARDS,
				),
			),
			FRAME_STAGE_DATA_DESC = "has the circuit installed.",
		),
		"secured" = list(
			FRAME_STAGE_DATA_STEPS = list(
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_STACK,
					FRAME_STEP_DATA_REQUEST = /obj/item/stack/cable_coil,
					FRAME_STEP_DATA_REQUEST_AMOUNT = 1,
					FRAME_STEP_DATA_STAGE = "wired",
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_FORWARDS,
				),
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_TOOL,
					FRAME_STEP_DATA_REQUEST = TOOL_SCREWDRIVER,
					FRAME_STEP_DATA_NAME = "unsecure circuit",
					FRAME_STEP_DATA_STAGE = "circuit",
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_BACKWARDS,
				),
			),
			FRAME_STAGE_DATA_DESC = "has the circuit secured.",
		),
		"wired" = list(
			FRAME_STAGE_DATA_STEPS = list(
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_TOOL,
					FRAME_STEP_DATA_REQUEST = TOOL_SCREWDRIVER,
					FRAME_STEP_DATA_NAME = "secure panel",
					FRAME_STEP_DATA_STAGE = FRAME_STAGE_FINISH,
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_FORWARDS,
				),
				list(
					FRAME_STEP_DATA_TYPE = FRAME_STEP_TYPE_TOOL,
					FRAME_STEP_DATA_REQUEST = TOOL_WIRECUTTER,
					FRAME_STEP_DATA_NAME = "remove wiring",
					FRAME_STEP_DATA_STAGE = "secured",
					FRAME_STEP_DATA_DIRECTION = TOOL_DIRECTION_BACKWARDS,
				),
			),
			FRAME_STAGE_DATA_NAME_OVERRIDE = "wired fire alarm frame",
			FRAME_STAGE_DATA_DESC = "has its wiring installed.",
		),
	)


/datum/frame2/fire_alarm/instance_product(obj/structure/frame/frame)
	return new /obj/machinery/fire_alarm(frame.loc, frame.dir)
