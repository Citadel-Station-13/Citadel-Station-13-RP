//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/proc/erase_maptext_on_turfs(list/turf/turfs)
	for(var/turf/T in turfs)
		T.maptext = null
