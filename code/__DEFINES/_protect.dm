///Protects a datum from being VV'd or spawned through admin manipulation
#ifndef TESTING
#define VV_PROTECT(Path)\
##Path/can_vv_get(var_name){\
    return FALSE;\
}\
##Path/vv_edit_var(var_name, var_value, mass_edit, raw_edit){\
    return FALSE;\
}\
##Path/CanProcCall(procname){\
    return FALSE;\
}\
##Path/Read(savefile/savefile){\
	del(src);\
}\
##Path/Write(savefile/savefile){\
	return;\
}\
##Path/can_vv_mark(){\
	return FALSE;\
}
#else
#define VV_PROTECT(Path)
#endif
// we del instead of qdel because for security reasons we must ensure the datum does not exist if Read is called. qdel will not enforce this.

/**
 * Makes a path read-only to view variables.
 *
 * * Does not prevent the path from being marked!
 */
#define VV_PROTECT_READONLY(Path)\
##Path/vv_edit_var(var_name, var_value, mass_edit, raw_edit){\
    return FALSE;\
}\
##Path/CanProcCall(procname){\
    return FALSE;\
}
