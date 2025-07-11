//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station Developers           *//

/**
 * @return TRUE to stop propagation.
 */
/atom/Topic(href, list/href_list)
	. = ..()
	if(.)
		return
	if(href_list["hrefexamine_hook"])
		usr.examine_entity(src, from_href = TRUE)
