/obj/vehicle/sealed/mecha/working/hoverpod
	name = "Hover Pod"
	desc = "Stubby and round, this space-capable craft is an ancient favorite."
	description_fluff = {"
		This small space-capable craft can accomodate one pilot and up to two passengers, depending on its equipment.
		The Hoverpod's trademark round design and bright white coloration are easily recognizable to spacefarers.
		The design has been in use for nearly two centuries, and has remained largely consistent.
		Developed to address short ranged transport of crew and cargo in EVA, the Hoverpod is a niche vehicle.
		Due to its reduced size and maneuverability, the Hoverpod saw frequent use in situations where a shuttle was deemed too cumbersome.
		Thanks to their ability to enter airlocks, Hoverpods have acted as a bridge between EVA in space suits and travelling within proper spacecraft.
		In recent times, however, the Hoverpod has begun to show its age.
		Newer solutions that address the same niche have begun to come to the forefront.
		In spite of this, the Hoverpod remains a cheap and reliable favorite across the Frontier.
	"}
	catalogue_data = list(/datum/category_item/catalogue/technology/hoverpod)
	icon_state = "engineering_pod"
	initial_icon = "engineering_pod"
	internal_damage_threshold = 80

	base_movement_speed = 4

	max_temperature = 20000
	integrity = 150
	integrity_max = 150
	wreckage = /obj/effect/decal/mecha_wreckage/hoverpod
	cargo_capacity = 5
	var/datum/effect_system/ion_trail_follow/ion_trail
	var/stabilization_enabled = 1

	move_sound = 'sound/machines/hiss.ogg'
	turn_sound = null

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_WEAPON = 0,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
	)

/obj/vehicle/sealed/mecha/working/hoverpod/Initialize(mapload)
	. = ..()
	ion_trail = new /datum/effect_system/ion_trail_follow()
	ion_trail.set_up(src)

/obj/vehicle/sealed/mecha/working/hoverpod/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	ion_trail.start()

/obj/vehicle/sealed/mecha/working/hoverpod/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	if(!length(occupants))
		ion_trail.stop()

//Modified phazon code
/obj/vehicle/sealed/mecha/working/hoverpod/Topic(href, href_list)
	..()
	if (href_list["toggle_stabilization"])
		stabilization_enabled = !stabilization_enabled
		send_byjax(src.occupant_legacy,"exosuit.browser","stabilization_command","[stabilization_enabled?"Dis":"En"]able thruster stabilization")
		src.occupant_message("<span class='notice'>Thruster stabilization [stabilization_enabled? "enabled" : "disabled"].</span>")
		return

/obj/vehicle/sealed/mecha/working/hoverpod/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_stabilization=1'><span id="stabilization_command">[stabilization_enabled?"Dis":"En"]able thruster stabilization</span></a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/vehicle/sealed/mecha/working/hoverpod/can_ztravel()
	return (stabilization_enabled && has_charge(step_energy_drain))

// No space drifting
/obj/vehicle/sealed/mecha/working/hoverpod/check_for_support()
	//does the hoverpod have enough charge left to stabilize itself?
	if (!has_charge(step_energy_drain))
		ion_trail.stop()
	else
		if (!ion_trail.on)
			ion_trail.start()
		if (stabilization_enabled)
			return 1

	return ..()

// No falling if we've got our boosters on
/obj/vehicle/sealed/mecha/working/hoverpod/can_fall()
	if(stabilization_enabled && has_charge(step_energy_drain))
		return FALSE
	else
		return TRUE

//Hoverpod variants
/obj/vehicle/sealed/mecha/working/hoverpod/combatpod
	desc = "An ancient, run-down combat spacecraft." // Ideally would have a seperate icon.
	name = "Combat Hoverpod"
	integrity = 200
	integrity_max = 200
	internal_damage_threshold = 35
	cargo_capacity = 2

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
	)

#warn /equipped
/obj/vehicle/sealed/mecha/working/hoverpod/combatpod/Initialize(mapload)
	. = ..()
	var/obj/item/vehicle_module/lazy/legacy/ME = new /obj/item/vehicle_module/lazy/legacy/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/vehicle/sealed/mecha/working/hoverpod/shuttlepod
	desc = "Who knew a tiny ball could fit three people?"
	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/tool/passenger,
		/obj/item/vehicle_module/lazy/legacy/tool/passenger,
	)

/obj/vehicle/sealed/mecha/working/hoverpod/shuttlecraft
	desc = "A more advanced variant of the hoverpod."
	name = "Shuttle"
	icon = 'icons/mecha/mecha64x64.dmi'
	icon_state = "shuttle_standard"
	initial_icon = "shuttle_standard"
	internal_damage_threshold = 60

	max_temperature = 20000
	integrity = 300
	integrity_max = 300
	wreckage = /obj/effect/decal/mecha_wreckage/shuttlecraft
	cargo_capacity = 3

	opacity = FALSE

	move_sound = 'sound/machines/generator/generator_end.ogg'
	turn_sound = 'sound/machines/hiss.ogg'

	// Paint colors! Null if not set.
	var/base_paint
	var/engine_paint
	var/central_paint
	var/front_paint

	var/image/base_paint_mask
	var/image/engine_paint_mask
	var/image/central_paint_mask
	var/image/front_paint_mask

	bound_height = 64
	bound_width = 64

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 1,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

/obj/vehicle/sealed/mecha/working/hoverpod/shuttlecraft/update_icon()
	cut_overlays()
	..()

	if(base_paint)
		if(!base_paint_mask)
			base_paint_mask = image(icon, "[initial_icon]-mask+base", src.layer + 1)
		base_paint_mask.color = base_paint
		add_overlay(base_paint_mask)
	if(front_paint)
		if(!front_paint_mask)
			front_paint_mask = image(icon, "[initial_icon]-mask+front", src.layer + 1)
		front_paint_mask.color = front_paint
		add_overlay(front_paint_mask)
	if(engine_paint)
		if(!engine_paint_mask)
			engine_paint_mask = image(icon, "[initial_icon]-mask+engine", src.layer + 1)
		engine_paint_mask.color = engine_paint
		add_overlay(engine_paint_mask)
	if(central_paint)
		if(!engine_paint_mask)
			central_paint_mask = image(icon, "[initial_icon]-mask+central", src.layer + 2)
		central_paint_mask.color = central_paint
		add_overlay(central_paint_mask)

/obj/vehicle/sealed/mecha/working/hoverpod/shuttlecraft/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool) && state == 1)
		var/new_paint_location = input("Please select a target zone.", "Paint Zone", null) as null|anything in list("Central", "Engine", "Base", "Front", "CANCEL")
		if(new_paint_location && new_paint_location != "CANCEL")
			var/new_paint_color = input("Please select a paint color.", "Paint Color", null) as color|null
			if(new_paint_color)
				switch(new_paint_location)
					if("Central")
						central_paint = new_paint_color
					if("Engine")
						engine_paint = new_paint_color
					if("Front")
						front_paint = new_paint_color
					if("Base")
						base_paint = new_paint_color
		update_icon()
	else ..()
