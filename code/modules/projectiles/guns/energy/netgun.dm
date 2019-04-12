/obj/item/gun/energy/netgun
	name = "Hephaestus \'Retiarius\'"
	desc = "The Hephaestus Industries 'Retiarius' stuns targets, immobilizing them in an energized net field."
	icon = 'icons/obj/items/guns/energy/misc.dmi'
	icon_state = "hunter"
	item_state = "gun" // Placeholder
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	automatic_charge_overlays = FALSE

	firemodes = list(
		/datum/firemode/energy/stun/netgun,
		/datum/firemode/energy/net
		)

/obj/item/gun/energy/netgun/update_icon()
	. = ..()

	if(power_supply)
		var/ratio = power_supply.charge / power_supply.maxcharge

		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		overlays += "[icon_state]_cell"
		overlays += "[icon_state]_[ratio]"
		overlays += "[icon_state]_[firemode.mode_icon_state]"
