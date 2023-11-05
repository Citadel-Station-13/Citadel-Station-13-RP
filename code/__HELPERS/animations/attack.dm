//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * linear 'bounce' towards a target
 *
 * @params
 * * target - the target
 * * time - half of this value is used for approach, the other half retreat
 * * dist - pixels to move
 */
/atom/movable/proc/animate_swing_at_target(atom/target, time = 4, dist = 8)
	var/angle = get_visual_angle(src, target)
	var/d_x = sin(angle) * dist
	var/d_y = cos(angle) * dist
	animate(src, pixel_x = d_x, pixel_y = d_y, time = time / 2, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE)
	animate(pixel_x = -d_x, pixel_y = -d_y, time = time / 2, flags = ANIMATION_RELATIVE)

/**
 * animate *incoming* weapon attacks
 *
 * @params
 * * weapon - thing hitting us
 * * time - animation duration
 */
/atom/movable/proc/animate_hit_by_weapon(obj/item/weapon, time = 3)

/**
 * animate some kind of predetermined attack effect
 *
 * @params
 * * animation_type - ATTACK_ANIMATION_X enum
 * * time - how long; this is usually ignored due to animations having hardcoded length.
 */
/atom/movable/proc/animate_hit_by_attack(animation_type, time = 3)
	#define ATTACK_ANIMATION_FILE 'icons/effects/attack_animations.dmi'

	#undef ATTACK_ANIMATION_FILE


#warn impl all
