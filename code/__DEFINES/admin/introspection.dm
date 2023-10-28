//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* configuration

/// this is used on all introspect client verb paths
/// use this to hook it into your admin system
#define VV_VERB_DECLARE(PATH, NAME)

//* general

/// when seen, we know to treat as global scope
#define VV_GLOBAL_SCOPE /datum/vv_global
/// max marks
#define VV_MAX_MARKS 50

//* return values for vv_edit_var

/// forbid
#define VV_EDIT_REJECT 0
/// perform after (default)
#define VV_EDIT_NORMAL 1
/// allow, but handle in proc (don't actually modify)
#define VV_EDIT_HANDLED 2

//* return values for vv_call_proc

/// forbid
#define VV_CALL_REJECT 0
/// perform after (default)
#define VV_CALL_NORMAL 1
/// allow, but handle in proc (doesn't do the normal proccall)
#define VV_CALL_HANDLED 2
/// allow, but hint that we modified the args for them
#define VV_CALL_MUTATED 3

//* helpers

/// prevent a datum from being written to
#define VV_LOCK_DATUM(path) \
##path/can_vv_call(datum/vv_context/actor, proc_name, raw_call) { return FALSE; } \
##path/vv_edit_var(datum/vv_context/actor, var_name, var_value, mass_edit, raw_edit) { return VV_EDIT_REJECT; } \
##path/can_vv_delete(datum/vv_context/actor) { return FALSE; }

/// prevent a datum from being read or written to
#define VV_FORBID_DATUM(path) \
##path/can_vv_call(datum/vv_context/actor, proc_name, raw_call) { return FALSE; } \
##path/vv_edit_var(datum/vv_context/actor, var_name, var_value, mass_edit, raw_edit) { return VV_EDIT_REJECT; } \
##path/vv_get_var(datum/vv_context/actor, var_name, raw_read) { return "!vv-forbidden!"; } \
##path/vv_var_query(datum/vv_context/actor) { return null; } \
##path/can_vv_mark(datum/vv_context/actor) { return FALSE; } \
##path/can_vv_bind(datum/vv_context/actor) { return FALSE; } \
##path/can_vv_delete(datum/vv_context/actor) { return FALSE; }

//* ui constants

#define VV_MARK_DIRECT "N"
#define VV_MARK_BINDING "B"
