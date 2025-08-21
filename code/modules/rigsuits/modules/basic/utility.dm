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
