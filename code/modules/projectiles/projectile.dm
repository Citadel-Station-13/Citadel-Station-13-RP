/**
 * ## Physics Specifications
 *
 * We track physics as absolute pixel on a tile, not byond's pixel x/y
 * thus the first pixel at bottom left of tile is 1, 1
 * and the last pixel at top right is 32, 32 (for a world icon size of 32 pixels)
 *
 * We cross over to the next tile at above 32, for up/right,
 * and to the last tile at below 1, for bottom/left.
 *
 * The code might handle it based on how it's implemented,
 * but as long as the error is 1 pixel or below, it's not a big deal.
 *
 * The reason we're so accurate (1 pixel/below is pretty insanely strict) is
 * so players have the projectile act like what the screen says it should be like;
 * hence why projectiles can realistically path across corners based on their 'hitbox center'.
 */
/obj/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	integrity_flags = INTEGRITY_INDESTRUCTIBLE | INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF
	pass_flags = ATOM_PASS_TABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	depth_level = INFINITY // nothing should be passing over us from depth

	//* Physics - Configuration *//

	/// speed, in pixels per decisecond
	var/speed = 32 / 0.55 // ~18 tiles/second
	/// are we a hitscan projectile?
	var/hitscan = FALSE
	/// angle, in degrees **clockwise of north**
	var/angle
	/// max distance in pixels
	///
	/// * please set this to a multiple of [WORLD_ICON_SIZE] so we scale with tile size.
	var/range = WORLD_ICON_SIZE * 50
	// todo: lifespan

	//* Physics - Tracers *//

	/// tracer /datum/point's
	var/list/tracer_vertices
	/// first point is a muzzle effect
	var/tracer_muzzle_flash
	/// last point is an impact
	var/tracer_impact_effect

	//* Physics - State *//

	/// paused? if so, we completely get passed over during processing
	var/paused = FALSE
	/// currently hitscanning
	var/hitscanning = FALSE
	/// a flag to prevent movement hooks from resetting our physics on a forced movement
	var/trajectory_ignore_forcemove = FALSE
	/// cached value: move this much x for this much distance
	/// basically, dx / distance
	var/calculated_dx
	/// cached value: move this much y for this much distance
	/// basically, dy / distance
	var/calculated_dy
	/// cached sign of dx; 1, -1, or 0
	var/calculated_sdx
	/// cached sign of dy; 1, -1, or 0
	var/calculated_sdy
	/// our current pixel location on turf
	/// byond pixel_x rounds, and we don't want that
	///
	/// * at below 0 or at equals to WORLD_ICON_SIZE, we move to the next turf
	var/current_px
	/// our current pixel location on turf
	/// byond pixel_y rounds, and we don't want that
	///
	/// * at below 0 or at equals to WORLD_ICON_SIZE, we move to the next turf
	var/current_py
	/// used to track if we got kicked forwards after calling Move()
	var/trajectory_kicked_forwards
	/// to avoid going too fast when kicked forwards by a mirror, if we overshoot the pixels we're
	/// supposed to move this gets set to penalize the next move with a weird algorithm
	/// that i won't bother explaining
	var/trajectory_penalty_applied = 0
	/// currently travelled distance in pixels
	var/distance_travelled
	/// if we get forcemoved, this gets reset to 0 as a trip
	/// this way, we know exactly how far we moved
	var/distance_travelled_this_iteration

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/ignore_source_check = FALSE

	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/spread = 0			//amount (in degrees) of projectile spread
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	var/ricochets = 0
	var/ricochets_max = 2
	var/ricochet_chance = 30

	//Hitscan
	/// do we have a tracer? if not we completely ignore hitscan logic
	var/has_tracer = TRUE
	var/tracer_type
	var/muzzle_type
	var/impact_type

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

	//Homing
	var/homing = FALSE
	var/atom/homing_target
	// angle per deciseconds
	// this is smoother the less time between SSprojectiles fires
	var/homing_turn_speed = 10
	var/homing_inaccuracy_min = 0		//in pixels for these. offsets are set once when setting target.
	var/homing_inaccuracy_max = 0
	var/homing_offset_x = 0
	var/homing_offset_y = 0

	//Targetting
	var/yo = null
	var/xo = null
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	var/def_zone = ""	//Aiming at
	var/mob/firer = null//Who shot it
	var/silenced = 0	//Attack message
	var/shot_from = "" // name of the object which shot us

	var/accuracy = 0
	var/dispersion = 0.0

	// Sub-munitions. Basically, multi-projectile shotgun, rather than pellets.
	var/use_submunitions = FALSE
	var/only_submunitions = FALSE // Will the projectile delete itself after firing the submunitions?
	var/list/submunitions = list() // Assoc list of the paths of any submunitions, and how many they are. [projectilepath] = [projectilecount].
	var/submunition_spread_max = 30 // Divided by 10 to get the percentile dispersion.
	var/submunition_spread_min = 5 // Above.
	/// randomize spread? if so, evenly space between 0 and max on each side.
	var/submunition_constant_spread = FALSE
	var/force_max_submunition_spread = FALSE // Do we just force the maximum?
	var/spread_submunition_damage = FALSE // Do we assign damage to our sub projectiles based on our main projectile damage?

	//? Damage - default handling
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

	var/SA_bonus_damage = 0 // Some bullets inflict extra damage on simple animals.
	var/SA_vulnerability = null // What kind of simple animal the above bonus damage should be applied to. Set to null to apply to all SAs.
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	var/projectile_type = /obj/projectile
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

	// todo: currently unimplemneted
	var/vacuum_traversal = TRUE //Determines if the projectile can exist in vacuum, if false, the projectile will be deleted if it enters vacuum.

	var/no_attack_log = FALSE

