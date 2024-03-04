/obj/item/computer_hardware
	name = "Hardware"
	desc = "Unknown Hardware."
	icon = 'icons/obj/modular_components.dmi'

	w_class = WEIGHT_CLASS_TINY // w_class limits which devices can contain this component.
	// 1: PDAs/Tablets, 2: Laptops, 3-4: Consoles only
	var/obj/item/modular_computer/holder = null

	/// If the hardware uses extra power, change this.
	var/power_usage = 0
	/// If the hardware is turned off set this to 0.
	var/enabled = TRUE
	/// Prevent disabling for important component, like the CPU.
	var/critical = FALSE
	/// Prevents direct installation of removable media.
	var/can_install = TRUE
	/// Hardware that fits into expansion bays.
	var/expansion_hw = FALSE
	/// Whether the hardware is removable or not.
	var/removable = TRUE
	/// Current damage level
	var/damage = 0
	/// Maximal damage level.
	var/max_damage = 100
	/// "Malfunction" threshold. When damage exceeds this value the hardware piece will semi-randomly fail and do !!FUN!! things
	var/damage_malfunction = 20
	/// "Failure" threshold. When damage exceeds this value the hardware piece will not work at all.
	var/damage_failure = 50
	/// Chance of malfunction when the component is damaged
	var/malfunction_probability = 10
	/// What define is used to qualify this piece of hardware? Important for upgraded versions of the same hardware.
	var/device_type

/obj/item/computer_hardware/New(obj/L)
	..()
	pixel_x = initial(pixel_x) + rand(-8, 8)
	pixel_y = initial(pixel_y) + rand(-8, 8)

/obj/item/computer_hardware/Destroy()
	if(holder)
		holder.uninstall_component(src)
	return ..()

/obj/item/computer_hardware/attackby(obj/item/I, mob/living/user)
	// Multitool. Runs diagnostics
	if(istype(I, /obj/item/multitool))
		to_chat(user, "***** DIAGNOSTICS REPORT *****")
		diagnostics(user)
		to_chat(user, "******************************")
		return TRUE
	// Nanopaste. Repair all damage if present for a single unit.
	if(istype(I, /obj/item/stack/nanopaste))
		var/obj/item/stack/S = I
		if(!damage)
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to require repairs."))
			return TRUE
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You apply a bit of \the [I] to \the [src]. It immediately repairs all damage."))
			damage = 0
		return TRUE
	// Cable coil. Works as repair method, but will probably require multiple applications and more cable.
	if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/S = I
		if(!damage)
			to_chat(user, SPAN_WARNING("\The [src] doesn't seem to require repairs."))
			return TRUE
		if(S.use(1))
			to_chat(user, SPAN_NOTICE("You patch up \the [src] with a bit of \the [I]."))
			take_damage_legacy(-10)
		return TRUE
	return ..()

/// Called on multitool click, prints diagnostic information to the user.
/obj/item/computer_hardware/proc/diagnostics(mob/user)
	to_chat(user, "Hardware Integrity Test... (Corruption: [damage]/[max_damage]) [damage > damage_failure ? "FAIL" : damage > damage_malfunction ? "WARN" : "PASS"]")

/// Handles damage checks.
/obj/item/computer_hardware/proc/check_functionality()
	// Turned off
	if(!enabled)
		return FALSE
	// Too damaged to work at all.
	if(damage > damage_failure)
		return FALSE
	// Still working. Well, sometimes...
	if(damage > damage_malfunction)
		if(prob(malfunction_probability))
			return FALSE
	// Good to go.
	return TRUE

/obj/item/computer_hardware/examine(mob/user, dist)
	. = ..()
	if(damage > damage_failure)
		. += SPAN_DANGER("It seems to be severely damaged!")
	else if(damage > damage_malfunction)
		. += SPAN_WARNING("It seems to be damaged!")
	else if(damage)
		. += SPAN_NOTICE("It seems to be slightly damaged.")

// Component-side compatibility check.
/obj/item/computer_hardware/proc/can_install(obj/item/modular_computer/M, mob/living/user = null)
	return can_install

// Called when component is installed into PC.
/obj/item/computer_hardware/proc/on_install(obj/item/modular_computer/M, mob/living/user = null)
	return

// Called when component is removed from PC.
/obj/item/computer_hardware/proc/on_remove(obj/item/modular_computer/M, mob/living/user)
	if(M.physical || !QDELETED(M))
		try_eject(forced = TRUE)

// Called when someone tries to insert something in it - paper in printer, card in card reader, etc.
/obj/item/computer_hardware/proc/try_insert(obj/item/I, mob/living/user = null)
	return FALSE

/**
 * Implement this when your hardware contains an object that the user can eject.
 *
 * Examples include ejecting cells from battery modules, ejecting an ID card from a card reader
 * or ejecting an Intellicard from an AI card slot.
 * Arguments:
 * * user - The mob requesting the eject.
 * * forced - Whether this action should be forced in some way.
 */
/obj/item/computer_hardware/proc/try_eject(mob/living/user = null, forced = FALSE)
	return FALSE

// modern tg uses obj_integrity; this is a wrapper for old dmg
// to heal use negative damage
/obj/item/computer_hardware/proc/take_damage_legacy(amount)
	damage += round(amount) // We want nice rounded numbers here.
	damage = clamp(damage, 0,  max_damage) // Clamp the value.
