/// Any floor or wall. What makes up the station and the rest of the map.
/turf
	icon = 'icons/turf/floors.dmi'
	layer = TURF_LAYER
	plane = TURF_PLANE
	luminosity = 1
	level = 1

	/// turf flags
	var/turf_flags = NONE

	var/holy = 0

	// Atmospherics / ZAS Environmental
	/// Initial air contents, as a specially formatted gas string.
	var/initial_gas_mix = GAS_STRING_TURF_DEFAULT
	// End

	// Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	// Properties for both
	/// Initial turf temperature.
	var/temperature = T20C
	/// Does this turf contain air/let air through?
	var/blocks_air = FALSE

	/**
	 * Baseturfs
	 */
	// baseturfs can be either a list or a single turf type.
	// In class definition like here it should always be a single type.
	// A list will be created in initialization that figures out the baseturf's baseturf etc.
	// In the case of a list it is sorted from bottom layer to top.
	// This shouldn't be modified directly, use the helper procs.
	var/list/baseturfs = /turf/baseturf_bottom
	/// are we mid changeturf?
	var/changing_turf = FALSE
	// End

	/**
	 * Automata
	 */
	/// acted automata - automata associated to power, act_cross() will be called when something enters us while this is set
	var/list/acting_automata

	/// Icon-smoothing variable to map a diagonal wall corner with a fixed underlay.
	var/list/fixed_underlay = null

	// General properties.
	var/icon_old = null
	/// How much does it cost to pathfind over this turf?
	var/pathweight = 1
	/// Has the turf been blessed?
	var/blessed = FALSE

	var/list/decals

	/// How much the turf slows down movement, if any.
	var/movement_cost = 0

	var/list/footstep_sounds = null

	// Outdoors var determines if the game should consider the turf to be 'outdoors', which controls certain things such as weather effects.
	var/outdoors = FALSE

	/// If true, most forms of teleporting to or from this turf tile will fail.
	var/block_tele = FALSE
	/// Used for things like RCDs (and maybe lattices/floor tiles in the future), to see if a floor should replace it.
	var/can_build_into_floor = FALSE
	/// List of 'dangerous' objs that the turf holds that can cause something bad to happen when stepped on, used for AI mobs.
	var/list/dangerous_objects
	/// For if you explicitly want a turf to not be affected by shield generators
	var/noshield = FALSE

/turf/vv_edit_var(var_name, new_value)
	var/static/list/banned_edits = list(NAMEOF(src, x), NAMEOF(src, y), NAMEOF(src, z))
	if(var_name in banned_edits)
		return FALSE
	. = ..()

/**
 * Turf Initialize
 *
 * Doesn't call parent, see [/atom/proc/Initialize]
 */
/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(flags & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags |= INITIALIZED

	// by default, vis_contents is inherited from the turf that was here before
	vis_contents.len = 0

	assemble_baseturfs()

	//atom color stuff
	if(color)
		add_atom_colour(color, FIXED_COLOUR_PRIORITY)

/*
	if (canSmoothWith)
		canSmoothWith = typelist("canSmoothWith", canSmoothWith)
*/

	for(var/atom/movable/AM in src)
		Entered(AM)

	var/area/A = loc
	if(!IS_DYNAMIC_LIGHTING(src) && IS_DYNAMIC_LIGHTING(A))
		add_overlay(/obj/effect/fullbright)

	if (light_power && light_range)
		update_light()

	if (opacity)
		has_opaque_atom = TRUE

	//Pathfinding related
	if(movement_cost && pathweight == 1)	// This updates pathweight automatically.
		pathweight = movement_cost

	return INITIALIZE_HINT_NORMAL

/turf/Destroy(force)
	. = QDEL_HINT_IWILLGC
	if(!changing_turf)
		stack_trace("Incorrect turf deletion")
	changing_turf = FALSE
/*
	var/turf/T = SSmapping.get_turf_above(src)
	if(T)
		T.multiz_turf_del(src, DOWN)
	T = SSmapping.get_turf_below(src)
	if(T)
		T.multiz_turf_del(src, UP)
*/
	if(force)
		..()
		//this will completely wipe turf state
		var/turf/B = new world.turf(src)
		for(var/A in B.contents)
			qdel(A)
		return
	// SSair.remove_from_active(src)
	// visibilityChanged()
	// QDEL_LIST(blueprint_data)
	flags &= ~INITIALIZED
	// requires_activation = FALSE
	..()

/turf/legacy_ex_act(severity)
	return 0

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

// Used by shuttle code to check if this turf is empty enough to not crush want it lands on.
/turf/proc/is_solid_structure()
	return 1

/turf/attack_hand(mob/user)
	. = ..()
	//QOL feature, clicking on turf can toggle doors, unless pulling something
	if(!user.pulling)
		var/obj/machinery/door/airlock/AL = locate(/obj/machinery/door/airlock) in src.contents
		if(AL)
			AL.attack_hand(user)
			return TRUE
		var/obj/machinery/door/firedoor/FD = locate(/obj/machinery/door/firedoor) in src.contents
		if(FD)
			FD.attack_hand(user)
			return TRUE

	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return 0
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return 0
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return 1

/turf/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
	return ..()

// Hits a mob on the tile.
/turf/proc/attack_tile(obj/item/W, mob/living/user)
	if(!istype(W))
		return FALSE

	var/list/viable_targets = list()
	var/success = FALSE	// Hitting something makes this true. If its still false, the miss sound is played.

	for(var/mob/living/L in contents)
		if(L == user)	// Don't hit ourselves.
			continue
		viable_targets += L

	if(!viable_targets.len)	// No valid targets on this tile.
		if(W.can_cleave)
			success = W.cleave(user, src)
	else
		var/mob/living/victim = pick(viable_targets)
		success = W.resolve_attackby(victim, user)

	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src, no_attack_icons = TRUE)

	if(!success)	// Nothing got hit.
		user.visible_message("<span class='warning'>\The [user] swipes \the [W] over \the [src].</span>")
		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
	return success

