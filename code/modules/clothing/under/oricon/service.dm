/obj/item/clothing/under/oricon/service
	name = "service uniform"
	icon = 'icons/clothing/uniform/rank/service.dmi'
	desc = "A service uniform of some kind."
	icon_state = "white"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 5, rad = 0)
	siemens_coefficient = 0.9
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL | WORN_RENDER_INHAND_NO_RENDER
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/service/fleet
	name = "fleet service uniform"
	desc = "The service uniform of the JSDF Fleet, made from immaculate white fabric."
	icon_state = "white"
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/service/marine
	name = "marine service uniform"
	desc = "The service uniform of the JSDF Marine Corps. Slimming."
	icon_state = "green"
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL

/obj/item/clothing/under/oricon/service/marine/command
	name = "marine command service uniform"
	desc = "The service uniform of the JSDF Marine Corps. Slimming and stylish."
	icon_state = "green_command"
	worn_has_rollsleeve = UNIFORM_HAS_ROLL
	worn_has_rolldown = UNIFORM_HAS_NO_ROLL
