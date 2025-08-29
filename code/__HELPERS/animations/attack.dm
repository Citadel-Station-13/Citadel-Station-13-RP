//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * 'bounce' towards a target
 *
 * @params
 * * target - the target
 * * time - animation duration
 * * dist - pixels to move
 */
/atom/movable/proc/animate_swing_at_target(atom/target, time = 3, dist = 8)
	var/mob_rotation = pick(10, -10)
	var/matrix/original = matrix(transform)
	var/matrix/rotated = matrix(transform)
	rotated.Turn(mob_rotation)
	if(get_turf(target) == get_turf(src))
		// just jump up and down lmao
		var/cpz = pixel_z
		animate(src, pixel_z = dist * (1 / 2), time = time * (1 / 3), transform = rotated, flags = ANIMATION_PARALLEL, easing = EASE_IN | BACK_EASING)
		animate(pixel_z = cpz, time = time * (2 / 3), transform = original, easing = SINE_EASING)
		return
	var/angle = get_visual_angle(src, target)
	var/cpx = pixel_x
	var/cpy = pixel_y
	var/d_x = sin(angle) * dist + cpx
	var/d_y = cos(angle) * dist + cpy
	// fast bounce, with a bit of angular rotation
	animate(src, pixel_x = d_x, pixel_y = d_y, time = time * (1 / 3), transform = rotated, flags = ANIMATION_PARALLEL, easing = EASE_IN | BACK_EASING)
	animate(pixel_x = cpx, pixel_y = cpy, time = time * (2 / 3), transform = original, easing = SINE_EASING)

/**
 * animate *incoming* weapon attacks
 *
 * @params
 * * attacker - (optional) what hit us
 * * weapon - thing hitting us
 * * time - animation duration
 */
/atom/proc/animate_hit_by_weapon(atom/attacker, obj/item/weapon, time = 8)
	// make sure it exists
	if(isnull(weapon))
		return

	// todo: overlays/vis contents?
	var/image/rendering = image(weapon, loc = src)

	// yeah we don't care about the mob's state, we're an animation
	rendering.appearance_flags = KEEP_APART | RESET_ALPHA | RESET_TRANSFORM | RESET_COLOR
	rendering.plane = MOB_PLANE
	rendering.layer = layer + 0.01

	// size down
	rendering.transform = matrix() * 0.4

	// 'slide' the weapon across us while it fades
	#define ATTACK_ITEM_OFFSET 12
	if(isnull(attacker) || attacker == src)
		rendering.pixel_z = ATTACK_ITEM_OFFSET
	else
		var/angle = get_visual_angle(attacker)
		var/d_x = sin(angle) * ATTACK_ITEM_OFFSET
		var/d_y = cos(angle) * ATTACK_ITEM_OFFSET
		rendering.pixel_x = d_x
		rendering.pixel_y = d_y
	#undef ATTACK_ITEM_OFFSET

	flick_overlay(rendering, GLOB.clients, time)

	animate(rendering, alpha = 175, transform = matrix() * 0.7, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = time * (1 / 2), easing = BACK_EASING | EASE_OUT)
	animate(alpha = 0, time = time * (1 / 2), easing = SINE_EASING | EASE_OUT)

/**
 * animate some kind of predetermined attack effect
 *
 * @params
 * * animation_type - ATTACK_ANIMATION_X enum
 * * time - how long; this is sometimes ignored due to animations having hardcoded length.
 */
/atom/proc/animate_hit_by_attack(animation_type = ATTACK_ANIMATION_PUNCH, time = 6)
	#define ATTACK_ANIMATION_FILE 'icons/effects/attack_animations.dmi'
	var/image/rendering = image(ATTACK_ANIMATION_FILE, icon_state = animation_type, loc = src)
	flick_overlay(rendering, GLOB.clients, time)

	// yeah we don't care about the mob's state, we're an animation
	rendering.appearance_flags = KEEP_APART | RESET_ALPHA | RESET_TRANSFORM | RESET_COLOR
	rendering.plane = MOB_PLANE

	// just make it fade out
	animate(rendering, alpha = 175, time = time * (1 / 2))
	animate(alpha = 0, time = time * (1 / 2), easing = SINE_EASING | EASE_OUT)

	#undef ATTACK_ANIMATION_FILE
