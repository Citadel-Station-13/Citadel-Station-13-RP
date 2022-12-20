//Please see the comment above the main NIF definition before
//trying to call any of these procs directly.

//A single piece of NIF software
/datum/nifsoft
	abstract_type = /datum/nifsoft

	var/name = "Prototype"
	var/desc = "Contact a dev!"


	/// The NIF that the software is stored in
	var/obj/item/nif/nif
	/// List position in the nifsoft list
	var/list_pos
	/// Cost in cash of buying this software from a terminal
	var/cost = 1000
	/// This is available in NIFSoft Shops at the start of the game
	var/vended = TRUE
	/// The wear (+/- 10% when applied) that this causes to the NIF
	var/wear = 1
	/// What access they need to buy it, can only set one for ~reasons~
	var/access
	/// If this is a black-market nifsoft (emag option)
	var/illegal = FALSE

	/// Whether the active mode of this implant is on
	var/active = FALSE
	/// Passive power drain, can be used in various ways from the software
	var/p_drain = 0
	/// Active power drain, same purpose as above, software can treat however
	var/a_drain = 0
	/// Whether or not this has an active power consumption mode
	var/activates = TRUE
	/// Flags to tell when we'd like to be ticked
	var/tick_flags = 0

	/// If the implant can be destroyed via EMP attack
	var/empable = TRUE

	/// Trial software! Or self-deleting illegal ones!
	var/expiring = FALSE
	/// World.time for when they expire
	var/expires_at

	/// Who this software is useful for
	var/applies_to = (NIF_ORGANIC|NIF_SYNTHETIC)

	/// Various flags for fast lookups that are settable on the NIF
	var/vision_flags = 0
	/// These are added as soon as the implant is activated
	var/health_flags = 0
	/// Otherwise use set_flag/clear_flag in one of your own procs for tricks
	var/combat_flags = 0
	var/other_flags = 0

	var/vision_flags_mob = 0
	var/darkness_view = 0

	/// List of vision planes this nifsoft enables when active
	var/list/planes_enabled = null
	/// Whether or not this NIFSoft provides exclusive vision modifier
	var/vision_exclusive = FALSE
	/// List of NIFSofts that are disabled when this one is enabled
	var/list/incompatible_with = null

//Constructor accepts the NIF it's being loaded into
/datum/nifsoft/New(var/obj/item/nif/nif_load)
	ASSERT(nif_load)

	nif = nif_load
	if(!install(nif))
		qdel(src)

//Destructor cleans up the software and nif reference
/datum/nifsoft/Destroy()
	if(nif)
		uninstall()
		nif = null
	return ..()

///Called when the software is installed in the NIF
/datum/nifsoft/proc/install()
	return nif.install(src)

///Called when the software is removed from the NIF
/datum/nifsoft/proc/uninstall()
	if(active)
		deactivate()
	if(nif)
		. = nif.uninstall(src)
		nif = null
	if(!QDESTROYING(src))
		qdel(src)

///Called every life() tick on a mob on active implants
/datum/nifsoft/proc/on_life(var/mob/living/carbon/human/human)
	return TRUE

///Called when attempting to activate an implant (could be a 'pulse' activation or toggling it on)
/datum/nifsoft/proc/activate(var/force = FALSE)
	if(active && !force)
		return
	var/nif_result = nif.activate(src)

	//If the NIF was fine with it, or we're forcing it
	if(nif_result || force)
		active = TRUE

		//If we enable vision planes
		if(planes_enabled)
			nif.add_plane(planes_enabled)
			nif.vis_update()

		//If we have other NIFsoft we need to turn off
		if(incompatible_with)
			nif.deactivate_these(incompatible_with)

		//Set all our activation flags
		nif.set_flag(vision_flags,NIF_FLAGS_VISION)
		nif.set_flag(health_flags,NIF_FLAGS_HEALTH)
		nif.set_flag(combat_flags,NIF_FLAGS_COMBAT)
		nif.set_flag(other_flags,NIF_FLAGS_OTHER)

		if(vision_exclusive)
			var/mob/living/carbon/human/H = nif.human
			if(H && istype(H))
				H.recalculate_vis()

	return nif_result

