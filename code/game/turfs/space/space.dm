/turf/space
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
	can_build_into_floor = TRUE
	var/keep_sprite = FALSE
//	heat_capacity = 700000 No.
	var/destination_z
	var/destination_x
	var/destination_y

/turf/space/basic/New()	//Do not convert to Initialize
	//This is used to optimize the map loader
	return

/turf/space/Initialize()
	if(!keep_sprite)
		icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
	/*Icon state commented until parallax
	icon_state = SPACE_ICON_STATE
	*/
	//air = space_gas

	if(flags & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags |= INITIALIZED

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	/*
	if(requires_activation)
		SSair.add_to_active(src)
	*/

	if (light_power && light_range)
		update_light()

	if (opacity)
		has_opaque_atom = TRUE

	ComponentInitialize()

	return INITIALIZE_HINT_NORMAL

//ATTACK GHOST IGNORING PARENT RETURN VALUE
/turf/space/attack_ghost(mob/observer/user)
	if(destination_z)
		var/turf/T = locate(destination_x, destination_y, destination_z)
		user.forceMove(T)

/turf/space/is_space()
	return 1

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/space/proc/update_starlight()
	if(!config.starlight)
		return
	if(locate(/turf/simulated) in orange(src,1))
		set_light(config.starlight)
	else
		set_light(0)

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
			ChangeTurf(/turf/simulated/floor/airless)
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

				if(R.use(1)) // Cost of roofing tiles is 1:1 with cost to place lattice and plating
					T.ReplaceWithLattice()
					T.ChangeTurf(/turf/simulated/floor)
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					user.visible_message("<span class='notice'>[user] expands the ceiling.</span>", "<span class='notice'>You expand the ceiling.</span>")
			else
				to_chat(user, "<span class='warning'>There aren't any holes in the ceiling to patch here.</span>")
				return
		// Space shouldn't have weather of the sort planets with atmospheres do.
		// If that's changed, then you'll want to swipe the rest of the roofing code from code/game/turfs/simulated/floor_attackby.dm
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	if(movement_disabled)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems
		return
	..()
	if ((!(A) || src != A.loc))	return

	inertial_drift(A)

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Target Z = [target_z]"
		world << "Next X = [next_x]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		world << "Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]"
		world << "Next Y = [next_y]"
		world << "Target Z = [target_z]"
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/turf/space/ChangeTurf(var/turf/N, var/tell_universe, var/force_lighting_update, var/preserve_outdoors)
	return ..(N, tell_universe, 1, preserve_outdoors)
