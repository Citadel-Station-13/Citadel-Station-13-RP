//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* /obj/item/ammo_casing casing_flags
/// delete after fire (usually for caseless)
#define CASING_DELETE (1<<0)
/// ferromagnetic round
#define CASING_FERROMAGNETIC (1<<1)
/// we're modified; otherwise, we assume that our type alone is enough to encode our information.
/// you must change this if var-changing a casing, or it might get deleted when it enters a magazine!
#define CASING_MODIFIED (1<<2)

DEFINE_BITFIELD(casing_flags, list(
	BITFIELD(CASING_DELETE),
	BITFIELD(CASING_FERROMAGNETIC),
	BITFIELD(CASING_MODIFIED),
))
