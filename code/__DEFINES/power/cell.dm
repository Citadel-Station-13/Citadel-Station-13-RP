//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

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

/// generate /small, /medium, /large, and /weapon cells for a type
#define POWER_CELL_GENERATE_TYPES(TYPEPATH) \
##TYPEPATH/small { \
	name = "small power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A small power cell used in handheld electronics. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	max_charge = ##TYPEPATH::typegen_capacity_small * ##TYPEPATH::typegen_capacity_multiplier; \
	typegen_material_modify = ##TYPEPATH::typegen_material_small_multiply; \
} \
##TYPEPATH/medium { \
	name = "medium power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A decently sized cell used in many pieces of modern equipment. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	max_charge = ##TYPEPATH::typegen_capacity_medium * ##TYPEPATH::typegen_capacity_multiplier; \
	typegen_material_modify = ##TYPEPATH::typegen_material_medium_multiply; \
} \
##TYPEPATH/large { \
	name = "large power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A bulky power cell used in industrial equipment and power supply systems. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	max_charge = ##TYPEPATH::typegen_capacity_large * ##TYPEPATH::typegen_capacity_multiplier; \
	typegen_material_modify = ##TYPEPATH::typegen_material_large_multiply; \
} \
##TYPEPATH/weapon { \
	name = "weapon power cell (" + ##TYPEPATH::cell_name + ")"; \
	desc = "A power cell accepted by many kinds of handheld weaponry. " + ##TYPEPATH::cell_desc; \
	rendering_system = TRUE; \
	indicator_count = 4; \
	max_charge = ##TYPEPATH::typegen_capacity_weapon * ##TYPEPATH::typegen_capacity_multiplier; \
	typegen_material_modify = ##TYPEPATH::typegen_material_weapon_multiply; \
}