/turf/MouseDroppedOnLegacy(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if((istype(A) && !(A.has_gravity)) || (istype(T,/turf/space)))
		return
	if(istype(O, /atom/movable/screen))
		return
	if(user.restrained() || user.stat || user.stunned || user.paralysis || (!user.lying && !istype(user, /mob/living/silicon/robot)))
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return
	if (do_after(user, 25 + (5 * user.weakened)) && !(user.stat))
		step_towards(O, src)
		if(ismob(O))
			animate(O, transform = turn(O.transform, 20), time = 2)
			sleep(2)
			animate(O, transform = turn(O.transform, -40), time = 4)
			sleep(4)
			animate(O, transform = turn(O.transform, 20), time = 2)
			sleep(2)
			O.update_transform()


/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/t in (trange(1,src) - src))
		var/turf/T = t
		if(check_blockage)
			if(!T.density)
				if(!LinkBlocked(src, T) && !TurfBlockedNonWindow(T))
					. += t
		else
			. += t

/turf/proc/CardinalTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/ad in AdjacentTurfs(check_blockage))
		var/turf/T = ad
		if(T.x == src.x || T.y == src.y)
			. += T

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER))
			return 1
	return 0

// Expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/debris/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
	else
		to_chat(user, "<span class='warning'>\The [source] is too dry to wash that.</span>")
	source.reagents.trans_to_turf(src, 1, 10)	// 10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/update_blood_overlays()
	return

// Called when turf is hit by a thrown object
/turf/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(src.density)
		spawn(2)
			step(AM, turn(AM.last_move_dir, 180))
		if(isliving(AM) && !(TT.throw_flags & THROW_AT_IS_GENTLE))
			var/mob/living/M = AM
			M.turf_collision(src, TT.speed)

/turf/AllowDrop()
	return TRUE

// Returns false if stepping into a tile would cause harm (e.g. open space while unable to fly, water tile while a slime, lava, etc).
/turf/proc/is_safe_to_enter(mob/living/L)
	if(LAZYLEN(dangerous_objects))
		for(var/obj/O in dangerous_objects)
			if(!O.is_safe_to_step(L))
				return FALSE
	return TRUE

// Tells the turf that it currently contains something that automated movement should consider if planning to enter the tile.
// This uses lazy list macros to reduce memory footprint, since for 99% of turfs the list would've been empty anyways.
/turf/proc/register_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYADD(dangerous_objects, O)
//	color = "#FF0000"

// Similar to above, for when the dangerous object stops being dangerous/gets deleted/moved/etc.
/turf/proc/unregister_dangerous_object(obj/O)
	if(!istype(O))
		return FALSE
	LAZYREMOVE(dangerous_objects, O)
	UNSETEMPTY(dangerous_objects)	// This nulls the list var if it's empty.
//	color = "#00FF00"

// This is all the way up here since its the common ancestor for things that need to get replaced with a floor when an RCD is used on them.
// More specialized turfs like walls should instead override this.
// The code for applying lattices/floor tiles onto lattices could also utilize something similar in the future.
/turf/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(density || !can_build_into_floor)
		return FALSE
	if(passed_mode == RCD_FLOORWALL)
		var/obj/structure/lattice/L = locate() in src
		// A lattice costs one rod to make. A sheet can make two rods, meaning a lattice costs half of a sheet.
		// A sheet also makes four floor tiles, meaning it costs 1/4th of a sheet to place a floor tile on a lattice.
		// Therefore it should cost 3/4ths of a sheet if a lattice is not present, or 1/4th of a sheet if it does.
		return list(
			RCD_VALUE_MODE = RCD_FLOORWALL,
			RCD_VALUE_DELAY = 0,
			RCD_VALUE_COST = L ? RCD_SHEETS_PER_MATTER_UNIT * 0.25 : RCD_SHEETS_PER_MATTER_UNIT * 0.75
			)
	return FALSE

/turf/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_FLOORWALL)
		to_chat(user, SPAN_NOTICE("You build a floor."))
		PlaceOnTop(/turf/simulated/floor, flags = CHANGETURF_INHERIT_AIR|CHANGETURF_PRESERVE_OUTDOORS)
		return TRUE
	return FALSE

// We're about to be the A-side in a turf translation
/turf/proc/pre_translate_A(var/turf/B)
	return
// We're about to be the B-side in a turf translation
/turf/proc/pre_translate_B(var/turf/A)
	return
// We were the the A-side in a turf translation
/turf/proc/post_translate_A(var/turf/B)
	return
// We were the the B-side in a turf translation
/turf/proc/post_translate_B(var/turf/A)
	return

/turf/has_gravity()
	if(loc.has_gravity(src))
		return TRUE
/*
	else
		// There's a gravity generator on our z level
		if(GLOB.gravity_generators["[z]"])
			//? length check
			return TRUE
*/
	return SSmapping.level_trait(z, ZTRAIT_GRAVITY)
