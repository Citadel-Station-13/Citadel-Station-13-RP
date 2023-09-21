/// all mobs
GLOBAL_LIST_EMPTY(mob_list)
/// all player mobs (not clients!)
GLOBAL_LIST_EMPTY(player_list)

/// by id
GLOBAL_LIST_INIT(sprite_accessory_hair, all_hair_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_ears, all_ear_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_tails, all_tail_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_wings, all_wing_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_facial_hair, all_facial_hair_styles())
/// by id
GLOBAL_LIST_INIT(sprite_accessory_markings, all_marking_styles())

// todo: most uses of these should either be a direct ref under new marking system or
// todo: an id to ref.
// todo: however, there are some legitimate cases of needing fast name lookup,
// todo: like non-tgui interfaces that let you choose markings
// todo: do not blindly kill these lists, we'll deal with everything as we go.

// by name
GLOBAL_LIST(legacy_hair_lookup)
// by id
GLOBAL_LIST(legacy_ears_lookup)
// by id
GLOBAL_LIST(legacy_wing_lookup)
// by id
GLOBAL_LIST(legacy_tail_lookup)
// by name
GLOBAL_LIST(legacy_facial_hair_lookup)
// by name
GLOBAL_LIST(legacy_marking_lookup)

/proc/all_hair_styles()
	. = list()
	var/list/by_name = list()
	for(var/path in subtypesof(/datum/sprite_accessory/hair))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		if(by_name[S.name])
			stack_trace("duplicate name [S.name] on [path]")
			continue
		.[S.id] = S
		by_name[S.name] = S
	tim_sort(by_name, GLOBAL_PROC_REF(cmp_text_asc), associative = FALSE)
	GLOB.legacy_hair_lookup = by_name
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_ear_styles()
	. = list()
	var/list/by_type = list()
	for(var/path in subtypesof(/datum/sprite_accessory/ears))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		.[S.id] = S
		by_type[S.type] = S
	tim_sort(by_type, GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
	GLOB.legacy_ears_lookup = by_type
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_wing_styles()
	. = list()
	var/list/by_type = list()
	for(var/path in subtypesof(/datum/sprite_accessory/wing))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		.[S.id] = S
		by_type[S.type] = S
	tim_sort(by_type, GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
	GLOB.legacy_wing_lookup = by_type
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_tail_styles()
	. = list()
	var/list/by_type = list()
	for(var/path in subtypesof(/datum/sprite_accessory/tail))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		.[S.id] = S
		by_type[S.type] = S
	tim_sort(by_type, GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
	GLOB.legacy_tail_lookup = by_type
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_facial_hair_styles()
	. = list()
	var/list/by_name = list()
	for(var/path in subtypesof(/datum/sprite_accessory/facial_hair))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		if(by_name[S.name])
			stack_trace("duplicate name [S.name] on [path]")
			continue
		.[S.id] = S
		by_name[S.name] = S
	tim_sort(by_name, GLOBAL_PROC_REF(cmp_text_asc), associative = FALSE)
	GLOB.legacy_facial_hair_lookup = by_name
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)

/proc/all_marking_styles()
	. = list()
	var/list/by_name = list()
	for(var/path in subtypesof(/datum/sprite_accessory/marking))
		var/datum/sprite_accessory/S = path
		if(initial(S.abstract_type) == path)
			continue
		S = new path
		if(!S.id)
			stack_trace("no id on [path]")
			continue
		if(.[S.id])
			stack_trace("duplicate id [S.id] on [path] and [.[S.id]]")
			continue
		if(by_name[S.name])
			stack_trace("duplicate name [S.name] on [path]")
			continue
		.[S.id] = S
		by_name[S.name] = S
	tim_sort(by_name, GLOBAL_PROC_REF(cmp_text_asc), associative = FALSE)
	GLOB.legacy_marking_lookup = by_name
	tim_sort(., GLOBAL_PROC_REF(cmp_name_asc), associative = TRUE)
