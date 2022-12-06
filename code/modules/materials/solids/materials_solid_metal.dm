/datum/material/solid/metal
	abstract_type = /datum/material/solid/metal

	name = null
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

	// default_solid_form = /obj/item/stack/material/ingot
	reflectiveness = MAT_VALUE_SHINY
	// removed_by_welder = TRUE
	// wall_name = "bulkhead"
	weight = MAT_VALUE_HEAVY
	hardness = MAT_VALUE_RIGID
	// wall_support_value = MAT_VALUE_HEAVY
	// wall_flags = PAINT_PAINTABLE

	wall_icon = 'icons/turf/walls/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	wall_blend_icons = list(
		'icons/turf/walls/wood.dmi' = TRUE,
		'icons/turf/walls/stone.dmi' = TRUE,
	)
	door_icon_base = "metal"


/datum/material/solid/metal/steel
	name = "steel"
	uid = "solid_metal_steel"
	stack_type = /obj/item/stack/material/steel
	integrity = 150
	conductivity = 11 // Assuming this is carbon steel, it would actually be slightly less conductive than iron, but lets ignore that.
	protectiveness = 10 // 33%

	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	color = "#666666"


/datum/material/solid/metal/steel/hull
	name = "steel hull"
	stack_type = /obj/item/stack/material/steel/hull
	integrity = 250

	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	texture_layer_icon_state = "mesh"
	color = "#666677"

/datum/material/solid/metal/steel/hull/place_sheet(turf/target) //Deconstructed into normal steel sheets.
	new /obj/item/stack/material/steel(target)


/datum/material/solid/metal/steel/holographic
	name = "holosteel"
	uid = "solid_metal_steel_holographic"
	display_name = "steel"
	stack_type = null
	shard_type = SHARD_NONE


/datum/material/solid/metal/plasteel
	name = "plasteel"
	uid = "solid_metal_plasteel"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	hardness = 80
	weight = 23
	protectiveness = 20 // 50%
	conductivity = 13 // For the purposes of balance.
	stack_origin_tech = list(TECH_MATERIAL = 2)
	composite_material = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT, MAT_PLATINUM = SHEET_MATERIAL_AMOUNT) //todo
	radiation_resistance = 14

	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	table_icon = 'icons/obj/structures/tables/metal.dmi'
	// color = "#777777" using steel's color cause of our current walls. @Zandario
	color = "#666666"


/datum/material/solid/metal/plasteel/hull
	name = "plasteel hull"
	uid = "solid_metal_plasteelhull"
	stack_type = /obj/item/stack/material/plasteel/hull
	integrity = 600

	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	color = "#777788"

/datum/material/solid/metal/plasteel/hull/place_sheet(turf/target) //Deconstructed into normal plasteel sheets.
	new /obj/item/stack/material/plasteel(target)


/datum/material/solid/metal/titanium
	name = "titanium"
	uid = "solid_metal_titanium"
	stack_type = /obj/item/stack/material/titanium
	conductivity = 2.38
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	color = "#D1E6E3"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'


/datum/material/solid/metal/titanium/hull
	name = "titanium hull"
	uid = "solid_metal_titaniumhull"
	stack_type = null
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'


/// Very rare alloy that is reflective, should be used sparingly.
/datum/material/solid/metal/durasteel
	name = "durasteel"
	uid = "solid_metal_durasteel"
	stack_type = /obj/item/stack/material/durasteel
	integrity = 600
	melting_point = 7000
	wall_icon = 'icons/turf/walls/metal.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	color = "#6EA7BE"
	hardness = 100
	weight = 28
	protectiveness = 60 // 75%
	reflectiveness = MAT_VALUE_VERY_SHINY // Not a perfect mirror, but close.
	stack_origin_tech = list(TECH_MATERIAL = 8)
	composite_material = list(MAT_PLASTEEL = SHEET_MATERIAL_AMOUNT, MAT_DIAMOND = SHEET_MATERIAL_AMOUNT) //shrug


