/obj/structure/table/rack/steel
	color = "#666666"

/obj/structure/table/rack/steel/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()

/obj/structure/table/rack/shelf
	name = "shelving"
	desc = "Some nice metal shelves."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shelf"

/obj/structure/table/rack/shelf/steel
	color = "#666666"

/obj/structure/table/rack/shelf/steel/Initialize(mapload)
	material = GET_MATERIAL_REF(/datum/material/solid/metal/steel)
	return ..()
