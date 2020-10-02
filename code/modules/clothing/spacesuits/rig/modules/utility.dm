/* Contains:
 * /obj/item/rig_module/device
 * /obj/item/rig_module/device/plasmacutter
 * /obj/item/rig_module/device/healthscanner
 * /obj/item/rig_module/device/drill
 * /obj/item/rig_module/device/orescanner
 * /obj/item/rig_module/device/rcd
 * /obj/item/rig_module/device/anomaly_scanner
 * /obj/item/rig_module/maneuvering_jets
 * /obj/item/rig_module/foam_sprayer
 * /obj/item/rig_module/device/broadcaster
 * /obj/item/rig_module/chem_dispenser
 * /obj/item/rig_module/chem_dispenser/injector
 * /obj/item/rig_module/voice
 * /obj/item/rig_module/device/paperdispenser
 * /obj/item/rig_module/device/pen
 * /obj/item/rig_module/device/stamp
 * /obj/item/rig_module/mounted/mop
 * /obj/item/rig_module/cleaner_launcher
 */

/obj/item/rig_module/device
	name = "mounted device"
	desc = "Some kind of hardsuit mount."
	usable = 0
	selectable = 1
	toggleable = 0
	disruptive = 0

	var/device_type
	var/obj/item/device

/obj/item/rig_module/device/plasmacutter
	name = "hardsuit plasma cutter"
	desc = "A lethal-looking industrial cutter."
	icon_state = "plasmacutter"
	interface_name = "plasma cutter"
	interface_desc = "A self-sustaining plasma arc capable of cutting through walls."
	suit_overlay_active = "plasmacutter"
	suit_overlay_inactive = "plasmacutter"
	use_power_cost = 0.5

	device_type = /obj/item/pickaxe/plasmacutter

/obj/item/rig_module/device/healthscanner
	name = "health scanner module"
	desc = "A hardsuit-mounted health scanner."
	icon_state = "scanner"
	interface_name = "health scanner"
	interface_desc = "Shows an informative health readout when used on a subject."

	device_type = /obj/item/healthanalyzer

/obj/item/rig_module/device/drill
	name = "hardsuit drill mount"
	desc = "A very heavy diamond-tipped drill."
	icon_state = "drill"
	interface_name = "mounted drill"
	interface_desc = "A diamond-tipped industrial drill."
	suit_overlay_active = "mounted-drill"
	suit_overlay_inactive = "mounted-drill"
	use_power_cost = 0.1

	device_type = /obj/item/pickaxe/diamonddrill

/obj/item/rig_module/device/anomaly_scanner
	name = "hardsuit anomaly scanner"
	desc = "You think it's called an Elder Sarsparilla or something."
	icon_state = "eldersasparilla"
	interface_name = "Alden-Saraspova counter"
	interface_desc = "An exotic particle detector commonly used by xenoarchaeologists."
	engage_string = "Begin Scan"
	usable = 1
	selectable = 0
	device_type = /obj/item/ano_scanner

/obj/item/rig_module/device/orescanner
	name = "ore scanner module"
	desc = "A clunky old ore scanner."
	icon_state = "scanner"
	interface_name = "ore detector"
	interface_desc = "A sonar system for detecting large masses of ore."
	engage_string = "Begin Scan"
	usable = 1
	selectable = 0
	device_type = /obj/item/mining_scanner

/obj/item/rig_module/device/orescanner/advanced
	name = "advanced ore scanner module"
	desc = "A sleeker, yet still somewhat clunky ore scanner."
	interface_name = "adv. ore detector"
	device_type = /obj/item/mining_scanner/advanced

/obj/item/rig_module/device/rcd
	name = "RCD mount"
	desc = "A cell-powered rapid construction device for a hardsuit."
	icon_state = "rcd"
	interface_name = "mounted RCD"
	interface_desc = "A device for building or removing walls. Cell-powered."
	usable = 1
	engage_string = "Configure RCD"

	device_type = /obj/item/rcd/electric/mounted/rig

