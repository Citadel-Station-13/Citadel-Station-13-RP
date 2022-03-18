#define DEFAULT_HUNGER_FACTOR 0.03 // Factor of how fast mob nutrition decreases
#define DEFAULT_THIRST_FACTOR 0.03 // Factor of how fast mob hydration decreases

#define REM 0.2 // Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick

#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3

#define MINIMUM_CHEMICAL_VOLUME 0.01

// states of matter
#define REAGENT_SOLID 1
#define REAGENT_LIQUID 2
#define REAGENT_GAS 3

#define REAGENTS_OVERDOSE 30

#define CHEM_SYNTH_ENERGY 500 // How much energy does it take to synthesize 1 unit of chemical, in Joules.

// Some on_mob_life() procs check for alien races.
#define IS_DIONA   1
#define IS_VOX     2
#define IS_SKRELL  3
#define IS_UNATHI  4
#define IS_TAJARA  5
#define IS_XENOS   6
#define IS_TESHARI 7
#define IS_SLIME   8
#define IS_ZADDAT  9
#define IS_CHIMERA 12
#define IS_SHADEKIN 13
#define IS_ALRAUNE 14
#define IS_APIDAEN 15
#define IS_XENOHYBRID 16

#define CE_STABLE           "stable"        // Inaprovaline
#define CE_ANTIBIOTIC       "antibiotic"    // Antibiotics
#define CE_BLOODRESTORE     "bloodrestore"  // Iron/nutriment
#define CE_PAINKILLER       "painkiller"
#define CE_ALCOHOL          "alcohol"       // Liver filtering
#define CE_ALCOHOL_TOXIC    "alcotoxic"     // Liver damage
#define CE_SPEEDBOOST       "gofast"        // Hyperzine
#define CE_SLOWDOWN         "goslow"        // Slowdown
#define CE_ANTACID          "nopuke"        // Don't puke.
#define CE_PULSE            "xcardic"       // increases or decreases heart rate
#define CE_NOPULSE          "heartstop"     // stops heartbeat
#define CE_ANTITOX          "antitox"       // Removes toxins
#define CE_OXYGENATED       "oxygen"        // Helps oxygenate the brain.
#define CE_BRAIN_REGEN      "brainfix"      // Allows the brain to recover after injury
#define CE_TOXIN            "toxins"        // Generic toxins, stops autoheal.
#define CE_BREATHLOSS       "breathloss"    // Breathing depression, makes you need more air
#define CE_MIND             "mindbending"   // Stabilizes or wrecks mind. Used for hallucinations
#define CE_CRYO             "cryogenic"     // Prevents damage from being frozen
#define CE_BLOCKAGE         "blockage"      // Gets in the way of blood circulation, higher the worse
#define CE_SQUEAKY          "squeaky"       // Helium voice. Squeak squeak.
#define CE_THIRDEYE         "thirdeye"      // Gives xray vision.
#define CE_SEDATE           "sedate"        // Applies sedation effects, i.e. paralysis, inability to use items, etc.
#define CE_ENERGETIC        "energetic"     // Speeds up stamina recovery.
#define	CE_VOICELOSS        "whispers"      // Lowers the subject's voice to a whisper
#define CE_GLOWINGEYES      "eyeglow"       // Causes eyes to glow.

#define CE_REGEN_BRUTE   "bruteheal"    // Causes brute damage to regenerate.
#define CE_REGEN_BURN    "burnheal"     // Causes burn damage to regenerate.

#define GET_CHEMICAL_EFFECT(X, C) (LAZYACCESS(X.chem_effects, C) || 0)

//reagent flags
#define IGNORE_MOB_SIZE BITFLAG(0)
#define AFFECTS_DEAD    BITFLAG(1)

#define HANDLE_REACTIONS(_reagents)  SSmaterials.active_holders[_reagents] = TRUE
#define UNQUEUE_REACTIONS(_reagents) SSmaterials.active_holders -= _reagents

#define REAGENT_LIST(R) (R.reagents?.get_reagents() || "No reagent holder")

#define REAGENTS_FREE_SPACE(R) (R?.maximum_volume - R?.total_volume)
#define REAGENT_VOLUME(REAGENT_HOLDER, REAGENT_TYPE) (REAGENT_HOLDER?.reagent_volumes && REAGENT_HOLDER.reagent_volumes[REAGENT_TYPE])
#define REAGENT_DATA(REAGENT_HOLDER, REAGENT_TYPE)   (REAGENT_HOLDER?.reagent_data    && REAGENT_HOLDER.reagent_data[REAGENT_TYPE])

#define MAT_SOLVENT_NONE     0
#define MAT_SOLVENT_MILD     1
#define MAT_SOLVENT_MODERATE 2
#define MAT_SOLVENT_STRONG   3

#define DIRTINESS_STERILE -2
#define DIRTINESS_CLEAN   -1
#define DIRTINESS_NEUTRAL  0

#define DEFAULT_GAS_ACCELERANT /decl/material/gas/hydrogen
#define DEFAULT_GAS_OXIDIZER   /decl/material/gas/oxygen


//Old stuff
#define REAGENTS_PER_SHEET 20

// Attached to CE_ANTIBIOTIC
#define ANTIBIO_NORM	1
#define ANTIBIO_OD		2
#define ANTIBIO_SUPER	3

// Chemistry lists.
var/list/tachycardics  = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine") // Increase heart rate.
var/list/bradycardics  = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")                 // Decrease heart rate.
var/list/heartstopper  = list("potassium_chlorophoride", "zombie_powder") // This stops the heart.
var/list/cheartstopper = list("potassium_chloride")                       // This stops the heart when overdose is met. -- c = conditional

#define MAX_PILL_SPRITE 24 //max icon state of the pill sprites
#define MAX_BOTTLE_SPRITE 4 //max icon state of the pill sprites
#define MAX_MULTI_AMOUNT 20 // Max number of pills/patches that can be made at once
#define MAX_UNITS_PER_PILL 60 // Max amount of units in a pill
#define MAX_UNITS_PER_PATCH 60 // Max amount of units in a patch
#define MAX_UNITS_PER_LOLLI 20 // Max amount of units in a lollipop.
#define MAX_UNITS_PER_AUTO 5 // Max amount of units in an autoinjector.
#define MAX_UNITS_PER_BOTTLE 60 // Max amount of units in a bottle (it's volume)
#define MAX_CUSTOM_NAME_LEN 64 // Max length of a custom pill/condiment/whatever

//reagents_holder_flags defines
#define INJECTABLE		(1<<0)	// Makes it possible to add reagents through droppers and syringes.
#define DRAWABLE		(1<<1)	// Makes it possible to remove reagents through syringes.

#define REFILLABLE		(1<<2)	// Makes it possible to add reagents through any reagent container.
#define DRAINABLE		(1<<3)	// Makes it possible to remove reagents through any reagent container.

#define TRANSPARENT		(1<<4)	// Used on containers which you want to be able to see the reagents off.
#define AMOUNT_VISIBLE	(1<<5)	// For non-transparent containers that still have the general amount of reagents in them visible.
#define NO_REACT        (1<<6)  // Applied to a reagent holder, the contents will not react with each other.
