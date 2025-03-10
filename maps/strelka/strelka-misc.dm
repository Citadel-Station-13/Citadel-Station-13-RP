/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door/strelka
	icon = 'icons/obj/stationobjs.dmi'
	name = "Blockade Runner mode button"
	desc = "Makes the ship enter a mode that closes all external windows of the shuttles. Can add a small level of protection."
	id = "blockade_runner"

/obj/machinery/button/remote/blast_door/strelka/trigger()
	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			if(M.density)
				spawn(0)
					command_announcement.Announce("Vessel is now entering Blockade Runner Mode. Closing ship shutters.", "Blockade Runner mode", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					M.open()
					return
			else
				spawn(0)
					command_announcement.Announce("Vessel is now exiting Blockade Runner Mode. Opening ship shutters.", "Blockade Runner mode", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					M.close()
					return

/obj/machinery/button/remote/blast_door/strelka/balista
	icon = 'icons/obj/stationobjs.dmi'
	name = "Balista activation button"
	desc = "Opens the Ballista blastdoors."
	id = "ballista"

/obj/machinery/button/remote/blast_door/strelka/balista/trigger()
	for(var/obj/machinery/door/blast/M in GLOB.machines)
		if(M.id == id)
			if(M.density)
				spawn(0)
					M.open()
					command_announcement.Announce("The Obstruction removal Ballista is now online. Openning barrel blastdoors", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					return
			else
				spawn(0)
					M.close()
					command_announcement.Announce("The Obstruction removal Ballista is now offline. Closing barrel blastdoors", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
					return

// Cargo shuttle Pilot
// Yep, the strelka is a biiiiiiiiiiiiiiiiiiiit old in some aspect..

/mob/living/simple_mob/animal/passive/maint_drone
	name = "Cargo shuttle Pilot Galaxy III"
	desc = "A small, normal-looking drone. It pilots the Cargo Supply shuttle... Yep, no MK2 pilot here..."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_maint_drone)

	icon = 'icons/mob/robots.dmi'
	icon_state = "corrupt-repairbot"
	icon_living = "corrupt-repairbot"
	hovering = FALSE // Can trigger landmines.

	maxHealth = 25
	health = 25
	movement_cooldown = 0
	movement_sound = 'sound/effects/servostep.ogg'

	pass_flags = ATOM_PASS_TABLE
	mob_swap_flags = 0
	mob_push_flags = 0

	legacy_melee_damage_lower = 6 // Approx 12 DPS.
	legacy_melee_damage_upper = 6
	base_attack_cooldown = 2.5 // Four attacks per second.
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list("cut", "sliced")

	var/poison_type = "fuel"	// The reagent that gets injected when it attacks.
	var/poison_chance = 35			// Chance for injection to occur.
	var/poison_per_bite = 5			// Amount added per injection.