/obj/item/rig_module/device/New()
	..()
	if(device_type) device = new device_type(src)

/obj/item/rig_module/device/engage(atom/target)
	if(!..() || !device)
		return FALSE

	if(!target)
		device.attack_self(holder.wearer)
		return TRUE

	var/turf/T = get_turf(target)
	if(istype(T) && !T.Adjacent(get_turf(src)))
		return FALSE

	var/resolved = target.attackby(device,holder.wearer)
	if(!resolved && device && target)
		device.afterattack(target,holder.wearer,1)
	return TRUE



/obj/item/rig_module/chem_dispenser
	name = "mounted chemical dispenser"
	desc = "A complex web of tubing and needles suitable for hardsuit use."
	icon_state = "injector"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0

	engage_string = "Inject"

	interface_name = "integrated chemical dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream."

	charges = list(
		list("tricordrazine", "tricordrazine", 0, 80),
		list("tramadol",      "tramadol",      0, 80),
		list("dexalin plus",  "dexalinp",      0, 80),
		list("antibiotics",   "spaceacillin",  0, 80),
		list("antitoxins",    "anti_toxin",    0, 80),
		list("nutrients",     "glucose",     0, 80),
		list("hyronalin",     "hyronalin",     0, 80),
		list("radium",        "radium",        0, 80)
		)

	var/max_reagent_volume = 80 //Used when refilling.

/obj/item/rig_module/chem_dispenser/ninja
	interface_desc = "Dispenses loaded chemicals directly into the wearer's bloodstream. This variant is made to be extremely light and flexible."

	//Want more? Go refill. Gives the ninja another reason to have to show their face.
	charges = list(
		list("tricordrazine", "tricordrazine", 0, 30),
		list("tramadol",      "tramadol",      0, 30),
		list("dexalin plus",  "dexalinp",      0, 30),
		list("antibiotics",   "spaceacillin",  0, 30),
		list("antitoxins",    "anti_toxin",    0, 60),
		list("nutrients",     "glucose",       0, 80),
		list("bicaridine",	  "bicaridine",    0, 30),
		list("clotting agent", "myelamine",    0, 30),
		list("peridaxon",     "peridaxon",     0, 30),
		list("hyronalin",     "hyronalin",     0, 30),
		list("radium",        "radium",        0, 30)
		)

/obj/item/rig_module/chem_dispenser/accepts_item(var/obj/item/input_item, var/mob/living/user)

	if(!input_item.is_open_container())
		return FALSE

	if(!input_item.reagents || !input_item.reagents.total_volume)
		to_chat(user, "\The [input_item] is empty.")
		return FALSE

	// Magical chemical filtration system, do not question it.
	var/total_transferred = 0
	for(var/datum/reagent/R in input_item.reagents.reagent_list)
		for(var/chargetype in charges)
			var/datum/rig_charge/charge = charges[chargetype]
			if(charge.display_name == R.id)

				var/chems_to_transfer = R.volume

				if((charge.charges + chems_to_transfer) > max_reagent_volume)
					chems_to_transfer = max_reagent_volume - charge.charges

				charge.charges += chems_to_transfer
				input_item.reagents.remove_reagent(R.id, chems_to_transfer)
				total_transferred += chems_to_transfer

				break

	if(total_transferred)
		to_chat(user, "<font color='blue'>You transfer [total_transferred] units into the suit reservoir.</font>")
	else
		to_chat(user, "<span class='danger'>None of the reagents seem suitable.</span>")
	return TRUE

