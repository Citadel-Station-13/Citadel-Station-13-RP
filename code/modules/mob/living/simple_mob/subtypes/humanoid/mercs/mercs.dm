///////////////////////////////
//		Merc Mobs Go Here
///////////////////////////////

// Probably shouldn't use this directly, there are a bunch of sub-classes that are more complete.
/mob/living/simple_mob/humanoid/merc
	name = "mercenary"
	desc = "A tough looking individual armed with only a knife."
	tt_desc = "E Homo sapiens"
	icon = 'icons/mob/merc.dmi'
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"

	faction = "syndicate"
	movement_cooldown = 2 // Come On they are in a fight. They could pick up the pace a bit.

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15		//Tac Knife damage
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 100)	// Same armor values as the vest they drop, plus simple mob immunities

	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier
	loot_list = list(/obj/item/material/knife/tacknife = 100)	// Might as well give it the knife

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/merc

	// Grenade special attack vars
	var/grenade_type = /obj/item/grenade/concussion
	special_attack_cooldown = 45 SECONDS
	special_attack_min_range = 2
	special_attack_max_range = 7

////////////////////////////////
//		Grenade Attack
////////////////////////////////

// Any merc can use this, just set special_attack_charges to a positive value

// Check if we should bother with the grenade
/mob/living/simple_mob/humanoid/merc/should_special_attack(atom/A)
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
/mob/living/simple_mob/humanoid/merc/do_special_attack(atom/A)
	set waitfor = FALSE
	set_AI_busy(TRUE)

	var/obj/item/grenade/G = new grenade_type(get_turf(src))
	if(istype(G))
		G.throw_at(A, G.throw_range, G.throw_speed, src)
		G.attack_self(src)
		special_attack_charges = max(special_attack_charges-1, 0)

	set_AI_busy(FALSE)


////////////////////////////////
//		Merc AI Types
////////////////////////////////
/datum/ai_holder/simple_mob/merc
	threaten = TRUE
	returns_home = TRUE		// Stay close to the base...
	wander = TRUE			// ... but "patrol" a little.
	threaten_delay = 3 

/datum/ai_holder/simple_mob/merc/ranged
	pointblank = TRUE		// They get close? Just shoot 'em!
	firing_lanes = TRUE		// But not your buddies!
	conserve_ammo = TRUE	// And don't go wasting bullets!

/datum/ai_holder/simple_mob/merc/ranged/surpressor
	conserve_ammo = FALSE //For Surpressive Fire Mercs like the Heavy and Tommy-Las


////////////////////////////////
//			Melee
////////////////////////////////
/mob/living/simple_mob/humanoid/merc/melee	// Defined in case we add non-sword-and-board mercs
	loot_list = list(/obj/item/material/knife/tacknife = 100)

// Sword and Shield Merc
/mob/living/simple_mob/humanoid/merc/melee/sword
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"

	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed")

	loot_list = list(/obj/item/melee/energy/sword = 100, /obj/item/shield/energy = 100)

// They have a shield, so they try to block
/mob/living/simple_mob/humanoid/merc/melee/sword/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(20))
			visible_message("<span class='danger'>\The [src] blocks \the [O] with its shield!</span>")
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_mob/humanoid/merc/melee/sword/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(35))
		visible_message("<font color='red'><B>[src] blocks [Proj] with its shield!</B></font>")
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()


////////////////////////////////
//			Ranged
////////////////////////////////

// Base Ranged Merc, so we don't have to redefine a million vars for every subtype. Uses a pistol.
/mob/living/simple_mob/humanoid/merc/ranged
	name = "mercenary"
	desc = "A tough looking individual armed with an pistol."
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	projectiletype = /obj/item/projectile/bullet/pistol/medium
//	casingtype = /obj/item/ammo_casing/spent	//Makes infinite stacks of bullets when put in PoIs.
	projectilesound = 'sound/weapons/Gunshot_light.ogg'
	loot_list = list(/obj/item/gun/projectile/colt = 100)

	needs_reload = TRUE
	reload_max = 7		// Not the best default, but it fits the pistol
	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged

