// this file must be at the top of defines.
// these are things used basically everywhere else.

//* Execution Constants *//

/// world.icon_size as a define so things are constant-folded
#define WORLD_ICON_SIZE 32

//* Error Handling *//

/// stack trace without messing with file/line - kudos lohikar c:
#define STACK_TRACE(msg) try { CRASH("trace: [msg]"); } catch(var/exception/___E) {___rethrow_exception(___E); };
/proc/___rethrow_exception(exception/E)
	throw E

/// Gives us the stack trace from CRASH() without ending the current proc.
/// Unlike STACK_TRACE, this will:
/// * call a new proc so the originating trace isn't from the original file anymore
/// * put the stack trace in stack trace storage
#define stack_trace(message) _stack_trace(message, __FILE__, __LINE__)

//* Function Calls *//

/// Arbitrary sentinel value for global proc callbacks, bound procs, and other proc ref systems
#define GLOBAL_PROC	"some_magic_bullshit"

/// Per the DM reference, spawn(-1) will execute the spawned code immediately until a block is met.
#define MAKE_SPAWN_ACT_LIKE_WAITFOR -1
/// Create a codeblock that will not block the callstack if a block is met.
#define ASYNC spawn(MAKE_SPAWN_ACT_LIKE_WAITFOR)

#define INVOKE_ASYNC(proc_owner, proc_path, proc_arguments...) \
	if ((proc_owner) == GLOBAL_PROC) { \
		ASYNC { \
			call(proc_path)(##proc_arguments); \
		}; \
	} \
	else { \
		ASYNC { \
			/* Written with `0 ||` to avoid the compiler seeing call("string"), and thinking it's a deprecated DLL */ \
			call(0 || proc_owner, proc_path)(##proc_arguments); \
		}; \
	}

//* Byond-isms *//

/// byond bug https://secure.byond.com/forum/?post=2072419
#define BLOCK_BYOND_BUG_2072419
