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
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	depth_level = INFINITY // nothing should be passing over us from depth

	//* Collision Handling *//

	/** PROJECTILE PIERCING
	  * WARNING:
	  * Projectile piercing MUST be done using these variables.
	  * Ordinary passflags will result in can_hit_target being false unless directly clicked on - similar to pass_flags_phase but without even going to process_hit.
	  * The two flag variables below both use pass flags.
	  * In the context of ATOM_PASS_THROWN, it means the projectile will ignore things that are currently "in the air" from a throw.
	  *
	  * Also, projectiles sense hits using Bump(), and then pierce them if necessary.
	  * They simply do not follow conventional movement rules.
	  * NEVER flag a projectile as PHASING movement type.
	  * If you so badly need to make one go through *everything*, override check_pierce() for your projectile to always return PROJECTILE_PIERCE_PHASE/HIT.
	  */
	/// The "usual" flags of pass_flags is used in that can_hit_target ignores these unless they're specifically targeted/clicked on. This behavior entirely bypasses process_hit if triggered, rather than phasing which uses prehit_pierce() to check.
	pass_flags = ATOM_PASS_TABLE
	/// we handle our own go through
	generic_canpass = FALSE
	/// If FALSE, allow us to hit something directly targeted/clicked/whatnot even if we're able to phase through it
	var/phases_through_direct_target = FALSE
	/// anything with these pass flags are automatically pierced
	var/pass_flags_pierce = NONE
	/// anything with these pass flags are automatically phased through
	var/pass_flags_phase = NONE
	/// number of times we've pierced something. Incremented BEFORE bullet_act and similar procs run!
	var/pierces = 0
	/// What we already hit
	/// initialized on fire()
	var/list/impacted

	//*            -- Combat - Accuracy --            *//
	//* These are applied in additional to mob
	//* evasion and miss handling! Projectiles should *//
	//* generally be pretty accurate for that reason. *//
	//*                                               *//
	//* All accuracy ranges use **manhattan**         *//
	//* distance, not euclidean!                      *//

	/// if enabled, projectile-side baymiss is entirely disabled
	///
	/// * the target can still forcefully miss us, unfortunately, if it doesn't use the standard API
	/// * this might be violently fixed in the future
	var/accuracy_disabled = FALSE
	/// perfect accuracy below this range (in pixels)
	///
	/// * this means the projectile doesn't enforce inaccuracy; not the target!
	/// * remember that even if a projectile clips a single pixel on a target turf, it hits.
	/// * right now, accuracy is slightly more than it should be due to distance being ticked up post-impact.
	var/accuracy_perfect_range = WORLD_ICON_SIZE * 7
	/// linear - accuracy outside of perfect range
	///
	/// * [0, 100] inclusive as %
	var/accuracy_drop_start = 100
	/// linear - hit % falloff per pixel
	var/accuracy_drop_slope = 5 / WORLD_ICON_SIZE
	/// linear - lowest possible accuracy to drop to
	var/accuracy_drop_end = 20
	/// alter end result hit probability by this value
	///
	/// todo: is this really the best way?
	///
	/// * this is a multiplier for hit chance if less than 1
	/// * this is a divisor for miss chance if more than 1
	/// * 0.5 will turn a 80% hit to a 40%
	/// * 2 will turn a 80% hit to a 90%
	/// * 2 will turn a 40% hit to a 70%
	var/accuracy_overall_modify = 1

	//* Combat - Effects *//

	/// projectile effects
	///
	/// * this is a static typelist on this typepath
	/// * do not under any circumstances edit this
	/// * this is /tmp because this should never change on a typepath
	VAR_PROTECTED/tmp/list/base_projectile_effects
	/// projectile effects
	///
	/// * this is configured at runtime and can be edited
	/// * this is non /tmp because this is infact serializable
	VAR_PROTECTED/list/additional_projectile_effects

	//* Configuration *//

	/// Projectile type bitfield; set all that is relevant
	var/projectile_type = NONE
	/// Impact ground on expiry (range, or lifetime)
	var/impact_ground_on_expiry = FALSE

	//* Physics - Configuration *//

	/// speed, in pixels per second
	var/speed = 25 * WORLD_ICON_SIZE
	/// are we a hitscan projectile?
	var/hitscan = FALSE
	/// angle, in degrees **clockwise of north**
	var/angle
	/// multiplier to distance travelled at the **current** [angle] to get it to chebyshev dist
	var/angle_chebyshev_divisor
	/// max distance in pixels
	///
	/// * please set this to a multiple of [WORLD_ICON_SIZE] so we scale with tile size.
	var/range = WORLD_ICON_SIZE * 50
	// todo: lifespan

	//* Physics - Homing *//
	/// Are we homing in on something?
	var/homing = FALSE
	/// current homing target
	var/atom/homing_target
	/// angle per second
	///
	/// * this is smoother the less time between SSprojectiles fires
	var/homing_turn_speed = 100
	/// rand(min, max) for inaccuracy offsets
	var/homing_inaccuracy_min = 0
	/// rand(min, max) for inaccuracy offsets
	var/homing_inaccuracy_max = 0
	/// pixels; added to the real location of target so we're not exactly on-point
	var/homing_offset_x = 0
	/// pixels; added to the real location of target so we're not exactly on-point
	var/homing_offset_y = 0

	//* Physics - Tracers *//

	/// tracer /datum/point's
	var/list/tracer_vertices
	/// first point is a muzzle effect
	var/tracer_muzzle_flash
	/// last point is an impact
	var/tracer_impact_effect
	/// default tracer duration
	var/tracer_duration = 5

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
	/// the pixel location we're moving to, or the [current_px] after this iteration step
	///
	/// * used so stuff like hitscan deflections work based on the actual raycasted collision step, and not the prior step.
	/// * only valid if [trajectory_moving_to] is set
	var/next_px
	/// the pixel location we're moving to, or the [current_px] after this iteration step
	///
	/// * used so stuff like hitscan deflections work based on the actual raycasted collision step, and not the prior step.
	/// * only valid if [trajectory_moving_to] is set
	var/next_py
	/// the pixel distance we'll have travelled after the current Move()
	///
	/// * use this during impact processing or you'll be off by anywhere from 1 to 32 pixels.
	/// * only valid if [trajectory_moving_to] is set
	var/next_distance
	/// used to track if we got kicked forwards after calling Move()
	var/trajectory_kick_forwards = 0
	/// to avoid going too fast when kicked forwards by a mirror, if we overshoot the pixels we're
	/// supposed to move this gets set to penalize the next move with a weird algorithm
	/// that i won't bother explaining
	var/trajectory_penalty_applied = 0
	/// currently travelled distance in pixels
	var/distance_travelled
	/// if we get forcemoved, this gets reset to 0 as a trip
	/// this way, we know exactly how far we moved
	var/distance_travelled_this_iteration
	/// where the physics loop and/or some other thing moving us is trying to move to
	/// used to determine where to draw hitscan tracers
	//  todo: this being here is kinda a symptom that things are handled weirdly but whatever
	//        optimally physics loop should handle tracking for stuff like animations, not require on hit processing to check turfs
	var/turf/trajectory_moving_to

	//* Targeting *//

	/// Originally clicked target
	var/atom/original_target

	//* legacy below *//

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet

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

	//Targetting
	var/yo = null
	var/xo = null
	var/turf/starting = null // the projectile's starting turf
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	var/def_zone = BP_TORSO
	var/mob/firer = null//Who shot it
	var/silenced = 0	//Attack message
	var/shot_from = "" // name of the object which shot us

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
	var/damage_force = 10
	/// damage tier - goes hand in hand with [damage_armor]
	var/damage_tier = BULLET_TIER_DEFAULT
	/// damage type - DAMAGE_TYPE_* define
	var/damage_type = DAMAGE_TYPE_BRUTE
	/// armor flag for damage - goes hand in hand with [damage_tier]
	var/damage_flag = ARMOR_BULLET
	/// damage mode - see [code/__DEFINES/combat/damage.dm]
	var/damage_mode = NONE

	var/SA_bonus_damage = 0 // Some bullets inflict extra damage on simple animals.
	var/SA_vulnerability = null // What kind of simple animal the above bonus damage should be applied to. Set to null to apply to all SAs.
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/taser_effect = 0 //If set then the projectile will apply it's agony damage using stun_effect_act() to mobs it hits, and other damage will be ignored
	var/legacy_penetrating = 0 //If greater than zero, the projectile will pass through dense objects as specified by on_penetrate()
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

