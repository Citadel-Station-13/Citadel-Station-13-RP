/// Arbitrary sentinel value for global proc callbacks
#define GLOBAL_PROC	"some_magic_bullshit"
/// A shorthand for the callback datum, [documented here](datum/callback.html)
#define CALLBACK new /datum/callback
///Per the DM reference, spawn(-1) will execute the spawned code immediately until a block is met.
#define MAKE_SPAWN_ACT_LIKE_WAITFOR -1
///Create a codeblock that will not block the callstack if a block is met.
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

/// Varset callback for a list
#define VARSET_LIST_CALLBACK(target, var_name, var_value) CALLBACK(GLOBAL_PROC_REF(___callbackvarset), ##target, ##var_name, ##var_value)
/// Varset callback for a datum
#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC_REF(___callbackvarset), ##datum, NAMEOF(##datum, ##var), ##var_value)
/// Create a varset timer
#define VARSET_IN(datum, var, var_value, time) addtimer(VARSET_CALLBACK(datum, var, var_value), time)

/proc/___callbackvarset(list_or_datum, var_name, var_value)
	if(islist(list_or_datum))
		list_or_datum[var_name] = var_value
		return
	var/datum/datum = list_or_datum
	if(IsAdminAdvancedProcCall())
		datum.vv_edit_var(var_name, var_value) //same result generally, unless badmemes
	else
		datum.vars[var_name] = var_value

/// flick() callback
#define FLICK_CALLBACK(state, target) CALLBACK(GLOBAL_PROC_REF(___callbackflick), target, state)
/// flick() using timer
#define FLICK_IN(state, target, time) addtimer(CALLBACK(GLOBAL_PROC_REF(___callbackflick), target, state), time)

/proc/___callbackflick(target, state)
	flick(target, state)
