//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/client/AllowUpload(filename, filelength)
	if(isnull(upload_current_sizelimit) || !upload_mutex)
		to_chat(src, SPAN_BOLDANNOUNCE("-- Something attempted to request a file upload without using client.prompt_for_x procs. Report this to a coder. --"))
		return FALSE
	if(filelength > upload_current_sizelimit)
		to_chat(src, SPAN_BOLDANNOUNCE("File upload was too large. Limit: [upload_current_sizelimit / 1024]KiB."))
		return FALSE
	return TRUE

/**
 * Check if we're currently prompting for a file.
 * * All file requests for a client must go through these procs, or they'll be rejected.
 */
/client/proc/is_prompting_for_file()
	return upload_mutex

/client/proc/prompt_for_file_or_null(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex)
		return null
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as file|null
	upload_current_sizelimit = null
	upload_mutex = FALSE

/client/proc/prompt_for_file_or_wait(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex_waiting > 10)
		to_chat(src, SPAN_BOLDANNOUNCE("Failed to open file picker prompt: Too many prompts are queued!"))
		return null
	++upload_mutex_waiting
	UNTIL(!upload_mutex)
	--upload_mutex_waiting
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as file|null
	upload_current_sizelimit = null
	upload_mutex = FALSE

/client/proc/prompt_for_sound_or_null(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex)
		return null
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as sound|null
	upload_current_sizelimit = null
	upload_mutex = FALSE

/client/proc/prompt_for_sound_or_wait(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex_waiting > 10)
		to_chat(src, SPAN_BOLDANNOUNCE("Failed to open file (sound) picker prompt: Too many prompts are queued!"))
		return null
	++upload_mutex_waiting
	UNTIL(!upload_mutex)
	--upload_mutex_waiting
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as sound|null
	upload_current_sizelimit = null
	upload_mutex = FALSE

/client/proc/prompt_for_icon_or_null(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex)
		return null
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as icon|null
	upload_current_sizelimit = null
	upload_mutex = FALSE

/client/proc/prompt_for_icon_or_wait(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex_waiting > 10)
		to_chat(src, SPAN_BOLDANNOUNCE("Failed to open file (icon) picker prompt: Too many prompts are queued!"))
		return null
	++upload_mutex_waiting
	UNTIL(!upload_mutex)
	--upload_mutex_waiting
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as icon|null
	upload_current_sizelimit = null
	upload_mutex = FALSE
