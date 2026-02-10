//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * generates a html string to embed our appearance. viewers must have seen us recently so
 * byond can render this.
 */
/atom/proc/chat_html_embed_rendered()
	// TODO: use 516 refs, for now just use the lame way
	return icon2html(src, world)
