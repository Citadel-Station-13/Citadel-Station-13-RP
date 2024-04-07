AUTO_FRAME_DATUM(apc, 'icons/objects/frames/apc.dmi')
/datum/frame2/apc
	name = "APC frame"
	material_cost = 2
	// we immediately form the entity on place; no stages
	steps_forward = list()
	steps_backward = list()
	wall_frame = TRUE
	#warn wallframe offsets

/datum/frame2/apc/instance_product(obj/structure/frame/frame)
	return new /obj/machinery/power/apc(frame.loc, frame.dir, TRUE)

/datum/frame2/apc/valid_location(obj/entity, turf/location, dir, datum/event_args/actor/actor, silent)
	if(!istype(location, /turf/simulated))
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("[entity] must be placed on normal flooring."),
				target = entity,
			)
		return FALSE
	var/area/area = location.loc
	if(!area)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("Missing area. Report this to coders with a screenshot of your screen. How did you get here?"),
				target = entity,
			)
		return FALSE
	if(!area.requires_power || area.always_unpowered)
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("[location] doesn't require power, or is externally powered."),
				target = entity,
			)
		return FALSE
	if(area.get_apc())
		if(!silent)
			actor.chat_feedback(
				SPAN_WARNING("[location] is part of an area that already has an APC."),
				target = entity,
			)
		return FALSE
	for(var/obj/machinery/power/terminal/T in location)
		actor.chat_feedback(
			SPAN_WARNING("There is another powernet terminal here."),
			target = entity,
		)
		return FALSE
	return ..()
