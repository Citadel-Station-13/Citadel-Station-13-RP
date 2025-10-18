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
	name = "personal shield module"
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
	/// * by default, damage is linear; this actually makes the shield more powerful
	///   against high AP low damage things than the other way around!
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
	var/shielded_arc_degrees_from_center = 180

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
	name = "structural field projector"
	desc = "Projects a field that dampens incoming attacks, albeit imperfectly."
	#warn set routing armor

/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic
	name = "exterior damping field (ranged)"

/obj/item/vehicle_module/personal_shield/structural_field/concussive
	name = "exterior damping field (melee)"

/datum/armor/vehicle_module/personal_shield_routing/at_field
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
/obj/item/vehicle_module/personal_shield/at_field
	name = "deflector network"
	desc = "A set of specialized shield projectors that can entirely soak an incoming attack."
	routing_armor_type = /datum/armor/vehicle_module/personal_shield_routing/at_field
	charge_max = 200
	charge_maintain_cost_per_unit = 20 //! ~2 units/tick to maintain while active
	charge_regen_cost_per_unit = 160 //! very very energy intensive
	charge_regen_rate = 20 //! can absorb a laser hit every 2 seconds
	charge_regen_rate_free_deactivated = 5
	charge_held_while_deactivated = TRUE

	/// last flick
	var/vfx_last = 0
	/// max average flick rate
	/// * DO NOT SET THIS TO 0 UNDER ANY CIRCUMSTANCES IF YOU DO I WILL TURN YOU INTO PASTE AND NOT IN A FUN WAY
	var/vfx_avg_flick_limit = 0.15
	/// stacks of vfx on us
	var/vfx_stacks = 0
	/// max vfx stacks
	/// * DO NOT SET THIS TO A HIGH VALUE
	var/vfx_stack_limit = 7

/obj/item/vehicle_module/personal_shield/at_field/proc/on_take_routed_damage(amount)
	. = ..()
	if(. <= 1)
		return
	flick_vfx_if_possible()

/obj/item/vehicle_module/personal_shield/at_field/proc/flick_vfx_if_possible()
	if(!vehicle)
		return
	#warn impl

/obj/item/vehicle_module/personal_shield/at_field/durand
	shielded_arc_degrees_from_center = 66.66666 //! covers frontal and front left/right's
	charge_maintain_cost_per_unit = 80 //! ~8 units/tick to maintain while active
	charge_regen_cost_per_unit = 1000 //! ~0.5 cell units per point of damage
