//////////////
//Defensive//
//////////////

/obj/item/vehicle_module/shocker
	name = "exosuit electrifier"
	desc = "A device to electrify the external portions of a mecha in order to increase its defensive capabilities."
	icon_state = "mecha_coil"
	equip_cooldown = 10
	energy_drain = 100
	range = RANGED
	origin_tech = list(TECH_COMBAT = 3, TECH_POWER = 6)
	var/shock_damage = 15
	var/active

	equip_type = EQUIP_HULL

/*
/obj/item/vehicle_module/shocker/can_attach(obj/vehicle/sealed/mecha/M as obj)
	if(..())
		if(!M.proc_res["dynattackby"] && !M.proc_res["dynattackhand"] && !M.proc_res["dynattackalien"])
			return 1
	return 0

/obj/item/vehicle_module/shocker/attach(obj/vehicle/sealed/mecha/M as obj)
	..()
	chassis.proc_res["dynattackby"] = src
	return
*/

/obj/item/vehicle_module/shocker/handle_melee_contact(var/obj/item/W, var/mob/living/user, var/inc_damage = null)
	if(!action_checks(user) || !active)
		return

	user.electrocute(damage = shock_damage, hit_zone = BP_TORSO, source = src)
	return inc_damage
