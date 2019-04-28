/mob/living/simple_animal/hostile/metalhead
	name = "metal-head"
	desc = "What happens when malware uploads to wetware."
	tt_desc = "E Homo sapiens"
	icon_state = "clown"
	icon_living = "clown"
	icon_dead = "clown_dead"
	icon_gib = "syndicate_gib" //Might keep this to save effort on making gib animation
	intelligence_level = SA_HUMANOID

	faction = "metalhead"
	maxHealth = 100
	health = 100
	speed = 4

	run_at_them = 1
	cooperative = 1
	investigates = 1
	firing_lines = 1
	returns_home = 1
	reacts = 1

	turns_per_move = 5
	stop_when_pulled = 0
	status_flags = CANPUSH

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 20
	environment_smash = 1
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "clawed")
	attack_sound = 'sound/weapons/slash.ogg'

	armor = list(melee = 30, bullet = 20, laser = 40, energy = 10, bomb = 10, bio = 100, rad = 100)	// Might adjust later.

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15

	speak_chance = 1
	speak = list("We are one.",
				"Useless flesh...",
				"Need upgrades...",
				"Power low, need recharge soon.",
				"Wish power core was bigger.",
				"Something not right...")
	emote_hear = list("sparks lightly","coughs","groans")
	emote_see = list("looks around","scratches their augments")
	say_understood = list()
	say_cannot = list()
	say_maybe_target = list("Something new here?","Who goes there?","Is that...?","That thing isn't...")
	say_got_target = list("Not us! Not us! Not us!","Kill the mutant!","Destroy it!","Destroy the monster!")
	reactions = list("Ready to engage?" = "Ready!")

	var/corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier // Likely the left over body when it dies, this will need to be tested before editing.
																	// Might be able to get away with doing nothing here.

/mob/living/simple_animal/hostile/syndicate/death()
	if(corpse)
		..()
		new corpse (src.loc)
	else
		..(0,"explodes!")
		new /obj/effect/gibspawner/human(src.loc)
		explosion(get_turf(src), -1, 0, 1, 3)
	qdel(src)
	return

/mob/living/simple_animal/hostile/syndicate/ranged/laser
	icon_state = "syndicateranged_laser"
	icon_living = "syndicateranged_laser"
	rapid = 0
	projectiletype = /obj/item/projectile/beam/midlaser
	projectilesound = 'sound/weapons/Laser.ogg'


/mob/living/simple_animal/hostile/syndicate/ranged/ionrifle
	icon_state = "syndicateranged_ionrifle"
	icon_living = "syndicateranged_ionrifle"
	rapid = 0
	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'

	return