/obj/item/rig_module/chem_dispenser/engage(atom/target)

	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a chemical type.</span>")
		return FALSE

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return FALSE

	var/chems_to_use = 10
	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient chems!</span>")
		return FALSE
	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(target)
		if(istype(target,/mob/living/carbon))
			target_mob = target
		else
			return FALSE
	else
		target_mob = H

	if(target_mob != H)
		to_chat(H, "<span class='danger'>You inject [target_mob] with [chems_to_use] unit\s of [charge.display_name].</span>")
	to_chat(target_mob, "<span class='danger'>You feel a rushing in your veins as [chems_to_use] unit\s of [charge.display_name] [chems_to_use == 1 ? "is" : "are"] injected.</span>")
	target_mob.reagents.add_reagent(charge.display_name, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return TRUE

/obj/item/rig_module/chem_dispenser/combat

	name = "combat chemical injector"
	desc = "A complex web of tubing and needles suitable for hardsuit use."

	charges = list(
		list("synaptizine",   "synaptizine",   0, 30),
		list("hyperzine",     "hyperzine",     0, 30),
		list("oxycodone",     "oxycodone",     0, 30),
		list("nutrients",     "glucose",     0, 80),
		list("clotting agent", "myelamine", 0, 80)
		)

	interface_name = "combat chem dispenser"
	interface_desc = "Dispenses loaded chemicals directly into the bloodstream."


/obj/item/rig_module/chem_dispenser/injector

	name = "mounted chemical injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	usable = 0
	selectable = 1
	disruptive = 1

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

/obj/item/rig_module/chem_dispenser/injector/advanced

	charges = list(
		list("tricordrazine", "tricordrazine", 0, 80),
		list("tramadol",      "tramadol",      0, 80),
		list("dexalin plus",  "dexalinp",      0, 80),
		list("antibiotics",   "spaceacillin",  0, 80),
		list("antitoxins",    "anti_toxin",    0, 80),
		list("nutrients",     "glucose",     0, 80),
		list("hyronalin",     "hyronalin",     0, 80),
		list("radium",        "radium",        0, 80),
		list("clotting agent", "myelamine", 0, 80)
		)

/obj/item/rig_module/voice

	name = "hardsuit voice synthesiser"
	desc = "A speaker box and sound processor."
	icon_state = "megaphone"
	usable = 1
	selectable = 0
	toggleable = 0
	disruptive = 0

	engage_string = "Configure Synthesiser"

	interface_name = "voice synthesiser"
	interface_desc = "A flexible and powerful voice modulator system."

	var/obj/item/voice_changer/voice_holder

/obj/item/rig_module/voice/New()
	..()
	voice_holder = new(src)
	voice_holder.active = 0

/obj/item/rig_module/voice/installed()
	..()
	holder.speech = src

/obj/item/rig_module/voice/engage()

	if(!..())
		return FALSE

	var/choice= input("Would you like to toggle the synthesiser or set the name?") as null|anything in list("Enable","Disable","Set Name")

	if(!choice)
		return FALSE

	switch(choice)
		if("Enable")
			active = 1
			voice_holder.active = 1
			to_chat(usr, "<font color='blue'>You enable the speech synthesiser.</font>")
		if("Disable")
			active = 0
			voice_holder.active = 0
			to_chat(usr, "<font color='blue'>You disable the speech synthesiser.</font>")
		if("Set Name")
			var/raw_choice = sanitize(input(usr, "Please enter a new name.")  as text|null, MAX_NAME_LEN)
			if(!raw_choice)
				return FALSE
			voice_holder.voice = raw_choice
			to_chat(usr, "<font color='blue'>You are now mimicking <B>[voice_holder.voice]</B>.</font>")
	return TRUE

/obj/item/rig_module/maneuvering_jets

	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	icon_state = "thrusters"
	usable = 1
	toggleable = 1
	selectable = 0
	disruptive = 0

	suit_overlay_active = "maneuvering_active"
	suit_overlay_inactive = null //"maneuvering_inactive"

	engage_string = "Toggle Stabilizers"
	activate_string = "Activate Thrusters"
	deactivate_string = "Deactivate Thrusters"

	interface_name = "maneuvering jets"
	interface_desc = "An inbuilt EVA maneuvering system that runs off the rig air supply."

	var/obj/item/tank/jetpack/rig/jets

/obj/item/rig_module/maneuvering_jets/engage()
	if(!..())
		return FALSE
	jets.toggle_rockets()
	return TRUE

/obj/item/rig_module/maneuvering_jets/activate()

	if(active)
		return FALSE

	active = 1

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	if(!jets.on)
		jets.toggle()
	return TRUE

/obj/item/rig_module/maneuvering_jets/deactivate()
	if(!..())
		return FALSE
	if(jets.on)
		jets.toggle()
	return TRUE

/obj/item/rig_module/maneuvering_jets/New()
	..()
	jets = new(src)

/obj/item/rig_module/maneuvering_jets/installed()
	..()
	jets.holder = holder
	jets.ion_trail.set_up(holder)

/obj/item/rig_module/maneuvering_jets/removed()
	..()
	jets.holder = null
	jets.ion_trail.set_up(jets)

/obj/item/rig_module/foam_sprayer


//Deployable Mop

/obj/item/rig_module/mounted/mop

	name = "mop projector"
	desc = "A powerful mop projector."
	icon_state = "mop"

	activate_string = "Project Mop"
	deactivate_string = "Cancel Mop"

	interface_name = "mop projector"
	interface_desc = "A mop that can be deployed from the hand of the wearer."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 0
	active_power_cost = 0
	passive_power_cost = 0

	gun = /obj/item/reagent_containers/spray/cleaner

//obj/item/reagent_containers/spray/cleaner
//	spary =

/obj/item/rig_module/mounted/engage(atom/target)

	if(!..())
		return FALSE

	if(!target)
		gun.attack_self(holder.wearer)
		return TRUE

	gun.Fire(target,holder.wearer)
	return TRUE

/obj/item/rig_module/mounted/mop/process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/mop_deploy) in holder.wearer))
			deactivate()
			return FALSE

	return ..()

