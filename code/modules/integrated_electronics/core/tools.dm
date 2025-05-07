// TODO: why is this here? should be impl'd on multitool
/obj/item/multitool
	var/accepting_refs
	var/datum/integrated_io/selected_io = null
	var/mode = 0

/obj/item/multitool/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(selected_io)
		selected_io = null
		to_chat(user, "<span class='notice'>You clear the wired connection from the multitool.</span>")
	update_icon()

/obj/item/multitool/update_icon()
	if(selected_io)
		if(buffer || connecting || connectable)
			icon_state = "multitool_tracking"
		else
			icon_state = "multitool_red"
	else
		if(buffer || connecting || connectable)
			icon_state = "multitool_tracking_fail"
		else if(accepting_refs)
			icon_state = "multitool_ref_scan"
		else if(weakref_wiring)
			icon_state = "multitool_no_camera"
		else
			icon_state = "multitool"

/obj/item/multitool/proc/wire(var/datum/integrated_io/io, mob/user)
	if(!io.holder.assembly)
		to_chat(user, "<span class='warning'>\The [io.holder] needs to be secured inside an assembly first.</span>")
		return

	if(selected_io)
		if(io == selected_io)
			to_chat(user, "<span class='warning'>Wiring \the [selected_io.holder]'s [selected_io.name] into itself is rather pointless.</span>")
			return
		if(io.io_type != selected_io.io_type)
			to_chat(user, "<span class='warning'>Those two types of channels are incompatable.  The first is a [selected_io.io_type], \
			while the second is a [io.io_type].</span>")
			return
		if(io.holder.assembly && io.holder.assembly != selected_io.holder.assembly)
			to_chat(user, "<span class='warning'>Both \the [io.holder] and \the [selected_io.holder] need to be inside the same assembly.</span>")
			return
		selected_io.linked |= io
		io.linked |= selected_io

		to_chat(user, "<span class='notice'>You connect \the [selected_io.holder]'s [selected_io.name] to \the [io.holder]'s [io.name].</span>")
		selected_io.holder.interact(user) // This is to update the UI.
		selected_io = null

	else
		selected_io = io
		to_chat(user, "<span class='notice'>You link \the multitool to \the [selected_io.holder]'s [selected_io.name] data channel.</span>")

	update_icon()


/obj/item/multitool/proc/unwire(var/datum/integrated_io/io1, var/datum/integrated_io/io2, mob/user)
	if(!io1.linked.len || !io2.linked.len)
		to_chat(user, "<span class='warning'>There is nothing connected to the data channel.</span>")
		return

	if(!(io1 in io2.linked) || !(io2 in io1.linked) )
		to_chat(user, "<span class='warning'>These data pins aren't connected!</span>")
		return
	else
		io1.linked.Remove(io2)
		io2.linked.Remove(io1)
		to_chat(user, "<span class='notice'>You clip the data connection between the [io1.holder.displayed_name]'s \
		[io1.name] and the [io2.holder.displayed_name]'s [io2.name].</span>")
		io1.holder.interact(user) // This is to update the UI.
		update_icon()

