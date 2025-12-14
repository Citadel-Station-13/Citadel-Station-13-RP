//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!
//I'm annoyed I even have to tell you this! SPRITE FIRST, then commit.
#define EQUIP_HEAVY_WEAPON "heavy_weapon" //Should only be used on weapons meant for 3x3 mechs.

#define EQUIP_HULL		"hull"
#define EQUIP_WEAPON	"weapon"
#define EQUIP_UTILITY	"utility"
#define EQUIP_SPECIAL	"core"

#define EQUIP_MICRO_UTILITY	"micro_utility"
#define EQUIP_MICRO_WEAPON	"micro_weapon"

/obj/item/vehicle_module
	name = "mecha equipment"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_equip"
	damage_force = 5
	origin_tech = list(TECH_MATERIAL = 2)
	description_info = "Some equipment may gain new abilities or advantages if equipped to certain types of Exosuits."
	var/equip_cooldown = 0
	var/equip_ready = TRUE
	var/energy_drain = 0
	var/obj/vehicle/sealed/mecha/chassis = null
	var/range = MELEE //bitflags
	/// Bitflag. Used by exosuit fabricator to assign sub-categories based on which exosuits can equip this.
	var/mech_flags = NONE
	var/salvageable = TRUE
	///May be either a type or a list of allowed types
	var/required_type = /obj/vehicle/sealed/mecha
	///mechaequip2
	var/equip_type = null
	var/allow_duplicate = FALSE
	///Sound to play once the fire delay passed.
	var/ready_sound = 'sound/mecha/mech_reload_default.ogg'
	/// Will the tool do its special?
	var/enable_special = FALSE
	///Does the component slow/speed up the suit?
	var/step_delay = 0

/obj/item/vehicle_module/proc/do_after_cooldown(target=1)
	sleep(equip_cooldown)
	set_ready_state(1)
	if(ready_sound) //Kind of like the kinetic accelerator.
		playsound(src, ready_sound, 50, 1, -1)
	if(target && chassis)
		return TRUE
	return FALSE

/obj/item/vehicle_module/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("[src] will fill [equip_type?"a [equip_type]":"any"] slot.")

/obj/item/vehicle_module/proc/add_equip_overlay(obj/vehicle/sealed/mecha/M as obj)
	return

/obj/item/vehicle_module/proc/update_chassis_page()
	if(chassis)
		send_byjax(chassis.occupant_legacy,"exosuit.browser","eq_list",chassis.get_equipment_list())
		send_byjax(chassis.occupant_legacy,"exosuit.browser","equipment_menu",chassis.get_equipment_menu(),"dropdowns")
		return TRUE
	return

/obj/item/vehicle_module/proc/update_equip_info()
	if(chassis)
		send_byjax(chassis.occupant_legacy,"exosuit.browser","\ref[src]",get_equip_info())
		return TRUE
	return

///Missiles detonating, teleporter creating singularity?
/obj/item/vehicle_module/proc/destroy()
	if(chassis)
		if(equip_type)
			if(equip_type == EQUIP_HULL)
				chassis.hull_equipment -= src
				listclearnulls(chassis.hull_equipment)
			if(equip_type == EQUIP_WEAPON)
				chassis.weapon_equipment -= src
				listclearnulls(chassis.weapon_equipment)
			if(equip_type == EQUIP_HEAVY_WEAPON)
				chassis.heavy_weapon_equipment -= src
				listclearnulls(chassis.heavy_weapon_equipment)
			if(equip_type == EQUIP_UTILITY)
				chassis.utility_equipment -= src
				listclearnulls(chassis.utility_equipment)
			if(equip_type == EQUIP_SPECIAL)
				chassis.special_equipment -= src
				listclearnulls(chassis.special_equipment)
			if(equip_type == EQUIP_MICRO_UTILITY)
				chassis.micro_utility_equipment -= src
				listclearnulls(chassis.micro_utility_equipment)
			if(equip_type == EQUIP_MICRO_WEAPON)
				chassis.micro_weapon_equipment -= src
				listclearnulls(chassis.micro_weapon_equipment)
		chassis.universal_equipment -= src
		chassis.equipment -= src
		listclearnulls(chassis.equipment)
		if(chassis.selected == src)
			chassis.selected = null
		src.update_chassis_page()
		chassis.occupant_message(SPAN_DANGER("The [src] is destroyed!"))
		chassis.log_append_to_last("[src] is destroyed.",1)
		if(istype(src, /obj/item/vehicle_module/weapon))//Gun
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
	return

/obj/item/vehicle_module/proc/critfail()
	if(chassis)
		log_message("Critical failure",1)
	return

/obj/item/vehicle_module/proc/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]"

/obj/item/vehicle_module/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED

/obj/item/vehicle_module/proc/is_melee()
	return range&MELEE

/obj/item/vehicle_module/proc/enable_special_checks(atom/target)
	if(ispath(required_type))
		return istype(target, required_type)

	for (var/path in required_type)
		if (istype(target, path))
			return TRUE
	return FALSE

/obj/item/vehicle_module/proc/action_checks(atom/target)
	if(!target)
		return FALSE
	if(!chassis)
		return FALSE
	if(!equip_ready)
		return FALSE
	if(energy_drain && !chassis.has_charge(energy_drain))
		return FALSE
	return TRUE

/obj/item/vehicle_module/proc/action(atom/target)
	return

