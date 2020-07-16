// Used for translating channels to tokens on examination
GLOBAL_LIST_INIT(channel_tokens, list(
	RADIO_CHANNEL_COMMON = RADIO_KEY_COMMON,
	RADIO_CHANNEL_SCIENCE = RADIO_TOKEN_SCIENCE,
	RADIO_CHANNEL_COMMAND = RADIO_TOKEN_COMMAND,
	RADIO_CHANNEL_MEDICAL = RADIO_TOKEN_MEDICAL,
	RADIO_CHANNEL_ENGINEERING = RADIO_TOKEN_ENGINEERING,
	RADIO_CHANNEL_SECURITY = RADIO_TOKEN_SECURITY,
	RADIO_CHANNEL_SUPPLY = RADIO_TOKEN_SUPPLY,
	RADIO_CHANNEL_SERVICE = RADIO_TOKEN_SERVICE,
	RADIO_CHANNEL_ENT = "NONE",
	RADIO_CHANNEL_EXPLORER = RADIO_TOKEN_EXPLORER,
	RADIO_CHANNEL_CENTCOM = RADIO_TOKEN_CENTCOM,
	RADIO_CHANNEL_ERT = "NONE", //recommend using "RADIO_TOKEN_CENTCOM"
	RADIO_CHANNEL_SYNDICATE = RADIO_TOKEN_SYNDICATE,
	RADIO_CHANNEL_SYNDIE = RADIO_TOKEN_SYNDICATE,
	RADIO_CHANNEL_RAID = RADIO_TOKEN_RAID,
	MODE_BINARY = MODE_TOKEN_BINARY,
	RADIO_CHANNEL_AI_PRIVATE = RADIO_TOKEN_AI_PRIVATE
))
/obj/item/radio/headset
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys"
	icon_state = "headset"
	item_state = null //To remove the radio's state
	matter = list(DEFAULT_WALL_MATERIAL = 75)
	subspace_transmission = TRUE
	canhear_range = 0 // can't hear headsets from very far away

	slot_flags = SLOT_EARS
	var/obj/item/encryptionkey/keyslot2 = null
	var/bowman = FALSE //not yet used!

	var/translate_hive = FALSE
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/seromi/ears.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/ears.dmi'
	)

	// Depricated vars
	var/obj/keyslot1 = null
	var/ks1type = null
	var/ks2type = null
	var/radio_desc = null

/obj/item/radio/headset/examine(mob/user)
	. = ..()
	if(in_range(user, src) && loc == user)
		// construction of frequency description
		var/list/avail_chans = list("Use [RADIO_KEY_COMMON] for the currently tuned frequency")
		if(translate_binary)
			avail_chans += "use [MODE_TOKEN_BINARY] for [MODE_BINARY]"
		if(length(channels))
			for(var/i in 1 to length(channels))
				if(i == 1)
					avail_chans += "use [MODE_TOKEN_DEPARTMENT] or [GLOB.channel_tokens[channels[i]]] ([uppertext(GLOB.channel_tokens[channels[i]])] if on your right ear) for [lowertext(channels[i])]"
				else
					avail_chans += "use [GLOB.channel_tokens[channels[i]]] ([uppertext(GLOB.channel_tokens[channels[i]])] if on your right ear) for [lowertext(channels[i])]"
		. += "<span class='notice'>A small screen on the headset displays the following available frequencies:\n[english_list(avail_chans)]."

		if(command)
			. += "<span class='info'>Alt-click to toggle the high-volume mode.</span>"
	else
		. += "<span class='notice'>A small screen on the headset flashes, it's too small to read without holding or wearing the headset.</span>"

/obj/item/radio/headset/ComponentInitialize()
	. = ..()
	// if (bowman)
	// 	AddComponent(/datum/component/wearertargeting/earprotection, list(SLOT_EARS))

/obj/item/radio/headset/Initialize(mapload)
	if(ks1type != null && mapload) //annoy mapperbus
		log_mapping("WARNING: [src] has a ks1type var which is depricated. Location: [COORD(src)], ks1type value: [ks1type]")
	if(ks2type != null && mapload)
		log_mapping("WARNING: [src] has a ks2type var which is depricated. Location: [COORD(src)], ks2type value: [ks2type]")
	if(keyslot1 != null && mapload)
		log_mapping("WARNING: [src] has a keyslot1 var which is depricated, please use keyslot instead. Location: [COORD(src)], keyslot1 value: [keyslot1]")
	if(radio_desc != null && mapload)
		log_mapping("WARNING: [src] has a radio_desc var which is depricated. Location: [COORD(src)], keyslot1 value: [radio_desc]")
	. = ..()
	recalculateChannels()

