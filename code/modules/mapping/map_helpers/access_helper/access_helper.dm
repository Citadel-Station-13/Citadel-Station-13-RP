//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/map_helper/access_helper
	icon = 'icons/mapping/helpers/access_helpers.dmi'

/obj/map_helper/access_helper/Initialize(mapload)
	var/detected = detect()
	if(!isnull(detected))
		apply(detected)
	return ..()

/obj/map_helper/access_helper/proc/apply(to_what)
	return

/obj/map_helper/access_helper/proc/detect()
	return
