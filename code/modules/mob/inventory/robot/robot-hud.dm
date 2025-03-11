//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/inventory/robot/hud_alter(datum/actor_hud/inventory/hud)
	return ..()

/datum/inventory/robot/hud_object_post_sync(datum/actor_hud/inventory/hud, atom/movable/screen/actor_hud/object)
	..()

#warn impl
