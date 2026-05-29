//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/shuttle_dock/ferry_pair
	/// Are we the home or away dock in this pair? Used for controller init.
	var/ferry_init_is_home
	/// Typepath of the other dock to bind to. Used for controller init.
	var/ferry_init_bind_opposite_typepath
	/// When initializing shuttle, kick the shuttle to the other side if possible instead
	/// * Useful when you want a large pad on Centcom that can accomodate
	///   shuttles from many different stations.
	var/ferry_init_kick_to_home = FALSE

#warn impl

#warn impl
