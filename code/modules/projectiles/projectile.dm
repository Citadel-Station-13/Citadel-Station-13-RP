#define MOVES_HITSCAN -1		//Not actually hitscan but close as we get without actual hitscan.
#define MUZZLE_EFFECT_PIXEL_INCREMENT 15	//How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	pass_flags = PASSTABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	////TG PROJECTILE SYTSEM
	//Projectile stuff
	var/range = 50
	var/originalRange

	var/override_pixel_speed				//DO NOT TOUCH THESE TWO VARS UNLESS YOU KNOW EXACTLY WHAT YOU ARE DOING.
	var/override_pixel_iterations

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/ignore_source_check = FALSE
	var/paused = FALSE	//for suspending the projectile midair
	var/last_projectile_move = 0
	var/last_process = 0
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!

	var/speed = 0.8			//Amount of deciseconds it takes for projectile to travel
	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/spread = 0			//amount (in degrees) of projectile spread
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/ricochets = 0
	var/ricochets_max = 2
	var/ricochet_chance = 30

	//Hitscan
	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	var/list/beam_segments	//assoc list of datum/point or datum/point/vector, start = end. Used for hitscan effect generation.
	var/datum/point/beam_index
	var/turf/hitscan_last	//last turf touched during hitscanning.
	var/tracer_type
	var/muzzle_type
	var/impact_type

	//Fancy hitscan lighting effects!
	var/hitscan_light_intensity = 1.5
	var/hitscan_light_range = 0.75
	var/hitscan_light_color_override
	var/muzzle_flash_intensity = 3
	var/muzzle_flash_range = 1.5
	var/muzzle_flash_color_override
	var/impact_light_intensity = 3
	var/impact_light_range = 2
	var/impact_light_color_override

	//Homing
	var/homing = FALSE
	var/atom/homing_target
	var/homing_turn_speed = 10		//Angle per tick.
	var/homing_inaccuracy_min = 0		//in pixels for these. offsets are set once when setting target.
	var/homing_inaccuracy_max = 0
	var/homing_offset_x = 0
	var/homing_offset_y = 0

	//Targetting
	var/yo = null
	var/xo = null
	var/atom/original		// the original target clicked
	var/turf/starting	// the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	//Misc/Polaris variables

	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = PROJECTILE_SILENCE_NORMAL	//Attack message
	var/shot_from = "" // name of the object which shot us

	var/accuracy = 0
	var/dispersion = 0.0

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE, HALLOSS are the only things that should be in here
	var/SA_bonus_damage = 0 // Some bullets inflict extra damage on simple animals.
	var/SA_vulnerability = null // What kind of simple animal the above bonus damage should be applied to. Set to null to apply to all SAs.
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	var/check_armour = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb	//Cael - bio and rad are also valid
	var/projectile_type = /obj/item/projectile
	var/penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
		//Effects
	var/incendiary = 0 //1 for ignite on hit, 2 for trail of fire. 3 maybe later for burst of fire around the impact point. - Mech
	var/flammability = 0 //Amount of fire stacks to add for the above.
	var/combustion = TRUE	//Does this set off flammable objects on fire/hit?
	var/stun = 0
	var/weaken = 0
	var/paralyze = 0
	var/irradiate = 0
	var/stutter = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/agony = 0
	var/reflected = 0 // This should be set to 1 if reflected by any means, to prevent infinite reflections.
	var/modifier_type_to_apply = null // If set, will apply a modifier to mobs that are hit by this projectile.
	var/modifier_duration = null // How long the above modifier should last for. Leave null to be permanent.

	embed_chance = 0	//Base chance for a projectile to embed

	var/fire_sound = 'sound/weapons/Gunshot_old.ogg' // Can be overriden in gun.dm's fire_sound var. It can also be null but I don't know why you'd ever want to do that. -Ace

	var/vacuum_traversal = TRUE //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	var/temporary_unstoppable_movement = FALSE

	var/auto_penetrate_amount = 0			//Penetrates this amount.

/obj/item/projectile/proc/Range()
	range--
	if(range <= 0 && loc)
		on_range()

/obj/item/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	on_impact(get_turf(src))
	qdel(src)

