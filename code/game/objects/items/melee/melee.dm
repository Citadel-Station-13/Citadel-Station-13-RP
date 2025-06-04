/datum/passive_parry/melee
	parry_arc = 155
	parry_arc_round_down = TRUE

/**
 * this is just as silly as /device and /weapon most of the time.
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
	passive_parry = /datum/passive_parry{
		parry_chance_melee = 5;
	}
