//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/client/AllowUpload(filename, filelength)
	if(filelength > upload_current_sizelimit)
		to_chat(src, SPAN_BOLDANNOUNCE("File upload was too large. Limit: [upload_current_sizelimit / 1024]KiB."))
		return FALSE
	return TRUE

/client/proc/is_prompting_for_file()
	return upload_mutex

/client/proc/prompt_for_file(message, title, size_limit = 1024 * 1024 * 1)
	if(upload_mutex)
		return null
	upload_mutex = TRUE
	upload_current_sizelimit = size_limit
	to_chat(src, SPAN_BOLDANNOUNCE("File upload was too large. Limit: [upload_current_sizelimit / 1024]KiB."))
	var/size_render = FLOOR(size_limit / (1024 * 1024), 0.05)
	. = input(src, message, "[title] (max [size_render]MiB)]") as file|null
	upload_current_sizelimit = null
	upload_mutex = FALSE
