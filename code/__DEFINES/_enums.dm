//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * `ID` must be unique and in `snake_case`
 * * `ENUM_TO_NAME` should be an list() with `ENUM_NAMED()`'s inside it.
 */
#define DECLARE_ENUM(ID, ENUM_TO_NAME); \
/datum/enum/##ID/get_enum_constants() { \
	return ENUM_TO_NAME; \
}

/// ENUM: must be the define, name will be the define itself.
#define ENUM(ENUM) #ENUM = ENUM
/// NAME: must be a string
/// VALUE: the actual enum value, whatever it is
#define ENUM_NAMED(NAME, VALUE) NAME = ##VALUE

/**
 * * `ID` the same in `DECLARE_ENUM`
 * * `PATH` is `/your/path/whatever` (example)
 * * `VARNAME` is without quotes. This allows us to compile-time check it.
 *
 * CAVEATS:
 * * Performance of enum reflection is heavily dependent on how many things share the same variable
 *   name. Please ensure all enums are called distinct names, including across different paths.
 */
#define ASSIGN_ENUM(ID, PATH, VARNAME) \
/datum/enum/##ID/New() { \
	..(); \
	if(paths[PATH]) { \
		paths[PATH] += NAMEOF_TYPE(PATH, VARNAME); \
	} \
	else { \
		paths[PATH] = list(NAMEOF_TYPE(PATH, VARNAME)); \
	} \
}
