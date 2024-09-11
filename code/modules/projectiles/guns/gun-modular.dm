//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Modular Components - Compatibility *//

/**
 * hard check
 */
/obj/item/gun/proc/can_install_component(obj/item/gun_component/component, force)
	SHOULD_NOT_OVERRIDE(TRUE)
	#warn slot enforcement
	return force || component.fits_on_gun(src, fits_modular_component(component))

/**
 * checks if we can attach a component; component gets final say
 */
/obj/item/gun/proc/fits_modular_component(obj/item/gun_component/component)
	return TRUE

//* Modular Components - Add / Remove *//

/**
 * * moves the component into us if it wasn't already
 */
/obj/item/gun/proc/attach_modular_component(obj/item/gun_component/component, force)
	#warn impl

/**
 * * deletes the component if no location is provided to move it to
 */
/obj/item/gun/proc/detach_modular_component(obj/item/gun_component/component, atom/new_loc)
	#warn impl

#warn hook everything in attackby's
