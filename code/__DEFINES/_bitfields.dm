#define DEFINE_BITFIELD(v, f) /datum/bitfield/##v { \
	flags = ##f; \
	variable = #v; \
}

#define BITFIELD(thing) #thing = thing
