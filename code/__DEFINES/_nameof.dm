//* by normal ref *//

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

//* by type *//

/**

 * NAMEOF that actually works in static definitions because src::type requires src to be defined.
 *
 * This accepts a type instead of a reference variable.
 */
#define NAMEOF_TYPE(TYPE, X) (nameof(##TYPE::##X))

/**

 * NAMEOF that actually works in static definitions because src::type requires src to be defined.
 *
 * This accepts a type instead of a reference variable.
 */
#define NAMEOF_TYPE_PROC(TYPE, X) (nameof(##TYPE/proc/##X))
