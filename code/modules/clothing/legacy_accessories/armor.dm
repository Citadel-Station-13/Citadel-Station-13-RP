/*
// This file holds all of the accessories used as part of the modular armor system. At some point it might be wise to split this into multiple files.
*/

/obj/item/clothing/accessory/armor
	name = "armor accessory"
	desc = "You should never see this description. Ahelp this, please."
	icon_override = 'icons/mob/clothing/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "pouches"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/clothing/accessory/armor/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.wear_suit == S)
			if((body_cover_flags & ARMS) && istype(H.gloves, /obj/item/clothing))
				var/obj/item/clothing/G = H.gloves
				if(G.body_cover_flags & ARMS)
					to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [G], it's in the way.</span>")
					S.accessories -= src
					return
			else if((body_cover_flags & LEGS) && istype(H.shoes, /obj/item/clothing))
				var/obj/item/clothing/Sh = H.shoes
				if(Sh.body_cover_flags & LEGS)
					to_chat(H, "<span class='warning'>You can't wear \the [src] with \the [Sh], it's in the way.</span>")
					S.accessories -= src
					return
	..()

///////////
//Pouches
///////////
/obj/item/clothing/accessory/storage/pouches
	name = "storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to two items."
	icon_override = 'icons/mob/clothing/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "pouches"
	w_class = WEIGHT_CLASS_NORMAL
	gender = PLURAL
	slot = ACCESSORY_SLOT_ARMOR_S
	max_combined_volume = WEIGHT_VOLUME_SMALL * 2

/obj/item/clothing/accessory/storage/pouches/blue
	desc = "A collection of blue pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_blue"

/obj/item/clothing/accessory/storage/pouches/navy
	desc = "A collection of navy blue pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_navy"

/obj/item/clothing/accessory/storage/pouches/green
	desc = "A collection of green pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_green"

/obj/item/clothing/accessory/storage/pouches/tan
	desc = "A collection of tan pouches that can be attached to a plate carrier. Carries up to two items."
	icon_state = "pouches_tan"

/obj/item/clothing/accessory/storage/pouches/large
	name = "large storage pouches"
	desc = "A collection of black pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches"
	max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	weight = ITEM_WEIGHT_STORAGE_POUCH_LARGE
	encumbrance = ITEM_ENCUMBRANCE_STORAGE_POUCH_LARGE

/obj/item/clothing/accessory/storage/pouches/large/blue
	desc = "A collection of blue pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_blue"

/obj/item/clothing/accessory/storage/pouches/large/navy
	desc = "A collection of navy blue pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_navy"

/obj/item/clothing/accessory/storage/pouches/large/green
	desc = "A collection of green pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_green"

/obj/item/clothing/accessory/storage/pouches/large/tan
	desc = "A collection of tan pouches that can be attached to a plate carrier. Carries up to four items."
	icon_state = "lpouches_tan"

////////////////
//Shotgun Shell Holder
////////////////

/obj/item/clothing/accessory/storage/shotgun_shell_holder
	name = "shotgun shell pouch"
	desc = "A set of eight pouches designed to hold shotgun shells for easy access."
	icon_override = 'icons/mob/clothing/modular_armor.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "shotholder"
	slot = ACCESSORY_SLOT_ARMOR_S
	max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	insertion_whitelist = list(
		/obj/item/ammo_casing/a12g,
	)

/obj/item/clothing/accessory/storage/shotgun_shell_holder/update_icon_state()
	icon_state = "shotholder-[length(contents)]"
	return ..()

////////////////
//Armor plates
////////////////
/obj/item/clothing/accessory/armor/armorplate
	name = "light armor plate"
	desc = "A lightweight armor plate made of tightly woven polyethylene filaments with a thick coating of steel covering the surface. Designed to catch projectiles instead of outright stop, it functions best against low-power weapons of any type. Fits within a plate carrier."
	icon_state = "armor_light"
	body_cover_flags = UPPER_TORSO|LOWER_TORSO
	armor_type = /datum/armor/station/light
	slot = ACCESSORY_SLOT_ARMOR_C

/obj/item/clothing/accessory/armorplate/get_fibers()
	return null	//Plates do not shed

/obj/item/clothing/accessory/armor/armorplate/stab
	name = "stab vest insert"
	desc = "A synthetic mesh armor insert made of densely woven aromatic polyamide fibers and coated in a layer of malleable ballistic gelatin. Great for dealing with anything from small blades to large clubs. Fits within a plate carrier."
	icon_state = "armor_stab"
	armor_type = /datum/armor/station/stab

