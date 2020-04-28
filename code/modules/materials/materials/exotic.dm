// Particle Smasher and other exotic materials.

/datum/material/verdantium
	id = MAT_VERDANTIUM
	stack_type = /obj/item/stack/material/verdantium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	icon_colour = "#4FE95A"
	integrity = 80
	protectiveness = 15
	weight = 15
	hardness = 30
	shard_type = SHARD_SHARD
	negation = 15
	conductivity = 60
	reflectivity = 0.3
	radiation_resistance = 5
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

//exotic wonder material
/datum/material/morphium
	id = MAT_MORPHIUM
	stack_type = /obj/item/stack/material/morphium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#37115A"
	icon_reinf = "reinf_metal"
	protectiveness = 60
	integrity = 900
	conductive = 0
	conductivity = 1.5
	hardness = 80
	shard_type = SHARD_SHARD
	weight = 30
	negation = 25
	explosion_resistance = 85
	reflectivity = 0.2
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 8, TECH_PHORON = 6, TECH_BLUESPACE = 6, TECH_ARCANE = 3)

/datum/material/morphium/hull
	id = MAT_MORPHIUMHULL
	stack_type = /obj/item/stack/material/morphium/hull
	icon_base = "hull"
	icon_reinf = "reinf_mesh"

/datum/material/valhollide
	id = MAT_VALHOLLIDE
	stack_type = /obj/item/stack/material/valhollide
	icon_base = "stone"
	door_icon_base = "stone"
	icon_reinf = "reinf_mesh"
	icon_colour = "##FFF3B2"
	protectiveness = 30
	integrity = 240
	weight = 30
	hardness = 45
	negation = 2
	conductive = 0
	conductivity = 5
	reflectivity = 0.5
	radiation_resistance = 20
	spatial_instability = 30
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_PHORON = 5, TECH_BLUESPACE = 5)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"

//R-UST port
/datum/material/supermatter
	id = "supermatter"
	icon_colour = "#FFFF00"
	stack_type = /obj/item/stack/material/supermatter
	shard_type = SHARD_SHARD
	radioactivity = 20
	stack_type = null
	luminescence = 3
	ignition_point = PHORON_MINIMUM_BURN_TEMPERATURE
	icon_base = "stone"
	shard_type = SHARD_SHARD
	hardness = 30
	door_icon_base = "stone"
	sheet_singular_name = "crystal"
	sheet_plural_name = "crystals"
	is_fusion_fuel = 1
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 5, TECH_BLUESPACE = 4)
