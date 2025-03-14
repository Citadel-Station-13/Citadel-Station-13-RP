///////////////////////////////////////////////////////////////////////
//Glasses
/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/
///////////////////////////////////////////////////////////////////////

/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_EYES
	active_slots = list(SLOT_ID_GLASSES)
	var/prescription = 0
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'

	//? Glasses - Toggling
	/// Uses toggle system
	var/toggleable = FALSE
	/// On?
	var/active = TRUE
	/// icon state when off
	var/inactive_icon_state = "degoggles"
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/list/away_planes //Holder for disabled planes

	//? Glasses - Modify
	/// Sight Modifiers - applies in active slots. This should be unique to the glasses!
	var/datum/vision/vision_modifier
	var/vision_flags = NONE
	var/vision_flags_remove = NONE

/obj/item/clothing/glasses/equipped(mob/user, slot, flags)
	. = ..()
	if((!toggleable || active) && (slot in active_slots))
		if(!isnull(vision_modifier))
			user.add_vision_modifier(vision_modifier)

/obj/item/clothing/glasses/unequipped(mob/user, slot, flags)
	. = ..()
	if(!isnull(vision_modifier))
		user.remove_vision_modifier(vision_modifier)

/obj/item/clothing/glasses/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(toggleable)
		var/mob/wearer = get_worn_mob()
		if(active)
			active = 0
			icon_state = inactive_icon_state
			if(worn_slot != SLOT_ID_HANDS)
				update_worn_icon()
			if(worn_slot in active_slots)
				if(!isnull(vision_modifier))
					wearer.remove_vision_modifier(vision_modifier)
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			away_planes = enables_planes
			enables_planes = null
			to_chat(usr, "You deactivate the optical matrix on the [src].")
		else
			active = 1
			icon_state = initial(icon_state)
			if(worn_slot != SLOT_ID_HANDS)
				user.update_inv_glasses()
			if(worn_slot in active_slots)
				if(!isnull(vision_modifier))
					wearer.add_vision_modifier(vision_modifier)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			enables_planes = away_planes
			away_planes = null
			to_chat(usr, "You activate the optical matrix on the [src].")
		update_action_buttons()
		user.recalculate_vis()
	..()

/*---Tinted Glasses!---*/
/obj/item/clothing/glasses/tinted
	name = "light blue tinted glasses"
	desc = "A pair of glasses with a light blue tint on the inside to change your whole worldview."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "glasses"
	body_cover_flags = EYES

/obj/item/clothing/glasses/tinted/color/yellow
	name = "yellow tinted glasses"
	desc = "A pair of glasses with a yellow tint on the inside to change your whole worldview."
	icon_state = "glasses_yellow"

/obj/item/clothing/glasses/tinted/color/blue
	name = "blue tinted glasses"
	desc = "A pair of glasses with a blue tint on the inside to change your whole worldview."
	icon_state = "glasses_blue"
	item_state = "glasses_blue"

/obj/item/clothing/glasses/tinted/color/pink
	name = "pink tinted glasses"
	desc = "A pair of glasses with a pink tint on the inside to change your whole worldview."
	icon_state = "glasses_pink"
	item_state = "glasses_pink"

/obj/item/clothing/glasses/tinted/color/beige
	name = "beige tinted glasses"
	desc = "A pair of glasses with a beige tint on the inside to change your whole worldview."
	icon_state = "glasses_beige"
	item_state = "glasses_beige"

/obj/item/clothing/glasses/tinted/color/orange
	name = "orange tinted glasses"
	desc = "A pair of glasses with a orange tint on the inside to change your whole worldview."
	icon_state = "glasses_orange"
	item_state = "glasses_orange"

/obj/item/clothing/glasses/tinted/color/green
	name = "green tinted glasses"
	desc = "A pair of glasses with a green tint on the inside to change your whole worldview."
	icon_state = "glasses_green"
	item_state = "glasses_green"

/obj/item/clothing/glasses/tinted/color/red
	name = "red tinted glasses"
	desc = "A pair of glasses with a red tint on the inside to change your whole worldview."
	icon_state = "glasses_red"
	item_state = "glasses_red"

