//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

#ifdef TESTING

/client/verb/show_me_a_browser()
	set name = ".browse-debug"

	var/content = input(src, "content?", "content?") as message|null
	content = replacetext_char(content, "\n", "")
	if(!content)
		return
	var/options = input(src, "options?", "options?") as text|null
	if(!options)
		return
	src << browse(content, options)

#endif
