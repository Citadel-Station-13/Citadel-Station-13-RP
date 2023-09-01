///Not actually hitscan but close as we get without actual hitscan.
#define MOVES_HITSCAN -1
///How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.
#define MUZZLE_EFFECT_PIXEL_INCREMENT 17
/obj/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	unacidable = TRUE
	pass_flags = ATOM_PASS_TABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	depth_level = INFINITY // nothing should be passing over us from depth
	generic_canpass = FALSE

	/** PROJECTILE PIERCING
	  * WARNING:
	  * Projectile piercing MUST be done using these variables.
	  * Ordinary passflags will result in can_hit_target being false unless directly clicked on - similar to pass_flags_phase but without even going to process_hit.
	  * The two flag variables below both use pass flags.
	  * In the context of LETPASStHROW, it means the projectile will ignore things that are currently "in the air" from a throw.
	  *
	  * Also, projectiles sense hits using Bump(), and then pierce them if necessary.
	  * They simply do not follow conventional movement rules.
	  * NEVER flag a projectile as PHASING movement type.
	  * If you so badly need to make one go through *everything*, override check_pierce() for your projectile to always return PROJECTILE_PIERCE_PHASE/HIT.
	  */
	/// The "usual" flags of pass_flags is used in that can_hit_target ignores these unless they're specifically targeted/clicked on. This behavior entirely bypasses process_hit if triggered, rather than phasing which uses prehit_pierce() to check.
	pass_flags = PASSTABLE
	/// If FALSE, allow us to hit something directly targeted/clicked/whatnot even if we're able to phase through it
	var/phases_through_direct_target = FALSE
	/// Bitflag for things the projectile should just phase through entirely - No hitting unless direct target and [phasing_ignore_direct_target] is FALSE. Uses pass_flags flags.
	var/pass_flags_phase = NONE
	/// Bitflag for things the projectile should hit, but pierce through without deleting itself. Defers to pass_flags_phase. Uses pass_flags flags.
	var/pass_flags_pierce = NONE
	/// number of times we've pierced something. Incremented BEFORE bullet_act and on_hit proc!
	var/pierces = 0

	/// current angle
	var/angle = 0
	/// original target
	var/atom/target
	/// firer if it exists
	var/atom/firer
	/// already passed / hit
	var/list/impacted = list()
	/// original starting turf
	var/turf/starting_turf

	/// cached dx over dy; x movement is pixels * dx_ratio
	var/dx_ratio = 0
	/// cached dy over dx; y movement is pixels * dy_ratio
	var/dy_ratio = 1
	/// current pixel x in turf; used because pixel_x is rounded to nearest 1
	var/px_current
	/// current pixel y in turf; used because pixel_y is rounded to nearest 1
	var/py_current
	/// do not reset px/py current on forced movement
	var/trajectory_ignore_forcemove = FALSE
	/// forcefully moving through stuff via MOVEMENT_PHASING
	var/trajectory_currently_phasing = FALSE

	/// are we fired
	var/fired = FALSE
	/// are we paused right now?
	var/paused = FALSE

	/// pixels per decisecond;
	var/speed = TILES_PER_SECOND(17.5)
	/// whether or not this is hitscan.
	var/hitscan = FALSE

	/// set to TRUE if the projectile should not face the angle
	/// projectiles should face north by default with 1 sprite per state (so no directionals)
	var/nondirectional_sprite = FALSE

	/// damage amount
	var/damage = 10
	/// damage tier - goes hand in hand with [damage_armor]
	var/damage_tier = BULLET_TIER_DEFAULT
	/// todo: legacy - BRUTE, BURN, TOX, OXY, CLONE, HALLOSS, ELECTROCUTE, BIOACID are the only things that should be in here
	var/damage_type = BRUTE
	/// armor flag for damage - goes hand in hand with [damage_tier]
	var/damage_flag = ARMOR_BULLET
	/// damage mode - see [code/__DEFINES/combat/damage.dm]
	var/damage_mode = NONE

	/// assoc list of paths to amount for submunitions; set to use submunitions
	var/list/submunitions
	/// delete self after firing submunitions
	var/submunitions_only = FALSE
	/// spread to each side maximum
	var/submunition_spread = 0
	/// spread mode
	var/submunition_spread_mode = SUBMUNITION_SPREAD_EVENLY
	/// spread submunition damage to one individual type
	/// usually you set it to the type of the only submunition path
	var/submunition_disperse_damage
	/// submunitions usually inherit our accuracy but this gives a mod to every submunition
	var/submunition_accuracy = 0

	/// the last point recorded
	var/datum/point/hitscan_index
	/// /obj/effect/projectile/tracer path
	var/hitscan_tracer_type
	/// /obj/effect/projectile/muzzle path
	var/hitscan_muzzle_type
	/// /obj/effect/projectile/impact path
	var/hitscan_impact_type

	/// point blanking ignores accuracy checks
	/// this applies to submunitions too
	var/point_blanking_doesnt_miss = FALSE

	/// homing target, if any
	var/atom/homing_target
	/// homing turn rate in deg per decisecond.
	var/homing_rate = 5
	/// if non null, stop homing permanently if we're within this error margin of angle towards the target.
	var/homing_shutoff = 3.5

	/// max ds we can persist for
	var/lifetime = 10 SECONDS
	/// fired time
	var/fired_at
	/// max range in tiles **touched**, not get_dist() range.
	var/range = 50
	/// current range
	var/travelled = 0

	#warn below

	var/ignore_source_check = FALSE

	var/spread = 0			//amount (in degrees) of projectile spread
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/ricochets = 0
	var/ricochets_max = 2
	var/ricochet_chance = 30

	var/miss_sounds
	var/ricochet_sounds
	var/list/impact_sounds	//for different categories, IMPACT_MEAT etc

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



	//Targetting
	var/yo = null
	var/xo = null
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	var/def_zone = ""	//Aiming at
	var/silenced = 0	//Attack message
	var/shot_from = "" // name of the object which shot us

	var/accuracy = 0
	var/dispersion = 0.0

	var/SA_bonus_damage = 0 // Some bullets inflict extra damage on simple animals.
	var/SA_vulnerability = null // What kind of simple animal the above bonus damage should be applied to. Set to null to apply to all SAs.
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
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
	var/excavation_amount = 0 // How much, if anything, it drills from a mineral turf.
	/// If this projectile is holy. Silver bullets, etc. Currently no effects.
	var/holy = FALSE

	// Antimagic
	/// Should we check for antimagic effects?
	var/antimagic_check = FALSE
	/// Antimagic charges to use, if any
	var/antimagic_charges_used = 0
	/// Multiplier for damage if antimagic is on the target
	var/antimagic_damage_factor = 0

	var/embed_chance = 0	//Base chance for a projectile to embed

	var/fire_sound = 'sound/weapons/Gunshot_old.ogg' // Can be overriden in gun.dm's fire_sound var. It can also be null but I don't know why you'd ever want to do that. -Ace

	var/vacuum_traversal = TRUE //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	var/no_attack_log = FALSE
	var/hitsound

