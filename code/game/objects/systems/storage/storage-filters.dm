//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/object_system/storage/proc/check_insertion_filters(obj/item/candidate)
	if(insertion_allow_typecache?[candidate.type])
		return TRUE
	if(!isnull(insertion_whitelist_typecache) && !insertion_whitelist_typecache?[candidate.type])
		return FALSE
	if(insertion_blacklist_typecache?[candidate.type])
		return FALSE
	return TRUE

/datum/object_system/storage/proc/set_insertion_whitelist(list/types)
	if(!length(types))
		src.insertion_whitelist_typecache = null
		return
	src.insertion_whitelist_typecache = cached_typecacheof(types)

/datum/object_system/storage/proc/set_insertion_blacklist(list/types)
	if(!length(types))
		src.insertion_blacklist_typecache = null
		return
	src.insertion_blacklist_typecache = cached_typecacheof(types)

/datum/object_system/storage/proc/set_insertion_allow(list/types)
	if(!length(types))
		src.insertion_allow_typecache = null
		return
	src.insertion_allow_typecache = cached_typecacheof(types)
