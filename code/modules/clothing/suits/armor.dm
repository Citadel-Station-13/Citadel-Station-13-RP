/obj/item/clothing/suit/armor
	allowed = list(/obj/item/gun/projectile/sec/flash, /obj/item/gun/energy,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/flashlight/maglight,/obj/item/clothing/head/helmet)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	clothing_flags = THICKMATERIAL
	valid_accessory_slots = (\
		ACCESSORY_SLOT_OVER\
		|ACCESSORY_SLOT_MEDAL\
		|ACCESSORY_SLOT_INSIGNIA)

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M

	for(var/obj/item/clothing/I in list(H.gloves, H.shoes))
		if(I && (src.body_parts_covered & ARMS && I.body_parts_covered & ARMS) )
			to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [I], it's in the way.</span>")
			return FALSE
		if(I && (src.body_parts_covered & LEGS && I.body_parts_covered & LEGS) )
			to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [I], it's in the way.</span>")
			return FALSE
	return TRUE

/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/alt
	name = "security armor"
	desc = "An armored vest that protects against some damage. This one has a NanoTrasen corporate badge."
	icon_state = "armoralt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")

/obj/item/clothing/suit/armor/vest/security
	name = "security armor"
	desc = "An armored vest that protects against some damage. This one has a corporate badge."
	icon_state = "armorsec"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")

/obj/item/clothing/suit/armor/riot
	name = "riot vest"
	desc = "A vest with heavy padding to protect against melee attacks."
	icon_state = "riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.5

/obj/item/clothing/suit/armor/riot/alt
	icon_state = "riot_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "riot_new", SLOT_ID_LEFT_HAND = "riot_new")

/obj/item/clothing/suit/armor/bulletproof
	name = "bullet resistant vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	blood_overlay_type = "armor"
	slowdown = 0.5
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/bulletproof/alt
	icon_state = "bulletproof_new"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "bulletproof_new", SLOT_ID_LEFT_HAND = "bulletproof_new")
	blood_overlay_type = "armor"

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	blood_overlay_type = "armor"
	slowdown = 0.5
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.1

/obj/item/clothing/suit/armor/laserproof/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
		var/obj/item/projectile/P = damage_source

		if(P.reflected) // Can't reflect twice
			return ..()

		var/reflectchance = 40 - round(damage/3)
		if(!(def_zone in list(BP_TORSO, BP_GROIN)))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(user)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)
			P.reflected = 1

			return PROJECTILE_CONTINUE // complete projectile permutation

/obj/item/clothing/suit/armor/combat
	name = "combat vest"
	desc = "A vest that protects the wearer from several common types of weaponry."
	icon_state = "combat"
	blood_overlay_type = "armor"
	slowdown = 0.5
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 30, bomb = 30, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/suit/armor/tactical
	name = "tactical armor"
	desc = "A suit of armor most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon_state = "swatarmor"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = HIDETIE|HIDEHOLSTER
	slowdown = 1
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/tactical/pirate
	name = "defaced tactical armor"
	desc = "This tactical armor has been painted over and repaired multiple times. Accumulated battle damage has degraded its protective capabilities significantly."
	icon_state = "swatarmor_pirate"
	armor = list(melee = 20, bullet = 20, laser = 20, energy = 10, bomb = 10, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/swat
	name = "swat suit"
	desc = "A heavily armored suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	clothing_flags = THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency/oxygen,/obj/item/clothing/head/helmet)
	slowdown = 1
	w_class = ITEMSIZE_HUGE
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 100)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	min_pressure_protection = 0 * ONE_ATMOSPHERE
	max_pressure_protection = 20* ONE_ATMOSPHERE
	siemens_coefficient = 0.6
	valid_accessory_slots = null

/obj/item/clothing/suit/armor/swat/officer
	name = "officer jacket"
	desc = "An armored jacket used in special operations."
	icon_state = "detective"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "detective", SLOT_ID_LEFT_HAND = "detective")
	blood_overlay_type = "coat"
	flags_inv = 0
	body_parts_covered = UPPER_TORSO|ARMS


