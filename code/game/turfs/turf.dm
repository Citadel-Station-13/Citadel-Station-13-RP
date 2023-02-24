/// Any floor or wall. What makes up the station and the rest of the map.
/turf
	abstract_type = /turf

	icon = 'icons/turf/floors.dmi'
	layer = TURF_LAYER
	plane = TURF_PLANE
	luminosity = 1
	level = 1

	//! Flags
	/// turf flags
	var/turf_flags = NONE
	/// multiz flags
	var/mz_flags = MZ_ATMOS_UP | MZ_OPEN_UP

	var/holy = 0

	//! atmospherics
	/**
	 * the gas we start out as
	 * can be:
	 * - a gas string (will be parsed)
	 * - an atmosphere id (use defines please)
	 */
	var/initial_gas_mix = GAS_STRING_TURF_DEFAULT
	//! outdoors
	/**
	 * are we considered outdoors for things like weather effects?
	 * todo: single var doing this is inefficient & bad, flags maybe?
	 * todo: we aren't going to touch this for a while tbh
	 *
	 * possible values:
	 * TRUE - as it implies
	 * FALSE - as it implies
	 * null - use area default
	 */
	var/outdoors = FALSE

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
	 *
	 * Baseturfs can either be a list or a single turf type.
	 * In class definitions it should always be a single type.
	 * A de-duplicated/cached list will be created in init that builds the
	 * baseturf "stack", so that we can access in runtime
	 *
	 * If this is a list, it's bottom first top last (so [1] is bottommost and [length] is topmost)
	 *
	 * To facilitate fast direct reads, we are not putting VAR_PRIVATE on this.
	 *
	 * ? Do not, under any circumstances, attempt to modify this list directly.
	 * ? Helper procs will do that for you. Modfiying the list directly
	 * ? WILL cause cache corruption and mess up the round.
	 */
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
	/// Has the turf been blessed?
	var/blessed = FALSE

	var/list/decals

	/// How much the turf slows down movement, if any.
	var/slowdown = 0
	/// Pathfinding cost; null defaults to slowdown
	var/pathweight

	var/list/footstep_sounds = null

	/// If true, most forms of teleporting to or from this turf tile will fail.
	var/block_tele = FALSE
	/// Used for things like RCDs (and maybe lattices/floor tiles in the future), to see if a floor should replace it.
	var/can_build_into_floor = FALSE
	/// List of 'dangerous' objs that the turf holds that can cause something bad to happen when stepped on, used for AI mobs.
	var/list/dangerous_objects
	/// For if you explicitly want a turf to not be affected by shield generators
	var/noshield = FALSE

	// Some quick notes on the vars below: is_outside should be left set to OUTSIDE_AREA unless you
	// EXPLICITLY NEED a turf to have a different outside state to its area (ie. you have used a
	// roofing tile). By default, it will ask the area for the state to use, and will update on
	// area change. When dealing with weather, it will check the entire z-column for interruptions
	// that will prevent it from using its own state, so a floor above a level will generally
	// override both area is_outside, and turf is_outside. The only time the base value will be used
	// by itself is if you are dealing with a non-multiz level, or the top level of a multiz chunk.

	// Weather relies on is_outside to determine if it should apply to a turf or not and will be
	// automatically updated on ChangeTurf set_outside etc. Don't bother setting it manually, it will
	// get overridden almost immediately.

	// TL;DR: just leave these vars alone.
	// var/tmp/obj/abstract/weather_system/weather
	var/tmp/is_outside = OUTSIDE_AREA

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
/turf/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(FALSE)
	if(atom_flags & ATOM_INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_INITIALIZED

	assemble_baseturfs()

	SETUP_SMOOTHING()

	// queue if necessary; QUEUE_SMOOTH implicitly checks IS_SMOOTH so don't check again
	QUEUE_SMOOTH(src)

	//atom color stuff
	if(color)
		add_atom_colour(color, FIXED_COLOUR_PRIORITY)

	for(var/atom/movable/AM in src)
		Entered(AM)

	var/area/A = loc
	if(!TURF_IS_DYNAMICALLY_LIT_UNSAFE(src))
		add_overlay(/obj/effect/fullbright)

	if (light_power && light_range)
		update_light()

	if (!mapload)
		SSambient_lighting.queued += src

	if (opacity)
		has_opaque_atom = TRUE

	if (mapload && permit_ao)
		queue_ao()

	if (mz_flags & MZ_MIMIC_BELOW)
		setup_zmimic(mapload)

	if(isnull(outdoors))
		outdoors = A.initial_outdoors

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
		vis_contents.len = 0
		var/turf/B = new world.turf(src)
		for(var/A in B.contents)
			qdel(A)
		return
	// SSair.remove_from_active(src)
	// visibilityChanged()
	// QDEL_LIST(blueprint_data)
	atom_flags &= ~ATOM_INITIALIZED
	// requires_activation = FALSE

	if (ao_queued)
		SSao.queue -= src
		ao_queued = 0

	if (mz_flags & MZ_MIMIC_BELOW)
		cleanup_zmimic()

	if (mimic_proxy)
		QDEL_NULL(mimic_proxy)

	// clear vis contents here instead of in Init
	vis_contents.len = 0

	..()

/turf/legacy_ex_act(severity)
	return FALSE

/turf/proc/is_space()
	return FALSE

/turf/proc/is_open()
	return FALSE

/turf/proc/is_intact()
	return FALSE

// Used by shuttle code to check if this turf is empty enough to not crush want it lands on.
/turf/proc/is_solid_structure()
	return TRUE

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
		cost *= ((isnull(pathweight)? slowdown : pathweight) + (isnull(t.pathweight)? t.slowdown : t.pathweight))/2
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
		if(A.density && !(A.atom_flags & ATOM_BORDER))
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

/* // TODO: Implement this. @Zandario
/turf/proc/update_weather(obj/abstract/weather_system/new_weather, force_update_below = FALSE)

	if(isnull(new_weather))
		new_weather = global.weather_by_z["[z]"]

	// We have a weather system and we are exposed to it; update our vis contents.
	if(istype(new_weather) && is_outside())
		if(weather != new_weather)
			if(weather)
				remove_vis_contents(src, weather.vis_contents_additions)
			weather = new_weather
			add_vis_contents(src, weather.vis_contents_additions)
			. = TRUE

	// We are indoors or there is no local weather system, clear our vis contents.
	else if(weather)
		remove_vis_contents(src, weather.vis_contents_additions)
		weather = null
		. = TRUE

	// Propagate our weather downwards if we permit it.
	if(force_update_below || (is_open() && .))
		var/turf/below = GetBelow(src)
		if(below)
			below.update_weather(new_weather)
*/

/turf/proc/is_outside()

	// Can't rain inside or through solid walls.
	// TODO: dense structures like full windows should probably also block weather.
	if(density)
		return OUTSIDE_NO

	// What would we like to return in an ideal world?
	if(is_outside == OUTSIDE_AREA)
		var/area/A = get_area(src)
		. = A ? A.is_outside : OUTSIDE_NO
	else
		. = is_outside

	// Notes for future self when confused: is_open() on higher
	// turfs must match effective is_outside value if the turf
	// should get to use the is_outside value it wants to. If it
	// doesn't line up, we invert the outside value (roof is not
	// open but turf wants to be outside, invert to OUTSIDE_NO).

	// Do we have a roof over our head? Should we care?
	if(HasAbove(z))
		var/turf/top_of_stack = src
		while(HasAbove(top_of_stack.z))
			top_of_stack = GetAbove(top_of_stack)
			if(top_of_stack.is_open() != . || (top_of_stack.is_outside != OUTSIDE_AREA && top_of_stack.is_outside != .))
				return !.

/turf/proc/set_outside(new_outside, skip_weather_update = FALSE)
	if(is_outside != new_outside)
		is_outside = new_outside
		// if(!skip_weather_update)
		// 	update_weather()
		SSambient_lighting.queued += src
		return TRUE
	return FALSE
