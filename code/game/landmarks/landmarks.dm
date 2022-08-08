GLOBAL_LIST_EMPTY(landmarks_list)
GLOBAL_LIST_EMPTY(landmarks_keyed)

/proc/landmarks_by_key(key)
	var/list/L = GLOB.landmarks_keyed[key]
	if(L)
		return L.Copy()
	return list()

/proc/pick_landmark_by_key(key)
	var/list/L = landmarks_by_key(key)
	return SAFEPICK(L)

/obj/landmark
	name = "landmark"
	icon = 'icons/mapping/landmarks/landmarks.dmi'
	icon_state = ""	// greyscale x
	color = COLOR_RED
	anchored = TRUE
	layer = MID_LANDMARK_LAYER
	invisibility = INVISIBILITY_MAXIMUM

	/// important landmarks get registered by id. not vv hooked, admins usually shouldn't mess with this.
	var/landmark_key
	/// delete on roundstart
	var/delete_on_roundstart = FALSE

INITIALIZE_IMMEDIATE(/obj/landmark)

/obj/landmark/Initialize(mapload)
	. = ..()
	GLOB.landmarks_list += src
	if(landmark_key)
		if(!GLOB.landmarks_keyed[landmark_key])
			GLOB.landmarks_keyed[landmark_key] = list(src)
		else
			GLOB.landmarks_keyed[landmark_key] += src

/obj/landmark/Destroy()
	GLOB.landmarks_list -= src
	if(landmark_key && GLOB.landmarks_keyed[landmark_key])
		GLOB.landmarks_keyed[landmark_key] -= src
		if(!length(GLOB.landmarks_keyed[landmark_key]))
			GLOB.landmarks_keyed -= landmark_key
	return ..()

/**
 * Called when the round is finished setting up directly from SSticker
 */
/obj/landmark/proc/OnRoundstart()
	if(delete_on_roundstart)
		qdel(src)

// everything below here are subtypes
// no no no, ftfy: everything below here needs to be nuked from orbit ~silicons
/obj/landmark/Initialize(mapload)
	. = ..()
	tag = text("landmark*[]", name)
	invisibility = 101

	switch(name)			//some of these are probably obsolete
		if("monkey")
			monkeystart += loc
			delete_on_roundstart = 1
			return
		if("start")
			newplayer_start += loc
			delete_on_roundstart = 1
			return
		if("prisonwarp")
			prisonwarp += loc
			delete_on_roundstart = 1
			return
		if("Holding Facility")
			holdingfacility += loc
		if("tdome1")
			tdome1 += loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin += loc
		if("tdomeobserve")
			tdomeobserve += loc
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			delete_on_roundstart = 1
			return
		if("blobstart")
			blobstart += loc
			delete_on_roundstart = 1
			return
		if("xeno_spawn")
			xeno_spawn += loc
			delete_on_roundstart = 1
			return
		if("endgame_exit")
			endgame_safespawns += loc
			delete_on_roundstart = 1
			return
		if("bluespacerift")
			endgame_exits += loc
			delete_on_roundstart = 1
			return
		if("lavaland_entry")
			lavaland_entry += loc
			delete_on_roundstart = 1
			return
		if("lavaland_exit")
			lavaland_exit += loc
			delete_on_roundstart = 1
			return
	GLOB.landmarks_list += src
	return 1

/obj/landmark/observer_spawn
	name = "observer start"
	color = COLOR_BLUE
	landmark_key = /obj/landmark/observer_spawn

/obj/landmark/virtual_reality
	name = "virtual_reality"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/landmark/virtual_reality/Initialize(mapload)
	. = ..()
	tag = "virtual_reality*[name]"
	invisibility = 101
	return 1

// DONT ANYONE DARE ADD MORE COSTUME LANDMARKS HOLY SHIT I **WILL** DESTROY YOU AND THROW YOUR PR OUT THE WINDOW
// **DO NOT USE LANDMARKS AS SPAWNERS** ~silicons

//Costume spawner landmarks
/obj/landmark/costume

/obj/landmark/costume/random/Initialize(mapload)
	. = ..()
	var/list/options = subtypesof(/obj/landmark/costume) - /obj/landmark/costume/random
	var/PICK= options[rand(1,options.len)]
	new PICK(src.loc)
	return INITIALIZE_HINT_QDEL

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/landmark/costume/chicken/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/chickensuit(src.loc)
	new /obj/item/clothing/head/chicken(src.loc)
	new /obj/item/reagent_containers/food/snacks/egg(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/gladiator/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/gladiator(src.loc)
	new /obj/item/clothing/head/helmet/gladiator(src.loc)
	qdel(src)

/obj/landmark/costume/madscientist/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/suit/storage/toggle/labcoat/mad(src.loc)
	new /obj/item/clothing/glasses/gglasses(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/elpresidente/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(src.loc)
	new /obj/item/clothing/head/flatcap(src.loc)
	new /obj/item/clothing/mask/smokable/cigarette/cigar/havana(src.loc)
	new /obj/item/clothing/shoes/boots/jackboots(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/nyangirl/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/schoolgirl(src.loc)
	new /obj/item/clothing/head/kitty(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/maid/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/skirt(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/beret , /obj/item/clothing/head/rabbitears )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/butler/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/under/suit_jacket(src.loc)
	new /obj/item/clothing/head/that(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/scratch/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/gloves/white(src.loc)
	new /obj/item/clothing/shoes/white(src.loc)
	new /obj/item/clothing/under/scratch(src.loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/highlander/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/kilt(src.loc)
	new /obj/item/clothing/head/beret(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/prig/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/accessory/wcoat(src.loc)
	new /obj/item/clothing/glasses/monocle(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(src.loc)
	new /obj/item/clothing/shoes/black(src.loc)
	new /obj/item/cane(src.loc)
	new /obj/item/clothing/under/sl_suit(src.loc)
	new /obj/item/clothing/mask/fakemoustache(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/plaguedoctor/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(src.loc)
	new /obj/item/clothing/head/plaguedoctorhat(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/nightowl/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/owl(src.loc)
	new /obj/item/clothing/mask/gas/owl_mask(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/waiter/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/waiter(src.loc)
	var/CHOICE= pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(src.loc)
	new /obj/item/clothing/suit/storage/apron(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/pirate/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/pirate(src.loc)
	new /obj/item/clothing/suit/pirate(src.loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(src.loc)
	new /obj/item/clothing/glasses/eyepatch(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/commie/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/soviet(src.loc)
	new /obj/item/clothing/head/ushanka(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/imperium_monk/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/imperium_monk(src.loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/holiday_priest/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/holidaypriest(src.loc)
	qdel(src)

/obj/landmark/costume/marisawizard/fake/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/head/wizard/marisa/fake(src.loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/cutewitch/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/under/sundress(src.loc)
	new /obj/item/clothing/head/witchwig(src.loc)
	new /obj/item/staff/broom(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/fakewizard/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/suit/wizrobe/fake(src.loc)
	new /obj/item/clothing/head/wizard/fake(src.loc)
	new /obj/item/staff/(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/sexyclown/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/mask/gas/sexyclown(src.loc)
	new /obj/item/clothing/under/sexyclown(src.loc)
	delete_on_roundstart = 1

/obj/landmark/costume/sexymime/Initialize(mapload)
	. = ..()
	new /obj/item/clothing/mask/gas/sexymime(src.loc)
	new /obj/item/clothing/under/sexymime(src.loc)
	delete_on_roundstart = 1