/obj/item/radio/headset/Destroy()
	QDEL_NULL(keyslot2) //ks1 gets qdeleted by the parent (radio.dm)
	return ..()

/obj/item/radio/headset/list_channels(mob/user)
	return list_secure_channels()

/obj/item/radio/headset/handle_message_mode(mob/living/M, message, channel)
	if (channel == "special")
		if (translate_binary)
			var/datum/language/binary = GLOB.all_languages["Robot Talk"]
			binary.broadcast(M, message)
		if (translate_hive)
			var/datum/language/hivemind = GLOB.all_languages["Hivemind"]
			hivemind.broadcast(M, message)
		return null

	return ..()

/obj/item/radio/headset/can_receive(freq, level, AIuser)
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc
		if(H.l_ear == src || H.r_ear == src)
			return ..(freq, level)
	else if(AIuser)
		return ..(freq, level)
	return FALSE

/obj/item/radio/headset/get_worn_icon_state(slot_name)
	var/append = ""
	if(icon_override)
		switch(slot_name)
			if(slot_l_ear_str)
				append = "_l"
			if(slot_r_ear_str)
				append = "_r"

	return "[..()][append]"

/obj/item/radio/headset/syndicate
	origin_tech = list(TECH_ILLEGAL = 3)

/obj/item/radio/headset/syndicate/alt //undisguised bowman with flash protection
	name = "syndicate headset"
	desc = "A syndicate headset that can be used to hear all radio frequencies." // Protects ears from flashbangs."
	icon_state = "syndie_headset"
	item_state = "headset"

/obj/item/radio/headset/syndicate/alt/leader
	name = "team leader headset"
	command = TRUE

/obj/item/radio/headset/syndicate/Initialize()
	. = ..()
	make_syndie()
/obj/item/radio/headset/raider
	origin_tech = list(TECH_ILLEGAL = 2)
	keyslot = new /obj/item/encryptionkey/raider
	syndie = TRUE

/obj/item/radio/headset/raider/Initialize()
	. = ..()
	set_frequency(RAID_FREQ)
	recalculateChannels()

/obj/item/radio/headset/binary //huh, just noticed poping out the key can yield you a illegal tech 3, which can make this 4
	origin_tech = list(TECH_ILLEGAL = 3)
	keyslot = new /obj/item/encryptionkey/binary

/obj/item/radio/headset/headset_sec
	name = "security radio headset"
	desc = "This is used by your elite security force."
	icon_state = "sec_headset"
	keyslot = new /obj/item/encryptionkey/headset_sec

/obj/item/radio/headset/headset_sec/alt
	name = "security bowman headset"
	desc = "This is used by your elite security force." //" Protects ears from flashbangs."
	icon_state = "sec_headset_alt"
	// item_state = "sec_headset_alt"
	bowman = TRUE

/obj/item/radio/headset/headset_eng
	name = "engineering radio headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset"
	keyslot = new /obj/item/encryptionkey/headset_eng

/obj/item/radio/headset/headset_eng/alt
	name = "engineering bowman headset"
	desc = "When the engineers wish to chat like girls."
	icon_state = "eng_headset_alt"
	keyslot = new /obj/item/encryptionkey/headset_eng
	bowman = TRUE

/obj/item/radio/headset/headset_rob
	name = "robotics radio headset"
	desc = "Made specifically for the roboticists who cannot decide between departments."
	icon_state = "rob_headset"
	keyslot = new /obj/item/encryptionkey/headset_rob

/obj/item/radio/headset/headset_med
	name = "medical radio headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset"
	keyslot = new /obj/item/encryptionkey/headset_med

/obj/item/radio/headset/headset_med/alt
	name = "medical bowman headset"
	desc = "A headset for the trained staff of the medbay."
	icon_state = "med_headset_alt"
	keyslot = new /obj/item/encryptionkey/headset_med
	bowman = TRUE

/obj/item/radio/headset/headset_sci
	name = "science radio headset"
	desc = "A sciency headset. Like usual."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/headset_sci

/obj/item/radio/headset/headset_medsci
	name = "medical research radio headset"
	desc = "A headset that is a result of the mating between medical and science."
	icon_state = "med_headset"
	keyslot = new /obj/item/encryptionkey/headset_medsci

