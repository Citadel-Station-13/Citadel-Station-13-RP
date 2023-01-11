// /obj/item/ammo_casing casing_flags
/// delete after fire (usually for caseless)
#define CASING_DELETE (1<<0)

DEFINE_BITFIELD(casing_flags, list(
	BITFIELD(CASING_DELETE),
))
