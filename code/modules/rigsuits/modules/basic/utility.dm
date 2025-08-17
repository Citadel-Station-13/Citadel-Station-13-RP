/obj/item/rig_module/basic/device/plasmacutter
	name = "hardsuit plasma cutter"
	desc = "A lethal-looking industrial cutter."
	icon_state = "plasmacutter"
	interface_name = "plasma cutter"
	interface_desc = "A self-sustaining plasma arc capable of cutting through walls."
	suit_overlay_active = "plasmacutter"
	suit_overlay_inactive = "plasmacutter"
	use_power_cost = 0.01
	module_cooldown = 0.5

	device_type = /obj/item/pickaxe/plasmacutter

/obj/item/rig_module/basic/device/healthscanner
	name = "health scanner module"
	desc = "A hardsuit-mounted health scanner."
	icon_state = "scanner"
	interface_name = "health scanner"
	interface_desc = "Shows an informative health readout when used on a subject."

	device_type = /obj/item/healthanalyzer

/obj/item/rig_module/basic/device/drill
	name = "hardsuit drill mount"
	desc = "A very heavy diamond-tipped drill."
	icon_state = "drill"
	interface_name = "mounted drill"
	interface_desc = "A diamond-tipped industrial drill."
	suit_overlay_active = "mounted-drill"
	suit_overlay_inactive = "mounted-drill"
	use_power_cost = 0.01
	module_cooldown = 0.5

	device_type = /obj/item/pickaxe/diamonddrill

/obj/item/rig_module/basic/device/rcd
	name = "RCD mount"
	desc = "A cell-powered rapid construction device for a hardsuit."
	icon_state = "rcd"
	interface_name = "mounted RCD"
	interface_desc = "A device for building or removing walls. Cell-powered."
	usable = 1
	engage_string = "Configure RCD"

	device_type = /obj/item/rcd/electric/mounted/hardsuit

/obj/item/rig_module/basic/device/Initialize(mapload)
	. = ..()
	if(device_type) device = new device_type(src)

/obj/item/rig_module/basic/device/engage(atom/target)
	if(!..() || !device)
		return 0

	if(!target)
		device.attack_self(holder.wearer)
		return 1

	var/turf/T = get_turf(target)
	if(istype(T) && !T.Adjacent(get_turf(src)))
		return 0

	device.melee_interaction_chain(target, holder.wearer, CLICKCHAIN_HAS_PROXIMITY)
	return 1

/obj/item/rig_module/basic/chem_dispenser
	name = "mounted chemical dispenser"
	desc = "A complex web of tubing and needles suitable for hardsuit use."
	icon_state = "injector"
	usable = 1
	selectable = 0
	toggleable = 0

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

/obj/item/rig_module/basic/chem_dispenser/ninja
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

/obj/item/rig_module/basic/chem_dispenser/accepts_item(var/obj/item/input_item, var/mob/living/user)

	if(!input_item.is_open_container())
		return 0

	if(!input_item.reagents || !input_item.reagents.total_volume)
		to_chat(user, "\The [input_item] is empty.")
		return 0

	// Magical chemical filtration system, do not question it.
	var/total_transferred = 0
	for(var/datum/reagent/R in input_item.reagents.get_reagent_datums())
		for(var/chargetype in charges)
			var/datum/rig_charge/charge = charges[chargetype]
			if(charge.display_name == R.id)

				var/chems_to_transfer = input_item.reagents.reagent_volumes[R.id]

				if((charge.charges + chems_to_transfer) > max_reagent_volume)
					chems_to_transfer = max_reagent_volume - charge.charges

				charge.charges += chems_to_transfer
				input_item.reagents.remove_reagent(R.id, chems_to_transfer)
				total_transferred += chems_to_transfer
				break

	if(total_transferred)
		to_chat(user, "<font color=#4F49AF>You transfer [total_transferred] units into the suit reservoir.</font>")
	else
		to_chat(user, "<span class='danger'>None of the reagents seem suitable.</span>")
	return 1

