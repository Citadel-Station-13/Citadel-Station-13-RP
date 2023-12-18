//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * point to point shuttle controller
 *
 * we have two destinations, linked directly via shuttle ids
 *
 * please use web shuttles for multi-dock one-destination.
 */
/datum/shuttle_controller/ferry
	tgui_module = "TGUIShuttleFerry"
	/// home dock id or typepath
	var/dock_home_id
	/// away dock id or typepath
	var/dock_away_id
	#warn hook init for both