/obj/item/multitool/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(accepting_refs && toolmode == MULTITOOL_MODE_INTCIRCUITS && (clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		weakref_wiring = WEAKREF(target)
		visible_message("<span class='notice'>[user] slides \a [src]'s over \the [target].</span>")
		to_chat(user, "<span class='notice'>You set \the [src]'s memory to a reference to [target.name] \[Ref\].  The ref scanner is \
		now off.</span>")
		accepting_refs = 0

/obj/item/storage/bag/circuits
	name = "circuit kit"
	desc = "This kit's essential for any circuitry projects."
	icon = 'icons/obj/integrated_electronics/electronic_misc.dmi'
	icon_state = "circuit_kit"
	w_class = WEIGHT_CLASS_NORMAL
	ui_numerical_mode = FALSE
	insertion_whitelist = list(
		/obj/item/integrated_circuit,
		/obj/item/storage/bag/circuits/mini,
		/obj/item/electronic_assembly,
		/obj/item/integrated_electronics,
		/obj/item/tool/crowbar,
		/obj/item/tool/screwdriver,
		/obj/item/tool/wrench,
		/obj/item/multitool
		)
	insertion_blacklist = list(/obj/item/tool/screwdriver/power)

/obj/item/storage/bag/circuits/basic/legacy_spawn_contents()
	new /obj/item/storage/bag/circuits/mini/arithmetic(src)
	new /obj/item/storage/bag/circuits/mini/trig(src)
	new /obj/item/storage/bag/circuits/mini/input(src)
	new /obj/item/storage/bag/circuits/mini/output(src)
	new /obj/item/storage/bag/circuits/mini/memory(src)
	new /obj/item/storage/bag/circuits/mini/logic(src)
	new /obj/item/storage/bag/circuits/mini/time(src)
	new /obj/item/storage/bag/circuits/mini/reagents(src)
	new /obj/item/storage/bag/circuits/mini/transfer(src)
	new /obj/item/storage/bag/circuits/mini/converter(src)
	new /obj/item/storage/bag/circuits/mini/power(src)

	new /obj/item/electronic_assembly(src)
	new /obj/item/assembly/electronic_assembly(src)
	new /obj/item/assembly/electronic_assembly(src)
	new /obj/item/multitool(src)
	new /obj/item/tool/screwdriver(src)
	new /obj/item/tool/crowbar(src)
	new /obj/item/tool/wrench(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/all/legacy_spawn_contents()
	new /obj/item/storage/bag/circuits/mini/arithmetic/all(src)
	new /obj/item/storage/bag/circuits/mini/trig/all(src)
	new /obj/item/storage/bag/circuits/mini/input/all(src)
	new /obj/item/storage/bag/circuits/mini/output/all(src)
	new /obj/item/storage/bag/circuits/mini/memory/all(src)
	new /obj/item/storage/bag/circuits/mini/logic/all(src)
	new /obj/item/storage/bag/circuits/mini/smart/all(src)
	new /obj/item/storage/bag/circuits/mini/manipulation/all(src)
	new /obj/item/storage/bag/circuits/mini/time/all(src)
	new /obj/item/storage/bag/circuits/mini/reagents/all(src)
	new /obj/item/storage/bag/circuits/mini/transfer/all(src)
	new /obj/item/storage/bag/circuits/mini/converter/all(src)
	new /obj/item/storage/bag/circuits/mini/power/all(src)

	new /obj/item/electronic_assembly(src)
	new /obj/item/electronic_assembly/medium(src)
	new /obj/item/electronic_assembly/large(src)
	new /obj/item/electronic_assembly/drone(src)
	new /obj/item/integrated_electronics/wirer(src)
	new /obj/item/integrated_electronics/debugger(src)
	new /obj/item/tool/crowbar(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini
	name = "circuit box"
	desc = "Used to partition categories of circuits, for a neater workspace."
	w_class = WEIGHT_CLASS_SMALL
	ui_numerical_mode = TRUE
	insertion_whitelist = list(/obj/item/integrated_circuit)
	var/spawn_flags_to_use = IC_SPAWN_DEFAULT

/obj/item/storage/bag/circuits/mini/arithmetic
	name = "arithmetic circuit box"
	desc = "Warning: Contains math."
	icon_state = "box_arithmetic"

/obj/item/storage/bag/circuits/mini/arithmetic/all // Don't believe this will ever be needed.
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/arithmetic/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/arithmetic/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/trig
	name = "trig circuit box"
	desc = "Danger: Contains more math."
	icon_state = "box_trig"

/obj/item/storage/bag/circuits/mini/trig/all // Ditto
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/trig/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/trig/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/input
	name = "input circuit box"
	desc = "Tell these circuits everything you know."
	icon_state = "box_input"

/obj/item/storage/bag/circuits/mini/input/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/input/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/input/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/output
	name = "output circuit box"
	desc = "Circuits to interface with the world beyond itself."
	icon_state = "box_output"

/obj/item/storage/bag/circuits/mini/output/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/output/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/output/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/memory
	name = "memory circuit box"
	desc = "Machines can be quite forgetful without these."
	icon_state = "box_memory"

/obj/item/storage/bag/circuits/mini/memory/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/memory/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/memory/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/logic
	name = "logic circuit box"
	desc = "May or may not be Turing complete."
	icon_state = "box_logic"

/obj/item/storage/bag/circuits/mini/logic/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/logic/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/logic/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/time
	name = "time circuit box"
	desc = "No time machine parts, sadly."
	icon_state = "box_time"

/obj/item/storage/bag/circuits/mini/time/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/time/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/time/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/reagents
	name = "reagent circuit box"
	desc = "Unlike most electronics, these circuits are supposed to come in contact with liquids."
	icon_state = "box_reagents"

/obj/item/storage/bag/circuits/mini/reagents/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/reagents/legacy_spawn_contents()
	. = ..()
	for(var/obj/item/integrated_circuit/reagent/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/transfer
	name = "transfer circuit box"
	desc = "Useful for moving data representing something arbitrary to another arbitrary virtual place."
	icon_state = "box_transfer"

/obj/item/storage/bag/circuits/mini/transfer/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/transfer/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/transfer/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/converter
	name = "converter circuit box"
	desc = "Transform one piece of data to another type of data with these."
	icon_state = "box_converter"

/obj/item/storage/bag/circuits/mini/converter/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/converter/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/converter/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/smart
	name = "smart box"
	desc = "Sentience not included."
	icon_state = "box_ai"

/obj/item/storage/bag/circuits/mini/smart/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/smart/legacy_spawn_contents()
	. = ..()
	for(var/obj/item/integrated_circuit/smart/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/manipulation
	name = "manipulation box"
	desc = "Make your machines actually useful with these."
	icon_state = "box_manipulation"

/obj/item/storage/bag/circuits/mini/manipulation/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/manipulation/legacy_spawn_contents()
	. = ..()
	for(var/obj/item/integrated_circuit/manipulation/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()

/obj/item/storage/bag/circuits/mini/power
	name = "power circuit box"
	desc = "Electronics generally require electricity."
	icon_state = "box_power"

/obj/item/storage/bag/circuits/mini/power/all
	spawn_flags_to_use = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/storage/bag/circuits/mini/power/legacy_spawn_contents()
	for(var/obj/item/integrated_circuit/passive/power/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	for(var/obj/item/integrated_circuit/power/IC in all_integrated_circuits)
		if(IC.spawn_flags & spawn_flags_to_use)
			for(var/i = 1 to 4)
				new IC.type(src)
	obj_storage.fit_to_contents()
