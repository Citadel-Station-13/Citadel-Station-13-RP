//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/observer/dead/double_click_on_special(atom/target, location, control, list/params)
	var/mob/maybe_current = mind?.current
	if(maybe_current && (maybe_current == target || (maybe_current in target)))
		if(can_reenter_corpse)
			reenter_corpse()
			return TRUE
	if(ismovable(target))
		ManualFollow(target)
		return TRUE
	if(isturf(target.loc) || isturf(target))
		forceMove(get_turf(target))
		return TRUE
	return ..()