/obj/item/clothing/suit/armor/det_suit
	name = "armor"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/caution
	name = "improvised armor (caution sign)"
	desc = "They used to beat you for pointing at the sign. Now, vengeance has come. WARNING: This is just a sign with straps attached to anchor it. Vengeance not guaranteed."
	icon_state = "caution"
	blood_overlay_type = "armor"
	armor = list(melee = 5, bullet = 1, laser = 5, energy = 5, bomb = 1, bio = 50, rad = 0)

//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "Reactive Teleport Armor"
	desc = "Someone separated our Research Director from their own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor_reflec_old", SLOT_ID_LEFT_HAND = "armor_reflec_old")
	blood_overlay_type = "armor"
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(prob(50))
		user.visible_message("<span class='danger'>The reactive teleport system flings [user] clear of the attack!</span>")
		var/list/turfs = new/list()
		for(var/turf/T in orange(6, user))
			if(istype(T,/turf/space)) continue
			if(T.density) continue
			if(T.x>world.maxx-6 || T.x<6)	continue
			if(T.y>world.maxy-6 || T.y<6)	continue
			turfs += T
		if(!turfs.len) turfs += pick(/turf in orange(6))
		var/turf/picked = pick(turfs)
		if(!isturf(picked)) return

		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, "sparks", 50, 1)

		user.loc = picked
		return PROJECTILE_FORCE_MISS
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	active = !( active )
	if (active)
		to_chat(user, "<font color=#4F49AF>The reactive armor is now active.</font>")
		icon_state = "reactive"
	else
		to_chat(user, "<font color=#4F49AF>The reactive armor is now inactive.</font>")
		icon_state = "reactiveoff"
		add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	icon_state = "reactiveoff"
	..()

// Alien armor has a chance to completely block attacks.
/obj/item/clothing/suit/armor/alien
	name = "alien enhancement vest"
	desc = "It's a strange piece of what appears to be armor. It looks very light and agile. Strangely enough it seems to have been designed for a humanoid shape."
	description_info = "It has a 20% chance to completely nullify an incoming attack, and the wearer moves slightly faster."
	icon_state = "alien_speed"
	blood_overlay_type = "armor"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	slowdown = -1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 0, rad = 40)
	siemens_coefficient = 0.4
	valid_accessory_slots = null
	var/block_chance = 20

/obj/item/clothing/suit/armor/alien/tank
	name = "alien protection suit"
	desc = "It's really resilient yet lightweight, so it's probably meant to be armor. Strangely enough it seems to have been designed for a humanoid shape."
	description_info = "It has a 40% chance to completely nullify an incoming attack."
	icon_state = "alien_tank"
	slowdown = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 70, bullet = 70, laser = 70, energy = 70, bomb = 70, bio = 0, rad = 40)
	block_chance = 40

/obj/item/clothing/suit/armor/alien/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(prob(block_chance))
		user.visible_message("<span class='danger'>\The [src] completely absorbs [attack_text]!</span>")
		return TRUE
	return FALSE

//Non-hardsuit ERT armor.
/obj/item/clothing/suit/armor/vest/ert
	name = "emergency response team armor"
	desc = "A set of armor worn by members of the Emergency Response Team."
	icon_state = "ertarmor_cmd"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
	valid_accessory_slots = null

//Commander
/obj/item/clothing/suit/armor/vest/ert/command
	name = "emergency response team commander armor"
	desc = "A set of armor worn by the commander of an Emergency Response Team. Has blue highlights."

//Security
/obj/item/clothing/suit/armor/vest/ert/security
	name = "emergency response team security armor"
	desc = "A set of armor worn by security members of the Emergency Response Team. Has red highlights."
	icon_state = "ertarmor_sec"

//Engineer
/obj/item/clothing/suit/armor/vest/ert/engineer
	name = "emergency response team engineer armor"
	desc = "A set of armor worn by engineering members of the Emergency Response Team. Has orange highlights."
	icon_state = "ertarmor_eng"

//Medical
/obj/item/clothing/suit/armor/vest/ert/medical
	name = "emergency response team medical armor"
	desc = "A set of armor worn by medical members of the Emergency Response Team. Has blue and white highlights."
	icon_state = "ertarmor_med"

//New Vests
/obj/item/clothing/suit/storage/vest
	name = "armor vest"
	desc = "A standard kevlar vest with webbing attached."
	icon_state = "webvest"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)
	allowed = list(/obj/item/gun,/obj/item/reagent_containers/spray/pepper,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/flashlight/maglight,/obj/item/clothing/head/helmet)

	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	clothing_flags = THICKMATERIAL

	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