/obj/item/clothing/accessory/armor/armorplate/medium
	name = "medium armor plate"
	desc = "An armor plate composed of a single sheet of polyethylene-reinforced steel, and a layer of ceramic at the front and back. It provides good protection with a focus on powerful ballistics. Fits within a plate carrier."
	icon_state = "armor_medium"
	armor_type = /datum/armor/station/medium

/obj/item/clothing/accessory/armor/armorplate/mediumtreated
	name = "treated medium armor plate"
	desc = "An armor plate of steel with ceramic layering treated with a highly reflective cobalt-chromium-tungsten alloy. Provides good protection with a focus on laser absorption. Fits within a plate carrier."
	icon_state = "armor_medium_treated"
	armor_type = /datum/armor/station/mediumtreated

/obj/item/clothing/accessory/armor/armorplate/heavy
	name = "strong armor plate"
	desc = "A strong silicon carbide armor plate sporting a polyurethane elastomeric coating to mitigate spalling from lower calibers as they're deflected. It provides excellent protection against ballistics. Fits within a plate carrier."
	icon_state = "armor_heavy"
	armor_type = /datum/armor/station/heavy

/obj/item/clothing/accessory/armor/armorplate/tactical
	name = "tactical armor plate"
	desc = "An armor plate designed for variety in the wilderness, this steel plate has a tight jacket of polyethylene filaments, and is coated in a reflective cobalt-chromium alloy. Bullet, laser, or animal, this plate can handle all of it evenly. Fits within a plate carrier."
	icon_state = "armor_tactical"
	armor_type = /datum/armor/station/tactical

/obj/item/clothing/accessory/armor/armorplate/combat
	name = "combat armor plate"
	desc = "A hardened steel armor plate, providing solid protection from ballistics and lasers. Suitable for combat with firearms of any type, but offers minimal protection from hand to hand.  Fits within a plate carrier."
	icon_state = "armor_combat"
	armor_type = /datum/armor/station/combat

/obj/item/clothing/accessory/armor/armorplate/ballistic
	name = "ballistic armor plate"
	desc = "A hefty silicon carbide armor plate with a layer of heavy tungsten, followed by a second coating of a polyurethane elastomeric to mitigate spalling from lower calibers as they're deflected. It's design is state of of the art when it comes to ballistics, and as a concequence the material is rather heavy, and is not as capable of dispersing laser fire as other armor varients. Fits within a plate carrier."
	icon_state = "armor_ballistic"
	weight = ITEM_WEIGHT_ARMOR_SPECIALIZED
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_SPECIALIZED
	armor_type = /datum/armor/station/ballistic

/obj/item/clothing/accessory/armor/armorplate/riot
	name = "riot armor plate"
	desc = "A synthetic mesh armor insert made of densely woven aromatic polyamide fibers, coated in malleable ballistic gelatin, and finally tight-jacketed with woven steel-polyethylene filaments. This provides excellent protection against low-velocity trauma, but most modern projectiles could tear through it with ease. Fits within a plate carrier."
	icon_state = "armor_riot"
	weight = ITEM_WEIGHT_ARMOR_SPECIALIZED
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_SPECIALIZED
	armor_type = /datum/armor/station/riot
	siemens_coefficient = 0.5

/obj/item/clothing/accessory/armor/armorplate/ablative
	name = "ablative armor plate"
	desc = "A highly reflective cobalt-chromium-tungsten alloy forms the seemingly jagged surface of the armor plate, which is adorned in perfectly cut and fitted glass prisms that form a smooth low-poly surface. When the ablative armor plate is working as designed, the glass prisms reflect laser fire inwards towards the innermost vertex for subsequent 'ablation', and sometimes reflection. There is a warning label on the back that warns you. It reads: Attempting to use this ablative armor plate to deflect ballistics and/or non-standard energy beams could result in 'rapid deconstruction' of the armor plate and its user. Fits within a plate carrier."
	icon_state = "armor_ablative"
	weight = ITEM_WEIGHT_ARMOR_SPECIALIZED
	encumbrance = ITEM_ENCUMBRANCE_ARMOR_SPECIALIZED
	armor_type = /datum/armor/station/ablative
	siemens_coefficient = 0.2

/obj/item/clothing/accessory/armor/armorplate/ablative/equipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	// if you're reading this: this is not the right way to do shieldcalls
	// this is just a lazy implementation
	// signals have highest priority, this as a piece of armor shouldn't have that.
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL, PROC_REF(shieldcall))

