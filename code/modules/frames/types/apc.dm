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

#warn sanity checks / location guards
