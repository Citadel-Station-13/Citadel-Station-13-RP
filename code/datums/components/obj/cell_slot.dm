/**
 * Simple cell slot component
 *
 * Can only have one per entity for performance reasons, as it would be
 * very difficult to differentiate between these in code otherwise.
 */
/datum/component/cell_slot
	registered_type = /datum/component/cell_slot

	/// held cell
	var/obj/item/cell/cell
	/// reserved - cell type accepted enum, for when we do large/medium/small/etc cells later.
	var/cell_type

/datum/component/cell_slot/Initialize()
	#warn impl

/datum/component/cell_slot/RegisterWithParent()
	. = ..()
	#warn impl

/datum/component/cell_slot/UnregisterFromParent()
	. = ..()
	#warn impl

/datum/component/cell_slot/proc/

/**
 * Grabs our /datum/component/cell_slot cell
 *
 * todo: optimize
 */
/obj/proc/cell_slotted()
	RETURN_TYPE(/obj/item/cell)
	var/datum/component/cell_slot/slot = GetComponent(/datum/component/cell_slot)
	return slot?.cell

#warn maybe odn't do this
