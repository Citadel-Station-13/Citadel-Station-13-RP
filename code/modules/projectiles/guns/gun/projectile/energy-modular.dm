//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/projectile/energy/on_modular_component_uninstall(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	..()
	if(!istype(component, /obj/item/gun_component/particle_array))
		return
	if(component == active_particle_array)
		set_particle_array(null)

/obj/item/gun/projectile/energy/on_modular_component_install(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	..()
	if(!istype(component, /obj/item/gun_component/particle_array))
		return
	if(!active_particle_array)
		set_particle_array(component)

/**
 * Unlike [set_particle_array], this will automatically pick the first inserted
 * array if the passed in array is null and there is one available.
 */
/obj/item/gun/projectile/energy/proc/auto_set_particle_array(obj/item/gun_component/particle_array/array)

/obj/item/gun/projectile/energy/proc/set_particle_array(obj/item/gun_component/particle_array/array)

	update_icon()

#warn impl; action, etc

/obj/item/gun/projectile/energy/proc/reconsider_particle_array_actions()
	#warn impl
