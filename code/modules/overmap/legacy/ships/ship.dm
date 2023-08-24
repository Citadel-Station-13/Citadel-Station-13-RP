// renamed because why the hell did you name it CHANGE_SPEED_BY
#define PENALIZED_SPEED_CHANGE(speed_var, v_diff) \
	v_diff = QUANTIZE_OVERMAP_DISTANCE(v_diff);\
	if(!QUANTIZE_OVERMAP_DISTANCE(speed_var + v_diff)) \
		{speed_var = 0};\
	else \
		{speed_var = QUANTIZE_OVERMAP_DISTANCE((speed_var + v_diff)/(1 + speed_var*v_diff/(max_speed ** 2)))}
// Uses Lorentzian dynamics to avoid going too fast.

// todo: /obj/overmap/entity
/obj/overmap/entity/visitable/ship
	name = "spacecraft"
	desc = "This marker represents a spaceship. Scan it for more information."
	scanner_desc = "Unknown spacefaring vessel."
	dir = NORTH
	icon_state = "ship"
	appearance_flags = TILE_BOUND|KEEP_TOGETHER|LONG_GLIDE
	glide_size = 8
	var/moving_state = "ship_moving"

	/// Tonnes, arbitrary number, affects acceleration provided by engines.
	var/vessel_mass = 10000
	/// Arbitrary number, affects how likely are we to evade meteors.
	var/vessel_size = SHIP_SIZE_LARGE

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

/obj/overmap/entity/visitable/ship/Initialize(mapload)
	. = ..()
	// rotation support
	if(dir != NORTH)
		fore_dir = turn(fore_dir, -dir2angle(dir))
	SSshuttle.ships += src

/obj/overmap/entity/visitable/ship/Destroy()
	SSshuttle.ships -= src
	. = ..()

//? todo why tf is this relaymove
/obj/overmap/entity/visitable/ship/relaymove(mob/user, direction, accel_limit)
	accelerate(direction, accel_limit)

/obj/overmap/entity/visitable/ship/get_scan_data(mob/user)
	. = ..()

	if(!!is_moving())
		. += {"\n\[i\]Heading\[/i\]: [get_heading()]\n\[i\]Velocity\[/i\]: [get_speed_legacy() * 1000]"}
	else
		. += {"\n\[i\]Vessel was stationary at time of scan.\[/i\]\n"}

	var/life = 0

	for(var/mob/living/L in living_mob_list)
		if(L.z in map_z) //Things inside things we'll consider shielded, otherwise we'd want to use get_z(L)
			life++

	. += {"\[i\]Life Signs\[/i\]: [life ? life : "None"]"}

// Projected acceleration based on information from engines
/obj/overmap/entity/visitable/ship/proc/get_acceleration_legacy()
	return round(get_total_thrust()/get_vessel_mass(), OVERMAP_DISTANCE_ACCURACY)

// Does actual burn and returns the resulting acceleration
/obj/overmap/entity/visitable/ship/proc/get_burn_acceleration_legacy()
	return round(burn() / get_vessel_mass(), OVERMAP_DISTANCE_ACCURACY)

/obj/overmap/entity/visitable/ship/proc/get_vessel_mass()
	. = vessel_mass
	for(var/obj/overmap/entity/visitable/ship/ship in src)
		. += ship.get_vessel_mass()

/**
 * ! legacy
 *
 * get speed in tiles / decisecond
 */
/obj/overmap/entity/visitable/ship/proc/get_speed_legacy()
	return OVERMAP_DIST_TO_PIXEL(get_speed()) / WORLD_ICON_SIZE / 10

// Get heading in BYOND dir bits
/obj/overmap/entity/visitable/ship/proc/get_heading_direction()
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