/obj/item/radio/headset/headset_com
	name = "command radio headset"
	desc = "A headset with a commanding channel.\nTo access the command channel, use :c."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/headset_com

/obj/item/radio/headset/headset_adj //Citadel Add: Secretary headset with service and command.
	name = "secretary radio headset"
	desc = "A headset for those who serve command."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/headset_adj

/obj/item/radio/headset/headset_com/alt
	name = "command bowman headset"
	desc = "A headset with a commanding channel.\nTo access the command channel, use :c."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/headset_com
	bowman = TRUE

/obj/item/radio/headset/heads
	command = TRUE

/obj/item/radio/headset/heads/captain
	name = "Facility Director's headset"
	desc = "The headset of the boss."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/captain/alt
	name = "Facility Director's bowman headset"
	desc = "The headset of the boss."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/captain
	bowman = TRUE

/obj/item/radio/headset/heads/captain/sfr
	name = "SFR headset"
	desc = "A headset belonging to a Sif Free Radio DJ. SFR, best tunes in the wilderness."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/captain

/obj/item/radio/headset/heads/ai_integrated //No need to care about icons, it should be hidden inside the AI anyway.
	name = "\improper AI subspace transceiver"
	desc = "Integrated AI radio transceiver."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	keyslot = new /obj/item/encryptionkey/heads/ai_integrated
	command = TRUE
	var/myAi = null    // Atlantis: Reference back to the AI which has this radio.
	var/disabledAi = FALSE // Atlantis: Used to manually disable AI's integrated radio via intellicard menu.

/obj/item/radio/headset/heads/ai_integrated/can_receive(freq, level)
	if (disabledAi)
		return FALSE //Transciever Disabled.
	return ..(freq, level, TRUE)

/obj/item/radio/headset/heads/rd
	name = "\proper the research director's headset"
	desc = "Headset of the fellow who keeps society marching towards technological singularity." //nerfs RD
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/rd

/obj/item/radio/headset/heads/rd/alt
	name = "research director's bowman headset"
	desc = "Headset of the researching God."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/rd
	bowman = TRUE

/obj/item/radio/headset/heads/hos
	name = "\proper the head of security's headset"
	desc = "The headset of the man in charge of keeping order and protecting the station."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/heads/hos/alt
	name = "\proper the head of security's bowman headset"
	desc = "The headset of the man in charge of keeping order and protecting the station." // Protects ears from flashbangs."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/hos
	bowman = TRUE

/obj/item/radio/headset/heads/ce
	name = "\proper the chief engineer's headset"
	desc = "The headset of the guy in charge of keeping the station powered and undamaged."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/ce

/obj/item/radio/headset/heads/ce/alt
	name = "\proper the chief engineer's bowman headset"
	desc = "The headset of the guy in charge of keeping the station powered and undamaged." //why can i taste salt on these desc?
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/ce
	bowman = TRUE

/obj/item/radio/headset/heads/cmo
	name = "\proper the chief medical officer's headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/cmo

/obj/item/radio/headset/heads/cmo/alt
	name = "\proper the chief medical officer's bowman headset"
	desc = "The headset of the highly trained medical chief."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/cmo
	bowman = TRUE

/obj/item/radio/headset/heads/hop
	name = "\proper the head of personnel's headset"
	desc = "The headset of the guy who will one day be Facility Director."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hop

/obj/item/radio/headset/heads/hop/alt
	name = "\proper the head of personnel's bowman headset"
	desc = "The headset of the guy who will one day be Facility Director."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/heads/hop
	bowman = TRUE

/obj/item/radio/headset/headset_mine
	name = "mining radio headset"
	desc = "Headset used by miners. Has inbuilt short-band radio for when comms are down."
	icon_state = "mine_headset"
	keyslot = new /obj/item/encryptionkey/headset_cargo //headset_mining
	adhoc_fallback = TRUE

/obj/item/radio/headset/headset_cargo
	name = "supply radio headset"
	desc = "A headset used by the QM and his slaves."
	icon_state = "cargo_headset"
	keyslot = new /obj/item/encryptionkey/headset_cargo

/obj/item/radio/headset/headset_cargo/alt
	name = "supply bowman headset"
	desc = "A bowman headset used by the QM and his slaves."
	icon_state = "cargo_headset_alt"
	keyslot = new /obj/item/encryptionkey/headset_cargo
	bowman = TRUE

