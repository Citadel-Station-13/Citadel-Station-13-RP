VV_LOCK_DATUM(/datum/vv_context)

/**
 * context object for vv users
 *
 * holds data like markings/whatnot
 */
/datum/vv_context
	/// ckey
	var/ckey
	/// active client - keep this up to date; this should always be the client of that ckey!
	var/client/active
	#warn hook active
	/// active marks
	var/list/datum/vv_mark/marks = list()

/datum/vv_context/proc/log_action(msg)
	#warn impl

/**
 * @params
 * * msg - message
 * * reference - thing edited, whether it may be a datum or a list
 */
/datum/vv_context/proc/log_edit(msg, datum/reference)
	#warn impl

/**
 * @params
 * * target - datum being called; world for world, VV_GLOBAL_SCOPE for global
 * * procname - proc name
 * * params - list of params
 */
/datum/vv_context/proc/log_proccall(target, procname, list/params)
	#warn impl

/**
 * @params
 * * msg - message
 * * reference - thing edited, whether it may be a datum or a list
 */
/datum/vv_context/proc/send_chat(msg, datum/reference)
	#warn impl
