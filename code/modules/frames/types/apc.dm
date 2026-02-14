AUTO_FRAME_DATUM(/datum/frame2/apc, apc, 'icons/machinery/power/apc.dmi')
/datum/frame2/apc
	name = "APC frame"
	material_cost = 2
	// we immediately form the entity on place; no stages
	stages = list()
	wall_frame = TRUE
	wall_pixel_x = 24
	wall_pixel_y = 24

/datum/frame2/apc/instance_product(obj/structure/frame/frame)
	return new /obj/machinery/power/apc(frame.loc, frame.dir, TRUE)

/datum/frame2/apc/valid_location(obj/entity, turf/location, dir, datum/event_args/actor/actor, silent)
	if(!istype(location, /turf/simulated))
		if(!silent)
			actor.chat_feedback(
				span_warning("[entity] must be placed on normal flooring."),
				target = entity,
			)
		return FALSE
	var/area/area = location.loc
	if(!area)
		if(!silent)
			actor.chat_feedback(
				span_warning("Missing area. Report this to coders with a screenshot of your screen. How did you get here?"),
				target = entity,
			)
		return FALSE
	if(!area.requires_power || area.always_unpowered)
		if(!silent)
			actor.chat_feedback(
				span_warning("[location] doesn't require power, or is externally powered."),
				target = entity,
			)
		return FALSE
	if(area.get_apc())
		if(!silent)
			actor.chat_feedback(
				span_warning("[location] is part of an area that already has an APC."),
				target = entity,
			)
		return FALSE
	for(var/obj/machinery/power/terminal/T in location)
		actor.chat_feedback(
			span_warning("There is another powernet terminal here."),
			target = entity,
		)
		return FALSE
	return ..()