/obj/item/clothing/accessory/armor/armorplate/ablative/unequipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL)

/obj/item/clothing/accessory/armor/armorplate/ablative/proc/shieldcall(mob/defending, list/shieldcall_args, fake_attack)
	var/damage_source = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
	var/def_zone = shieldcall_args[SHIELDCALL_ARG_HIT_ZONE]
	if(istype(damage_source, /obj/projectile/energy) || istype(damage_source, /obj/projectile/beam))
		var/obj/projectile/P = damage_source

		if(P.reflected)
			return

		var/reflectchance = 20 - round(shieldcall_args[SHIELDCALL_ARG_DAMAGE]/3)
		if(!(def_zone in list(BP_TORSO, BP_GROIN)))
			reflectchance /= 2
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [defending]'s [src.name] reflects [P]!</span>")


			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(defending)

			P.legacy_redirect(new_x, new_y, curloc, defending)
			P.reflected = 1
			shieldcall_args[SHIELDCALL_ARG_FLAGS] |= SHIELDCALL_FLAGS_FOR_PROJECTILE_DEFLECT

//////////////
//Arm guards
//////////////
/obj/item/clothing/accessory/armor/armguards
	name = "arm guards"
	desc = "A pair of black arm pads reinforced with armor plating. Attaches to a plate carrier."
//	accessory_icons = list(slot_tie_str = 'icons/mob/clothing/modular_armor.dmi', SLOT_ID_SUIT = 'icons/mob/clothing/modular_armor.dmi')
	icon_state = "armguards"
	gender = PLURAL
	body_cover_flags = ARMS
	armor_type = /datum/armor/station/medium
	slot = ACCESSORY_SLOT_ARMOR_A

/obj/item/clothing/accessory/armor/armguards/blue
	desc = "A pair of blue arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_blue"

/obj/item/clothing/accessory/armor/armguards/navy
	desc = "A pair of navy blue arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_navy"

/obj/item/clothing/accessory/armor/armguards/green
	desc = "A pair of green arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_green"

/obj/item/clothing/accessory/armor/armguards/tan
	desc = "A pair of tan arm pads reinforced with armor plating. Attaches to a plate carrier."
	icon_state = "armguards_tan"

/obj/item/clothing/accessory/armor/armguards/combat
	name = "heavy arm guards"
	desc = "A pair of red-trimmed black arm pads reinforced with heavy armor plating. Attaches to a plate carrier."
	icon_state = "armguards_combat"
	armor_type = /datum/armor/station/combat

/obj/item/clothing/accessory/armor/armguards/ablative
	name = "ablative arm guards"
	desc = "These arm guards will protect your arms from energy weapons."
	icon_state = "armguards_ablative"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.4 //This is worse than the other ablative pieces, to avoid this from becoming the poor warden's insulated gloves.
	armor_type = /datum/armor/station/ablative

/obj/item/clothing/accessory/armor/armguards/ballistic
	name = "ballistic arm guards"
	desc = "These arm guards will protect your arms from ballistic weapons."
	icon_state = "armguards_ballistic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.7
	armor_type = /datum/armor/station/ballistic

/obj/item/clothing/accessory/armor/armguards/riot
	name = "riot arm guards"
	desc = "These arm guards will protect your arms from close combat weapons."
	icon_state = "armguards_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "swat", SLOT_ID_LEFT_HAND = "swat")
	siemens_coefficient = 0.5
	armor_type = /datum/armor/station/riot

//////////////
//Leg guards
//////////////
/obj/item/clothing/accessory/armor/legguards
	name = "leg guards"
	desc = "A pair of armored leg pads in black. Attaches to a plate carrier."
//	accessory_icons = list(slot_tie_str = 'icons/mob/clothing/modular_armor.dmi', SLOT_ID_SUIT = 'icons/mob/clothing/modular_armor.dmi')
	icon_state = "legguards"
	gender = PLURAL
	body_cover_flags = LEGS
	armor_type = /datum/armor/station/medium
	slot = ACCESSORY_SLOT_ARMOR_L

/obj/item/clothing/accessory/armor/legguards/blue
	desc = "A pair of armored leg pads in blue. Attaches to a plate carrier."
	icon_state = "legguards_blue"

/obj/item/clothing/accessory/armor/legguards/navy
	desc = "A pair of armored leg pads in navy blue. Attaches to a plate carrier."
	icon_state = "legguards_navy"

