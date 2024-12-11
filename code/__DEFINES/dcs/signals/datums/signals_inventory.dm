//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* for /datum/inventory *//

/// raised with (obj/item/item, datum/inventory_slot/slot_or_index)
///
/// * raised after COMSIG_INVENTORY_ITEM_EXITED during swaps
#define COMSIG_INVENTORY_ITEM_ENTERED "inventory-item-entered-slot"
/// raised with (obj/item/item, datum/inventory_slot/slot_or_index)
///
/// * raised before COMSIG_INVENTORY_ITEM_ENTERED during swaps
#define COMSIG_INVENTORY_ITEM_EXITED "inventory-item-exited-slot"
/// raised with ()
///
/// * raised on any inventory slot mutation
#define COMSIG_INVENTORY_SLOT_REBUILD "inventory-slot-rebuild"
