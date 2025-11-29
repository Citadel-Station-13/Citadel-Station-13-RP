/datum/armor/vehicle/mecha/fighter
	melee = 0.3
	melee_tier = 4
	melee_deflect = 5
	bullet = 0.3
	bullet_tier = 4
	bullet_deflect = 2.5
	laser = 0.3
	laser_tier = 4
	laser_deflect = 2.5
	energy = 0.2
	bomb = 0.35

/obj/vehicle/sealed/mecha/fighter
	name = "Delete me, nerd!!"
	desc = "The base type of fightercraft. Don't spawn this one!"
	opacity = FALSE
	//See ATTRIBUTIONS.md for details on license
	icon = 'icons/mecha/fighters64x64.dmi'

	icon_state = ""
	initial_icon = ""

	dir_in = null //Don't reset direction when empty

	armor_type = /datum/armor/vehicle/mecha/fighter
	integrity = 1.5 * /obj/vehicle/sealed/mecha::integrity
	integrity_max = 1.5 * /obj/vehicle/sealed/mecha::integrity_max
	base_movement_speed = 5

	comp_armor_relative_thickness = 1.25
	comp_hull = /obj/item/vehicle_component/plating/mecha_hull/lightweight
	comp_hull_relative_thickness = 1.25

	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	move_sound = 'sound/mecha/fighter/engine_mid_fighter_move.ogg'
	turn_sound = 'sound/mecha/fighter/engine_mid_boost_01.ogg'

	bound_height = 64
	bound_width = 64

	module_slots = list(
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
	)

	/// fighters don't have hands we're not actually at the gundam phase of mech implementation yet
	melee_attacks = null

	/// We're FLYYYYING
	var/flight_mode = FALSE
	/// Can fly in gravity
	var/flight_works_in_gravity = TRUE
	/// base speed on ground
	var/ground_base_movement_speed = 2
	/// Flight mode energy cost in joules per second
	var/flight_energy_cost = 500
	/// Flight mode can be kept on without an occupant
	var/flight_has_autopilot = FALSE

	/// legacy: ion trail when flying
	var/datum/effect_system/ion_trail_follow/ion_trail

/obj/vehicle/sealed/mecha/fighter/Initialize(mapload)
	. = ..()
	ion_trail = new /datum/effect_system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.stop()

/obj/vehicle/sealed/mecha/fighter/process(delta_time)
	..()
	if(flight_mode)
		if(flight_energy_cost)
			if(!draw_sourced_power_oneoff("thrusters", "thrusters", flight_energy_cost * delta_time))
				occupant_send_default_chat("Power lost to thrusters.")
				disable_flight(null, null, TRUE)

#warn autopilot
/obj/vehicle/sealed/mecha/fighter/occupant_added(mob/adding, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	consider_gravity()

/obj/vehicle/sealed/mecha/fighter/occupant_removed(mob/removing, datum/event_args/actor/actor, control_flags, silent)
	. = ..()
	consider_gravity()

/obj/vehicle/sealed/mecha/fighter/can_ztravel()
	return (landing_gear_raised && has_charge(step_energy_drain))

// No space drifting
// This doesnt work but I actually dont want it to anyways, so I'm not touching it at all. Space drifting is cool.
/obj/vehicle/sealed/mecha/fighter/check_for_support()
	if (landing_gear_raised)
		return 1
	return ..()

// No falling if we've got our boosters on
/obj/vehicle/sealed/mecha/fighter/can_fall()
	if(landing_gear_raised && has_charge(step_energy_drain))
		return FALSE
	else
		return TRUE

/obj/vehicle/sealed/mecha/fighter/proc/consider_gravity(var/moved = FALSE)
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

/obj/vehicle/sealed/mecha/fighter/get_step_delay()
    . = ..()
    if(has_gravity() && !landing_gear_raised)
        . += 4

/obj/vehicle/sealed/mecha/fighter/proc/start_hover()
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

/obj/vehicle/sealed/mecha/fighter/proc/stop_hover()
	if(ion_trail.on)
		ion_trail.stop()
		animate(src, pixel_y = get_standard_pixel_y_offset(), time = 5, easing = SINE_EASING | EASE_IN) //halt animation

/obj/vehicle/sealed/mecha/fighter/check_for_support()
	if (has_charge(step_energy_drain) && landing_gear_raised)
		return 1

	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille) in things || locate(/obj/structure/lattice) in things || locate(/turf/simulated) in things || locate(/turf/unsimulated) in things)
		return 1
	else
		return 0

/obj/vehicle/sealed/mecha/fighter/play_entered_noise(var/mob/who)
	if(hasInternalDamage())
		who << sound('sound/mecha/fighter_entered_bad.ogg',volume=50)
	else
		who << sound('sound/mecha/fighter_entered.ogg',volume=50)

/obj/vehicle/sealed/mecha/fighter/proc/user_enable_flight(datum/event_args/actor/actor, silent)
	#warn log this and that

/obj/vehicle/sealed/mecha/fighter/proc/user_disable_flight(datum/event_args/actor/actor, silent)

/obj/vehicle/sealed/mecha/fighter/proc/enable_flight(datum/event_args/actor/actor, silent)
	#warn impl

	var/datum/vehicle_ui_controller/mecha/fighter/ui_controller = src.ui_controller
	ui_controller?.update_ui_flight()

/**
 * @params
 * * actor
 * * silent
 * * involuntary - set to TRUE if running out of power, pilot ejecting without autopilot, etc
 */
/obj/vehicle/sealed/mecha/fighter/proc/disable_flight(datum/event_args/actor/actor, silent, involuntary)
	#warn impl

	var/datum/vehicle_ui_controller/mecha/fighter/ui_controller = src.ui_controller
	ui_controller?.update_ui_flight()