/obj/overmap/entity/visitable/ship/proc/adjust_speed(n_x, n_y)
	var/old_still = !is_moving()
	PENALIZED_SPEED_CHANGE(vel_x, n_x)
	PENALIZED_SPEED_CHANGE(vel_y, n_y)
	// funny; this proc isn't optimized so we abuse it to do our work so i don't have to refactor adjust_speed
	set_velocity(vel_x, vel_y)
	update_icon()
	var/still = !is_moving()
	if(still == old_still)
		return
	else if(still)
		for(var/zz in map_z)
			SSparallax.update_z_motion(zz)
			// fuck you we're extra brutal today, decelration kills you too!
			SSmapping.throw_movables_on_z_turfs_of_type(zz, /turf/space, fore_dir)
	else
		glide_size = WORLD_ICON_SIZE/max(DS2TICKS(SSprocessing.wait), 1)	// Down to whatever decimal
		for(var/zz in map_z)
			SSparallax.update_z_motion(zz)
			SSmapping.throw_movables_on_z_turfs_of_type(zz, /turf/space, global.reverse_dir[fore_dir])

/obj/overmap/entity/visitable/ship/proc/get_brake_path()
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

/obj/overmap/entity/visitable/ship/proc/decelerate()
	if(is_moving() && can_burn())
		var/deceleration = get_burn_acceleration_legacy()
		//? shim: convert to new overmaps units from old
		//? old was, for some stupid reason, "turfs per decosecond".
		deceleration = deceleration * OVERMAP_DISTANCE_TILE * 10
		adjust_speed(-SIGN(vel_x) * min(deceleration,abs(vel_x)), -SIGN(vel_y) * min(deceleration,abs(vel_y)))
		last_burn = world.time

/obj/overmap/entity/visitable/ship/proc/accelerate(direction, accel_limit)
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

/obj/overmap/entity/visitable/ship/update_icon()
	if(!!is_moving())
		icon_state = moving_state
		transform = matrix().Turn(get_heading())
	else
		icon_state = initial(icon_state)
		transform = null
	..()

/obj/overmap/entity/visitable/ship/setDir(new_dir)
	return ..(NORTH)	// NO! We always face north.

/obj/overmap/entity/visitable/ship/proc/burn()
	for(var/datum/ship_engine/E in engines)
		. += E.burn()

/obj/overmap/entity/visitable/ship/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/overmap/entity/visitable/ship/proc/can_burn()
	if(halted)
		return 0
	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()

// Deciseconds to next step
/obj/overmap/entity/visitable/ship/proc/ETA()
	. = INFINITY
	if(vel_x)
		var/offset = MODULUS(OVERMAP_DIST_TO_PIXEL(pos_x), WORLD_ICON_SIZE)
		var/dist_to_go = (vel_x > 0) ? (WORLD_ICON_SIZE - offset) : offset
		. = min(., (dist_to_go / OVERMAP_DIST_TO_PIXEL(abs(vel_x))) * 10)
	if(vel_y)
		var/offset = MODULUS(OVERMAP_DIST_TO_PIXEL(pos_y), WORLD_ICON_SIZE)
		var/dist_to_go = (vel_y > 0) ? (WORLD_ICON_SIZE - offset) : offset
		. = min(., (dist_to_go / OVERMAP_DIST_TO_PIXEL(abs(vel_y))) * 10)
	. = max(., 0)

/obj/overmap/entity/visitable/ship/proc/halt()
	adjust_speed(-vel_x, -vel_y)
	halted = 1

/obj/overmap/entity/visitable/ship/proc/unhalt()
	if(!SSshuttle.overmap_halted)
		halted = 0

/obj/overmap/entity/visitable/ship/populate_sector_objects()
	..()
	for(var/obj/machinery/computer/ship/S in GLOB.machines)
		S.attempt_hook_up(src)
	for(var/datum/ship_engine/E in ship_engines)
		if(check_ownership(E.holder))
			engines |= E

/obj/overmap/entity/visitable/ship/proc/get_landed_info()
	return "This ship cannot land."

/obj/overmap/entity/visitable/ship/get_distress_info()
	var/turf/T = get_turf(src) // Usually we're on the turf, but sometimes we might be landed or something.
	var/x_to_use = T?.x || "UNK"
	var/y_to_use = T?.y || "UNK"
	return "\[X:[x_to_use], Y:[y_to_use], VEL:[get_speed_legacy() * 1000], HDG:[get_heading()]\]"

/obj/overmap/entity/visitable/ship/set_glide_size(new_glide_size, recursive)
	return	// *no*.
