/obj/item/vehicle_module/lazy/legacy
	name = "mecha equipment"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_equip"
	damage_force = 5
	origin_tech = list(TECH_MATERIAL = 2)
	description_info = "Some equipment may gain new abilities or advantages if equipped to certain types of Exosuits."
	var/obj/vehicle/sealed/mecha/chassis
	var/equip_cooldown = 0
	var/equip_ready = TRUE
	var/energy_drain = 0
	var/range = MELEE //bitflags
	///Sound to play once the fire delay passed.
	var/ready_sound = 'sound/mecha/mech_reload_default.ogg'
	///Does the component slow/speed up the suit?
	var/step_delay = 0

#warn hook 'chassis'
#warn impl all

/obj/item/vehicle_module/lazy/legacy/proc/do_after_cooldown(target=1)
	sleep(equip_cooldown)
	set_ready_state(1)
	if(ready_sound) //Kind of like the kinetic accelerator.
		playsound(src, ready_sound, 50, 1, -1)
	if(target && chassis)
		return TRUE
	return FALSE

///Missiles detonating, teleporter creating singularity?
/obj/item/vehicle_module/lazy/legacy/proc/destroy()
	if(chassis)
		chassis.occupant_message(SPAN_DANGER("The [src] is destroyed!"))
		if(istype(src, /obj/item/vehicle_module/lazy/legacy/weapon))//Gun
			switch(chassis.mech_faction)
				if(MECH_FACTION_NT)
					src.chassis.occupant_legacy << sound('sound/mecha/weapdestrnano.ogg',volume=70)
				if(MECH_FACTION_SYNDI)
					src.chassis.occupant_legacy  << sound('sound/mecha/weapdestrsyndi.ogg',volume=60)
				else
					src.chassis.occupant_legacy  << sound('sound/mecha/weapdestr.ogg',volume=50)
		else //Not a gun
			switch(chassis.mech_faction)
				if(MECH_FACTION_NT)
					src.chassis.occupant_legacy  << sound('sound/mecha/critdestrnano.ogg',volume=70)
				if(MECH_FACTION_SYNDI)
					src.chassis.occupant_legacy  << sound('sound/mecha/critdestrsyndi.ogg',volume=70)
				else
					src.chassis.occupant_legacy  << sound('sound/mecha/critdestr.ogg',volume=50)
	spawn
		qdel(src)

/obj/item/vehicle_module/lazy/legacy/on_vehicle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/atom/target = clickchain.target
	if(target == vehicle)
	else if(sufficiently_adjacent(target))
		if(is_melee())
			action(target)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	else
		if(is_ranged())
			action(target)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	return clickchain_flags

/obj/item/vehicle_module/lazy/legacy/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED

/obj/item/vehicle_module/lazy/legacy/proc/is_melee()
	return range&MELEE

/obj/item/vehicle_module/lazy/legacy/proc/action_checks(atom/target)
	if(!target)
		return FALSE
	if(!chassis)
		return FALSE
	if(!equip_ready)
		return FALSE
	if(energy_drain && !chassis.has_charge(energy_drain))
		return FALSE
	return TRUE

/obj/item/vehicle_module/lazy/legacy/proc/action(atom/target)
	return

/obj/item/vehicle_module/lazy/legacy/proc/set_ready_state(state)
	equip_ready = state

/obj/item/vehicle_module/lazy/legacy/proc/occupant_message(message)
	return vehicle_occupant_send_default_chat(message)

///Equipment returns its slowdown or speedboost.
/obj/item/vehicle_module/lazy/legacy/proc/get_step_delay()
	return step_delay
