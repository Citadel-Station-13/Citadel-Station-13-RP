//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* /obj/item/ammo_casing casing_flags *//

/// delete after fire (usually for caseless)
//  todo: audit where we actually check this; this shouldn't be handled by the gun.
#define CASING_DELETE (1<<0)
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
	BITFIELD_NEW("Non Chemical", CASING_NONCHEMICAL),
))

//* Firing Method (Priming) Flags *//

/// chemical propellant ignition
#define CASING_PRIMER_CHEMICAL (1<<0)
/// magnetic acceleration
#define CASING_PRIMER_MAGNETIC (1<<1)
/// activate microbattery cell
#define CASING_PRIMER_MICROBATTERY (1<<2)

DEFINE_BITFIELD_NEW(ammo_casing_primer, list(
	/obj/item/ammo_casing = list(
		"casing_primer",
	),
), list(
	BITFIELD_NEW("Chemical", CASING_PRIMER_CHEMICAL),
	BITFIELD_NEW("Magnetic", CASING_PRIMER_MAGNETIC),
	BITFIELD_NEW("Microbattery", CASING_PRIMER_MICROBATTERY),
))