/obj/projectile/Initialize(mapload)
	if(islist(base_projectile_effects))
		base_projectile_effects = typelist(NAMEOF(src, base_projectile_effects), base_projectile_effects)
	return ..()

/obj/projectile/Destroy()
	// stop processing
	STOP_PROCESSING(SSprojectiles, src)
	// cleanup
	cleanup_hitscan_tracers()
	return ..()

/obj/projectile/proc/process_legacy_penetration(atom/A)
	return TRUE

/obj/projectile/proc/legacy_on_range() //if we want there to be effects when they reach the end of their range
	finalize_hitscan_tracers(impact_effect = FALSE, kick_forwards = 8)

	for(var/datum/projectile_effect/effect as anything in base_projectile_effects)
		if(effect.hook_lifetime)
			effect.on_lifetime(src, impact_ground_on_expiry)
	for(var/datum/projectile_effect/effect as anything in additional_projectile_effects)
		if(effect.hook_lifetime)
			effect.on_lifetime(src, impact_ground_on_expiry)

	if(impact_ground_on_expiry)
		impact(loc, PROJECTILE_IMPACT_IS_EXPIRING)

	expire()

/obj/projectile/proc/fire(set_angle_to, atom/direct_target, no_source_check)
	if(only_submunitions)	// refactor projectiles whwen holy shit this is awful lmao
		// todo: this should make a muzzle flash
		qdel(src)
		return

	// setup impact checking
	impacted = list()
	// make sure firer is in it
	if(firer && !no_source_check)
		impacted[firer] = TRUE
		if(ismob(firer))
			var/atom/buckle_iterating = firer.buckled
			while(buckle_iterating)
				if(impacted[buckle_iterating])
					CRASH("how did we loop in buckle iteration check?")
				impacted[buckle_iterating] = TRUE
				if(ismob(buckle_iterating))
					var/mob/cast_for_next = buckle_iterating
					buckle_iterating = cast_for_next.buckled
				else
					break
	// set angle if needed
	if(isnum(set_angle_to))
		set_angle(set_angle_to)
	// handle direct hit
	if(direct_target)
		if(direct_target.bullet_act(src, PROJECTILE_IMPACT_POINT_BLANK, def_zone) & PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH)
			impacted[direct_target] = TRUE
		else
			// todo: this should make a muzzle flash
			qdel(src)
			return
	// setup physics
	setup_physics()

	// legacy below
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
	fired = TRUE
	// legacy aboev

	// start physics & kickstart movement
	if(hitscan)
		physics_hitscan()
	else
		START_PROCESSING(SSprojectiles, src)
		physics_iteration(WORLD_ICON_SIZE, SSprojectiles.wait)

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
	original_target = target
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

