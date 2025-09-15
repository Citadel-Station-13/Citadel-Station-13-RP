//? BEHOLD THE LIST OF GLOBAL LISTS ?//

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

/// List of all human mobs and sub-types, including clientless.
var/global/list/human_mob_list = list()
/// List of all silicon mobs, including clientless.
var/global/list/silicon_mob_list = list()
/// List of all AIs, including clientless.
var/global/list/ai_list = list()
/// List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/living_mob_list = list()
/// List of all dead mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list = list()
/// List of all objects which care about receiving messages (communicators, radios, etc)
var/global/list/listening_objects = list()

/// Index for all cables, so that powernets don't have to look through the entire world all the time.
var/global/list/cable_list = list()
/// List of all medical sideeffects types by thier names.
var/global/list/side_effects = list()
/// List of all mechs. Used by hostile mobs target tracking.
var/global/list/mechas_list = list()

#define all_genders_define_list list(MALE,FEMALE,PLURAL,NEUTER,HERM)
#define all_genders_text_list list("Male","Female","Plural","Neuter","Herm")

/// Times that players are allowed to respawn ("ckey" = world.time)
GLOBAL_LIST_EMPTY(respawn_timers)

//* Uplinks
var/list/obj/item/uplink/world_uplinks = list()

//* Preferences stuff *//
//!Underwear
var/datum/category_collection/underwear/global_underwear = new()
//!Backpacks - The load order here is important to maintain. Don't go swapping these around.
var/global/list/backbaglist = list("Nothing", "Backpack", "Satchel", "Satchel Alt", "Messenger Bag", "RIG", "Duffle Bag")
var/global/list/pdachoicelist = list("Default", "Slim", "Old", "Rugged","Minimalist", "Holographic", "Wrist-Bound")
var/global/list/exclude_jobs = list(/datum/role/job/station/ai,/datum/role/job/station/cyborg)

//* Visual nets
GLOBAL_LIST_EMPTY(visual_nets)
GLOBAL_DATUM_INIT(cameranet, /datum/visualnet/camera, new)
GLOBAL_DATUM_INIT(cultnet, /datum/visualnet/cult, new)

//* Runes
var/global/list/rune_list = new()
var/global/list/escape_list = list()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()
//* Lavaland
var/global/list/lavaland_entry = list()
var/global/list/lavaland_exit = list()

var/global/list/syndicate_access = list(ACCESS_ENGINEERING_MAINT, ACCESS_FACTION_SYNDICATE, ACCESS_ENGINEERING_AIRLOCK)

/// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
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

/// Strings which corraspond to slot flags, useful for outputting what slot something is.
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

// To be replaced by tg rendering soon
GLOBAL_LIST_EMPTY(mannequins)
/proc/get_mannequin(var/ckey = "NULL")
	var/mob/living/carbon/human/dummy/mannequin/M = GLOB.mannequins[ckey]
	if(!istype(M))
		GLOB.mannequins[ckey] = new /mob/living/carbon/human/dummy/mannequin(null)
		M = GLOB.mannequins[ckey]
	return M

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/make_datum_reference_lists()
	//* Keybindings
	init_keybindings()

	//* Circuits
	initialize_integrated_circuits_list()

	//* Recipes
	init_subtypes(/datum/crafting_recipe, GLOB.crafting_recipes)

	//* Drink Reactions
	init_subtypes(/datum/chemical_reaction/drinks, GLOB.drink_recipes)

	var/list/paths

	// Custom species traits
	paths = typesof(/datum/trait) - /datum/trait - /datum/trait/negative - /datum/trait/neutral - /datum/trait/positive
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue //A prototype or something
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

	return 1 // Hooks must return 1

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
///Hexidecimal numbers
var/global/list/hexNums = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")

//! ## Traits
/// Negative custom species traits, indexed by path.
var/global/list/negative_traits = list()
/// Neutral custom species traits, indexed by path.
var/global/list/neutral_traits = list()
/// Positive custom species traits, indexed by path.
var/global/list/positive_traits = list()
/// Trait groups, indexed by path
var/global/list/all_trait_groups = list()
/// Just path = cost list, saves time in char setup.
var/global/list/traits_costs = list()
/// All of 'em at once. (same instances)
var/global/list/all_traits = list()

