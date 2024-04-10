// todo: we need to rethink if we need/want a cluster at some point (and why is the answer yes :^))
//       and how to orchestrate. topics are nice, but they shouldn't be the end-all backend for this.
//
//       not to mention we also need a cross-server/unified DB.
//       2025 DB rework..?

/datum/config_entry/string/comms_key
	protection = CONFIG_ENTRY_HIDDEN

/datum/config_entry/string/comms_key/ValidateAndSet(str_val)
	return str_val != "default_pwd" && length(str_val) > 6 && ..()

// todo: remove, cluster staging/organization should be in a database
/datum/config_entry/string/cross_comms_name
