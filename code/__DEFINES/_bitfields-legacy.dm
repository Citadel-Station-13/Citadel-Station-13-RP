// todo: get rid of this and make it like DEFINE_ENUM
#define DEFINE_BITFIELD(v, f) /datum/bitfield_legacy/single/##v { \
	flags = ##f; \
	variable = #v; \
}

// todo: get rid of this and make it like DEFINE_ENUM
#define DEFINE_SHARED_BITFIELD(n, v, f) /datum/bitfield_legacy/multi/##n { \
	flags = ##f; \
	variables = ##v; \
}

// todo: get rid of this, rename BITFIELD_NAMED to this
#define BITFIELD(thing) #thing = thing
#define BITFIELD_NAMED(name, thing) name = thing

// todo: impl
/// KEY: must be unique, may be arbitrary; not a string, as it's used in typepath generation
/// CONSTRAINTS: list(/type = list(varname, ...), ...)
/// BITFIELDS: list of BITFIELD_NEW().
#define DEFINE_BITFIELD_NEW(KEY, CONSTRAINTS, BITFIELDS)
