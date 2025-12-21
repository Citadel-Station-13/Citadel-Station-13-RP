/**
 * Just a supertype for power cell designs
 */
/datum/prototype/design/generated/power_cell
	category = DESIGN_CATEGORY_POWER

/**
 * Power storage cells
 */
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

	/**
	 * Materials base is intentionally nulled by default on /cell.
	 *
	 * This will invoke type generation. If this is set by a mapper or varedit, it will ignore
	 * typegen.
	 */
	materials_base = null

	//* -- Set by type generation -- *//

	/// should we run typegen from the power cell datum we're provided?
	/// * This is statically set by the power cell type generation defines.
	/// * This should never be modified after Initialize() runs.
	var/tmp/typegen_active = FALSE
	var/tmp/typegen_material_multiplier = 1

	//* Behavior *//
	/// Power cell prototype. Fetched at init.
	/// * This is nullable! If this is null, we don't perform typegen.
	var/datum/prototype/power_cell/cell_datum
	/// what cell types we are
	var/cell_type = NONE

	//* Charge *//
	/// current charge
	var/charge
	/// maximum charge
	/// * also used as a base for type generation
	var/max_charge = POWER_CELL_CAPACITY_BASE
	/// last time power was drawn from us
	var/last_use

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
	var/rating = 1

/obj/item/cell/Initialize(mapload)
	cell_datum = RSpower_cells.fetch_local_or_throw(cell_datum)
	if(typegen_active)
		// Typegen is active, run type generation stuff.
		// This will trample all map edits. If you're editing a map, you shouldn't be editing power cells.
		// Or if you are, you should null out their cell datum.
		if(isnull(materials_base) && cell_datum.typegen_materials_base)
			if(has_typelist(NAMEOF(src, materials_base)))
				materials_base = get_typelist(NAMEOF(src, materials_base))
			else
				// This will **trample** the materials_base check in /obj initialization, so we have to the
				// entire cycle.
				var/list/generating_materials = cell_datum.typegen_materials_base.Copy()
				if(typegen_material_multiplier != 1)
					for(var/key in generating_materials)
						generating_materials[key] *= typegen_material_multiplier
				for(var/key in cell_datum.typegen_materials_base_adjust)
					generating_materials[key] += cell_datum.typegen_materials_base_adjust[key]
				generating_materials = SSmaterials.preprocess_kv_keys_to_ids(generating_materials)
				materials_base = typelist(NAMEOF(src, materials_base), generating_materials)
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
		. += "It has a power rating of [max_charge].\nThe charge meter reads [round(src.percent() )]%."

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

/obj/item/cell/proc/give(amount, force)
	// LEGACY - explosion?
	if(rigged && amount > 0)
		explode()
		return FALSE
	// END
	if(force)
		. = amount
	else
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
	return ..()

//* Setters *//

/obj/item/cell/proc/set_charge(amount, update)
	charge = clamp(amount, 0, max_charge)
	if(update)
		update_icon()