#warn above

/obj/projectile/Destroy()
	if(fired)
		STOP_PROCESSING(SSprojectiles, src)
	return ..()

#warn below

/obj/projectile/proc/Range()
	range--
	if(range <= 0 && loc)
		on_range()

/obj/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	qdel(src)

/obj/projectile/proc/return_predicted_turf_after_moves(moves, forced_angle)		//I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, SSprojectiles.global_pixel_speed)
	var/datum/point/vector/v = current.return_vector_after_increments(moves * SSprojectiles.global_iterations_per_move)
	return v.return_turf()

/obj/projectile/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return getline(current, ending)

/obj/projectile/proc/set_pixel_speed(new_speed)
	if(trajectory)
		trajectory.set_speed(new_speed)
		return TRUE
	return FALSE

/obj/projectile/proc/record_hitscan_start(datum/point/pcache)
	if(!has_tracer)
		return
	if(!pcache)
		return
	beam_segments = list()
	beam_index = pcache
	beam_segments[beam_index] = null	//record start.

/obj/projectile/proc/process_hitscan()
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

/obj/projectile/proc/pixel_move(trajectory_multiplier, hitscanning = FALSE)
	if(!loc || !trajectory)
		return
	last_projectile_move = world.time
	if(homing)
		process_homing()
	var/forcemoved = FALSE
	for(var/i in 1 to SSprojectiles.global_iterations_per_move)
		if(QDELETED(src))
			return
		trajectory.increment(trajectory_multiplier)
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
		pixel_x = trajectory.return_px() - trajectory.mpx * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		pixel_y = trajectory.return_py() - trajectory.mpy * trajectory_multiplier * SSprojectiles.global_iterations_per_move
		animate(src, pixel_x = trajectory.return_px(), pixel_y = trajectory.return_py(), time = 1, flags = ANIMATION_END_NOW)
	Range()