/// Suit Sensors global list.
var/global/list/sensorpreflist = list("Off", "Binary", "Vitals", "Tracking", "No Preference")

/// Stores numeric player size options indexed by name.
var/global/list/player_sizes_list = list(
		"Macro" 	= RESIZE_HUGE,
		"Big" 		= RESIZE_BIG,
		"Normal" 	= RESIZE_NORMAL,
		"Small" 	= RESIZE_SMALL,
		"Tiny" 		= RESIZE_TINY)

/// Stores vantag settings indexed by name.
var/global/list/vantag_choices_list = list(
		VANTAG_NONE		=	"No Involvement",
		VANTAG_VORE		=	"Be Prey",
		VANTAG_KIDNAP	=	"Be Kidnapped",
		VANTAG_KILL		=	"Be Killed")

/// Blacklist to exclude items from object ingestion. Digestion blacklist located in digest_act_vr.dm
GLOBAL_LIST_INIT(item_vore_blacklist, list(
		/obj/item/hand_tele,
		/obj/item/card/id/gold/captain/spare,
		/obj/item/gun,
		/obj/item/storage, //this was stupid why was this not here in the first place
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/blueprints,
		/obj/item/clothing/head/helmet/space,
		/obj/item/disk/nuclear))
//		/obj/item/clothing/suit/storage/hooded/wintercoat/roiz)

///Classic Vore sounds
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

///Poojy's Fancy Sounds
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
		SPECIES_UNATHI 		= UNATHI_EGG,
		SPECIES_UNATHI_DIGI = UNATHI_EGG,
		"Tajaran" 		= TAJARAN_EGG,
		SPECIES_AKULA 		= AKULA_EGG,
		SPECIES_SKRELL 		= SKRELL_EGG,
		SPECIES_NEVREAN		= NEVREAN_EGG,
		SPECIES_SERGAL 		= SERGAL_EGG,
		SPECIES_HUMAN			= HUMAN_EGG,
		"Slime"			= SLIME_EGG,
		"Egg"			= EGG_EGG,
		SPECIES_XENOCHIMERA 		= XENOCHIMERA_EGG,
		SPECIES_XENO		= XENOMORPH_EGG)

var/global/list/tf_vore_egg_types = list(
	SPECIES_UNATHI 		= /obj/structure/closet/secure_closet/egg/unathi,
	SPECIES_UNATHI_DIGI = /obj/structure/closet/secure_closet/egg/unathi,
	SPECIES_TAJ 		= /obj/structure/closet/secure_closet/egg/tajaran,
	SPECIES_AKULA 		= /obj/structure/closet/secure_closet/egg/shark,
	SPECIES_SKRELL 		= /obj/structure/closet/secure_closet/egg/skrell,
	SPECIES_SERGAL		= /obj/structure/closet/secure_closet/egg/sergal,
	SPECIES_NEVREAN		= /obj/structure/closet/secure_closet/egg/nevrean,
	SPECIES_HUMAN			= /obj/structure/closet/secure_closet/egg/human,
	"Slime"			= /obj/structure/closet/secure_closet/egg/slime,
	"Egg"			= /obj/structure/closet/secure_closet/egg,
	SPECIES_XENOCHIMERA		= /obj/structure/closet/secure_closet/egg/scree,
	SPECIES_XENO		= /obj/structure/closet/secure_closet/egg/xenomorph)

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
				/obj/item/material/kitchen/utensil,
				/obj/item/material/shard,
				/obj/item/newspaper,
				/obj/item/paper,
				/obj/item/paperplane,
				/obj/item/pen,
				/obj/item/photo,
				/obj/item/reagent_containers/food,
				/obj/item/reagent_containers/glass/bottle,
				/obj/item/reagent_containers/glass/rag,
				/obj/item/reagent_containers/hypospray/autoinjector,
				/obj/item/skub,
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