///Called when attempting to deactivate an implant
/datum/nifsoft/proc/deactivate(var/force = FALSE)
	if(!active && !force)
		return
	var/nif_result = nif.deactivate(src)

	//If the NIF was fine with it or we're forcing it
	if(nif_result || force)
		active = FALSE

		//If we enable vision planes, disable them
		if(planes_enabled)
			nif.del_plane(planes_enabled)
			nif.vis_update()

		//Clear all our activation flags
		nif.clear_flag(vision_flags,NIF_FLAGS_VISION)
		nif.clear_flag(health_flags,NIF_FLAGS_HEALTH)
		nif.clear_flag(combat_flags,NIF_FLAGS_COMBAT)
		nif.clear_flag(other_flags,NIF_FLAGS_OTHER)

		if(vision_exclusive)
			var/mob/living/carbon/human/H = nif.human
			if(H && istype(H))
				H.recalculate_vis()

	return nif_result

///Called when an implant expires
/datum/nifsoft/proc/expire()
	uninstall()
	return

///Called when installed from a disk
/datum/nifsoft/proc/disk_install(var/mob/living/carbon/human/target,var/mob/living/carbon/human/user)
	return TRUE

///Status text for menu
/datum/nifsoft/proc/stat_text()
	if(activates)
		return "[active ? "Active" : "Disabled"]"

	return "Always On"

//////////////////////
///A package of NIF software
/datum/nifsoft/package
	var/list/software = list()
	wear = 0 //Packages don't cause wear themselves, the software does

//Constructor accepts a NIF and loads all the software
/datum/nifsoft/package/New(var/obj/item/nif/nif_load)
	ASSERT(nif_load)

	for(var/P in software)
		new P(nif_load)

	qdel(src)

//Clean self up
/datum/nifsoft/package/Destroy()
	software.Cut()
	software = null
	return ..()

/////////////////
// A NIFSoft Uploader
/obj/item/disk/nifsoft
	name = "NIFSoft Uploader"
	desc = "It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""
	icon = 'icons/obj/nanomods.dmi'
	icon_state = "medical"
	item_state = "nanomod"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand.dmi',
		)
	w_class = ITEMSIZE_SMALL
	var/datum/nifsoft/stored = null

/obj/item/disk/nifsoft/afterattack(var/A, mob/user, flag, params)
	if(!in_range(user, A))
		return

	if(!ishuman(user) || !ishuman(A))
		return

	var/mob/living/carbon/human/Ht = A
	var/mob/living/carbon/human/Hu = user

	if(!Ht.nif || Ht.nif.stat != NIF_WORKING)
		to_chat(user,"<span class='warning'>Either they don't have a NIF, or the uploader can't connect.</span>")
		return

	var/extra = extra_params()
	if(A == user)
		to_chat(user,"<span class='notice'>You upload [src] into your NIF.</span>")
	else
		Ht.visible_message("<span class='warning'>[Hu] begins uploading [src] into [Ht]!</span>","<span class='danger'>[Hu] is uploading [src] into you!</span>")

	icon_state = "[initial(icon_state)]-animate"	//makes it play the item animation upon using on a valid target
	update_icon()

	if(A == user && do_after(Hu,1 SECONDS,Ht))
		new stored(Ht.nif,extra)
		qdel(src)
	else if(A != user && do_after(Hu,10 SECONDS,Ht))
		new stored(Ht.nif,extra)
		qdel(src)
	else
		icon_state = "[initial(icon_state)]"	//If it fails to apply to a valid target and doesn't get deleted, reset its icon state
		update_icon()

///So disks can pass fancier stuff.
/obj/item/disk/nifsoft/proc/extra_params()
	return null