/datum/material/solid/metal/durasteel/hull //The 'Hardball' of starship hulls.
	name = "durasteel hull"
	uid = "solid_metal_durasteelhull"
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	color = "#45829a"
	reflectiveness = MAT_VALUE_MIRRORED

/datum/material/solid/metal/durasteel/hull/place_sheet(turf/target) //Deconstructed into normal durasteel sheets.
	new /obj/item/stack/material/durasteel(target)

/datum/material/solid/metal/iron
	name = "iron"
	uid = "solid_metal_iron"
	stack_type = /obj/item/stack/material/iron
	color = "#5C5454"
	weight = 22
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/solid/metal/lead
	name = "lead"
	uid = "solid_metal_lead"
	stack_type = /obj/item/stack/material/lead
	color = "#273956"
	weight = 23 // Lead is a bit more dense than silver IRL, and silver has 22 ingame.
	conductivity = 10
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	radiation_resistance = 25 // Lead is Special and so gets to block more radiation than it normally would with just weight, totalling in 48 protection.

/datum/material/solid/metal/gold
	name = "gold"
	uid = "solid_metal_gold"
	stack_type = /obj/item/stack/material/gold
	color = "#EDD12F"
	weight = 24
	hardness = 40
	conductivity = 41
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/solid/metal/gold/bronze //placeholder for ashtrays
	name = "bronze"
	lore_text = "An alloy of copper and tin. Once used in weapons and laboring tools."
	uid = "solid_metal_bronze"
	hardness = MAT_VALUE_RIGID + 10
	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	color = "#CCBC63"
	// use_reinf_state = null
	// value = 1.2
	// default_solid_form = /obj/item/stack/material/sheet

/datum/material/solid/metal/brass
	name = "brass"
	color = "#CAC955"
	integrity = 150
	stack_type = /obj/item/stack/material/brass

/datum/material/solid/metal/copper
	name = "copper"
	color = "#b45c13"
	weight = 15
	hardness = 30
	conductivity = 35
	stack_type = /obj/item/stack/material/copper

/datum/material/solid/metal/silver
	name = "silver"
	lore_text = "A soft, white, lustrous transition metal. Has many and varied industrial uses in electronics, solar panels and mirrors."
	uid = "solid_metal_silver"
	stack_type = /obj/item/stack/material/silver
	color = "#D1E6E3"
	weight = 22
	hardness = 50
	conductivity = 63
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"

/datum/material/solid/metal/uranium
	name = "uranium"
	lore_text = "A silvery-white metallic chemical element in the actinide series, weakly radioactive. Commonly used as fuel in fission reactors."
	uid = "solid_metal_uranium"

	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_stone.dmi'
	table_icon = 'icons/obj/structures/tables/stone.dmi'
	icon_reinf_directionals = TRUE
	color = "#007A00"
	door_icon_base = "stone"

	legacy_flags = MATERIAL_FISSIBLE
	radioactivity = 12
	weight = MAT_VALUE_VERY_HEAVY
	stack_origin_tech = list(TECH_MATERIAL = 5)
	reflectiveness = MAT_VALUE_MATTE
	// value = 1.5
	// default_solid_form = /obj/item/stack/material/puck
	stack_type = /obj/item/stack/material/uranium
	// exoplanet_rarity = MAT_RARITY_UNCOMMON

/datum/material/solid/metal/uranium/generate_recipes()
	..()
	recipes += new/datum/stack_recipe_list("statues", list(
		new/datum/stack_recipe("nuke statue",     /obj/structure/statue/uranium/nuke, 20, time = 5, one_per_turf = 1, on_floor = 1),
		new/datum/stack_recipe("engineer statue", /obj/structure/statue/uranium/eng,  20, time = 5, one_per_turf = 1, on_floor = 1),
	))
	recipes += new/datum/stack_recipe("uranium floor tile", /obj/item/stack/tile/uranium, 1, 4, 20)

