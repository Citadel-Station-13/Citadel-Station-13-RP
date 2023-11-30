/obj/item/clothing/accessory/bracelet/material
	abstract_type = /obj/item/clothing/accessory/bracelet/material
	icon_state = "materialbracelet"
	materials_base = null
	material_parts = /datum/material/steel
	material_costs = 2000
	material_primary = MATERIAL_PART_DEFAULT

/obj/item/clothing/accessory/bracelet/material/Initialize(mapload, material)
	if(!isnull(material))
		material_parts = material
	return ..()

/obj/item/clothing/accessory/bracelet/material/update_material_single(datum/material/material)
	. = ..()
	name = "[material.display_name] bracelet"
	desc = "A bracelet made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/accessory/bracelet/material/wood
	material_parts = /datum/material/wood_plank

/obj/item/clothing/accessory/bracelet/material/plastic
	material_parts = /datum/material/plastic

/obj/item/clothing/accessory/bracelet/material/iron
	material_parts = /datum/material/iron

/obj/item/clothing/accessory/bracelet/material/steel
	material_parts = /datum/material/steel

/obj/item/clothing/accessory/bracelet/material/silver
	material_parts = /datum/material/silver

/obj/item/clothing/accessory/bracelet/material/gold
	material_parts = /datum/material/gold

/obj/item/clothing/accessory/bracelet/material/platinum
	material_parts = /datum/material/platinum

/obj/item/clothing/accessory/bracelet/material/phoron
	material_parts = /datum/material/phoron

/obj/item/clothing/accessory/bracelet/material/glass
	material_parts = /datum/material/glass
