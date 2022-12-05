
// Mostly for debugging table connections
// This file is not #included in the .dme.

/obj/structure/table/debug
	New()
		material = get_material_by_name("debugium")
		..()