// C20r SMG
/mob/living/simple_mob/humanoid/merc/ranged/smg
	name = "mercenary soldier"
	desc = "A tough looking individual armed with an submachine gun."
	icon_state = "syndicateranged_smg"
	icon_living = "syndicateranged_smg"

	loot_list = list(/obj/item/gun/projectile/automatic/c20r = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged/surpressor

	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

/mob/living/simple_mob/humanoid/merc/ranged/smg/sol
	icon_state = "bluforranged_smg"
	icon_living = "blueforranged_smg"

	corpse = /obj/effect/landmark/mobcorpse/solarpeacekeeper
	loot_list = list(/obj/item/gun/projectile/automatic/c20r = 100)

	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

// Laser Rifle
/mob/living/simple_mob/humanoid/merc/ranged/laser
	name = "mercenary marksman"
	desc = "A tough looking individual armed with an laser rifle."
	icon_state = "syndicateranged_laser"
	icon_living = "syndicateranged_laser"
	projectiletype = /obj/item/projectile/beam/midlaser
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/gun/energy/laser = 100)

	reload_max = 10

// Ion Rifle
/mob/living/simple_mob/humanoid/merc/ranged/ionrifle
	name = "mercenary anti-technical"
	desc = "A tough looking individual armed with an ion rifle."
	icon_state = "syndicateranged_ionrifle"
	icon_living = "syndicateranged_ionrifle"
	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/gun/energy/ionrifle = 100)

	reload_max = 10

//Garand
/mob/living/simple_mob/humanoid/merc/ranged/garand
	name = "mercenary rifleman"
	desc = "A tough looking individual armed with a semiautomatic rifle."
	icon_state = "syndicateranged_veteran"
	icon_living = "syndicateranged_veteran"
	projectiletype = /obj/item/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/Gunshot_heavy.ogg'

	loot_list = list(/obj/item/gun/projectile/garand = 100)

	reload_max = 8
	reload_time = 2 // It takes a bit to jam a stripper clip into the rifle.

//Hand Cannon
/mob/living/simple_mob/humanoid/merc/ranged/deagle
	name = "mercenary officer"
	desc = "A tough looking individual armed with an handcannon."
	icon_state = "syndicate_handcannon"
	icon_living = "syndicate_handcannon"
	projectiletype = /obj/item/projectile/bullet/pistol/strong
	projectilesound = 'sound/weapons/Gunshot_deagle.ogg'
	loot_list = list(/obj/item/gun/projectile/deagle = 100)

	needs_reload = TRUE
	reload_max = 7		// Deagle Reload

// Grenadier, Basically a miniboss,
/mob/living/simple_mob/humanoid/merc/ranged/grenadier
	name = "mercenary grenadier"
	desc = "A tough looking individual armed with a shotgun and a belt of grenades."
	icon_state = "syndicateranged_shotgun"
	icon_living = "syndicateranged_shotgun"
	projectiletype = /obj/item/projectile/bullet/pellet/shotgun		// Buckshot
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	loot_list = list(/obj/item/gun/projectile/shotgun/pump = 100)

	reload_max = 4
	reload_time = 1.5 SECONDS	// It's a shotgun, it takes a moment

	special_attack_charges = 5


////////////////////////////////
//		Space Mercs
////////////////////////////////

// Sword Space Merc
/mob/living/simple_mob/humanoid/merc/melee/sword/space
	name = "mercenary commando"
	desc = "A tough looking individual, armred with an energy sword and shield."
	icon_state = "syndicatespace-melee"
	icon_living = "syndicatespace-melee"

	movement_cooldown = 0

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

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

/mob/living/simple_mob/humanoid/merc/melee/sword/space/Process_Spacemove(var/check_drift = 0)
	return

// Ranged Space Merc
/mob/living/simple_mob/humanoid/merc/ranged/space
	name = "armored mercenary"
	desc = "A tough looking individual, armed with a submachine gun."
	icon_state = "syndicatespace-ranged"
	icon_living = "syndicatespceace-ranged"

	movement_cooldown = 0

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

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 20

	loot_list = list(/obj/item/gun/projectile/automatic/c20r = 100)

/mob/living/simple_mob/humanoid/merc/ranged/space/Process_Spacemove(var/check_drift = 0)
	return

