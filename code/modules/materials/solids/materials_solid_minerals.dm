
/datum/material/solid/hematite
	name = "hematite"
	uid = "solid_hematite"
	color = "#aa6666"
	heating_products = list(
		/datum/material/solid/metal/iron = 0.8,
		/datum/material/solid/slag = 0.2
	)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"
	// value = 0.8
	// sparse_material_weight = 35
	// rich_material_weight = 20
	// ore_type_value = ORE_SURFACE
	ore_data_value = 1

/datum/material/solid/sand
	name = "sand"
	uid = "solid_sand"
	color = "#e2dbb5"
	heating_products = list(/datum/material/solid/glass = 1)
	heating_point = GENERIC_SMELTING_HEAT_POINT
	heating_sound = null
	heating_message = null
	ore_compresses_to = /datum/material/solid/stone/sandstone
	ore_name = "sand"
	ore_icon_overlay = "dust"
	ore_type_value = ORE_SURFACE
	ore_data_value = 1
	// value = 0.8
	// dirtiness = 15
	dissolves_into = list(
		/datum/material/solid/silicon = 1
	)
	default_solid_form = /obj/item/stack/material/lump
