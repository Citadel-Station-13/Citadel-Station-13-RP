//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_jammer
	name = "bluespace disruption flare"
	desc = "A high throughput device used to disrupt nearby teleportation systems."

/obj/item/bluespace_jammer/proc/consume_energy(joules)
	#warn impl

/obj/item/bluespace_jammer/trap
	name = "modified disruption flare"
	desc = "A reprogrammed bluespace disruptor flare. Instead of jamming teleportation from an accurate lock-on, this gadget redirects any unfortunate objects in transit towards its area of effect."
