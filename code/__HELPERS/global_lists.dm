var/list/admins = list()							// list of all clients whom are admins

// Since it didn't really belong in any other category, I'm putting this here
// This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/player_list = list()				// List of all mobs **with clients attached**. Excludes /mob/new_player
var/global/list/mob_list = list()					// List of all mobs, including clientless
var/global/list/human_mob_list = list()				// List of all human mobs and sub-types, including clientless
var/global/list/silicon_mob_list = list()			// List of all silicon mobs, including clientless
var/global/list/ai_list = list()					// List of all AIs, including clientless
var/global/list/living_mob_list = list()			// List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list = list()				// List of all dead mobs, including clientless. Excludes /mob/new_player
var/global/list/listening_objects = list()			// List of all objects which care about receiving messages (communicators, radios, etc)

var/global/list/cable_list = list()					// Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/landmarks_list = list()				// list of all landmarks created
var/global/list/side_effects = list()				// list of all medical sideeffects types by thier names |BS12
var/global/list/mechas_list = list()				// list of all mechs. Used by hostile mobs target tracking.
var/global/list/joblist = list()					// list of all jobstypes, minus borg and AI

#define all_genders_define_list list(MALE,FEMALE,PLURAL,NEUTER,HERM)
#define all_genders_text_list list("Male","Female","Plural","Neuter","Herm")

var/list/mannequins_

// Times that players are allowed to respawn ("ckey" = world.time)
GLOBAL_LIST_EMPTY(respawn_timers)

// Posters
var/global/list/poster_designs = list()
var/global/list/NT_poster_designs = list()

// Uplinks
var/list/obj/item/uplink/world_uplinks = list()

// Preferences stuff
	// Hairstyles
var/global/list/hair_styles_list = list()				// Stores /datum/sprite_accessory/hair indexed by name
var/global/list/hair_styles_male_list = list()
var/global/list/hair_styles_female_list = list()
var/global/list/facial_hair_styles_list = list()		// Stores /datum/sprite_accessory/facial_hair indexed by name
var/global/list/facial_hair_styles_male_list = list()
var/global/list/facial_hair_styles_female_list = list()
var/global/list/skin_styles_female_list = list()		// Unused
var/global/list/body_marking_styles_list = list()		// Stores /datum/sprite_accessory/marking indexed by name
var/global/list/ear_styles_list = list()				// Stores /datum/sprite_accessory/ears indexed by type
var/global/list/tail_styles_list = list()				// Stores /datum/sprite_accessory/tail indexed by type
var/global/list/wing_styles_list = list()				// Stores /datum/sprite_accessory/wing indexed by type

	// Traits
var/global/list/negative_traits = list()				// Negative custom species traits, indexed by path
var/global/list/neutral_traits = list()					// Neutral custom species traits, indexed by path
var/global/list/positive_traits = list()				// Positive custom species traits, indexed by path
var/global/list/traits_costs = list()					// Just path = cost list, saves time in char setup
var/global/list/all_traits = list()						// All of 'em at once (same instances)

var/global/list/sensorpreflist = list("Off", "Binary", "Vitals", "Tracking", "No Preference")	// TFF 5/8/19 - Suit Sensors global list

var/global/list/custom_species_bases = list() // Species that can be used for a Custom Species icon base


	// Underwear
var/datum/category_collection/underwear/global_underwear = new()

	// Backpacks
var/global/list/backbaglist = list("Nothing", "Backpack", "Satchel", "Satchel Alt", "Messenger Bag")
var/global/list/pdachoicelist = list("Default", "Slim", "Old", "Rugged","Minimalist", "Holographic", "Wrist-Bound")
var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)

// Visual nets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet = new()
var/datum/visualnet/cult/cultnet = new()

// Runes
var/global/list/rune_list = new()
var/global/list/escape_list = list()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()

var/global/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"feet" = FEET,
	"arms" = ARMS,
	"hands" = HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back" = SLOT_BACK,
	"face" = SLOT_MASK,
	"waist" = SLOT_BELT,
	"ID slot" = SLOT_ID,
	"ears" = SLOT_EARS,
	"eyes" = SLOT_EYES,
	"hands" = SLOT_GLOVES,
	"head" = SLOT_HEAD,
	"feet" = SLOT_FEET,
	"exo slot" = SLOT_OCLOTHING,
	"body" = SLOT_ICLOTHING,
	"uniform" = SLOT_TIE,
	"holster" = SLOT_HOLSTER
)

