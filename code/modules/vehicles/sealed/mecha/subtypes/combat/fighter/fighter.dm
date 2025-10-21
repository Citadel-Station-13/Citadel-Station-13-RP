/obj/vehicle/sealed/mecha/combat/fighter
	name = "Delete me, nerd!!"
	desc = "The base type of fightercraft. Don't spawn this one!"

	base_movement_speed = 5
	comp_hull = /obj/item/vehicle_component/plating/hull/lightweight

	var/datum/effect_system/ion_trail_follow/ion_trail
	var/landing_gear_raised = FALSE //If our anti-space-drift is on
	var/ground_capable = FALSE //If we can fly over normal turfs and not just space

	icon = 'icons/mecha/fighters64x64.dmi' //See ATTRIBUTIONS.md for details on license

	icon_state = ""
	initial_icon = ""

	dir_in = null //Don't reset direction when empty

	integrity = 300
	integrity_max = 300
	comp_armor_relative_thickness = 1.25
	comp_hull_relative_thickness = 1.25
	opacity = FALSE

	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	stomp_sound = 'sound/mecha/fighter/engine_mid_fighter_move.ogg'
	swivel_sound = 'sound/mecha/fighter/engine_mid_boost_01.ogg'

	bound_height = 64
	bound_width = 64

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_UNIVERSAL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
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