/obj/item/clothing/suit/storage/vest/officer
	name = "officer armor vest"
	desc = "A standard kevlar vest with webbing attached. This one has a security holobadge clipped to the chest."
	icon_state = "officerwebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	icon_badge = "officerwebvest_badge"
	icon_nobadge = "officerwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/warden
	name = "warden armor vest"
	desc = "A standard kevlar vest with webbing attached. This one has a silver badge clipped to the chest."
	icon_state = "wardenwebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	icon_badge = "wardenwebvest_badge"
	icon_nobadge = "wardenwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/wardencoat
	name = "Warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/storage/vest/wardencoat/alt
	name = "Warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_alt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/suit/storage/vest/hos
	name = "head of security armor vest"
	desc = "A standard kevlar vest with webbing attached. This one has a gold badge clipped to the chest."
	icon_state = "hoswebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	icon_badge = "hoswebvest_badge"
	icon_nobadge = "hoswebvest_nobadge"

/obj/item/clothing/suit/storage/vest/hoscoat
	name = "armored coat"
	desc = "A greatcoat enhanced with a special alloy for some protection and style."
	icon_state = "hos"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDETIE|HIDEHOLSTER

/obj/item/clothing/suit/storage/vest/hos_overcoat
	name = "security overcoat"
	desc = "A fashionable leather overcoat lined with a lightweight, yet tough armor."
	icon_state = "leathercoat-sec"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDETIE|HIDEHOLSTER
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "wcoat", SLOT_ID_LEFT_HAND = "wcoat")

//Jensen cosplay gear
/obj/item/clothing/suit/storage/vest/hoscoat/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "hostrench"
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/vest/pcrc
	name = "PCRC armor vest"
	desc = "A simple kevlar vest belonging to Proxima Centauri Risk Control. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	icon_badge = "pcrcvest_badge"
	icon_nobadge = "pcrcvest_nobadge"

/obj/item/clothing/suit/storage/vest/oricon
	name = "\improper Orion Confederation armored vest"
	desc = "A synthetic armor vest. This one is marked with the crest of the Orion Confederation."
	icon_state = "solvest"
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/oricon/heavy
	name = "\improper Orion Confederation heavy armored vest"
	desc = "A synthetic armor vest with PEACEKEEPER printed in distinctive blue lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "solwebvest"

/obj/item/clothing/suit/storage/vest/oricon/security
	name = "master at arms heavy armored vest"
	desc = "A synthetic armor vest with MASTER AT ARMS printed in silver lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "secwebvest"

/obj/item/clothing/suit/storage/vest/oricon/command
	name = "command heavy armored vest"
	desc = "A synthetic armor vest with Orion Confederation printed in detailed gold lettering on the chest. This one has added webbing and ballistic plates."
	icon_state = "comwebvest"

/obj/item/clothing/suit/storage/vest/tactical //crack at a more balanced mid-range armor, minor improvements over standard vests, with the idea "modern" combat armor would focus on energy weapon protection.
	name = "tactical armored vest"
	desc = "A heavy armored vest in a fetching tan. It is surprisingly flexible and light, even with the extra webbing and advanced ceramic plates."
	icon_state = "tacwebvest"
	item_state = "tacwebvest"
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/heavy/flexitac //a reskin of the above to have a matching armor set
	name = "tactical light vest"
	desc = "An armored vest made from advanced flexible ceramic plates. It's surprisingly mobile, if a little unfashionable."
	icon_state = "flexitac"
	item_state = "flexitac"
	armor = list(melee = 40, bullet = 40, laser = 60, energy = 35, bomb = 30, bio = 0, rad = 0)
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = T0C - 20
	slowdown = 0.3

/obj/item/clothing/suit/storage/vest/detective
	name = "detective armor vest"
	desc = "A standard kevlar vest in a vintage brown, it has a badge clipped to the chest that reads, 'Private investigator'."
	icon_state = "detectivevest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	icon_badge = "detectivevest_badge"
	icon_nobadge = "detectivevest_nobadge"