// Stores numeric player size options indexed by name
var/global/list/player_sizes_list = list(
		"Macro" 	= RESIZE_HUGE,
		"Big" 		= RESIZE_BIG,
		"Normal" 	= RESIZE_NORMAL,
		"Small" 	= RESIZE_SMALL,
		"Tiny" 		= RESIZE_TINY)

// Stores vantag settings indexed by name
var/global/list/vantag_choices_list = list(
		VANTAG_NONE		=	"No Involvement",
		VANTAG_VORE		=	"Be Prey",
		VANTAG_KIDNAP	=	"Be Kidnapped",
		VANTAG_KILL		=	"Be Killed")

// Blacklist to exclude items from object ingestion. Digestion blacklist located in digest_act_vr.dm
var/global/list/item_vore_blacklist = list(
		/obj/item/hand_tele,
		/obj/item/card/id/gold/captain/spare,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/disk/nuclear)
//		/obj/item/clothing/suit/storage/hooded/wintercoat/roiz)

// Classic Vore sounds
var/global/list/classic_vore_sounds = list(
		"Gulp" = 'sound/vore/gulp.ogg',
		"Insert" = 'sound/vore/insert.ogg',
		"Insertion1" = 'sound/vore/insertion1.ogg',
		"Insertion2" = 'sound/vore/insertion2.ogg',
		"Insertion3" = 'sound/vore/insertion3.ogg',
		"Schlorp" = 'sound/vore/schlorp.ogg',
		"Squish1" = 'sound/vore/squish1.ogg',
		"Squish2" = 'sound/vore/squish2.ogg',
		"Squish3" = 'sound/vore/squish3.ogg',
		"Squish4" = 'sound/vore/squish4.ogg',
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)"	= 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'sound/effects/rustle5.ogg',
		"None" = null)

var/global/list/classic_release_sounds = list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
		"Splatter" = 'sound/effects/splat.ogg',
		"None" = null
		)

// Poojy's Fancy Sounds
var/global/list/fancy_vore_sounds = list(
		"Gulp" = 'sound/vore/sunesound/pred/swallow_01.ogg',
		"Swallow" = 'sound/vore/sunesound/pred/swallow_02.ogg',
		"Insertion1" = 'sound/vore/sunesound/pred/insertion_01.ogg',
		"Insertion2" = 'sound/vore/sunesound/pred/insertion_02.ogg',
		"Tauric Swallow" = 'sound/vore/sunesound/pred/taurswallow.ogg',
		"Stomach Move"		= 'sound/vore/sunesound/pred/stomachmove.ogg',
		"Schlorp" = 'sound/vore/sunesound/pred/schlorp.ogg',
		"Squish1" = 'sound/vore/sunesound/pred/squish_01.ogg',
		"Squish2" = 'sound/vore/sunesound/pred/squish_02.ogg',
		"Squish3" = 'sound/vore/sunesound/pred/squish_03.ogg',
		"Squish4" = 'sound/vore/sunesound/pred/squish_04.ogg',
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)"	= 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'sound/effects/rustle5.ogg',
		"None" = null
		)

var/global/list/fancy_release_sounds = list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
		"Stomach Move" = 'sound/vore/sunesound/pred/stomachmove.ogg',
		"Pred Escape" = 'sound/vore/sunesound/pred/escape.ogg',
		"Splatter" = 'sound/effects/splat.ogg',
		"None" = null
		)

var/global/list/global_vore_egg_types = list(
		"Unathi" 		= UNATHI_EGG,
		"Tajaran" 		= TAJARAN_EGG,
		"Akula" 		= AKULA_EGG,
		"Skrell" 		= SKRELL_EGG,
		"Nevrean"		= NEVREAN_EGG,
		"Sergal" 		= SERGAL_EGG,
		"Human"			= HUMAN_EGG,
		"Slime"			= SLIME_EGG,
		"Egg"			= EGG_EGG,
		"Xenochimera" 		= XENOCHIMERA_EGG,
		"Xenomorph"		= XENOMORPH_EGG)

