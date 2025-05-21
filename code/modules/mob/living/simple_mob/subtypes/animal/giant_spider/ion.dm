/mob/living/simple_mob/animal/giant_spider/ion
	desc = "Furry and green, it makes you shudder to look at it. This one has brilliant green eyes and a hint of static discharge."
	tt_desc = "X Brachypelma phorus ionus"
	icon_state = "webslinger"
	icon_living = "webslinger"
	icon_dead = "webslinger_dead"

	maxHealth = 90
	health = 90

	base_attack_cooldown = 15
	projectilesound = 'sound/weapons/taser2.ogg'
	projectiletype = /obj/projectile/ion/pistol

	legacy_melee_damage_lower = 8
	legacy_melee_damage_upper = 15

	poison_chance = 15
	poison_per_bite = 2
	poison_type = "psilocybin"

	exotic_type = /obj/item/reagent_containers/glass/venomgland/spider/psilocybin

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/electric_spider

/obj/item/reagent_containers/glass/venomgland/spider/psilocybin
	name = "Trippy Venom Gland"
	desc = "A sac full of venom. It makes you feel funny when you sniff it."

/obj/item/reagent_containers/glass/venomgland/spider/psilocybin/Initialize(mapload)
	. = ..()
	reagents.add_reagent("psilocybin", 15)
