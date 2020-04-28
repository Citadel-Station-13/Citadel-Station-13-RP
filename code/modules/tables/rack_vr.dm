/obj/structure/table/rack/steel
	color = "#666666"

/obj/structure/table/rack/steel/New()
	material = SSmaterials.material_by_id(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/rack/shelf
	name = "shelving"
	desc = "Some nice metal shelves."
	icon = 'icons/obj/objects_vr.dmi'
	icon_state = "shelf"

/obj/structure/table/rack/shelf/steel
	color = "#666666"

/obj/structure/table/rack/shelf/steel/New()
	material = SSmaterials.material_by_id(DEFAULT_WALL_MATERIAL)
	..()
