/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"

/obj/item/clothing/gloves/ring/material/Initialize(mapload, new_material)
	. = ..()
	if(!new_material)
		new_material = MAT_STEEL
	material = GET_MATERIAL_REF(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.color

/obj/item/clothing/gloves/ring/material/get_material()
	return material

/obj/item/clothing/gloves/ring/material/wood/Initialize(mapload, material_key)
	return ..(mapload, MAT_WOOD)

/obj/item/clothing/gloves/ring/material/plastic/Initialize(mapload, material_key)
	return ..(mapload, MAT_PLASTIC)

/obj/item/clothing/gloves/ring/material/iron/Initialize(mapload, material_key)
	return ..(mapload, MAT_IRON)

/obj/item/clothing/gloves/ring/material/steel/Initialize(mapload, material_key)
	return ..(mapload, MAT_STEEL)

/obj/item/clothing/gloves/ring/material/silver/Initialize(mapload, material_key)
	return ..(mapload, MAT_SILVER)

/obj/item/clothing/gloves/ring/material/gold/Initialize(mapload, material_key)
	return ..(mapload, MAT_GOLD)

/obj/item/clothing/gloves/ring/material/platinum/Initialize(mapload, material_key)
	return ..(mapload, MAT_PLATINUM)

/obj/item/clothing/gloves/ring/material/phoron/Initialize(mapload, material_key)
	return ..(mapload, MAT_PHORON)

/obj/item/clothing/gloves/ring/material/glass/Initialize(mapload, material_key)
	return ..(mapload, MAT_GLASS)

/obj/item/clothing/gloves/ring/material/uranium/Initialize(mapload, material_key)
	return ..(mapload, MAT_URANIUM)

/obj/item/clothing/gloves/ring/material/osmium/Initialize(mapload, material_key)
	return ..(mapload, MAT_OSMIUM)

/obj/item/clothing/gloves/ring/material/mhydrogen/Initialize(mapload, material_key)
	return ..(mapload, MAT_METALHYDROGEN)
