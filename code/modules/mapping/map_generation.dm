//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

GLOBAL_VAR_INIT(map_generation_mutex, FALSE)

/proc/is_map_generation_mutex_locked()
	return map_generation_mutex

/proc/try_with_map_generation_mutex(datum/callback/callback)
	if(map_generation_mutex)
		return null
	return with_map_generation_mutex(callback)

/proc/with_map_generation_mutex(datum/callback/callback)
	UNTIL(!map_generation_mutex)
	map_generation_mutex = TRUE
	. = callback.Invoke()
	map_generation_mutex = FALSE

GLOBAL_VAR_INIT(map_generation_cycle, 0)

/proc/next_map_generation_cycle()
	. = ++map_generation_cycle
	if(map_generation_cycle > SHORT_REAL_LIMIT)
		map_generation_cycle = -(SHORT_REAL_LIMIT - 1)
