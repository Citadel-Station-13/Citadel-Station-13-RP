
/obj/item/gun/energy/hardlight_bow
	name = "hardlight bow"
	desc = "An experimental, unlicensed design from Haephestus that never actually went anywhere; the idea of a crankable ion weapon was of interest, but the lack of practicality made it undesirable. \n \n <i>\"...and his music was electric.\"</i>"
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "bow_hardlight"
	item_state = "bow_pipe"
	slot_flags = SLOT_BACK | SLOT_BELT
	charge_cost = 1200
	battery_lock = 1
	pin = /obj/item/firing_pin/explorer
	projectile_type = /obj/projectile/ion

	var/recharging = 0
	var/phase_power = 150

/obj/item/gun/energy/hardlight_bow/unload_ammo(var/mob/user)
	if(recharging)
		return
	recharging = 1
	user.visible_message("<span class='notice'>[user] begins to tighten \the [src]'s electric bowstring.</span>", \
						"<span class='notice'>You begin to tighten \the [src]'s electric bowstring</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/weapons/hardlight_bow_charge.ogg',25,1)
		if(power_supply.give(phase_power) < phase_power)
			break

	recharging = 0