/obj/item/clothing/suit/storage/vest/press
	name = "press vest"
	icon_state = "pvest"
	desc = "A simple kevlar vest. This one has the word 'Press' embroidered on patches on the back and front."
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	allowed = list(/obj/item/flashlight,/obj/item/tape_recorder,/obj/item/pen,/obj/item/camera_film,/obj/item/camera,/obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/vest/heavy
	name = "heavy armor vest"
	desc = "A heavy kevlar vest with webbing attached."
	icon_state = "webvest"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 0, rad = 0)
	slowdown = 0.5

/obj/item/clothing/suit/storage/vest/heavy/officer
	name = "officer heavy armor vest"
	desc = "A heavy kevlar vest with webbing attached. This one has a security holobadge clipped to the chest."
	icon_state = "officerwebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	icon_badge = "officerwebvest_badge"
	icon_nobadge = "officerwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/warden
	name = "warden heavy armor vest"
	desc = "A heavy kevlar vest with webbing attached. This one has a silver badge clipped to the chest."
	icon_state = "wardenwebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	icon_badge = "wardenwebvest_badge"
	icon_nobadge = "wardenwebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/hos
	name = "head of security heavy armor vest"
	desc = "A heavy kevlar vest with webbing attached. This one has a gold badge clipped to the chest."
	icon_state = "hoswebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	icon_badge = "hoswebvest_badge"
	icon_nobadge = "hoswebvest_nobadge"

/obj/item/clothing/suit/storage/vest/heavy/pcrc
	name = "PCRC heavy armor vest"
	desc = "A heavy kevlar vest belonging to Proxima Centauri Risk Control with webbing attached. This one has a PCRC crest clipped to the chest."
	icon_state = "pcrcwebvest_nobadge"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	icon_badge = "pcrcwebvest_badge"
	icon_nobadge = "pcrcwebvest_nobadge"

//Provides the protection of a merc voidsuit, but only covers the chest/groin, and also takes up a suit slot. In exchange it has no slowdown and provides storage.
/obj/item/clothing/suit/storage/vest/heavy/merc
	name = "heavy armor vest"
	desc = "A high-quality heavy kevlar vest in a fetching tan. The vest is surprisingly flexible, and possibly made of an advanced material."
	icon_state = "mercwebvest"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)
	slowdown = 0

/obj/item/clothing/suit/storage/vest/capcarapace
	name = "captain's carapace"
	desc = "A fireproof, armored chestpiece reinforced with ceramic plates and plasteel pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon_state = "capcarapace"
	armor = list(melee = 50, bullet = 40, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

//All of the armor below is mostly unused

/obj/item/clothing/suit/armor/centcomm
	name = "CentCom armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	w_class = ITEMSIZE_LARGE//bulky item
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/gun/projectile/sec/flash, /obj/item/gun/energy,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank/emergency/oxygen,/obj/item/clothing/head/helmet)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "An old military-grade suit of armor. Incredibly robust against brute force damage! However, it offers little protection from energy-based weapons, which, combined with its bulk, makes it woefully obsolete."
	icon_state = "heavy"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor = list(melee = 90, bullet = 80, laser = 10, energy = 10, bomb = 80, bio = 0, rad = 0)
	w_class = ITEMSIZE_HUGE // Very bulky, very heavy.
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 5 // If you're a tank you're gonna move like a tank.
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/tdome/red
	name = "Thunderdome suit (red)"
	desc = "Reddish armor."
	icon_state = "tdred"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "Thunderdome suit (green)"
	desc = "Pukish armor."
	icon_state = "tdgreen"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/samurai
	name = "karuta-gane"
	desc = "An utterly ancient suit of Earth armor, reverently maintained and restored over the years. Designed for foot combat in an era where melee combat was the predominant focus, this suit offers no protection against ballistics or energy attacks, although its lacquered exterior may occasionally deflect laser bolts."
	icon_state = "samurai"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "leather_coat", SLOT_ID_LEFT_HAND = "leather_coat")
	armor = list(melee = 100, bullet = 00, laser = 5, energy = 0, bomb = 0, bio = 0, rad = 0)
	w_class = ITEMSIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDETIE|HIDEHOLSTER
	siemens_coefficient = 0.6
	valid_accessory_slots = null

/obj/item/clothing/suit/armor/combat/syndicate
	name = "syndicate combat vest"
	desc = "A heavily armored vest worn over a thick coat. The gold embroidery suggests whoever wears this possesses a high rank."
	icon_state = "syndievest"
	blood_overlay_type = "armor"
	valid_accessory_slots = null

