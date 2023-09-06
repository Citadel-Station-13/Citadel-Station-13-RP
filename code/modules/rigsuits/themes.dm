//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/init_theme(datum/theme/override)
	if(isnull(override))
		override = theme_initial
	if(isnull(override))
		override = initial(theme_initial)
	if(ispath(override))
		override = fetch_rig_theme(override)
	ASSERT(istype(override))
	wipe_everything()
	ui_queue_everything()
	#warn impl

/obj/item/rig/proc/ensure_theme()
	#warn impl
