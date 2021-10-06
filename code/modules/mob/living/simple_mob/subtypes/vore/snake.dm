/datum/category_item/catalogue/fauna/giant_snake
	name = "Snake"
	desc = "An Earth reptile with a distinct lack of limbs, \
	snakes ambulate by slithering across the ground. Snakes \
	possess a wide variety of colorations and patterns, and are \
	sometimes owned as pets by enthusiasts. Many are venemous, \
	although there are harmless species, as well as species which \
	consume their prey via more specific techniques, such as \
	constriction."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/aggressive/giant_snake
	name = "giant snake"
	desc = "Snakes. Why did it have to be snakes?"
	catalogue_data = list(/datum/category_item/catalogue/fauna/giant_snake)

	icon_dead = "snake-dead"
	icon_living = "snake"
	icon_state = "snake"
	icon = 'icons/mob/vore64x64.dmi'

	faction = "snake"

	old_x = -16
	old_y = -16
	default_pixel_x = -16
	default_pixel_y = -16
	pixel_x = -16
	pixel_y = -16

	ai_holder_type = /datum/ai_holder/simple_mob/melee

//Randomization Code
/mob/living/simple_mob/vore/aggressive/giant_snake/Initialize()
    . = ..()
    var/mod = rand(50,150)/100
    size_multiplier = mod
    maxHealth = round(200*mod)
    health = round(200*mod)
    melee_damage_lower = round(5*mod)
    melee_damage_upper = round(12*mod)
    movement_cooldown = round(5*mod)
    update_icons()

// Activate Noms!
/mob/living/simple_mob/vore/aggressive/giant_snake
	vore_active = 1
	vore_pounce_chance = 25
	vore_icons = SA_ICON_LIVING
	swallowTime = 2 SECONDS // Hungry little bastards.
