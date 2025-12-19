// the power cell
// charge from 0 to 100%
// fits in APC to provide backup power

/obj/item/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = list(TECH_POWER = 1)
	damage_force = 5.0
	throw_force = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	suit_storage_class = SUIT_STORAGE_CLASS_SOFTWEAR | SUIT_STORAGE_CLASS_HARDWEAR

	armor_type = /datum/armor/object/light
	integrity = 200
	integrity_max = 200
	integrity_failure = 100

	//* -- Set by type generation -- *//

	/// should we run typegen from the power cell datum we're provided?
	///
	/// These things are affected, on the power cell datum side
	/// * typegen_capacity
	/// * typegen_material
	/// * typegen_visual
	/// * typegen_worth
	///
	/// The following things are statically set by the #define generator
	/// * indicator color
	/// * stripe color
	/// * charge capacity
	///
	/// The following things are set at init
	/// * materials
	///
	/// The following things are read at runtime
	/// * worth
	///
	/// This should never be modified after Initialize() runs.
	var/tmp/typegen_active = FALSE
	#warn we should set name and desc via macro too..

	//* Behavior *//
	/// cell data prototype; loaded at init, set to typepath or anonymous type
	var/datum/prototype/power_cell/cell_datum
	/// what cell types we are
	var/cell_type = NONE
	#warn this

	//* Charge *//
	/// current charge
	var/charge
	/// maximum charge
	/// * also used as a base for type generation
	var/max_charge = POWER_CELL_CAPACITY_BASE
	/// last time power was drawn from us
	var/last_use

	//* Configuration *//
	/// allow rechargers
	var/can_be_recharged = TRUE
	#warn impl

	//* Rendering *//
	/// perform default rendering
	var/rendering_system = FALSE
	/// total states; 0 to disable auto render
	var/indicator_count
	/// our indicator color
	var/indicator_color = "#00aa00"
	/// our stripe color; null for no stripe
	var/stripe_color

	//* Self Recharge *//
	/// do we self recharge?
	var/self_recharge = FALSE
	/// cell units to give, per second, if self-recharging
	var/self_recharge_amount = 50
	/// how long to wait until after the last use to start recharging
	var/self_recharge_delay = 0 SECONDS

	//* legacy below *//
	/// Are we EMP immune?
	var/emp_proof = FALSE
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/charge_delay = 0 // How long it takes for the cell to start recharging after last use
	var/rating = 1
	materials_base = list(MAT_STEEL = 700, MAT_GLASS = 50)

	// Overlay stuff.
	var/overlay_half_state = "cell-o1" // Overlay used when not fully charged but not empty.
	var/overlay_full_state = "cell-o2" // Overlay used when fully charged.

/obj/item/cell/Initialize(mapload)
	#warn cell datum; use it to do materials mod
	if(!isnull(typegen_material_modify) && !is_typelist(NAMEOF(src, materials_base), materials_base))
		if(has_typelist(NAMEOF(src, materials_base)))
			materials_base = get_typelist(NAMEOF(src, materials_base))
		else
			var/list/multiplied = materials_base.Copy()
			for(var/key in multiplied)
				multiplied[key] = multiplied[key] * typegen_material_modify
			materials_base = typelist(NAMEOF(src, materials_base), multiplied)
	. = ..()
	if(isnull(charge))
		charge = max_charge
	update_icon()
	if(self_recharge)
		START_PROCESSING(SSobj, src)

/obj/item/cell/Destroy()
	if(datum_flags & DF_ISPROCESSING)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/cell/get_worth(flags)
	. = ..()
	if(typegen_active)
		. *= cell_datum?.typegen_worth_multiplier

/obj/item/cell/get_rating()
	return rating

/obj/item/cell/get_cell(inducer)
	return src

/obj/item/cell/drain_energy(datum/actor, amount, flags)
	if(charge <= 0)
		return 0
	return use(DYNAMIC_KJ_TO_CELL_UNITS(amount)) * GLOB.cellrate

/obj/item/cell/can_drain_energy(datum/actor, flags)
	return TRUE

/obj/item/cell/examine(mob/user, dist)
	. = ..()
	if(get_dist(src, user) <= 1)
		. += " It has a power rating of [max_charge].\nThe charge meter reads [round(src.percent() )]%."
	if(max_charge < 30000)
		. += "[desc]\nThe manufacturer's label states this cell has a power rating of [max_charge], and that you should not swallow it.\nThe charge meter reads [round(src.percent() )]%."
	else
		. += "This power cell has an exciting chrome finish, as it is an uber-capacity cell type! It has a power rating of [max_charge]!\nThe charge meter reads [round(src.percent() )]%."