/obj/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	if(AM.is_incorporeal())
		return
	..()
	if(isliving(AM) && !check_pass_flags(ATOM_PASS_MOB))
		var/mob/living/L = AM
		if(can_hit_target(L, permutated, (AM == original)))
			Bump(AM)

/obj/projectile/proc/process_homing()			//may need speeding up in the future performance wise.
	if(!homing_target)
		return FALSE
	var/datum/point/PT = RETURN_PRECISE_POINT(homing_target)
	PT.x += clamp(homing_offset_x, 1, world.maxx)
	PT.y += clamp(homing_offset_y, 1, world.maxy)
	var/angle = closer_angle_difference(Angle, angle_between_points(RETURN_PRECISE_POINT(src), PT))
	setAngle(Angle + clamp(angle, -homing_turn_speed, homing_turn_speed))

/obj/projectile/proc/set_homing_target(atom/A)
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

/obj/projectile/process(delta_time)
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

/obj/projectile/forceMove(atom/target)
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

/obj/projectile/proc/fire(angle, atom/direct_target)
	if(only_submunitions)	// refactor projectiles whwen holy shit this is awful lmao
		qdel(src)
		return
	//If no angle needs to resolve it from xo/yo!
	if(direct_target)
		direct_target.bullet_act(src, def_zone)
		qdel(src)
		return
	if(isnum(angle))
		setAngle(angle)
	var/turf/starting = get_turf(src)
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(clamp(starting + xo, 1, world.maxx), clamp(starting + yo, 1, world.maxy), starting.z)
		setAngle(get_visual_angle(src, target))
	if(dispersion)
		setAngle(Angle + rand(-dispersion, dispersion))
	original_angle = Angle
	trajectory_ignore_forcemove = TRUE
	forceMove(starting)
	trajectory_ignore_forcemove = FALSE
	trajectory = new(starting.x, starting.y, starting.z, pixel_x, pixel_y, Angle, SSprojectiles.global_pixel_speed)
	last_projectile_move = world.time
	permutated = list()
	originalRange = range
	fired = TRUE
	if(hitscan)
		. = process_hitscan()
	START_PROCESSING(SSprojectiles, src)
	pixel_move(1, FALSE)	//move it now!


/obj/projectile/proc/after_z_change(atom/olcloc, atom/newloc)

/obj/projectile/proc/before_z_change(atom/oldloc, atom/newloc)

/obj/projectile/proc/before_move()
	return

/obj/projectile/proc/after_move()
	return

/obj/projectile/proc/store_hitscan_collision(datum/point/pcache)
	if(!has_tracer)
		return
	beam_segments[beam_index] = pcache
	beam_index = pcache
	beam_segments[beam_index] = null

