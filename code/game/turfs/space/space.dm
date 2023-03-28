/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"
	plane = SPACE_PLANE
	mz_flags = MZ_ATMOS_BOTH | MZ_OPEN_BOTH

	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED
	permit_ao = FALSE

	initial_gas_mix = GAS_STRING_VACUUM
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	temperature = 2.7
	can_build_into_floor = TRUE
	z_eventually_space = TRUE

	/// If we're an edge.
	var/edge = 0
	/// Force this one to pretend it's an overedge turf.
	var/forced_dirs = 0

/turf/space/basic
	atom_flags = ATOM_INITIALIZED

/turf/space/basic/New()	//Do not convert to Initialize
	//This is used to optimize the map loader
	return

/turf/space/Initialize(mapload)

	SHOULD_CALL_PARENT(FALSE)
	atom_flags |= ATOM_INITIALIZED

	icon_state = SPACE_ICON_STATE(x, y, z)

	// We might be an edge
	if(y == world.maxy || forced_dirs & NORTH)
		edge |= NORTH
	else if(y == 1 || forced_dirs & SOUTH)
		edge |= SOUTH

	if(x == 1 || forced_dirs & WEST)
		edge |= WEST
	else if(x == world.maxx || forced_dirs & EAST)
		edge |= EAST

	if(!HasBelow(z))
		return INITIALIZE_HINT_NORMAL

	var/turf/below = GetBelow(src)
	if(isspaceturf(below))
		return INITIALIZE_HINT_NORMAL

	var/area/A = below.loc
	if(!below.density && (A.area_flags & AREA_FLAG_EXTERNAL))
		return INITIALIZE_HINT_NORMAL

	if (CONFIG_GET(flag/starlight))
		update_starlight()

	return INITIALIZE_HINT_LATELOAD // oh no! we need to switch to being a different kind of turf!

/turf/space/Destroy()
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GetAbove(T)))
			T.z_eventually_space = FALSE
	return ..()

/turf/space/is_space()	// Hmmm this Space is made of Space.
	return TRUE

/turf/space/is_open()
	return TRUE

// Override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/space/is_solid_structure()
	return locate(/obj/structure/lattice, src)	// Counts as solid structure if it has a lattice

/turf/space/proc/update_starlight()
	if(!(CONFIG_GET(flag/starlight)))
		return

	for (var/turf/T in RANGE_TURFS(1, src))
		// Fuck if I know how these turfs are located in an area that is not an area.
		if (!isloc(T.loc) || !TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
			continue

		set_ambient_light(COLOR_WHITE)
		return

	if (TURF_IS_AMBIENT_LIT_UNSAFE(src))
		clear_ambient_light()


/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if(istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/plating, flags = CHANGETURF_INHERIT_AIR)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	if(istype(C, /obj/item/stack/tile/roofing))
		var/turf/T = GetAbove(src)
		var/obj/item/stack/tile/roofing/R = C

		// Patch holes in the ceiling
		if(T)
			if(istype(T, /turf/simulated/open) || istype(T, /turf/space))
				// Must be build adjacent to an existing floor/wall, no floating floors
				var/turf/simulated/A = locate(/turf/simulated/floor) in T.CardinalTurfs()
				if(!A)
					A = locate(/turf/simulated/wall) in T.CardinalTurfs()
				if(!A)
					to_chat(user, "<span class='warning'>There's nothing to attach the ceiling to!</span>")
					return

				if(R.use(1))	// Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ReplaceWithLattice()
					T.ChangeTurf(/turf/simulated/floor, flags = CHANGETURF_INHERIT_AIR)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] expands the ceiling.</span>", "<span class='notice'>You expand the ceiling.</span>")
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return
		// Space shouldn't have weather of the sort planets with atmospheres do.
		// If that's changed, then you'll want to swipe the rest of the roofing code from code/game/turfs/simulated/floor_attackby.dm
	return

/turf/space/Entered(var/atom/movable/A)
	. = ..()

	if(edge)
		addtimer(CALLBACK(src, .proc/on_atom_edge_touch, A), 0)

/turf/space/proc/on_atom_edge_touch(atom/movable/AM)
	if(!QDELETED(AM) && (AM.loc == src))
		AM.touch_map_edge()


//// Special variants used in various maps ////

// Bluespace jump turf!
/turf/space/bluespace
	name = "bluespace"
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

/turf/space/bluespace/Initialize(mapload)
	. = ..()
	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

// Desert jump turf!
/turf/space/sandyscroll
	name = "sand transit"
	icon = 'icons/turf/transit_vr.dmi'
	icon_state = "desert_ns"

/turf/space/sandyscroll/Initialize(mapload)
	. = ..()
	icon_state = "desert_ns"
