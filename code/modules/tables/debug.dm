
// Mostly for debugging table connections
// This file is not #included in the .dme.

/obj/structure/table/debug
	New()
		material = GET_MATERIAL_REF(/datum/material/debug)
		..()
