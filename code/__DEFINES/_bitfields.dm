#define DEFINE_BITFIELD(v, f) /datum/bitfield/single/##v { \
	flags = ##f; \
	variable = #v; \
}

#define DEFINE_SHARED_BITFIELD(n, v, f) /datum/bitfield/multi/##n { \
	flags = ##f; \
	variables = ##v; \
}

#define BITFIELD(thing) #thing = thing
