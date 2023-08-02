/// world.icon_size as a define so things are constant-folded
#define WORLD_ICON_SIZE 32

/// stack trace without messing with file/line - kudos lohikar c:
#define STACK_TRACE(msg) try { CRASH("trace: [msg]"); } catch(var/exception/___E) {___rethrow_exception(___E); };
/proc/___rethrow_exception(exception/E)
	throw E

/// Gives us the stack trace from CRASH() without ending the current proc.
/// Unlike STACK_TRACE, this will:
/// * call a new proc so the originating trace isn't from the original file anymore
/// * put the stack trace in stack trace storage
#define stack_trace(message) _stack_trace(message, __FILE__, __LINE__)
