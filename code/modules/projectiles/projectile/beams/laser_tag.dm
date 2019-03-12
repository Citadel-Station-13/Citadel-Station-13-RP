/obj/item/projectile/beam/laser/lasertag
	name = "lasertag beam"
	no_attack_log = FALSE
	damage = 0
	nodamage = TRUE
	combustion = FALSE
	check_armour = ARMOR_LASER
	damage_type = BURN

/obj/item/projectile/beam/laser/lasertag/blue
	name = "blue lasertag beam"
	color = COLOR_BLUE

/obj/item/projectile/beam/laser/lasertag/blue/on_hit(atom/target, blocked = 0)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)

/obj/item/projectile/beam/laser/lasertag/red
	name = "red lasertag beam"
	color = COLOR_RED

/obj/item/projectile/beam/laser/lasertag/red/on_hit(var/atom/target, var/blocked = 0)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)

/obj/item/projectile/beam/laser/lasertag/omni//A laser tag bolt that stuns EVERYONE
	name = "omni lasertag beam"
	color = COLOR_CYAN

/obj/item/projectile/beam/laser/lasertag/omni/on_hit(var/atom/target, var/blocked = 0)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
