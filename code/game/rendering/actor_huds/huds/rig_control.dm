//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/actor_hud/rig_control
	/// owning rig
	var/obj/item/rig/rig

	var/atom/movable/screen/actor_hud/rig_control/active_mouse_module_dock/mouse_module_dock

#warn impl

/atom/movable/screen/actor_hud/rig_control
	abstract_type = /atom/movable/screen/actor_hud/rig_control

/atom/movable/screen/actor_hud/rig_control/active_mouse_module_dock
	var/opened = FALSE

/atom/movable/screen/actor_hud/rig_control/active_mouse_module_dock/proc/open()

/atom/movable/screen/actor_hud/rig_control/active_mouse_module_dock/proc/close()

/atom/movable/screen/actor_hud/rig_control/active_mouse_module

/atom/movable/screen/actor_hud/rig_control/selectable_mouse_module
