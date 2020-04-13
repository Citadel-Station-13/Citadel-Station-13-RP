/obj/item/stolenpackage
	name = "stolen package"
	desc = "What's in the box?"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate5"
	item_state = "table_parts"
	w_class = ITEMSIZE_HUGE

/obj/item/stolenpackage/attack_self(mob/user)
		// Another way of doing this. Commented out because the other method is better for this application.
		/*var/spawn_chance = rand(1,100)
		switch(spawn_chance)
			if(0 to 49)
				new /obj/random/gun/guarenteed(usr.loc)
				usr << "You got a thing!"
			if(50 to 99)
				new /obj/item/bikehorn/rubberducky(usr.loc)
				new /obj/item/bikehorn(usr.loc)
				usr << "You got two things!"
			if(100)
				usr << "The box contained nothing!"
				return
		*/
		var/loot = pick(/obj/effect/landmark/costume,
						/obj/item/clothing/glasses/thermal,
						/obj/item/clothing/gloves/combat,
						/obj/item/clothing/gloves/combat/advanced,
						/obj/item/clothing/accessory/holster/machete/occupied,
						/obj/item/clothing/accessory/holster/machete/occupied/deluxe,
						/obj/item/clothing/accessory/holster/machete/occupied/durasteel,
						/obj/item/clothing/head/bearpelt,
						/obj/item/clothing/mask/balaclava,
						/obj/item/clothing/mask/horsehead,
						/obj/item/clothing/mask/muzzle,
						/obj/item/clothing/suit/armor/heavy,
						/obj/item/clothing/suit/armor/laserproof,
						/obj/item/clothing/suit/armor/vest,
						/obj/item/chameleon,
						/obj/item/pda/clown,
						/obj/item/pda/mime,
						/obj/item/pda/syndicate,
						/obj/item/mecha_parts/chassis/phazon,
						/obj/item/mecha_parts/part/phazon_head,
						/obj/item/mecha_parts/part/phazon_left_arm,
						/obj/item/mecha_parts/part/phazon_left_leg,
						/obj/item/mecha_parts/part/phazon_right_arm,
						/obj/item/mecha_parts/part/phazon_right_leg,
						/obj/item/mecha_parts/part/phazon_torso,
						/obj/item/bodysnatcher,
						/obj/item/bluespace_harpoon,
						/obj/item/clothing/accessory/permit/gun,
						/obj/item/perfect_tele,
						/obj/item/sleevemate,
						/obj/item/disk/nifsoft/compliance,
						/obj/item/seeds/ambrosiadeusseed,
						/obj/item/seeds/ambrosiavulgarisseed,
						/obj/item/seeds/libertymycelium,
						/obj/fiftyspawner/platinum,
						/obj/item/toy/nanotrasenballoon,
						/obj/item/toy/syndicateballoon,
						/obj/item/aiModule/syndicate,
						/obj/item/book/manual/engineering_hacking,
						/obj/item/card/emag,
						/obj/item/card/emag_broken,
						/obj/item/card/id/syndicate,
						/obj/item/contraband/poster,
						/obj/item/disposable_teleporter,
						/obj/item/grenade/flashbang/clusterbang,
						/obj/item/grenade/flashbang/clusterbang,
						/obj/item/grenade/spawnergrenade/spesscarp,
						/obj/item/melee/energy/sword,
						/obj/item/melee/telebaton,
						/obj/item/pen/reagent/paralysis,
						/obj/item/pickaxe/diamonddrill,
						/obj/item/reagent_containers/food/drinks/bottle/pwine,
						/obj/item/reagent_containers/food/snacks/carpmeat,
						/obj/item/reagent_containers/food/snacks/clownstears,
						/obj/item/reagent_containers/food/snacks/xenomeat,
						/obj/item/reagent_containers/glass/beaker/neurotoxin,
						/obj/item/rig/combat,
						/obj/item/shield/energy,
						/obj/item/stamp/centcomm,
						/obj/item/stamp/solgov,
						/obj/item/storage/fancy/cigar/havana,
						/obj/item/storage/fancy/cigar/cohiba,
						/obj/item/xenos_claw,
						/obj/random/contraband,
						/obj/random/contraband,
						/obj/random/contraband,
						/obj/random/contraband,
						/obj/random/weapon/guarenteed)
		new loot(user.drop_location())
		to_chat(user, "You unwrap the package.")
		qdel(src)

