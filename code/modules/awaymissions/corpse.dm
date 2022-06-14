/**
 * used to create a corpse of a human
 */
/atom/movable/spawner/corpse
	name = "Unknown"
	var/mobname = "Unknown"  //Unused now but it'd fuck up maps to remove it now
	var/corpseuniform = null //Set this to an object path to have the slot filled with said object on the corpse.
	var/corpsesuit = null
	var/corpseshoes = null
	var/corpsegloves = null
	var/corpseradio = null
	var/corpseglasses = null
	var/corpsemask = null
	var/corpsehelmet = null
	var/corpsebelt = null
	var/corpsepocket1 = null
	var/corpsepocket2 = null
	var/corpseback = null
	var/corpseid = 0     //Just set to 1 if you want them to have an ID
	var/corpseidjob = null // Needs to be in quotes, such as "Clown" or "Chef." This just determines what the ID reads as, not their access
	var/corpseidaccess = null //This is for access. See access.dm for which jobs give what access. Again, put in quotes. Use "Captain" if you want it to be all access.
	var/corpseidicon = null //For setting it to be a gold, silver, CentCom etc ID
	var/species = /datum/species/human

/atom/movable/spawner/corpse/Initialize(mapload)
	. = ..()
	createCorpse()
	return INITIALIZE_HINT_QDEL

/atom/movable/spawner/corpse/proc/createCorpse() //Creates a mob and checks for gear in each slot before attempting to equip it.
	SHOULD_NOT_SLEEP(TRUE)	// HMMM MOB INIT ISSUES?
	var/mob/living/carbon/human/M = new /mob/living/carbon/human (src.loc)
	. = M
	M.set_species(species)
	M.real_name = src.name
	M.death(1) //Kills the new mob
	if(src.corpseuniform)
		M.equip_to_slot_or_del(new src.corpseuniform(M), slot_w_uniform)
	if(src.corpsesuit)
		M.equip_to_slot_or_del(new src.corpsesuit(M), slot_wear_suit)
	if(src.corpseshoes)
		M.equip_to_slot_or_del(new src.corpseshoes(M), slot_shoes)
	if(src.corpsegloves)
		M.equip_to_slot_or_del(new src.corpsegloves(M), slot_gloves)
	if(src.corpseradio)
		M.equip_to_slot_or_del(new src.corpseradio(M), slot_l_ear)
	if(src.corpseglasses)
		M.equip_to_slot_or_del(new src.corpseglasses(M), slot_glasses)
	if(src.corpsemask)
		M.equip_to_slot_or_del(new src.corpsemask(M), slot_wear_mask)
	if(src.corpsehelmet)
		M.equip_to_slot_or_del(new src.corpsehelmet(M), slot_head)
	if(src.corpsebelt)
		M.equip_to_slot_or_del(new src.corpsebelt(M), slot_belt)
	if(src.corpsepocket1)
		M.equip_to_slot_or_del(new src.corpsepocket1(M), slot_r_store)
	if(src.corpsepocket2)
		M.equip_to_slot_or_del(new src.corpsepocket2(M), slot_l_store)
	if(src.corpseback)
		M.equip_to_slot_or_del(new src.corpseback(M), slot_back)
	if(src.corpseid == 1)
		var/obj/item/card/id/W = new(M)
		var/datum/job/jobdatum
		for(var/jobtype in typesof(/datum/job))
			var/datum/job/J = new jobtype
			if(J.title == corpseidaccess)
				jobdatum = J
				break
		if(src.corpseidicon)
			W.icon_state = corpseidicon
		if(src.corpseidaccess)
			if(jobdatum)
				W.access = jobdatum.get_access()
			else
				W.access = list()
		if(corpseidjob)
			W.assignment = corpseidjob
		M.set_id_info(W)
		M.equip_to_slot_or_del(W, slot_wear_id)

/atom/movable/spawner/corpse/syndicatesoldier
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"



/atom/movable/spawner/corpse/syndicatecommando
	name = "Syndicate Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/void/merc
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/merc
	corpseback = /obj/item/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/tank/emergency/oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"



