// renamed because why the hell did you name it CHANGE_SPEED_BY
#define PENALIZED_SPEED_CHANGE(speed_var, v_diff) \
	v_diff = QUANTIZE_OVERMAP_DISTANCE(v_diff);\
	if(!QUANTIZE_OVERMAP_DISTANCE(speed_var + v_diff)) \
		{speed_var = 0};\
	else \
		{speed_var = QUANTIZE_OVERMAP_DISTANCE((speed_var + v_diff)/(1 + speed_var*v_diff/(max_speed ** 2)))}
// Uses Lorentzian dynamics to avoid going too fast.

// todo: /obj/overmap/entity
/obj/effect/overmap/visitable/ship
	name = "spacecraft"
	desc = "This marker represents a spaceship. Scan it for more information."
	scanner_desc = "Unknown spacefaring vessel."
	dir = NORTH
	icon_state = "ship"
	appearance_flags = TILE_BOUND|KEEP_TOGETHER|LONG_GLIDE
	glide_size = 8
	var/moving_state = "ship_moving"

	//! identity
	/// id
	var/id
	/// next id
	var/static/id_next = 0


	/// Tonnes, arbitrary number, affects acceleration provided by engines.
	var/vessel_mass = 10000
	/// Arbitrary number, affects how likely are we to evade meteors.
	var/vessel_size = SHIP_SIZE_LARGE

	/// Pixel coordinates in the world.
	var/position_x
	/// Pixel coordinates in the world.
	var/position_y
	/// velocity x in overmap units per second
	var/vel_x
	/// velocity y in overmap units per second
	var/vel_y
	/// max speed in overmap units per second
	var/max_speed = OVERMAP_DISTANCE_TILE
	/// Worldtime when ship last acceleated.
	var/last_burn = 0
	/// How often ship can do burns.
	var/burn_delay = 1 SECOND
	/// What dir ship flies towards for purpose of moving stars effect procs.
	var/fore_dir = NORTH

	/// The list of all the engines we have.
	var/list/engines = list()
	/// Global on/off toggle for all engines.
	var/engines_state = 0
	/// Global thrust limit for all engines, 0..1
	var/thrust_limit = 1
	/// Admin halt or other stop.
	var/halted = 0
	/// Skill needed to steer it without going in random dir.
	var/skill_needed = SKILL_NONE //We don't like skills.
	var/operator_skill

/obj/effect/overmap/visitable/ship/New()
	// assign id immediately
	id = "[++id_next]"
	return ..()

/obj/effect/overmap/visitable/ship/Initialize(mapload)
	. = ..()
	SSshuttle.ships += src
	position_x = ((loc.x - 1) * WORLD_ICON_SIZE) + (WORLD_ICON_SIZE/2) + pixel_x + 1
	position_y = ((loc.y - 1) * WORLD_ICON_SIZE) + (WORLD_ICON_SIZE/2) + pixel_y + 1

/obj/effect/overmap/visitable/ship/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	SSshuttle.ships -= src
	. = ..()

//? todo why tf is this relaymove
/obj/effect/overmap/visitable/ship/relaymove(mob/user, direction, accel_limit)
	accelerate(direction, accel_limit)

/obj/effect/overmap/visitable/ship/get_scan_data(mob/user)
	. = ..()

	if(!!is_moving())
		. += {"\n\[i\]Heading\[/i\]: [get_heading_degrees()]\n\[i\]Velocity\[/i\]: [get_speed_legacy() * 1000]"}
	else
		. += {"\n\[i\]Vessel was stationary at time of scan.\[/i\]\n"}

	var/life = 0

	for(var/mob/living/L in living_mob_list)
		if(L.z in map_z) //Things inside things we'll consider shielded, otherwise we'd want to use get_z(L)
			life++

	. += {"\[i\]Life Signs\[/i\]: [life ? life : "None"]"}

// Projected acceleration based on information from engines
/obj/effect/overmap/visitable/ship/proc/get_acceleration_legacy()
	return round(get_total_thrust()/get_vessel_mass(), OVERMAP_DISTANCE_ACCURACY)

// Does actual burn and returns the resulting acceleration
/obj/effect/overmap/visitable/ship/proc/get_burn_acceleration_legacy()
	return round(burn() / get_vessel_mass(), OVERMAP_DISTANCE_ACCURACY)

