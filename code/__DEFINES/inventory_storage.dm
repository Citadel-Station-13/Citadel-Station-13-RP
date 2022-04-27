//* ALL DEFINES RELATED TO INVENTORY OBJECTS, MANAGEMENT, ETC, GO HERE *//

//ITEM INVENTORY WEIGHT, FOR w_class
/// Usually items smaller then a human hand, (e.g. playing cards, lighter, scalpel, coins/holochips)
#define ITEMSIZE_TINY     1
/// Pockets can hold small and tiny items, (e.g. flashlight, multitool, grenades, GPS device)
#define ITEMSIZE_SMALL    2
/// Standard backpacks can carry tiny, small & normal items, (e.g. fire extinguisher, stun baton, gas mask, metal sheets)
#define ITEMSIZE_NORMAL   3
/// Items that can be weilded or equipped but not stored in an inventory, (e.g. defibrillator, backpack, space suits)
#define ITEMSIZE_LARGE    4
/// Usually represents objects that require two hands to operate, (e.g. shotgun, two-handed melee weapons)
#define ITEMSIZE_HUGE     5
/// Essentially means it cannot be picked up or placed in an inventory, (e.g. mech parts, safe)
#define ITEMSIZE_GIGANTIC 6
/// Use this to forbid item from being placed in a container.
#define ITEMSIZE_NO_CONTAINER 100


//? Tweak these to determine how much space an item takes in a container.
//? Look in storage.dm for get_storage_cost(), which uses these.  Containers also use these as a reference for size.
//? ITEMSIZE_COST_NORMAL is equivalent to one slot using the old inventory system.  As such, it is a nice reference to use for
//? defining how much space there is in a container.
#define ITEMSIZE_COST_TINY            1
#define ITEMSIZE_COST_SMALL           2
#define ITEMSIZE_COST_NORMAL          4
#define ITEMSIZE_COST_LARGE           8
#define ITEMSIZE_COST_HUGE           16
#define ITEMSIZE_COST_NO_CONTAINER 1000

//? Container sizes.  Note that different containers can hold a maximum ITEMSIZE.
#define INVENTORY_STANDARD_SPACE	ITEMSIZE_COST_NORMAL * 7 // 28
#define INVENTORY_DUFFLEBAG_SPACE	ITEMSIZE_COST_NORMAL * 10 // 36
#define INVENTORY_BOX_SPACE			ITEMSIZE_COST_SMALL * 7

//* ITEM INVENTORY SLOT BITMASKS *//
/// Suit slot (armors, costumes, space suits, etc.)
#define ITEM_SLOT_OCLOTHING (1<<0)
/// Jumpsuit slot
#define ITEM_SLOT_ICLOTHING (1<<1)
/// Glove slot
#define ITEM_SLOT_GLOVES (1<<2)
/// Glasses slot
#define ITEM_SLOT_EYES (1<<3)
/// Ear slot (radios, earmuffs)
#define ITEM_SLOT_EARS (1<<4)
/// Mask slot
#define ITEM_SLOT_MASK (1<<5)
/// Head slot (helmets, hats, etc.)
#define ITEM_SLOT_HEAD (1<<6)
/// Shoe slot
#define ITEM_SLOT_FEET (1<<7)
/// ID slot
#define ITEM_SLOT_ID (1<<8)
/// Belt slot
#define ITEM_SLOT_BELT (1<<9)
/// Back slot
#define ITEM_SLOT_BACK (1<<10)
/// Dextrous simplemob "hands" (used for Drones and Dextrous Guardians)
#define ITEM_SLOT_DEX_STORAGE (1<<11)
/// Neck slot (ties, bedsheets, scarves)
#define ITEM_SLOT_NECK (1<<12)
/// A character's hand slots
#define ITEM_SLOT_HANDS (1<<13)
/// Inside of a character's backpack
#define ITEM_SLOT_BACKPACK (1<<14)
/// Suit Storage slot
#define ITEM_SLOT_SUITSTORE (1<<15)
/// Left Pocket slot
#define ITEM_SLOT_LPOCKET (1<<16)
/// Right Pocket slot
#define ITEM_SLOT_RPOCKET (1<<17)
/// Handcuff slot
#define ITEM_SLOT_HANDCUFFED (1<<18)
/// Legcuff slot (bolas, beartraps)
#define ITEM_SLOT_LEGCUFFED (1<<19)


//! This all needs a refactor to tg storage but for now..
/// Maximum you can reach down to grab things from storage.
#define MAX_STORAGE_REACH 2