//Modular plate carriers
/obj/item/clothing/suit/armor/pcarrier
	name = "plate carrier"
	desc = "A lightweight black plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/obj/clothing/modular_armor.dmi'
	item_icons = list(SLOT_ID_SUIT = 'icons/mob/clothing/modular_armor.dmi')
	icon_state = "pcarrier"
	valid_accessory_slots = (\
		ACCESSORY_SLOT_INSIGNIA\
		|ACCESSORY_SLOT_ARMOR_C\
		|ACCESSORY_SLOT_ARMOR_A\
		|ACCESSORY_SLOT_ARMOR_L\
		|ACCESSORY_SLOT_ARMOR_S\
		|ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = (\
		ACCESSORY_SLOT_INSIGNIA\
		|ACCESSORY_SLOT_ARMOR_C\
		|ACCESSORY_SLOT_ARMOR_A\
		|ACCESSORY_SLOT_ARMOR_L\
		|ACCESSORY_SLOT_ARMOR_S\
		|ACCESSORY_SLOT_ARMOR_M)
	blood_overlay_type = "armor"

/obj/item/clothing/suit/armor/pcarrier/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return

	if(!ishuman(M))
		return

	var/mob/living/carbon/human/H = M

	if(H.gloves)
		if(H.gloves.body_parts_covered & ARMS)
			for(var/obj/item/clothing/accessory/A in src)
				if(A.body_parts_covered & ARMS)
					to_chat(H, "<span class='warning'>You can't wear \the [A] with \the [H.gloves], they're in the way.</span>")
					return FALSE
	if(H.shoes)
		if(H.shoes.body_parts_covered & LEGS)
			for(var/obj/item/clothing/accessory/A in src)
				if(A.body_parts_covered & LEGS)
					to_chat(H, "<span class='warning'>You can't wear \the [A] with \the [H.shoes], they're in the way.</span>")
					return FALSE
	return TRUE
/obj/item/clothing/suit/armor/pcarrier/light
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate)

/obj/item/clothing/suit/armor/pcarrier/light/sol
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate, /obj/item/clothing/accessory/armor/tag)

/obj/item/clothing/suit/armor/pcarrier/light/nt
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate, /obj/item/clothing/accessory/armor/tag/nt)

/obj/item/clothing/suit/armor/pcarrier/medium
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium, /obj/item/clothing/accessory/storage/pouches)

/obj/item/clothing/suit/armor/pcarrier/medium/sol
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag)

/obj/item/clothing/suit/armor/pcarrier/medium/security
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/sec)

/obj/item/clothing/suit/armor/pcarrier/medium/command
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/com)

/obj/item/clothing/suit/armor/pcarrier/medium/nt
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium, /obj/item/clothing/accessory/storage/pouches, /obj/item/clothing/accessory/armor/tag/nt)

/obj/item/clothing/suit/armor/pcarrier/blue
	name = "blue plate carrier"
	desc = "A lightweight blue plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_blue"

/obj/item/clothing/suit/armor/pcarrier/press
	name = "light blue plate carrier"
	desc = "A lightweight light blue plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_press"

/obj/item/clothing/suit/armor/pcarrier/blue/sol
	name = "peacekeeper plate carrier"
	desc = "A lightweight plate carrier vest in SCG Peacekeeper colors. It can be equipped with armor plates, but provides no protection of its own."
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium, /obj/item/clothing/accessory/storage/pouches/blue, /obj/item/clothing/accessory/armor/armguards/blue, /obj/item/clothing/accessory/armor/tag)

/obj/item/clothing/suit/armor/pcarrier/green
	name = "green plate carrier"
	desc = "A lightweight green plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_green"

/obj/item/clothing/suit/armor/pcarrier/navy
	name = "navy plate carrier"
	desc = "A lightweight navy blue plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_navy"

/obj/item/clothing/suit/armor/pcarrier/tan
	name = "tan plate carrier"
	desc = "A lightweight tan plate carrier vest. It can be equipped with armor plates, but provides no protection of its own."
	icon_state = "pcarrier_tan"

/obj/item/clothing/suit/armor/pcarrier/tan/tactical
	name = "tactical plate carrier"
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/tactical, /obj/item/clothing/accessory/storage/pouches/large/tan)