/obj/projectile/Destroy()
	#warn should this be done here?
	if(hitscan)
		finalize_hitscan_and_generate_tracers()
	// stop processing
	STOP_PROCESSING(SSprojectiles, src)
	// cleanup
	QDEL_LIST(tracer_vertices)
	return ..()

/obj/projectile/proc/legacy_on_range() //if we want there to be effects when they reach the end of their range
	qdel(src)

/obj/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	if(AM.is_incorporeal())
		return
	..()
	if(isliving(AM) && !check_pass_flags(ATOM_PASS_MOB))
		var/mob/living/L = AM
		if(can_hit_target(L, permutated, (AM == original)))
			Bump(AM)

/obj/projectile/forceMove(atom/target)
	if(!isloc(target) || !isloc(loc) || !z)
		return ..()
	. = ..()
	if(!trajectory_ignore_forcemove)
		reset_physics_to_turf()

	#warn deal with hitscan shit
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		if(hitscan)
			finalize_hitscan_and_generate_tracers(FALSE)
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)
		if(hitscan)
			record_hitscan_start(RETURN_PRECISE_POINT(src))

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
		set_angle(angle)

	// setup physics
	setup_physics()

	var/turf/starting = get_turf(src)
	if(isnull(angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(clamp(starting + xo, 1, world.maxx), clamp(starting + yo, 1, world.maxy), starting.z)
		set_angle(get_visual_angle(src, target))
	if(dispersion)
		set_angle(angle + rand(-dispersion, dispersion))
	original_angle = angle
	forceMove(starting)
	permutated = list()
	fired = TRUE
	// kickstart
	if(hitscan)
		physics_hitscan()
	else
		START_PROCESSING(SSprojectiles, src)
		pixel_move(1, FALSE)	//move it now!

/obj/projectile/Move(atom/newloc, dir = NONE)
	. = ..()
	if(.)
		if(fired && can_hit_target(original, permutated, TRUE))
			Bump(original)

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
		set_angle(get_visual_angle(src, targloc) + spread)

	if(isliving(source) && params)
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]

		set_angle(calculated[1] + spread)
	else if(targloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		set_angle(get_visual_angle(src, targloc) + spread)
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
	set_angle(get_visual_angle(source, target))

/obj/projectile/proc/vol_by_damage()
	if(damage)
		return clamp((damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then clamp the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume.

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
		if(direct_target)
			return TRUE
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
					var/calculated = angle + round((count / amt - 0.5) * submunition_spread_max, 1)
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

//* Hitscan Visuals *//

/**
 * returns a /datum/point based on where we currently are
 */
/obj/projectile/proc/get_tracer_point()
	RETURN_TYPE(/datum/point)
	#warn impl

/**
 * records the start of a hitscan
 *
 * this can edit the point passed in!
 */
/obj/projectile/proc/record_hitscan_start(datum/point/point = get_tracer_point(), muzzle_marker, kick_forwards = 16)
	tracer_vertices = list(point)
	tracer_muzzle_flash = muzzle_marker
	#warn kick forwards

/**
 * ends the hitscan tracer
 *
 * this can edit the point passed in!
 */
/obj/projectile/proc/record_hitscan_end(datum/point/point = get_tracer_point(), impact_marker, kick_forwards = 16)
	tracer_vertices += point
	tracer_impact_effect = impact_marker
	#warn kick forwards

/**
 * records a deflection (change in angle, aka generate new tracer)
 */
/obj/projectile/proc/record_hitscan_deflection(datum/point/point = get_tracer_point())
	// there's no way you need more than 25
	// if this is hit, fix your shit, don't bump this up; there's absolutely no reason for example,
	// to simulate reflectors working !!25!! times.
	if(length(tracer_vertices) >= 25)
		CRASH("tried to add more than 25 vertices to a hitscan tracer")
	tracer_vertices += point

#warn below

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
	if(tracer_type)
		var/tempref = "\ref[src]"
		for(var/datum/point/p in beam_segments)
			generate_tracer_between_points(p, beam_segments[p], beam_components, tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity, tempref)
	if(muzzle_type && duration > 0)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		thing.color = color
		thing.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override? muzzle_flash_color_override : color)
		beam_components.beam_components += thing
	if(impacting && impact_type && duration > 0)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(angle)
		thing.transform = M
		thing.color = color
		thing.set_light(impact_light_range, impact_light_intensity, impact_light_color_override? impact_light_color_override : color)
		beam_components.beam_components += thing
	QDEL_IN(beam_components, duration)

#warn this

//* Physics - Configuration *//

/**
 * sets our angle
 */
/obj/projectile/proc/set_angle(new_angle)
	angle = new_angle

	// update sprite
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(angle)
		transform = M

	// update trajectory
	calculated_dx = sin(new_angle)
	calculated_dy = cos(new_angle)
	calculated_sdx = calculated_dx == 0? 0 : (calculated_dx > 0? 1 : -1)
	calculated_sdy = calculated_dy == 0? 0 : (calculated_dy > 0? 1 : -1)

	// record our tracer's change
	if(hitscanning)
		record_hitscan_deflection()

/**
 * sets our speed in pixels per decisecond
 */
/obj/projectile/proc/set_speed(new_speed)
	speed = new_speed

/**
 * sets our angle and speed
 */
/obj/projectile/proc/set_velocity(new_angle, new_speed)
	// this is so this can be micro-optimized later but for once i'm not going to do it early for no reason
	set_speed(new_speed)
	set_angle(new_angle)

/**
 * todo: this is somewhat mildly terrible
 */
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

/**
 * initializes physics vars
 */
/obj/projectile/proc/setup_physics()
	distance_travelled = 0

/**
 * called after an unhandled forcemove is detected, or other event
 * that should reset our on-turf state
 */
/obj/projectile/proc/reset_physics_to_turf()
	// we use this because we can center larger than 32x32 projectiles
	// without disrupting physics this way
	//
	// we add by (WORLD_ICON_SIZE / 2) because
	// pixel_x / pixel_y starts at center,
	//
	current_px = pixel_x - base_pixel_x + (WORLD_ICON_SIZE / 2)
	current_py = pixel_y - base_pixel_y + (WORLD_ICON_SIZE / 2)

//* Physics - Processing *//

/obj/projectile/process(delta_time)
	if(paused)
		return
	physics_iteration(delta_time * speed, delta_time)

/**
 * immediately processes hitscan
 */
/obj/projectile/proc/physics_hitscan()
	hitscanning = TRUE

	// setup
	var/safety = 250
	record_hitscan_start()

	// just move as many times as we can
	while(!QDELETED(src) && loc)
		// check safety
		safety--
		if(safety <= 0)
			// if you're here, you shouldn't be. do not bump safety up, fix whatever
			// you're doing because no one should be making projectiles go more than 250
			// tiles in a single life.
			stack_trace("projectile hit iteration limit for hitscan")
			break

		// move forwards by 1 tile length
		distance_travelled += physics_step(WORLD_ICON_SIZE)
		// see if we're done
		if(distance_travelled >= range)
			legacy_on_range()
			break

	hitscanning = FALSE

/**
 * ticks forwards a number of pixels
 *
 * todo: potential lazy animate support for performance, as we honestly don't need to animate at full fps if the server's above 20fps
 */
/obj/projectile/proc/physics_iteration(pixels, delta_time)
	// setup iteration
	var/safety = 10
	var/pixels_remaining = pixels
	distance_travelled_this_iteration = 0

	// apply penalty
	var/penalizing = clamp(trajectory_penalty_applied, 0, pixels_remaining)
	pixels_remaining -= penalizing
	trajectory_penalty_applied -= penalizing

	// clamp to max distance
	pixels_remaining = min(pixels_remaining, range - distance_travelled)

	// move as many times as we need to
	//
	// * break if we're loc = null (by deletion or otherwise)
	// * break if we get paused
	while(pixels_remaining > 0)
		// check safety
		safety--
		if(safety <= 0)
			CRASH("ran out of safety! what happened?")

		// move
		var/pixels_moved = physics_step(pixels_remaining)
		distance_travelled += pixels_moved
		pixels_remaining -= pixels_moved

		if(!loc || paused)
			break

	// penalize next one if we were kicked forwards forcefully too far
	trajectory_penalty_applied = max(0, -pixels_remaining)

	// if we don't have a loc anymore just bail
	if(!loc)
		return

	// if we're at max range
	if(distance_travelled >= range)
		// todo: egh
		legacy_on_range()
		if(QDELETED(src))
			return

	// process homing
	physics_tick_homing(delta_time)

	// perform animations
	// we assume at this point any deflections that should have happened, has happened,
	// so we just do a naive animate based on our current loc and pixel x/y
	//
	// todo: animation needs to take into account angle changes,
	//       but that's expensive as shit so uh lol
	//
	// the reason we use distance_travelled_this_iteration is so if something disappears
	// by forceMove or whatnot,
	// we won't have it bounce from its previous location to the new one as it's not going
	// to be accurate anymore
	//
	// so instead, as of right now, we backtrack via how much we know we moved.
	pixel_x = -(distance_travelled_this_iteration * sin(angle)) + base_pixel_x
	pixel_y = -(distance_travelled_this_iteration * cos(angle)) + base_pixel_y

	animate(
		src,
		delta_time,
		flags = ANIMATION_END_NOW,
		pixel_x = base_pixel_x + current_px - (WORLD_ICON_SIZE / 2),
		pixel_y = base_pixel_y + current_py - (WORLD_ICON_SIZE / 2),
	)

/**
 * based on but exactly http://www.cs.yorku.ca/~amana/research/grid.pdf
 *
 * move into the next tile, or the specified number of pixels,
 * whichever is less pixels moved
 *
 * this will modify our current_px/current_py as necessary
 *
 * @return pixels moved
 */
/obj/projectile/proc/physics_step(limit)
	// distance to move in our angle to get to next turf for horizontal and vertical
	var/d_next_horizontal = \
		(calculated_sdx? ((calculated_sdx > 0? (WORLD_ICON_SIZE + 0.5) - current_px : current_px - 0.5) / calculated_dx) : INFINITY)
	var/d_next_vertical = \
		(calculated_sdy? ((calculated_sdy > 0? (WORLD_ICON_SIZE + 0.5) - current_py : current_py - 0.5) / calculated_dy) : INFINITY)
	var/turf/move_to_target

	if(d_next_horizontal == d_next_vertical)
		// we're diagonal
		if(d_next_horizontal <= limit)
			move_to_target = locate(x + calculated_sdx, y + calculated_sdy, z)
			. = d_next_horizontal
			current_px += d_next_horizontal - WORLD_ICON_SIZE + calculated_sdx
			current_py += d_next_horizontal - WORLD_ICON_SIZE + calculated_sdy
	else if(d_next_horizontal < d_next_vertical)
		// closer is to move left/right
		if(d_next_horizontal <= limit)
			move_to_target = locate(x + calculated_sdx, y, z)
			. = d_next_horizontal
			current_px += d_next_horizontal - WORLD_ICON_SIZE + calculated_sdx
			current_py += d_next_horizontal * calculated_dy
	else if(d_next_vertical < d_next_horizontal)
		// closer is to move up/down
		if(d_next_vertical <= limit)
			move_to_target = locate(x, y + calculated_sdy, z)
			. = d_next_vertical
			current_px += d_next_vertical * calculated_dx
			current_py += d_next_vertical - WORLD_ICON_SIZE + calculated_sdy

	// if we need to move
	if(move_to_target)
		// is this or step_towards better? meh.
		Move(move_to_target, get_dir(src, move_to_target))
	else
		// not moving to another tile, so, just move on current tile
		. = limit
		current_px += limit * calculated_dx
		current_py += limit * calculated_dy

/**
 * immediately, without processing, kicks us forward a number of pixels
 *
 * since we immediately cross over into a turf when entering,
 * things like mirrors/reflectors will immediately set angle
 *
 * it looks ugly and is pretty bad to just reflect off the edge of a turf so said things can
 * call this proc to kick us forwards by a bit
 */
/obj/projectile/proc/physics_kick_forwards(pixels)
	current_px += pixels * calculated_dx
	current_py += pixels * calculated_dy

/**
 * only works during non-hitscan
 *
 * this is called once per tick
 * homing is smoother the higher fps the server / SSprojectiles runs at
 *
 * todo: this is somewhat mildly terrible
 * todo: this has absolutely no arc/animation support; this is bad
 */
/obj/projectile/proc/physics_tick_homing(delta_time)
	// checks if they're 1. on a turf, 2. on our z
	// todo: should we add support for tracking something even if it leaves a turf?
	if(homing_target?.z != z)
		// bye bye!
		return FALSE
	// todo: this assumes single-tile objects. at some point, we should upgrade this to be unnecessarily expensive and always center-mass.
	var/dx = (homing_target.x - src.x) * WORLD_ICON_SIZE + (0 - current_px)
	var/dy = (homing_target.y - src.y) * WORLD_ICON_SIZE + (0 - current_py)
	// say it with me, arctan()
	// is CCW of east if (dx, dy)
	// and CW of north if (dy, dx)
	// where dx and dy is distance in x/y pixels from us to them.

	var/nudge_towards = closer_angle_difference(arctan(dy, dx))
	var/max_turn_speed = homing_turn_speed * delta_time

	set_angle(angle + clamp(nudge_towards, -max_turn_speed, max_turn_speed))

//* Physics - Querying *//

/**
 * predict what turf we'll be in after going forwards a certain amount of pixels
 *
 * doesn't actually sim; so this will go through walls/obstacles!
 *
 * * if we go out of bounds, we will return null; this doesn't level-wrap
 */
/obj/projectile/proc/physics_predicted_turf_after_iteration(pixels)
	// -1 at the end if 0, because:
	//
	// -32 is go back 1 tile and be at the 1st pixel (as 0 is going back)
	// 0 is go back 1 tile and be at the 32nd pixel.
	var/incremented_px = (current_px + pixels * calculated_dx) || - 1
	var/incremented_py = (current_py + pixels * calculated_dy) || - 1

	var/incremented_tx = floor(incremented_px / 32)
	var/incremented_ty = floor(incremented_py / 32)

	return locate(x + incremented_tx, y + incremented_ty, z)

/**
 * predict what turfs we'll hit, excluding the current turf, after going forwards
 * a certain amount of pixels
 *
 * doesn't actually sim; so this will go through walls/obstacles!
 */
/obj/projectile/proc/physics_predicted_turfs_during_iteration(pixels)
	return pixel_physics_raycast(loc, current_px, current_py, angle, pixels)

//* Targeting *//

/**
 * Checks if something is a valid target when directly clicked.
 */
/obj/projectile/proc/is_valid_target(atom/target)
	if(isobj(target))
		var/obj/O = target
		return O.obj_flags & OBJ_RANGE_TARGETABLE
	else if(isliving(target))
		return TRUE
	else if(isturf(target))
		return target.density
	return FALSE