/obj/projectile/proc/legacy_redirect(x, y, starting, source)
	reflected = TRUE
	old_style_target(locate(x, y, z), starting? get_turf(starting) : get_turf(source))

/obj/projectile/proc/old_style_target(atom/target, atom/source)
	if(!source)
		source = get_turf(src)
	starting = get_turf(source)
	original_target = target
	set_angle(get_visual_angle(source, target))

/obj/projectile/proc/vol_by_damage()
	if(damage_force)
		return clamp((damage_force) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then clamp the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume.

//Checks if the projectile is eligible for embedding. Not that it necessarily will.
/obj/projectile/proc/can_embed()
	//embed must be enabled and damage type must be brute
	if(embed_chance == 0 || damage_type != DAMAGE_TYPE_BRUTE)
		return 0
	return 1

/obj/projectile/proc/get_structure_damage()
	if(damage_type == DAMAGE_TYPE_BRUTE || damage_type == DAMAGE_TYPE_BURN)
		return damage_force
	return 0

/obj/projectile/proc/check_fire(atom/target as mob, mob/living/user as mob)  //Checks if you can hit them or not.
	check_trajectory(target, user, pass_flags, atom_flags)

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
	original_target = target
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
			damage_override = damage_force
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
					SM.damage_force = damage_override
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
 * Standard proc to determine damage when impacting something. This does not affect the special damage variables/effect variables, only damage and damage_type.
 * May or may not be called before/after armor calculations.
 *
 * @params
 * - target The atom hit
 *
 * @return Damage to apply to target.
 */
/obj/projectile/proc/run_damage_vulnerability(atom/target)
	var/final_damage = damage_force
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

// !legacy code above!

//* Collision Handling *//

/obj/projectile/CanAllowThrough()
	SHOULD_CALL_PARENT(FALSE)
	return TRUE

/obj/projectile/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	// performance
	SHOULD_CALL_PARENT(FALSE)
	// always can go through already impacted things
	if(impacted[blocker])
		return TRUE
	return blocker_opinion

/obj/projectile/Crossed(atom/movable/AM)
	..()
	scan_crossed_atom(AM)

// todo: should we inline this?
/obj/projectile/proc/scan_crossed_atom(atom/movable/target)
	if(!should_impact(target))
		return
	impact(target)

/obj/projectile/Bump(atom/A)
	. = ..()
	impact_loop(get_turf(A), A)

/obj/projectile/forceMove(atom/target)
	var/is_a_jump = isturf(target) != isturf(loc) || target.z != z || !trajectory_ignore_forcemove
	if(is_a_jump)
		record_hitscan_end()
		render_hitscan_tracers()
	. = ..()
	if(!.)
		stack_trace("projectile forcemove failed; please do not try to forcemove projectiles to invalid locations!")
	distance_travelled_this_iteration = 0
	if(!trajectory_ignore_forcemove)
		reset_physics_to_turf()
	if(is_a_jump)
		record_hitscan_start()

/obj/projectile/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	// if we're being yanked, we'll get Moved() again
	if(movable_flags & MOVABLE_IN_MOVED_YANK)
		return
	// not even fired yet
	if(!fired)
		return
	// scan the turf for anything we need to hit
	scan_moved_turf(loc)
	// trigger effects
	for(var/datum/projectile_effect/effect as anything in base_projectile_effects)
		if(effect.hook_moved)
			effect.on_moved(src, old_loc)
	for(var/datum/projectile_effect/effect as anything in additional_projectile_effects)
		if(effect.hook_moved)
			effect.on_moved(src, old_loc)

// todo: should we inline this?
/obj/projectile/proc/scan_moved_turf(turf/tile)
	if(original_target?.loc != tile)
		return
	if(!should_impact(original_target))
		return
	impact(original_target)

/**
 * checks if we're valid to hit a target
 *
 * this is called 'should' because it's not called in impact()
 * this checks if we should try to impact when processing collisions
 * this doesn't actually prevent us from having an impact call
 */
/obj/projectile/proc/should_impact(atom/target, is_colliding_us)
	// 1. emulate the usual physics / cross
	//    remember that impact_loop() scans all atoms, not just the hit one.
	if(impacted[target])
		return FALSE
	if(QDELETED(target))
		return FALSE
	// 1.5: legacy bullshit
	if(target.is_incorporeal())
		return FALSE
	// 2. are they the thing blocking us?
	if(is_colliding_us)
		return TRUE
	// 3. process projectile things
	if(target == original_target)
		return TRUE
	else if(!target.density || (target.pass_flags_self & pass_flags))
		return FALSE
	else if(target.layer < PROJECTILE_HIT_THRESHOLD_LAYER)
		return FALSE
	return TRUE

/**
 * this strangely named proc is basically the hit processing loop
 *
 * "now why the hells would you do this"
 *
 * well, you see, turf movement handling doesn't support what we need to do,
 * and for good reason.
 *
 * most of the time, turf movement handling is more than enough for any game use case.
 * it is not nearly accurate/comprehensive enough for projectiles
 * and we're not going to make it that, because that's a ton of overhead for everything else
 *
 * so instead, projectiles handle it themselves on a Bump().
 *
 * when this happens, the projectile should hit everything that's going to collide it anyways
 * in the turf, not just one thing; this way, hits are instant for a given collision.
 *
 * @params
 * * was_moving_onto - the turf we were moving to
 * * bumped - what bumped us?
 */
/obj/projectile/proc/impact_loop(turf/was_moving_onto, atom/bumped)
	var/impact_return
	// so unfortunately, only one border object is considered here
	// why?
	// because you see, for speed reasons we're not going to iterate once just to gather border.
	// so we assume that 'bumped' is border, or it just doesn't happen.

	// make sure we're not inf looping
	ASSERT(!(impacted[bumped]))
	// see if we should impact
	impact_return = impact(bumped)
	if(!(impact_return & PROJECTILE_IMPACT_CONTINUE_LOOP))
		return

	// at this point we're technically safe to just move again because
	// we processed bumped
	// problem is, that's O(n^2) behavior
	// we don't want to process just one bumped atom
	// as turf/Enter() will loop through everything again
	//
	// we want to process all of them.

	// at this point you might ask
	// why not use MOVEMENT_UNSTOPPABLE?
	// if we did, we wouldn't have the border-prioritization we have
	// that'd be bad as you'd be hit by a bullet behind a directional window

	// wow, projectiles are annoying to deal with

	// begin: main loop

	// first, targeted atom
	if(original_target?.loc == was_moving_onto)
		if(should_impact(original_target))
			impact_return = impact(bumped)
			if(!(impact_return & PROJECTILE_IMPACT_CONTINUE_LOOP))
				return

	// then, mobs
	for(var/mob/mob_target in was_moving_onto)
		if(!should_impact(mob_target))
			continue
		impact_return = impact(mob_target)
		if(!(impact_return & PROJECTILE_IMPACT_CONTINUE_LOOP))
			return

	// then, objs
	for(var/obj/obj_target in was_moving_onto)
		if(!should_impact(obj_target))
			continue
		impact_return = impact(obj_target)
		if(!(impact_return & PROJECTILE_IMPACT_CONTINUE_LOOP))
			return

	// then, the turf
	if(should_impact(was_moving_onto))
		impact_return = impact(was_moving_onto)
		if(!(impact_return & PROJECTILE_IMPACT_CONTINUE_LOOP))
			return

	// if we passed everything and we're still going,
	// we can safely move onto their turf again, and this time we should succeed.
	if(trajectory_moving_to)
		Move(trajectory_moving_to)

//* Lifetime & Deletion *//

// todo: on_lifetime() --> expire()

/**
 * Called to delete if:
 *
 * * ran out of range
 * * hit something and shouldn't pass through
 *
 * @params
 * * impacting - we're deleting from impact, rather than range
 */
/obj/projectile/proc/expire(impacting)
	qdel(src)

//* Impact Processing *//

/**
 * Called to perform an impact
 *
 * @params
 * * target - thing being hit
 * * impact_flags - impact flags to feed in
 * * def_zone - zone to hit; otherwise this'll be calculated.
 *
 * @return resultant impact_flags
 */
/obj/projectile/proc/impact(atom/target, impact_flags, def_zone = src.def_zone || BP_TORSO)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(impacted[target])
		return impact_flags | PROJECTILE_IMPACT_PASSTHROUGH | PROJECTILE_IMPACT_DUPLICATE | PROJECTILE_IMPACT_CONTINUE_LOOP
	impacted[target] = TRUE
	var/where_we_were = loc
	impact_flags = pre_impact(target, impact_flags, def_zone)
	var/keep_going

	// priority 1: delete?
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_DELETE)
		if(hitscanning)
			finalize_hitscan_tracers()
		qdel(src)
		return impact_flags
	// priority 2: should we hit?
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_NOT_HIT)
		keep_going = TRUE
		// phasing?
		if(impact_flags & PROJECTILE_IMPACT_PHASE)
			impact_flags = on_phase(target, impact_flags, def_zone)
		// reflect?
		else if(impact_flags & PROJECTILE_IMPACT_REFLECT)
			impact_flags = on_reflect(target, impact_flags, def_zone)
		// else, is passthrough. do nothing
	else
		impact_flags = target.bullet_act(src, impact_flags, def_zone, 1)
		// did we pierce?
		if(impact_flags & PROJECTILE_IMPACT_PIERCE)
			keep_going = TRUE
			impact_flags = on_pierce(target, impact_flags, def_zone)
		// are we otherwise meant to keep going?
		else if(impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH)
			keep_going = TRUE

	// did anything triggered up above trigger a delete?
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_DELETE)
		if(hitscanning)
			finalize_hitscan_tracers()
		qdel(src)
		return impact_flags

	// trigger projectile effects
	if(base_projectile_effects || additional_projectile_effects)
		// todo: can we move this to on_impact_new and have 'blocked' passed in? hrm.
		for(var/datum/projectile_effect/effect as anything in base_projectile_effects)
			if(effect.hook_impact)
				impact_flags = effect.on_impact(src, target, impact_flags, def_zone)
		for(var/datum/projectile_effect/effect as anything in additional_projectile_effects)
			if(effect.hook_impact)
				impact_flags = effect.on_impact(src, target, impact_flags, def_zone)
		// did anything triggered up above trigger a delete?
		if(impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_DELETE)
			if(hitscanning)
				finalize_hitscan_tracers()
			qdel(src)
			return impact_flags

	// see if we should keep going or delete
	if(keep_going)
		if(loc == where_we_were)
			// if we are supposed to keep going and we didn't get yanked, continue the impact loop.
			impact_flags |= PROJECTILE_IMPACT_CONTINUE_LOOP
	else
		// or if we aren't supposed to keep going, delete.
		if(hitscanning)
			if(trajectory_moving_to)
				// create tracers
				var/datum/point/visual_impact_point = get_intersection_point(trajectory_moving_to)
				// it's possible to not have an intersection point, if say, angle was being messed with mid-move
				// this entire system is suboptimal design-wise but atleast it's fast.
				if(visual_impact_point)
					// kick it forwards a bit
					visual_impact_point.shift_in_projectile_angle(angle, 2)
					// draw
					finalize_hitscan_tracers(visual_impact_point, impact_effect = TRUE)
				else
					finalize_hitscan_tracers(impact_effect = TRUE, kick_forwards = 32)
			else
				finalize_hitscan_tracers(impact_effect = TRUE, kick_forwards = 32)
		expire(TRUE)

	return impact_flags

