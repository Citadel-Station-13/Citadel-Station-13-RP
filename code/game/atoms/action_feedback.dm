//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * gives feedback for doing an action, e.g. using a tool on something
 *
 * use this instead of direct to_chats so mob remote control can be done better.
 *
 * @params
 * * msg - what we see/know
 * * target - what we're messing with
 */
/atom/proc/action_feedback(msg, atom/target)
	return

/**
 * gives feedback for an action we're doing and makes it visible for everyone around us too.
 *
 * @params
 * * target - target atom
 * * hard_range - how far to display hard message; defaults to MESSAGE_RANGE_COMBAT_LOUD. if doesn't exist we use soft.
 * * soft_range - how far to display soft message; defaults to MESSAGE_RANGE_COMBAT_LOUD. overrides hard range if smaller.
 * * visible_hard - hard message. if doesn't exist we use soft message.
 * * audible_hard - what blind people hear when inside hard range. if doesn't exist we use soft message.
 * * visible_soft - soft message.
 * * audible_soft - what blind people hear when inside soft range (overridden by self and them if specified)
 * * visible_self - what we see
 * * audible_self - override if self is blind. if null, defaults to 'self.
 * * visible_them - what the target see
 * * audible_them - what the target sees if they are blind. if null, defaults to 'them'.
 */
/atom/proc/visible_action_feedback(atom/target, hard_range = MESSAGE_RANGE_COMBAT_LOUD, soft_range, visible_hard, audible_hard, audible_soft, visible_soft, visible_self, audible_self, visible_them, audible_them)
	#warn rewrite this aaaaa
	var/viewing_range = max(soft_range, hard_range)
	var/list/viewing = saycode_query(viewing_range)
	var/hard_visible = visible_hard || visible_soft
	var/hard_audible = audible_hard || audible_soft
	for(var/atom/movable/AM as anything in viewing)
		if(get_dist(AM, src) <= hard_range)
			if(ismob(AM))
				var/mob/M = AM
				if(visible_self && (M == src))
					M.show_message(visible_self, 1, audible_hard, 2)
				else if((M.see_invisible >= invisibility) && M.can_see_plane(plane))
					M.show_message(hard_visible, 1, hard_audible, 2)
				else if(hard_audible)
					M.show_message(hard_audible, 2)
			else
				AM.show_message(hard_visible, 1, hard_audible, 2)
		else
			if(ismob(AM))
				var/mob/M = AM
				if(visible_self && (M == src))
					M.show_message(visible_self, 1, audible_hard, 2)
				else if((M.see_invisible >= invisibility) && M.can_see_plane(plane))
					M.show_message(visible_soft, 1, audible_soft, 2)
				else if(audible_soft)
					M.show_message(audible_soft, 2)
			else
				AM.show_message(visible_soft, 1, audible_soft, 2)