/obj/item/clothing/glasses/tinted/color/purple
	name = "purple tinted glasses"
	desc = "A pair of glasses with a purple tint on the inside to change your whole worldview."
	icon_state = "glasses_purple"
	item_state = "glasses_purple"

/*---The rest of the normal stuff---*/
/obj/item/clothing/glasses/meson
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "meson", SLOT_ID_LEFT_HAND = "meson")
	item_action_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = 1
	vision_flags = SEE_TURFS
	vision_flags_remove = SEE_BLACKNESS
	body_cover_flags = EYES //cit change
	vision_modifier = /datum/vision/augmenting/legacy_ghetto_nvgs
	worth_intrinsic = 125

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical Meson Scanner with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/meson/aviator
	name = "engineering aviators"
	icon_state = "aviator_eng"
	inactive_icon_state = "aviator"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sunglasses", SLOT_ID_LEFT_HAND = "sunglasses")
	item_action_name = "Toggle HUD"
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/meson/aviator/prescription
	name = "prescription engineering aviators"
	desc = "Engineering Aviators with prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/hud/health/aviator
	name = "medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD."
	icon_state = "aviator_med"
	inactive_icon_state = "aviator"
	item_action_name = "Toggle Mode"
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/hud/health/aviator/prescription
	name = "prescription medical HUD aviators"
	desc = "Modified aviator glasses with a toggled health HUD. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	toggleable = 1
	item_action_name = "Toggle Goggles"
	body_cover_flags = EYES
	clothing_flags = SCAN_REAGENTS

/obj/item/clothing/glasses/goggles
	name = "goggles"
	desc = "Just some plain old goggles."
	icon_state = "plaingoggles"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	body_cover_flags = EYES
	atom_flags = PHORONGUARD

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	origin_tech = list(TECH_MAGNET = 2)
	toggleable = 1
	item_action_name = "Toggle Goggles"
	body_cover_flags = EYES // Cit change
	inactive_icon_state = "denight"
	flash_protection = FLASH_PROTECTION_REDUCED
	vision_modifier = /datum/vision/baseline/nvg_lowtech

/obj/item/clothing/glasses/night/vox
	name = "Alien Optics"
	species_restricted = list(SPECIES_VOX)
	atom_flags = PHORONGUARD

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blindfold", SLOT_ID_LEFT_HAND = "blindfold")
	body_cover_flags = 0
	var/eye = null
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'


/obj/item/clothing/glasses/eyepatchwhite
	name = "eyepatch"
	desc = "A simple eyepatch made of a strip of cloth tied around the head."
	icon_state = "eyepatch_white"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blindfold", SLOT_ID_LEFT_HAND = "blindfold")
	body_cover_flags = 0
	var/eye = null

/obj/item/clothing/glasses/eyepatchwhite/verb/switcheye()
	set name = "Switch Eyepatch"
	set category = VERB_CATEGORY_OBJECT
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	eye = !eye
	if(eye)
		icon_state = "[icon_state]_1"
	else
		icon_state = initial(icon_state)
	update_worn_icon()

/obj/item/clothing/glasses/eyepatch/verb/switcheye()
	set name = "Switch Eyepatch"
	set category = VERB_CATEGORY_OBJECT
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	eye = !eye
	if(eye)
		icon_state = "[icon_state]_1"
	else
		icon_state = initial(icon_state)
	update_worn_icon()

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "headset", SLOT_ID_LEFT_HAND = "headset")
	body_cover_flags = 0

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	toggleable = 1
	item_action_name = "Toggle Goggles"
	vision_flags = SEE_OBJS
	vision_flags_remove = SEE_BLACKNESS
	body_cover_flags = EYES //cit change
	vision_modifier = /datum/vision/augmenting/legacy_ghetto_nvgs

/obj/item/clothing/glasses/material/prescription
	name = "prescription optical material scanner"
	prescription = 1