///////////Civilians//////////////////////

/atom/movable/spawner/corpse/chef
	name = "Chef"
	corpseuniform = /obj/item/clothing/under/rank/chef
	corpsesuit = /obj/item/clothing/suit/chef/classic
	corpseshoes = /obj/item/clothing/shoes/black
	corpsehelmet = /obj/item/clothing/head/chefhat
	corpseback = /obj/item/storage/backpack
	corpseradio = /obj/item/radio/headset
	corpseid = 1
	corpseidjob = "Chef"
	corpseidaccess = "Chef"


/atom/movable/spawner/corpse/doctor
	name = "Doctor"
	corpseradio = /obj/item/radio/headset/headset_med
	corpseuniform = /obj/item/clothing/under/rank/medical
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat
	corpseback = /obj/item/storage/backpack/medic
	corpsepocket1 = /obj/item/flashlight/pen
	corpseshoes = /obj/item/clothing/shoes/black
	corpseid = 1
	corpseidjob = "Medical Doctor"
	corpseidaccess = "Medical Doctor"

/atom/movable/spawner/corpse/engineer
	name = "Engineer"
	corpseradio = /obj/item/radio/headset/headset_eng
	corpseuniform = /obj/item/clothing/under/rank/engineer
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/orange
	corpsebelt = /obj/item/storage/belt/utility/full
	corpsegloves = /obj/item/clothing/gloves/yellow
	corpsehelmet = /obj/item/clothing/head/hardhat
	corpseid = 1
	corpseidjob = "Station Engineer"
	corpseidaccess = "Station Engineer"

/atom/movable/spawner/corpse/engineer/rig
	corpsesuit = /obj/item/clothing/suit/space/void/engineering
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/engineering

/atom/movable/spawner/corpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	corpseidaccess = "Clown"

/atom/movable/spawner/corpse/scientist
	name = "Scientist"
	corpseradio = /obj/item/radio/headset/headset_sci
	corpseuniform = /obj/item/clothing/under/rank/scientist
	corpsesuit = /obj/item/clothing/suit/storage/toggle/labcoat/science
	corpseback = /obj/item/storage/backpack
	corpseshoes = /obj/item/clothing/shoes/white
	corpseid = 1
	corpseidjob = "Scientist"
	corpseidaccess = "Scientist"

/atom/movable/spawner/corpse/miner
	corpseradio = /obj/item/radio/headset/headset_cargo
	corpseuniform = /obj/item/clothing/under/rank/miner
	corpsegloves = /obj/item/clothing/gloves/black
	corpseback = /obj/item/storage/backpack/industrial
	corpseshoes = /obj/item/clothing/shoes/black
	corpseid = 1
	corpseidjob = "Shaft Miner"
	corpseidaccess = "Shaft Miner"

/atom/movable/spawner/corpse/miner/rig
	corpsesuit = /obj/item/clothing/suit/space/void/mining
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/mining


/////////////////Officers//////////////////////

/atom/movable/spawner/corpse/bridgeofficer
	name = "Bridge Officer"
	corpseradio = /obj/item/radio/headset/heads/hop
	corpseuniform = /obj/item/clothing/under/rank/centcom/officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/black
	corpseglasses = /obj/item/clothing/glasses/sunglasses
	corpseid = 1
	corpseidjob = "Bridge Officer"
	corpseidaccess = "Captain"

/atom/movable/spawner/corpse/commander
	name = "Commander"
	corpseuniform = /obj/item/clothing/under/rank/centcom/officer
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseradio = /obj/item/radio/headset/heads/captain
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsemask = /obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	corpsehelmet = /obj/item/clothing/head/centhat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsepocket1 = /obj/item/flame/lighter/zippo
	corpseid = 1
	corpseidjob = "Commander"
	corpseidaccess = "Captain"

/atom/movable/spawner/corpse/vintage/pilot
	name = "Unknown Pilot"
	corpsesuit = /obj/item/clothing/suit/space/void/refurb/pilot
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/refurb/pilot
	corpseidjob = "Pilot"