//Spread is FORCED!
/obj/projectile/proc/preparePixelProjectile(atom/target, atom/source, params, spread = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)

	if(istype(source, /atom/movable))
		var/atom/movable/MT = source
		if(MT.locs && MT.locs.len)	// Multi tile!
			for(var/turf/T in MT.locs)
				if(get_dist(T, target) < get_turf(curloc))
					curloc = get_turf(T)

	trajectory_ignore_forcemove = TRUE
	forceMove(get_turf(source))
	trajectory_ignore_forcemove = FALSE
	starting = curloc
	original = target
	if(targloc || !params)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(get_visual_angle(src, targloc) + spread)

	if(isliving(source) && params)
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]

		setAngle(calculated[1] + spread)
	else if(targloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(get_visual_angle(src, targloc) + spread)
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
		var/screenviewX = user.client.current_viewport_width * world.icon_size
		var/screenviewY = user.client.current_viewport_height * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = arctan(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/projectile/proc/redirect(x, y, starting, source)
	old_style_target(locate(x, y, z), starting? get_turf(starting) : get_turf(source))

/obj/projectile/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	starting = get_turf(source)
	original = target
	setAngle(get_visual_angle(source, target))

/obj/projectile/Destroy()
	if(hitscan)
		finalize_hitscan_and_generate_tracers()
	return ..()

/obj/projectile/proc/cleanup_beam_segments()
	if(!has_tracer)
		return
	QDEL_LIST_ASSOC(beam_segments)
	beam_segments = list()
	qdel(beam_index)

/obj/projectile/proc/vol_by_damage()
	if(damage)
		return clamp((damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then clamp the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume.

/obj/projectile/proc/finalize_hitscan_and_generate_tracers(impacting = TRUE)
	if(!has_tracer)
		return
	if(trajectory && beam_index)
		var/datum/point/pcache = trajectory.copy_to()
		beam_segments[beam_index] = pcache
	generate_hitscan_tracers(null, null, impacting)

/obj/projectile/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 5, impacting = TRUE)
	if(!length(beam_segments))
		return
	beam_components = new
	if(hitscan_tracer_type)
		var/tempref = "\ref[src]"
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], beam_components, hitscan_tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity, tempref)
	if(hitscan_muzzle_type && duration > 0)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new hitscan_muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		thing.color = color
		thing.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override? muzzle_flash_color_override : color)
		beam_components.beam_components += thing
	if(impacting && hitscan_impact_type && duration > 0)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new hitscan_impact_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(Angle)
		thing.transform = M
		thing.color = color
		thing.set_light(impact_light_range, impact_light_intensity, impact_light_color_override? impact_light_color_override : color)
		beam_components.beam_components += thing
	QDEL_IN(beam_components, duration)

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/projectile/proc/can_hit_target(atom/target, list/passthrough, direct_target = FALSE, ignore_loc = FALSE)
	if(QDELETED(target))
		return FALSE
	if(!ignore_source_check && firer)
		var/mob/M = firer
		if((target == firer) || ((target == firer.loc) && istype(firer.loc, /obj/mecha)) || (target in firer.buckled_mobs) || (istype(M) && (M.buckled == target)))
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
			if(!L.density)
				return FALSE
	return TRUE

/obj/projectile/Bump(atom/A)
	if(A in permutated)
		trajectory_ignore_forcemove = TRUE
		forceMove(get_turf(A))
		trajectory_ignore_forcemove = FALSE
		return FALSE
	if(firer && !reflected)
		if(A == firer || (A == firer.loc && istype(A, /obj/mecha))) //cannot shoot yourself or your mech
			trajectory_ignore_forcemove = TRUE
			forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			return FALSE

	var/distance = get_dist(starting, get_turf(src))
	var/turf/target_turf = get_turf(A)
	var/passthrough = FALSE

	if(ismob(A))
		var/mob/M = A
		if(istype(A, /mob/living))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/grab/G = locate() in M
			if(G && G.state >= GRAB_NECK)
				if(G.affecting.stat == DEAD)
					var/shield_chance = min(80, (30 * (M.mob_size / 10)))	//Small mobs have a harder time keeping a dead body as a shield than a human-sized one. Unathi would have an easier job, if they are made to be SIZE_LARGE in the future. -Mech
					if(prob(shield_chance))
						visible_message("<span class='danger'>\The [M] uses [G.affecting] as a shield!</span>")
						if(Bump(G.affecting))
							return
					else
						visible_message("<span class='danger'>\The [M] tries to use [G.affecting] as a shield, but fails!</span>")
				else
					visible_message("<span class='danger'>\The [M] uses [G.affecting] as a shield!</span>")
					if(Bump(G.affecting))
						return //If Bump() returns 0 (keep going) then we continue on to attack M.

			passthrough = !projectile_attack_mob(M, distance)
		else
			passthrough = 1 //so ghosts don't stop bullets
	else
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/living/M in A)
				projectile_attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = TRUE
		penetrating--

	if(passthrough)
		trajectory_ignore_forcemove = TRUE
		forceMove(target_turf)
		permutated.Add(A)
		trajectory_ignore_forcemove = FALSE
		return FALSE

	if(A)
		on_impact(A)
	qdel(src)
	return TRUE

