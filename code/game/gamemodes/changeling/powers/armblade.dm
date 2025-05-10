/datum/power/changeling/arm_blade
	name = "Arm Blade"
	desc = "We reform one of our arms into a deadly blade."
	helptext = "We may retract our armblade by dropping it.  It can deflect projectiles."
	enhancedtext = "The blade will have armor peneratration."
	ability_icon_state = "ling_armblade"
	genomecost = 2
	verbpath = /mob/proc/changeling_arm_blade

//Grows a scary, and powerful arm blade.
/mob/proc/changeling_arm_blade()
	set category = "Changeling"
	set name = "Arm Blade (20)"

	if(src.mind.changeling.recursive_enhancement)
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_blade/greater))
			to_chat(src, "<span class='notice'>We prepare an extra sharp blade.</span>")
			return 1

	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/arm_blade))
			return 1
		return 0

//Claws
/datum/power/changeling/claw
	name = "Claw"
	desc = "We reform one of our arms into a deadly claw."
	helptext = "We may retract our claw by dropping it."
	enhancedtext = "The claw will have armor peneratration."
	ability_icon_state = "ling_claw"
	genomecost = 1
	verbpath = /mob/proc/changeling_claw

//Grows a scary, and powerful claw.
/mob/proc/changeling_claw()
	set category = "Changeling"
	set name = "Claw (15)"

	if(src.mind.changeling.recursive_enhancement)
		if(changeling_generic_weapon(/obj/item/melee/changeling/claw/greater, 1, 15))
			to_chat(src, "<span class='notice'>We prepare an extra sharp claw.</span>")
			return 1

	else
		if(changeling_generic_weapon(/obj/item/melee/changeling/claw, 1, 15))
			return 1
		return 0

// todo: full rework of all of this; changeling weapons are balanced by a numbskull holy shit fuck bay
//       - block chances are way, way too high
//       - insufficient armor penetration (ironically) for citrp combat balancing directives
//       - need to rethink changeling defensives in general, they shouldn't be reliant on parrying

/datum/parry_frame/passive_block/armblade
	parry_sfx = 'sound/weapons/slash.ogg'

/obj/item/melee/changeling
	name = "arm weapon"
	desc = "A grotesque weapon made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "arm_blade"
	w_class = WEIGHT_CLASS_HUGE
	damage_force = 5
	anchored = 1
	throw_force = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	var/mob/living/creator //This is just like ninja swords, needed to make sure dumb shit that removes the sword doesn't make it stay around.
	var/weapType = "weapon"
	var/weapLocation = "arm"

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 40;
		parry_chance_projectile = 15;
		parry_frame = /datum/parry_frame/passive_block/armblade;
	}

/obj/item/melee/changeling/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(ismob(loc))
		visible_message("<span class='warning'>A grotesque weapon forms around [loc.name]\'s arm!</span>",
		"<span class='warning'>Our arm twists and mutates, transforming it into a deadly weapon.</span>",
		"<span class='italics'>You hear organic matter ripping and tearing!</span>")
		src.creator = loc

/obj/item/melee/changeling/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	visible_message("<span class='warning'>With a sickening crunch, [creator] reforms their arm!</span>",
	"<span class='notice'>We assimilate the weapon back into our body.</span>",
	"<span class='italics'>You hear organic matter ripping and tearing!</span>")
	playsound(src, 'sound/effects/blobattack.ogg', 30, 1)
	qdel(src)

/obj/item/melee/changeling/Destroy()
	STOP_PROCESSING(SSobj, src)
	creator = null
	return ..()

/obj/item/melee/changeling/process(delta_time)  //Stolen from ninja swords.
	if(!creator || loc != creator || !creator.is_holding(src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
		qdel(src)

/obj/item/melee/changeling/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "arm_blade"
	damage_force = 40
	damage_tier = 4
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	pry = 1
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 60;
		parry_chance_projectile = 25;
		parry_frame = /datum/parry_frame/passive_block/armblade;
	}

/obj/item/melee/changeling/arm_blade/greater
	name = "arm greatblade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people and armor as a hot knife through butter."
	damage_tier = 4.5

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 70;
		parry_chance_projectile = 35;
		parry_frame = /datum/parry_frame/passive_block/armblade;
	}

/obj/item/melee/changeling/claw
	name = "hand claw"
	desc = "A grotesque claw made out of bone and flesh that cleaves through people as a hot knife through butter."
	icon_state = "ling_claw"
	damage_tier = 4
	damage_force = 15
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 50;
		parry_chance_projectile = 15;
		parry_frame = /datum/parry_frame/passive_block/armblade;
	}

/obj/item/melee/changeling/claw/greater
	name = "hand greatclaw"
	damage_force = 20
	damage_tier = 4.5
	pry = 1

	passive_parry = /datum/passive_parry/melee{
		parry_chance_default = 60;
		parry_chance_projectile = 25;
		parry_frame = /datum/parry_frame/passive_block/armblade;
	}
