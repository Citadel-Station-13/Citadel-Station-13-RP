/datum/element/vision_granter
	id_arg_index = 2
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH

	/// darksight
	var/datum/vision/modifier
	/// relevant slots
	var/list/slots

/datum/element/vision_granter/Attach(datum/target, datum/vision/modifier, list/slots)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.modifier = modifier
	src.slots = islist(slots)? slots : list(slots)
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(target, COMSIG_ITEM_UNEQUIPPED, PROC_REF(on_unequip))

/datum/element/vision_granter/Detach(datum/source)
	. = ..()
	UnregisterSignal(source, list(
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED
	))

/datum/element/vision_granter/proc/on_equip(datum/source, mob/M, slot)
	if(!(slot in slots))
		return
	M.add_vision_modifier(modifier)

/datum/element/vision_granter/proc/on_unequip(datum/source, mob/M, slot)
	if(!(slot in slots))
		return
	M.remove_vision_modifier(modifier)