/**
 * Called at the start of impact.
 *
 * * Hooks to return flags / whatnot should happen here
 * * You are allowed to edit the projectile here, but it is absolutely not recommended.
 *
 * @return new impact_flags
 */
/obj/projectile/proc/pre_impact(atom/target, impact_flags, def_zone)
	if(target.pass_flags_self & pass_flags_phase)
		return impact_flags | PROJECTILE_IMPACT_PHASE
	if(target.pass_flags_self & pass_flags_pierce)
		return impact_flags | PROJECTILE_IMPACT_PIERCE
	return impact_flags

/**
 * Called after bullet_act() of the target.
 *
 * * Please take into account impact_flags.
 * * Most impact flags returned are not re-checked for performance; pierce/phase calculations should be done in pre_impact().
 * * please see [/atom/proc/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)]
 * * Args at this point are no longer mutable after the ..() call.
 *
 * Things to keep in mind, if you ignore the above and didn't read bullet_act():
 * * Args are changed directly and passed up, but not passed back down. This means setting efficiency at base of /on_impact doesn't change a subtype's call
 * * This also means you need to default efficiency to 1 if you have things acting on it, as it won't be propagated for you.
 * * 'efficiency' is extremely powerful
 * * impact_flags having PROJECTILE_IMPACT_DELETE is a good sign to delete and do nothing else.
 *
 * todo: add PROJECTILE_IMPACT_DELETE_AFTER as opposed to DELETE? so rest of effects can still run
 *
 * @return new impact_flags; only PROJECTILE_IMPACT_DELETE is rechecked.
	 */