/obj/item/clothing/accessory/armor/legguards/green
	desc = "A pair of armored leg pads in green. Attaches to a plate carrier."
	icon_state = "legguards_green"

/obj/item/clothing/accessory/armor/legguards/tan
	desc = "A pair of armored leg pads in tan. Attaches to a plate carrier."
	icon_state = "legguards_tan"

/obj/item/clothing/accessory/armor/legguards/combat
	name = "heavy leg guards"
	desc = "A pair of heavily armored leg pads in red-trimmed black. Attaches to a plate carrier."
	icon_state = "legguards_combat"
	armor_type = /datum/armor/station/combat

/obj/item/clothing/accessory/armor/legguards/ablative
	name = "ablative leg guards"
	desc = "These will protect your legs from energy weapons."
	icon_state = "legguards_ablative"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.1
	armor_type = /datum/armor/station/ablative

/obj/item/clothing/accessory/armor/legguards/ballistic
	name = "ballistic leg guards"
	desc = "These will protect your legs from ballistic weapons."
	icon_state = "legguards_ballistic"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.7
	armor_type = /datum/armor/station/ballistic

/obj/item/clothing/accessory/armor/legguards/riot
	name = "riot leg guards"
	desc = "These will protect your legs from close combat weapons."
	icon_state = "legguards_riot"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "jackboots", SLOT_ID_LEFT_HAND = "jackboots")
	siemens_coefficient = 0.5
	armor_type = /datum/armor/station/riot

//////////////////////////
//Decorative attachments
//////////////////////////
/obj/item/clothing/accessory/armor/tag
	name = "\improper SCG Flag"
	desc = "An emblem depicting the Solar Confederate Government's flag."
//	accessory_icons = list(slot_tie_str = 'icons/mob/clothing/modular_armor.dmi', SLOT_ID_SUIt = 'icons/mob/clothing/modular_armor.dmi')
	icon_state = "solflag"
	slot = ACCESSORY_SLOT_ARMOR_M
	w_class = WEIGHT_CLASS_SMALL

//Nanotrasen
/obj/item/clothing/accessory/armor/tag/nts
	name = "\improper CORPORATE SECURITY tag"
	desc = "An armor tag with the words CORPORATE SECURITY printed in red lettering."
	icon_state = "ntstag"

/obj/item/clothing/accessory/armor/tag/ntbs
	name = "\improper BLUESHIELD tag"
	desc = "An armor tag with the words BLUESHIELD printed in blue lettering."
	icon_state = "ntbstag"

/obj/item/clothing/accessory/armor/tag/ntc
	name = "\improper CORPORATE SEC-COM tag"
	desc = "An armor tag with the words CORPORATE SEC-COM printed in gold lettering."
	icon_state = "ntctag"

/obj/item/clothing/accessory/armor/tag/para
	name = "\improper PARACAUSAL ANOMALY RESPONSE tag"
	desc = "An armor tag with the words PARACAUSAL ANOMALY RESPONSE printed in silver lettering."
	icon_state = "paratag"

/obj/item/clothing/accessory/armor/tag/pmd
	name = "\improper PMD patch"
	desc = "An embroidered patch bearing the PMD's half-lidded eye Icon."
	icon_state = "pmdtag"

//Other
/obj/item/clothing/accessory/armor/tag/sifguard
	name = "\improper Sif Defense Force crest"
	desc = "An emblem depicting the crest of the Sif Defense Force."
	icon_state = "ecflag"

/obj/item/clothing/accessory/armor/tag/civsec
	name = "\improper Security tag"
	desc = "An armor tag with the word SECURITY printed in silver lettering."
	icon_state = "sectag"

/obj/item/clothing/accessory/armor/tag/com
	name = "\improper SCG tag"
	desc = "An armor tag with the words SOLAR CONFEDERATE GOVERNMENT printed in gold lettering."
	icon_state = "comtag"

/obj/item/clothing/accessory/armor/tag/pcrc
	name = "\improper PCRC tag"
	desc = "An armor tag with the words PROXIMA CENTAURI RISK CONTROL printed in cyan lettering."
	icon_state = "pcrctag"

/obj/item/clothing/accessory/armor/tag/saare
	name = "\improper SAARE tag"
	desc = "An armor tag with the acronym SAARE printed in olive-green lettering."
	icon_state = "saaretag"

/obj/item/clothing/accessory/armor/tag/opos
	name = "\improper O+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O POSITIVE."
	icon_state = "opostag"

