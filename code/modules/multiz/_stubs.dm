/obj/landmark/map_data
	name = "Unknown"
	desc = "An unknown location."
	invisibility = 101

	/// The number of Z-Levels in the map.
	var/height = 1
	/// What the map edge should be formed with. (null = world.turf)
	var/turf/edge_type

// FOR THE LOVE OF GOD USE THESE.  DO NOT FUCKING SPAGHETTIFY THIS.
// Use the Has*() functions if you ONLY need to check.
// If you need to do something, use Get*().
HasAbove(var/z)
HasBelow(var/z)
// These give either the turf or null.
GetAbove(var/atom/atom)
GetBelow(var/atom/atom)