/obj/item/rig_module/basic/chem_dispenser/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, "<span class='danger'>You have not selected a chemical type.</span>")
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	var/chems_to_use = 10
	if(charge.charges <= 0)
		to_chat(H, "<span class='danger'>Insufficient chems!</span>")
		return 0
	else if(charge.charges < chems_to_use)
		chems_to_use = charge.charges

	var/mob/living/carbon/target_mob
	if(target)
		if(istype(target,/mob/living/carbon))
			target_mob = target
		else
			return 0
	else
		target_mob = H

	if(target_mob != H)
		to_chat(H, "<span class='danger'>You inject [target_mob] with [chems_to_use] unit\s of [charge.display_name].</span>")
	to_chat(target_mob, "<span class='danger'>You feel a rushing in your veins as [chems_to_use] unit\s of [charge.display_name] [chems_to_use == 1 ? "is" : "are"] injected.</span>")
	target_mob.reagents.add_reagent(charge.display_name, chems_to_use)

	charge.charges -= chems_to_use
	if(charge.charges < 0) charge.charges = 0

	return 1

/obj/item/rig_module/basic/chem_dispenser/combat

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


/obj/item/rig_module/basic/chem_dispenser/injector

	name = "mounted chemical injector"
	desc = "A complex web of tubing and a large needle suitable for hardsuit use."
	usable = 0
	selectable = 1

	interface_name = "mounted chem injector"
	interface_desc = "Dispenses loaded chemicals via an arm-mounted injector."

/obj/item/rig_module/basic/chem_dispenser/injector/advanced

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

/obj/item/rig_module/basic/maneuvering_jets

	name = "hardsuit maneuvering jets"
	desc = "A compact gas thruster system for a hardsuit."
	icon_state = "thrusters"
	usable = 1
	toggleable = 1
	selectable = 0

	suit_overlay_active = "maneuvering_active"
	suit_overlay_inactive = null //"maneuvering_inactive"

	engage_string = "Toggle Stabilizers"
	activate_string = "Activate Thrusters"
	deactivate_string = "Deactivate Thrusters"

	interface_name = "maneuvering jets"
	interface_desc = "An inbuilt EVA maneuvering system that runs off the hardsuit air supply."

	var/obj/item/tank/jetpack/hardsuit/jets

/obj/item/rig_module/basic/maneuvering_jets/engage()
	if(!..())
		return 0
	jets.toggle_rockets()
	return 1

/obj/item/rig_module/basic/maneuvering_jets/activate()

	if(active)
		return 0

	active = 1

	spawn(1)
		if(suit_overlay_active)
			suit_overlay = suit_overlay_active
		else
			suit_overlay = null
		holder.update_icon()

	if(!jets.on)
		jets.toggle()
	return 1

/obj/item/rig_module/basic/maneuvering_jets/deactivate()
	if(!..())
		return 0
	if(jets.on)
		jets.toggle()
	return 1

/obj/item/rig_module/basic/maneuvering_jets/Initialize(mapload)
	. = ..()
	jets = new(src)

/obj/item/rig_module/basic/maneuvering_jets/installed()
	..()
	jets.holder = holder
	jets.ion_trail.set_up(holder)

/obj/item/rig_module/basic/maneuvering_jets/removed()
	..()
	jets.holder = null
	jets.ion_trail.set_up(jets)

/obj/item/rig_module/basic/device/hand_defib
	name = "\improper Hand-mounted Defibrillator"
	desc = "Following complaints regarding the danger of switching equipment in the field, Vey-Med developed internalised defibrillator paddles mounted in the gauntlets of the rescue suit powered by the suit's cell."

	use_power_cost = 50

	interface_name = "Hand-mounted Defbrillators"
	interface_desc = "Following complaints regarding the danger of switching equipment in the field, Vey-Med developed internalised defibrillator paddles mounted in the gauntlets of the rescue suit powered by the suit's cell."

	device_type = /obj/item/shockpaddles/standalone/hardsuit
