/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	material_primary = MATERIAL_ID_STEEL
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"

/obj/item/clothing/gloves/ring/material/UpdateDescriptions()
	name = "[material_primary? "[material_primary.display_name] " : ""]ring"
	desc = "A ring[material_primary? " made from [material_primary.display_name]" : ""]."

/obj/item/clothing/gloves/ring/material/wood
	material_primary = MATERIAL_ID_WOOD

/obj/item/clothing/gloves/ring/material/plastic
	material_primary = MATERIAL_ID_PLASTIC

/obj/item/clothing/gloves/ring/material/iron
	material_primary = MATERIAL_ID_IRON

/obj/item/clothing/gloves/ring/material/steel
	material_primary = MATERIAL_ID_STEEL

/obj/item/clothing/gloves/ring/material/silver
	material_primary = MATERIAL_ID_SILVER

/obj/item/clothing/gloves/ring/material/gold
	material_primary = MATERIAL_ID_GOLD

/obj/item/clothing/gloves/ring/material/platinum
	material_primary = MATERIAL_ID_PLATINUM

/obj/item/clothing/gloves/ring/material/phoron
	material_primary = MATERIAL_ID_PHORON

/obj/item/clothing/gloves/ring/material/glass
	material_primary = MATERIAL_ID_GLASS

/obj/item/clothing/gloves/ring/material/uranium
	material_primary = MATERIAL_ID_URANIUM

/obj/item/clothing/gloves/ring/material/osmium
	material_primary = MATERIAL_ID_OSMIUM

/obj/item/clothing/gloves/ring/material/mhydrogen
	material_primary = MATERIAL_ID_MHYDROGEN
