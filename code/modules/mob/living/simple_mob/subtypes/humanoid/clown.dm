/datum/category_item/catalogue/fauna/clown
	name = "Clown"
	desc = "The Clown is truly a galactic phenomenon. Those who travel to \
	Clown Planet to train in the comedic arts sometimes undergo a curious \
	revelation. Becoming fully devoted to the Honkmother, these fantatical \
	jesters roam the Frontier on missions of mayhem and hilarity. Just because \
	they're smiling, it doesn't mean they aren't deadly. Watch where you step."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/clown)

// Obtained by scanning all X.
/datum/category_item/catalogue/fauna/all_clowns
	name = "Collection - Clowns"
	desc = "You have scanned a large array of different types of clown, \
	and therefore you have been granted a large sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_HARD
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/clown,
		/datum/category_item/catalogue/fauna/clown/commando
		)

/mob/living/simple_mob/humanoid/clown
	name = "clown"
	desc = "A denizen of clown planet."
	tt_desc = "E Homo sapiens corydon" //this is an actual Clown, as opposed to someone dressed up as one
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "clown_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/clown)

	faction = "clown"

	loot_list = list(/obj/item/bikehorn = 100)

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 8
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = list("attacked")
	attack_sound = 'sound/items/bikehorn.ogg'

	say_list_type = /datum/say_list/clown

/datum/say_list/clown
	speak = list("HONK", "Honk!", "Welcome to clown planet!")
	emote_see = list("honks")

/mob/living/simple_mob/humanoid/clown/prankster
	name = "clown"
	desc = "A denizen of clown planet. I wonder if that's a real gun."

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting

	projectiletype = /obj/item/projectile/bullet/honker
	projectilesound = 'sound/items/bikehorn.ogg'
	needs_reload = FALSE

////////////////////////////////
//		Honk Ops
////////////////////////////////

/datum/category_item/catalogue/fauna/clown/commando
	name = "Clown - Commando"
	desc = "The ongoing aggression between the states of Columbina and La Rien \
	may have begun to simmer down in recent years, but both sides still seek to \
	protect their interests across the Galaxy. Many veterans of the War, their \
	loyalty to Columbina and the Honkmother proven, are trained in a variety of \
	the College's most advanced pranks. These Commandos are frequently dispatched \
	to disrupt Vaudium smuggling operations, or to combat the agents of La Rien \
	wherever the fighting is most amusing. Do not mistake their garish appearnce \
	for foolishness."

// Debug variant.
/mob/living/simple_mob/humanoid/clown/commando
	name = "clown commando"
	desc = "A brightly adorned clown armed with a strange blade."
	icon_state = "clownop"
	icon_living = "clownop"
	icon_dead = "clownop_dead"
	icon_gib = "clown_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/clown/commando)

	movement_cooldown = 2

	status_flags = 0

	response_help = "bonks"
	response_disarm = "trips"
	response_harm = "wallops"

	harm_intent_damage = 5
	melee_damage_lower = 15		//Tac Knife damage
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 35, bomb = 30, bio = 100, rad = 100)	// Same armor values as the vest they drop, plus simple mob immunities

	corpse = /atom/movable/spawner/corpse/clown/clownop
	loot_list = list(/obj/item/melee/clownop = 100)	// Might as well give it the knife

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/clownop

	// Grenade special attack vars
	var/grenade_type = /obj/item/grenade/chem_grenade/lube_tactical
	var/grenade_timer = 50
	special_attack_cooldown = 45 SECONDS
	special_attack_min_range = 2
	special_attack_max_range = 7
	special_attack_charges = 3

//Clown Op Saylists
/datum/say_list/clownop
	speak = list("Why did the Teshari cross the road?",
				"Knock knock.",
				"Honk!",
				"If he slips me again, I'm gonna prank him really good.",
				"I need to add more shoes to my collection.")
	emote_see = list("honks their nose", "giggles", "adjusts their suspenders", "looks around", "fusses with their wig")

	say_understood = list("Copy-dopy!", "Ahuh!")
	say_cannot = list("Not gonna!")
	say_maybe_target = list("Who's there?")
	say_got_target = list("Honk!")
	say_threaten = list("We're closed!", "Do I amuse you?")
	say_stand_down = list("Ha ha.")
	say_escalate = list("Prepare to get pranked!", "You're about to be tripping!")
	threaten_sound = 'sound/items/bikehorn.ogg'
	stand_down_sound = 'sound/effects/splat.ogg'

////////////////////////////////
//		Grenade Attack
////////////////////////////////

// Any merc can use this, just set special_attack_charges to a positive value

