/obj/vehicle/sealed/mecha/combat/fighter
	name = "Delete me, nerd!!"
	desc = "The base type of fightercraft. Don't spawn this one!"

	var/datum/effect_system/ion_trail_follow/ion_trail
	var/landing_gear_raised = FALSE //If our anti-space-drift is on
	var/ground_capable = FALSE //If we can fly over normal turfs and not just space

	icon = 'icons/mecha/fighters64x64.dmi' //See ATTRIBUTIONS.md for details on license

	icon_state = ""
	initial_icon = ""

	dir_in = null //Don't reset direction when empty

	step_in = 2 //Fast

	integrity = 400
	integrity_max = 400

	infra_luminosity = 6

	opacity = FALSE

	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	stomp_sound = 'sound/mecha/fighter/engine_mid_fighter_move.ogg'
	swivel_sound = 'sound/mecha/fighter/engine_mid_boost_01.ogg'

	bound_height = 64
	bound_width = 64

	max_hull_equip = 2
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 1
	max_special_equip = 1

	starting_components = list(
		/obj/item/vehicle_component/hull/lightweight,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)

	var/in_gravity_damage = 20

/obj/vehicle/sealed/mecha/combat/fighter/Initialize(mapload)
	. = ..()
	ion_trail = new /datum/effect_system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.stop()

/obj/vehicle/sealed/mecha/combat/fighter/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000

/obj/vehicle/sealed/mecha/combat/fighter/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	consider_gravity()

/obj/vehicle/sealed/mecha/combat/fighter/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	consider_gravity()

//Modified phazon code
/obj/vehicle/sealed/mecha/combat/fighter/Topic(href, href_list)
	..()
	if (href_list["toggle_landing_gear"])
		landing_gear_raised = !landing_gear_raised
		send_byjax(src.occupant_legacy,"exosuit.browser","landing_gear_command","[landing_gear_raised?"Lower":"Raise"] landing gear")
		src.occupant_message("<span class='notice'>Landing gear [landing_gear_raised? "raised" : "lowered"].</span>")
		return

/obj/vehicle/sealed/mecha/combat/fighter/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_landing_gear=1'><span id="landing_gear_command">[landing_gear_raised?"Raise":"Lower"] landing gear</span></a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/vehicle/sealed/mecha/combat/fighter/can_ztravel()
	return (landing_gear_raised && has_charge(step_energy_drain))

// No space drifting
// This doesnt work but I actually dont want it to anyways, so I'm not touching it at all. Space drifting is cool.
/obj/vehicle/sealed/mecha/combat/fighter/check_for_support()
	if (landing_gear_raised)
		return 1

	return ..()

// No falling if we've got our boosters on
/obj/vehicle/sealed/mecha/combat/fighter/can_fall()
	if(landing_gear_raised && has_charge(step_energy_drain))
		return FALSE
	else
		return TRUE


/obj/vehicle/sealed/mecha/combat/fighter/proc/consider_gravity(var/moved = FALSE)
	var/gravity = has_gravity()
	if (gravity && !landing_gear_raised)
		playsound(src, 'sound/effects/roll.ogg', 50, 1)
	else if(gravity && ground_capable && occupant_legacy)
		start_hover()
	else if((!gravity && ground_capable) || !occupant_legacy)
		stop_hover()
	else if(moved && gravity && !ground_capable)
		occupant_message("Collision alert! Vehicle not rated for use in gravity!")
		take_damage_legacy(in_gravity_damage, "brute")
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)

/obj/vehicle/sealed/mecha/combat/fighter/get_step_delay()
    . = ..()
    if(has_gravity() && !landing_gear_raised)
        . += 4

/obj/vehicle/sealed/mecha/combat/fighter/handle_equipment_movement()
	. = ..()
	consider_gravity(TRUE)

/obj/vehicle/sealed/mecha/combat/fighter/proc/start_hover()
	if(!ion_trail.on) //We'll just use this to store if we're floating or not
		ion_trail.start()
		var/amplitude = 2 //maximum displacement from original position
		var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

		var/top = get_standard_pixel_y_offset() + amplitude
		var/bottom = get_standard_pixel_y_offset() - amplitude
		var/half_period = period / 2
		var/quarter_period = period / 4

		animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
		animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
		animate(pixel_y = get_standard_pixel_y_offset(), time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/obj/vehicle/sealed/mecha/combat/fighter/proc/stop_hover()
	if(ion_trail.on)
		ion_trail.stop()
		animate(src, pixel_y = get_standard_pixel_y_offset(), time = 5, easing = SINE_EASING | EASE_IN) //halt animation

/obj/vehicle/sealed/mecha/combat/fighter/check_for_support()
	if (has_charge(step_energy_drain) && landing_gear_raised)
		return 1

	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille) in things || locate(/obj/structure/lattice) in things || locate(/turf/simulated) in things || locate(/turf/unsimulated) in things)
		return 1
	else
		return 0