/obj/item/rig_module/mounted/mop/activate()

	..()

	var/mob/living/M = holder.wearer

	if(M.l_hand && M.r_hand)
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		deactivate()
		return

	var/obj/item/mop_deploy/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

/obj/item/rig_module/mounted/mop/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/mop_deploy/blade in M.contents)
		M.drop_from_inventory(blade)
		qdel(blade)


	//Space Cleaner Launcher

/obj/item/rig_module/cleaner_launcher

	name = "mounted space cleaner launcher"
	desc = "A shoulder-mounted micro-cleaner dispenser."
	selectable = 1
	icon_state = "grenade_launcher"

	interface_name = "integrated cleaner launcher"
	interface_desc = "Discharges loaded cleaner grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("cleaner grenade",   "cleaner grenade",   /obj/item/grenade/chem_grenade/cleaner,  9),
		)

/obj/item/rig_module/cleaner_launcher/accepts_item(var/obj/item/input_device, var/mob/living/user)

	if(!istype(input_device) || !istype(user))
		return FALSE

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return FALSE

	if(accepted_item.charges >= 5)
		to_chat(user, "<span class='danger'>Another grenade of that type will not fit into the module.</span>")
		return FALSE

	to_chat(user, "<font color='blue'><b>You slot \the [input_device] into the suit module.</b></font>")
	user.drop_from_inventory(input_device)
	qdel(input_device)
	accepted_item.charges++
	return TRUE

/obj/item/rig_module/cleaner_launcher/engage(atom/target)

	if(!..())
		return FALSE

	if(!target)
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a grenade type.</span>")
		return FALSE

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return FALSE

	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient grenades!</span>")
		return FALSE

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message("<span class='danger'>[H] launches \a [new_grenade]!</span>")
	new_grenade.activate(H)
	new_grenade.throw_at(target,fire_force,fire_distance)

