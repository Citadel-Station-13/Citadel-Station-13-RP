//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/living/carbon/gib()
	var/turf/our_turf = get_turf(src)
	if(our_turf)
		for(var/obj/item/organ/organ as anything in get_organs())
			// check if they should be obliterated with a horrific if-pyramid of doom
			// todo: customizable dropping external organs?
			if(!istype(organ, /obj/item/organ/external))
				if(!organ.always_drop_on_gib)
					if(!organ.always_drop_on_everything)
						continue
			#warn remove
			// todo: customizable throwing for gib
			var/list/possible_throw_turfs = RANGE_TURFS(3, our_turf)
			var/turf/throw_turf = SAFEPICK(possible_throw_turfs)
			organ.throw_at(throw_turf, 3, 1, THROW_AT_NEVER_HIT_PUSH)
