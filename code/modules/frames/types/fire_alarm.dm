AUTO_FRAME_DATUM(/datum/frame2/fire_alarm, fire_alarm, 'icons/machinery/fire_alarm.dmi')
/datum/frame2/fire_alarm
	name = "fire alarm frame"
	wall_pixel_y = 24
	wall_pixel_x = 24
	wall_frame = TRUE
	material_cost = 2
	stages = list(
		"frame" = /datum/frame_stage{
			steps = list(
				/datum/frame_step{
					request = /obj/item/circuitboard/firealarm;
					name = "insert circuit";
					stage = "circuit";
					direction = TOOL_DIRECTION_FORWARDS;
				},
				/datum/frame_step{
					request = TOOL_WRENCH;
					time = 1 SECONDS;
					name = "detach frame";
					stage = FRAME_STAGE_DECONSTRUCT;
					direction = TOOL_DIRECTION_BACKWARDS;
				},
			);
			descriptor = "is currently an empty shell.";
		},
		"circuit" = /datum/frame_stage{
			steps = list(
				/datum/frame_step{
					request = TOOL_SCREWDRIVER;
					name = "secure circuit";
					stage = "secured";
					direction = TOOL_DIRECTION_FORWARDS;
				},
				/datum/frame_step{
					request_type = FRAME_REQUEST_TYPE_INTERACT;
					name = "remove circuit";
					stage = "frame";
					drop = /obj/item/circuitboard/firealarm;
					direction = TOOL_DIRECTION_BACKWARDS;
				},
			);
			descriptor = "has the circuit installed";
		},
		"secured" = /datum/frame_stage{
			steps = list(
				/datum/frame_step{
					request = /obj/item/stack/cable_coil;
					name = "wire circuit";
					request_amount = 1;
					stage = "wired";
					direction = TOOL_DIRECTION_FORWARDS;
				},
				/datum/frame_step{
					request = TOOL_SCREWDRIVER;
					name = "unsecure circuit";
					stage = "circuit";
					direction = TOOL_DIRECTION_FORWARDS;
				},
			);
			descriptor = "has the circuit secured.";
		},
		"wired" = /datum/frame_stage{
			steps = list(
				/datum/frame_step{
					request = TOOL_SCREWDRIVER;
					name = "secure panel";
					stage = FRAME_STAGE_FINISH;
					direction = TOOL_DIRECTION_FORWARDS;
				},
				/datum/frame_step{
					request = TOOL_WIRECUTTER;
					name = "remove wiring";
					stage = "secured";
					direction = TOOL_DIRECTION_BACKWARDS;
				},
			);
			descriptor = "has its wiring installed.";
			name_append = "(wired)";
		},
	)


/datum/frame2/fire_alarm/instance_product(obj/structure/frame/frame)
	return new /obj/machinery/fire_alarm(frame.loc, frame.dir)
