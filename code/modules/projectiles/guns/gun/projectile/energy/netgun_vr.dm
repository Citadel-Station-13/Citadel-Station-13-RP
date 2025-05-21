/datum/firemode/energy/netgun
	cycle_cooldown = 0.5 SECONDS

/datum/firemode/energy/netgun/stun
	name = "stun"
	legacy_direct_varedits = list(projectile_type=/obj/projectile/beam/stun/blue, fire_sound='sound/weapons/Taser.ogg', charge_cost=240)

/datum/firemode/energy/netgun/capture
	name = "capture"
	cycle_cooldown = 5 SECONDS
	legacy_direct_varedits = list(projectile_type=/obj/projectile/beam/energy_net, fire_sound = 'sound/weapons/eluger.ogg', charge_cost=1200)


/obj/item/gun/projectile/energy/netgun
	name = "Hephaestus \'Retiarius\'"
	desc = "The Hephaestus Industries 'Retiarius' stuns targets, immobilizing them in an energized net field."
	catalogue_data = list()///datum/category_item/catalogue/information/organization/hephaestus)
	icon_state = "hunter"
	item_state = "gun" // Placeholder

	fire_sound = 'sound/weapons/eluger.ogg'
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	projectile_type = /obj/projectile/beam/stun/blue
	charge_cost = 240

	firemodes = list(
		/datum/firemode/energy/netgun/stun,
		/datum/firemode/energy/netgun/capture,
	)

/obj/item/gun/projectile/energy/netgun/update_icon()
	cut_overlays()
	var/list/overlays_to_add = list()

	if(obj_cell_slot.cell)
		var/ratio = obj_cell_slot.cell.charge / obj_cell_slot.cell.maxcharge

		if(obj_cell_slot.cell.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, 0.25) * 100, 25)

		overlays_to_add += "[initial(icon_state)]_cell"
		overlays_to_add += "[initial(icon_state)]_[ratio]"
		overlays_to_add += "[initial(icon_state)]_[firemode.name]"

	add_overlay(overlays_to_add)