///For the mechanic of leaving remains. Ones listed below are basically ones that got no bones or leave no trace after death.
var/global/list/remainless_species = list(SPECIES_ID_PROMETHEAN,
				SPECIES_ID_DIONA,
				SPECIES_ID_ALRAUNE,
				SPECIES_ID_PROTEAN,
				SPECIES_ID_MONKEY, //Exclude all monkey subtypes, which is handled by ID
				SPECIES_ID_XENOMORPH, //Same for xenos
				SPECIES_ID_SHADOW,
				SPECIES_ID_GOLEM, //Some special species that may or may not be ever used in event too,
				SPECIES_ID_SHADEKIN) //Shadefluffers just poof away

/legacy_hook/startup/proc/init_vore_datum_ref_lists()
	var/paths

	// Custom species traits
	paths = typesof(/datum/trait) - /datum/trait
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue //A prototype or something
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

	// Trait groups
	paths = typesof(/datum/trait_group) - /datum/trait_group
	for(var/path in paths)
		var/datum/trait_group/instance = new path()
		if(!instance.name)
			continue  // Should never happen but worth checking for
		all_trait_groups[path] = instance

	// Weaver recipe stuff
	paths = subtypesof(/datum/weaver_recipe/structure)
	for(var/path in paths)
		var/datum/weaver_recipe/instance = new path()
		if(!instance.title)
			continue //A prototype or something
		weavable_structures[instance.title] = instance

	paths = subtypesof(/datum/weaver_recipe/item)
	for(var/path in paths)
		var/datum/weaver_recipe/instance = new path()
		if(!instance.title)
			continue //A prototype or something
		weavable_items[instance.title] = instance

	return 1 // Hooks must return 1


// XENOBIOLOGY
var/global/list/xenobio_metal_materials_normal = list(
										/obj/item/stack/material/steel = 20,
										/obj/item/stack/material/glass = 15,
										/obj/item/stack/material/plastic = 12,
										/obj/item/stack/material/wood = 12,
										/obj/item/stack/material/cardboard = 6,
										/obj/item/stack/material/sandstone = 5,
										/obj/item/stack/material/log = 5,
										/obj/item/stack/material/lead = 5,
										/obj/item/stack/material/iron = 5,
//uncomment these if it's ever decided that these should exist
//										/obj/item/stack/material/graphite = 5,
//										/obj/item/stack/material/tin = 4,
//										/obj/item/stack/material/bronze = 4,
//										/obj/item/stack/material/aluminium = 4,
										/obj/item/stack/material/copper = 4)

var/global/list/xenobio_metal_materials_adv = list(
										/obj/item/stack/material/glass/reinforced = 15,
										/obj/item/stack/material/marble = 10,
										/obj/item/stack/material/brass = 10,
										/obj/item/stack/material/plasteel = 10,
										/obj/item/stack/material/glass/phoronglass = 10,
										/obj/item/stack/material/wood/sif = 5,
										/obj/item/stack/material/wood/hard = 5,
										/obj/item/stack/material/log/sif = 5,
										/obj/item/stack/material/log/hard = 5,
										/obj/item/stack/material/glass/phoronrglass = 5,
//										/obj/item/stack/material/glass/titanium = 3,
//										/obj/item/stack/material/glass/plastitanium = 3,
//										/obj/item/stack/material/painite = 1,
//										/obj/item/stack/material/void_opal = 1,
//										/obj/item/stack/material/quartz = 1
										/obj/item/stack/material/durasteel = 2)


var/global/list/xenobio_metal_materials_weird = list(
										/obj/item/stack/material/cloth = 10,
										/obj/item/stack/material/leather = 5,
										/obj/item/stack/material/bone = 10,
										/obj/item/stack/material/wax = 10,
//										/obj/item/stack/material/fiber = 5,
//										/obj/item/stack/material/fur/wool = 7,
										/obj/item/stack/material/snow = 3,
										/obj/item/stack/material/snowbrick = 3,
//										/obj/item/stack/material/flint = 3,
//										/obj/item/stack/material/stick = 3,
										/obj/item/stack/material/chitin = 1,
										/obj/item/stack/material/resin = 1)

