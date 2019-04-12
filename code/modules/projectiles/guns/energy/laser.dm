/obj/item/gun/energy/laser
	name = "laser rifle"
	desc = "A Hephaestus Industries G40E rifle, designed to kill with concentrated energy blasts.  This variant has the ability to \
	switch between standard fire and a more efficent but weaker 'suppressive' fire."
	icon_state = "laser"
	item_state = "laser"
	wielded_item_state = "laser-wielded"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEMSIZE_LARGE
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
//	one_handed_penalty = 30

	firemodes = list(
		/datum/firemode/energy/laser/rifle,
		/datum/firemode/energy/laser/suppressive
		)

/obj/item/gun/energy/laser/mounted
	self_recharge = TRUE
	use_external_power = TRUE
	one_handed_penalty = FALSE	// Not sure if two-handing gets checked for mounted weapons, but better safe than sorry.

/obj/item/gun/energy/laser/practice
	name = "practice laser carbine"
	desc = "A modified version of the HI G40E, this one fires less concentrated energy bolts designed for target practice."
	cell_type = /obj/item/weapon/cell/device
	firemodes = /datum/firemode/energy/laser/practice

/obj/item/gun/energy/laser/retro
	name = "retro laser"
	icon_state = "retro"
	item_state = "retro"
	desc = "An older model of the basic lasergun. Nevertheless, it is still quite deadly and easy to maintain, making it a favorite amongst pirates and other outlaws."
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	firdemodes = /datum/firemode/energy/laser/retro

/obj/item/gun/energy/laser/retro/mounted
	self_recharge = TRUE
	use_external_power = ENERGY_GUN_EXTERNAL_CHARGE

/obj/item/gun/energy/laser/retro/empty
	cell_type = null

/obj/item/gun/energy/laser/alien
	name = "alien pistol"
	desc = "A weapon that works very similarly to a traditional energy weapon. How this came to be will likely be a mystery for the ages."
	icon_state = "alienpistol"
	item_state = "alienpistol"
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/alien // Self charges.
	origin_tech = list(TECH_COMBAT = 8, TECH_MAGNET = 7)

/obj/item/gun/energy/captain
	name = "antique laser gun"
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "A rare weapon, handcrafted by a now defunct specialty manufacturer on Luna for a small fortune. It's certainly aged well."
	force = 5
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	origin_tech = null
	cell_type = /obj/item/weapon/cell/device/weapon/recharge/captain
	removeable_battery = FALSE

/obj/item/gun/energy/lasercannon
	name = "laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron \
	flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	removable_battery = FALSE
	w_class = ITEMSIZE_LARGE
	firemodes = /datum/firemode/energy/laser/cannon

/obj/item/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = TRUE
	use_external_cell = ENERGY_GUN_EXTERNAL_CHARGE
	recharge_time = 10

/obj/item/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts, which are able to penetrate matter easier than \
	standard photonic beams, resulting in an effective 'anti-armor' energy weapon."
	icon_state = "xray"
	item_state = "xray"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	firemodes = /datum/firemode/energy/laser/xray

////////Laser Tag////////////////////

/obj/item/gun/energy/lasertag
	name = "laser tag gun"
	item_state = "laser"
	desc = "Standard issue weapon of the Imperial Guard"
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	firemodes = /datum/firemode/energy/lasertag
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	removable_battery = FALSE
	var/required_vest

/obj/item/gun/energy/lasertag/special_check(mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, "<span class='warning'>You need to be wearing your laser tag vest!</span>")
			return FALSE
	return ..()

/obj/item/gun/energy/lasertag/blue
	icon_state = "bluetag"
	item_state = "bluetag"
	firemodes = /datum/firemode/energy/lasertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/gun/energy/lasertag/red
	icon_state = "redtag"
	item_state = "redtag"
	firemodes = /datum/firemode/energy/lasertag/red
	required_vest = /obj/item/clothing/suit/redtag