var/global/list/tf_vore_egg_types = list(
	"Unathi" 		= /obj/structure/closet/secure_closet/egg/unathi,
	"Tajara" 		= /obj/structure/closet/secure_closet/egg/tajaran,
	"Akula" 		= /obj/structure/closet/secure_closet/egg/shark,
	"Skrell" 		= /obj/structure/closet/secure_closet/egg/skrell,
	"Sergal"		= /obj/structure/closet/secure_closet/egg/sergal,
	"Nevrean"		= /obj/structure/closet/secure_closet/egg/nevrean,
	"Human"			= /obj/structure/closet/secure_closet/egg/human,
	"Slime"			= /obj/structure/closet/secure_closet/egg/slime,
	"Egg"			= /obj/structure/closet/secure_closet/egg,
	"Xenochimera"		= /obj/structure/closet/secure_closet/egg/scree,
	"Xenomorph"		= /obj/structure/closet/secure_closet/egg/xenomorph)

var/global/list/edible_trash = list(/obj/item/broken_device,
				/obj/item/clothing/accessory/collar,
				/obj/item/communicator,
				/obj/item/clothing/mask,
				/obj/item/clothing/glasses,
				/obj/item/clothing/gloves,
				/obj/item/clothing/head,
				/obj/item/clothing/shoes,
				/obj/item/aicard,
				/obj/item/flashlight,
				/obj/item/mmi/digital/posibrain,
				/obj/item/paicard,
				/obj/item/pda,
				/obj/item/radio/headset,
				/obj/item/inflatable/torn,
				/obj/item/organ,
				/obj/item/stack/material/cardboard,
				/obj/item/toy,
				/obj/item/trash,
				/obj/item/digestion_remains,
				/obj/item/bananapeel,
				/obj/item/bone,
				/obj/item/broken_bottle,
				/obj/item/card/emag_broken,
				/obj/item/cigbutt,
				/obj/item/circuitboard/broken,
				/obj/item/clipboard,
				/obj/item/corncob,
				/obj/item/dice,
				/obj/item/flame,
				/obj/item/light,
				/obj/item/lipstick,
				/obj/item/material/shard,
				/obj/item/newspaper,
				/obj/item/paper,
				/obj/item/paperplane,
				/obj/item/pen,
				/obj/item/photo,
				/obj/item/reagent_containers/food,
				/obj/item/reagent_containers/glass/bottle,
				/obj/item/reagent_containers/glass/rag,
				/obj/item/soap,
				/obj/item/spacecash,
				/obj/item/storage/box/vmcrystal,
				/obj/item/storage/box/matches,
				/obj/item/storage/box/wings,
				/obj/item/storage/fancy/candle_box,
				/obj/item/storage/fancy/cigarettes,
				/obj/item/storage/fancy/crayons,
				/obj/item/storage/fancy/egg_box,
				/obj/item/storage/wallet)

var/global/list/contamination_flavors = list(
				"Generic" = contamination_flavors_generic,
				"Acrid" = contamination_flavors_acrid,
				"Dirty" = contamination_flavors_dirty,
				"Musky" = contamination_flavors_musky,
				"Smelly" = contamination_flavors_smelly,
				"Wet" = contamination_flavors_wet)

var/global/list/contamination_flavors_generic = list("acrid",
				"bedraggled",
				"begrimed",
				"churned",
				"contaminated",
				"cruddy",
				"damp",
				"digested",
				"dirty",
				"disgusting",
				"drenched",
				"drippy",
				"filthy",
				"foul",
				"funky",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"gruesome",
				"gunky",
				"icky",
				"juicy",
				"messy",
				"mucky",
				"mushy",
				"nasty",
				"noxious",
				"oozing",
				"pungent",
				"putrescent",
				"putrid",
				"repulsive",
				"saucy",
				"slimy",
				"sloppy",
				"sloshed",
				"sludgy",
				"smeary",
				"smelly",
				"smudgy",
				"smutty",
				"soaked",
				"soggy",
				"soiled",
				"sopping",
				"squashy",
				"squishy",
				"stained",
				"sticky",
				"stinky",
				"tainted",
				"tarnished",
				"unclean",
				"unsanitary",
				"unsavory",
				"yucky")

