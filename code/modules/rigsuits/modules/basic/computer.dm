
/obj/item/rig_module/basic/power_sink

	name = "hardsuit power sink"
	desc = "An heavy-duty power sink."
	icon_state = "powersink"
	toggleable = 1
	activates_on_touch = 1
	disruptive = 0

	activate_string = "Enable Power Sink"
	deactivate_string = "Disable Power Sink"

	interface_name = "niling d-sink"
	interface_desc = "Colloquially known as a power siphon, this module drains power through the suit hands into the suit battery."

	var/atom/interfaced_with // Currently draining power from this device.
	// in kJ
	var/total_power_drained = 0
	var/drain_loc

/obj/item/rig_module/basic/power_sink/deactivate()

	if(interfaced_with)
		if(holder && holder.wearer)
			to_chat(holder.wearer, "<span class = 'warning'>Your power sink retracts as the module deactivates.</span>")
		drain_complete()
	interfaced_with = null
	total_power_drained = 0
	return ..()

/obj/item/rig_module/basic/power_sink/activate()
	interfaced_with = null
	total_power_drained = 0
	return ..()

/obj/item/rig_module/basic/power_sink/engage(atom/target)
	// Is it a valid power source?
	if(!target.can_drain_energy(src))
		return FALSE

	to_chat(H, "<span class = 'danger'>You begin draining power from [target]!</span>")
	interfaced_with = target
	drain_loc = interfaced_with.loc

	holder.spark_system.start()
	playsound(H.loc, /datum/soundbyte/sparks, 50, 1)

	return 1

/obj/item/rig_module/basic/power_sink/process(delta_time)
	var/mob/living/carbon/human/H
	if(holder && holder.wearer)
		H = holder.wearer

	if(!H || !istype(H))
		return 0

	holder.spark_system.start()
	playsound(H, /datum/soundbyte/sparks, 50, 1)

	H.break_cloak()

	if(!holder.cell)
		to_chat(H, "<span class = 'danger'>Your power sink flashes an error; there is no cell in your hardsuit.</span>")
		drain_complete(H)
		return

	if(!interfaced_with || !interfaced_with.Adjacent(H) || !(interfaced_with.loc == drain_loc))
		to_chat(H, "<span class = 'warning'>Your power sink retracts into its casing.</span>")
		drain_complete(H)
		return

	if(holder.cell.fully_charged())
		to_chat(H, "<span class = 'warning'>Your power sink flashes an amber light; your hardsuit cell is full.</span>")
		drain_complete(H)
		return

	// Attempts to drain up to 12.5*cell-capacity kW, determines this value from remaining cell capacity to ensure we don't drain too much.
	// 1Ws/(12.5*CELLRATE) = 40s to charge
	var/to_drain = min(12.5 * holder.cell.maxcharge, holder.cell.maxcharge - holder.cell.charge)
	var/target_drained = interfaced_with.drain_energy(src, DYNAMIC_CELL_UNITS_TO_KJ(to_drain))
	if(target_drained <= 0)
		to_chat(H, "<span class = 'danger'>Your power sink flashes a red light; there is no power left in [interfaced_with].</span>")
		drain_complete(H)
		return

	holder.cell.give(DYNAMIC_KJ_TO_CELL_UNITS(target_drained))
	total_power_drained += target_drained

/obj/item/rig_module/basic/power_sink/proc/drain_complete(var/mob/living/M)
	if(!interfaced_with)
		if(M)
			to_chat(M, "<font color=#4F49AF><b>Total power drained:</b> [round(DYNAMIC_KJ_TO_CELL_UNITS(total_power_drained))] cell units.</font>")
	else
		if(M)
			to_chat(M, "<font color=#4F49AF><b>Total power drained from [interfaced_with]:</b> [round(DYNAMIC_KJ_TO_CELL_UNITS(total_power_drained))] cell units.</font>")
		interfaced_with.drain_energy(src, 0, ENERGY_DRAIN_SURGE)

	drain_loc = null
	interfaced_with = null
	total_power_drained = 0
