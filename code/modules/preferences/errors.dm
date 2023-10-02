/datum/preferences/proc/auto_flush_errors()
	if(!client)
		return
	flush_errors(client)

/datum/preferences/proc/flush_errors(client/C)
	if(!C)
		return
	if(!LAZYLEN(io_error_queue))
		return
	to_chat(C, io_error_queue.Join("<br>"))
	io_error_queue = null

/datum/preferences/proc/queue_errors(list/errors, head_message)
	if(!LAZYLEN(errors))
		return
	LAZYINITLIST(io_error_queue)
	var/list/lined = list()
	var/i = 0
	if(head_message)
		lined += head_message
	for(var/error in errors)
		lined += "[++i]: [error]"
	io_error_queue += errors
