//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * 'bounce' towards a target
 *
 * @params
 * * target - the target
 * * time - animation duration
 * * dist - pixels to move
 */
/atom/movable/proc/animate_swing_at_target(atom/target, time = 3, dist = 8)
	var/angle = get_visual_angle(src, target)
	var/d_x = sin(angle) * dist
	var/d_y = cos(angle) * dist
	var/mob_rotation = pick(10, -10)
	var/matrix/original = matrix(transform)
	var/matrix/rotated = matrix(transform)
	rotated.Turn(mob_rotation)
	// fast bounce, with a bit of angular rotation
	animate(src, pixel_x = d_x, pixel_y = d_y, time = time * (1 / 3), transform = rotated, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE, easing = EASE_IN | BACK_EASING)
	animate(pixel_x = -d_x, pixel_y = -d_y, time = time * (2 / 3), transform = original, flags = ANIMATION_RELATIVE, easing = SINE_EASING)

/**
 * animate *incoming* weapon attacks
 *
 * @params
 * * weapon - thing hitting us
 * * time - animation duration
 */
/atom/movable/proc/animate_hit_by_weapon(obj/item/weapon, time = 8)
	// todo: overlays/vis contents?
	var/image/rendering = image(weapon, loc = src)
	flick_overlay(rendering, GLOB.clients, time)

	// 'slide' the weapon across us while it fades

	#warn impl

/**
 * animate some kind of predetermined attack effect
 *
 * @params
 * * animation_type - ATTACK_ANIMATION_X enum
 * * time - how long; this is sometimes ignored due to animations having hardcoded length.
 */
/atom/movable/proc/animate_hit_by_attack(animation_type, time = 6)
	#define ATTACK_ANIMATION_FILE 'icons/effects/attack_animations.dmi'
	var/image/rendering = image(ATTACK_ANIMATION_FILE, icon_state = animation_type, loc = src)
	flick_overlay(rendering, GLOB.clients, time)

	// just make it fade out
	animate(rendering, alpha = 175, time = time * (1 / 2))
	animate(alpha = 0, time = time * (1 / 2), easing = SINE_EASING | EASE_OUT)

	#undef ATTACK_ANIMATION_FILE
