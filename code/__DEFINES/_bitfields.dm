//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * `ID` must be unique and in `snake_case`
 * * `BIT_TO_NAME` should be an list() with `BITFIELD_NEW()`'s inside it.
 */
#define DECLARE_BITFIELD(ID, BIT_TO_NAME); \
/datum/bitfield/##ID/get_bit_constants() { \
	return BIT_TO_NAME; \
}

/// NAME: must be a string
/// VALUE: the actual enum value, whatever it is
#define BITFIELD_NEW(NAME, VALUE) #NAME = ##VALUE

/**
 * * `ID` the same in `DECLARE_BITFIELD`
 * * `PATH` is `/your/path/whatever` (example)
 * * `VARNAME` is without quotes. This allows us to compile-time check it.
 *
 * CAVEATS:
 * * Performance of bitfield reflection is heavily dependent on how many things share the same variable
 *   name. Please ensure all bitfields are called distinct names, including across different paths.
 */
#define ASSIGN_BITFIELD(ID, PATH, VARNAME) \
/datum/bitfield/##ID/New() { \
	..(); \
	if(paths[PATH]) { \
		paths[PATH] += NAMEOF_TYPE(PATH, VARNAME); \
	} \
	else { \
		paths[PATH] = list(NAMEOF_TYPE(PATH, VARNAME)); \
	} \
}

