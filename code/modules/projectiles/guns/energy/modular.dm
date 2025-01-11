//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/obj/item/gun/energy/modular
	/// active particle array
	var/obj/item/gun_component/particle_array/active_particle_array

/obj/item/gun/energy/modular/on_modular_component_uninstall(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	..()
	if(!istype(component, /obj/item/gun_component/particle_array))
		return
	if(component == active_particle_array)
		set_particle_array(null)

/obj/item/gun/energy/modular/on_modular_component_install(obj/item/gun_component/component, datum/event_args/actor/actor, silent)
	..()
	if(!istype(component, /obj/item/gun_component/particle_array))
		return
	if(!active_particle_array)
		set_particle_array(component)

/obj/item/gun/energy/modular/proc/set_particle_array(obj/item/gun_component/particle_array/array)

	update_icon()

#warn impl; action, etc