/obj/item/projectile/proc/return_predicted_turf_after_moves(moves, forced_angle)		//I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, (override_pixel_speed || SSprojectiles.global_pixel_speed))
	var/datum/point/vector/v = current.return_vector_after_increments(moves * (override_pixel_iterations || SSprojectiles.global_iterations_per_move))
	return v.return_turf()

/obj/item/projectile/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return getline(current, ending)

/obj/item/projectile/proc/set_pixel_speed(new_speed)
	if(trajectory)
		trajectory.set_speed(new_speed)
		return TRUE
	return FALSE

/obj/item/projectile/proc/record_hitscan_start(datum/point/pcache)
	if(pcache)
		beam_segments = list()
		beam_index = pcache
		beam_segments[beam_index] = null	//record start.

/obj/item/projectile/proc/process_hitscan()
	var/safety = range * 3
	record_hitscan_start(RETURN_POINT_VECTOR_INCREMENT(src, Angle, MUZZLE_EFFECT_PIXEL_INCREMENT, 1))
	while(loc && !QDELETED(src))
		if(paused)
			stoplag(1)
			continue
		if(safety-- <= 0)
			if(loc)
				Bump(loc)
			if(!QDELETED(src))
				qdel(src)
			return	//Kill!
		pixel_move(1, TRUE)

/obj/item/projectile/proc/pixel_move(trajectory_multiplier, hitscanning = FALSE)
	if(!loc || !trajectory)
		return
	last_projectile_move = world.time
	if(homing)
		process_homing()
	var/forcemoved = FALSE
	var/moves = (override_pixel_iterations || SSprojectiles.global_iterations_per_move) * trajectory_multiplier
	for(var/i in 1 to moves)
		if(QDELETED(src))
			return
		trajectory.increment()
		var/turf/T = trajectory.return_turf()
		if(!istype(T))
			qdel(src)
			return
		if(T.z != loc.z)
			var/old = loc
			before_z_change(loc, T)
			trajectory_ignore_forcemove = TRUE
			forceMove(T)
			trajectory_ignore_forcemove = FALSE
			after_z_change(old, loc)
			if(!hitscanning)
				pixel_x = trajectory.return_px()
				pixel_y = trajectory.return_py()
			forcemoved = TRUE
			hitscan_last = loc
		else if(T != loc)
			before_move()
			step_towards(src, T)
			hitscan_last = loc
			after_move()
		if(can_hit_target(original, permutated))
			Bump(original)
	if(!hitscanning && !forcemoved)
		pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier * (override_pixel_iterations || SSprojectiles.global_iterations_per_move)
		pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier * (override_pixel_iterations || SSprojectiles.global_iterations_per_move)
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	Range()

/obj/item/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	..()
	if(isliving(AM) && (AM.density || AM == original))
		Bump(AM)

/obj/item/projectile/proc/process_homing()			//may need speeding up in the future performance wise.
	if(!homing_target)
		return FALSE
	var/datum/point/PT = RETURN_PRECISE_POINT(homing_target)
	PT.x += CLAMP(homing_offset_x, 1, world.maxx)
	PT.y += CLAMP(homing_offset_y, 1, world.maxy)
	var/angle = closer_angle_difference(Angle, angle_between_points(RETURN_PRECISE_POINT(src), PT))
	setAngle(Angle + CLAMP(angle, -homing_turn_speed, homing_turn_speed))

/obj/item/projectile/proc/set_homing_target(atom/A)
	if(!A || (!isturf(A) && !isturf(A.loc)))
		return FALSE
	homing = TRUE
	homing_target = A
	homing_offset_x = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	homing_offset_y = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	if(prob(50))
		homing_offset_x = -homing_offset_x
	if(prob(50))
		homing_offset_y = -homing_offset_y

