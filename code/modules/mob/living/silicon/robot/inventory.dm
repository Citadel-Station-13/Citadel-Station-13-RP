//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such
// todo: proper inv procs
//! WARNING: we currently only call equipped/unequipped and jankily using SLOT_ID_HANDS...

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_held_item()
	return module_active

//TODO: Something apparently?

/* for now we don't use generic slots at all */
// TODO: put in hands should try to put into grippers ~silicons

/mob/living/silicon/robot/is_in_inventory(obj/item/I)
	return is_module_item(I) || is_in_gripper(I)

/mob/living/silicon/robot/proc/is_in_gripper(obj/item/I, require_active_module)
	return (																										\
		I.loc == src?																								\
		!!gripper_holding(I) :																						\
		(istype(I.loc, /obj/item/gripper) && (require_active_module? is_holding(I.loc) : is_module_item(I.loc)))	\
	)

/mob/living/silicon/robot/proc/gripper_holding(obj/item/I)
	for(var/obj/item/gripper/G in module.modules)
		if(G.get_item() == I)
			return G

/mob/living/silicon/robot/proc/unreference_from_gripper(obj/item/I, newloc)
	if(!istype(I.loc, /obj/item/gripper))
		return FALSE
	var/obj/item/gripper/G = I.loc
	if(!is_module_item(G))
		return FALSE
	if(G.get_item() != I)
		return FALSE
	G.remove_item(newloc)
	return TRUE
