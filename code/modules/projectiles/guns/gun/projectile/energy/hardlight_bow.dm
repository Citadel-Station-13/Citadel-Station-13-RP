
/obj/item/gun/projectile/energy/hardlight_bow
	name = "hardlight bow"
	desc = "An experimental, unlicensed design from Haephestus that never actually went anywhere; the idea of a crankable ion weapon was of interest, but the lack of practicality made it undesirable. \n \n <i>\"...and his music was electric.\"</i>"
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "bow_hardlight"
	item_state = "bow_pipe"
	slot_flags = SLOT_BACK | SLOT_BELT
	charge_cost = 1200
	legacy_battery_lock = 1
	pin = /obj/item/firing_pin/explorer
	projectile_type = /obj/projectile/ion

	var/recharging = 0
	var/phase_power = 150

/obj/item/gun/projectile/energy/hardlight_bow/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	var/mob/user = clickchain.performer
	if(!user.inventory.count_empty_hands())
		return
	if(recharging)
		return
	. |= CLICKCHAIN_DID_SOMETHING
	recharging = 1
	user.visible_message("<span class='notice'>[user] begins to tighten \the [src]'s electric bowstring.</span>", \
						"<span class='notice'>You begin to tighten \the [src]'s electric bowstring</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/weapons/hardlight_bow_charge.ogg',25,1)
		if(obj_cell_slot?.cell?.give(phase_power) < phase_power)
			break

	recharging = 0
