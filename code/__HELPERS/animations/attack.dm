/atom/movable/proc/animate_swing_at_target(atom/target, time = 4, dist = 8)
	var/angle = get_visual_angle(src, target)
	var/d_x = sin(angle) * dist
	var/d_y = cos(angle) * dist
	animate(src, pixel_x = d_x, pixel_y = d_y, time = time / 2, flags = ANIMATION_PARALLEL | ANIMATION_RELATIVE)
	animate(pixel_x = -d_x, pixel_y = -d_y, time = time / 2, flags = ANIMATION_RELATIVE)

/atom/movable/proc/animate_hit_by_weapon(obj/item/weapon, time = 3)

/atom/movable/proc/animate_hit_by_attack(animation_type, time = 3)
	#define ATTACK_ANIMATION_FILE 'icons/effects/attack_animations.dmi'

	#undef ATTACK_ANIMATION_FILE


#warn impl all