/datum/material/solid/metal/platinum
	name = "platinum"
	uid = "solid_metal_platinum"
	color = "#9999FF"
	stack_type = /obj/item/stack/material/platinum
	weight = 27
	conductivity = 9.43
	stack_origin_tech = list(TECH_MATERIAL = 2)

/datum/material/solid/metal/osmium
	name = "osmium"
	uid = "solid_metal_osmium"
	stack_type = /obj/item/stack/material/osmium
	color = "#9999FF"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	conductivity = 100

//Vaudium products
/datum/material/solid/metal/bananium
	name = "bananium"
	uid = "solid_metal_bananium"
	color = "#d6c100"
	stack_type = /obj/item/stack/material/bananium
	integrity = 150
	conductivity = 0 // Weird rubber metal.
	protectiveness = 10 // 33%



//! Particle Smasher and other exotic materials.

/datum/material/solid/metal/verdantium
	name = "verdantium"
	uid = "solid_metal_verdantium"
	stack_type = /obj/item/stack/material/verdantium
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	color = "#4FE95A"
	integrity = 80
	protectiveness = 15
	weight = 15
	hardness = 30
	shard_type = SHARD_SHARD
	negation = 15
	conductivity = 60
	reflectiveness = MAT_VALUE_MATTE
	radiation_resistance = 5
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_BIO = 4)
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

//exotic wonder material
/datum/material/solid/metal/morphium
	name = "morphium"
	uid = "solid_metal_morphium"
	stack_type = /obj/item/stack/material/morphium
	wall_icon = 'icons/turf/walls/metal.dmi'
	door_icon_base = "metal"
	color = "#37115A"
	wall_reinf_icon = 'icons/turf/walls/reinf_metal.dmi'
	protectiveness = 60
	integrity = 900
	conductive = 0
	conductivity = 1.5
	hardness = 80
	shard_type = SHARD_SHARD
	weight = 30
	negation = 25
	reflectiveness = MAT_VALUE_MATTE
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_MAGNET = 8, TECH_PHORON = 6, TECH_BLUESPACE = 6, TECH_ARCANE = 3)

/datum/material/solid/metal/morphium/hull
	name = "morphium hull"
	uid = "solid_metal_morphiumhull"
	stack_type = /obj/item/stack/material/morphium/hull
	wall_icon = 'icons/turf/walls/hull.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'

/datum/material/solid/metal/valhollide
	name = "valhollide"
	uid = "solid_metal_valhollide"
	stack_type = /obj/item/stack/material/valhollide
	wall_icon = 'icons/turf/walls/stone.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	door_icon_base = "stone"
	color = "##FFF3B2"
	protectiveness = 30
	integrity = 240
	weight = 30
	hardness = 45
	negation = 2
	conductive = 0
	conductivity = 5
	reflectiveness = MAT_VALUE_SHINY
	radiation_resistance = 20
	spatial_instability = 30
	stack_origin_tech = list(TECH_MATERIAL = 7, TECH_PHORON = 5, TECH_BLUESPACE = 5)
	sheet_singular_name = "gem"
	sheet_plural_name = "gems"

/datum/material/solid/metal/aluminium
	name = "aluminium"
	uid = "solid_aluminium"
	lore_text = "A low-density ductile metal with a silvery-white sheen."
	integrity = 125
	weight = MAT_VALUE_LIGHT
	wall_icon = 'icons/turf/walls/solid.dmi'
	wall_reinf_icon = 'icons/turf/walls/reinf.dmi'
	// wall_flags = PAINT_PAINTABLE|PAINT_STRIPABLE|WALL_HAS_EDGES
	// use_reinf_state = null
	color = "#CCCDCC"
	hitsound = 'sound/weapons/smash.ogg'
	// taste_description = "metal"
	default_solid_form = /obj/item/stack/material/shiny