/obj/item/projectile/process()
	last_process = world.time
	if(!loc || !fired || !trajectory)
		fired = FALSE
		return PROCESS_KILL
	if(paused || !isturf(loc))
		last_projectile_move += world.time - last_process		//Compensates for pausing, so it doesn't become a hitscan projectile when unpaused from charged up ticks.
		return
	var/elapsed_time_deciseconds = (world.time - last_projectile_move) + time_offset
	time_offset = 0
	var/required_moves = speed > 0? FLOOR(elapsed_time_deciseconds / speed, 1) : MOVES_HITSCAN			//Would be better if a 0 speed made hitscan but everyone hates those so I can't make it a universal system :<
	if(required_moves == MOVES_HITSCAN)
		required_moves = SSprojectiles.global_max_tick_moves
	else
		if(required_moves > SSprojectiles.global_max_tick_moves)
			var/overrun = required_moves - SSprojectiles.global_max_tick_moves
			required_moves = SSprojectiles.global_max_tick_moves
			time_offset += overrun * speed
		time_offset += MODULUS(elapsed_time_deciseconds, speed)

	for(var/i in 1 to required_moves)
		pixel_move(1, FALSE)

/obj/item/projectile/proc/setAngle(new_angle)	//wrapper for overrides.
	Angle = new_angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile/forceMove(atom/target)
	if(!isloc(target) || !isloc(loc) || !z)
		return ..()
	var/zc = target.z != z
	var/old = loc
	if(zc)
		before_z_change(old, target)
	. = ..()
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		if(hitscan)
			finalize_hitscan_and_generate_tracers(FALSE)
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)
		if(hitscan)
			record_hitscan_start(RETURN_PRECISE_POINT(src))
	if(zc)
		after_z_change(old, target)

/obj/item/projectile/proc/fire(angle, atom/direct_target)
	//If no angle needs to resolve it from xo/yo!
	if(direct_target)
		process_hit(get_turf(direct_target), direct_target, accuracy_mod = INFINITY)		//For the sake of hoping no one aims that badly, we'll say you can hit things point blank.
		return
	if(isnum(angle))
		setAngle(angle)
	var/turf/starting = get_turf(src)
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(CLAMP(starting + xo, 1, world.maxx), CLAMP(starting + yo, 1, world.maxy), starting.z)
		AUTO_GET_ANGLE(src, target, _new_angle)
		setAngle(_new_angle)
	if(dispersion)
		setAngle(Angle + rand(-dispersion, dispersion))
	original_angle = Angle
	trajectory_ignore_forcemove = TRUE
	forceMove(starting)
	trajectory_ignore_forcemove = FALSE
	trajectory = new(starting.x, starting.y, starting.z, pixel_x, pixel_y, Angle, (override_pixel_speed || SSprojectiles.global_iterations_per_move))
	last_projectile_move = world.time
	permutated = list()
	originalRange = range
	fired = TRUE
	if(hitscan)
		. = process_hitscan()
	START_PROCESSING(SSprojectiles, src)
	pixel_move(1, FALSE)	//move it now!

/obj/item/projectile/proc/after_z_change(atom/olcloc, atom/newloc)

/obj/item/projectile/proc/before_z_change(atom/oldloc, atom/newloc)

/obj/item/projectile/proc/before_move()
	return

/obj/item/projectile/proc/after_move()
	return

/obj/item/projectile/proc/store_hitscan_collision(datum/point/pcache)
	beam_segments[beam_index] = pcache
	beam_index = pcache
	beam_segments[beam_index] = null

