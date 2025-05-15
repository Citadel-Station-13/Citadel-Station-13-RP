///////////////////////////////
//		Tajara Mercs
///////////////////////////////

/datum/category_item/catalogue/fauna/taj_guerilla
	name = "Tajara Guerillas"
	desc = "The ongoing cold war between on Adhomai is punctuated by proxy conflicts \
	that stretch into the frontier. The New Kingdom, Democratic Republic, and People's \
	Republic all make use of armed proxies to further their ends, equipping and \
	training revolutionaries, bandits, terrorists, and whoever else they can use against \
	their enemies with plausible deniability. Many of these organizations are reduced \
	to simple banditry and piracy once they become a political liability. Once cut off \
	these guerillas tend to spill out into the wider frontier to menace local settlers \
	and frontier corporations."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/taj_guerilla)


/mob/living/simple_mob/humanoid/taj_guerilla
	name = "random naked tajaran"
	desc = "This poor fella isn't even wearing pants. You should probably contact an admin something went wrong."
	tt_desc = "E Homo Felis Adhomai"
	icon = 'icons/mob/taj_guerilla.dmi'
	icon_state = "base"
	icon_living = "base"
	icon_dead = ""
	icon_gib = ""
	catalogue_data = list(/datum/category_item/catalogue/fauna/taj_guerilla)

	movement_base_speed = 10 / 1
	minbodytemp = 200

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "claws"

	harm_intent_damage = 5
	legacy_melee_damage_lower = 15		//Tac Knife damage
	legacy_melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")

	corpse = /obj/spawner/corpse/tajara

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc
	say_list_type = /datum/say_list/tajara


///////////////////////////////
//		Bandits
///////////////////////////////

/datum/category_item/catalogue/fauna/taj_guerilla/bandits
	name = "Tajara Bandits"
	desc = "The Nobles of the New Kingdom of Adhomai have both the financial resources \
	and legal right to have men under arms. These soldiers are under the sole command \
	of their noble unless orders come in from said noble's liege whether it is the King or \
	a higher noble. As such NKA nobles make judicious use of 'bandits' to do their \
	bidding beyond the New Kingdom's borders. Bolstering their ranks with conscripted \
	criminals and homeless peasants, these bandits often find themselves isolated on the \
	frontier when their liege cuts them off or when they decide to go into business for themselves."
	value = CATALOGUER_REWARD_TRIVIAL