//List of different corpse types

/atom/movable/spawner/corpse/syndicatesoldier
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/vest
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"

/atom/movable/spawner/corpse/solarpeacekeeper
	name = "Mercenary"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/blue/sol
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas
	corpsehelmet = /obj/item/clothing/head/helmet/swat
	corpseback = /obj/item/storage/backpack
	corpseid = 1
	corpseidjob = "Peacekeeper"
	corpseidaccess = "Syndicate"

/atom/movable/spawner/corpse/syndicatecommando
	name = "Syndicate Commando"
	corpseuniform = /obj/item/clothing/under/syndicate
	corpsesuit = /obj/item/clothing/suit/space/void/merc
	corpseshoes = /obj/item/clothing/shoes/boots/swat
	corpsegloves = /obj/item/clothing/gloves/swat
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/syndicate
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/merc
	corpseback = /obj/item/tank/jetpack/oxygen
	corpsepocket1 = /obj/item/tank/emergency/oxygen
	corpseid = 1
	corpseidjob = "Operative"
	corpseidaccess = "Syndicate"



/atom/movable/spawner/corpse/clown
	name = "Clown"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Clown"
	corpseidaccess = "Clown"

/atom/movable/spawner/corpse/clown/clownop
	name = "Clown Commando"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/clownop
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsepocket1 = /obj/item/bikehorn
	corpseback = /obj/item/storage/backpack/clown
	corpseid = 1
	corpseidjob = "Commando"
	corpseidaccess = "Syndicate"

/atom/movable/spawner/corpse/clown/clownop/space
	name = "Clown Commando"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpsesuit = /obj/item/clothing/suit/space/void/clownop
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/clownop
	corpsepocket1 = /obj/item/bananapeel
	corpseid = 1
	corpseidjob = "Commando"
	corpseidaccess = "Syndicate"

/atom/movable/spawner/corpse/clown/clownop/space/alt
	name = "Clown Commando"
	corpseuniform = /obj/item/clothing/under/rank/clown
	corpsesuit = /obj/item/clothing/suit/space/void/clownop
	corpseshoes = /obj/item/clothing/shoes/clown_shoes
	corpseradio = /obj/item/radio/headset
	corpsemask = /obj/item/clothing/mask/gas/clown_hat
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/clownop/alt
	corpsepocket1 = /obj/item/bananapeel
	corpseid = 1
	corpseidjob = "Commando"
	corpseidaccess = "Syndicate"

/atom/movable/spawner/corpse/russian
	name = "Russian"
	corpseuniform = /obj/item/clothing/under/soviet
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsehelmet = /obj/item/clothing/head/bearpelt

/atom/movable/spawner/corpse/russian/ranged
	corpsehelmet = /obj/item/clothing/head/ushanka

//Diorama Corpses
/atom/movable/spawner/corpse/shogun
	name = "Shogun's Bodyguard"
	corpseuniform = /obj/item/clothing/under/color/black
	corpsesuit = /obj/item/clothing/suit/kamishimo
	corpseshoes = /obj/item/clothing/shoes/sandal
	corpsehelmet = /obj/item/clothing/head/rice

/atom/movable/spawner/corpse/safari
	name = "Colonial Adventurer"
	corpseuniform = /obj/item/clothing/under/safari
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsehelmet = /obj/item/clothing/head/pith

//////////////////////////
//		Vox Bodies
//////////////////////////

/atom/movable/spawner/corpse/vox
	name = "vox"
	corpseid = 0
	species = /datum/species/vox

//Types of Vox corpses:

