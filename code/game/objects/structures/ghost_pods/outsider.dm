/obj/structure/ghost_pod/ghost_activated/ashlander
	name = "ashlander yurt"
	desc = "A coarse leather tent. Squat and vaguely onion shaped, the thick red hide acting as a door covering flaps in the warm breeze. It seems like it could easily be dismantled and moved. A strange red icon shaped out of sinew and leather hangs over the doorway."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "yurt"
	icon_state_opened = "yurt"
	anchored = TRUE
	density = TRUE
	ghost_query_type = /datum/ghost_query/stowaway
	var/occupant_type = "ashlander"
	var/allow_appearance_change = TRUE
	var/make_antag = MODE_ASHLANDER
	var/spawn_with_weapon = TRUE

	var/list/clothing_possibilities

/obj/structure/ghost_pod/ghost_activated/ashlander/Initialize(mapload)
	. = ..()

	handle_clothing_setup()

/obj/structure/ghost_pod/ghost_activated/ashlander/proc/handle_clothing_setup()
	clothing_possibilities = list()

	clothing_possibilities |= subtypesof(/obj/item/clothing/under/color)
	clothing_possibilities |= subtypesof(/obj/item/clothing/head/soft)
	clothing_possibilities |= /obj/item/clothing/shoes/black
	clothing_possibilities |= /obj/item/radio/headset

/obj/structure/ghost_pod/ghost_activated/ashlander/create_occupant(var/mob/M)
	..()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/H = new(src)

	if(M.mind)
		M.mind.transfer_to(H)
	to_chat(M, "<span class='notice'>You are an [occupant_type]! \
	Select 'Scorian' from the race lists. Ashlanders are all permadeath characters. \
	They have gray skin of varying hues, red eyes, and - typically - white, black, or brown hair.</span>")
	if(make_antag)
		to_chat(M, "<span class='warning'>You are an Ashlander - a <b>neutral</b> party. Your tribe still worships the Buried Ones. \
	The wastes are sacred ground, its monsters a blessed bounty. You would never willingly leave your homeland behind. \
	You have seen lights in the distance - falling from the heavens, and returning. They foreshadow the arrival of outsiders to your domain. \
	Ensure your tribe remains protected at all costs.</span>")
	H.ckey = M.ckey
	visible_message("<span class='warning'>The flap of the yurt opens as the occupant steps out.</span>")
	log_and_message_admins("successfully opened \a [src] and became an [occupant_type].")

	var/list/uniform_options
	var/list/shoe_options
	var/list/head_options

	if(clothing_possibilities && clothing_possibilities.len)
		for(var/path in clothing_possibilities)
			if(ispath(path, /obj/item/clothing/under))
				if(!uniform_options)
					uniform_options = list()
				uniform_options |= path
			if(ispath(path, /obj/item/clothing/shoes))
				if(!shoe_options)
					shoe_options = list()
				shoe_options |= path
			if(ispath(path, /obj/item/clothing/head))
				if(!head_options)
					head_options = list()
				head_options |= path

	if(uniform_options && uniform_options.len)
		var/newpath = pick(uniform_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(shoe_options && shoe_options.len)
		var/newpath = pick(shoe_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(head_options && head_options.len)
		var/newpath = pick(head_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	var/newname = sanitize(input(H, "Your mind feels foggy, and you recall your name might be [H.real_name]. Would you like to change your name?") as null|text, MAX_NAME_LEN)
	if (newname)
		H.real_name = newname

	icon_state = icon_state_opened

	H.forceMove(T)

	if(make_antag)
		var/datum/antagonist/antag = GLOB.all_antag_types[make_antag]
		if(antag)
			if(antag.add_antagonist(H.mind, 1, 1, 0, 1, 1))
				log_admin("\The [src] made [key_name(src)] into a [antag.role_text].")

	if(allow_appearance_change)
		H.change_appearance(APPEARANCE_ALL, H.loc, check_species_whitelist = 1)

	visible_message("<span class='aliem'>\The [src] [pick("creaks", "rustles", "shudders")] as \the [H] steps out.</span>")
