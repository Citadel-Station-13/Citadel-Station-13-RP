/datum/controller/subsystem/proc/subsystem_log(msg)
	return log_subsystem(name, msg)

/datum/controller/subsystem/proc/emit_debug_log(msg)
	subsystem_log("debug: [msg]")

/datum/controller/subsystem/proc/emit_info_log(msg)
	subsystem_log("info: [msg]")

/datum/controller/subsystem/proc/emit_warn_log(msg)
	subsystem_log("warn: [msg]")

/datum/controller/subsystem/proc/emit_error_log(msg)
	subsystem_log("error: [msg]")

/datum/controller/subsystem/proc/emit_fatal_log(msg)
	subsystem_log("fatal: [msg]")

/datum/controller/subsystem/proc/emit_init_debug(msg)
	subsystem_log("init-debug: [msg]")

/datum/controller/subsystem/proc/emit_init_info(msg)
	subsystem_log("init-info: [msg]")

/datum/controller/subsystem/proc/emit_init_warn(msg)
	subsystem_log("init-warn: [msg]")
	message_admins("[src] load warning: [msg]")

/datum/controller/subsystem/proc/emit_init_error(msg)
	subsystem_log("init-error: [msg]")
	message_admins(SPAN_BOLDANNOUNCE("Init error - [src]: [msg]"))

/datum/controller/subsystem/proc/emit_init_fatal(msg)
	subsystem_log("init-fatal: [msg]")
	to_chat(world, SPAN_BOLDANNOUNCE("Init fatal - [src]: [msg]"))
