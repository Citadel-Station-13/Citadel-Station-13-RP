/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	atom_flags = NONE//doesn't protect eyes because it's a monocle, duh
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2)

/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "headset", SLOT_ID_LEFT_HAND = "headset")
	body_parts_covered = 0

/obj/item/clothing/glasses/hud/health/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/hud_granter, list(DATA_HUD_MEDICAL), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/hud/health/prescription
	name = "Prescription Health Scanner HUD"
	desc = "A medical HUD integrated with a set of prescription glasses"
	prescription = 1
	icon_state = "healthhudpresc"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "headset", SLOT_ID_LEFT_HAND = "headset")
	body_parts_covered = 0

/obj/item/clothing/glasses/hud/security/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/hud_granter, list(DATA_HUD_SECURITY_ADVANCED), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/hud/security/prescription
	name = "Prescription Security HUD"
	desc = "A security HUD integrated with a set of prescription glasses"
	prescription = 1
	icon_state = "sechudpresc"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "glasses", SLOT_ID_LEFT_HAND = "glasses")

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "Augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "sunglasses", SLOT_ID_LEFT_HAND = "sunglasses")
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

//Port of _vr files.
/obj/item/clothing/glasses/omnihud
	name = "\improper AR glasses"
	desc = "The VM-62 AR Glasses are a design from Vey Med. These are a cheap export version \
	for Nanotrasen. Probably not as complete as Vey Med could make them, but more readily available for NT."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3)
	var/obj/item/clothing/glasses/hud/omni/hud = null
	var/mode = "civ"
	icon_state = "glasses"
	var/datum/nano_module/arscreen
	var/arscreen_path
	var/datum/tgui_module/tgarscreen
	var/tgarscreen_path
	var/flash_prot = 0 //0 for none, 1 for flash weapon protection, 2 for welder protection
	enables_planes = list(VIS_AUGMENTED)
	plane_slots = list(SLOT_ID_GLASSES)

/obj/item/clothing/glasses/omnihud/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/hud_granter, list(DATA_HUD_ID_JOB), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/omnihud/Initialize(mapload)
	. = ..()
	if(arscreen_path)
		arscreen = new arscreen_path(src)
	if(tgarscreen_path)
		tgarscreen = new tgarscreen_path(src)

/obj/item/clothing/glasses/omnihud/Destroy()
	QDEL_NULL(arscreen)
	QDEL_NULL(tgarscreen)
	. = ..()

/obj/item/clothing/glasses/omnihud/dropped(mob/user, flags, atom/newLoc)
	if(arscreen)
		SSnanoui.close_uis(src)
	if(tgarscreen)
		SStgui.close_uis(src)
	..()

/obj/item/clothing/glasses/omnihud/emp_act(var/severity)
	var/disconnect_ar = arscreen
	arscreen = null
	var/disconnect_tgar = tgarscreen
	tgarscreen = null
	spawn(20 SECONDS)
		arscreen = disconnect_ar
		tgarscreen = disconnect_tgar
	..()

/obj/item/clothing/glasses/omnihud/proc/flashed()
	if(flash_prot && ishuman(loc))
		to_chat(loc, "<span class='warning'>Your [src.name] darken to try and protect your eyes!</span>")

/obj/item/clothing/glasses/omnihud/prescribe(var/mob/user)
	prescription = !prescription
	playsound(user,'sound/items/screwdriver.ogg', 50, 1)
	if(prescription)
		name = "[initial(name)] (pr)"
		user.visible_message("[user] uploads new prescription data to the [src.name].")
	else
		name = "[initial(name)]"
		user.visible_message("[user] deletes the prescription data on the [src.name].")

/obj/item/clothing/glasses/omnihud/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(!H.glasses || !(H.glasses == src))
		to_chat(user, "<span class='warning'>You must be wearing the [src] to see the display.</span>")
	else
		if(!ar_interact(H))
			to_chat(user, "<span class='warning'>The [src] does not have any kind of special display.</span>")

/obj/item/clothing/glasses/omnihud/proc/ar_interact(var/mob/living/carbon/human/user)
	return 0 //The base models do nothing.

/obj/item/clothing/glasses/omnihud/prescription
	name = "AR glasses (pr)"
	prescription = 1

/obj/item/clothing/glasses/omnihud/med
	name = "\improper AR-M glasses"
	desc = "The VM-62-M AR glasses are a design from Vey Med. \
	These have been upgraded with medical records access and virus database integration."
	mode = "med"
	action_button_name = "AR Console (Crew Monitor)"
	prescription = 1
	tgarscreen_path = /datum/tgui_module/crew_monitor/glasses
	enables_planes = list(VIS_AUGMENTED)

/obj/item/clothing/glasses/omnihud/med/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/hud_granter, list(DATA_HUD_ID_JOB, DATA_HUD_MEDICAL), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/omnihud/med/ar_interact(var/mob/living/carbon/human/user)
	if(tgarscreen)
		tgarscreen.ui_interact(user)
	return 1

/obj/item/clothing/glasses/omnihud/sec
	name = "\improper AR-S glasses"
	desc = "The VM-62-S AR glasses are a design from Vey Med. \
	These have been upgraded with security records integration and flash protection."
	mode = "sec"
	flash_protection = FLASH_PROTECTION_MAJOR
	prescription = 1
	action_button_name = "AR Console (Security Alerts)"
	enables_planes = list(VIS_AUGMENTED)


/obj/item/clothing/glasses/omnihud/sec/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/hud_granter, list(DATA_HUD_SECURITY_ADVANCED), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/omnihud/sec/ar_interact(var/mob/living/carbon/human/user)
	if(arscreen)
		arscreen.nano_ui_interact(user,"main",null,1,glasses_state)
	return 1

