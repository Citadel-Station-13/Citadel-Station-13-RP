// for /datum/var/datum_flags
#define DF_USE_TAG		(1<<0)
#define DF_VAR_EDITED	(1<<1)
#define DF_ISPROCESSING (1<<2)

DEFINE_BITFIELD(datum_flags, list(
	BITFIELD(DF_USE_TAG),
	BITFIELD(DF_VAR_EDITED),
	BITFIELD(DF_ISPROCESSING),
))
