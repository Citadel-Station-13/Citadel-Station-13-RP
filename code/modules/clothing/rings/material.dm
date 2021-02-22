/////////////////////////////////////////
//Material Rings
/obj/item/clothing/gloves/ring/material
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "material"

/obj/item/clothing/gloves/ring/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/gloves/ring/material/get_material()
	return material

/obj/item/clothing/gloves/ring/material/wood/Initialize(mapload, material_key)
	..(mapload, "wood")

/obj/item/clothing/gloves/ring/material/plastic/Initialize(mapload, material_key)
	..(mapload, "plastic")

/obj/item/clothing/gloves/ring/material/iron/Initialize(mapload, material_key)
	..(mapload, "iron")

/obj/item/clothing/gloves/ring/material/steel/Initialize(mapload, material_key)
	..(mapload, "steel")

/obj/item/clothing/gloves/ring/material/silver/Initialize(mapload, material_key)
	..(mapload, "silver")

/obj/item/clothing/gloves/ring/material/gold/Initialize(mapload, material_key)
	..(mapload, "gold")

/obj/item/clothing/gloves/ring/material/platinum/Initialize(mapload, material_key)
	..(mapload, "platinum")

/obj/item/clothing/gloves/ring/material/phoron/Initialize(mapload, material_key)
	..(mapload, "phoron")

/obj/item/clothing/gloves/ring/material/glass/Initialize(mapload, material_key)
	..(mapload, "glass")

/obj/item/clothing/gloves/ring/material/uranium/Initialize(mapload, material_key)
	..(mapload, "uranium")

/obj/item/clothing/gloves/ring/material/osmium/Initialize(mapload, material_key)
	..(mapload, "osmium")

/obj/item/clothing/gloves/ring/material/mhydrogen/Initialize(mapload, material_key)
	..(mapload, "mhydrogen")
