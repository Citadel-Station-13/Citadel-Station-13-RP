/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"
	material_parts = /datum/prototype/material/steel
	material_costs = SHEET_MATERIAL_AMOUNT * 0.2
	material_primary = MATERIAL_PART_DEFAULT

/obj/item/clothing/gloves/ring/material/Initialize(mapload, material)
	if(!isnull(material))
		material_parts = material
	return ..()

/obj/item/clothing/gloves/ring/material/update_material_single(datum/prototype/material/material)
	. = ..()
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/gloves/ring/material/wood
	material_parts = /datum/prototype/material/wood_plank

/obj/item/clothing/gloves/ring/material/plastic
	material_parts = /datum/prototype/material/plastic

/obj/item/clothing/gloves/ring/material/iron
	material_parts = /datum/prototype/material/iron

/obj/item/clothing/gloves/ring/material/steel
	material_parts = /datum/prototype/material/steel

/obj/item/clothing/gloves/ring/material/silver
	material_parts = /datum/prototype/material/silver

/obj/item/clothing/gloves/ring/material/gold
	material_parts = /datum/prototype/material/gold

/obj/item/clothing/gloves/ring/material/platinum
	material_parts = /datum/prototype/material/platinum

/obj/item/clothing/gloves/ring/material/phoron
	material_parts = /datum/prototype/material/phoron

/obj/item/clothing/gloves/ring/material/glass
	material_parts = /datum/prototype/material/glass

/obj/item/clothing/gloves/ring/material/uranium
	material_parts = /datum/prototype/material/uranium

/obj/item/clothing/gloves/ring/material/osmium
	material_parts = /datum/prototype/material/osmium

/obj/item/clothing/gloves/ring/material/mhydrogen
	material_parts = /datum/prototype/material/hydrogen/mhydrogen

