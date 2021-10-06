/mob/living/simple_mob/animal/giant_spider/electric
	base_attack_cooldown = 15

/mob/living/simple_mob/animal/giant_spider/webslinger
	base_attack_cooldown = 15

// Slightly placeholder, mostly to replace ion hivebots on V4
/mob/living/simple_mob/animal/giant_spider/ion
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes and a hint of static discharge."
	tt_desc = "X Brachypelma phorus ionus"
	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"

	base_attack_cooldown = 15
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/item/projectile/ion/pistol

	poison_chance = 15
	poison_per_bite = 2
	poison_type = "psilocybin"

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/electric_spider

//Randomization Code
/mob/living/simple_mob/animal/giant_spider/ion/Initialize()
    . = ..()
    var/mod = rand(50,150)/100
    size_multiplier = mod
    maxHealth = round(90*mod)
    health = round(90*mod)
    melee_damage_lower = round(8*mod)
    melee_damage_upper = round(15*mod)
    movement_cooldown = round(10*mod)
    update_icons()

//Lost to AI refactor, returning champion of arachnophobe horror, Spider Queen
/mob/living/simple_mob/animal/giant_spider/nurse/queen
	name = "giant spider queen"
	desc = "Absolutely gigantic, this creature is horror itself."
	tt_desc = "X Brachypelma phorus tyrannus"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "spider_queen"
	icon_living = "spider_queen"
	icon_dead = "spider_queen_dead"

	attack_armor_pen = 25

	pixel_x = -16
	pixel_y = -16
	old_x = -16
	old_y = -16

//Randomization Code
/mob/living/simple_mob/animal/giant_spider/nurse/queen/Initialize()
    . = ..()
    var/mod = rand(50,150)/100
    size_multiplier = mod
    maxHealth = round(320*mod)
    health = round(320*mod)
    melee_damage_lower = round(20*mod)
    melee_damage_upper = round(30*mod)
    movement_cooldown = round(10*mod)
    update_icons()