/obj/item/cell/attackby(obj/item/W, mob/user)
	..()
	if(istype(W, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = W
		to_chat(user, "You inject the solution into the power cell.")
		if(S.reagents.has_reagent("phoron", 5))
			rigged = 1
			log_admin("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a power cell with phoron, rigging it to explode.")
		S.reagents.clear_reagents()

/obj/item/cell/proc/explode()
	var/turf/T = get_turf(src.loc)
/*
 * 1000-cell	explosion(T, -1, 0, 1, 1)
 * 2500-cell	explosion(T, -1, 0, 1, 1)
 * 10000-cell	explosion(T, -1, 1, 3, 3)
 * 15000-cell	explosion(T, -1, 2, 4, 4)
 * */
	if (charge==0)
		return
	var/devastation_range = 0
	var/heavy_impact_range = round(sqrt(charge) / 60)
	var/light_impact_range = round(sqrt(charge) / 30)
	var/flash_range = light_impact_range
	if (light_impact_range==0)
		rigged = 0
		corrupt()
		return
	log_admin("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")
	message_admins("LOG: Rigged power cell explosion, last touched by [fingerprintslast]")
	explosion(T, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	qdel(src)

/obj/item/cell/proc/corrupt()
	charge /= 2
	max_charge /= 2
	if (prob(10))
		rigged = 1 //broken batteries are dangerous

/obj/item/cell/emp_act(severity)
	. = ..()
	if(emp_proof)
		return
	//remove this once emp changes on dev are merged in
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		severity *= R.cell_emp_mult
	charge -= charge / (severity + 1)
	if (charge < 0)
		charge = 0
	update_icon()

/obj/item/cell/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
			if (prob(50))
				corrupt()
		if(3.0)
			if (prob(25))
				qdel(src)
				return
			if (prob(25))
				corrupt()

/obj/item/cell/proc/get_electrocute_damage()
	//1kW = 5
	//10kW = 24
	//100kW = 45
	//250kW = 53
	//1MW = 66
	//10MW = 88
	//100MW = 110
	//1GW = 132
	if(charge >= 1000)
		var/damage = log(1.1,charge)
		damage = damage - (log(1.1,damage)*1.5)
		return round(damage)
	else
		return 0

//* Main *//

/obj/item/cell/proc/give(amount)
	// LEGACY - explosion?
	if(rigged && amount > 0)
		explode()
		return FALSE
	// END
	. = clamp(amount, 0, max_charge - charge)
	charge += .
	update_icon()

/obj/item/cell/proc/amount_missing()
	. = max(0, max_charge - charge)

/obj/item/cell/proc/fully_charged()
	return check_charge(max_charge)

/obj/item/cell/proc/check_charge(amount)
	return charge >= amount

/obj/item/cell/proc/checked_use(amount, reserve)
	if(!check_charge(amount + reserve))
		return 0
	return use(amount)

/obj/item/cell/proc/use(amount)
	// LEGACY - explosion?
	if(rigged && amount > 0)
		explode()
		return 0
	// END
	. = min(charge, amount)
	charge -= .
	last_use = world.time
	update_icon()

//* Calculations *//

/**
 * Returns percent remaining, [0, 100]
 */
/obj/item/cell/proc/percent()
	return max_charge ? (100 * charge / max_charge) : 0

/**
 * Returns ratio remaining, [0, 1]
 */
/obj/item/cell/proc/ratio()
	return max_charge ? (charge / max_charge) : 0

//* Processing *//

/obj/item/cell/process(delta_time)
	if(!self_recharge)
		return PROCESS_KILL
	if(world.time < last_use + self_recharge_delay)
		return
	give(self_recharge_amount * delta_time)

//* Rendering *//

/obj/item/cell/update_icon()
	if(rendering_system)
		cut_overlays()

		if(stripe_color)
			var/image/stripe = image(icon, "cell-stripe")
			stripe.color = stripe_color
			add_overlay(stripe)

		if(indicator_count)
			var/image/indicator = image(icon, "cell-[charge <= 1? "empty" : "[ceil(charge / max_charge * 5)]"]")
			indicator.color = indicator_color
			add_overlay(indicator)
	else
		//! LEGACY CODE !//
		cut_overlays()
		if(charge < 0.01) // Empty.
		else if(charge/max_charge >= 0.995) // Full
			add_overlay(overlay_full_state)
		else // Inbetween.
			add_overlay(overlay_half_state)
		//! END !//
	return ..()

//* Setters *//

/obj/item/cell/proc/set_charge(amount, update)
	charge = clamp(amount, 0, max_charge)
	if(update)
		update_icon()
