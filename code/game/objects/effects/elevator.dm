GLOBAL_LIST_EMPTY(virtual_elevators)

/**
 * "fake" elevators, useful for cargo/whatever
 * 
 * you manually control them with other datums.
 */
/obj/effect/virtual_elevator
	name = "cargo lift"
	desc = "A lift of some kind."
	icon = 'icons/effects/elevator_5x5.dmi'
	
	bound_width = 160
	bound_height = 160
	bound_x = -64
	bound_y = -64

	/// unique id
	var/id

#warn impl
#warn almayer_(lowering, lowered, raising, raised)

/obj/effect/virtual_elevator/Initialize(mapload)
	. = ..()
	register()

/obj/effect/virtual_elevator/Destroy()
	if(registered)
		unregister()
	return ..()

/obj/effect/virtual_elevator/proc/register()
	if(!isnull(GLOB.virtual_elevators[id]))
		CRASH("id collision")
	GLOB.virtual_elevators[id] = src
	registered = TRUE

/obj/effect/virtual_elevator/proc/unregister()
	GLOB.virtual_elevators -= id
	registered = FALSE

/obj/effect/virtual_elevator/proc/movables()
	. = list()
	for(var/atom/movable/AM in obounds(src))
		. += AM
