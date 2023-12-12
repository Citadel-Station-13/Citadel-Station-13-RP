//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn circuit

/obj/machinery/teleporter/bluespace_projector
	name = "bluespace field projector"
	desc = "A prototype field projector used to project a confinement field over a teleportation pad."

	/// linked capacitor
	var/obj/machinery/teleporter/bluespace_capacitor/capacitor
	/// target pad
	var/obj/machinery/teleporter/bluespace_pad/active_target

/obj/machinery/teleporter/bluespace_projector/proc/draw(kilojoules)
	return capacitor?.use(kilojoules)

/obj/machinery/teleporter/bluespace_projector/drain_energy(datum/actor, amount, flags)
	return draw(amount)

/obj/machinery/teleporter/bluespace_projector/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TelesciProjector")
		ui.open()

#warn teleport_projector