//TODO: make it so this is called more reliably, instead of sometimes by bullet_act() and sometimes not
/obj/projectile/proc/on_hit(atom/target, blocked = 0, def_zone)
	if(blocked >= 100)
		return 0//Full block
	if(!isliving(target))
		return 0
//	if(isanimal(target))	return 0
	var/mob/living/L = target
	L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, blocked, incendiary, flammability) // add in AGONY!
	if(modifier_type_to_apply)
		L.add_modifier(modifier_type_to_apply, modifier_duration)
	return 1

//called when the projectile stops flying because it Bump'd with something
/obj/projectile/proc/on_impact(atom/A)
	if(damage && damage_type == BURN)
		var/turf/T = get_turf(A)
		if(T)
			T.hotspot_expose(700, 5)

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(embed_chance == 0 || damage_type != BRUTE)
		return 0
	return 1

/obj/projectile/proc/get_structure_damage()
	if(damage_type == BRUTE || damage_type == BURN)
		return damage
	return 0

//return 1 if the projectile should be allowed to pass through after all, 0 if not.
/obj/projectile/proc/check_penetrate(atom/A)
	return 1

/obj/projectile/proc/check_fire(atom/target as mob, mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, atom_flags)

/obj/projectile/CanAllowThrough()
	. = ..()
	return TRUE

//Called when the projectile intercepts a mob. Returns 1 if the projectile hit the mob, 0 if it missed and should keep flying.
/obj/projectile/proc/projectile_attack_mob(mob/living/target_mob, distance, miss_modifier = 0)
	if(!istype(target_mob))
		return

	//roll to-hit
	miss_modifier = max(15*(distance-2) - accuracy + miss_modifier + target_mob.get_evasion(), 0)
	var/hit_zone = get_zone_with_miss_chance(def_zone, target_mob, miss_modifier, ranged_attack=(distance > 1 || original != target_mob)) //if the projectile hits a target we weren't originally aiming at then retain the chance to miss

	var/result = PROJECTILE_FORCE_MISS
	if(hit_zone)
		def_zone = hit_zone //set def_zone, so if the projectile ends up hitting someone else later (to be implemented), it is more likely to hit the same part
		result = target_mob.bullet_act(src, def_zone)

	if(result == PROJECTILE_FORCE_MISS)
		if(!silenced)
			visible_message("<span class='notice'>\The [src] misses [target_mob] narrowly!</span>")
			playsound(target_mob.loc, pick(miss_sounds), 60, 1)
		return FALSE

	//hit messages
	if(silenced)
		to_chat(target_mob, "<span class='danger'>You've been hit in the [parse_zone(def_zone)] by \the [src]!</span>")
	else
		visible_message("<span class='danger'>\The [target_mob] is hit by \the [src] in the [parse_zone(def_zone)]!</span>")//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter

	//admin logs
	if(!no_attack_log)
		if(istype(firer, /mob) && istype(target_mob))
			add_attack_logs(firer,target_mob,"Shot with \a [src.type] projectile")

	//sometimes bullet_act() will want the projectile to continue flying
	if (result == PROJECTILE_CONTINUE)
		return FALSE

	return TRUE

