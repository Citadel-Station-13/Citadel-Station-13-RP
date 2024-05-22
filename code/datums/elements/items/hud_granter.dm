/datum/element/hud_granter
	id_arg_index = 2
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	/// huds
	var/list/huds
	/// relevant slots
	var/list/slots

/datum/element/hud_granter/Attach(datum/target, list/huds, list/slots)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.huds = huds
	src.slots = islist(slots)? slots : list(slots)
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(target, COMSIG_ITEM_UNEQUIPPED, PROC_REF(on_unequip))

/datum/element/hud_granter/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))

/datum/element/hud_granter/proc/on_equip(datum/source, mob/M, slot)
	if(!(slot in slots))
		return
	for(var/hud in huds)
		M.self_perspective.add_atom_hud(hud)

/datum/element/hud_granter/proc/on_unequip(datum/source, mob/M, slot)
	if(!(slot in slots))
		return
	for(var/hud in huds)
		M.self_perspective.remove_atom_hud(hud)
