/obj/item/stack/telecrystal
	name = "telecrystal"
	desc = "It seems to be pulsing with suspiciously enticing energies."
	description_antag = "Telecrystals can be activated by utilizing them on devices with an actively running uplink. They will not activate on unactivated uplinks."
	singular_name = "telecrystal"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "telecrystal"
	w_class = ITEMSIZE_TINY
	max_amount = 240
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)
	damage_force = 1 //Needs a token force to ensure you can attack because for some reason you can't attack with 0 force things

/obj/item/stack/telecrystal/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/L = target
	if(!istype(L))
		return
	if(amount >= 5)
		add_attack_logs(user, L, "teleported with telecrystals")
		L.visible_message("<span class='warning'>\The [L] has been transported with \the [src] by \the [user].</span>")
		safe_blink(L, 14)
		use(5)
	else
		to_chat(user, "<span class='warning'>There are not enough telecrystals to do that.</span>")
	return NONE

/obj/item/stack/telecrystal/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(user.mind.accept_tcrystals) //Checks to see if antag type allows for tcrystals
		to_chat(user, "<span class='notice'>You use \the [src], adding [src.amount] to your balance.</span>")
		user.mind.tcrystals += amount
		use(amount)
	return
