//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/atom/movable/coord_log_string()
	if(isturf(loc))
		return "[x],[y],[z]"
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return "null-loc"
	return "nested @ [our_turf.x],[our_turf.y],[our_turf.z]"
