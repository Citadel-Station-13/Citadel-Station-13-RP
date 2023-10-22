/// From base of obj/item/dropped: (mob/user, flags, atom/newLoc)
#define COMSIG_ITEM_DROPPED "item_drop"
/// From base of obj/item/pickup: (mob/user, flags, atom/oldLoc)
#define COMSIG_ITEM_PICKUP "item_pickup"
/// From base of obj/item/equipped(): (/mob/equipper, slot, flags)
#define COMSIG_ITEM_EQUIPPED "item_equip"
/// From base of obj/item/unequipped(): (/mob/unequipper, slot, flags)
#define COMSIG_ITEM_UNEQUIPPED "item_unequip"

//* Return values for all of the above 4 signals
//  todo: implement on pickup
//  todo: implement on unequipped
//  todo: implement on equipped
	#define COMOPNENT_ITEM_INV_OP_RELOCATE				(1<<0)
	#define COMOPNENT_ITEM_INV_OP_SUPPRESS_SOUND		(1<<1)


/// Called on [/obj/item] before unequip from base of [mob/proc/doUnEquip]: (force, atom/newloc, no_move, invdrop, silent)
////#define COMSIG_ITEM_PRE_UNEQUIP "item_pre_unequip"
	///? Only the pre unequip can be cancelled.
	////#define COMPONENT_ITEM_BLOCK_UNEQUIP (1<<0)
/// Called on [/obj/item] AFTER unequip from base of [mob/proc/doUnEquip]: (force, atom/newloc, no_move, invdrop, silent)
////#define COMSIG_ITEM_POST_UNEQUIP "item_post_unequip"