var/global/list/xenobio_silver_materials_basic = list(
										/obj/item/stack/material/silver = 10,
										/obj/item/stack/material/uranium = 8,
										/obj/item/stack/material/gold = 6,
										/obj/item/stack/material/titanium = 4,
										/obj/item/stack/material/phoron = 1)

var/global/list/xenobio_silver_materials_adv = list(
										/obj/item/stack/material/deuterium = 5,
										/obj/item/stack/material/tritium = 5,
										/obj/item/stack/material/osmium = 5,
										/obj/item/stack/material/mhydrogen = 3,
										/obj/item/stack/material/diamond = 2,
										/obj/item/stack/material/verdantium = 1)

var/global/list/xenobio_silver_materials_special = list(
										/obj/item/stack/material/valhollide = 1,
										/obj/item/stack/material/morphium = 1,
										/obj/item/stack/material/bananium = 1, //cit addition: :o)
										/obj/item/stack/material/silencium = 1)

//TODO: add Cit-RP specific mobs, maybe? also, maybe some mobs could be ported?
var/global/list/xenobio_gold_mobs_hostile = list(
//										/mob/living/simple_mob/vore/alienanimals/space_jellyfish,
//										/mob/living/simple_mob/vore/alienanimals/skeleton,
//										/mob/living/simple_mob/vore/alienanimals/space_ghost,
//										/mob/living/simple_mob/vore/alienanimals/startreader,
//										/mob/living/simple_mob/animal/passive/mouse/operative,
										/mob/living/simple_mob/animal/giant_spider,
										/mob/living/simple_mob/animal/giant_spider/frost,
										/mob/living/simple_mob/animal/giant_spider/electric,
										/mob/living/simple_mob/animal/giant_spider/hunter,
										/mob/living/simple_mob/animal/giant_spider/lurker,
										/mob/living/simple_mob/animal/giant_spider/pepper,
										/mob/living/simple_mob/animal/giant_spider/thermic,
										/mob/living/simple_mob/animal/giant_spider/tunneler,
										/mob/living/simple_mob/animal/giant_spider/webslinger,
										/mob/living/simple_mob/animal/giant_spider/phorogenic,
										/mob/living/simple_mob/animal/giant_spider/carrier,
										/mob/living/simple_mob/animal/giant_spider/nurse,
										/mob/living/simple_mob/animal/giant_spider/ion,
										/mob/living/simple_mob/animal/giant_spider/nurse/queen,
										/mob/living/simple_mob/animal/sif/diyaab,
										/mob/living/simple_mob/animal/sif/duck,
										/mob/living/simple_mob/animal/sif/frostfly,
										/mob/living/simple_mob/animal/sif/glitterfly,
										/mob/living/simple_mob/animal/sif/hooligan_crab,
										/mob/living/simple_mob/animal/sif/kururak,
										/mob/living/simple_mob/animal/sif/leech,
//										/mob/living/simple_mob/animal/sif/tymisian,
										/mob/living/simple_mob/animal/sif/sakimm,
										/mob/living/simple_mob/animal/sif/savik,
										/mob/living/simple_mob/animal/sif/shantak,
//										/mob/living/simple_mob/animal/sif/siffet,
										/mob/living/simple_mob/animal/space/xenomorph/warrior,
										/mob/living/simple_mob/animal/space/xenomorph/drone,
										/mob/living/simple_mob/animal/space/xenomorph/neurotoxin_spitter,
										/mob/living/simple_mob/animal/space/xenomorph/acid_spitter,
										/mob/living/simple_mob/animal/space/xenomorph/vanguard,
										/mob/living/simple_mob/animal/space/bats,
										/mob/living/simple_mob/animal/space/bear,
										/mob/living/simple_mob/animal/space/carp,
										/mob/living/simple_mob/animal/space/carp/large,
										/mob/living/simple_mob/animal/space/carp/large/huge,
										/mob/living/simple_mob/animal/space/goose,
										/mob/living/simple_mob/creature,
										/mob/living/simple_mob/faithless,
										/mob/living/simple_mob/tomato,
										/mob/living/simple_mob/animal/space/tree,
										/mob/living/simple_mob/vore/aggressive/corrupthound,
										/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
										/mob/living/simple_mob/vore/aggressive/deathclaw,
										/mob/living/simple_mob/vore/aggressive/dino,
										/mob/living/simple_mob/vore/aggressive/frog,
//										/mob/living/simple_mob/vore/otie,
//										/mob/living/simple_mob/vore/otie/red,
										/mob/living/simple_mob/vore/aggressive/panther,
										/mob/living/simple_mob/vore/aggressive/rat,
//										/mob/living/simple_mob/vore/sect_drone,
//										/mob/living/simple_mob/vore/sect_queen,
//										/mob/living/simple_mob/vore/weretiger,
//										/mob/living/simple_mob/vore/wolf,
//										/mob/living/simple_mob/vore/xeno_defanged,
										/mob/living/simple_mob/vore/aggressive/giant_snake)