/obj/item/vehicle_module/proc/can_attach(obj/vehicle/sealed/mecha/M as obj)
	//if(M.equipment.len >= M.max_equip)
	//	return FALSE
	if(!allow_duplicate)
		for(var/obj/item/vehicle_module/ME in M.equipment) //Exact duplicate components aren't allowed.
			if(ME.type == src.type)
				return FALSE
	if(equip_type == EQUIP_HULL && M.hull_equipment.len < M.max_hull_equip)
		return TRUE
	if(equip_type == EQUIP_WEAPON && M.weapon_equipment.len < M.max_weapon_equip)
		return TRUE
	if(equip_type == EQUIP_HEAVY_WEAPON && M.heavy_weapon_equipment.len < M.max_heavy_weapon_equip)
		return TRUE
	if(equip_type == EQUIP_UTILITY && M.utility_equipment.len < M.max_utility_equip)
		return TRUE
	if(equip_type == EQUIP_SPECIAL && M.special_equipment.len < M.max_special_equip)
		return TRUE
	if(equip_type == EQUIP_MICRO_UTILITY && M.micro_utility_equipment.len < M.max_micro_utility_equip)
		return TRUE
	if(equip_type == EQUIP_MICRO_WEAPON && M.micro_weapon_equipment.len < M.max_micro_weapon_equip)
		return TRUE
	if(equip_type != EQUIP_SPECIAL && M.universal_equipment.len < M.max_universal_equip) //The exosuit needs to be military grade to actually have a universal slot capable of accepting a true weapon.
		if(equip_type == EQUIP_WEAPON && !istype(M, /obj/vehicle/sealed/mecha/combat))
			return FALSE
		return TRUE
	/*if (ispath(required_type))
		return istype(M, required_type)

	for (var/path in required_type)
		if (istype(M, path))
			return TRUE
	*/
	return FALSE

/obj/item/vehicle_module/proc/attach(obj/vehicle/sealed/mecha/M as obj)
	//M.equipment += src
	var/has_equipped = FALSE
	if(equip_type == EQUIP_HULL && M.hull_equipment.len < M.max_hull_equip && !has_equipped)
		M.hull_equipment += src
		has_equipped = TRUE
	if(equip_type == EQUIP_WEAPON && M.weapon_equipment.len < M.max_weapon_equip && !has_equipped)
		M.weapon_equipment += src
		has_equipped = TRUE
	if(equip_type == EQUIP_HEAVY_WEAPON && M.heavy_weapon_equipment.len < M.max_heavy_weapon_equip && !has_equipped)
		M.heavy_weapon_equipment += src
		has_equipped = TRUE
	if(equip_type == EQUIP_UTILITY && M.utility_equipment.len < M.max_utility_equip && !has_equipped)
		M.utility_equipment += src
		has_equipped = TRUE
	if(equip_type == EQUIP_SPECIAL && M.special_equipment.len < M.max_special_equip && !has_equipped)
		M.special_equipment += src
		has_equipped = TRUE
	if(equip_type == EQUIP_MICRO_UTILITY && M.micro_utility_equipment.len < M.max_micro_utility_equip && !has_equipped)
		M.micro_utility_equipment += src
		has_equipped = TRUE
	if(equip_type == EQUIP_MICRO_WEAPON && M.micro_weapon_equipment.len < M.max_micro_weapon_equip && !has_equipped)
		M.micro_weapon_equipment += src
		has_equipped = TRUE
	if(equip_type != EQUIP_SPECIAL && M.universal_equipment.len < M.max_universal_equip && !has_equipped)
		M.universal_equipment += src
	M.equipment += src
	chassis = M
	src.loc = M

	if(enable_special_checks(M))
		enable_special = TRUE

	M.log_message("[src] initialized.")
	if(!M.selected)
		M.selected = src
	src.update_chassis_page()
	return

/obj/item/vehicle_module/proc/detach(atom/moveto=null)
	moveto = moveto || get_turf(chassis)
	if(src.forceMove(moveto))
		chassis.equipment -= src
		chassis.universal_equipment -= src
		if(equip_type)
			switch(equip_type)
				if(EQUIP_HULL)
					chassis.hull_equipment -= src
				if(EQUIP_WEAPON)
					chassis.weapon_equipment -= src
				if(EQUIP_HEAVY_WEAPON)
					chassis.heavy_weapon_equipment -= src
				if(EQUIP_UTILITY)
					chassis.utility_equipment -= src
				if(EQUIP_SPECIAL)
					chassis.special_equipment -= src
				if(EQUIP_MICRO_UTILITY)
					chassis.micro_utility_equipment -= src
				if(EQUIP_MICRO_WEAPON)
					chassis.micro_weapon_equipment -= src
		if(chassis.selected == src)
			chassis.selected = null
		update_chassis_page()
		chassis.log_message("[src] removed from equipment.")
		chassis = null
		set_ready_state(1)
	enable_special = FALSE
	return

/obj/item/vehicle_module/Topic(href,href_list)
	if(href_list["detach"])
		src.detach()
	return

/obj/item/vehicle_module/proc/set_ready_state(state)
	equip_ready = state
	if(chassis)
		send_byjax(chassis.occupant_legacy,"exosuit.browser","\ref[src]",src.get_equip_info())
	return

/obj/item/vehicle_module/proc/occupant_message(message)
	if(chassis)
		chassis.occupant_message("[icon2html(src, world)] [message]")
	return

/obj/item/vehicle_module/proc/log_message(message)
	if(chassis)
		chassis.log_message("<i>[src]:</i> [message]")
	return

///Allows mech equipment to do an action upon the mech moving
/obj/item/vehicle_module/proc/MoveAction()
	return

///Equipment returns its slowdown or speedboost.
/obj/item/vehicle_module/proc/get_step_delay()
	return step_delay

//* Chassis - Physicality *//

/**
 * Returns if our mount is sufficiently close to something to be considered adjacent.
 *
 * * This is usually our mech.
 * * If we are not mounted, this always fails.
 */
/obj/item/vehicle_module/proc/sufficiently_adjacent(atom/entity)
	return chassis?.sufficiently_adjacent(entity)
