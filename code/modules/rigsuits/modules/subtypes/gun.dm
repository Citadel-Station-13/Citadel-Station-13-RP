//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * rig-mounted gun
 * * please refrain from using these over item_deploy if possible. these are
 *   generally going to be quite powerful. they're only included for completeness;
 *   they're Really Quite Bad.
 */
/obj/item/rig_module/gun
	/// automatically sets everything as needed.
	var/lazy_automount_path

#warn impl