/obj/item/clothing/glasses/graviton
	name = "graviton goggles"
	desc = "The secrets of space travel are.. not quite yours."
	icon_state = "grav"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	origin_tech = list(TECH_MAGNET = 2, TECH_BLUESPACE = 1)
	toggleable = 1
	item_action_name = "Toggle Goggles"
	inactive_icon_state = "denight"
	vision_flags = SEE_OBJS | SEE_TURFS
	vision_flags_remove = SEE_BLACKNESS
	body_cover_flags = EYES // Cit change
	flash_protection = FLASH_PROTECTION_REDUCED
	vision_modifier = /datum/vision/augmenting/legacy_ghetto_nvgs

/obj/item/clothing/glasses/regular
	name = "prescription glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	prescription = 1
	body_cover_flags = 0

/obj/item/clothing/glasses/regular/scanners
	name = "scanning goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

/obj/item/clothing/glasses/regular/hipster
	name = "prescription glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	body_cover_flags = 0

/obj/item/clothing/glasses/gglasses
	name = "green glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	body_cover_flags = 0

/obj/item/clothing/glasses/regular/rimless
	name = "prescription rimless glasses"
	desc = "Sleek modern glasses with a single sculpted lens."
	icon_state = "glasses_rimless"

/obj/item/clothing/glasses/rimless
	name = "rimless glasses"
	desc = "Sleek modern glasses with a single sculpted lens."
	icon_state = "glasses_rimless"
	prescription = 0

/obj/item/clothing/glasses/regular/thin
	name = "prescription thin-rimmed glasses"
	desc = "Glasses with frames are so last century."
	icon_state = "glasses_thin"
	prescription = 1

/obj/item/clothing/glasses/thin
	name = "thin-rimmed glasses"
	desc = "Glasses with frames are so last century."
	icon_state = "glasses_thin"
	prescription = 0

/obj/item/clothing/glasses/regular/thick
	name = "prescription thick glasses"
	desc = "Glasses with extra thick lenses."
	icon_state = "glasses_thick"
	prescription = 1

/obj/item/clothing/glasses/thick
	name = "thick glasses"
	desc = "Glasses with extra thick lenses."
	icon_state = "glasses_thick"
	prescription = 0

/obj/item/clothing/glasses/regular/dark
	name = "prescription dark framed glasses"
	desc = "Glasses with a darker frame."
	icon_state = "glasses_alt"
	prescription = 1

/obj/item/clothing/glasses/dark
	name = "dark framed glasses"
	desc = "Glasses with a darker frame."
	icon_state = "glasses_alt"
	prescription = 0

/obj/item/clothing/glasses/regular/scan
	name = "prescription scanner glasses"
	desc = "Glasses with a scanner device installed."
	icon_state = "glasses_scan"
	prescription = 1

/obj/item/clothing/glasses/scan
	name = "scanner glasses"
	desc = "Glasses with a scanner device installed."
	icon_state = "glasses_scan"
	prescription = 0

/obj/item/clothing/glasses/sunglasses
	name = "sunglasses"
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	icon_state = "sun"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sunglasses", SLOT_ID_LEFT_HAND = "sunglasses")
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/sunglasses/aviator
	name = "aviators"
	desc = "A pair of designer sunglasses."
	icon_state = "aviator"

/obj/item/clothing/glasses/sunglasses/aureate
	name = "aureate headdress"
	desc = "An elegant head-mounted ornament. It's shaped like a crown, and obscures quite a bit of bright light, but not enough for welding."
	icon_state = "aureate_headdress"
	icon = 'icons/clothing/head/aureate.dmi'
	worn_render_flags = WORN_RENDER_SLOT_ONE_FOR_ALL

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "welding-g", SLOT_ID_LEFT_HAND = "welding-g")
	item_action_name = "Flip Welding Goggles"
	materials_base = list(MAT_STEEL = 1500, MAT_GLASS = 1000)
	var/up = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY

/obj/item/clothing/glasses/welding/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	toggle(user)

/obj/item/clothing/glasses/welding/update_icon_state()
	icon_state = "[base_icon_state || initial(icon_state)][up ? "up" : ""]"
	return ..()

