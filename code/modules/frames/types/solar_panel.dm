AUTO_FRAME_DATUM(/datum/frame2/solar_panel, 'icons/objects/frames/solar_panel.dmi')
/datum/frame2/solar_panel
	name = "solar assembly"
	material_buildable = FALSE
	has_density = TRUE
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

/datum/frame2/solar_panel/on_item(obj/structure/frame2/frame, obj/item/item, datum/event_args/actor/clickchain/click)
	. = ..()
	if(.)
		return
	if(istype(item, /obj/item/tracker_electronics))
		if(frame.get_context("tracker"))
			click.chat_feedback(
				SPAN_WARNING("[frame] already has tracker electronics installed."),
				target = frame,
			)
			return TRUE
		if(!click.performer.attempt_consume_item_for_construction(item))
			return TRUE
		click.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_CONSTRUCTION,
			visible = SPAN_NOTICE("[click.performer] inserts [item] into [frame].")
		)
		frame.set_context("tracker", TRUE)
		return TRUE

/datum/frame2/solar_panel/instance_product(obj/structure/frame2/frame)
	if(frame.get_context("tracker"))
		return new /obj/machinery/power/tracker(frame.loc)
	else
		return new /obj/machinery/power/solar(frame.loc)

/datum/frame2/solar_panel/instruction_special(obj/structure/frame2/frame, datum/event_args/actor/clickchain/click)
	. = ..()
	if(!frame.get_context("tracker"))
		. += SPAN_NOTICE("Add <b>tracker electronics</b> to make this a solar tracker assembly.")
	else
		. += SPAN_NOTICE("This assembly is wired to be a <b>solar tracker</b>.")

/obj/structure/frame2/solar_panel/anchored
	anchored = TRUE

/obj/structure/frame2/solar_panel/tracker
	context = list(
		"tracker" = TRUE,
	)

/obj/structure/frame2/solar_panel/tracker/anchored
	anchored = TRUE
