/obj/item/chainsaw
	name = "chainsaw"
	desc = "A motorized belt assembly that pulls a specialized chain at high speeds to create an effective cutting implement. Vroom vroom."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "chainsaw0"
	item_state = "chainsaw0"
	var/on = 0
	var/max_fuel = 100
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	var/active_force = 55
	var/inactive_force = 10

/obj/item/chainsaw/Initialize(mapload)
	. = ..()
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	START_PROCESSING(SSobj, src)

/obj/item/chainsaw/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/chainsaw/proc/turnOn(mob/user as mob)
	to_chat(user, "You start pulling the string on \the [src].")
	//visible_message("[usr] starts pulling the string on the [src].")

	if(max_fuel <= 0)
		if(do_after(user, 10))
			to_chat(user, "\The [src] won't start!")
		else
			to_chat(user, "You fumble with the string.")
	else
		if(do_after(user, 10))
			to_chat(user, "You start \the [src] up with a loud grinding!")
			//visible_message("[usr] starts \the [src] up with a loud grinding!")
			attack_verb = list("shredded", "ripped", "torn")
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',40,1)
			damage_force = active_force
			edge = 1
			sharp = 1
			on = 1
			update_icon()
		else
			to_chat(user, "You fumble with the string.")

/obj/item/chainsaw/proc/turnOff(mob/user as mob)
	to_chat(user, "You switch the gas nozzle on the chainsaw, turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(user, 'sound/weapons/chainsaw_turnoff.ogg',40,1)
	damage_force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	update_icon()

/obj/item/chainsaw/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!on)
		turnOn(user)
	else
		turnOff(user)

/obj/item/chainsaw/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return
	..()
	if(on)
		playsound(src, 'sound/weapons/chainsaw_attack.ogg',40,1)
	if(target && on)
		if(get_fuel() > 0)
			reagents.remove_reagent("fuel", 1)
	if (istype(target, /obj/structure/reagent_dispensers/fueltank) || istype(target, /obj/item/reagent_containers/portable_fuelcan) && get_dist(src,target) <= 1)
		to_chat(usr, "<span class='notice'>You begin filling the tank on the [src].</span>")
		if(do_after(usr, 15))
			target.reagents.trans_to_obj(src, max_fuel)
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
			to_chat(usr, "<span class='notice'>[src] succesfully refueled.</span>")
		else
			to_chat(usr, "<span class='notice'>Don't move while you're refilling the [src].</span>")

/obj/item/chainsaw/process(delta_time)
	if(!on)
		return

	if(get_fuel() > 0)
		reagents.remove_reagent("fuel", 1)
		playsound(src, 'sound/weapons/chainsaw_turnoff.ogg',15,1)
	if(get_fuel() <= 0)
		to_chat(usr, "\The [src] sputters to a stop!")
		turnOff()

/obj/item/chainsaw/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/chainsaw/examine(mob/user, dist)
	. = ..()
	if(max_fuel)
		. += "<span class = 'notice'>The [src] feels like it contains roughtly [get_fuel()] units of fuel left.</span>"

/obj/item/chainsaw/suicide_act(mob/user)
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	to_chat(viewers(user), "<span class='danger'>[user] is lying down and pulling the chainsaw into [TU.him], it looks like [TU.he] [TU.is] trying to commit suicide!</span>")
	return(BRUTELOSS)

/obj/item/chainsaw/update_icon()
	if(on)
		icon_state = "chainsaw1"
		item_state = "chainsaw1"
	else
		icon_state = "chainsaw0"
		item_state = "chainsaw0"

/obj/item/chainsaw/chainsword
	name = "chainsaw sword"
	desc = "The whirring assembly normally found in a chainsaw, now affixed to a sword-hilt. This weapon requires extensive training to wield effectively."
	icon_state = "chainsword0"
	item_state = "chainsword0"
	slot_flags = SLOT_BELT
	damage_force = 30
	throw_force = 10
	w_class = ITEMSIZE_NORMAL
	sharp = 1
	edge = 1
	attack_verb = list("sawed", "torn", "cut", "chopped", "diced")
	attack_sound = 'sound/weapons/chainsaw_attack.ogg'
	armor_penetration = 30

/obj/item/chainsaw/chainsword/turnOn(mob/user as mob)
	to_chat(user, "You begin pulling the throttle on \the [src].")
	//visible_message("[usr] starts pulling the throttle on the [src].")

	if(max_fuel <= 0)
		if(do_after(user, 10))
			to_chat(user, "\The [src] won't start!")
		else
			to_chat(user, "Your finger slips off of the throttle.")
	else
		if(do_after(user, 10))
			to_chat(user, "You start \the [src] up with a loud grinding!")
			//visible_message("[usr] starts \the [src] up with a loud grinding!")
			attack_verb = list("shredded", "ripped", "torn")
			playsound(src, 'sound/weapons/chainsaw_startup.ogg',40,1)
			damage_force = active_force
			edge = 1
			sharp = 1
			on = 1
			update_icon()
		else
			to_chat(user, "Your finger slips off of the throttle.")

/obj/item/chainsaw/chainsword/turnOff(mob/user as mob)
	to_chat(user, "You release the trigger on the chainsword, turning it off.")
	attack_verb = list("bluntly hit", "beat", "knocked")
	playsound(user, 'sound/weapons/chainsaw_turnoff.ogg',40,1)
	damage_force = inactive_force
	edge = 0
	sharp = 0
	on = 0
	update_icon()

/obj/item/chainsaw/chainsword/update_icon()
	if(on)
		icon_state = "chainsword1"
		item_state = "chainsword1"
	else
		icon_state = "chainsword0"
		item_state = "chainsword0"
