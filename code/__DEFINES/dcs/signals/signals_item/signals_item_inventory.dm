/// From base of obj/item/dropped(mob/user, flags, atom/newLoc): (mob/user)
#define COMSIG_ITEM_DROPPED "item_drop"
	#define COMPONENT_ITEM_DROPPED_RELOCATE				(1<<0)
	#define COMPONENT_ITEM_DROPPED_SUPPRESS_SOUND		(1<<1)
/// From base of obj/item/pickup(mob/user, flags, atom/oldLoc): (/mob/taker)
#define COMSIG_ITEM_PICKUP "item_pickup"
/// From base of obj/item/equipped(): (/mob/equipper, slot, accessory)
#define COMSIG_ITEM_EQUIPPED "item_equip"
/// From base of obj/item/unequipped(): (/mob/unequipped, slot, accessory)
#define COMSIG_ITEM_UNEQUIPPED "item_unequip"
/// Called on [/obj/item] before unequip from base of [mob/proc/doUnEquip]: (force, atom/newloc, no_move, invdrop, silent)
////#define COMSIG_ITEM_PRE_UNEQUIP "item_pre_unequip"
	///? Only the pre unequip can be cancelled.
	////#define COMPONENT_ITEM_BLOCK_UNEQUIP (1<<0)
/// Called on [/obj/item] AFTER unequip from base of [mob/proc/doUnEquip]: (force, atom/newloc, no_move, invdrop, silent)
////#define COMSIG_ITEM_POST_UNEQUIP "item_post_unequip"
