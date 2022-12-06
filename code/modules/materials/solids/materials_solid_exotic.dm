/datum/material/solid/super_matter
	name = "supermatter"
	lore_text = "Hypercrystalline supermatter is a subset of non-baryonic 'exotic' matter. It is found mostly in the heart of large stars, and features heavily in all kinds of fringe physics-defying technology."
	uid = "solid_exotic_supermatter"
	color = "#FFFF00"
	radioactivity = 20
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)
	luminescence = 3
	// value = 3
	legacy_flags = MATERIAL_FUSION_FUEL
	// construction_difficulty = MAT_VALUE_HARD_DIY
	// default_solid_form = /obj/item/stack/material/segment
	stack_type = /obj/item/stack/material/supermatter
	// exoplanet_rarity = MAT_RARITY_EXOTIC
	is_fusion_fuel = 1

	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	shard_type = SHARD_SHARD

	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	reflectiveness = MAT_VALUE_SHINY
	hardness = MAT_VALUE_RIGID

	wall_icon = 'icons/turf/walls/stone.dmi'
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	door_icon_base = "stone"


/datum/material/solid/phoron
	name = "phoron"
	uid = "solid_exotic_phoron"
	color = "#FC2BC5"
	stack_type = /obj/item/stack/material/phoron
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_PHORON = 2)

	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	shard_type = SHARD_SHARD

	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	reflectiveness = MAT_VALUE_SHINY
	hardness = MAT_VALUE_RIGID

	wall_icon = 'icons/turf/walls/stone.dmi'
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	door_icon_base = "stone"


/datum/material/solid/metallic_hydrogen
	name = "metallic hydrogen"
	uid = "solid_exotic_metallichydrogen"
	lore_text = "When hydrogen is exposed to extremely high pressures and temperatures, such as at the core of gas giants like Jupiter, it can take on metallic properties and - more importantly - acts as a room temperature superconductor. Achieving solid metallic hydrogen at room temperature, though, has proven to be rather tricky."
	color = "#E6C5DE"
	stack_type = /obj/item/stack/material/mhydrogen
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	conductivity = 100
	is_fusion_fuel = 1

/*
// Commenting this out while fires are so spectacularly lethal, as I can't seem to get this balanced appropriately.
/datum/material/solid/phoron/combustion_effect(var/turf/T, var/temperature, var/effect_multiplier)
	if(isnull(ignition_point))
		return 0
	if(temperature < ignition_point)
		return 0
	var/totalPhoron = 0
	for(var/turf/simulated/floor/target_tile in range(2,T))
		var/phoronToDeduce = (temperature/30) * effect_multiplier
		totalPhoron += phoronToDeduce
		target_tile.assume_gas(/datum/gas/phoron, phoronToDeduce, 200+T0C)
		spawn (0)
			target_tile.hotspot_expose(temperature, 400)
	return round(totalPhoron/100)
*/