/obj/item/clothing/accessory/armor/tag/oneg
	name = "\improper O- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as O NEGATIVE."
	icon_state = "onegtag"

/obj/item/clothing/accessory/armor/tag/apos
	name = "\improper A+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A POSITIVE."
	icon_state = "apostag"

/obj/item/clothing/accessory/armor/tag/aneg
	name = "\improper A- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as A NEGATIVE."
	icon_state = "anegtag"

/obj/item/clothing/accessory/armor/tag/bpos
	name = "\improper B+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B POSITIVE."
	icon_state = "bpostag"

/obj/item/clothing/accessory/armor/tag/bneg
	name = "\improper B- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as B NEGATIVE."
	icon_state = "bnegtag"

/obj/item/clothing/accessory/armor/tag/abpos
	name = "\improper AB+ blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB POSITIVE."
	icon_state = "abpostag"

/obj/item/clothing/accessory/armor/tag/abneg
	name = "\improper AB- blood patch"
	desc = "An embroidered patch indicating the wearer's blood type as AB NEGATIVE."
	icon_state = "abnegtag"

/obj/item/clothing/accessory/armor/tag/press
	name = "\improper PRESS tag"
	desc = "An armor tag with the words PRESS emblazoned in bold white lettering."
	icon_state = "presstag"

/////////////////
// Helmet Covers
/////////////////

/obj/item/clothing/accessory/armor/helmcover
	name = "helmet cover"
	desc = "A fabric cover for armored helmets."
	icon_override = 'icons/mob/clothing/ties.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "helmcover_blue"
	slot = ACCESSORY_SLOT_HELM_C

/obj/item/clothing/accessory/armor/helmcover/blue
	name = "blue helmet cover"
	desc = "A fabric cover for armored helmets in a bright blue color."
	icon_state = "helmcover_blue"

/obj/item/clothing/accessory/armor/helmcover/navy
	name = "navy blue helmet cover"
	desc = "A fabric cover for armored helmets. This one is colored navy blue."
	icon_state = "helmcover_navy"

/obj/item/clothing/accessory/armor/helmcover/green
	name = "green helmet cover"
	desc = "A fabric cover for armored helmets. This one has a woodland camouflage pattern."
	icon_state = "helmcover_green"

/obj/item/clothing/accessory/armor/helmcover/tan
	name = "tan helmet cover"
	desc = "A fabric cover for armored helmets. This one has a desert camouflage pattern."
	icon_state = "helmcover_tan"

/obj/item/clothing/accessory/armor/helmcover/nt
	name = "\improper Nanotrasen helmet cover"
	desc = "A fabric cover for armored helmets. This one has Nanotrasen's colors."
	icon_state = "helmcover_nt"

/obj/item/clothing/accessory/armor/helmcover/pcrc
	name = "\improper PCRC helmet cover"
	desc = "A fabric cover for armored helmets. This one is colored navy blue and has a tag in the back with the words PROXIMA CENTAURI RISK CONTROL printed in cyan lettering on it."
	icon_state = "helmcover_pcrc"

/obj/item/clothing/accessory/armor/helmcover/saare
	name = "\improper SAARE helmet cover"
	desc = "A fabric cover for armored helmets. This one has SAARE's colors."
	icon_state = "helmcover_saare"

/////////////////
//Helmet Cameras
/////////////////

/obj/item/clothing/accessory/armor/helmetcamera
	name = "helmet camera"
	desc = "A small camera that attaches to helmets."
	icon_override = 'icons/mob/clothing/ties.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "helmcam"
	slot = ACCESSORY_SLOT_HELM_R
	var/obj/machinery/camera/camera
	var/list/camera_networks
	camera_networks = list(NETWORK_CIV_HELMETS)


/obj/item/clothing/accessory/armor/helmetcamera/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(camera_networks)
		if(!camera)
			camera = new /obj/machinery/camera(src)
			camera.replace_networks(camera_networks)
			camera.set_status(FALSE) //So the camera will activate in the following check.

		if(camera.status == TRUE)
			camera.set_status(FALSE)
			to_chat(usr, "<font color=#4F49AF>Camera deactivated.</font>")
		else
			camera.set_status(TRUE)
			camera.c_tag = usr.name
			to_chat(usr, "<font color=#4F49AF>User scanned as [camera.c_tag]. Camera activated.</font>")
	else
		to_chat(usr, "This object does not have a camera.") //Shouldnt ever be visible for helmet cams.
		return

