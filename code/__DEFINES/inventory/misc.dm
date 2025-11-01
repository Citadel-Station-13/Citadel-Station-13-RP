// proc: dropped() on /obj/item
// todo: this should be in procs.dm and the names need to be changed probably
// todo: comsig instead?
/// relocated; return false
#define ITEM_RELOCATED_BY_DROPPED -1

//* Item `suit_storage_class` defines *//

#define ITEM_SUIT_STORAGE_CLASS_HARDWEAR (1<<0)
#define ITEM_SUIT_STORAGE_CLASS_SOFTWEAR (1<<1)
#define ITEM_SUIT_STORAGE_CLASS_ARMOR (1<<2)

/datum/bitfield/suit_storage_class
	flags = alist(
		ITEM_SUIT_STORAGE_CLASS_HARDWEAR = "Hardwear",
		ITEM_SUIT_STORAGE_CLASS_SOFTWEAR = "Softwear",
		ITEM_SUIT_STORAGE_CLASS_ARMOR = "Armor",
	)
	paths = alist(
		/obj/item = list(
			NAMEOF_TYPE(/obj/item, suit_storage_class),
			NAMEOF_TYPE(/obj/item, suit_storage_class_allow),
			NAMEOF_TYPE(/obj/item, suit_storage_class_disallow),
		),
	)
