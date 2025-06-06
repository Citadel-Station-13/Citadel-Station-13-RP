//Expedition pistol
/obj/item/gun/projectile/energy/frontier
	name = "Expedition Crank Phaser"
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization."
	icon_state = "phaser"
	item_state = "phaser"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "phaser", SLOT_ID_LEFT_HAND = "phaser", "SLOT_ID_BELT" = "phaser")
	fire_sound = /datum/soundbyte/guns/energy/laser_3/rifle
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 2, TECH_POWER = 4)
	charge_cost = 300
	legacy_battery_lock = 1

	var/recharging = 0
	var/phase_power = 75

	projectile_type = /obj/projectile/beam
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/projectile/beam, charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/projectile/beam/weaklaser, charge_cost = 60),
	)

/obj/item/gun/projectile/energy/frontier/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
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
	update_icon()
	user.visible_message("<span class='notice'>[user] opens \the [src] and starts pumping the handle.</span>", \
						"<span class='notice'>You open \the [src] and start pumping the handle.</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(obj_cell_slot?.cell?.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()

/obj/item/gun/projectile/energy/frontier/update_icon()
	if(recharging)
		icon_state = "[initial(icon_state)]_pump"
		return
	..()

/obj/item/gun/projectile/energy/frontier/emp_act(severity)
	return ..(severity+2)

/obj/item/gun/projectile/energy/frontier/legacy_ex_act() //|rugged|
	return

/obj/item/gun/projectile/energy/frontier/locked
	desc = "An extraordinarily rugged laser weapon, built to last and requiring effectively no maintenance. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	pin = /obj/item/firing_pin/explorer

//Phaser Carbine - Reskinned phaser
/obj/item/gun/projectile/energy/frontier/locked/carbine
	name = "Expedition Phaser Carbine"
	desc = "An ergonomically improved version of the venerable frontier phaser, the carbine is a fairly new weapon, and has only been produced in limited numbers so far. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon_state = "carbinekill"
	item_state = "retro"
	item_icons = list(SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi', SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi')

	modifystate = "carbinekill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/projectile/beam, modifystate="carbinekill", charge_cost = 300),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/projectile/beam/weaklaser, modifystate="carbinestun", charge_cost = 60),

	)

//Expeditionary Holdout Phaser Pistol
/obj/item/gun/projectile/energy/frontier/locked/holdout
	name = "Holdout Phaser Pistol"
	desc = "An minaturized weapon designed for the purpose of expeditionary support to defend themselves on the field. Includes a built-in crank charger for recharging away from civilization. This one has a safety interlock that prevents firing while in proximity to the facility."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "holdoutkill"
	item_state = null
	fire_sound = /datum/soundbyte/guns/energy/laser_3/pistol
	phase_power = 100

	w_class = WEIGHT_CLASS_SMALL
	charge_cost = 600
	modifystate = "holdoutkill"
	firemodes = list(
		list(mode_name="lethal", fire_delay=12, projectile_type=/obj/projectile/beam, modifystate="holdoutkill", charge_cost = 600),
		list(mode_name="low-power", fire_delay=8, projectile_type=/obj/projectile/beam/weaklaser, modifystate="holdoutstun", charge_cost = 120),
		list(mode_name="stun", fire_delay=12, projectile_type=/obj/projectile/beam/stun/med, modifystate="holdoutshock", charge_cost = 300),
	)

/obj/item/gun/projectile/energy/frontier/taj
	name = "Adhomai crank laser"
	desc = "The \"Icelance\" crank charged laser rifle, produced by the Hadii-Wrack group for the People's Republic of Adhomai's Grand People's Army."
	icon = 'icons/obj/gun/energy.dmi'
	icon_state = "phaser-taj"
	item_state = "phaser-taj"
	wielded_item_state = "phaser-taj"
	charge_cost = 600

	projectile_type = /obj/projectile/beam/midlaser


	firemodes = list(
	)

/obj/item/gun/projectile/energy/frontier/taj/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(!clickchain.performer.inventory.count_empty_hands())
		return
	var/mob/user = clickchain.performer
	if(recharging)
		return
	. |= CLICKCHAIN_DID_SOMETHING
	recharging = 1
	update_icon()
	user.visible_message("<span class='notice'>[user] begins to turn the crank of \the [src].</span>", \
						"<span class='notice'>You begins to turn the crank of \the [src].</span>")
	while(recharging)
		if(!do_after(user, 10, src))
			break
		playsound(get_turf(src),'sound/items/change_drill.ogg',25,1)
		if(obj_cell_slot?.cell?.give(phase_power) < phase_power)
			break

	recharging = 0
	update_icon()
