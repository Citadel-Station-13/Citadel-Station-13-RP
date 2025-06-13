//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* /datum/inventory_slot slot_equip_checks flags *//
/// check slot flags - must match
#define SLOT_EQUIP_CHECK_USE_FLAGS			(1<<0)
/// use proc
#define SLOT_EQUIP_CHECK_USE_PROC			(1<<1)

DEFINE_BITFIELD(slot_equip_checks, list(
	BITFIELD(SLOT_EQUIP_CHECK_USE_FLAGS),
	BITFIELD(SLOT_EQUIP_CHECK_USE_PROC),
))

//* /datum/inventory_slot inventory_slot_flags *//

/// render on mob
#define INV_SLOT_IS_RENDERED				(1<<0)
/// considered worn equipment
#define INV_SLOT_CONSIDERED_WORN			(1<<1)
/// allow random uid
#define INV_SLOT_ALLOW_RANDOM_ID			(1<<2)
/// considered inventory? mob can access normally from hud if so
#define INV_SLOT_IS_INVENTORY				(1<<3)
/// hide unless inv is expanded
#define INV_SLOT_HUD_REQUIRES_EXPAND		(1<<4)
/// considered abstract - represents a logical action, isn't actually an item holding slot
#define INV_SLOT_IS_ABSTRACT				(1<<5)
/// show on strip menu?
#define INV_SLOT_IS_STRIPPABLE				(1<<6)
/// simple stripping - show slot + link, do not show item regardless of obfuscation. handles obfuscation differently.
#define INV_SLOT_STRIP_SIMPLE_LINK			(1<<7)
/// do not show on strip panel unless it's occupied by an item
#define INV_SLOT_STRIP_ONLY_REMOVES			(1<<8)

DEFINE_BITFIELD(inventory_slot_flags, list(
	BITFIELD(INV_SLOT_IS_RENDERED),
	BITFIELD(INV_SLOT_CONSIDERED_WORN),
	BITFIELD(INV_SLOT_ALLOW_RANDOM_ID),
	BITFIELD(INV_SLOT_IS_INVENTORY),
	BITFIELD(INV_SLOT_HUD_REQUIRES_EXPAND),
	BITFIELD(INV_SLOT_IS_ABSTRACT),
	BITFIELD(INV_SLOT_IS_STRIPPABLE),
	BITFIELD(INV_SLOT_STRIP_SIMPLE_LINK),
	BITFIELD(INV_SLOT_STRIP_ONLY_REMOVES),
))

//* /datum/inventory_slot inventory_filter_flags *//

#define INV_FILTER_UNKNOWN (1<<1)
#define INV_FILTER_EQUIPMENT (1<<2)
#define INV_FILTER_RESTRAINTS (1<<3)

/// specially handled value
#define INV_FILTER_HANDS (1<<23)

DEFINE_BITFIELD_NEW(inv_slot_filter, list(
	/datum/inventory_slot = list(
		NAMEOF_TYPE(/datum/inventory_slot, inventory_filter_flags),
	),
), list(
	BITFIELD_NEW("Unknown", INV_FILTER_UNKNOWN),
	BITFIELD_NEW("Equipment", INV_FILTER_EQUIPMENT),
	BITFIELD_NEW("Restraints", INV_FILTER_RESTRAINTS),
	BITFIELD_NEW("Hands", INV_FILTER_HANDS),
))


// rest got converted to typepath ids
// one day i'll come for you, inhand icons.
// one day.... mark my words...

/// global list of default slots to use when equipping to appropriate slot
GLOBAL_LIST_INIT(slot_equipment_priority, meta_slot_equipment_priority())

/proc/meta_slot_equipment_priority()
	return list(
		SLOT_ID_BACK,
		SLOT_ID_WORN_ID,
		SLOT_ID_UNIFORM,
		SLOT_ID_SUIT,
		SLOT_ID_MASK,
		SLOT_ID_HEAD,
		SLOT_ID_SHOES,
		SLOT_ID_GLOVES,
		SLOT_ID_LEFT_EAR,
		SLOT_ID_RIGHT_EAR,
		SLOT_ID_GLASSES,
		SLOT_ID_BELT,
		SLOT_ID_SUIT_STORAGE,
		/datum/inventory_slot/abstract/attach_as_accessory,
		SLOT_ID_LEFT_POCKET,
		SLOT_ID_RIGHT_POCKET
	)

