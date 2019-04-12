/*
 * Vox Darkmatter Cannon
 */
/obj/item/gun/energy/darkmatter
	name = "dark matter gun"
	desc = "A vicious alien beam weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "darkcannon"
	item_state = "darkcannon"
	w_class = ITEMSIZE_HUGE
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	removable_battery = FALSE

	firemodes = list(
		/datum/firemode/energy/darkmatter/stun,
		/datum/firemode/energy/dakrmatter/beam,
		/datum/firemode/energy/darkmatter/burst
		)

/*
 * Vox Sonic Cannon
 */
/obj/item/gun/energy/sonic
	name = "soundcannon"
	desc = "A vicious alien sound weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "noise"
	item_state = "noise"
	w_class = ITEMSIZE_HUGE
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	removable_battery = FALSE

	firemodes = list(
		/datum/firemode/energy/sonic/strong,
		/datum/firemode/energy/sonic/weak
		)
