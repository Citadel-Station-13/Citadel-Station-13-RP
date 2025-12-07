//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/armor/vehicle_module/personal_shield_routing
	melee_soak = 5
	bullet_soak = 15
	laser_soak = 15
	melee_deflect = 10
	bullet_deflect = 10
	laser_deflect = 10

/**
 * * DO NOT USE RAW TYPE NAKED; A VISUAL MUST BE PROVIDED
 */
/obj/item/vehicle_module/personal_shield
	name = "vehicle shield module"
	desc = "Some kind of shielding module."

	#warn equip slot to hull

	/// armor used to check for damage routing to self
	/// * any damage this armor 'blocks' will be routed to the shield layer instead
	var/datum/armor/routing_armor
	var/routing_armor_type

	/// active ?
	var/active = FALSE

	/// charge
	/// * default scaling is 1 point of damage for 1 charge
	var/charge = 0
	/// max charge
	var/charge_max = 150
	/// watts to maintain charge per 1
	var/charge_maintain_cost_per_unit = 7
	/// joules to recharge 1 charge
	var/charge_regen_cost_per_unit = 35
	/// charge gain rate
	var/charge_regen_rate = 10
	/// do not lose charge when deactivated
	var/charge_held_while_deactivated = FALSE
	/// speed of regen per second while deactivated; doesn't take energy to do so
	var/charge_regen_rate_free_deactivated = 0

	/// shielding arc degrees CW of **FRONT**
	var/shielded_arc_center_cw_of_front = 0
	/// shielding arc degrees left/right of center
	/// * This rounds down for melee.
	var/shielded_arc_degrees_from_center = 180

	var/works_on_melee = TRUE

#warn impl

/obj/item/vehicle_module/personal_shield/proc/fetch_routing_armor() as /datum/armor

/obj/item/vehicle_module/personal_shield/proc/process_vehicle_damage_instance(SHIELDCALL_PROC_HEADER)

/**
 * @return points absorbed
 */
/obj/item/vehicle_module/personal_shield/proc/take_routed_damage(damage) as num

/obj/item/vehicle_module/personal_shield/proc/on_take_routed_damage(amount)

/**
 * replaces rw/ccw armor boosters
 */
/obj/item/vehicle_module/personal_shield/structural_field
	name = /obj/item/vehicle_module/personal_shield::name + " (structural field)"
	name = "structural field projector"
	desc = "Projects a field that dampens incoming attacks, albeit imperfectly."
	#warn set routing armor

	disallow_duplicates = TRUE
	disallow_duplicates_match_type = /obj/item/vehicle_module/personal_shield/structural_field

	works_on_melee = TRUE

/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic
	name = "exterior damping field (ranged)"

/obj/item/vehicle_module/personal_shield/structural_field/concussive
	name = "exterior damping field (melee)"

/datum/armor/vehicle_module/personal_shield_routing/deflector
	melee_soak = 5
	bullet_soak = 20
	laser_soak = 30
	melee_deflect = 25
	bullet_deflect = 25
	laser_deflect = 25

/**
 * blame tg i don't even like evangelion
 * * can deflect most simple hits below a certain amount of damage entirely, but bad against melee
 * * adminspawn only; durand gets a version that freezes them while active
 * * technically this type's function is to just flick a graphic on hit
 */
/obj/item/vehicle_module/personal_shield/deflector
	name = /obj/item/vehicle_module/personal_shield::name + " (deflector network)"
	desc = "A set of specialized shield projectors that can entirely soak an incoming attack."
	routing_armor_type = /datum/armor/vehicle_module/personal_shield_routing/deflector
	charge_max = 200
	charge_maintain_cost_per_unit = 20 //! ~2 units/tick to maintain while active
	charge_regen_cost_per_unit = 160 //! very very energy intensive
	charge_regen_rate = 20 //! can absorb a laser hit every 2 seconds
	charge_regen_rate_free_deactivated = 5
	charge_held_while_deactivated = TRUE
	works_on_melee = FALSE

	/// last vfx check
	var/vfx_last_check
	/// running vfx average
	var/vfx_avg_rate = 0
	/// max average flick rate per second
	var/vfx_avg_flick_limit = 6.5

/obj/item/vehicle_module/personal_shield/deflector/proc/on_take_routed_damage(amount)
	. = ..()
	if(. <= 1)
		return
	flick_vfx_if_possible()

/obj/item/vehicle_module/personal_shield/deflector/proc/flick_vfx_if_possible()
	if(!vehicle)
		return FALSE
	var/elapsed_since_last = world.time - vfx_last_check
	vfx_last_check = world.time
	// this isn't a real average but i don't care lol
	vfx_avg_rate /= (10 + elapsed_since_last) * 0.1
	if(vfx_avg_rate > vfx_avg_flick_limit)
		return FALSE
	vfx_avg_rate++
	flick_vfx()

/obj/item/vehicle_module/personal_shield/deflector/proc/flick_vfx()
	#warn impl

/obj/item/vehicle_module/personal_shield/deflector/durand
	shielded_arc_degrees_from_center = 60 //! covers frontal and front left/right's
	charge_maintain_cost_per_unit = 80 //! ~8 units/tick to maintain while active
	charge_regen_cost_per_unit = 1000 //! ~0.5 cell units per point of damage

#warn duran'ds should immobilize or near immobilze it