/atom/movable/spawner/corpse/vox/pirate
	name = "vox pirate"
	corpseuniform = /obj/item/clothing/under/color/black
	corpsesuit = /obj/item/clothing/suit/armor/vox_scrap
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsegloves = /obj/item/clothing/gloves/light_brown
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/atom/movable/spawner/corpse/vox/boarder_m
	name = "vox melee boarder"
	corpseuniform = /obj/item/clothing/under/vox/vox_casual
	corpsesuit = /obj/item/clothing/suit/armor/vox_scrap
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsegloves = /obj/item/clothing/gloves/light_brown
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/atom/movable/spawner/corpse/vox/boarder_r
	name = "vox ranged boarder"
	corpseuniform = /obj/item/clothing/under/rank/bartender
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/atom/movable/spawner/corpse/vox/boarder_t
	name = "vox salvage technician"
	corpseuniform = /obj/item/clothing/under/rank/bartender
	corpsesuit = /obj/item/clothing/suit/armor/bulletproof
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsemask = /obj/item/clothing/mask/breath
	corpseid = 0

/atom/movable/spawner/corpse/vox/suppressor
	name = "vox suppressor"
	corpseuniform = /obj/item/clothing/under/color/red
	corpsesuit = /obj/item/clothing/suit/storage/toggle/fr_jacket
	corpseshoes = /obj/item/clothing/shoes/orange
	corpsegloves = /obj/item/clothing/gloves/red
	corpsemask = /obj/item/clothing/mask/gas/half
	corpseid = 0

/atom/movable/spawner/corpse/vox/captain
	name = "vox captain"
	corpseuniform = /obj/item/clothing/under/color/black
	corpsesuit = /obj/item/clothing/suit/space/vox/carapace
	corpseshoes = /obj/item/clothing/shoes/magboots/vox
	corpsegloves = /obj/item/clothing/gloves/light_brown
	corpsemask = /obj/item/clothing/mask/breath
	corpsehelmet = /obj/item/clothing/head/helmet/riot
	corpseid = 0

/atom/movable/spawner/corpse/syndicatecommando
	name = "Mercenary Commando"

//////////////////////////
//	   Pirate Bodies
//////////////////////////
//I'm sorry for how huge this list is. I didn't really consider the ramifications of creating a diverse crew of pirates.

/atom/movable/spawner/corpse/pirate
	name = "Pirate"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/tan

/atom/movable/spawner/corpse/pirate/melee
	corpsesuit = /obj/item/clothing/suit/unathi/mantle
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsebelt = /obj/item/storage/belt/security/tactical
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/melee_machete
	name = "Pirate Brush Cutter"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsemask = /obj/item/clothing/mask/balaclava
	corpseback = /obj/item/storage/backpack/dufflebag/syndie

/atom/movable/spawner/corpse/pirate/melee_machete_armor
	name = "Armored Brush Cutter"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/green
	corpsesuit = /obj/item/clothing/suit/storage/vest/tactical
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsehelmet = /obj/item/clothing/head/welding
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/melee_energy_armor
	name = "Armored Duelist"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/tan
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/navy
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsemask = /obj/item/clothing/mask/gas/jackal

/atom/movable/spawner/corpse/pirate/melee_shield
	name = "Pirate Buckler"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/green
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsehelmet = /obj/item/clothing/head/tajaran/scarf
	corpseback = /obj/item/storage/backpack/dufflebag/syndie

/atom/movable/spawner/corpse/pirate/melee_shield_machete_armor
	name = "Armored Sword and Boarder"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/green
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/navy
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsehelmet = /obj/item/clothing/head/helmet
	corpsebelt = /obj/item/storage/belt/security/tactical
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/ranged
	name = "Pirate Pistolier"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsehelmet = /obj/item/clothing/head/welding
	corpsebelt = /obj/item/storage/belt/security/tactical
	corpseback = /obj/item/storage/backpack/dufflebag/syndie

/atom/movable/spawner/corpse/pirate/ranged_armor
	name = "Armored Pistolier"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpsesuit = /obj/item/clothing/suit/storage/vest/tactical
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsebelt = /obj/item/storage/belt/security/tactical

/atom/movable/spawner/corpse/pirate/ranged_laser
	name = "Pirate Handcannon"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpsehelmet = /obj/item/clothing/head/helmet/cyberpunk
	corpsebelt = /obj/item/storage/belt/security/tactical
	corpseback = /obj/item/storage/backpack/dufflebag/syndie

