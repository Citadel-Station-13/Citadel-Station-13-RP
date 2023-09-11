/datum/firemode/energy/gravwhip
	name = "gravity beam"
	fire_delay = 1.5 SECONDS
	projectile_type = /obj/projectile/energy/hook
	charge_cost = 400

/datum/firemode/energy/gravring/grab
	name = "manipulate"
	fire_delay = 1.5 SECONDS
	projectile_type = /obj/projectile/energy/hook/ring
	charge_cost = 400

/datum/firemode/energy/gravring/battle
	name = "battle"
	projectile_type = /obj/projectile/beam/xray
	charge_cost = 260
	fire_delay = 0.8 SECONDS

/obj/item/gun/projectile/energy/hooklauncher
	name = "gravity whip"
	desc = "A large, strange gauntlet."
	icon_state = "gravwhip"
	item_state = "gravwhip"
	fire_sound_text = "laser blast"

	fire_delay = 15
	charge_cost = 300

	cell_type = /obj/item/cell/device/weapon

	regex_this_firemodes = list(
		/datum/firemode/energy/gravwhip,
	)

/obj/item/gun/projectile/energy/hooklauncher/ring
	name = "ominous ring"
	desc = "A small ring with strange symbols engraved upon it."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-signet"
	item_state = "concealed"

	w_class = ITEMSIZE_TINY

	cell_type = /obj/item/cell/device/weapon/recharge/alien
	battery_lock = TRUE

	regex_this_firemodes = list(
		/datum/firemode/energy/gravring/grab,
		/datum/firemode/energy/gravring/battle,
	)
