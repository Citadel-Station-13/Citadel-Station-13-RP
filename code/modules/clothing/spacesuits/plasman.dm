// PLASMEME SUITS, PROBABLY SHITCODE

/obj/item/clothing/suit/space/plasman
	name = "Phoronoid containment suit"
	icon = 'modular_citadel/icons/obj/plasmeme/suits.dmi'
	icon_state = "plasmaman_suit"
	icon_override = 'modular_citadel/icons/mob/plasmeme/suit.dmi'
	desc = "A suit designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. Seems like it doesn't protect from much else."
	slowdown = 1
	item_flags = STOPPRESSUREDAMAGE | AIRTIGHT
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	allowed = list(/obj/item/weapon/tank)

/obj/item/clothing/head/helmet/space/plasman
	name = "Phoronoid containtment helmet"
	icon = 'modular_citadel/icons/obj/plasmeme/hats.dmi'
	icon_state = "plasmaman_helmet"
	icon_override = 'modular_citadel/icons/mob/plasmeme/helmet.dmi'
	desc = "A helmet designed by NT to keep phoronoids from coming into contact with incompatible atmosphere. Comes with a little light built in!"
	item_flags = STOPPRESSUREDAMAGE | AIRTIGHT | FLEXIBLEMATERIAL
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	light_overlay = "plasmaman_overlay"