/obj/item/clothing/accessory/armor/helmetcamera/examine(mob/user, dist)
	. = ..()
	if(camera_networks && get_dist(user,src) <= 1)
		. += "The [camera ? "" : "in"]active."

/obj/item/clothing/accessory/armor/helmetcamera/body
	name = "body camera"
	desc = "A small camera that attaches to most uniforms."
	icon_override = 'icons/mob/clothing/ties.dmi'
	icon = 'icons/obj/clothing/modular_armor.dmi'
	icon_state = "helmcam_body"
	slot = ACCESSORY_SLOT_DECOR
	camera_networks = list(NETWORK_CIV_HELMETS)

/obj/item/clothing/accessory/armor/helmetcamera/security
	name = "security helmet camera"
	desc = "A small camera that attaches to helmets. This one has its feed restricted to Security."
	icon_state = "helmcam_sec"
	camera_networks = list(NETWORK_SEC_HELMETS)

/obj/item/clothing/accessory/armor/helmetcamera/security/body
	name = "security body camera"
	desc = "A small camera that attaches to most uniforms. This one has its feed restricted to Security."
	icon_state = "helmcam_body_sec"
	slot = ACCESSORY_SLOT_DECOR

/obj/item/clothing/accessory/armor/helmetcamera/exploration
	name = "exploration helmet camera"
	desc = "A small camera that attaches to helmets. This one has its feed restricted to Exploration."
	icon_state = "helmcam_explo"
	camera_networks = list(NETWORK_EXPLO_HELMETS)

/obj/item/clothing/accessory/armor/helmetcamera/exploration/body
	name = "exploration body camera"
	desc = "A small camera that attaches to most uniforms. This one has its feed restricted to Exploration."
	slot = ACCESSORY_SLOT_DECOR
	icon_state = "helmcam_body_explo"

//Lightweight Limb Plating - These are incompatible with plate carriers.

//Debug variant
/obj/item/clothing/accessory/armor/limb_plate
	name = "armor plating"
	desc = "You shouldn't be seeing this. Contact a Maintainer."
	icon = 'icons/obj/clothing/ties.dmi'
	icon_override = 'icons/mob/clothing/ties.dmi'
	icon_state = "bronze"
	armor_type = /datum/armor/station/light

/obj/item/clothing/accessory/armor/limb_plate/arm_l
	name = "left shoulder plate"
	desc = "A sturdy, unadorned armor plate. Attaches to a plate harness."
	icon_state = "arm_plate_l"
	slot = ACCESSORY_SLOT_ARMOR_C

/obj/item/clothing/accessory/armor/limb_plate/arm_r
	name = "right shoulder plate"
	desc = "A sturdy, unadorned armor plate. Attaches to a plate harness."
	icon_state = "arm_plate_r"
	slot = ACCESSORY_SLOT_ARMOR_A

/obj/item/clothing/accessory/armor/limb_plate/leg_l
	name = "left thigh plate"
	desc = "A sturdy, unadorned armor plate. Attaches to a plate harness."
	icon_state = "leg_plate_l"
	slot = ACCESSORY_SLOT_ARMOR_L

/obj/item/clothing/accessory/armor/limb_plate/leg_r
	name = "right thigh plate"
	desc = "A sturdy, unadorned armor plate. Attaches to a plate harness."
	icon_state = "leg_plate_r"
	slot = ACCESSORY_SLOT_ARMOR_M

//EMT Subtypes
/obj/item/clothing/accessory/armor/limb_plate/arm_l/emt
	name = "left shoulder plate (Paramedic)"
	desc = "A sturdy, armor plate marked with medical insignia. Attaches to a plate harness."
	icon_state = "arm_paramed_l"

/obj/item/clothing/accessory/armor/limb_plate/arm_r/emt
	name = "right shoulder plate (Paramedic)"
	desc = "A sturdy, armor plate marked with medical insignia. Attaches to a plate harness."
	icon_state = "arm_paramed_r"

/obj/item/clothing/accessory/armor/limb_plate/leg_l/emt
	name = "left thigh plate (Paramedic)"
	desc = "A sturdy, armor plate marked with medical insignia. Attaches to a plate harness."
	icon_state = "leg_paramed_l"

/obj/item/clothing/accessory/armor/limb_plate/leg_r/emt
	name = "right thigh plate (Paramedic)"
	desc = "A sturdy, armor plate marked with medical insignia. Attaches to a plate harness."
	icon_state = "leg_paramed_r"