//Spread is FORCED!
/obj/item/projectile/proc/preparePixelProjectile(atom/target, atom/source, params, spread = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)
	trajectory_ignore_forcemove = TRUE
	forceMove(get_turf(source))
	trajectory_ignore_forcemove = FALSE
	starting = get_turf(source)
	original = target
	if(targloc || !params)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(GET_ANGLE(src, targloc) + spread)

	if(isliving(source) && params)
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]

		setAngle(calculated[1] + spread)
	else if(targloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(GET_ANGLE(src, targloc) + spread)
	else
		stack_trace("WARNING: Projectile [type] fired without either mouse parameters, or a target atom to aim at!")
		qdel(src)

/proc/calculate_projectile_angle_and_pixel_offsets(mob/user, params)
	var/list/mouse_control = params2list(params)
	var/p_x = 0
	var/p_y = 0
	var/angle = 0
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])
	if(mouse_control["screen-loc"])
		//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

		//Split X+Pixel_X up into list(X, Pixel_X)
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")

		//Split Y+Pixel_Y up into list(Y, Pixel_Y)
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32
		var/y = text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32

		//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
		var/list/screenview = user.client? getviewsize(user.client.view) : world.view
		var/screenviewX = screenview[1] * world.icon_size
		var/screenviewY = screenview[2] * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = ATAN2(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/item/projectile/proc/redirect(x, y, starting, source)
	old_style_target(locate(x, y, z), starting? get_turf(starting) : get_turf(source))

/obj/item/projectile/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	starting = get_turf(source)
	original = target
	AUTO_GET_ANGLE(source, target, angle)
	setAngle(angle)

/obj/item/projectile/Destroy()
	if(hitscan)
		finalize_hitscan_and_generate_tracers()
	STOP_PROCESSING(SSprojectiles, src)
	cleanup_beam_segments()
	qdel(trajectory)
	return ..()

/obj/item/projectile/proc/prehit(atom/target)
	return TRUE

/obj/item/projectile/proc/cleanup_beam_segments()
	QDEL_LIST_ASSOC(beam_segments)
	beam_segments = list()
	qdel(beam_index)

/obj/item/projectile/proc/vol_by_damage()
	if(damage)
		return CLAMP((damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then CLAMP the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume.

/obj/item/projectile/proc/finalize_hitscan_and_generate_tracers(impacting = TRUE)
	if(trajectory && beam_index)
		var/datum/point/pcache = trajectory.copy_to()
		beam_segments[beam_index] = pcache
	generate_hitscan_tracers(null, null, impacting)

/obj/item/projectile/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 5, impacting = TRUE)
	if(!length(beam_segments))
		return
	if(tracer_type)
		var/tempref = REF(src)
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity, tempref)
	if(muzzle_type && duration > 0)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		thing.color = color
		thing.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override? muzzle_flash_color_override : color)
		QDEL_IN(thing, duration)
	if(impacting && impact_type && duration > 0)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(Angle)
		thing.transform = M
		thing.color = color
		thing.set_light(impact_light_range, impact_light_intensity, impact_light_color_override? impact_light_color_override : color)
		QDEL_IN(thing, duration)
	if(cleanup)
		cleanup_beam_segments()

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/item/projectile/proc/can_hit_target(atom/target, list/passthrough, direct_target = FALSE, ignore_loc = FALSE)
	if(QDELETED(target))
		return FALSE
	if(!ignore_source_check && firer)
		var/mob/M = firer
		if((target == firer) || ((target == firer.loc) && ismecha(firer.loc)) || (target in firer.buckled_mobs) || (istype(M) && (M.buckled == target)))
			return FALSE
	if(!ignore_loc && (loc != target.loc))
		return FALSE
	if(target in passthrough)
		return FALSE
	if(target.density)		//This thing blocks projectiles, hit it regardless of layer/mob stuns/etc.
		return TRUE
	if(!isliving(target))
		if(target.layer < PROJECTILE_HIT_THRESHOLD_LAYER)
			return FALSE
	else
		var/mob/living/L = target
		if(!direct_target)
			if(!L.density || L.lying)
				return FALSE
			//if(!CHECK_BITFIELD(L.mobility_flags, MOBILITY_USE | MOBILITY_STAND | MOBILITY_MOVE) || !(L.stat == CONSCIOUS))		//If they're able to 1. stand or 2. use items or 3. move, AND they are not softcrit,  they are not stunned enough to dodge projectiles passing over.
			//	return FALSE
	return TRUE

