/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	item_state = "card-id"
	w_class = WEIGHT_CLASS_SMALL
	materials_base = list(MAT_STEEL = 30, MAT_GLASS = 10)
	var/list/design_ids
	var/design_capacity = 12

/obj/item/disk/design_disk/proc/get_max_capacity()
	return design_capacity

/obj/item/disk/design_disk/proc/get_designs()
	return design_ids

/obj/item/disk/design_disk/proc/design_count()
	return LAZYLEN(design_ids)

/obj/item/disk/design_disk/proc/used_storage()
	var/tally = 0
	for(var/check in design_ids)
		var/datum/prototype/design/D = RSdesigns.fetch(check)
		tally += D?.complexity
	return tally

/obj/item/disk/design_disk/proc/get_remaining_capacity()
	return (design_capacity - used_storage())

/obj/item/disk/design_disk/proc/add_design_force(var/added_id)
	LAZYDISTINCTADD(design_ids, added_id)
	return TRUE

/obj/item/disk/design_disk/proc/del_design_force(var/removed_id)
	LAZYREMOVE(design_ids, removed_id)
	return TRUE

/obj/item/disk/design_disk/proc/add_design(var/id_or_design_datum_to_add)
	var/datum/prototype/design/blueprint
	if(istype(id_or_design_datum_to_add, /datum/prototype/design))
		blueprint = id_or_design_datum_to_add
	else
		blueprint = RSdesigns.fetch(id_or_design_datum_to_add)
	if(!blueprint)
		return FALSE
	if(get_remaining_capacity() > blueprint.complexity)
		return add_design_force(blueprint.id)
	return FALSE

/obj/item/disk/design_disk/proc/remove_design(var/id_or_design_datum_to_del)
	var/datum/prototype/design/blueprint
	if(istype(id_or_design_datum_to_del, /datum/prototype/design))
		blueprint = id_or_design_datum_to_del
	else
		blueprint = RSdesigns.fetch(id_or_design_datum_to_del)
	if(!blueprint)
		return FALSE
	if(blueprint.id in design_ids)
		return del_design_force(blueprint.id)
	return FALSE

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	design_ids = list()
	pixel_x = rand(-5.0, 5)
	pixel_y = rand(-5.0, 5)
