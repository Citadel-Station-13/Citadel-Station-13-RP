/// Arbitrary sentinel value for global proc callbacks
#define GLOBAL_PROC	"some_magic_bullshit"
/// A shorthand for the callback datum, [documented here](datum/callback.html)
#define CALLBACK new /datum/callback
/// Call with waitfor = FALSE
#define INVOKE_ASYNC(TRG, PR, ARG...) if ((TRG) == GLOBAL_PROC) { spawn (-1) call(PR)(##ARG); } else { spawn(-1) call(TRG, PR)(##ARG); }

/// Varset callback for a list
#define VARSET_LIST_CALLBACK(target, var_name, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##target, ##var_name, ##var_value)
/// Varset callback for a datum
#define VARSET_CALLBACK(datum, var, var_value) CALLBACK(GLOBAL_PROC, /proc/___callbackvarset, ##datum, NAMEOF(##datum, ##var), ##var_value)
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
#define FLICK_CALLBACK(target, state) CALLBACK(GLOBAL_PROC, /proc/___callbackflick, target, state)
/// flick() using timer
#define FLICK_IN(target, state, time) addtimer(CALLBACK(GLOBAL_PROC, /proc/___callbackflick, target, state), time)

/proc/___callbackflick(target, state)
	flick(target, state)
