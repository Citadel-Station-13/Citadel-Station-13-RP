/// From base of obj/item/dropped: (mob/user, inv_op_flags, atom/new_loc)
#define COMSIG_ITEM_DROPPED "item_drop"
	#define COMPONENT_ITEM_DROPPED_RELOCATE				(1<<0)
	#define COMPONENT_ITEM_DROPPED_SUPPRESS_SOUND		(1<<1)
/// From base of obj/item/pickup: (mob/user, inv_op_flags, atom/old_loc)
#define COMSIG_ITEM_PICKUP "item_pickup"
/// From base of obj/item/equipped(): (/mob/equipper, slot_id, inv_op_flags)
#define COMSIG_ITEM_EQUIPPED "item_equip"
/// From base of obj/item/unequipped(): (/mob/unequipped, slot_id, inv_op_flags)
#define COMSIG_ITEM_UNEQUIPPED "item_unequip"
