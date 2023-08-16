//* Action feedback module
//* Handles giving chat feedback for actions performed by an atom,
//* whether to the atom, to the target, or to everyone around

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
	var/list/viewing
	var/viewing_range = max(soft_range, hard_range)
	//! LEGACY
	if(isbelly(loc))
		var/obj/belly/B = loc
		viewing = B.effective_emote_hearers()
	else
		viewing = get_hearers_in_view(viewing_range, src)
	//! end
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