/obj/item/clothing/glasses/welding/verb/toggle_verb()
	set category = VERB_CATEGORY_OBJECT
	set name = "Adjust welding goggles"
	set src in usr

	toggle(usr)

/obj/item/clothing/glasses/welding/proc/toggle(mob/user)
	if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
		return

	if(src.up)
		src.up = !src.up
		inv_hide_flags |= HIDEEYES
		set_body_cover_flags(body_cover_flags | EYES)
		flash_protection = initial(flash_protection)
		tint = initial(tint)
		to_chat(usr, "You flip \the [src] down to protect your eyes.")
	else
		src.up = !src.up
		inv_hide_flags &= ~HIDEEYES
		set_body_cover_flags(body_cover_flags & ~EYES)
		flash_protection = FLASH_PROTECTION_NONE
		tint = TINT_NONE
		to_chat(usr, "You push \the [src] up out of your face.")
	update_full_icon()

/obj/item/clothing/glasses/welding/prescription
	name = "prescription welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association. These ones have prescription lenses."
	prescription = 1

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	tint = TINT_MODERATE

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blindfold", SLOT_ID_LEFT_HAND = "blindfold")
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = BLIND
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/*obj/item/clothing/glasses/sunglasses/blindfold/equipped(mob/user, slot, flags)
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = user
		loc.add_modifier(/datum/modifier/sight/blindness)*/


/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = null, SLOT_ID_LEFT_HAND = null)
	w_class = WEIGHT_CLASS_TINY

/obj/item/clothing/glasses/sunglasses/fakeblindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blindfold", SLOT_ID_LEFT_HAND = "blindfold")
	flash_protection = FLASH_PROTECTION_NONE
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'

/obj/item/clothing/glasses/sunglasses/fakeblindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = null, SLOT_ID_LEFT_HAND = null)
	w_class = WEIGHT_CLASS_TINY

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 1

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"

/obj/item/clothing/glasses/fakesunglasses //Sunglasses without flash immunity
	name = "stylish sunglasses"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "sun"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sunglasses", SLOT_ID_LEFT_HAND = "sunglasses")

/obj/item/clothing/glasses/fakesunglasses/aviator
	name = "stylish aviators"
	desc = "A pair of designer sunglasses. Doesn't seem like it'll block flashes."
	icon_state = "aviator"

/obj/item/clothing/glasses/sunglasses/sechud
	name = "\improper HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhudsec"

/obj/item/clothing/glasses/sunglasses/sechud/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/hud_granter, list(/datum/atom_hud/data/human/security/advanced), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/sunglasses/sechud/tactical
	name = "tactical HUD"
	desc = "Flash-resistant goggles with inbuilt combat and security information."
	icon_state = "swatgoggles"
	body_cover_flags = EYES

/obj/item/clothing/glasses/sunglasses/sechud/aviator
	name = "security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes."
	icon_state = "aviator_sec"
	inactive_icon_state = "aviator"
	item_action_name = "Toggle Mode"
	var/on = 1
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

/obj/item/clothing/glasses/sunglasses/sechud/aviator/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			flash_protection = FLASH_PROTECTION_NONE
			enables_planes = away_planes
			away_planes = null
			to_chat(usr, "You switch the [src] to HUD mode.")
		else
			flash_protection = initial(flash_protection)
			away_planes = enables_planes
			enables_planes = null
			to_chat(usr, "You switch \the [src] to flash protection mode.")
		update_icon()
		SEND_SOUND(user, activation_sound)
		user.recalculate_vis()
		update_worn_icon()
		update_action_buttons()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/update_icon_state()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = inactive_icon_state
	return ..()

/obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription
	name = "prescription security HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes. Comes with bonus prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/sunglasses/medhud
	name = "\improper HUD sunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunMedHud"

/obj/item/clothing/glasses/sunglasses/medhud/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/hud_granter, list(/datum/atom_hud/data/human/medical), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = 1
	item_action_name = "Toggle Goggles"
	vision_flags = SEE_MOBS
	vision_flags_remove = SEE_BLACKNESS
	vision_modifier = /datum/vision/augmenting/legacy_ghetto_nvgs
	enables_planes = list(/atom/movable/screen/plane_master/cloaked)
	flash_protection = FLASH_PROTECTION_REDUCED

