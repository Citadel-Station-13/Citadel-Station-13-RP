// Thermal suit armor

/obj/item/clothing/accessory/armor/armorplate/thermal_light
	name = "light armor insert kit"
	desc = "A kit of basic kevlar inserts. The inserts are light and flexible enough as to not impede movement. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 10, bomb = 25, bio = 0, rad = 40)
	slot = ACCESSORY_SLOT_ARMOR_C

/obj/item/clothing/accessory/armor/armorplate/thermal_medium
	name = "medium armor insert kit"
	desc = "A kit of plasteel-reinforced synthetic inserts. The inserts aren't flexible, but aren't too heavy either, installing these may only impede movement slightly. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 60)
	slot = ACCESSORY_SLOT_ARMOR_C
	slowdown = 0.25

/obj/item/clothing/accessory/armor/armorplate/thermal_heavy
	name = "heavy armor insert kit"
	desc = "A kit of plasteel-reinforced ceramic plates. The inserts are very heavy, thick, and not at all flexible. Installing these will impede movement a lot. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 40, bio = 0, rad = 60)
	slot = ACCESSORY_SLOT_ARMOR_C
	slowdown = 1

/obj/item/clothing/accessory/armor/armorplate/thermal_riot
	name = "blunt force insert kit"
	desc = "An advanced kit of shear thickening reactive armor and polymer inserts to specifically protect the user against blunt trauma. These inserts are flexible but somewhat hefty, installing these may only impede movement slightly. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 80, bullet = 20, laser = 10, energy = 10, bomb = 30, bio = 0, rad = 20)
	slot = ACCESSORY_SLOT_ARMOR_C
	slowdown = 0.25

/obj/item/clothing/accessory/armor/armorplate/thermal_bulletproof
	name = "bullet resistant insert kit"
	desc = "An advanced kit of shear thickening reactive armor and plasteel-reinforced synthetic weave inserts to specifically protect the user against bullet impacts and the resulting blunt force. These inserts are flexible but somewhat hefty, installing these may only impede movement slightly. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 20, bullet = 80, laser = 10, energy = 10, bomb = 30, bio = 0, rad = 20)
	slot = ACCESSORY_SLOT_ARMOR_C
	slowdown = 0.25

/obj/item/clothing/accessory/armor/armorplate/thermal_ablative
	name = "ablative insert kit"
	desc = "An advanced kit of ablative, heat dissipating reactive armor and light synthetic weave inserts to specifically protect the user against laser based weaponry and partially from incoming energy soureces. A warning label on the kit states that because of how the inserts are installed, it cannot reflect projectiles. The inserts are quite hefty and not at all flexible. Installing these will impede movement a fair bit. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 40, bomb = 10, bio = 0, rad = 20)
	slot = ACCESSORY_SLOT_ARMOR_C
	slowdown = 0.5

/obj/item/clothing/accessory/armor/armorplate/thermal_rad
	name = "CBRN insert kit"
	desc = "An advanced kit of chemical, biological, radiation, and nuclear agent resistant lining designed to protect your vitals at the very least. The lining is lightly armored, but mainly intended to protect the user from more hazardous environments. A voidsuit would probably be better. These inserts won't slow you down one bit. Inserts into a Hazardous Environment Suit."
	icon_state = "armor_kit"
	icon_override = null
	icon = 'maps/rift/icons/obj/rft_accessory.dmi'
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 15, bullet = 15, laser = 15, energy = 30, bomb = 30, bio = 20, rad = 90) // Doesn't protect the head.
	slot = ACCESSORY_SLOT_ARMOR_C