//TODO: literally none of these boss mobs exist in code, so I just shoved the aliens and dragon in as a placeholder for now
var/global/list/xenobio_gold_mobs_bosses = list(
										/mob/living/simple_mob/vore/aggressive/dragon)
//										/mob/living/simple_mob/vore/leopardmander,
//										/mob/living/simple_mob/vore/leopardmander/blue,
//										/mob/living/simple_mob/vore/leopardmander/exotic,
//										/mob/living/simple_mob/vore/greatwolf,
//										/mob/living/simple_mob/vore/greatwolf/black,
//										/mob/living/simple_mob/vore/greatwolf/grey,
//										/mob/living/simple_mob/vore/bigdragon,

var/global/list/xenobio_gold_mobs_safe = list(
//										/mob/living/simple_mob/vore/alienanimals/dustjumper,
										/mob/living/simple_mob/animal/passive/chicken,
										/mob/living/simple_mob/animal/passive/cow,
										/mob/living/simple_mob/animal/goat,
										/mob/living/simple_mob/animal/passive/crab,
//										/mob/living/simple_mob/animal/passive/mouse/jerboa,
										/mob/living/simple_mob/animal/passive/lizard,
										/mob/living/simple_mob/animal/passive/lizard/large,
										/mob/living/simple_mob/animal/passive/yithian,
										/mob/living/simple_mob/animal/passive/tindalos,
										/mob/living/simple_mob/animal/passive/mouse,
										/mob/living/simple_mob/animal/passive/penguin,
//										/mob/living/simple_mob/animal/passive/opossum,
										/mob/living/simple_mob/animal/passive/cat,
										/mob/living/simple_mob/animal/passive/dog/corgi,
//										/mob/living/simple_mob/animal/passive/dog/void_puppy,
//										/mob/living/simple_mob/animal/passive/dog/bullterrier,
										/mob/living/simple_mob/animal/passive/dog/tamaskan,
//										/mob/living/simple_mob/animal/passive/dog/brittany,
										/mob/living/simple_mob/animal/passive/fox,
										/mob/living/simple_mob/animal/passive/fox/syndicate,
//										/mob/living/simple_mob/animal/passive/hare,
//										/mob/living/simple_mob/animal/passive/pillbug,
										/mob/living/simple_mob/animal/passive/gaslamp,
										/mob/living/simple_mob/animal/passive/snake,
//										/mob/living/simple_mob/animal/passive/snake/red,
//										/mob/living/simple_mob/animal/passive/snake/python,
										/mob/living/simple_mob/vore/bee,
										/mob/living/simple_mob/vore/fennec,
										/mob/living/simple_mob/vore/fennix,
//										/mob/living/simple_mob/vore/seagull,
										/mob/living/simple_mob/vore/hippo,
//										/mob/living/simple_mob/vore/horse,
//										/mob/living/simple_mob/vore/jelly,
//										/mob/living/simple_mob/vore/oregrub,
//										/mob/living/simple_mob/vore/oregrub/lava,
//										/mob/living/simple_mob/vore/rabbit,
										/mob/living/simple_mob/vore/redpanda,
//										/mob/living/simple_mob/vore/sheep,
//										/mob/living/simple_mob/vore/squirrel,
										/mob/living/simple_mob/vore/solargrub)

