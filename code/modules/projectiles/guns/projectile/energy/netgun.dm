/datum/firemode/energy/netgun/stun
	name = "stun"
	projectile_type = /obj/projectile/beam/stun/blue
	fire_delay = 0.5 SECONDS
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 240
	legacy_modifystate = "stun"

/datum/firemode/energy/netgun/capture
	name = "net"
	projectile_type = /obj/projectile/beam/energy_net
	fire_delay = 5 SECONDS
	fire_sound = 'sound/weapons/eluger.ogg'
	charge_cost = 1200
	legacy_modifystate = "net"

/obj/item/gun/projectile/energy/netgun
	name = "Hephaestus \'Retiarius\'"
	desc = "The Hephaestus Industries 'Retiarius' stuns targets, immobilizing them in an energized net field."
	catalogue_data = list()///datum/category_item/catalogue/information/organization/hephaestus)
	icon_state = "hunter"
	item_state = "gun" // Placeholder

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)

	regex_this_firemodes = list(
		/datum/firemode/energy/netgun/stun,
		/datum/firemode/energy/netgun/capture,
	)

/obj/item/gun/projectile/energy/netgun/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()

	if(power_supply)
		var/ratio = power_supply.charge / power_supply.maxcharge

		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		overlays_to_add += "[initial(icon_state)]_cell"
		overlays_to_add += "[initial(icon_state)]_[ratio]"
		overlays_to_add += "[initial(icon_state)]_[firemode.legacy_modifystate]"

	add_overlay(overlays_to_add)
