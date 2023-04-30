/datum/element/clothing/hud_granter
	id_arg_index = 2
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	/// huds
	var/list/huds
	/// relevant slots
	var/list/slots

/datum/element/clothing/hud_granter/Attach(datum/target, list/huds, list/slots)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	src.slots = slots
	src.huds = huds
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/on_equip)
	RegisterSignal(target, COMSIG_ITEM_UNEQUIPPED, .proc/on_unequip)

/datum/element/clothing/hud_granter/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))

/datum/element/clothing/hud_granter/proc/on_equip(datum/source, mob/M, slot)
	if(!(slot in slots))
		return
	for(var/hud in huds)
		var/datum/atom_hud/H = GLOB.huds[hud]
		H.add_hud_to(M)

/datum/element/clothing/hud_granter/proc/on_unequip(datum/source, mob/M, slot)
	if(!(slot in slots))
		return
	for(var/hud in huds)
		var/datum/atom_hud/H = GLOB.huds[hud]
		H.remove_hud_from(M)