var/global/list/contamination_flavors_wet = list("damp",
				"drenched",
				"drippy",
				"gloppy",
				"gooey",
				"juicy",
				"oozing",
				"slimy",
				"slobbery",
				"sloppy",
				"sloshed",
				"sloughy",
				"sludgy",
				"slushy",
				"soaked",
				"soggy",
				"sopping",
				"squashy",
				"squishy",
				"sticky")

var/global/list/contamination_flavors_smelly = list("disgusting",
				"filthy",
				"foul",
				"funky",
				"gross",
				"icky",
				"malodorous",
				"nasty",
				"niffy",
				"noxious",
				"pungent",
				"putrescent",
				"putrid",
				"rancid",
				"reeking",
				"repulsive",
				"smelly",
				"stenchy",
				"stinky",
				"unsavory",
				"whiffy",
				"yucky")

var/global/list/contamination_flavors_acrid = list("acrid",
				"caustic",
				"churned",
				"chymous",
				"digested",
				"discolored",
				"disgusting",
				"drippy",
				"foul",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"gruesome",
				"icky",
				"mucky",
				"mushy",
				"nasty",
				"noxious",
				"oozing",
				"pungent",
				"putrescent",
				"putrid",
				"repulsive",
				"saucy",
				"slimy",
				"sloppy",
				"sloshed",
				"sludgy",
				"slushy",
				"smelly",
				"smudgy",
				"soupy",
				"squashy",
				"squishy",
				"stained",
				"sticky",
				"tainted",
				"unsavory",
				"yucky")

var/global/list/contamination_flavors_dirty = list("bedraggled",
				"begrimed",
				"besmirched",
				"blemished",
				"contaminated",
				"cruddy",
				"dirty",
				"discolored",
				"filthy",
				"gloppy",
				"gooey",
				"grimy",
				"gross",
				"grubby",
				"gruesome",
				"gunky",
				"messy",
				"mucky",
				"mushy",
				"nasty",
				"saucy",
				"slimy",
				"sloppy",
				"sludgy",
				"smeary",
				"smudgy",
				"smutty",
				"soiled",
				"stained",
				"sticky",
				"tainted",
				"tarnished",
				"unclean",
				"unsanitary",
				"unsavory")

var/global/list/contamination_flavors_musky = list("drenched",
				"drippy",
				"funky",
				"gooey",
				"juicy",
				"messy",
				"musky",
				"nasty",
				"raunchy",
				"saucy",
				"slimy",
				"sloppy",
				"slushy",
				"smeary",
				"smelly",
				"smutty",
				"soggy",
				"squashy",
				"squishy",
				"sticky",
				"tainted")

var/global/list/contamination_colors = list("green",
				"white",
				"black",
				"grey",
				"yellow",
				"red",
				"blue",
				"orange",
				"purple",
				"lime",
				"brown",
				"darkred",
				"cyan",
				"beige",
				"pink")

// The mechanic of leaving remains. Ones listed below are basically ones that got no bones or leave no trace after death.
var/global/list/remainless_species = list(SPECIES_PROMETHEAN,
				SPECIES_DIONA,
				SPECIES_ALRAUNE,
				SPECIES_PROTEAN,
				SPECIES_MONKEY,				// Exclude all monkey subtypes, to prevent abuse of it. They aren't,
				SPECIES_MONKEY_TAJ,			// Set to have remains anyway, but making double sure,
				SPECIES_MONKEY_SKRELL,
				SPECIES_MONKEY_UNATHI,
				SPECIES_MONKEY_AKULA,
				SPECIES_MONKEY_NEVREAN,
				SPECIES_MONKEY_SERGAL,
				SPECIES_MONKEY_VULPKANIN,
				SPECIES_XENO,				// Same for xenos,
				SPECIES_XENO_DRONE,
				SPECIES_XENO_HUNTER,
				SPECIES_XENO_SENTINEL,
				SPECIES_XENO_QUEEN,
				SPECIES_SHADOW,
				SPECIES_GOLEM,				// Some special species that may or may not be ever used in event too,
				SPECIES_SHADEKIN)			// Shadefluffers just poof away

