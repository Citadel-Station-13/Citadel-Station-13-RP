GLOBAL_LIST_EMPTY(cable_ender_lookup)

/obj/structure/wire/cable/ender
	// Pretend to be heavy duty power cable
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	plane = TURF_PLANE
	layer = HEAVYDUTY_WIRE_LAYER //Just below pipes
	color = null
	unacidable = 1
	cut_time = null
	/// what other cable enders we link to
	var/id

/obj/structure/cable/ender/Initialize(mapload, _color, _d1, _d2, auto_merge)
	if(!isnull(id))
		LAZYADD(GLOB.cable_ender_lookup[id], src)
	return ..()

/obj/structure/wire/cable/ender/Destroy()
	if(!isnull(id) && !isnull(GLOB.cable_ender_lookup[id]))
		GLOB.cable_ender_lookup[id] - src
		if(!length(GLOB.cable_ender_lookup[id]))
			GLOB.cable_ender_lookup -= id
	return ..()

/obj/structure/wire/cable/ender/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
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

/obj/structure/wire/cable/ender/adjacent_wires()
	. = ..()
	var/list/others = GLOB.cable_ender_lookup[id] - src
	. |= others

// Because they cannot be rebuilt, they are hard to destroy
// todo: object damage
/obj/structure/wire/cable/ender/legacy_ex_act(severity)
	return
