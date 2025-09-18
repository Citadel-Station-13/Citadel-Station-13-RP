/// Any floor or wall. What makes up the station and the rest of the map.
/turf
	abstract_type = /turf
	icon = 'icons/turf/floors.dmi'
	luminosity = 1

	//* Default turf inbuilts *//

	layer = TURF_LAYER
	plane = TURF_PLANE
	opacity = FALSE
	density = FALSE
	alpha = 255

	//* Atmospherics
	/**
	 * the gas we start out as
	 * can be:
	 * - a gas string (will be parsed)
	 * - an atmosphere id (use defines please)
	 */
	var/initial_gas_mix = GAS_STRING_TURF_DEFAULT
	/**
	 * Act like a specific temperature for heat exchanger pipes.
	 */
	var/temperature_for_heat_exchangers

	//* Automata
	/// acted automata - automata associated to power, act_cross() will be called when something enters us while this is set
	var/list/acting_automata

	//* Baseturfs / Turf Changing
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

	//* Flags
	/// turf flags
	var/turf_flags = NONE
	/// multiz flags
	var/mz_flags = MZ_ATMOS_UP | MZ_OPEN_UP

	//* Movement / Pathfinding
	/// How much the turf slows down movement, if any.
	var/slowdown = 0
	/// Pathfinding cost
	var/path_weight = 1
	/// danger flags to avoid
	var/turf_path_danger = NONE
	/// pathfinding id - used to avoid needing a big closed list to iterate through every cycle of jps
	var/tmp/pathfinding_cycle

	//* Outdoors
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
	var/outdoors = null

	//* Radiation
	/// cached rad insulation of contents
	var/rad_insulation_contents = 1

	// Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	// Properties for both
	/// Initial turf temperature.
	var/temperature = T20C
	/// Does this turf contain air/let air through?
	var/blocks_air = FALSE


	var/holy = 0

	/// Icon-smoothing variable to map a diagonal wall corner with a fixed underlay.
	var/list/fixed_underlay = null

	// General properties.
	var/icon_old = null
	/// Has the turf been blessed?
	var/blessed = FALSE

	var/list/decals

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
	var/static/list/banned_edits = list(
		NAMEOF_TYPE(/turf, x),
		NAMEOF_TYPE(/turf, y),
		NAMEOF_TYPE(/turf, z),
	)
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

	QUEUE_SMOOTH(src)

	//atom color stuff
	if(color)
		add_atom_color(color)

	// todo: uh oh.
	// TODO: what would tg do (but maybe not that much component signal abuse?)
	// this is to trigger entered effects
	// bad news is this is not necessarily currently idempotent
	// we probably have to deal with this at.. some point.
	for(var/atom/movable/content as anything in src)
		Entered(content)

	var/area/A = loc

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
	if(!(atom_flags & ATOM_INITIALIZED))
		STACK_TRACE("Turf destroyed without initializing.")
	. = QDEL_HINT_IWILLGC
	if(!changing_turf)
		STACK_TRACE("Incorrect turf deletion")
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
	if(length(vis_contents))
		vis_contents.Cut()

	..()

/// WARNING WARNING
/// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
/// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
/// We do it because moving signals over was needlessly expensive, and bloated a very commonly used bit of code
/turf/clear_signal_refs()
	return

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

/turf/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	. = ..()
	if(.)
		return
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

	if(!CHECK_MOBILITY(user, MOBILITY_CAN_MOVE) || user.restrained() || !(user.pulling))
		return FALSE
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return FALSE
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return FALSE
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t, suppress_message = TRUE)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return TRUE

/turf/attack_ai(mob/user as mob) //this feels like a bad idea ultimately but this is the cheapest way to let cyborgs nudge things they're pulling around
	. = ..()
	if(Adjacent(user))
		var/datum/event_args/actor/clickchain/clickchain = user.default_clickchain_event_args(src)
		attack_hand(user, clickchain)