/obj/item/radio/headset/headset_service
	name = "service radio headset"
	desc = "Headset used by the service staff, tasked with keeping the station full, happy and clean."
	icon_state = "srv_headset"
	keyslot = new /obj/item/encryptionkey/headset_service

/obj/item/radio/headset/headset_clown
	name = "clown's headset"
	desc = "A headset for the clown. Finally. A megaphone you can't take away."
	icon_state = "srv_headset"
	keyslot = new /obj/item/encryptionkey/headset_service
	command = TRUE
	commandspan = SPAN_CLOWN

/obj/item/radio/headset/ert
	name = "emergency response team radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/ert
	independent = TRUE
	freerange = TRUE

/obj/item/radio/headset/ert/alt
	name = "emergency response team bowman headset"
	desc = "The headset of the boss's boss."
	icon_state = "com_headset_alt"
	keyslot = new /obj/item/encryptionkey/ert
	freerange = TRUE
	bowman = TRUE

/obj/item/radio/headset/omni		//Only for the admin intercoms
	keyslot = new /obj/item/encryptionkey/omni
	freerange = TRUE
	independent = TRUE

/obj/item/radio/headset/ia
	name = "internal affair's headset"
	desc = "The headset of your worst enemy."
	icon_state = "com_headset"
	keyslot = new /obj/item/encryptionkey/heads/hos

/obj/item/radio/headset/mmi_radio
	name = "brain-integrated radio"
	desc = "MMIs and synthetic brains are often equipped with these."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "radio"
	item_state = "headset"
	var/mmiowner = null
	var/radio_enabled = TRUE

/obj/item/radio/headset/mmi_radio/can_receive(freq, level)
	if (!radio_enabled || istype(src.loc.loc, /mob/living/silicon) || istype(src.loc.loc, /obj/item/organ/internal))
		return FALSE //Transciever Disabled.
	return ..(freq, level, TRUE)

/obj/item/radio/headset/attackby(obj/item/W, mob/user, params)
	user.set_machine(src)
	// if (istype(W,/obj/item/headsetupgrader))
	// 	if (!bowman)
	// 		to_chat(user,"<span class='notice'>You upgrade [src].</span>")
	// 		bowmanize()
	// 		qdel(W)
	if(W.is_screwdriver())
		if(keyslot || keyslot2)
			for(var/ch_name in channels)
				// SSradio.remove_object(src, GLOB.radiochannels[ch_name])
				radio_controller.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null

			var/turf/T = user.drop_location()
			if(T)
				if(keyslot)
					keyslot.forceMove(T)
					keyslot = null
				if(keyslot2)
					keyslot2.forceMove(T)
					keyslot2 = null

			recalculateChannels()
			to_chat(user, "<span class='notice'>You pop out the encryption keys in the headset.</span>")
			playsound(src, W.usesound, 50, TRUE)

		else
			to_chat(user, "<span class='warning'>This headset doesn't have any unique encryption keys!  How useless...</span>")

	else if(istype(W, /obj/item/encryptionkey))
		if(keyslot && keyslot2)
			to_chat(user, "<span class='warning'>The headset can't hold another key!</span>")
			return

		if(!keyslot)
			// if(!user.transferItemToLoc(W, src))
			// 	return
			user.drop_item()
			W.loc = src
			keyslot = W

		else
			// if(!user.transferItemToLoc(W, src))
			// 	return
			user.drop_item()
			W.loc = src
			keyslot2 = W


		recalculateChannels()
	else
		return ..()

/obj/item/radio/headset/recalculateChannels()
	..()
	if(keyslot2)
		for(var/ch_name in keyslot2.channels)
			if(!(ch_name in src.channels))
				channels[ch_name] = keyslot2.channels[ch_name]

		if(keyslot2.translate_binary)
			translate_binary = TRUE
		if(keyslot2.syndie)
			syndie = TRUE
		// if(keyslot2.independent)
		// 	independent = TRUE
		if(keyslot2.translate_hive)
			translate_hive = TRUE

	for(var/ch_name in channels)
		secure_radio_connections[ch_name] = radio_controller.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

/obj/item/radio/headset/AltClick(mob/living/user)
	. = ..()
	if(!istype(user) || !Adjacent(user) || user.incapacitated())
		return
	if (command)
		use_command = !use_command
		to_chat(user, "<span class='notice'>You toggle high-volume mode [use_command ? "on" : "off"].</span>")
		return TRUE
