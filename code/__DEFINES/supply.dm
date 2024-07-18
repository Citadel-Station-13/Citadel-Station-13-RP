//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Supply Packs - Flags *//

/// prevent private orders from overriding access locks
///
/// * for things that are somewhat dangerous and should require access
#define SUPPLY_PACK_LOCK_PRIVATE_ORDERS (1<<0)
/// prevent private orders at all
///
/// * for things that are too dangerous to allow random ordering
#define SUPPLY_PACK_PREVENT_PRIVATE_ORDERS (1<<1)

#warn new define bitfield; update
DEFINE_BITFIELD(supply_pack_flags, list(
	BITFIELD_NEW(SUPPLY_PACK_LOCK_PRIVATE_ORDERS, "Always Access Restricted"),
	BITFIELD_NEW(SUPPLY_PACK_PREVENT_PRIVATE_ORDERS, "No Private Orders"),
))

//* Supply Entity Descriptors *//

/// decode as material
#define SUPPLY_DESCRIPTOR_HINT_MATERIAL "material"
/// decode as gas
#define SUPPLY_DESCRIPTOR_HINT_GAS "gas"
/// decode as entity (SSpersistence entity descriptors
#define SUPPLY_DESCRIPTOR_HINT_ENTITY "entity"
