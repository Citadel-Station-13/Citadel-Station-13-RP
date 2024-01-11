// todo: get rid of this and make it like DEFINE_ENUM
#define DEFINE_BITFIELD(v, f) /datum/bitfield/single/##v { \
	flags = ##f; \
	variable = #v; \
}

// todo: get rid of this and make it like DEFINE_ENUM
#define DEFINE_SHARED_BITFIELD(n, v, f) /datum/bitfield/multi/##n { \
	flags = ##f; \
	variables = ##v; \
}

// todo: get rid of this, rename BITFIELD_NAMED to this
#define BITFIELD(thing) #thing = thing
#define BITFIELD_NAMED(name, thing) name = thing
