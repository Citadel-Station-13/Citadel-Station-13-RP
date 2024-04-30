/obj/vehicle/ridden
	name = "ridden vehicle"
	// todo: i wish byond planes weren't monolithic and awful but we should probably have a proper plane system haha.
	plane = MOB_PLANE
	buckle_allowed = TRUE
	buckle_max_mobs = 1
	buckle_lying = FALSE
	default_driver_move = FALSE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW
	var/riding_filter_type = /datum/component/riding_filter/vehicle
	var/riding_handler_type

/obj/vehicle/ridden/Initialize(mapload)
	. = ..()
	AddComponent(riding_filter_type, riding_handler_type)

/obj/vehicle/ridden/generate_action_type(actiontype)
	var/datum/action/vehicle/ridden/A = ..()
	. = A
	if(istype(A))
		A.vehicle_ridden_target = src

/obj/vehicle/ridden/mob_unbuckled(mob/M, flags, mob/user, semantic)
	remove_occupant(M)
	return ..()

/obj/vehicle/ridden/mob_buckled(mob/M, flags, mob/user, semantic)
	add_occupant(M)
	/*
	if(M.get_num_legs() < legs_required)
		to_chat(M, "<span class='warning'>You don't have enough legs to operate the pedals!</span>")
		unbuckle_mob(M)
	*/
	return ..()

/obj/vehicle/ridden/proc/drive_check(mob/user)
	if(key_type && !is_key(inserted_key))
		to_chat(user, SPAN_WARNING("[src] has no key inserted."))
		return FALSE
	return TRUE