/atom/movable/spawner/corpse/pirate/ranged_laser_armor
	name = "Armored Handcannon"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpsesuit = /obj/item/clothing/suit/storage/vest/tactical
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsebelt = /obj/item/storage/belt/security/tactical

/atom/movable/spawner/corpse/pirate/ranged_blunderbuss
	name = "Pirate Blunderbuster"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsebelt = /obj/item/storage/belt/security/tactical/bandolier
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/ranged_blunderbuss_armor
	name = "Armored Blunderbuster"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/tan
	corpsesuit = /obj/item/clothing/suit/storage/vest/tactical
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsehelmet = /obj/item/clothing/head/tajaran/scarf
	corpsebelt = /obj/item/storage/belt/security/tactical/bandolier
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/mate
	name = "First Mate"
	corpseuniform = /obj/item/clothing/under/worn_fatigues
	corpsesuit = /obj/item/clothing/suit/armor/riot/alt
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsemask = /obj/item/clothing/mask/gas/commando

/atom/movable/spawner/corpse/pirate/mate/rifle
	name = "Mate Marksman"
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsemask = null

/atom/movable/spawner/corpse/pirate/bosun
	name = "Bosun"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/green
	corpsesuit = /obj/item/clothing/suit/armor/tactical/pirate
	corpseshoes = /obj/item/clothing/shoes/boots/workboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/captain
	name = "Pirate Captain"
	corpseuniform = /obj/item/clothing/under/worn_fatigues
	corpsesuit = /obj/item/clothing/suit/armor/tactical/pirate
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsemask = /obj/item/clothing/mask/balaclava
	corpsehelmet = /obj/item/clothing/head/helmet/pirate

//Akula
/atom/movable/spawner/corpse/akula
	species = /datum/species/akula
/atom/movable/spawner/corpse/pirate/melee_armor
	name = "Armored Pirate"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine
	corpsesuit = /obj/item/clothing/suit/storage/vest/tactical
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsehelmet = /obj/item/clothing/head/helmet/cyberpunk

/atom/movable/spawner/corpse/pirate/melee_energy
	name = "Pirate Duelist"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/tan
	corpsesuit = /obj/item/clothing/suit/unathi/mantle
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsehelmet = /obj/item/clothing/head/welding

/atom/movable/spawner/corpse/pirate/mate/shotgun
	name = "Mate Blunderbuster"
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsemask = /obj/item/clothing/mask/gas/jackal

//Vulpkanin
/atom/movable/spawner/corpse/vulpkanin
	species = /datum/species/vulpkanin

/atom/movable/spawner/corpse/pirate/melee_shield_machete
	name = "Sword and Boarder"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/tan
	corpseshoes = /obj/item/clothing/shoes/boots/workboots

/atom/movable/spawner/corpse/pirate/melee_shield_armor
	name = "Armored Buckler"
	corpseuniform = /obj/item/clothing/under/oricon/utility/marine/green
	corpsesuit = /obj/item/clothing/suit/armor/pcarrier/navy
	corpseshoes = /obj/item/clothing/accessory/armor/legguards/riot
	corpsehelmet = /obj/item/clothing/head/helmet
	corpsebelt = /obj/item/storage/belt/security/tactical
	corpseback = /obj/item/storage/backpack/rebel

/atom/movable/spawner/corpse/pirate/mate/pistol
	name = "Mate Pistolier"
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpsehelmet = /obj/item/clothing/head/helmet/cyberpunk

/*
/atom/movable/spawner/corpse/pirate
	name = "Pirate"
	corpseuniform = /obj/item/clothing/under/pirate
	corpseshoes = /obj/item/clothing/shoes/boots/jackboots
	corpseglasses = /obj/item/clothing/glasses/eyepatch
	corpsehelmet = /obj/item/clothing/head/bandana

/atom/movable/spawner/corpse/pirate/ranged
	name = "Pirate Gunner"
	corpsesuit = /obj/item/clothing/suit/pirate
	corpsehelmet = /obj/item/clothing/head/pirate
*/
