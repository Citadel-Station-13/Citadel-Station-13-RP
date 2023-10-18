/// A mob has just equipped an item. Called on [/mob] from base of [/obj/item/equipped()]: (/obj/item/equipped_item, slot, inv_op_flags)
#define COMSIG_MOB_ITEM_EQUIPPED "mob_equipped_item"
/// A mob has just unequipped an item. Called on [/mob] from base of [/obj/item/unequipped()]: (/obj/item/equipped_item, slot, inv_op_flags)
#define COMSIG_MOB_ITEM_UNEQUIPPED "mob_unequipped_item"
/// A mob has just picked up an item. Called on [/mob] from base of [/obj/item/pickup()]: (/obj/item/equipped_item, inv_op_flags, old_loc)
#define COMSIG_MOB_ITEM_PICKUP "mob_pickup_item"
/// A mob has just dropped an item. Called on [/mob] from base of [/obj/item/dropped()]: (/obj/item/equipped_item, inv_op_flags, new_loc)
#define COMSIG_MOB_ITEM_DROPPED "mob_dropped_item"
