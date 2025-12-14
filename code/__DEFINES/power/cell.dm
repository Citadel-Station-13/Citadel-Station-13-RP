//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /obj/item/cell/var/cell_type *//

/// handheld devices
#define CELL_TYPE_SMALL (1<<1)
/// medium size devices like inducers, bulky handheld equipment, etc
#define CELL_TYPE_MEDIUM (1<<2)
/// mecha, apcs, large drills, etc
#define CELL_TYPE_LARGE (1<<3)
/// energy weapons that don't use special cells / specific other types
#define CELL_TYPE_WEAPON (1<<4)

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

/// generate /small, /medium, /large, and /weapon cells for a power cell datum
#define POWER_CELL_GENERATE_TYPES(DATUM_TYPEPATH, CELL_TYPEPATH, PROTOTYPE_ID) \
/obj/item/cell/small##CELL_TYPEPATH { \
	name = "small power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A small power cell used in handheld electronics. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-small"; \
	max_charge = /obj/item/cell/small::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_small * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	cell_datum = ##DATUM_TYPEPATH; \
} \
/obj/item/cell/medium##CELL_TYPEPATH { \
	name = "medium power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A decently sized cell used in many pieces of modern equipment. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-medium"; \
	max_charge = /obj/item/cell/medium::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_medium * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	cell_datum = ##DATUM_TYPEPATH; \
} \
/obj/item/cell/large##CELL_TYPEPATH { \
	name = "large power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A bulky power cell used in industrial equipment and power supply systems. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-large"; \
	max_charge = /obj/item/cell/large::max_charge * ##DATUM_TYPEPATH::typegen_capacity_multiplier_large * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	cell_datum = ##DATUM_TYPEPATH; \
} \
/obj/item/cell/weapon##CELL_TYPEPATH { \
	name = "weapon power cell (" + ##DATUM_TYPEPATH::cell_name + ")"; \
	desc = "A power cell accepted by many kinds of handheld weaponry. " + ##DATUM_TYPEPATH::cell_desc; \
	prototype_id = "cell-" + ##PROTOTYPE_ID + "-weapon"; \
	max_charge = /obj/item/cell/weapon::max_charge + ##DATUM_TYPEPATH::typegen_capacity_multiplier_weapon * ##DATUM_TYPEPATH::typegen_capacity_multiplier; \
	stripe_color = ##DATUM_TYPEPATH::typegen_visual_stripe_color; \
	indicator_color = ##DATUM_TYPEPATH::typegen_visual_indicator_color; \
	typegen_active = TRUE; \
	cell_datum = ##DATUM_TYPEPATH; \
}
