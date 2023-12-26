//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * modules are modular items that can be inserted into specific slots on the rig.
 */
/obj/item/rig_module
	#warn impl all

	//* UI
	//! todo: this is fucking evil
	/// cached b64 string of our UI icon
	var/cached_tgui_icon_b64
	/// is our UI update queued?
	var/ui_update_queued = FALSE

