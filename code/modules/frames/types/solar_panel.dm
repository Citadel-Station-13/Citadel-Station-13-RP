AUTO_FRAME_DATUM(preloaded/apc, 'icons/objects/frames/solar_panel.dmi')
/datum/frame2/solar_panel
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