/mob/living/simple_mob/humanoid/taj_guerilla/bandit
	name = "Tajara Bandit"
	desc = "An armored Tajara Warrior, seems he lost his weapon. He seems confident enough with his knife though."
	icon_state = "nka"
	icon_living = "nka"
	catalogue_data = list(/datum/category_item/catalogue/fauna/taj_guerilla/bandits)
	iff_factions = MOB_IFF_FACTION_TAJARA_NKA

	armor_type = list(/datum/armor/general/medieval/light)

	corpse = /obj/spawner/corpse/tajara/nka_soldier
	loot_list = list(/obj/item/material/knife/tacknife = 100)

	say_list_type = /datum/say_list/tajara/nka

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword
	name = "Tajara Bandit Freeblade"
	desc = "An armored Tajara swordsman, bringing a sword to a gunfight is only a bad idea until they reach melee distance."
	icon_state = "nka_freeblade"
	icon_living = "nka_freeblade"

	loot_list = list(/obj/item/material/sword/plasteel = 100)

	legacy_melee_damage_lower = 30
	legacy_melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed","cleaved","impaled")

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.damage_force)
		if(prob(50))
			visible_message("<span class='danger'>\The [src] parries \the [O] with its sword!</span>")
			if(user)
				ai_holder.react_to_attack_polaris(user)
			return
		else
			..()
	else
		to_chat(user, "<span class='warning'>This weapon is ineffective, it does no damage.</span>")
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	if(prob(10))
		visible_message("<span class='warning'>[src] deflects [proj] with its blade!</span>")
		if(proj.firer)
			ai_holder.react_to_attack_polaris(proj.firer)
		return PROJECTILE_IMPACT_BLOCKED
	return ..()

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/rifle
	name = "Tajara Bandit Rifleman"
	desc = "An armored Tajara with an old rifle. Sometimes you take what you can get and even old rifles can pierce armor."
	icon_state = "nka_rifleman"
	icon_living = "nka_rifleman"

	projectiletype = /obj/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	base_attack_cooldown = 10

	needs_reload = TRUE
	reload_time = 1.5 SECONDS //Assume use of speedloaders
	reload_max = 5		// Not the best default, but it fits the pistol

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged

	loot_list = list(/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/taj = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword/revolver
	name = "Tajara Bandit Raider"
	desc = "An armored Tajara swordsman, he also has a revolver. He is certainly ready for both sword and gun fights."
	icon_state = "nka_raider"
	icon_living = "nka_raider"

	projectiletype = /obj/projectile/bullet/pistol/strong
	projectilesound = 'sound/weapons/weaponsounds_heavypistolshot.ogg'

	needs_reload = TRUE
	reload_time = 1.5 SECONDS
	reload_max = 6

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/aggressive/blood_hunter

	loot_list = list(/obj/item/material/sword/plasteel = 100, /obj/item/gun/projectile/ballistic/revolver/mateba/taj = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/assault_rifle
	name = "Tajara Bandit Armsman"
	desc = "An armored Tajara with battle rifle, medieval aesthetic modern firepower!"
	icon_state = "nka_armsman"
	icon_living = "nka_armsman"

	projectiletype = /obj/projectile/bullet/rifle/a556
	projectilesound = 'sound/weapons/weaponsounds_rifleshot.ogg'
	base_attack_cooldown = 2.5

	needs_reload = TRUE
	reload_max = 30		// Not the best default, but it fits the pistol

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged

	loot_list = list(/obj/item/gun/projectile/ballistic/automatic/sts35/taj = 100)

///////////////////////////////
//		Guerillas
///////////////////////////////

/datum/category_item/catalogue/fauna/taj_guerilla/guerillas
	name = "Tajara Guerillas"
	desc = "The Democratic Republic of Adhomai despite making great progress to liberal \
	democracy remains at the mercy of countless armed militant groups. What qualifies as the \
	army of the DRA is in reality a very loose and constantly shifting coalition of militias \
	and other armed organizations. These groups often splinter over idealogy, pay and promotions \
	meaning the DRA produces a constant stream of new armed bands which turn to the frontier to \
	find the glory they couldn't at home. In the most extreme cases the DRA will outlaw an entire militia \
	driving hundreds of armed Tajara to the fringes of society and by the extension into the frontier. \
	Despite the chaos this has some advantages for the republic who can rely on these exiles for risky \
	wetwork."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla
	name = "Tajara Guerilla"
	desc = "A mercenary looking Tajara with a strong vest and a knife. You wonder where his gun went."
	icon_state = "dra"
	icon_living = "dra"
	catalogue_data = list(/datum/category_item/catalogue/fauna/taj_guerilla/guerillas)
	iff_factions = MOB_IFF_FACTION_TAJARA_DRA

	armor_type = list(/datum/armor/station/combat)

	corpse = /obj/spawner/corpse/tajara/dra_soldier
	loot_list = list(/obj/item/material/knife/tacknife = 100)

	say_list_type = /datum/say_list/tajara/dra

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/uzi
	name = "Tajara Guerilla Gunman"
	desc = "A mercenary looking Tajara with an machine pistol. Volume of fire can make up for lack of stopping power."
	icon_state = "dra_gunman"
	icon_living = "dra_gunman"

	projectiletype = /obj/projectile/bullet/pistol/medium
	projectilesound = 'sound/weapons/weaponsounds_pistolshot.ogg'
	base_attack_cooldown = 2 ///Uzi Go Brrrrr

	needs_reload = TRUE
	reload_max = 16

	loot_list = list(/obj/item/gun/projectile/ballistic/automatic/mini_uzi/taj = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/sniper
	name = "Tajara Guerilla Sniper"
	desc = "A mercenary looking Tajara with an machine pistol. Fast on his feet."
	icon_state = "dra_sniper"
	icon_living = "dra_sniper"

	projectiletype = /obj/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'

	needs_reload = TRUE
	reload_max = 10

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/kiting/sniper

	loot_list = list(/obj/item/gun/projectile/ballistic/SVD/taj = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/fal
	name = "Tajara Guerilla Commando"
	desc = "A mercenary looking Tajara with a bizarre looking battle rifle. Bizarre does not mean, not deadly"
	icon_state = "dra_commando"
	icon_living = "dra_commando"

	projectiletype = /obj/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'

	base_attack_cooldown = 5
	needs_reload = TRUE
	reload_max = 20

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged/surpressor

	loot_list = list(/obj/item/gun/projectile/ballistic/automatic/fal/taj = 100)


///////////////////////////////
//		Insurgents
///////////////////////////////

/datum/category_item/catalogue/fauna/taj_guerilla/insurgents
	name = "Tajara Insurgents"
	desc = "The People's Republic of Adhomai begin as a worker's revolution against a uncaring and tyrannical ruling class. \
	Even after the People's Republic developed own tyrannical ruling class they still like to keep the spirit of revolution \
	alive in the population of rival nations. To this end the PRA engages in complex weapons smuggling operations in order \
	funnel weapons to revolutionary groups in rival nations. The more promising groups recieve PRA 'volunteers' made up of \
	either fanatical PRA military personnel or recruits from the PRA's infamous intelligence agencies. Some Insurgent groups \
	are almost entirely 'volunteers' which are mainly former prisoners often at the mercy of handful of embedded commissars. \
	Insurgent groups often find themselves on the frontier on mission or after their handlers have cut them loose."
	value = CATALOGUER_REWARD_TRIVIAL


/mob/living/simple_mob/humanoid/taj_guerilla/insurgent
	name = "Tajara Insurgent"
	desc = "Seems like they forgot to give this one a gun, not that it appears to be discouraging him."
	icon_state = "pra"
	icon_living = "pra"
	catalogue_data = list(/datum/category_item/catalogue/fauna/taj_guerilla/insurgents)
	iff_factions = MOB_IFF_FACTION_TAJARA_PRA

	armor_type = list(/datum/armor/station/ballistic)

	corpse = /obj/spawner/corpse/tajara/pra_soldier
	loot_list = list(/obj/item/material/knife/tacknife = 100)

	say_list_type = /datum/say_list/tajara/pra

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/sawn_rifle
	name = "Tajara Insurgent Bandit"
	desc = "A masked insurgent with a sawn off rifle. You probably don't want him to get close."
	icon_state = "pra_bandit"
	icon_living = "pra_bandit"

	projectiletype = /obj/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'

	needs_reload = TRUE
	reload_time = 1.5 SECONDS //Assume use of speedloaders
	reload_max = 5		// Not the best default, but it fits the pistol

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged/shotgun //He is compensating for sawn rifle range by getting close

	loot_list = list(/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/taj/sawn = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/dual_pistols
	name = "Tajara Insurgent Gunslinger"
	desc = "A masked insurgent duel weilding pistols. What he lacks in accurayc he may make up for in volume of fire."
	icon_state = "pra_gunslinger"
	icon_living = "pra_gunslinger"

	projectiletype = /obj/projectile/bullet/pistol/medium
	projectilesound = 'sound/weapons/weaponsounds_pistolshot.ogg'
	base_attack_cooldown = 5

	needs_reload = TRUE
	reload_time = 3 SECONDS //REally fast for reloading two mags
	reload_max = 14		//2 Pistols 7 bullets each

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged/shotgun //Also likes getting close

	loot_list = list(/obj/item/gun/projectile/ballistic/colt/taj = 100, /obj/item/gun/projectile/ballistic/colt/taj = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/automat
	name = "Tajara Insurgent Gunner"
	desc = "A masked insurgent slugging around an Automat. Doesn't look like he has that much ammo."
	icon_state = "pra_gunner"
	icon_living = "pra_gunner"

	projectiletype = /obj/projectile/bullet/rifle/a762
	projectilesound = 'sound/weapons/weaponsounds_heavyrifleshot.ogg'
	base_attack_cooldown = 5
	needs_reload = TRUE
	reload_time = 3 SECONDS //Stuffing Three speedloaders down it
	reload_max = 15

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged/surpressor //Not great considering they don't have much ammo

	loot_list = list(/obj/item/gun/projectile/ballistic/automatic/automat/taj = 100)

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/bullpup
	name = "Tajara Insurgent Revolutionary"
	desc = "A masked insurgent with a bullpup rifle. The revolution demands superior firepower and someone delivered."
	icon_state = "pra_revolutionary"
	icon_living = "pra_revolutionary"

	projectiletype = /obj/projectile/bullet/rifle/a95
	projectilesound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	base_attack_cooldown = 6 //May get nerfed, these guys do more damage then 762 rifles

	needs_reload = TRUE
	reload_max = 45

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged

	loot_list = list(/obj/item/gun/projectile/ballistic/automatic/k25/taj = 100)

//////////////////////
// Neutral Variants //
//////////////////////

//These guys do not attack crew and non-hostile. They have different names to match. Safe to save you shouldn't shoot these guys

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/rifle/neutral
	name = "New Kingdom Rifleman"
	desc = "A rifleman from the New Kingdom of Adhomai. Hard to believe they still send solider into battle with such dated equipment."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/assault_rifle/neutral
	name = "New Kingdom Soldier"
	desc = "A soldier from the New Kingdom of Adhomai. Seems even a backward kingdom can give their men good rifles."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword/revolver/neutral
	name = "New Kingdom Shock Trooper"
	desc = "A soldier from the New Kingdom of Adhomai with a sword and rifle. Sometimes it can helpful to bring swords to gunfights."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/uzi/neutral
	name = "Tajara Mercenary Gunman"
	desc = "A Tajara merc with a Uzi. He seems a lot cooler headed then human mercs."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/sniper/neutral
	name = "Tajara Mercenary Sniper"
	desc = "A Tajara merc with a sniper. Judging by the lack of holes in you, he's chill with you."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/fal/neutral
	name = "Tajara Mercenary Commando"
	desc = "A Tajara merc with an assault rifle. He seems to be overall chill person."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/dual_pistols/neutral
	name = "PVSM Gunslinger"
	desc = "A member of the People's Republic of Adhomai Volunteer Space Militia, armed with two pistols."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/automat/neutral
	name = "PVSM Gunner"
	desc = "A member of the People's Republic of Adhomai Volunteer Space Militia, armed with a heavy automat."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/bullpup/neutral
	name = "PVSM Infatryman"
	desc = "A member of the People's Republic of Adhomai Volunteer Space Militia, armed with fancy bullpup."
	catalogue_data = list()
	iff_factions = MOB_IFF_FACTION_NEUTRAL

////////////////////////
// Mercenary Variants //
////////////////////////

//Are Allied with Mercs and eachother for varied engagements
/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/sword/revolver/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/rifle/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/bandit/assault_rifle/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/uzi/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/sniper/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/guerilla/fal/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/sawn_rifle/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/dual_pistols/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/automat/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY

/mob/living/simple_mob/humanoid/taj_guerilla/insurgent/bullpup/merc_faction
	iff_factions = MOB_IFF_FACTION_MERCENARY