/obj/vehicle/sealed/mecha/combat/fighter/play_entered_noise(var/mob/who)
	if(hasInternalDamage())
		who << sound('sound/mecha/fighter_entered_bad.ogg',volume=50)
	else
		who << sound('sound/mecha/fighter_entered.ogg',volume=50)

//causes damage when running into objects
/obj/vehicle/sealed/mecha/combat/fighter/Bump(atom/obstacle)
	. = ..()
	// this isn't defined becuase this is shitcode anyways and i'm just patching it
	// todo: why the fuck are you guys doing snowflake collision code??
	if(TIMER_COOLDOWN_CHECK(src, "fighter_collision"))
		return
	if(istype(obstacle, /obj) || istype(obstacle, /turf))
		TIMER_COOLDOWN_START(src, "fighter_collision", 5 SECONDS)
		occupant_message("<B><FONT COLOR=red SIZE=+1>Collision Alert!</B></FONT>")
		take_damage_legacy(20, "brute")
		playsound(src, 'sound/effects/grillehit.ogg', 50, 1)

////////////// Gunpod //////////////

/obj/vehicle/sealed/mecha/combat/fighter/gunpod
	name = "\improper Gunpod"
	desc = "Small mounted weapons platform capable of space and surface combat. More like a flying tank than a dedicated fightercraft."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "gunpod"
	initial_icon = "gunpod"

	catalogue_data = list(/datum/category_item/catalogue/technology/gunpod)
	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	step_in = 3 //Slightly slower than others

	ground_capable = TRUE

	// Paint colors! Null if not set.
	var/stripe1_color
	var/stripe2_color
	var/image/stripe1_overlay
	var/image/stripe2_overlay

/obj/vehicle/sealed/mecha/combat/fighter/gunpod/loaded/Initialize(mapload) //Loaded version with guns
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/vehicle_module/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/vehicle/sealed/mecha/combat/fighter/gunpod/recon
	name = "\improper Reconnaissance Gunpod"
	desc = "Small mounted weapons platform capable of space and surface combat. More like a flying tank than a dedicated fightercraft. This stripped down model is used for long range reconnaissance ."

/obj/vehicle/sealed/mecha/combat/fighter/gunpod/recon/Initialize(mapload) //Blinky
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/vehicle_module/tesla_energy_relay(src)
	ME.attach(src)

/obj/vehicle/sealed/mecha/combat/fighter/gunpod/update_icon()
	cut_overlays()
	..()

	if(stripe1_color)
		stripe1_overlay = image("gunpod_stripes1")
		stripe1_overlay.color = stripe1_color
		add_overlay(stripe1_overlay)
	if(stripe2_color)
		stripe2_overlay = image("gunpod_stripes2")
		stripe2_overlay.color = stripe2_color
		add_overlay(stripe2_overlay)

/obj/vehicle/sealed/mecha/combat/fighter/gunpod/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/multitool) && state == 1)
		var/new_paint_location = input("Please select a target zone.", "Paint Zone", null) as null|anything in list("Fore Stripe", "Aft Stripe", "CANCEL")
		if(new_paint_location && new_paint_location != "CANCEL")
			var/new_paint_color = input("Please select a paint color.", "Paint Color", null) as color|null
			if(new_paint_color)
				switch(new_paint_location)
					if("Fore Stripe")
						stripe1_color = new_paint_color
					if("Aft Stripe")
						stripe2_color = new_paint_color

		update_icon()
	else ..()

/obj/effect/decal/mecha_wreckage/gunpod
	name = "Gunpod wreckage"
	desc = "Remains of some unfortunate gunpod. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "gunpod-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/gunpod
	name = "Voidcraft - Gunpod"
	desc = "This is a small space-capable fightercraft that has an arrowhead design. Can hold up to one pilot, \
	and sometimes one or two passengers, with the right modifications made. \
	Typically used as small fighter craft, the gunpod can't carry much of a payload, though it's still capable of holding it's own."
	value = CATALOGUER_REWARD_MEDIUM
