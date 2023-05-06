/// world.icon_size as a define so things are constant-folded
#define WORLD_ICON_SIZE 32

/// stack trace without messing with file/line - kudos lohikar c:
#define STACK_TRACE(msg) try { CRASH("trace: [msg]"); } catch(var/exception/___E) {___rethrow_exception(___E); };
/proc/___rethrow_exception(exception/E)
	throw E

/// increments a static numerically incrementing id up to and beyond SHORT_REAL_LIMIT
#define STORE_AND_INCREMENT_ASCENDING_UID(idvar, idnext) idvar = num2text(idnext > SHORT_REAL_LIMIT? (idnext += min(1, 2 ** round(idnext / SHORT_REAL_LIMIT)) : 1), 100)
/// what id_next on things that use the above should start on
#define FIRST_ASCENDING_UID 0