/obj/item/clothing/suit/armor/pcarrier/merc
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/merc, /obj/item/clothing/accessory/armor/armguards/merc, /obj/item/clothing/accessory/armor/legguards/merc, /obj/item/clothing/accessory/storage/pouches/large)

//Brig Spec Variants
/obj/item/clothing/suit/armor/pcarrier/bulletproof
	name = "ballistic plate carrier"
	desc = "A lightweight ballistic vest. Equipped with a ballistic armor plate by default, this armor consists of a kevlar weave augmented by a non-Newtonian gel layer."
	icon_state = "ballistic"
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/bulletproof, /obj/item/clothing/accessory/armor/tag/sec)

/obj/item/clothing/suit/armor/pcarrier/laserproof
	name = "ablative plate carrier"
	desc = "A lightweight deflector vest. Equipped with an ablative armor plate by default, this armor consists of a polished Cartesian Glance Plating and an inset network of heat sink channels."
	icon_state = "ablative"
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/laserproof, /obj/item/clothing/accessory/armor/tag/sec)

/obj/item/clothing/suit/armor/pcarrier/riot
	name = "riot suppression plate carrier"
	desc = "A lightweight padded vest. Equipped with a padded armor plate by default, this armor consists of a stab resistant kevlar weave and hardened fleximat padding."
	icon_state = "riot"
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/riot, /obj/item/clothing/accessory/armor/tag/sec)

//Clown Op Carrier
/obj/item/clothing/suit/armor/pcarrier/clownop
	name = "clown commando plate carrier"
	desc = "A lightweight red and white plate carrier vest. It can be equipped with armor plates, but provides no protection of its own. Honk."
	icon_state = "clowncarrier"
	starting_accessories = list(/obj/item/clothing/accessory/armor/armorplate/medium)


//PARA Armor
/obj/item/clothing/suit/armor/vest/para
	name = "PARA light armor"
	desc = "Light armor emblazoned with the device of an Eye. When equipped by trained PMD agents, runes set into the interior begin to glow."
	icon_state = "para_ert_armor"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 60, bomb = 20, bio = 0, rad = 0)
	action_button_name = "Enable Armor Sigils"

	var/anti_magic = FALSE
	var/blessed = FALSE

/obj/item/clothing/suit/armor/vest/para/attack_self(mob/user as mob)
	if(user.mind.isholy && !anti_magic && !blessed)
		anti_magic = TRUE
		blessed = TRUE
		to_chat(user, "<font color=#4F49AF>You enable the armor's protective sigils.</font>")
	else
		anti_magic = FALSE
		blessed = FALSE
		to_chat(user, "<font color=#4F49AF>You disable the armor's protective sigils.</font>")

	if(!user.mind.isholy)
		to_chat(user, "<font color='red'>You can't figure out what these symbols do.</font>")

/obj/item/clothing/suit/armor/para/inquisitor
	name = "inquisitor's coat"
	desc = "A flowing, armored coat adorned with occult iconography."
	icon_state = "witchhunter"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "armor", SLOT_ID_LEFT_HAND = "armor")
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 0, rad = 0)
	action_button_name = "Enable Coat Sigils"
	valid_accessory_slots = null

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "An old military-grade suit of armor. Incredibly robust against brute force damage! However, it offers little protection from energy-based weapons, which, combined with its bulk, makes it woefully obsolete."
	icon_state = "heavy"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	armor = list(melee = 90, bullet = 80, laser = 10, energy = 10, bomb = 80, bio = 0, rad = 0)
	w_class = ITEMSIZE_HUGE // massively bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 5 // If you're a tank you're gonna move like a tank.
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0


/obj/item/clothing/suit/armor/vest/wolftaur
	name = "wolf-taur armor vest"
	desc = "An armored vest that protects against some damage. It appears to be created for a wolf-taur."
	species_restricted = null //Species restricted since all it cares about is a taur half
	icon = 'icons/mob/clothing/taursuits_wolf.dmi'
	icon_state = "heavy_wolf_armor"
	item_state = "heavy_wolf_armor"
	valid_accessory_slots = null