var/global/list/xenobio_gold_mobs_birds = list(/mob/living/simple_mob/animal/passive/bird/black_bird,
										/mob/living/simple_mob/animal/passive/bird/azure_tit,
										/mob/living/simple_mob/animal/passive/bird/european_robin,
										/mob/living/simple_mob/animal/passive/bird/goldcrest,
										/mob/living/simple_mob/animal/passive/bird/ringneck_dove,
										/mob/living/simple_mob/animal/passive/bird/parrot,
										/mob/living/simple_mob/animal/passive/bird/parrot/kea,
										/mob/living/simple_mob/animal/passive/bird/parrot/eclectus,
										/mob/living/simple_mob/animal/passive/bird/parrot/grey_parrot,
										/mob/living/simple_mob/animal/passive/bird/parrot/black_headed_caique,
										/mob/living/simple_mob/animal/passive/bird/parrot/white_caique,
										/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar,
										/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/blue,
										/mob/living/simple_mob/animal/passive/bird/parrot/budgerigar/bluegreen,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/white,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/yellowish,
										/mob/living/simple_mob/animal/passive/bird/parrot/cockatiel/grey,
										/mob/living/simple_mob/animal/passive/bird/parrot/sulphur_cockatoo,
										/mob/living/simple_mob/animal/passive/bird/parrot/white_cockatoo,
										/mob/living/simple_mob/animal/passive/bird/parrot/pink_cockatoo)			//There's too dang many

var/global/list/xenobio_cerulean_potions = list(
										/obj/item/slimepotion/enhancer,
										/obj/item/slimepotion/stabilizer,
										/obj/item/slimepotion/mutator,
										/obj/item/slimepotion/docility,
										/obj/item/slimepotion/steroid,
										/obj/item/slimepotion/unity,
										/obj/item/slimepotion/loyalty,
										/obj/item/slimepotion/friendship,
										/obj/item/slimepotion/feeding,
										/obj/item/slimepotion/infertility,
										/obj/item/slimepotion/fertility,
										/obj/item/slimepotion/shrink,
										/obj/item/slimepotion/death,
										/obj/item/slimepotion/ferality,
										/obj/item/slimepotion/reinvigoration,
										/obj/item/slimepotion/mimic,
										/obj/item/slimepotion/sapience,
										/obj/item/slimepotion/obedience)

var/global/list/xenobio_rainbow_extracts = list(
										/obj/item/slime_extract/grey = 2,
										/obj/item/slime_extract/metal = 3,
										/obj/item/slime_extract/blue = 3,
										/obj/item/slime_extract/purple = 1,
										/obj/item/slime_extract/orange = 3,
										/obj/item/slime_extract/yellow = 3,
										/obj/item/slime_extract/gold = 3,
										/obj/item/slime_extract/silver = 3,
										/obj/item/slime_extract/dark_purple = 2,
										/obj/item/slime_extract/dark_blue = 3,
										/obj/item/slime_extract/red = 3,
										/obj/item/slime_extract/green = 3,
										/obj/item/slime_extract/pink = 3,
										/obj/item/slime_extract/oil = 3,
										/obj/item/slime_extract/bluespace = 3,
										/obj/item/slime_extract/cerulean = 1,
										/obj/item/slime_extract/amber = 3,
										/obj/item/slime_extract/sapphire = 3,
										/obj/item/slime_extract/ruby = 3,
										/obj/item/slime_extract/emerald = 3,
										/obj/item/slime_extract/light_pink = 1,
										/obj/item/slime_extract/rainbow = 1)
//END XENOBIOLOGY
