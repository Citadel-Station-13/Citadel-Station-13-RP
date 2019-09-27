/datum/material/snow
	id = MATERIAL_ID_SNOW
	display_name = "loose snow"
	stack_type = /obj/item/stack/material/snow
	material_flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#FFFFFF"
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

/datum/material/snowbrick //only slightly stronger than snow, used to make igloos mostly
	id = MATERIAL_ID_SNOWBRICK
	display_name = "snow"
	material_flags = MATERIAL_BRITTLE
	stack_type = /obj/item/stack/material/snowbrick
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#D8FDFF"
	integrity = 50
	weight = 2
	hardness = 2
	protectiveness = 0 // 0%
	stack_origin_tech = list(TECH_MATERIAL = 1)
	melting_point = T0C+1
	destruction_desc = "crumbles"
	sheet_singular_name = "brick"
	sheet_plural_name = "bricks"
	radiation_resistance = 1

/datum/material/algae
	id = MATERIAL_ID_ALGAE
	display_name = "algae"
	stack_type = /obj/item/stack/material/algae
	icon_colour = "#557722"
	shard_type = SHARD_STONE_PIECE
	weight = 10
	hardness = 10
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/datum/material/carbon
	id = MATERIAL_ID_CARBON
	display_name = "carbon"
	stack_type = /obj/item/stack/material/carbon
	icon_colour = "#303030"
	shard_type = SHARD_SPLINTER
	weight = 5
	hardness = 20
	icon_base = "stone"
	icon_reinf = "reinf_stone"
	door_icon_base = "stone"
	sheet_singular_name = "sheet"
	sheet_plural_name = "sheets"

/datum/material/cardboard
	id = MATERIAL_ID_CARDBOARD
	stack_type = /obj/item/stack/material/cardboard
	material_flags = MATERIAL_BRITTLE
	integrity = 10
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#AAAAAA"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%
	ignition_point = T0C+232 //"the temperature at which book-paper catches fire, and burns." close enough
	melting_point = T0C+232 //temperature at which cardboard walls would be destroyed
	stack_origin_tech = list(TECH_MATERIAL = 1)
	door_icon_base = "wood"
	destruction_desc = "crumples"
	radiation_resistance = 1

//TODO PLACEHOLDERS:
/datum/material/leather
	id = MATERIAL_ID_LEATHER
	icon_colour = "#5C4831"
	stack_origin_tech = list(TECH_MATERIAL = 2)
	material_flags = MATERIAL_PADDING
	ignition_point = T0C+300
	melting_point = T0C+300
	protectiveness = 3 // 13%

/datum/material/carpet
	id = MATERIAL_ID_CARPET
	display_name = "comfy"
	use_name = "red upholstery"
	icon_colour = "#DA020A"
	material_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	sheet_singular_name = "tile"
	sheet_plural_name = "tiles"
	protectiveness = 1 // 4%

/datum/material/cotton
	id = MATERIAL_ID_COTTON
	display_name ="cotton"
	icon_colour = "#FFFFFF"
	material_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	protectiveness = 1 // 4%

/datum/material/toy_foam
	id = MATERIAL_ID_FOAM
	display_name = "foam"
	use_name = "foam"
	material_flags = MATERIAL_PADDING
	ignition_point = T0C+232
	melting_point = T0C+300
	icon_colour = "#ff9900"
	hardness = 1
	weight = 1
	protectiveness = 0 // 0%

/datum/material/diona
	display_name = "biomass"
	id = MATERIAL_ID_BIOMASS
	icon_colour = null
	stack_type = null
	integrity = 600
	icon_base = "diona"
	icon_reinf = "noreinf"

/datum/material/diona/place_dismantled_product()
	return

/datum/material/diona/place_dismantled_girder(var/turf/target)
	spawn_diona_nymph(target)

/datum/material/plastic
	id = MATERIAL_ID_PLASTIC
	display_name = "plastic"
	stack_type = /obj/item/stack/material/plastic
	material_flags = MATERIAL_BRITTLE
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#CCCCCC"
	hardness = 10
	weight = 12
	protectiveness = 5 // 20%
	conductivity = 2 // For the sake of material armor diversity, we're gonna pretend this plastic is a good insulator.
	melting_point = T0C+371 //assuming heat resistant plastic
	stack_origin_tech = list(TECH_MATERIAL = 3)

/datum/material/plastic/holographic
	id = MATERIAL_ID_PLASTIC_HOLO
	display_name = "plastic"
	stack_type = null
	shard_type = SHARD_NONE

/datum/material/resin
	id = MATERIAL_ID_XENO_RESIN
	display_name = "resin"
	icon_colour = "#35343a"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"

/datum/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

