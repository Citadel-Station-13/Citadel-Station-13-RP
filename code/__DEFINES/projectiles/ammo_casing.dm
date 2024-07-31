//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* /obj/item/ammo_casing casing_flags
/// delete after fire (usually for caseless)
#define CASING_DELETE (1<<0)
/// ferromagnetic round
#define CASING_FERROMAGNETIC (1<<1)
/// we're modified; otherwise, we assume that our type alone is enough to encode our information.
/// you must change this if var-changing a casing, or it might get deleted when it enters a magazine!
#define CASING_MODIFIED (1<<2)

DEFINE_BITFIELD_NEW(ammo_casing_flags, list(
	/obj/item/ammo_casing = list(
		"casing_flags",
	),
), list(
	BITFIELD_NEW("Delete after firing", CASING_DELETE),
	BITFIELD_NEW("Ferromagnetic", CASING_FERROMAGNETIC),
	BITFIELD_NEW("Is Modified", CASING_MODIFIED),
))