/obj/projectile/proc/on_impact(atom/target, impact_flags, def_zone, efficiency = 1)
	//! legacy shit
	if(damage_force && damage_type == DAMAGE_TYPE_BURN)
		var/turf/T = get_turf(target)
		if(T)
			T.hotspot_expose(700, 5)
	//! end
	return impact_flags

/**
 * called in bullet_act() to redirect our impact to another atom
 *
 * use like this:
 *
 * `return proj.impact_redirect(target, args)`
 *
 * * You **must** use this, not just `return target.bullet_act(arglist(args))`
 * * This does book-keeping like adding the target to permutated, ensure the target can't be hit multiple times in a row, and more.
 * * Don't be too funny about bullet_act_args, it's a directly passed in args list. Don't be stupid.
 */
/obj/projectile/proc/impact_redirect(atom/target, list/bullet_act_args)
	if(impacted[target])
		return bullet_act_args[BULLET_ACT_ARG_FLAGS] | PROJECTILE_IMPACT_DUPLICATE
	bullet_act_args[BULLET_ACT_ARG_FLAGS] |= PROJECTILE_IMPACT_INDIRECTED
	return target.bullet_act(arglist(bullet_act_args))

/**
 * phasing through
 *
 * * Most impact flags returned are not re-checked for performance; pierce/phase calculations should be done in pre_impact().
 *
 * @return new impact flags; only PROJETILE_IMPACT_DELETE is rechecked.
 */
