//MARK ALL FLAG CHANGES IN _globals/bitfields.dm!
//All flags should go in here if possible.
#define ALL (~0) //For convenience.
#define NONE 0

//for convenience
#define ENABLE_BITFIELD(variable, flag)				(variable |= (flag))
#define DISABLE_BITFIELD(variable, flag)			(variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag)				(variable & (flag))

//check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags)	((flagvar & (flags)) == flags)

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// /datum datum_flags
#define DF_VAR_EDITED			(1<<0)
#define DF_ISPROCESSING			(1<<1)
#define DF_USE_TAG				(1<<2)

// /datum/material material_flags
#define MATERIAL_UNMELTABLE			(1<<0)
#define MATERIAL_BRITTLE			(1<<1)
#define MATERIAL_PADDING			(1<<2)

// /atom flags var

// /obj material_usage_flags var
#define USE_PRIMARY_MATERIAL_COLOR		(1<<0)			//change color to primary material on updatei con
#define USE_PRIMARY_MATERIAL_OPACITY	(1<<1)			//above but for opacity
#define USE_PRIMARY_MATERIAL_PREFIX		(1<<2)			//Use primary material get_prefix() before name. See UpdateDescriptions() on /atom.