/obj/item/clothing/suit/armor/vest/wolftaur/can_equip(mob/M, slot, mob/user, flags)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H
	if(istype(H) && istype(H.tail_style, /datum/sprite_accessory/tail/taur/wolf))
		return
	else
		to_chat(H,"<span class='warning'>You need to have a wolf-taur half to wear this.</span>")
		return FALSE

// HoS armor improved to be slightly better than normal security stuff.
/obj/item/clothing/suit/storage/vest/hoscoat
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/hos
	armor = list(melee = 50, bullet = 40, laser = 40, energy = 25, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/vest/hoscoat/jensen
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "hostrench"
	flags_inv = HIDEHOLSTER

/obj/item/clothing/suit/storage/vest/oricon
	name = "\improper Orion Confederation Government armored vest"
	desc = "A synthetic armor vest. This one is marked with the crest of the Orion Confederation Group."

/obj/item/clothing/suit/storage/vest/oricon/heavy
	name = "\improper Orion Confederation Government heavy armored vest"
	desc = "A synthetic armor vest with SECURITY printed in distinctive blue lettering on the chest. This one has added webbing and ballistic plates." // JSDF does peacekeeping, not these guys.

/obj/item/clothing/suit/storage/vest/oricon/security
	name = "master at arms heavy armored vest"
	desc = "A synthetic armor vest with MASTER AT ARMS printed in silver lettering on the chest. This one has added webbing and ballistic plates."

/obj/item/clothing/suit/storage/vest/oricon/command
	name = "command heavy armored vest"
	desc = "A synthetic armor vest with Orion Confederation Government printed in detailed gold lettering on the chest. This one has added webbing and ballistic plates."

/obj/item/clothing/suit/armor/combat/JSDF
	name = "marine body armor"
	desc = "When I joined the Corps, we didn't have any fancy-schmanzy armor. We had sticks! Two sticks, and a rock for the whole platoon - and we had to <i>share</i> the rock!"
	icon_state = "unsc_armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO // ToDo: Break up the armor into smaller bits.

/obj/item/clothing/suit/armor/combat/imperial
	name = "imperial soldier armor"
	desc = "Made out of an especially light metal, it lets you conquer in style."
	icon_state = "ge_armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/armor/combat/imperial/centurion
	name = "imperial centurion armor"
	desc = "Not all heroes wear capes, but it'd be cooler if they did."
	icon_state = "ge_armorcent"

/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A tribal armor plate, crafted from animal bone."
	icon_state = "bonearmor"
	armor = list("melee" = 35, "bullet" = 25, "laser" = 25, "energy" = 10, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "wound" = 10)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

//Strange Plate Armor
/obj/item/clothing/suit/armor/bulletproof/kettle
	name = "bulky imperial plate"
	desc = "Often sold in tandem with KTL helmets, this sturdy plate armor offers impressive protection against bullets. These suits are believed to originate from an isolationist human society on the Eastern Rim."
	icon_state = "ironplate"
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/bulletproof/kettle/adamant
	name = "adamant imperial plate"
	desc = "Much more rare than standard Imperial plate, adamant armor protects against lasers and radiation as well as bullets. These suits are believed to originate from an isolationist human society on the Eastern Rim."
	icon_state = "aplate"
	armor = list(melee = 10, bullet = 60, laser = 40, energy = 40, bomb = 0, bio = 0, rad = 60)

//Plate Harness Armor. Has no intrinsic protective value, but serves as a lightweight anchor for limb plating.
/obj/item/clothing/suit/armor/plate_harness
	name = "lightweight harness"
	desc = "A lightweight harness designed to attach to the torso. It serves as an anchor point for lightweight armor plating, but provides no protection of its own."
	icon = 'icons/obj/clothing/ties.dmi'
	item_icons = list(SLOT_ID_SUIT = 'icons/mob/clothing/ties.dmi')
	icon_state = "pilot_webbing1"
	valid_accessory_slots = (\
		ACCESSORY_SLOT_ARMOR_C\
		|ACCESSORY_SLOT_ARMOR_A\
		|ACCESSORY_SLOT_ARMOR_L\
		|ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = (\
		ACCESSORY_SLOT_ARMOR_C\
		|ACCESSORY_SLOT_ARMOR_A\
		|ACCESSORY_SLOT_ARMOR_L\
		|ACCESSORY_SLOT_ARMOR_M)
	blood_overlay_type = "armor"
