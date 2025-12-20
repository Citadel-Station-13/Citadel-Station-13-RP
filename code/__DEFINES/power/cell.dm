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

DEFINE_BITFIELD_NEW(cell_type, list(
	/obj/item/cell = list(
		"cell_type",
	),
	/datum/object_system/cell_slot = list(
		"cell_type",
	),
), list(
	BITFIELD_NEW("Small", CELL_TYPE_SMALL),
	BITFIELD_NEW("Medium", CELL_TYPE_MEDIUM),
	BITFIELD_NEW("Large", CELL_TYPE_LARGE),
	BITFIELD_NEW("Weapon", CELL_TYPE_WEAPON),
))

#warn don't forget sprite now that it isn't all inherited

/// generate /small, /medium, /large, and /weapon cells for a power cell datum and typepath combo
/// * only works for standard cells with standard graphics.
#define POWER_CELL_GENERATE_TYPES(DATUM_TYPEPATH, CELL_TYPEPATH, PROTOTYPE_ID) \
/obj/item/cell##CELL_TYPEPATH/small { \
	name = "small power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A small power cell used in handheld electronics. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-small"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_small * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_small * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_small; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_small; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_small; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_small; \
	cell_type = CELL_TYPE_SMALL; \
} \
/obj/item/cell##CELL_TYPEPATH/small/empty { \
	charge = 0; \
} \
/obj/item/cell##CELL_TYPEPATH/medium { \
	name = "medium power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A decently sized cell used in many pieces of modern equipment. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-medium"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_medium * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_medium * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_medium; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_medium; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_medium; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_medium; \
	cell_type = CELL_TYPE_MEDIUM; \
} \
/obj/item/cell##CELL_TYPEPATH/medium/empty { \
	charge = 0; \
} \
/obj/item/cell##CELL_TYPEPATH/large { \
	name = "large power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A bulky power cell used in industrial equipment and power supply systems. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-large"; \
	charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_large * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_large * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_large; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_large; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_large; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_large; \
	cell_type = CELL_TYPE_LARGE; \
} \
/obj/item/cell##CELL_TYPEPATH/large/empty { \
	charge = 0; \
} \
/obj/item/cell##CELL_TYPEPATH/weapon { \
	name = "weapon power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A power cell accepted by many kinds of handheld weaponry. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-weapon"; \
	charge = /obj/item/cell::max_charge + ##DATUM_TYPEPATH::typegen_capacity_multiplier_weapon * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	max_charge = /obj/item/cell::max_charge + ##DATUM_TYPEPATH::typegen_capacity_multiplier_weapon * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	typegen_material_multiplier = ##DATUM_TYPEPATH::typegen_material_multiply * ##DATUM_TYPEPATH::typegen_material_multiply_weapon; \
	cell_datum = ##DATUM_TYPEPATH; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	worth_intrinsic = ##DATUM_TYPEPATH::typegen_worth_base_weapon; \
	w_class = ##DATUM_TYPEPATH::typegen_w_class_weapon; \
	weight_volume = ##DATUM_TYPEPATH::typegen_w_volume_weapon; \
	cell_type = CELL_TYPE_WEAPON; \
} \
/obj/item/cell##CELL_TYPEPATH/weapon/empty { \
	charge = 0; \
}
