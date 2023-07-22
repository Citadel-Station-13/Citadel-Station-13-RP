/obj/item/rig/proc/effective_control_flags(mob/M)

/obj/item/rig/proc/check_control_flags(mob/M, control_flags)
	return (effective_control_flags(M) & control_flags) == control_flags

#warn impl