/obj/item/rig_module/device/paperdispenser
	name = "hardsuit paper dispenser"
	desc = "Crisp sheets."
	icon_state = "paper"
	interface_name = "paper dispenser"
	interface_desc = "Dispenses warm, clean, and crisp sheets of paper."
	engage_string = "Dispense"
	usable = 1
	selectable = 0
	device_type = /obj/item/paper_bin

/obj/item/rig_module/device/paperdispenser/engage(atom/target)

	if(!..() || !device)
		return FALSE

	if(!target)
		device.attack_hand(holder.wearer)
		return TRUE

/obj/item/rig_module/device/pen
	name = "mounted pen"
	desc = "For mecha John Hancocks."
	icon_state = "pen"
	interface_name = "mounted pen"
	interface_desc = "Signatures with style(tm)."
	engage_string = "Change color"
	usable = 1
	device_type = /obj/item/pen/multi

/obj/item/rig_module/device/stamp
	name = "mounted internal affairs stamp"
	desc = "DENIED."
	icon_state = "stamp"
	interface_name = "mounted stamp"
	interface_desc = "Leave your mark."
	engage_string = "Toggle stamp type"
	usable = 1
	var/iastamp
	var/deniedstamp

/obj/item/rig_module/device/stamp/New()
	..()
	iastamp = new /obj/item/stamp/internalaffairs(src)
	deniedstamp = new /obj/item/stamp/denied(src)
	device = iastamp

/obj/item/rig_module/device/stamp/engage(atom/target)
	if(!..() || !device)
		return FALSE

	if(!target)
		if(device == iastamp)
			device = deniedstamp
			to_chat(holder.wearer, "<span class='notice'>Switched to denied stamp.</span>")
		else if(device == deniedstamp)
			device = iastamp
			to_chat(holder.wearer, "<span class='notice'>Switched to internal affairs stamp.</span>")
		return TRUE

/obj/item/rig_module/sprinter
	name = "sprint module"
	desc = "A robust hardsuit-integrated sprint module."
	icon_state = "sprinter"

	var/sprint_speed = 1

	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 0
	active_power_cost = 5
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable Sprint"
	deactivate_string = "Disable Sprint"

	interface_name = "sprint system"
	interface_desc = "Increases power to the suit's actuators, allowing faster movement."

/obj/item/rig_module/sprinter/activate()

	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, "<font color='blue'><b>You activate the suit's sprint mode.</b></font>")

	holder.slowdown -= sprint_speed

/obj/item/rig_module/sprinter/deactivate()

	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer

	to_chat(H, "<span class='danger'>Your hardsuit returns to normal speed.</span>")

	holder.slowdown += sprint_speed

/obj/item/rig_module/pat_module
	name = "\improper P.A.T. module"
	desc = "A \'Pre-emptive Access Tunneling\' module, for opening every door in a hurry."
	icon_state = "cloak"

	var/range = 3

	usable = 1
	toggleable = 1
	disruptable = 1
	disruptive = 0

	use_power_cost = 100
	active_power_cost = 1
	passive_power_cost = 0
	module_cooldown = 30

	activate_string = "Enable P.A.T."
	deactivate_string = "Disable P.A.T."
	engage_string = "Override Airlock"

	interface_name = "PAT system"
	interface_desc = "For opening doors ahead of you, in advance. Override notifies command staff."

/*
	var/message = "[H] has activated \a [src] in [get_area(T)] at position [T.x],[T.y],[T.z], giving them full access for medical rescue."
	var/obj/item/radio/headset/a = new /obj/item/radio/headset/heads/captain(null)
	a.icon = icon
	a.icon_state = icon_state
	a.autosay(message, "Security Subsystem", "Command")
	a.autosay(message, "Security Subsystem", "Security")
	qdel(a)
*/

/obj/item/rig_module/pat_module/activate()
	if(!..(TRUE)) //Skip the engage() call, that's for the override and is 'spensive.
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H,"<span class='notice'>You activate the P.A.T. module.</span>")
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, .proc/boop)

