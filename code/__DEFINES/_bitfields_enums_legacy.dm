// TODO: deprecated
#define DEFINE_BITFIELD(v, f) /datum/bitfield_legacy/single/##v { \
	flags = ##f; \
	variable = #v; \
}

// TODO: deprecated
#define DEFINE_SHARED_BITFIELD(n, v, f) /datum/bitfield_legacy/multi/##n { \
	flags = ##f; \
	variables = ##v; \
}

// TODO: deprecated
#define DEFINE_BITFIELD_NAMED(KEY, CONSTRAINTS, BITFIELDS)

// TODO: deprecated
/// KEY: must be unique, may be arbitrary; not a string, as it's used in typepath generation
/// CONSTRAINTS: list(/type = list(varname, ...), ...)
/// ENUMS: list of ENUM().
#define DEFINE_ENUM(KEY, CONSTRAINTS, ENUMS)
