//Define a macro that we can use to assemble all the circuit board names
#ifdef T_BOARD
#error T_BOARD already defined elsewhere, we can't use it.
#endif
#define T_BOARD(name) "circuit board (" + (name) + ")"

// TODO: split into machine, computer, etc circuits
/**
 * circuitboards
 *
 * used in frames to construct arbitrary objects with arbitrary components.
 * this will usually be /obj/machinery, but other things are possible.
 */
/obj/item/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	origin_tech = list(TECH_DATA = 2)
	density = FALSE
	anchored = FALSE
	w_class = ITEMSIZE_SMALL
	force = 5.0
	throw_force = 5.0
	throw_speed = 3
	throw_range = 15
	var/build_path = null
	var/board_type = new /datum/frame/frame_types/computer
	/**
	 * Components required by the machine.
	 * Example: list(/obj/item/stock_parts/matter_bin = 5)
	 */
	var/list/req_components

	/**
	 * Components that are optional for the machine.
	 * Example: list(/obj/item/stock_parts/matter_bin = 5)
	 */
	var/list/def_components

	var/contain_parts = TRUE

/**
 * called when we are used to construct something.
 *
 * put your synchronization code in here.
 */
/obj/item/circuitboard/proc/after_construct(atom/A)
	return

/**
 * called when what we were used to construct is deconstructed.
 *
 * put your synchronization code in here.
 *
 */
/obj/item/circuitboard/proc/after_deconstruct(atom/A)
	return

/// Should be called from the constructor of any machine to automatically populate the default parts.
/obj/item/circuitboard/proc/apply_default_parts(obj/machinery/M)
	if(LAZYLEN(M.component_parts))
		// This really shouldn't happen. If it somehow does, print out a stack trace and gracefully handle it.
		stack_trace("apply_defauly_parts called on machine that already had component_parts: [M]")

		// Move to nullspace so you don't trigger handle_atom_del logic and remove existing parts.
		for(var/obj/item/part in M.component_parts)
			part.moveToNullspace(loc)
			qdel(part)

	// List of components always contains the circuit board used to build it.
	// M.component_parts = list(src)
	// forceMove(M)

	// we're on shitty old code, circuit isn't part of component parts yet.
	M.component_parts = list()
	forceMove(M)

	if(M.circuit != src)
		// This really shouldn't happen. If it somehow does, print out a stack trace and gracefully handle it.
		stack_trace("apply_default_parts called from a circuit board that does not belong to machine: [M]")

		// Move to nullspace so you don't trigger handle_atom_del logic, remove old circuit, add new circuit.
		M.circuit.moveToNullspace()
		qdel(M.circuit)
		M.circuit = src

	for(var/comp_path in req_components)
		var/comp_amt = req_components[comp_path]
		if(!comp_amt)
			continue

		if(def_components && def_components[comp_path])
			comp_path = def_components[comp_path]

		if(ispath(comp_path, /obj/item/stack))
			M.component_parts += new comp_path(null, comp_amt)
		else
			for(var/i in 1 to comp_amt)
				M.component_parts += new comp_path(null)

	M.RefreshParts()

/obj/item/circuitboard/examine(mob/user)
	. = ..()
	if(LAZYLEN(req_components))
		var/list/nice_list = list()
		for(var/B in req_components)
			var/atom/A = B
			if(!ispath(A))
				continue
			nice_list += list("[req_components[A]] [initial(A.name)]")
		. += SPAN_NOTICE("Required components: [english_list(nice_list)].")