/obj/projectile/proc/on_phase(atom/target, impact_flags, def_zone)
	return impact_flags

/**
 * reflected off of
 *
 * * Most impact flags returned are not re-checked for performance; pierce/phase calculations should be done in pre_impact().
 *
 * @return new impact flags; only PROJETILE_IMPACT_DELETE is rechecked.
 */
/obj/projectile/proc/on_reflect(atom/target, impact_flags, def_zone)
	return impact_flags

/**
 * piercing through
 *
 * * Most impact flags returned are not re-checked for performance; pierce/phase calculations should be done in pre_impact().
 *
 * @return new impact flags; only PROJETILE_IMPACT_DELETE is rechecked.
 */
/obj/projectile/proc/on_pierce(atom/target, impact_flags, def_zone)
	return impact_flags

//* Impact Processing - Combat *//

/**
 * processes default hit probability for baymiss
 *
 * * This is called by things like /mob/living as needed; there is no default baymiss handling on /projectile anymore.
 * * More than 100 target_opinion means that much % more than 100 of *not missing*.
 * * e.g. 200 target_opinion makes a 75% inherent hit chance (25% miss chance) to 87.5% hit cahnce (12.5% miss chance)
 *
 * todo: 0 to 100 for accuracy might not be amazing; maybe allow negative values evasion-style?
 *
 * @params
 * * target - what we're hitting
 * * target_opinion - the return from processing hit chance on their side
 * * distance - distance in pixels
 * * impact_check - are we checking for impact? this way things like pellets can do their own rolls after 100% hitting
 *
 * @return hit probability as % in [0, 100]; > 100 is allowed.
 */
