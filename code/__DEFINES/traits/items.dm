/// prevents an item from being dropped
#define TRAIT_ITEM_NODROP "item-nodrop"
DATUM_TRAIT_NEW(/obj/item, TRAIT_ITEM_NODROP, "Prevents an item from being dropped via most means.")
/// prevents an item from showing on examine, as well as the strip menu.
#define TRAIT_ITEM_HIDE_WORN_EXAMINE "item-hide_worn_examine"
DATUM_TRAIT_NEW(/obj/item, TRAIT_ITEM_HIDE_WORN_EXAMINE, "Prevents an item from being visible on examines and the strip menu.")
