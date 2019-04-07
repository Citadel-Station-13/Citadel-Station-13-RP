/*
 * Contains weapons primarily using the 'grappling hook' projectiles.
 */

/obj/item/gun/energy/hooklauncher
	name = "gravity whip"
	desc = "A large, strange gauntlet."
	icon_state = "gravwhip"
	item_state = "gravwhip"
	firemodes = /datum/firemode/energy/hook

// An easily concealable not-ripoff version. It would be silenced, if it didn't make it blatant you're the one using it.

/obj/item/gun/energy/hooklauncher/ring
	name = "ominous ring"
	desc = "A small ring with strange symbols engraved upon it."
	icon = 'icons/obj/clothing/rings.dmi'
	icon_state = "seal-signet"
	item_state = "concealed"
	w_class = ITEMSIZE_TINY
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/alien
	removable_battery = FALSE
	automatic_charge_overlays = FALSE
	firemodes = list(/datum/firemode/energy/hook, /datum/firemode/energy/laser/xray/battlering)
