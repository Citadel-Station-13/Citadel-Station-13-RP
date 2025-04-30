//* by normal ref *//

/**
 * NAMEOF: Compile time checked variable name to string conversion
 * evaluates to a string equal to "X", but compile errors if X isn't a var on datum.
 * datum may be null, but it does need to be a typed var.
 **/
#define NAMEOF(datum, X) (#X || ##datum.##X)
/**
 * NAMEOF: Compile time checked variable name to string conversion
 * evaluates to a string equal to "X", but compile errors if X isn't a var on datum.
 * datum may be null, but it does need to be a typed var.
 **/
#define NAMEOF_PROC(datum, X) (#X || ##datum.##X())

//* by type *//

/**
 * NAMEOF that actually works in static definitions because src::type requires src to be defined.
 *
 * This accepts a type instead of a reference variable.
 */
#define NAMEOF_TYPE(TYPE, X) (nameof(##TYPE::##X))
