/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door/strelka/blockade
	icon = 'icons/obj/stationobjs.dmi'
	name = "Blockade Runner mode button"
	desc = "Makes the ship enter a mode that closes all external windows of the shuttles. Can add a small level of protection."
	id = "blockade_runner"
	var/sealed = FALSE
	var/last_used = 0


/obj/machinery/door/blast/strelka/blockade
	name = "Heavy duty blast door"
	desc = "An old blastdoor, designed for handleing one or two hits of anti ship weaponry."
	id = "blockade_runner"
	icon_state_open = "old_pdoor0"
	icon_state_opening = "old_pdoorc0"
	icon_state_closed = "old_pdoor1"
	icon_state_closing = "old_pdoorc1"
	icon_state = "old_pdoor0"
	density = 0
	opacity = 1
	integrity = 500
	integrity_max = 500

/obj/machinery/door/blast/strelka/blockade/Initialize(mapload)
	. = ..()
	opacity = 0


/obj/machinery/button/remote/blast_door/strelka/blockade/trigger()
	if(last_used > (world.time - 1 MINUTES))
		src.visible_message("[src] beeps as the capacitors to move the blast doors are still recharging.", "[src] beeps as the capacitors to move the blast doors are still recharging.", "[src] beeps as the capacitors to move the blast doors are still recharging.")
		return
	last_used = world.time
	sealed = !sealed
	if(sealed)
		command_announcement.Announce("Vessel is now entering Blockade Runner Mode. Closing ship shutters.", "Blockade Runner mode", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
	else
		command_announcement.Announce("Vessel is now exiting Blockade Runner Mode. Opening ship shutters.", "Blockade Runner mode", new_sound = sound('sound/effects/meteor_strike.ogg', volume=15))
	switch_blastdoors()

/obj/machinery/button/remote/blast_door/strelka/blockade/proc/switch_blastdoors()
	for(var/obj/machinery/door/blast/strelka/blockade/M in GLOB.machines)
		if(M.id == id)
			if(sealed)
				spawn(0)
					M.force_close()
			else
				spawn(0)
					M.force_open()

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

/obj/item/paper/strelka_rust
	name = "Safety Instructions for the R-UST on the NEV Strelka"
	info = {"<h4>Getting Started</h4>
	You can set this R-UST up like you can every other.
	Be aware that it is far smaller than other R-USTs you might be familiar with.<br>
	<b>DO <i>NOT</i> exceed a field strength of 50!</b><br>
	Be safe.
	"}

/obj/item/paper/strelka_rust_access
	name = "Access instructions for the R-UST"
	info = {"<h4>How to access the R-UST core</h4>
	As you will have noticed, there is no direct access to the R-UST core.
	To access the core you will have to open the vent,
	and use the public exterior airlock portside from here.
	This is done to maintain a thermal and atmospheric seal between the Core and the rest of the station.
	Be safe.
	"}
