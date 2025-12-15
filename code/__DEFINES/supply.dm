//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Supply Packs - Flags *//

/// prevent private orders from overriding access locks
///
/// * for things that are somewhat dangerous and should require access
#define SUPPLY_PACK_LOCK_PRIVATE_ORDERS (1<<0)
/// private orders are subject to approval queues rather than being automatically approved once paid
///
/// * for things that are too dangerous to allow random ordering
#define SUPPLY_PACK_RESTRICT_PRIVATE_ORDERS (1<<1)

DEFINE_BITFIELD_NAMED(supply_pack_flags, list(
	/datum/supply_pack = list(
		"supply_pack_flags",
	),
), list(
	BITFIELD_NAMED("Always Access Restricted", SUPPLY_PACK_LOCK_PRIVATE_ORDERS),
	BITFIELD_NAMED("Restricted Private Orders", SUPPLY_PACK_RESTRICT_PRIVATE_ORDERS),
))

//* Supply Entity Descriptors *//

/// decode as material
#define SUPPLY_DESCRIPTOR_HINT_MATERIAL "material"
/// decode as gas
#define SUPPLY_DESCRIPTOR_HINT_GAS "gas"
/// decode as prototype (SSpersistence prototype descriptors)
#define SUPPLY_DESCRIPTOR_HINT_PROTOTYPE "prototype"
