//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* for /datum/inventory *//

/// raised with (obj/item/item, datum/inventory_slot/slot_or_index)
///
/// * raised after COMSIG_INVENTORY_ITEM_EXITED_SLOT during swaps
#define COMSIG_INVENTORY_ITEM_ENTERED_SLOT "inventory-item-entered-slot"
/// raised with (obj/item/item, datum/inventory_slot/slot_or_index)
///
/// * raised before COMSIG_INVENTORY_ITEM_ENTERED_SLOT during swaps
#define COMSIG_INVENTORY_ITEM_EXITED_SLOT "inventory-item-exited-slot"