/obj/item/clothing/glasses/thermal/emp_act(severity)
	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = src.loc
		to_chat(M, "<font color='red'>The Optical Thermal Scanner overloads and blinds you!</font>")
		if(M.glasses == src)
			M.apply_status_effect(/datum/status_effect/sight/blindness, 3 SECONDS)
			M.eye_blurry = 5
			// Don't cure being nearsighted
			if(!(M.disabilities & DISABILITY_NEARSIGHTED))
				M.disabilities |= DISABILITY_NEARSIGHTED
				spawn(100)
					M.disabilities &= ~DISABILITY_NEARSIGHTED
	..()

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "meson", SLOT_ID_LEFT_HAND = "meson")
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = 0
	activation_sound = null
	item_action_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "thermonocle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sunglasses", SLOT_ID_LEFT_HAND = "sunglasses")
	toggleable = 1
	item_action_name = "Toggle Monocle"
	atom_flags = NONE //doesn't protect eyes because it's a monocle, duh

	body_cover_flags = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics"
	icon_state = "eyepatch"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "blindfold", SLOT_ID_LEFT_HAND = "blindfold")
	body_cover_flags = 0
	toggleable = 1
	item_action_name = "Toggle Eyepatch"

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "optical thermal implants"
	desc = "A set of implantable lenses designed to augment your vision."
	icon_state = "thermalimplants"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sunglasses", SLOT_ID_LEFT_HAND = "sunglasses")

/obj/item/clothing/glasses/aerogelgoggles
	name = "orange goggles"
	desc = "Teshari designed lightweight goggles."
	icon_state = "orange-g"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	item_action_name = "Adjust Orange Goggles"
	atom_flags = PHORONGUARD
	var/up = 0
	body_cover_flags = EYES
	species_restricted = list(SPECIES_TESHARI)

/obj/item/clothing/glasses/aerogelgoggles/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	toggle()

/obj/item/clothing/glasses/aerogelgoggles/verb/toggle()
	set category = VERB_CATEGORY_OBJECT
	set name = "Adjust Orange Goggles"
	set src in usr

	if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
		if(src.up)
			src.up = !src.up
			inv_hide_flags |= HIDEEYES
			set_body_cover_flags(body_cover_flags | EYES)
			icon_state = initial(icon_state)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			inv_hide_flags &= ~HIDEEYES
			set_body_cover_flags(body_cover_flags & ~EYES)
			icon_state = "[initial(icon_state)]up"
			to_chat(usr, "You push \the [src] up from in front of your eyes.")
		update_worn_icon()
		update_action_buttons()

/obj/item/clothing/glasses/jamjar
	name = "jamjar glasses"
	desc = "A staple of the neo-otaku's wardrobe."
	icon_state = "jamjar_glasses"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	prescription = 1
	body_cover_flags = 0

/obj/item/clothing/glasses/augmentedshades
	name = "augmented shades"
	desc = "A pair of retractable sunglasses lenses."
	icon_state = "jensenshades"
	inactive_icon_state = "jensenshades_off"
	toggleable = 1
	item_action_name = "Toggle Out/In"

/obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold
	name = "white blindfold"
	desc = "A white blindfold that covers the eyes, preventing sight."
	icon_state = "blindfoldwhite"

/obj/item/clothing/glasses/sunglasses/fakeblindfold/whiteblindfold
	name = "white blindfold"
	desc = "A white blindfold that covers the eyes, preventing sight."
	icon_state = "blindfoldwhite"

/obj/item/clothing/glasses/redglasses
	name = "red glasses"
	desc = "A pair of glasses with red lenses that swirl and pulse hypnotically."
	icon_state = "redglasses"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")

/obj/item/clothing/glasses/badglasses
	name = "poorly made glasses"
	desc = "A pair of glasses that look cheaply made. The lenses are prescription, at least...?"
	icon_state = "glasses_alt"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")
	prescription = 1

/obj/item/clothing/glasses/orangeglasses
	name = "orange glasses"
	desc = "A pair of orange glasses."
	icon_state = "orangeglasses"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")