/obj/projectile/proc/process_accuracy(atom/target, target_opinion = 100, distance, impact_check)
	if(isnull(distance))
		distance = (trajectory_moving_to ? next_distance : distance_travelled) * angle_chebyshev_divisor
	if(accuracy_disabled)
		return 100
	. = 100
	// perform accuracy curving
	if(distance > accuracy_perfect_range)
		. = accuracy_drop_start
		var/extra_distance = distance - accuracy_perfect_range
		var/drop_percent = extra_distance * accuracy_drop_slope
		. = clamp(. - drop_percent, ., accuracy_drop_end)
	if(accuracy_overall_modify != 1)
		if(accuracy_overall_modify < 1)
			// below 1: multiplier for hit chance
			. *= accuracy_overall_modify
		else
			// above 1: divisor for miss chance
			. = 100 - ((100 - .) / accuracy_overall_modify)
	if(target_opinion < 100)
		. *= (target_opinion / 100)
	else if(target_opinion > 100)
		. = 100 - ((100 - .) / (target_opinion / 100))

/**
 * processes zone accuracy
 *
 * * this is here to override 'special' baymiss, like 'don't even hit this zone' systems.
 *
 * @params
 * * target - what we're hitting
 * * target_opinion - the return from processing hit zone on their side
 * * distance - distance in pixels
 * * impact_check - are we checking for impact? this way things like pellets can do their own processing
 */
/obj/projectile/proc/process_zone_miss(atom/target, target_opinion, distance, impact_check)
	return target_opinion

/**
 * Applies the standard damage instance to an entity.
 *
 * @params
 * * target - thing being hit
 * * efficiency - 0 to 1+ - efficiency of hit, where 0% is full block
 * * impact_flags - impact flags passed in
 * * hit_zone - zone to hit
 *
 * @return BULLET_ACT_* flags to append into the calling bullet_act().
 */