//Combat Shotgun Merc
/mob/living/simple_mob/humanoid/merc/ranged/space/shotgun
	name = "mercenary tactical"
	desc = "A tough looking individual armed with a combat shotgun."
	icon_state = "syndicatespace-shotgun"
	icon_living = "syndicatespace-shotgun"

	base_attack_cooldown = 10
	reload_max = 7
	reload_time = 2 SECONDS //Takes a While to load all those shells.

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun		// Buckshot
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	loot_list = list(/obj/item/gun/projectile/shotgun/pump/combat = 100)

//Auto-Shotgun Space Merc
/mob/living/simple_mob/humanoid/merc/ranged/space/shotgun/auto
	name = "mercenary sweeper"
	desc = "A tough looking individual armed with an automatic shotgun."
	icon_state = "syndicatespace-ashotgun"
	icon_living = "syndicatespace-ashotgun"

	base_attack_cooldown = 5 // Two attacks a second or so.
	reload_max = 24

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun		// Buckshot
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	loot_list = list(/obj/item/gun/projectile/automatic/as24 = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged/surpressor

//Machine Gun Merc
/mob/living/simple_mob/humanoid/merc/ranged/space/heavy
	name = "mercenary heavy gunner"
	desc = "A tough looking individual armed with an light machinegun."
	icon_state = "syndicatespace-heavy"
	icon_living = "syndicatespace-heavy"

	base_attack_cooldown = 2.5 // Four Attacks a Second. MOAR DAKKA
	reload_max = 50

	projectiletype = /obj/item/projectile/bullet/rifle/a545
	projectilesound = 'sound/weapons/Gunshot_light.ogg'

	loot_list = list(/obj/item/gun/projectile/automatic/l6_saw = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged/surpressor

//Tommy-Las Merc
/mob/living/simple_mob/humanoid/merc/ranged/space/tommylas
	name = "mercenary light burster"
	desc = "A tough looking individual armed with an automatic laser."
	icon_state = "syndicatespace-tommylas"
	icon_living = "syndicatespace-tommylas"

	base_attack_cooldown = 2.5 // Four Attacks a Second. MOAR DAKKA
	reload_max = 3
	reload_time = 0.5  // Meant to Simulate controlled Supressive Bursts

	projectiletype = /obj/item/projectile/beam/weaklaser
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/gun/energy/tommylaser = 100)

	ai_holder_type = /datum/ai_holder/simple_mob/merc/ranged/surpressor

/mob/living/simple_mob/humanoid/merc/ranged/space/fal
	name = "mercenary commando"
	desc = "A tough looking individual armed with a assault rifle."
	icon_state = "syndicatespace-commando"
	icon_living = "syndicatespace-commando"
	projectiletype = /obj/item/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/Gunshot_heavy.ogg'

	loot_list = list(/obj/item/gun/projectile/automatic/fal = 100)

	reload_max = 20

////////////////////////////////
//			PoI Mercs
////////////////////////////////

// None of these drop weapons, until we have a better way to balance them
/mob/living/simple_mob/humanoid/merc/melee/poi
	loot_list = list()

/mob/living/simple_mob/humanoid/merc/melee/sword/poi
	loot_list = list()

/mob/living/simple_mob/humanoid/merc/ranged/poi
	loot_list = list()

/mob/living/simple_mob/humanoid/merc/ranged/smg/poi
	loot_list = list()

/mob/living/simple_mob/humanoid/merc/ranged/laser/poi
	loot_list = list()

/mob/living/simple_mob/humanoid/merc/ranged/ionrifle
	loot_list = list()

/mob/living/simple_mob/humanoid/merc/ranged/grenadier/poi
	loot_list = list()

////////////////////////////////
//			Vox Pirates
////////////////////////////////
//Classifying these as Mercs, due to the general power level I want them at.

/mob/living/simple_mob/humanoid/merc/voxpirate
	name = "vox pirate"
	desc = "A desperate looking Vox. Get your gun."
	icon = 'icons/mob/animal.dmi'
	icon_state = "voxpirate"
	icon_living = "voxpirate"
	icon_dead = "voxpirate_dead"

	faction = "voxpirate"
	movement_cooldown = 4

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 20		//Vox Hunting rifle blade damage
	melee_damage_upper = 20
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 100)	// Matching Merc voidsuit stats to represent toughness.

	projectiletype = /obj/item/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/riflebolt.ogg'
	needs_reload = TRUE
	reload_max = 20

	min_oxy = 0 //Vox are spaceproof.
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	corpse = /obj/effect/landmark/mobcorpse/vox/pirate
	loot_list = list(/obj/item/gun/projectile/shotgun/pump/rifle/vox_hunting = 100,
					/obj/item/ammo_magazine/clip/c762 = 30,
					/obj/item/ammo_magazine/clip/c762 = 30
					)

	ai_holder_type = /datum/ai_holder/simple_mob/merc
	say_list_type = /datum/say_list/merc/voxpirate

