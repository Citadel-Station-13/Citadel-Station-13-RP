//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/human/click_on(atom/target, location, control, raw_params, inject_clickchain_flags)
	// this does imply abilities are not put in clickchain logs,
	// but hey what can i do about old code i'm not refactoring this shit right now lmao
	if(ab_handler?.process_click(src, target))
		return
	..()