/obj/projectile/proc/inflict_impact_damage(atom/target, efficiency, impact_flags, hit_zone)
	. = NONE

	//! LEGACY COMBAT CODE
	// SHIM!!!
	var/list/shieldcall_modified_args = target.check_damage_instance(damage_force, damage_type, damage_tier, damage_flag, damage_mode, ATTACK_TYPE_PROJECTILE, src, SHIELDCALL_FLAG_SECOND_CALL, hit_zone)
	// todo: this handling very obviously should not be here
	// dear lord this code is a dumpster fire
	if(shieldcall_modified_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAGS_PIERCE_ATTACK)
		. |= PROJECTILE_IMPACT_REFLECT
	if(shieldcall_modified_args[SHIELDCALL_ARG_FLAGS] & SHIELDCALL_FLAGS_BLOCK_ATTACK)
		return
	// END
	if(isliving(target))
		var/mob/living/L = target
		//Armor
		var/soaked = L.get_armor_soak(hit_zone, src.damage_flag, src.armor_penetration)
		var/absorb = L.run_armor_check(hit_zone, src.damage_flag, src.armor_penetration)
		var/proj_sharp = is_sharp(src)
		var/proj_edge = has_edge(src)
		var/final_damage = src.get_final_damage(target) * efficiency

		if ((proj_sharp || proj_edge) && (soaked >= round(src.damage_force*0.8)))
			proj_sharp = 0
			proj_edge = 0

		if ((proj_sharp || proj_edge) && prob(L.legacy_mob_armor(hit_zone, src.damage_flag)))
			proj_sharp = 0
			proj_edge = 0

		var/list/impact_sounds = islist(src.impact_sounds)? LAZYACCESS(src.impact_sounds, L.get_bullet_impact_effect_type(hit_zone)) : src.impact_sounds
		if(length(impact_sounds))
			playsound(L, pick(impact_sounds), 75)
		else if(!isnull(impact_sounds))
			playsound(L, impact_sounds, 75)

		//Stun Beams
		if(src.taser_effect)
			L.stun_effect_act(0, src.agony, hit_zone, src)
			to_chat(L, "<font color='red'>You have been hit by [src]!</font>")
			if(!src.nodamage)
				L.apply_damage(final_damage, src.damage_type, hit_zone, absorb, soaked, 0, src, sharp=proj_sharp, edge=proj_edge)
			return

		if(!src.nodamage)
			L.apply_damage(final_damage, src.damage_type, hit_zone, absorb, soaked, 0, src, sharp=proj_sharp, edge=proj_edge)

		// todo: some of these dont' make sense to be armor'd (last two), some do; please refactor this
		L.apply_effects(stun, weaken, paralyze, irradiate, stutter, eyeblur, drowsy, agony, clamp((1 - efficiency) * 100 + absorb, 0, 100), incendiary, flammability)
		if(modifier_type_to_apply)
			L.add_modifier(modifier_type_to_apply, modifier_duration)
	//! END

	for(var/datum/projectile_effect/effect as anything in base_projectile_effects)
		if(effect.hook_damage)
			effect.on_damage(src, target, impact_flags, hit_zone, efficiency)
	for(var/datum/projectile_effect/effect as anything in additional_projectile_effects)
		if(effect.hook_damage)
			effect.on_damage(src, target, impact_flags, hit_zone, efficiency)

	if(legacy_penetrating > 0)
		if(process_legacy_penetration(target))
			. |= PROJECTILE_IMPACT_PIERCE | PROJECTILE_IMPACT_PASSTHROUGH

/**
 * wip algorithm to dampen a projectile when it pierces
 *
 * * entity - thing hit
 * * force - nominal force to resist the damping; generally, projectiles at this lose a moderate chunk of energy, while 2x loses minimal, 0.5x loses a lot.
 * * tier - effective armor tier of object; modulates actual energy lost
 */
/obj/projectile/proc/dampen_on_pierce_experimental(atom/entity, force, tier)
	var/tdiff = damage_tier - tier
	var/dmult = src.damage_force / force
	var/malus = dmult >= 1 ? ((1 / dmult) ** tdiff * 10) : (10 * ((1 / dmult) / (1 + tdiff)))
	src.damage_force = clamp(src.damage_force - malus, src.damage_force * 0.5, src.damage_force)

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