/hook/startup/proc/init_vore_datum_ref_lists()
	var/paths

	// Custom Ears
	paths = typesof(/datum/sprite_accessory/ears) - /datum/sprite_accessory/ears
	for(var/path in paths)
		var/obj/item/clothing/head/instance = new path()
		ear_styles_list[path] = instance

	// Custom Tails
	paths = typesof(/datum/sprite_accessory/tail) - /datum/sprite_accessory/tail - /datum/sprite_accessory/tail/taur
	for(var/path in paths)
		var/datum/sprite_accessory/tail/instance = new path()
		tail_styles_list[path] = instance

	// Custom Wings
	paths = typesof(/datum/sprite_accessory/wing) - /datum/sprite_accessory/wing
	for(var/path in paths)
		var/datum/sprite_accessory/wing/instance = new path()
		wing_styles_list[path] = instance

	// Custom species traits
	paths = typesof(/datum/trait) - /datum/trait
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue	// A prototype or something
		var/cost = instance.cost
		traits_costs[path] = cost
		all_traits[path] = instance
		switch(cost)
			if(-INFINITY to -0.1)
				negative_traits[path] = instance
			if(0)
				neutral_traits[path] = instance
			if(0.1 to INFINITY)
				positive_traits[path] = instance

	// Custom species icon bases
	var/list/blacklisted_icons = list(SPECIES_CUSTOM,SPECIES_PROMETHEAN)	// Just ones that won't work well.
	for(var/species_name in GLOB.playable_species)
		if(species_name in blacklisted_icons)
			continue
		var/datum/species/S = GLOB.all_species[species_name]
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			continue
		custom_species_bases += species_name

	return 1	// Hooks must return 1





/proc/get_mannequin(var/ckey)
	if(!mannequins_)
		mannequins_ = new()
 	. = mannequins_[ckey]
	if(!.)
		. = new/mob/living/carbon/human/dummy/mannequin()
		mannequins_[ckey] = .

// // // // // // // // // // // // //
// // /Initial Building// // /
// // // // // // // // // // // // //

/proc/make_datum_reference_lists()
	// Keybindings
	init_keybindings()

	// Circuits
	initialize_integrated_circuits_list()

	var/list/paths

	// Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	// Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = typesof(/datum/sprite_accessory/facial_hair) - /datum/sprite_accessory/facial_hair
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	// Body markings - Initialise all /datum/sprite_accessory/marking into an list indexed by marking name
	paths = typesof(/datum/sprite_accessory/marking) - /datum/sprite_accessory/marking
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		body_marking_styles_list[M.name] = M

	// List of job. I can't believe this was calculated multiple times per tick!
	paths = typesof(/datum/job)-/datum/job
	paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		joblist[J.title] = J

	// Languages and species.
	paths = typesof(/datum/language)-/datum/language
	for(var/T in paths)
		var/datum/language/L = new T
		GLOB.all_languages[L.name] = L

	for (var/language_name in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			GLOB.language_keys[lowertext(L.key)] = L

	var/rkey = 0
	paths = typesof(/datum/species)
	for(var/T in paths)

		rkey++

		var/datum/species/S = T
		if(!initial(S.name))
			continue

		S = new T
		S.race_key = rkey // Used in mob icon caching.
		GLOB.all_species[S.name] = S

		if(!(S.spawn_flags & SPECIES_IS_RESTRICTED))
			GLOB.playable_species += S.name
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			GLOB.whitelisted_species += S.name

	// Posters
	paths = typesof(/datum/poster) - /datum/poster
	paths -= typesof(/datum/poster/nanotrasen)
	for(var/T in paths)
		var/datum/poster/P = new T
		poster_designs += P

	paths = typesof(/datum/poster/nanotrasen)
	for(var/T in paths)
		var/datum/poster/P = new T
		NT_poster_designs += P

	return 1

/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	world << .
*/
// Hexidecimal numbers
var/global/list/hexNums = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")
