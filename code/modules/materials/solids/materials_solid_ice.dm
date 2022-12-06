/datum/material/solid/ice
	color = "#a5f2f3"
	heating_products = list(
		/datum/material/liquid/water = 1
	)
	name = "water"
	use_name = "ice"
	codex_name = "water ice"
	// taste_description = "ice"
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "lump"
	// removed_by_welder = TRUE
	// value = 0.2
	// sparse_material_weight = 2
	ore_result_amount = 7
	// rich_material_weight = 37
	heating_point = T20C + 10 // Above room temperature, to avoid drinks melting.
	uid = "solid_ice"

/datum/material/solid/ice/Initialize()
	if(!liquid_name)
		liquid_name = "liquid [name]" // avoiding the 'molten ice' issue
	if(!gas_name)
		gas_name = name
	if(!solid_name)
		solid_name = "[name] ice"
	if(!use_name)
		use_name = solid_name
	if(!ore_name)
		ore_name = solid_name
	. = ..()




/datum/material/solid/snow
	name = "snow"
	stack_type = /obj/item/stack/material/snow
	legacy_flags = MATERIAL_BRITTLE
	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#FFFFFF"
	integrity = 1
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumples"
	sheet_singular_name = "pile"
	sheet_plural_name = "pile" //Just a bigger pile
	radiation_resistance = 1

/datum/material/solid/snow/brick //only slightly stronger than snow, used to make igloos mostly
	name = "snowbrick"
	stack_type = /obj/item/stack/material/snowbrick
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	icon_reinf_directionals = TRUE
	color = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
