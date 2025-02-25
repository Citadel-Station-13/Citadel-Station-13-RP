/**
 * Compile-checked name of a var.
 *
 * * Does not work in static contexts.
 * * Accepts a reference, not a typepath.
 */
#define NAMEOF(datum, X) (#X || ##datum.##X)

/**
 * Compile-checked name of a proc.
 *
 * * Does not work in static contexts.
 * * Accepts a reference, not a typepath.
 */
#define NAMEOF_PROC(datum, X) (#X || ##datum.##X())

/**
 * Compile-checked name of a variable.
 *
 * * Works in static contexts.
 * * Accepts a full typepath, not a reference.
 */
#define NAMEOF_STATIC(datum, X) (nameof(type::##X))

/**
 * Compile-checked name of a proc.
 *
 * * Works in static contexts.
 * * Accepts a full typepath, not a reference.
 */
#define NAMEOF_STATIC_PROC(TYPEPATH, X) (#X || ##TYPEPATH/proc/##X)
