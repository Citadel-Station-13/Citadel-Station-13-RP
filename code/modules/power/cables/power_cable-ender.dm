GLOBAL_LIST_EMPTY(cable_ender_lookup)

/**
 * Magical remote power joins, basically.
 *
 * Use this to transmit power cross-zlevel.
 */
/obj/structure/wire/power_cable/ender
	// Pretend to be heavy duty power cable
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	plane = TURF_PLANE
	layer = HEAVYDUTY_WIRE_LAYER //Just below pipes
	color = null
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	cut_time = null

	/// what other cable enders we link to
	var/id

/obj/structure/wire/power_cable/ender/preloading_instance(datum/dmm_context/context)
	. = ..()
	id = SSmapping.mangled_persistent_id(id, context.mangling_id)

/obj/structure/wire/power_cable/ender/Initialize(mapload, _color, _d1, _d2, auto_merge)
	if(!isnull(id))
		LAZYADD(GLOB.cable_ender_lookup[id], src)
	return ..()

/obj/structure/wire/power_cable/ender/Destroy()
	if(!isnull(id) && !isnull(GLOB.cable_ender_lookup[id]))
		GLOB.cable_ender_lookup[id] - src
		if(!length(GLOB.cable_ender_lookup[id]))
			GLOB.cable_ender_lookup -= id
	return ..()

/obj/structure/wire/power_cable/ender/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	switch(var_name)
		if(NAMEOF(src, id))
			if(!isnull(id) && !isnull(GLOB.cable_ender_lookup[id]))
				GLOB.cable_ender_lookup[id] - src
				if(!length(GLOB.cable_ender_lookup[id]))
					GLOB.cable_ender_lookup -= id
	. = ..()
	if(!isnull(id))
		LAZYADD(GLOB.cable_ender_lookup[id], src)
	if(.)
		rebuild()

/obj/structure/wire/power_cable/ender/adjacent_wires()
	. = ..()
	var/list/others = GLOB.cable_ender_lookup[id] - src
	. |= others

// Because they cannot be rebuilt, they are hard to destroy
// todo: object damage
/obj/structure/wire/power_cable/ender/legacy_ex_act(severity)
	return
