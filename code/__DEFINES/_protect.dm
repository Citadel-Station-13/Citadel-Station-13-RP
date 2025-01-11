/**
 * Completely occludes a path from view variable interactions.
 */
#define VV_PROTECT(Path)\
##Path{} \
##Path/can_vv_get(var_name){\
    return FALSE;\
}\
##Path/vv_edit_var(var_name, var_value, mass_edit, raw_edit){\
    return FALSE;\
}\
##Path/CanProcCall(procname){\
    return FALSE;\
}\
##Path/can_vv_mark(){\
	return FALSE;\
}

/**
 * Makes a path read-only to view variables.
 *
 * * Does not prevent the path from being marked!
 */
#define VV_PROTECT_READONLY(Path)\
##Path{} \
##Path/vv_edit_var(var_name, var_value, mass_edit, raw_edit){\
    return FALSE;\
}\
##Path/CanProcCall(procname){\
    return FALSE;\
}
