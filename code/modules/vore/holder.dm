/**
 * physical holders of vore
 *
 * also known as a "belly" apparently
 */
/obj/vore_holder
	name = "vore holder"
	desc = "what?"

	/// are we processing?
	var/active = FALSE

#warn impl all

/obj/vore_holder/serialize()
	. = ..()

/obj/vore_holder/deserialize(list/data)
	. = ..()

/obj/vore_holder/proc/set_active(new_active)
	if(active == new_active)
		return
	active = new_active
	if(active)
		SSvore.active_holders += src
	else
		SSvore.active_holders -= src

/**
 * @params
 * * dt - time in seconds to process
 * * cycles - current process cycle count (goes up by 1 per fire)
 */
/obj/vore_holder/proc/process_vore(dt, cycles)
	#warn impl