/obj/item/rig_module/pat_module/deactivate()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = holder.wearer
	to_chat(H,"<span class='notice'>Your disable the P.A.T. module.</span>")
	UnregisterSignal(H, COMSIG_MOVABLE_MOVED)

/obj/item/rig_module/pat_module/proc/boop(var/mob/living/carbon/human/user,var/turf/To,var/turf/Tn)
	if(!istype(user) || !istype(To) || !istype(Tn))
		deactivate() //They were picked up or something, or put themselves in a locker, who knows. Just turn off.
		return

	var/direction = user.dir
	var/turf/current = Tn
	for(var/i = 0; i < range; i++)
		current = get_step(current,direction)
		if(!current) break

		var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in current
		if(!A || !A.density) continue

		if(A.allowed(user) && A.operable())
			A.open()

/obj/item/rig_module/pat_module/engage()
	var/mob/living/carbon/human/H = holder.wearer
	if(!istype(H))
		return FALSE

	var/obj/machinery/door/airlock/A = locate(/obj/machinery/door/airlock) in get_step(H,H.dir)

	//Okay, we either found an airlock or we're about to give up.
	if(!A || !A.density || !A.can_open() || !..())
		to_chat(H,"<span class='warning'>Unable to comply! Energy too low, or not facing a working airlock!</span>")
		return FALSE

	H.visible_message("<span class='warning'>[H] begins overriding the airlock!</span>","<span class='notice'>You begin overriding the airlock!</span>")
	if(do_after(H,6 SECONDS,A) && A.density)
		A.open()

	var/username = FindNameFromID(H) || "Unknown"
	var/message = "[username] has overridden [A] (airlock) in \the [get_area(A)] at [A.x],[A.y],[A.z] with \the [src]."
	global_announcer.autosay(message, "Security Subsystem", "Command")
	global_announcer.autosay(message, "Security Subsystem", "Security")
	return TRUE

/obj/item/rig_module/rescue_pharm
	name = "micro-pharmacy"
	desc = "A small chemical dispenser with integrated micro cartridges."
	usable = 0
	selectable = 1
	disruptive = 1
	toggleable = 1

	use_power_cost = 0
	active_power_cost = 5

	activate_string = "Enable Regen"
	deactivate_string = "Disable Regen"

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

	var/max_reagent_volume = 20 //Regen to this volume
	var/chems_to_use = 5 //Per injection

	charges = list(
		list("inaprovaline",  "inaprovaline",  0, 20),
		list("anti_toxin",  "anti_toxin",  0, 20),
		list("paracetamol",      "paracetamol",      0, 20),
		list("dexalin",  "dexalin",      0, 20)
		)

/obj/item/rig_module/rescue_pharm/process()
	. = ..()
	if(active)
		var/did_work = 0

		for(var/charge in charges)
			var/datum/rig_charge/C = charges[charge]

			//Found one that isn't full
			if(C.charges < max_reagent_volume)
				did_work = 1
				C.charges += 1
				break

		if (!did_work)
			deactivate() //All done

/obj/item/rig_module/rescue_pharm/engage(atom/target)
	if(!target)
		return TRUE //You're just toggling the module on, not clicking someone.

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H,"<span class='danger'>You have not selected a chemical type.</span>")
		return FALSE

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return FALSE

	if(charge.charges <= 0)
		to_chat(H,"<span class='danger'>Insufficient chems!</span>")
		return FALSE

	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(istype(target,/mob/living/carbon))
		target_mob = target
	else
		return FALSE

	to_chat(H,"<span class='notice'>You inject [target_mob == H ? "yourself" : target_mob] with [chems_to_use] unit\s of [charge.short_name].</span>")
	to_chat(target_mob,"<span class='notice'>You feel a rushing in your veins as you're injected by \the [src].</span>")
	target_mob.reagents.add_reagent(charge.display_name, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return TRUE
