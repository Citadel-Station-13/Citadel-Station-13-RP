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
	#define COMPONENT_ITEM_INV_OP_RELOCATE				(1<<0)
	#define COMPONENT_ITEM_INV_OP_SUPPRESS_SOUND		(1<<1)