// Compliance Disk //
/obj/item/disk/nifsoft/compliance
	name = "NIFSoft Uploader (Compliance)"
	desc = "Wow, adding laws to people? That seems illegal. It probably is. Okay, it really is."
	icon_state = "compliance"
	item_state = "healthanalyzer"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand.dmi',
		)
	stored = /datum/nifsoft/compliance
	var/laws

/obj/item/disk/nifsoft/compliance/afterattack(var/A, mob/user, flag, params)
	if(!ishuman(A))
		return
	if(!laws)
		to_chat(user,"<span class='warning'>You haven't set any laws yet. Use the disk in-hand first.</span>")
		return
	..(A,user,flag,params)

/obj/item/disk/nifsoft/compliance/attack_self(mob/user)
	var/newlaws = input(user,"Please Input Laws","Compliance Laws",laws) as message
	newlaws = sanitize(newlaws,2048)
	if(newlaws)
		to_chat(user,"You set the laws to: <br><span class='notice'>[newlaws]</span>")
		laws = newlaws

/obj/item/disk/nifsoft/compliance/extra_params()
	return laws

// Security Disk //
/obj/item/disk/nifsoft/security
	name = "NIFSoft Uploader - Security"
	desc = "Contains free NIFSofts useful for security members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	icon_state = "security"
	stored = /datum/nifsoft/package/security

/datum/nifsoft/package/security
	software = list(/datum/nifsoft/hud/ar_sec,/datum/nifsoft/flashprot)

/obj/item/storage/box/nifsofts_security
	name = "security nifsoft uploaders"
	desc = "A box of free nifsofts for security employees."
	icon_state = "disk_kit"

/obj/item/storage/box/nifsofts_security/PopulateContents()
	for(var/i = 0 to 7)
		new /obj/item/disk/nifsoft/security(src)

// Engineering Disk //
/obj/item/disk/nifsoft/engineering
	name = "NIFSoft Uploader - Engineering"
	desc = "Contains free NIFSofts useful for engineering members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	icon_state = "engineering"
	stored = /datum/nifsoft/package/engineering

/datum/nifsoft/package/engineering
	software = list(/datum/nifsoft/hud/ar_eng,/datum/nifsoft/alarmmonitor,/datum/nifsoft/uvblocker)

/obj/item/storage/box/nifsofts_engineering
	name = "engineering nifsoft uploaders"
	desc = "A box of free nifsofts for engineering employees."
	icon_state = "disk_kit"

/obj/item/storage/box/nifsofts_engineering/PopulateContents()
	for(var/i = 0 to 7)
		new /obj/item/disk/nifsoft/engineering(src)

// Medical Disk //
/obj/item/disk/nifsoft/medical
	name = "NIFSoft Uploader - Medical"
	desc = "Contains free NIFSofts useful for medical members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	stored = /datum/nifsoft/package/medical

/datum/nifsoft/package/medical
	software = list(/datum/nifsoft/hud/ar_med,/datum/nifsoft/crewmonitor)

/obj/item/storage/box/nifsofts_medical
	name = "medical nifsoft uploaders"
	desc = "A box of free nifsofts for medical employees."
	icon_state = "disk_kit"

/obj/item/storage/box/nifsofts_medical/PopulateContents()
	for(var/i = 0 to 7)
		new /obj/item/disk/nifsoft/medical(src)

// Mining Disk //
/obj/item/disk/nifsoft/mining
	name = "NIFSoft Uploader - Mining"
	desc = "Contains free NIFSofts useful for mining members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""

	icon_state = "mining"
	stored = /datum/nifsoft/package/mining

/datum/nifsoft/package/mining
	software = list(/datum/nifsoft/material,/datum/nifsoft/spare_breath)

/obj/item/storage/box/nifsofts_mining
	name = "mining nifsoft uploaders"
	desc = "A box of free nifsofts for mining employees."
	icon_state = "disk_kit"

/obj/item/storage/box/nifsofts_mining/PopulateContents()
	for(var/i = 0 to 7)
		new /obj/item/disk/nifsoft/mining(src)