// Check if we should bother with the grenade
/mob/living/simple_mob/humanoid/clown/commando/should_special_attack(atom/A)
	var/mob_count = 0				// Are there enough mobs to consider grenading?
	var/turf/T = get_turf(A)
	for(var/mob/M in range(T, 2))
		if(M.faction == faction) 	// Don't grenade our friends
			return FALSE
		if(M in oview(src, special_attack_max_range))	// And lets check if we can actually see at least two people before we throw a grenade
			if(!M.stat)			// Dead things don't warrant a grenade
				mob_count ++
	if(mob_count < 2)
		return FALSE
	else
		return TRUE

// Yes? Throw the grenade
/mob/living/simple_mob/humanoid/clown/commando/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	var/obj/item/grenade/G = new grenade_type(get_turf(src))
	if(istype(G))
		G.throw_at(A, G.throw_range, G.throw_speed, src)
		G.det_time = grenade_timer
		G.activate(src)
		special_attack_charges = max(special_attack_charges-1, 0)

	set_AI_busy(FALSE)

// The actual Op mobs.

//Melee

/mob/living/simple_mob/humanoid/clown/commando/melee
	icon_state = "clownop_melee"
	icon_living = "clownop_melee"
	loot_list = list(/obj/item/melee/clownop = 100)

//Ranged

/mob/living/simple_mob/humanoid/clown/commando/ranged // Basic pistol mob.
	desc = "A brightly adorned clown armed with a weird pistol."
	icon_state = "clownop_ranged"
	icon_living = "clownop_ranged"
	projectiletype = /obj/item/projectile/bullet/honker/lethal
	projectilesound = 'sound/items/bikehorn.ogg'
	needs_reload = TRUE
	reload_max = 12
	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged
	loot_list = list(/obj/item/gun/projectile/clown_pistol = 100,
					/obj/item/ammo_magazine/mcompressedbio = 30,
					/obj/item/ammo_magazine/mcompressedbio = 30
					)

//Voidsuit Variants

/datum/category_item/catalogue/fauna/clown/commando/space
	name = "Clown - Operative"
	desc = "The most elite Commandos serving Columbina have come to be known as \
	'Clown Operatives', though they are also referred to as 'Honk Ops'. Deadly, \
	and often comically dressed, these operatives utilize modified Gorlex pattern \
	suits, lending an imposing air to their outlandish color scheme. They are very \
	capable fighters, having served in the ongoing conflict against La Rien for \
	decades. Outside of the Church, there are none more faithful to the Honkmother \
	and her cause."

/mob/living/simple_mob/humanoid/clown/commando/melee/space
	desc = "A heavily armored clown, wielding a deadly looking sword."
	icon_state = "clownop_space_melee"
	icon_living = "clownop_space_melee"
	catalogue_data = list(/datum/category_item/catalogue/fauna/clown/commando/space)

	movement_cooldown = 0

	harm_intent_damage = 5
	melee_damage_lower = 30		//Tac Knife damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 100)	// Same armor as their voidsuit

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	corpse = /atom/movable/spawner/corpse/clown/clownop/space
	loot_list = list(/obj/item/melee/clownstaff = 100)

/mob/living/simple_mob/humanoid/clown/commando/melee/space/Process_Spacemove(var/check_drift = 0)
	return

/mob/living/simple_mob/humanoid/clown/commando/melee/space/alt
	icon_state = "clownop_space_alt_melee"
	icon_living = "clownop_space_alt_melee"
	corpse = /atom/movable/spawner/corpse/clown/clownop/space/alt

// Ranged Space Clown
/mob/living/simple_mob/humanoid/clown/commando/ranged/space
	desc = "A heavily armored clown, armed with a dangerous looking gun."
	icon_state = "clownop_space_ranged"
	icon_living = "clownop_space_ranged"
	catalogue_data = list(/datum/category_item/catalogue/fauna/clown/commando/space)

	movement_cooldown = 0

	reload_max = 20
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 100)	// Same armor as their voidsuit. This should already have been here when polaris patched these guys in.

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	corpse = /atom/movable/spawner/corpse/clown/clownop/space
	loot_list = list(/obj/item/gun/projectile/automatic/clown_rifle = 100,
					/obj/item/ammo_magazine/mcompressedbio/large/banana = 30,
					/obj/item/ammo_magazine/mcompressedbio/large/banana = 30
					)

	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

/mob/living/simple_mob/humanoid/clown/commando/ranged/space/Process_Spacemove(var/check_drift = 0)
	return

/mob/living/simple_mob/humanoid/clown/commando/ranged/space/alt
	icon_state = "clownop_space_alt_ranged"
	icon_living = "clownop_space_alt_ranged"
	corpse = /atom/movable/spawner/corpse/clown/clownop/space/alt