/turf/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(I.obj_storage?.allow_mass_gather && I.obj_storage.allow_mass_gather_via_click)
		I.obj_storage.auto_handle_interacted_mass_pickup(new /datum/event_args/actor(user), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return ..()

// Hits a mob on the tile.
// todo: redo this
// /turf/proc/attack_tile(obj/item/W, mob/living/user)
// 	if(!istype(W))
// 		return FALSE

// 	var/list/viable_targets = list()
// 	var/success = FALSE	// Hitting something makes this true. If its still false, the miss sound is played.

// 	for(var/mob/living/L in contents)
// 		if(L == user)	// Don't hit ourselves.
// 			continue
// 		viable_targets += L

// 	if(!viable_targets.len)	// No valid targets on this tile.
// 		if(W.can_cleave)
// 			success = W.cleave(user, src)
// 	else
// 		var/mob/living/victim = pick(viable_targets)
// 		success = W.resolve_attackby(victim, user)

// 	user.setClickCooldownLegacy(user.get_attack_speed_legacy(W))
// 	user.do_attack_animation(src, no_attack_icons = TRUE)

// 	if(!success)	// Nothing got hit.
// 		user.visible_message("<span class='warning'>\The [user] swipes \the [W] over \the [src].</span>")
// 		playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
// 	return success

/turf/MouseDroppedOnLegacy(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if(!ismob(O))
		return
	var/mob/M = O
	if(user == M && IS_STANDING(user))
		return
	if((istype(A) && !(A.has_gravity)) || (istype(T,/turf/space)))
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return
	if(M.pulledby || M.is_grabbed())
		return
	if(!CHECK_MOBILITY(user, user == M? MOBILITY_IS_CONSCIOUS : MOBILITY_CAN_USE))
		return
	if (do_after(user, 2.5 SECONDS, mobility_flags = user == M? MOBILITY_IS_CONSCIOUS : MOBILITY_CAN_USE))
		if(M.pulledby || M.is_grabbed())
			return
		step_towards(M, src)
		animate(M, transform = turn(O.transform, 20), time = 2)
		sleep(2)
		animate(M, transform = turn(O.transform, -40), time = 4)
		sleep(4)
		animate(M, transform = turn(O.transform, 20), time = 2)
		sleep(2)
		M.update_transform()


/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

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
		cost *= ((isnull(path_weight)? slowdown : path_weight) + (isnull(t.path_weight)? t.slowdown : t.path_weight))/2
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

/turf/drop_location()
	return src

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
	var/turf/top_of_stack = src
	while((top_of_stack = top_of_stack.above()))
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

//* Atom Color - we don't use the expensive system. *//

/turf/get_atom_color()
	return color

/turf/add_atom_color(coloration, colour_priority)
	color = coloration

/turf/remove_atom_color(colour_priority, coloration)
	color = null

/turf/update_atom_color()
	return

/turf/copy_atom_color(atom/other, colour_priority)
	if(isnull(other.color))
		return
	color = other.color

//* Depth *//

/**
 * gets overall depth level for stuff standing on us
 */
/turf/proc/depth_level()
	. = 0
	for(var/obj/O in src)
		if(!O.depth_projected)
			continue
		. = max(., O.depth_level)

//* Multiz *//

/**
 * Update multiz linkage. This is done when a zlevel rebuilds its multiz state.
 *
 * todo: maybe include params for 'z_offset_up', 'z_offset_down'? manuallly fetching on
 *       every turf is slow as balls.
 */
/turf/proc/update_multiz()
	return

//* Orientation *//

/**
 * Are we a valid anchor or orientation source for a wall-mounted object?
 *
 * If so, return the anchor object.
 */
/turf/proc/get_wallmount_anchor()
	RETURN_TYPE(/atom)
	// are we valid
	if(GLOB.wallframe_typecache[type])
		return src
	// are our contents valid
	for(var/obj/O in contents)
		if(GLOB.wallframe_typecache[O.type])
			return O

//* Sector API *//

/**
 * called by planet / weather to update temperature during weather changes
 *
 * todo: this is bad lol this either needs more specifications/documentation or a redesign
 */
/turf/proc/sector_set_temperature(temperature)
	return

//* Radiation *//

/turf/proc/update_rad_insulation()
	rad_insulation_contents = 1

//* Underfloor *//

/**
 * returns if we should hide underfloor objects
 *
 * * override this on child types for speed!
 * * if the turf has an is_plating() override, it probably needs an override for this!
 *
 * @return a truthy value. Do not use this value for anything else; all we care is whether or not it's truthy.
 */
/turf/proc/hides_underfloor_objects()
	return !is_plating()

/**
 * tell all objects on us to reconsider their underfloor status
 *
 * we are always called at mapload by turfs that can hide underfloor objects,
 * because objs are configured to only check themselves outside of mapload.
 */
/turf/proc/update_underfloor_objects()
	var/we_should_cover = hides_underfloor_objects()
	for(var/obj/thing in contents)
		if(thing.hides_underfloor == OBJ_UNDERFLOOR_UNSUPPORTED)
			continue
		thing.update_hiding_underfloor(
			(thing.hides_underfloor != OBJ_UNDERFLOOR_NEVER) && we_should_cover,
		)

//* VV *//

/turf/vv_delete()
	ScrapeAway()