/mob/living/simple_mob/humanoid/merc/voxpirate/boarder
	name = "vox melee boarder"
	desc = "A howling Vox with a sword. Run."
	icon_state = "voxboarder_m"
	icon_living = "voxboarder_m"
	icon_dead = "voxboarder_m_dead"

	melee_damage_lower = 30		//Energy sword damage
	melee_damage_upper = 30
	attack_sharp = 1
	attack_edge = 1

	corpse = /obj/effect/landmark/mobcorpse/vox/boarder_m
	loot_list = list(/obj/item/melee/energy/sword = 100)

// They're good with the swords? I dunno. I like the idea they can deflect.
/mob/living/simple_mob/humanoid/merc/voxpirate/boarder/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(20))
			visible_message("<span class='danger'>\The [src] blocks \the [O] with its sword!</span>")
			if(user)
				ai_holder.react_to_attack(user)
			return
		else
			..()
	else
		to_chat(user, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_mob/humanoid/merc/voxpirate/boarder/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(35))
		visible_message("<font color='red'><B>[src] blocks [Proj] with its sword!</B></font>")
		if(Proj.firer)
			ai_holder.react_to_attack(Proj.firer)
		return
	else
		..()

	ai_holder_type = /datum/ai_holder/simple_mob/merc

////////////////////////////////
//			Vox Ranged
////////////////////////////////

/mob/living/simple_mob/humanoid/merc/voxpirate/ranged/boarder
	name = "vox ranged boarder"
	desc = "A howling Vox with a shotgun. Get to cover!"
	icon_state = "voxboarder_r"
	icon_living = "voxboarder_r"
	icon_dead = "voxboarder_r_dead"

	projectiletype = /obj/item/projectile/bullet/pellet/shotgun
	projectilesound = 'sound/weapons/Gunshot_shotgun.ogg'

	corpse = /obj/effect/landmark/mobcorpse/vox/boarder_r
	loot_list = list(/obj/item/gun/projectile/shotgun/pump/combat = 100,
					/obj/item/ammo_magazine/m12gdrum = 30,
					/obj/item/ammo_magazine/m12gdrum = 30
					)

	needs_reload = TRUE
	reload_max = 10

/mob/living/simple_mob/humanoid/merc/voxpirate/ranged/suppressor
	name = "vox suppressor"
	desc = "Come on, feel the noise!"
	icon_state = "voxsuppressor"
	icon_living = "voxsuppressor"
	icon_dead = "voxsuppresor_dead"

	armor = list(melee = 30, bullet = 50, laser = 60, energy = 30, bomb = 35, bio = 100, rad = 100)	// Boosted armor to represent Tank role.

	projectiletype = /obj/item/projectile/sonic/weak
	projectilesound = 'sound/effects/basscannon.ogg'

	corpse = /obj/effect/landmark/mobcorpse/vox/suppressor
	loot_list = list(/obj/item/gun/energy/sonic = 100)

	base_attack_cooldown = 5 // Two attacks a second or so.
	needs_reload = TRUE
	reload_max = 25 //Gotta lay down that fire, son.

/mob/living/simple_mob/humanoid/merc/voxpirate/ranged/captain
	name = "vox pirate captain"
	desc = "Walkings the plank, dustlung! Yayaya."
	icon_state = "voxcaptain"
	icon_living = "voxcaptain"
	icon_dead = "voxcaptain_dead"

	armor = list(melee = 60, bullet = 50, laser = 40, energy = 15, bomb = 30, bio = 100, rad = 100)	// Vox RIG armor values.

	projectiletype = /obj/item/projectile/energy/darkmatter
	projectilesound = 'sound/weapons/eLuger.ogg'

	corpse = /obj/effect/landmark/mobcorpse/vox/captain
	loot_list = list(/obj/item/gun/energy/darkmatter = 100)

	needs_reload = TRUE
	reload_max = 10 //Other Vox should be carrying ammo.

