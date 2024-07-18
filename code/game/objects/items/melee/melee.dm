/datum/passive_parry/melee
	parry_arc = 165
	parry_arc_round_down = TRUE

/**
 * this is like /device and /weapon but a little less dumb
 *
 * this has some simple wrappers for default defense stuff, so 'common'ly melee weapons
 * like knives, armblades, etc, can easily use them.
 *
 * * Certain things may or may not 'graduate' to /obj/item level later.
 */
/obj/item/melee
	icon = 'icons/obj/weapons.dmi'
	attack_sound = "swing_hit"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

	/// passive parry data / frame
	///
	/// * anonymous typepath is allowed
	/// * typepath is allowed
	/// * instance is allowed
	///
	/// note that the component will not be modified while held;
	/// if this is changed, the component needs to be remade.
	var/passive_parry = /datum/passive_parry{
		parry_chance_melee = 5;
	}


/obj/item/melee/pickup(mob/user, flags, atom/oldLoc)
	// we load the component here as it hooks equipped,
	// so loading it here means it can still handle the equipped signal.
	if(passive_parry)
		LoadComponent(/datum/component/passive_parry, passive_parry)
	return ..()

/obj/item/melee/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	// get rid of the passive parry component to save memory
	DelComponent(/datum/component/passive_parry)

#warn vv / chance passive_parry type hook
