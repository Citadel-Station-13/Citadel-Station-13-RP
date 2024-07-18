//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/passive_parry/shield
	parry_arc = 135
	#warn default soud

/obj/item/shield
	name = "shield"
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
	var/passive_parry = /datum/passive_parry/shield{
		parry_chance_default = 50;
	}

/obj/item/shield/pickup(mob/user, flags, atom/oldLoc)
	// we load the component here as it hooks equipped,
	// so loading it here means it can still handle the equipped signal.
	if(passive_parry)
		LoadComponent(/datum/component/passive_parry, passive_parry)
	return ..()

/obj/item/shield/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	// get rid of the passive parry component to save memory
	DelComponent(/datum/component/passive_parry)

#warn vv / chance passive_parry type hook

#warn how do we do output text
