// These projectiles are somewhat different from the other projectiles in the code.
// First, these have an 'arcing' visual, that is accomplished by having the projectile icon rotate as its flying, and
// moving up, then down as it approaches the target. There is also a small shadow effect that follows the projectile
// as its flying.

// Besides the visuals, arcing projectiles do not collide with anything until they reach the target, as they fly over them.
// For best effect, use this only when it makes sense to do so, IE on the Surface. The projectiles don't care about ceilings or gravity.

// todo: better description; this type does have an excuse to have special behavior.
/obj/projectile/arc
	name = "arcing shot"
	icon_state = "fireball" // WIP
	movement_type = MOVEMENT_UNSTOPPABLE
	impact_ground_on_expiry = TRUE
	plane = ABOVE_PLANE // Since projectiles are 'in the air', they might visually overlap mobs while in flight, so the projectile needs to be above their plane.
	speed = 10 * WORLD_ICON_SIZE
	var/fired_dir = null		// Which direction was the projectile fired towards. Needed to invert the projectile turning based on if facing left or right.
	var/distance_to_fly = null // How far, in pixels, to fly for. Will call on_range() when this is passed.
	var/visual_y_offset = -16 // Adjusts how high the projectile and its shadow start, visually. This is so the projectile and shadow align with the center of the tile.
	var/obj/effect/projectile_shadow/shadow = null // Visual indicator for the projectile's 'true' position. Needed due to being bound to two dimensions in reality.


/obj/projectile/arc/Initialize(mapload)
	shadow = new(get_turf(src))
	return ..()

/obj/projectile/arc/Destroy()
	QDEL_NULL(shadow)
	return ..()

/obj/projectile/arc/proc/calculate_initial_pixel_distance(atom/user, atom/target)
	var/datum/point/A = new(user)
	var/datum/point/B = new(target)

	// Set the pixel offsets if they exist.
	A.x += (p_x - 16)
	A.y += (p_y - 16)

	return pixel_length_between_points(A, B)

/obj/projectile/arc/proc/distance_flown()
	var/datum/point/current_point = new(src)
	var/datum/point/starting_point = new(starting)
	return pixel_length_between_points(current_point, starting_point)

/obj/projectile/arc/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	fired_dir = get_dir(user, target) // Used to determine if the projectile should turn in the air.
	distance_to_fly = calculate_initial_pixel_distance(user, target) // Calculates how many pixels to travel before hitting the ground.
	..() // Does the actual launching. The projectile will be out after this.

// For legacy.
/obj/projectile/arc/old_style_target(atom/target, atom/source)
	..()
	fired_dir = get_dir(source, target)
	distance_to_fly = calculate_initial_pixel_distance(source, target)

/obj/projectile/arc/physics_iteration(pixels)
	// Do the other important stuff first.
	. = ..()

	// Test to see if its time to 'hit the ground'.
	var/pixels_flown = distance_flown()

	if(pixels_flown >= distance_to_fly)
		legacy_on_range() // This will also cause the projectile to be deleted.

	else
		// Handle visual projectile turning in flight.
		var/arc_progress = clamp( pixels_flown / distance_to_fly, 0,  1)
		var/new_visual_degree = LERP(45, 135, arc_progress)

		if(fired_dir & EAST)
			adjust_rotation(new_visual_degree)
		else if(fired_dir & WEST)
			adjust_rotation(-new_visual_degree)

		// Now for the fake height.
		var/arc_max_pixel_height = distance_to_fly / 2
		var/sine_position = arc_progress * 180
		var/pixel_z_position = (arc_max_pixel_height * sin(sine_position)) + visual_y_offset
		animate(src, pixel_z = pixel_z_position, time = 1, flags = ANIMATION_END_NOW)

		// Update our shadow.
		if(shadow)
			shadow.forceMove(loc)
			shadow.pixel_x = pixel_x
			shadow.pixel_y = pixel_y + visual_y_offset

/obj/effect/projectile_shadow
	name = "shadow"
	desc = "You better avoid the thing coming down!"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "arc_shadow"
	anchored = TRUE
	animate_movement = 0 // Just like the projectile it's following.

//* We do not hit normally. *//

/obj/projectile/arc/scan_crossed_atom(atom/movable/target)
	return

/obj/projectile/arc/scan_moved_turf(turf/tile)
	return

/obj/projectile/arc/impact_loop(turf/was_moving_onto, atom/bumped)
	return