/obj/effect/overmap/visitable/ship/proc/get_vessel_mass()
	. = vessel_mass
	for(var/obj/effect/overmap/visitable/ship/ship in src)
		. += ship.get_vessel_mass()

/**
 * ! legacy
 *
 * get speed in tiles / decisecond
 */
/obj/effect/overmap/visitable/ship/proc/get_speed_legacy()
	. = QUANTIZE_OVERMAP_DISTANCE(sqrt(vel_x ** 2 + vel_y ** 2))
	. = OVERMAP_DIST_TO_PIXEL(.) / WORLD_ICON_SIZE / 10

// Get heading in BYOND dir bits
/obj/effect/overmap/visitable/ship/proc/get_heading()
	var/res = NONE
	if(vel_x)
		if(vel_x > 0)
			res |= EAST
		else
			res |= WEST
	if(vel_y)
		if(vel_y > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

// Get heading in degrees (like a compass heading)
/obj/effect/overmap/visitable/ship/proc/get_heading_degrees()
	return (arctan(vel_y, vel_x) + 360) % 360	// Yes ATAN2(y, x) is correct to get clockwise degrees

/obj/effect/overmap/visitable/ship/proc/adjust_speed(n_x, n_y)
	var/old_still = !is_moving()
	PENALIZED_SPEED_CHANGE(vel_x, n_x)
	PENALIZED_SPEED_CHANGE(vel_y, n_y)
	update_icon()
	var/still = !is_moving()
	if(still == old_still)
		return
	else if(still)
		STOP_PROCESSING(SSprocessing, src)
		for(var/zz in map_z)
			SSparallax.update_z_motion(zz)
			// fuck you we're extra brutal today, decelration kills you too!
			SSmapping.throw_movables_on_z_turfs_of_type(zz, /turf/space, fore_dir)
	else
		START_PROCESSING(SSprocessing, src)
		glide_size = WORLD_ICON_SIZE/max(DS2TICKS(SSprocessing.wait), 1)	// Down to whatever decimal
		for(var/zz in map_z)
			SSparallax.update_z_motion(zz)
			SSmapping.throw_movables_on_z_turfs_of_type(zz, /turf/space, REVERSE_DIR(fore_dir))

/obj/effect/overmap/visitable/ship/proc/get_brake_path()
	if(!get_acceleration_legacy())
		return INFINITY
	if(!is_moving())
		return 0
	if(!burn_delay)
		return 0
	if(!get_speed_legacy())
		return 0
	var/num_burns = get_speed_legacy()/get_acceleration_legacy() + 2	// Some padding in case acceleration drops form fuel usage
	var/burns_per_grid = 1/ (burn_delay * get_speed_legacy())
	return round(num_burns/burns_per_grid)

/obj/effect/overmap/visitable/ship/proc/decelerate()
	if(is_moving() && can_burn())
		var/deceleration = get_burn_acceleration_legacy()
		//? shim: convert to new overmaps units from old
		//? old was, for some stupid reason, "turfs per decosecond".
		deceleration = deceleration * OVERMAP_DISTANCE_TILE * 10
		adjust_speed(-SIGN(vel_x) * min(deceleration,abs(vel_x)), -SIGN(vel_y) * min(deceleration,abs(vel_y)))
		last_burn = world.time

/obj/effect/overmap/visitable/ship/proc/accelerate(direction, accel_limit)
	if(can_burn())
		last_burn = world.time
		var/acceleration = min(get_burn_acceleration_legacy(), accel_limit)
		//? shim: convert to new overmaps units from old
		//? old was, for some stupid reason, "turfs per decosecond".
		acceleration = acceleration * OVERMAP_DISTANCE_TILE * 10

		if(direction & EAST)
			adjust_speed(acceleration, 0)
		if(direction & WEST)
			adjust_speed(-acceleration, 0)
		if(direction & NORTH)
			adjust_speed(0, acceleration)
		if(direction & SOUTH)
			adjust_speed(0, -acceleration)

/obj/effect/overmap/visitable/ship/process(delta_time)
	var/new_position_x = position_x + (OVERMAP_DIST_TO_PIXEL(vel_x) * delta_time)
	var/new_position_y = position_y + (OVERMAP_DIST_TO_PIXEL(vel_y) * delta_time)

	// For simplicity we assume that you can't travel more than one turf per tick.  That would be hella-fast.
	var/new_turf_x = CEILING(new_position_x / WORLD_ICON_SIZE, 1)
	var/new_turf_y = CEILING(new_position_y / WORLD_ICON_SIZE, 1)

	var/new_pixel_x = MODULUS(new_position_x, WORLD_ICON_SIZE) - (WORLD_ICON_SIZE/2) - 1
	var/new_pixel_y = MODULUS(new_position_y, WORLD_ICON_SIZE) - (WORLD_ICON_SIZE/2) - 1

	var/new_loc = locate(new_turf_x, new_turf_y, z)

	position_x = new_position_x
	position_y = new_position_y

	if(new_loc != loc)
		var/turf/old_loc = loc
		Move(new_loc, NORTH, delta_time * 10)
		if(get_dist(old_loc, loc) > 1)
			pixel_x = new_pixel_x
			pixel_y = new_pixel_y
			return
	// todo: actual animations
	animate(src, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = 8, flags = ANIMATION_END_NOW)

// If we get moved, update our internal tracking to account for it
/obj/effect/overmap/visitable/ship/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	// If moving out of another sector start off centered in the turf.
	if(!isturf(old_loc))
		position_x = (WORLD_ICON_SIZE/2) + 1
		position_y = (WORLD_ICON_SIZE/2) + 1
		pixel_x = 0
		pixel_y = 0
	position_x = ((loc.x - 1) * WORLD_ICON_SIZE) + MODULUS(position_x, WORLD_ICON_SIZE)
	position_y = ((loc.y - 1) * WORLD_ICON_SIZE) + MODULUS(position_y, WORLD_ICON_SIZE)


/obj/effect/overmap/visitable/ship/update_icon()
	if(!!is_moving())
		icon_state = moving_state
		transform = matrix().Turn(get_heading_degrees())
	else
		icon_state = initial(icon_state)
		transform = null
	..()

/obj/effect/overmap/visitable/ship/setDir(new_dir)
	return ..(NORTH)	// NO! We always face north.

/obj/effect/overmap/visitable/ship/proc/burn()
	for(var/datum/ship_engine/E in engines)
		. += E.burn()

/obj/effect/overmap/visitable/ship/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/effect/overmap/visitable/ship/proc/can_burn()
	if(halted)
		return 0
	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()

// Deciseconds to next step
/obj/effect/overmap/visitable/ship/proc/ETA()
	. = INFINITY
	if(vel_x)
		var/offset = MODULUS(position_x, WORLD_ICON_SIZE)
		var/dist_to_go = (vel_x > 0) ? (WORLD_ICON_SIZE - offset) : offset
		. = min(., (dist_to_go / OVERMAP_DIST_TO_PIXEL(abs(vel_x))) * 10)
	if(vel_y)
		var/offset = MODULUS(position_y, WORLD_ICON_SIZE)
		var/dist_to_go = (vel_y > 0) ? (WORLD_ICON_SIZE - offset) : offset
		. = min(., (dist_to_go / OVERMAP_DIST_TO_PIXEL(abs(vel_y))) * 10)
	. = max(., 0)

/obj/effect/overmap/visitable/ship/proc/halt()
	adjust_speed(-vel_x, -vel_y)
	halted = 1

/obj/effect/overmap/visitable/ship/proc/unhalt()
	if(!SSshuttle.overmap_halted)
		halted = 0

/obj/effect/overmap/visitable/ship/populate_sector_objects()
	..()
	for(var/obj/machinery/computer/ship/S in GLOB.machines)
		S.attempt_hook_up(src)
	for(var/datum/ship_engine/E in ship_engines)
		if(check_ownership(E.holder))
			engines |= E

/obj/effect/overmap/visitable/ship/proc/get_landed_info()
	return "This ship cannot land."

/obj/effect/overmap/visitable/ship/get_distress_info()
	var/turf/T = get_turf(src) // Usually we're on the turf, but sometimes we might be landed or something.
	var/x_to_use = T?.x || "UNK"
	var/y_to_use = T?.y || "UNK"
	return "\[X:[x_to_use], Y:[y_to_use], VEL:[get_speed_legacy() * 1000], HDG:[get_heading_degrees()]\]"

/obj/effect/overmap/visitable/ship/set_glide_size(new_glide_size, recursive)
	return	// *no*.
