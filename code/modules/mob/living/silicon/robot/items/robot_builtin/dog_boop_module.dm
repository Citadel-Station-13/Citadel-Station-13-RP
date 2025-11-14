/obj/item/robot_builtin/dog_boop_module
	name = "boop module"
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "nose"
	desc = "The BOOP module, a simple reagent and atmosphere sniffer."
	damage_force = 0
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD
	throw_force = 0
	attack_verb = list("nuzzled", "nosed", "booped")
	w_class = WEIGHT_CLASS_TINY

/obj/item/robot_builtin/dog_boop_module/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if (!( istype(user.loc, /turf) ))
		return

	var/datum/gas_mixture/environment = user.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.setClickCooldownLegacy(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message("<span class='notice'>[user] sniffs the air.</span>", "<span class='notice'>You sniff the air...</span>")

	to_chat(user, "<span class='notice'><B>Smells like:</B></span>")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(user, "<span class='notice'>Pressure: [round(pressure,0.1)] kPa</span>")
	else
		to_chat(user, "<span class='warning'>Pressure: [round(pressure,0.1)] kPa</span>")
	if(total_moles)
		for(var/g in environment.gas)
			to_chat(user, "<span class='notice'>[global.gas_data.names[g]]: [round((environment.gas[g] / total_moles) * 100)]%</span>")
		to_chat(user, "<span class='notice'>Temperature: [round(environment.temperature-T0C,0.1)]&deg;C ([round(environment.temperature,0.1)]K)</span>")

/obj/item/robot_builtin/dog_boop_module/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if (user.stat)
		return
	if(!istype(target) && !ismob(target))
		return

	user.setClickCooldownLegacy(DEFAULT_ATTACK_COOLDOWN)


	if(ismob(target))
		user.visible_message("<span class='notice'>\the [user] boops \the [target.name]!</span>", "<span class='notice'>You boop \the [target.name]!</span>")
		playsound(src, 'sound/weapons/thudswoosh.ogg', 25, 1, -1)
	else
		user.visible_message("<span class='notice'>[user] sniffs at \the [target.name].</span>", "<span class='notice'>You sniff \the [target.name]...</span>")
		if(!isnull(target.reagents))
			var/dat = ""
			if(target.reagents.total_volume > 0)
				for (var/datum/reagent/R in target.reagents.get_reagent_datums())
					dat += "\n \t <span class='notice'>[R]</span>"
			if(dat)
				to_chat(user, "<span class='notice'>Your BOOP module indicates: [dat]</span>")
			else
				to_chat(user, "<span class='notice'>No active chemical agents smelled in [target].</span>")
		else
			if(istype(target, /obj/item/tank)) // don't double post what atmosanalyzer_scan returns
				analyze_gases(target, user)
			else
				to_chat(user, "<span class='notice'>No significant chemical agents smelled in [target].</span>")
