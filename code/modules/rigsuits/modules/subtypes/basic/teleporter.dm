//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/basic/teleporter
	var/supports_targeted_jaunt = TRUE
	var/supports_emergency_jaunt = TRUE

	var/bring_grabbed = TRUE
	var/bring_pulled = TRUE

/obj/item/rig_module/basic/teleporter/Initialize(mapload)
	. = ..()
	impl_trigger = supports_emergency_jaunt
	impl_click = supports_targeted_jaunt

/obj/item/rig_module/basic/teleporter/Destroy()
	. = ..()

/obj/item/rig_module/basic/teleporter/proc/get_emergency_jaunt_loc()

/obj/item/rig_module/basic/teleporter/proc/on_jaunt(atom/old_loc, atom/new_loc)

/obj/item/rig_module/basic/teleporter/proc/on_targeted_jaunt(atom/old_loc, atom/new_loc)

/obj/item/rig_module/basic/teleporter/proc/on_emergency_jaunt(atom/old_loc, atom/new_loc)

/obj/item/rig_module/basic/teleporter/proc/jaunt(atom/new_loc)


/obj/item/rig_module/basic/teleporter/ninja
	name = /obj/item/rig_module/basic::name + " (phase-shift jaunter)"
	desc = /obj/item/rig_module/basic::desc + " A mysterious prototype allowing the user to \
	shift through solid matter. Unlike Bluespace tunneling, it does not leave behind \
	wakes that can be traced - though the power consumption is exorbitant, and \
	its range is similarly limited."

#warn impl