/obj/item/projectile/Bump(atom/A)
	//var/datum/point/pcache = trajectory.copy_to()
	var/turf/T = get_turf(A)

	/*
	if(check_ricochet(A) && check_ricochet_flag(A) && ricochets < ricochets_max)
		ricochets++
		if(A.handle_ricochet(src))
			on_ricochet(A)
			ignore_source_check = TRUE
			decayedRange = max(0, decayedRange - reflect_range_decrease)
			range = decayedRange
			if(hitscan)
				store_hitscan_collision(pcache)
			return TRUE
	*/

	var/distance = get_dist(T, starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	def_zone = ran_zone(def_zone, max(100-(7*distance), 5)) //Lower accurancy/longer range tradeoff. 7 is a balanced number to use.

	/*
	if(isturf(A) && hitsound_wall)
		var/volume = CLAMP(vol_by_damage() + 20, 0, 100)
		if(suppressed)
			volume = 5
		playsound(loc, hitsound_wall, volume, 1, -1)
	*/

	. = process_hit(T, select_target(T, A, silent = silenced), null, null, distance)

#define QDEL_SELF 1			//Delete if we're not UNSTOPPABLE flagged non-temporarily
#define DO_NOT_QDEL 2		//Pass through.
#define FORCE_QDEL 3		//Force deletion.

/obj/item/projectile/proc/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE, distance = 0, accuracy_mod = 0)		//probably needs to be reworked entirely when pixel movement is done.
	if(QDELETED(src) || !T || !target)		//We're done, nothing's left.
		if((qdel_self == FORCE_QDEL) || ((qdel_self == QDEL_SELF) && !temporary_unstoppable_movement && !CHECK_BITFIELD(movement_type, UNSTOPPABLE)))
			qdel(src)
		return hit_something
	permutated |= target		//Make sure we're never hitting it again. If we ever run into weirdness with piercing projectiles needing to hit something multiple times.. well.. that's a to-do.
	if(!prehit(target))
		return process_hit(T, select_target(T, silent = silenced), qdel_self, hit_something, distance)		//Hit whatever else we can since that didn't work.
	var/can_penetrate = can_penetrate(target)
	var/result = do_hit_atom(target, distance, accuracy_mod)
	if(result == BULLET_ACT_FORCE_QDEL)
		qdel_self = FORCE_QDEL
		hit_something = TRUE
	else if((result == BULLET_ACT_FORCE_PIERCE) || (result == BULLET_ACT_MISS) || can_penetrate)
		if((result == BULLET_ACT_MISS) && (silenced <= PROJECTILE_SILENCE_NONE))
			visible_message("<span class='notice'>\The [src] misses [target] narrowly!</span>")
		else if(can_penetrate && (result != BULLET_ACT_FORCE_PIERCE))
			do_penetrate(target)
		if(!CHECK_BITFIELD(movement_type, UNSTOPPABLE))
			temporary_unstoppable_movement = TRUE
			ENABLE_BITFIELD(movement_type, UNSTOPPABLE)
		return process_hit(T, select_target(T, silent = silenced), qdel_self, TRUE, distance)		//Hit whatever else we can since we're piercing through but we're still on the same tile.
	else if(result == BULLET_ACT_TURF)									//We hit the turf but instead we're going to also hit something else on it.
		return process_hit(T, select_target(T, silent = silenced), QDEL_SELF, TRUE, distance)
	else		//Whether it hit or blocked, we're done!
		qdel_self = QDEL_SELF
		hit_something = TRUE
	if((qdel_self == FORCE_QDEL) || ((qdel_self == QDEL_SELF) && !temporary_unstoppable_movement && !CHECK_BITFIELD(movement_type, UNSTOPPABLE)))
		qdel(src)
		on_impact(target? target : (T? T : get_turf(src)))
	return hit_something

#undef QDEL_SELF
#undef DO_NOT_QDEL
#undef FORCE_QDEL

/obj/item/projectile/proc/select_target(turf/T, atom/target, silent = PROJECTILE_SILENCE_NONE)			//Select a target from a turf.
	if((original in T) && can_hit_target(original, permutated, TRUE, TRUE))
		return original
	if(target && can_hit_target(target, permutated, target == original, TRUE))
		return target
	var/list/mob/living/possible_mobs = typecache_filter_list(T, GLOB.typecache_mob)
	var/list/mob/mobs = list()
	for(var/mob/living/M in possible_mobs)
		if(!can_hit_target(M, permutated, M == original, TRUE))
			continue
		mobs += M

	var/mob/M = safepick(mobs)
	if(M)
		return get_mob_projectile_target(M, silent)

	var/list/obj/possible_objs = typecache_filter_list(T, GLOB.typecache_machine_or_structure)
	var/list/obj/objs = list()
	for(var/obj/O in possible_objs)
		if(!can_hit_target(O, permutated, O == original, TRUE))
			continue
		objs += O
	var/obj/O = safepick(objs)
	if(O)
		return O
	//Nothing else is here that we can hit, hit the turf if we haven't.
	if(!(T in permutated) && can_hit_target(T, permutated, T == original, TRUE))
		return T
	//Returns null if nothing at all was found.