/obj/item/storage/fancy/cigar/havana
	name = "\improper Havana cigar case"
	desc = "Save these for the fancy-pantses at the next CentCom black tie reception. You can't blow the smoke from such majestic stogies in just anyone's face."
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar/havana)
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette/cigar/havana = 7)

/obj/item/storage/fancy/cigar/cohiba
	name = "\improper Cohiba Robusto cigar case"
	desc = "If Havana cigars were meant for the black tie reception, then these are meant to be family heirlooms instead of being smoked. These are the pinnacle of smoking luxury, make no mistake."
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba)
	starts_with = list(/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 7)

/obj/item/stolenpackageplus
	name = "curated stolen package"
	desc = "What's in this slightly more robust box?"
	icon = 'icons/obj/storage.dmi'
	icon_state = "deliverycrate5"
	item_state = "table_parts"
	w_class = ITEMSIZE_HUGE

/obj/item/stolenpackageplus/attack_self(mob/user)
		var/loot = pick(/obj/item/clothing/glasses/thermal,
						/obj/item/clothing/gloves/combat/advanced,
						/obj/item/clothing/gloves/combat/advanced,
						/obj/item/clothing/accessory/holster/machete/occupied,
						/obj/item/clothing/accessory/holster/machete/occupied/deluxe,
						/obj/item/clothing/accessory/holster/machete/occupied/durasteel,
						/obj/item/clothing/suit/armor/heavy,
						/obj/item/clothing/suit/armor/laserproof,
						/obj/item/chameleon,
						/obj/item/pda/syndicate,
						/obj/item/mecha_parts/chassis/phazon,
						/obj/item/mecha_parts/part/phazon_head,
						/obj/item/mecha_parts/part/phazon_left_arm,
						/obj/item/mecha_parts/part/phazon_left_leg,
						/obj/item/mecha_parts/part/phazon_right_arm,
						/obj/item/mecha_parts/part/phazon_right_leg,
						/obj/item/mecha_parts/part/phazon_torso,
						/obj/item/bodysnatcher,
						/obj/item/bluespace_harpoon,
						/obj/item/clothing/accessory/permit/gun,
						/obj/item/perfect_tele,
						/obj/item/disk/nifsoft/compliance,
						/obj/item/seeds/ambrosiadeusseed,
						/obj/item/seeds/ambrosiavulgarisseed,
						/obj/item/seeds/libertymycelium,
						/obj/fiftyspawner/platinum,
						/obj/item/toy/nanotrasenballoon,
						/obj/item/toy/syndicateballoon,
						/obj/item/aiModule/syndicate,
						/obj/item/card/emag,
						/obj/item/card/id/syndicate,
						/obj/item/disposable_teleporter,
						/obj/item/grenade/flashbang/clusterbang,
						/obj/item/grenade/flashbang/clusterbang,
						/obj/item/grenade/spawnergrenade/spesscarp,
						/obj/item/melee/energy/sword,
						/obj/item/melee/telebaton,
						/obj/item/pen/reagent/paralysis,
						/obj/item/pickaxe/diamonddrill,
						/obj/item/reagent_containers/glass/beaker/neurotoxin,
						/obj/item/rig/combat,
						/obj/item/shield/energy,
						/obj/item/stamp/centcomm,
						/obj/item/stamp/solgov,
						/obj/item/storage/fancy/cigar/havana,
						/obj/item/storage/fancy/cigar/cohiba,
						/obj/random/contraband,
						/obj/random/weapon/guarenteed)
		new loot(usr.drop_location())
		to_chat(user, "You unwrap the package.")
		qdel(src)