/obj/item/clothing/glasses/proc/prescribe(var/mob/user)
	prescription = !prescription

	//Look it's really not that fancy. It's not ACTUALLY unique scrip data.
	if(prescription)
		name = "[initial(name)] (pr)"
		user.visible_message("[user] replaces the lenses in \the [src] with a new prescription.")
	else
		name = "[initial(name)]"
		user.visible_message("[user] replaces the prescription lenses in \the [src] with generics.")

	playsound(user,'sound/items/screwdriver.ogg', 50, 1)

//Prescription kit
/obj/item/glasses_kit
	name = "prescription glasses kit"
	desc = "A kit containing all the needed tools and parts to develop and apply a prescription for someone."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"
	var/scrip_loaded = 0

/obj/item/glasses_kit/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY))
		return
	if(!istype(user))
		return

	//Too difficult
	if(target == user)
		to_chat(user, "<span class='warning'>You can't use this on yourself. Get someone to help you.</span>")
		return

	//We're applying a prescription
	if(istype(target,/obj/item/clothing/glasses))
		var/obj/item/clothing/glasses/G = target
		if(!scrip_loaded)
			to_chat(user, "<span class='warning'>You need to build a prescription from someone first! Use the kit on someone.</span>")
			return

		if(do_after(user,5 SECONDS))
			G.prescribe(user)
			scrip_loaded = 0

	//We're getting a prescription
	else if(ishuman(target))
		var/mob/living/carbon/human/T = target
		if(T.glasses || (T.head && T.head.inv_hide_flags & HIDEEYES))
			to_chat(user, "<span class='warning'>The person's eyes can't be covered!</span>")
			return

		T.visible_message("[user] begins making measurements for prescription lenses for [target].","[user] begins measuring your eyes. Hold still!")
		if(do_after(user,5 SECONDS,T))
			T.flash_eyes()
			scrip_loaded = 1
			T.visible_message("[user] finishes making prescription lenses for [target].","<span class='warning'>Gah, that's bright!</span>")

	else
		..()

/*---Tajaran-specific Eyewear---*/

/obj/item/clothing/glasses/tajblind
	name = "embroidered veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = 'icons/mob/clothing/eyes.dmi'
	icon_state = "tajblind"
	item_state = "tajblind"
	prescription = 1
	body_cover_flags = EYES

/obj/item/clothing/glasses/hud/health/tajblind
	name = "lightweight veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has an installed medical HUD."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = 'icons/mob/clothing/eyes.dmi'
	icon_state = "tajblind_med"
	item_state = "tajblind_med"
	body_cover_flags = EYES

/obj/item/clothing/glasses/sunglasses/sechud/tajblind
	name = "sleek veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has an in-built security HUD."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = 'icons/mob/clothing/eyes.dmi'
	icon_state = "tajblind_sec"
	item_state = "tajblind_sec"
	prescription = 1
	body_cover_flags = EYES

/obj/item/clothing/glasses/meson/prescription/tajblind
	name = "industrial veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has installed mesons."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = 'icons/mob/clothing/eyes.dmi'
	icon_state = "tajblind_meson"
	item_state = "tajblind_meson"
	inactive_icon_state = "tajblind"
	body_cover_flags = EYES

/obj/item/clothing/glasses/material/prescription/tajblind
	name = "mining veil"
	desc = "An Tajaran made veil that allows the user to see while obscuring their eyes. This one has an installed material scanner."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = 'icons/mob/clothing/eyes.dmi'
	icon_state = "tajblind_meson"
	item_state = "tajblind_meson"
	inactive_icon_state = "tajblind"
	body_cover_flags = EYES

/obj/item/clothing/glasses/welding/laconic
	name = "laconic goggles"
	desc = "Welding goggles fashioned out of brass. Brass goggles."
	icon_state = "laconic-g"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "welding-g", SLOT_ID_LEFT_HAND = "welding-g")
	item_action_name = "Adjust Goggles"
	materials_base = list("brass" = 1500, MAT_GLASS = 1000)