/obj/item/projectile/proc/get_mob_projectile_target(mob/living/M, silent = PROJECTILE_SILENCE_NONE)
	. = M.lowest_buckled_mob()
	//POLARISCODE START - This is bad but I can't be bothered to refactor the whole grab system for now..
	var/list/obj/item/weapon/grab/grabs = M.return_all_grab_holders()
	for(var/i in grabs)
		var/obj/item/weapon/grab/grab = i
		if(grab.affecting in permutated)
			continue
		if(grab && grab.state >= GRAB_NECK)
			if(grab.affecting.stat == DEAD)
				var/shield_chance = min(80, (30 * (M.mob_size / 10)))	//Small mobs have a harder time keeping a dead body as a shield than a human-sized one. Unathi would have an easier job, if they are made to be SIZE_LARGE in the future. -Mech
				if(prob(shield_chance))
					if(silent <= PROJECTILE_SILENCE_NORMAL)
						visible_message("<span class='danger'>\The [M] uses [grab.affecting] as a shield!</span>")
					return grab.affecting
				else if(silent <= PROJECTILE_SILENCE_NORMAL)
					visible_message("<span class='danger'>\The [M] tries to use [grab.affecting] as a shield, but fails!</span>")
			else
				if(silent <= PROJECTILE_SILENCE_NORMAL)
					visible_message("<span class='danger'>\The [M] uses [grab.affecting] as a shield!</span>")
				return grab.affecting
	//PLARISCODE STOP

/obj/item/projectile/proc/do_hit_atom(atom/target, distance = 0, accuracy_mod = 0)
	return ismob(target)? attack_mob(target, distance, accuracy_mod) : target.bullet_act(src, def_zone)

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
//This proc needs to be refactored. Only on_hit should exist - kevinz000
/obj/item/projectile/proc/attack_mob(mob/living/target_mob, distance, miss_modifier = -INFINITY)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = max(15*(distance-2) - accuracy + miss_modifier + target_mob.get_evasion(), 0)
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, ranged_attack=(distance > 1 || original != target_mob)) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	. = BULLET_ACT_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		. = target_mob.bullet_act(src, def_zone)

	if(. == BULLET_ACT_MISS)
		return

	//hit messages
	if(silenced)
		to_chat(target_mob, "<span class='danger'>You've been hit in the [parse_zone(def_zone)] by \the [src]!</span>")
	else
		visible_message("<span class='danger'>\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!</span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob) && istype(target_mob))
			add_attack_logs(firer,target_mob,"Shot with \a [src.type] projectile")

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
//TODO: Do the same but also make this stuff work on objs - kevinz000
/obj/item/projectile/proc/on_hit(atom/target, blocked = 0, def_zone)
	if(blocked >= 100)
		return BULLET_ACT_BLOCK
	if(isliving(target))
		var/mob/living/L = target
		L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, blocked, incendiary, flammability) // add in AGONY!
		if(modifier_type_to_apply)
			L.add_modifier(modifier_type_to_apply, modifier_duration)
	return BULLET_ACT_HIT

//called when the projectile stops flying because it Bump'd with something
/obj/item/projectile/proc/on_impact(atom/A)
	if(damage && damage_type == BURN)
		var/turf/T = get_turf(A)
		if(T)
			T.hotspot_expose(700, 5)

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/item/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(embed_chance == 0 || damage_type != BRUTE)
		return 0
	return 1

/obj/item/projectile/proc/get_structure_damage()
	if(damage_type == BRUTE || damage_type == BURN)
		return damage
	return 0

/obj/item/projectile/proc/can_penetrate(atom/A)
	return auto_penetrate_amount

/obj/item/projectile/proc/do_penetrate(atom/A)
	auto_penetrate_amount--
	return TRUE

/obj/item/projectile/CanPass()
	return TRUE

/obj/item/projectile/proc/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	original = target
	def_zone = check_zone(target_zone)
	firer = user
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	preparePixelProjectile(target, user? user : get_turf(src), params, forced_spread)
	return fire(angle_override, direct_target)

//called to launch a projectile from a gun
/obj/item/projectile/proc/launch_from_gun(atom/target, target_zone, mob/user, params, angle_override, forced_spread, obj/item/weapon/gun/launcher)

	shot_from = launcher.name
	silenced = launcher.silenced

	return launch_projectile(target, target_zone, user, params, angle_override, forced_spread)