/obj/item/clothing/glasses/omnihud/eng
	name = "\improper AR-E glasses"
	desc = "The VM-62-E AR glasses are a design from Vey Med. \
	These have been upgraded with advanced electrochromic lenses to protect your eyes during welding."
	mode = "eng"
	prescription = 1
	flash_protection = FLASH_PROTECTION_MAJOR
	action_button_name = "AR Console (Station Alerts)"
	arscreen_path = /datum/nano_module/alarm_monitor/engineering

/obj/item/clothing/glasses/omnihud/eng/ar_interact(var/mob/living/carbon/human/user)
	if(arscreen)
		arscreen.nano_ui_interact(user,"main",null,1,glasses_state)
	return 1

/obj/item/clothing/glasses/omnihud/rnd
	name = "\improper AR-R glasses"
	desc = "The VM-62-R AR glasses are a design from Vey Med. \
	These have been ... modified ... to fit into a different frame."
	mode = "sci"
	prescription = 1
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = null
	icon_state = "purple"
	clothing_flags = SCAN_REAGENTS

/obj/item/clothing/glasses/omnihud/eng/meson
	name = "meson scanner HUD"
	desc = "A headset equipped with a scanning lens and mounted retinal projector. They don't provide any eye protection, but they're less obtrusive than goggles."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/vore/custom_clothes_vr.dmi'
	icon_state = "projector"
	off_state = "projector-off"
	body_parts_covered = 0
	toggleable = 1
	prescription = 1
	vision_flags = SEE_TURFS //but they can spot breaches. Due to the way HUDs work, they don't provide darkvision up-close the way mesons do.


/obj/item/clothing/glasses/omnihud/eng/meson/attack_self(mob/user)
	if(!active)
		toggleprojector()
	..()

/obj/item/clothing/glasses/omnihud/eng/meson/verb/toggleprojector()
	set name = "Toggle projector"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(toggleable)
		if(active)
			active = 0
			icon_state = off_state
			item_state = "[initial(item_state)]-off"
			usr.update_inv_glasses()
			to_chat(usr, "You deactivate the retinal projector on the [src].")
		else
			active = 1
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			usr.update_inv_glasses()
			to_chat(usr, "You activate the retinal projector on the [src].")
		usr.update_action_buttons()

/obj/item/clothing/glasses/omnihud/exp
	name = "\improper AR-V goggles"
	desc = "The VM-62-V AR goggles are a design from Vey Med. \
	These have been upgraded with an integrated zoom function and rudimentary health scanner."
	mode = "exp"
	icon_state = "pf_goggles"
	prescription = 1
	action_button_name = "Toggle Zoom"
	enables_planes = list(VIS_AUGMENTED)

/obj/item/clothing/glasses/omnihud/exp/ui_action_click()
	zoom(wornslot = SLOT_ID_GLASSES)

/obj/item/clothing/glasses/omnihud/all
	name = "\improper AR-B glasses"
	desc = "The CC-62-B AR glasses are a design from Nanotrasen Central Command. \
	These have been upgraded with every feature the lesser models have. Now we're talkin'."
	mode = "best"
	prescription = 1
	flash_protection = FLASH_PROTECTION_MAJOR
	enables_planes = list(VIS_AUGMENTED)

/obj/item/clothing/glasses/omnihud/all/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/clothing/hud_granter, list(DATA_HUD_SECURITY_ADVANCED, DATA_HUD_MEDICAL), list(SLOT_ID_GLASSES))

/obj/item/clothing/glasses/hud/security/eyepatch
    name = "Security Hudpatch"
    desc = "An eyepatch with built in scanners, that analyzes those in view and provides accurate data about their ID status and security records."
    icon_state = "hudpatch"
    item_state_slots = list(SLOT_ID_RIGHT_HAND = "blindfold", SLOT_ID_LEFT_HAND = "blindfold")
    body_parts_covered = 0
    enables_planes = list(VIS_AUGMENTED)
    var/eye = null

/obj/item/clothing/glasses/hud/security/eyepatch/verb/switcheye()
	set name = "Switch Eyepatch"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	eye = !eye
	if(eye)
		icon_state = "[icon_state]_1"
	else
		icon_state = initial(icon_state)
	update_worn_icon()

/obj/item/clothing/glasses/hud/engi/eyepatch
	name = "meson eyeHUD"
	desc = "A eyepatch equipped with a scanning lens and mounted retinal projector. For when you take style over smarts."
	icon_state = "mesonpatch"
	off_state = "eyepatch"
	body_parts_covered = 0
	toggleable = 1
	vision_flags = SEE_TURFS //but they can spot breaches. Due to the way HUDs work, they don't provide darkvision up-close the way mesons do.

/obj/item/clothing/glasses/omnihud/eng/meson/attack_self(mob/user)
	if(!active)
		toggleprojector()
	..()

/obj/item/clothing/glasses/hud/engi/eyepatch/verb/toggleprojector()
	set name = "Toggle projector"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return
	if(toggleable)
		if(active)
			active = 0
			icon_state = off_state
			item_state = "[initial(item_state)]-off"
			usr.update_inv_glasses()
			to_chat(usr, "You deactivate the retinal projector on the [src].")
		else
			active = 1
			icon_state = initial(icon_state)
			item_state = initial(item_state)
			usr.update_inv_glasses()
			to_chat(usr, "You activate the retinal projector on the [src].")
		usr.update_action_buttons()

/obj/item/clothing/glasses/hud/health/eyepatch
	name = "Health Scanner Patch"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status. This one's an eyepatch."
	icon_state = "medpatch"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "headset", SLOT_ID_LEFT_HAND = "headset")
	body_parts_covered = 0
	enables_planes = list(VIS_AUGMENTED)
