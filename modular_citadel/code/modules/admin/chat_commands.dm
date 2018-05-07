/datum/tgs_chat_command/DO_YOU_WORK
	name = "working"
	help_text = "Tells you whether or not TGS3 integration is working or not."

/datum/tgs_chat_command/DO_YOU_WORK/Run(datum/tgs_chat_user/sender, params)
	return "Yes, I'm working."
