/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/debugger
	name = "debugger"
	desc = "Used to debug electronic equipment."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	damage_force = 5.0
	w_class = WEIGHT_CLASS_SMALL
	throw_force = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "You can use this on airlocks or APCs to try to hack them without cutting wires."

	materials_base = list(MAT_STEEL = 50, MAT_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	var/obj/machinery/telecomms/buffer // simple machine buffer for device linkage
