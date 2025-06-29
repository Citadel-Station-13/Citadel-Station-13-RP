
//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station developers.          *//

#define OBJ_BIND_ADJACENCY_GROUP(PATH, VARNAME, KEY) \
##PATH { \
	var/datum/object_system/adjacency_group/##VARNAME; \
}; \
##PATH/Initialize(mapload, ...) { \
	. = ..(); \
	if(. == INITIALIZE_HINT_QDEL) { \
		return; \
	}; \
	VARNAME = new(src, KEY); \
}; \
##PATH/Moved(...) { \
	VARNAME.parent_moved(); \
	return ..(); \
}
