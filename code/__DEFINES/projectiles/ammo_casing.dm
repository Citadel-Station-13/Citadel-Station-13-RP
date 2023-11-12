//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* /obj/item/ammo_casing casing_flags
/// delete after fire (usually for caseless)
#define CASING_DELETE (1<<0)
/// ferromagnetic round
#define CASING_FERROMAGNETIC (1<<1)

DEFINE_BITFIELD(casing_flags, list(
	BITFIELD(CASING_DELETE),
	BITFIELD(CASING_FERROMAGNETIC),
))
