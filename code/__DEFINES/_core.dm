/// world.icon_size as a define so things are constant-folded
#define WORLD_ICON_SIZE 32

/// stack trace without messing with file/line - kudos lohikar c:
#define STACK_TRACE(msg) try { CRASH("trace: [msg]"); } catch(var/exception/___E) {___rethrow_exception(___E); };
/proc/___rethrow_exception(exception/E)
	throw E

/// get variable if not null or
#define VALUE_OR_DEFAULT(VAL, DEFAULT) (isnull(VAL)? (DEFAULT) : (VAL))

/// byond bug https://secure.byond.com/forum/?post=2072419
#define BLOCK_BYOND_BUG_2072419

/// A null statement to guard against EmptyBlock lint without necessitating the use of pass()
/// Used to avoid proc-call overhead. But use sparingly. Probably pointless in most places.
#define EMPTY_BLOCK_GUARD ;

// THIS IS ON THIS FILE NOT IN `typeids.dm` DUE TO DEFINE LOAD ORDER!!!
// Refs contain a type id within their string that can be used to identify byond types.
// Custom types that we define don't get a unique id, but this is useful for identifying
// types that don't normally have a way to run istype() on them.
#define TYPEID(thing) copytext(REF(thing), 4, 6)