/**
 * i hate everything
 *
 * todo: refactor guns
 * projectiles
 * and everything else
 *
 * i am losing my fucking mind
 * this shouldn't have to fucking exist because the ammo casing and/or gun should be doing it
 * and submunitions SHOULDNT BE HANDLED HERE!!
 */
/obj/projectile/proc/launch_projectile_common(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	original = target
	def_zone = check_zone(target_zone)
	firer = user

	if(use_submunitions && submunitions.len)
		var/temp_min_spread = 0
		if(force_max_submunition_spread)
			temp_min_spread = submunition_spread_max
		else
			temp_min_spread = submunition_spread_min

		var/damage_override = null

		if(spread_submunition_damage)
			damage_override = damage
			if(nodamage)
				damage_override = 0

			var/projectile_count = 0

			for(var/proj in submunitions)
				projectile_count += submunitions[proj]

			damage_override = round(damage_override / max(1, projectile_count))

		for(var/path in submunitions)
			var/amt = submunitions[path]
			for(var/count in 1 to amt)
				var/obj/projectile/SM = new path(get_turf(loc))
				SM.shot_from = shot_from
				SM.silenced = silenced
				if(!isnull(damage_override))
					SM.damage = damage_override
				if(submunition_constant_spread)
					SM.dispersion = 0
					var/calculated = Angle + round((count / amt - 0.5) * submunition_spread_max, 1)
					SM.launch_projectile(target, target_zone, user, params, calculated)
				else
					SM.dispersion = rand(temp_min_spread, submunition_spread_max) / 10
					SM.launch_projectile(target, target_zone, user, params, angle_override)

/obj/projectile/proc/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	preparePixelProjectile(target, user? user : get_turf(src), params, forced_spread)
	launch_projectile_common(target, target_zone, user, params, angle_override, forced_spread)
	return fire(angle_override, direct_target)

//called to launch a projectile from a gun
/obj/projectile/proc/launch_from_gun(atom/target, target_zone, mob/user, params, angle_override, forced_spread, obj/item/gun/launcher)

	shot_from = launcher.name
	silenced = launcher.silenced

	return launch_projectile(target, target_zone, user, params, angle_override, forced_spread)

/obj/projectile/proc/launch_projectile_from_turf(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	var/direct_target
	if(get_turf(target) == get_turf(src))
		direct_target = target

	preparePixelProjectile(target, user? user : get_turf(src), params, forced_spread)
	launch_projectile_common(target, target_zone, user, params, angle_override, forced_spread)
	return fire(angle_override, direct_target)

/**
 * Standard proc to determine damage when impacting something. This does not affect the special damage variables/effect variables, only damage and damtype.
 * May or may not be called before/after armor calculations.
 *
 * @params
 * - target The atom hit
 *
 * @return Damage to apply to target.
 */
/obj/projectile/proc/run_damage_vulnerability(atom/target)
	var/final_damage = damage
	if(isliving(target))
		var/mob/living/L = target
		if(issimple(target))
			var/mob/living/simple_mob/SM = L
			if(SM.mob_class & SA_vulnerability)
				final_damage += SA_bonus_damage
		if(L.anti_magic_check(TRUE, TRUE, antimagic_charges_used, FALSE))
			final_damage *= antimagic_damage_factor
	return final_damage

/**
 * Probably isn't needed but saves me the time and I can regex this later:
 * Gets the final `damage` that should be used on something
 */
/obj/projectile/proc/get_final_damage(atom/target)
	return run_damage_vulnerability(target)

#warn above

//* Setters

/obj/projectile/proc/set_angle(angle)
	src.angle = angle
	src.dx_ratio = sin(angle)
	src.dy_ratio = cos(angle)
	if(!nondirectional_sprite)
		var/matrix/turning = new
		turning.Turn(angle)
		transform = turning

/obj/projectile/proc/set_speed(speed)
	src.speed = speed

//* Firing

/**
 * Fires us.
 *
 * @params
 * * angle_override - override angle; useful for 'userless' projectile fires because we don't have to set any other vars
 * * point_blank - hit something point blank (duh)
 */
/obj/projectile/proc/fire(angle_override, atom/point_blank)

#warn impl

//* Hitscan Rendering

/obj/projectile/proc/hitscan_tracer_start(datum/point/where)
	#warn impl

/obj/projectile/proc/hitscan_tracer_redirected(datum/point/where)
	#warn impl

/obj/projectile/proc/hitscan_tracer_end(datum/point/where)
	#warn impl

//* Processing / Flight

/obj/projectile/process(delta_time)
	if(paused)
		return
	increment(speed * delta_time * SSprojectiles.global_speed_multiplier)
	if(QDELETED(src))
		return
	if(!isnull(homing_target))
		home_in(delta_time)

/**
 * Propagates our simulation by an amount of pixels
 */
/obj/projectile/proc/increment(pixels)
	#warn impl

/**
 * Process hitscan
 */
/obj/projectile/proc/hitscan(render_muzzle = TRUE)
	var/safety = range * 10
	if(render_muzzle)
		#warn render muzzle effect
	#warn render tracer start with increment
	var/turf/current = loc
	ASSERT(istype(current))
	if(isnull(px_current))
		px_current = 0
	if(isnull(py_current))
		py_current = 0
	while(!QDELETED(src))
		ASSERT(!isnull(loc))
		// todo: implement pausing
		if(!--safety)
			// too far, just kill without bumping
			// this shouldn't be happening if proper diminishing returns are applied
			stack_trace("hitscan projectile ran out of safety.")
			qdel(src)
			return

	#warn impl

/**
 * process homing
 *
 * note that higher fps for projectile simulation
 * directly results in smoother homing.
 *
 * this is an issue but not worth fixing because 20+ fps is more than good enough.
 */
/obj/projectile/proc/home_in(ds)
	var/wanted = closer_angle_difference(angle, get_projectile_angle(src, homing_target))
	var/turn_rate = homing_rate * ds
	set_angle(angle + clamp(wanted, -turn_rate, turn_rate))

//* Movement Hooks

// todo: this is one of the last Crossed() calls we have to deal with, probably.
/obj/projectile/Crossed(atom/movable/AM)
	..()
	//! legacy
	if(AM.is_incorporeal())
		return
	//! end
	scan_crossed_target(AM)

/obj/projectile/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(!fired)
		return
	if(trajectory_currently_phasing == TRUE)
		trajectory_currently_phasing = FALSE
		movement_type &= ~MOVEMENT_PHASING
	scan_moved_turf()

/obj/projectile/Bump(atom/A)
	// we skip the rest of /atom/movable/Bump other than the signal.
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	if(!can_impact(A, cross_failed = TRUE))
		return
	impact(A)


/obj/projectile/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	if(!isnull(impacted[blocker]))
		return TRUE
	return ..()

//* Impact - Scan

/**
 * Try to hit a Crossed() target
 */
/obj/projectile/proc/scan_crossed_target(atom/movable/AM)
	if(can_hit_target(AM))
		impact_internal(AM)
	#warn impl

/**
 * Try to hit something on a turf
 */
/obj/projectile/proc/scan_moved_turf()
	#warn impl

//* Impact - Internal

/**
 * Called to process impacts.
 * This is usually from the following sources:
 * * We got Crossed() between moves by a moving object
 * * We Bump()'d something that did block us
 * * We Moved() and scanned for something to hit
 *
 * This proc should not check can_impact(); this is assumed already to have been checked.
 */
/obj/projectile/proc/impact(atom/movable/A)
	// check impacted; this should be checked by can_impact but we want to be sure incase of snowflake calls
	if(impacted[A])
		return FALSE
	// grab our point
	var/datum/point/visual_point = new /datum/point(src)
	#warn impl

/**
 * Selects a target to hit from a turf
 *
 * @params
 * T - The turf
 * bumped - used to track if something is the reason we impacted in the first place.
 * If set, this atom is always treated as dense by can_hit_target.

 * Priority:
 * 0. Anything that is already in impacted is ignored no matter what. Furthermore, in any bracket, if the target atom parameter is in it, that's hit first.
 * 	Furthermore, can_hit_target is always checked. This (entire proc) is PERFORMANCE OVERHEAD!! But, it shouldn't be ""too"" bad and I frankly don't have a better *generic non snowflakey* way that I can think of right now at 3 AM.
 *		FURTHERMORE, mobs/objs have a density check from can_hit_target - to hit non dense objects over a turf, you must click on them, same for mobs that usually wouldn't get hit.
 * 1. The thing originally aimed at/clicked on
 * 2. Mobs - picks lowest buckled mob to prevent scarp piggybacking memes
 * 3. Objs
 * 4. Turf
 * 5. Nothing
 */
/obj/item/projectile/proc/select_target(turf/T, atom/bumped)
	#warn this sucks, we should swap bumped auto-hit to something else maybe?
	// 1. original
	if(can_impact(original, FALSE, original == bumped))
		return original
	var/list/atom/possible = list()		// let's define these ONCE
	var/list/atom/considering = list()
	// 2. mobs
	possible = typecache_filter_list(T, GLOB.typecache_living)	// living only
	for(var/i in possible)
		if(!can_impact(i, i == original, TRUE, i == bumped))
			continue
		considering += i
	if(considering.len)
		var/mob/living/M = pick(considering)
		return M.lowest_buckled_mob()
	considering.len = 0
	// 3. objs and other dense things
	for(var/i in T.contents)
		if(!can_impact(i, i == original, TRUE, i == bumped))
			continue
		considering += i
	if(considering.len)
		return pick(considering)
	// 4. turf
	if(can_impact(T, T == original, TRUE, T == bumped))
		return T
	// 5. nothing
		// (returns null)

//* Impact - Checks

/**
 * Returns if we can / should hit a target at all.
 * This is before prehit_pierce and accuracy_miss.
 *
 * @params
 * * A - the thing we might want to hit
 * * point_blank - are they a point blank target
 * * cross_failed - are we scanning for a hit due to a failed Cross().
 */
/obj/projectile/proc/can_impact(atom/A, point_blank, cross_failed)
	#warn impl

/**
 * performs accuracy checks to see if we should hit something
 *
 * @params
 * * AM - thing being hit
 *
 * @return TRUE to miss
 */
/obj/projectile/proc/accuracy_miss(atom/movable/AM)
	#warn impl - we're going to want a tracking var for range to do that

/**
 * Checks if we should pierce something.
 *
 * NOT meant to be a pure proc, since this replaces prehit() which was used to do things.
 * Return PROJECTILE_DELETE_WITHOUT_HITTING to delete projectile without hitting at all!
 *
 * @return PROJECTILE_PIERCE_* enum
 */
/obj/projectile/proc/prehit_pierce(atom/A)
	if((pass_flags_phase & A.pass_flags_self) && (phases_through_direct_target || target != A))
		return PROJECTILE_PIERCE_PHASE
	if(pass_flags_pierce & A.pass_flags_self)
		return PROJECTILE_PIERCE_HIT
	if(ismovable(A))
		var/atom/movable/AM = A
		if(!isnull(AM.throwing))
			var/check = (AM.throwing.throw_flags & THROW_AT_OVERHAND)? ATOM_PASS_OVERHEAD_THROW : ATOM_PASS_THROWN
			return (pass_flags_phase & check)? PROJECTILE_PIERCE_PHASE : ((pass_flags_pierce & check)? PROJECTILE_PIERCE_HIT : PROJECTILE_PIERCE_NONE)
	return PROJECTILE_PIERCE_NONE

//* Impact - Application

#warn impl

//* Varedit Hooks

/obj/projectile/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	. = ..()
	if(!. || raw_edit)
		return
	switch(var_name)
		if(NAMEOF(src, angle))
			set_angle(isnum(var_value)? var_value : 0)
