// PLASMEME SUITS, PROBABLY SHITCODE

/obj/item/clothing/suit/space/plasman
	name = "Phoronoid containment suit"
	icon = 'modular_citadel/icons/obj/plasmeme/suits.dmi'
	icon_state = "plasmaman_suit"
	icon_override = 'modular_citadel/icons/mob/plasmeme/suit.dmi'
	desc = "A suit designed to keep Phoronoids from coming into contact with oxygen, and promptly becoming a torch."
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	allowed = list(/obj/item/weapon/tank)

/obj/item/clothing/head/helmet/space/plasman
	name = "Phoronoid containtment helmet"
	icon = 'modular_citadel/icons/obj/plasmeme/hats.dmi'
	icon_state = "plasmaman_helmet0"
	icon_override = 'modular_citadel/icons/mob/plasmeme/helmet.dmi'
	desc = "A helmet to go with the phoronoid containment suit. Please wear this if you happen to be a phoronoid."
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)