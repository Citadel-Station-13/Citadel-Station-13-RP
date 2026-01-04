//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /obj/item/cell/var/cell_type *//

/// handheld devices
#define CELL_TYPE_SMALL (1<<0)
/// medium size devices like inducers, bulky handheld equipment, etc
#define CELL_TYPE_MEDIUM (1<<1)
/// mecha, apcs, large drills, etc
#define CELL_TYPE_LARGE (1<<2)
/// energy weapons that don't use special cells / specific other types
#define CELL_TYPE_WEAPON (1<<3)

DECLARE_BITFIELD(cell_type, list(
	BITFIELD_NAMED("Small", CELL_TYPE_SMALL),
	BITFIELD_NAMED("Medium", CELL_TYPE_MEDIUM),
	BITFIELD_NAMED("Large", CELL_TYPE_LARGE),
	BITFIELD_NAMED("Weapon", CELL_TYPE_WEAPON),
))
ASSIGN_BITFIELD(cell_type, /obj/item/cell, cell_type)
ASSIGN_BITFIELD(cell_type, /datum/object_system/cell_slot, cell_type)
ASSIGN_BITFIELD(cell_type, /obj/machinery/recharger, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/machinery/cell_charger, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/machinery/power/apc, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/machinery/space_heater, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/item/flashlight, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/item/melee/transforming/energy, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/item/melee/baton, cell_accept)
ASSIGN_BITFIELD(cell_type, /obj/item/inducer, cell_accept)
ASSIGN_BITFIELD(cell_type, /mob/living/silicon/robot, cell_accept)

/// generate /small, /medium, /large, and /weapon cells for a power cell datum and typepath combo
/// * only works for standard cells with standard graphics.
#define POWER_CELL_GENERATE_TYPES(DATUM_TYPEPATH, CELL_TYPEPATH, PROTOTYPE_ID) \
/obj/item/cell##CELL_TYPEPATH/small { \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-small"; \
	name = "small power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A small power cell used in handheld electronics. " + ##DATUM_TYPEPATH::cell_desc; \
	icon = 'icons/items/power/cells/small.dmi'; \
	icon_state = "cell"; \
	base_icon_state = "cell"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_small * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_small * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_small; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	belt_storage_class = BELT_CLASS_FOR_SMALL_CELL; \
	belt_storage_size = BELT_SIZE_FOR_SMALL_CELL; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_small; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_small; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_small; \
	cell_type = CELL_TYPE_SMALL; \
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_ARMOR | SUIT_STORAGE_CLASS_HARDWEAR; \
	slot_flags = SLOT_POCKET; \
} \
/obj/item/cell##CELL_TYPEPATH/small/empty { \
	charge = 0; \
} \
/obj/item/cell##CELL_TYPEPATH/medium { \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-medium"; \
	name = "medium power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A decently sized cell used in many pieces of modern equipment. " + ##DATUM_TYPEPATH::cell_desc; \
	icon = 'icons/items/power/cells/medium.dmi'; \
	icon_state = "cell"; \
	base_icon_state = "cell"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_medium * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_medium * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_medium; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	belt_storage_class = BELT_CLASS_FOR_MEDIUM_CELL; \
	belt_storage_size = BELT_SIZE_FOR_MEDIUM_CELL; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_medium; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_medium; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_medium; \
	cell_type = CELL_TYPE_MEDIUM; \
	suit_storage_class = SUIT_STORAGE_CLASS_ARMOR | SUIT_STORAGE_CLASS_HARDWEAR; \
} \
/obj/item/cell##CELL_TYPEPATH/medium/empty { \
	charge = 0; \
} \
/obj/item/cell##CELL_TYPEPATH/large { \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-large"; \
	name = "large power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A bulky power cell used in industrial equipment and power supply systems. " + ##DATUM_TYPEPATH::cell_desc; \
	icon = 'icons/items/power/cells/large.dmi'; \
	icon_state = "cell"; \
	base_icon_state = "cell"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_large * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_large * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_large; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	belt_storage_class = BELT_CLASS_FOR_LARGE_CELL; \
	belt_storage_size = BELT_SIZE_FOR_LARGE_CELL; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_large; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_large; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_large; \
	cell_type = CELL_TYPE_LARGE; \
	suit_storage_class = SUIT_STORAGE_CLASS_HARDWEAR; \
} \
/obj/item/cell##CELL_TYPEPATH/large/empty { \
	charge = 0; \
} \
/obj/item/cell##CELL_TYPEPATH/weapon { \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-weapon"; \
	name = "weapon power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A power cell accepted by many kinds of handheld weaponry. " + ##DATUM_TYPEPATH::cell_desc; \
	icon = 'icons/items/power/cells/weapon.dmi'; \
	icon_state = "cell"; \
	base_icon_state = "cell"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_weapon * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_weapon * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_weapon; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	belt_storage_class = BELT_CLASS_FOR_WEAPON_CELL; \
	belt_storage_size = BELT_SIZE_FOR_WEAPON_CELL; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_weapon; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_weapon; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_weapon; \
	cell_type = CELL_TYPE_WEAPON; \
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_ARMOR; \
	slot_flags = SLOT_POCKET; \
} \
/obj/item/cell##CELL_TYPEPATH/weapon/empty { \
	charge = 0; \
}
