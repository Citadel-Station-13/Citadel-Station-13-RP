/obj/item/vehicle_module/legacy
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
	/// Bitflag. Used by exosuit fabricator to assign sub-categories based on which exosuits can equip this.
	var/mech_flags = NONE
	///Sound to play once the fire delay passed.
	var/ready_sound = 'sound/mecha/mech_reload_default.ogg'
	///Does the component slow/speed up the suit?
	var/step_delay = 0

#warn hook 'chassis'

/obj/item/vehicle_module/legacy/proc/do_after_cooldown(target=1)
	sleep(equip_cooldown)
	set_ready_state(1)
	if(ready_sound) //Kind of like the kinetic accelerator.
		playsound(src, ready_sound, 50, 1, -1)
	if(target && chassis)
		return TRUE
	return FALSE

/obj/item/vehicle_module/legacy/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("[src] will fill [equip_type?"a [equip_type]":"any"] slot.")

/obj/item/vehicle_module/legacy/proc/add_equip_overlay(obj/vehicle/sealed/mecha/M as obj)
	return

/obj/item/vehicle_module/legacy/proc/

///Missiles detonating, teleporter creating singularity?
/obj/item/vehicle_module/legacy/proc/destroy()
	if(chassis)
		chassis.occupant_message(SPAN_DANGER("The [src] is destroyed!"))
		chassis.log_append_to_last("[src] is destroyed.",1)
		if(istype(src, /obj/item/vehicle_module/legacy/weapon))//Gun
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

/obj/item/vehicle_module/legacy/proc/critfail()
	if(chassis)
		log_message("Critical failure",1)

/obj/item/vehicle_module/legacy/proc/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]"

/obj/item/vehicle_module/legacy/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED

/obj/item/vehicle_module/legacy/proc/is_melee()
	return range&MELEE

/obj/item/vehicle_module/legacy/proc/action_checks(atom/target)
	if(!target)
		return FALSE
	if(!chassis)
		return FALSE
	if(!equip_ready)
		return FALSE
	if(energy_drain && !chassis.has_charge(energy_drain))
		return FALSE
	return TRUE

/obj/item/vehicle_module/legacy/proc/action(atom/target)
	return

/obj/item/vehicle_module/legacy/proc/can_attach(obj/vehicle/sealed/mecha/M as obj)
	#warn deal with this shit
	if(equip_type != EQUIP_SPECIAL && M.universal_equipment.len < M.max_universal_equip) //The exosuit needs to be military grade to actually have a universal slot capable of accepting a true weapon.
		if(equip_type == EQUIP_WEAPON && !istype(M, /obj/vehicle/sealed/mecha/combat))
			return FALSE
		return TRUE
	return FALSE

/obj/item/vehicle_module/legacy/proc/attach(obj/vehicle/sealed/mecha/M as obj)
	#warn deal with this shit
	var/has_equipped = FALSE
	M.equipment += src
	chassis = M
	src.loc = M

	if(!M.selected)
		M.selected = src
	src.update_chassis_page()
	return

/obj/item/vehicle_module/legacy/proc/detach(atom/moveto=null)
	moveto = moveto || get_turf(chassis)
	if(src.forceMove(moveto))
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.log_message("[src] removed from equipment.")
		chassis = null
		set_ready_state(1)

/obj/item/vehicle_module/legacy/Topic(href,href_list)
	if(href_list["detach"])
		src.detach()
	return

/obj/item/vehicle_module/legacy/proc/set_ready_state(state)
	equip_ready = state
	if(chassis)
		send_byjax(chassis.occupant_legacy,"exosuit.browser","\ref[src]",src.get_equip_info())

/obj/item/vehicle_module/legacy/proc/occupant_message(message)
	if(chassis)
		chassis.occupant_message("[icon2html(src, world)] [message]")
	return

/obj/item/vehicle_module/legacy/proc/log_message(message)
	if(chassis)
		chassis.log_message("<i>[src]:</i> [message]")
	return

///Equipment returns its slowdown or speedboost.
/obj/item/vehicle_module/legacy/proc/get_step_delay()
	return step_delay
