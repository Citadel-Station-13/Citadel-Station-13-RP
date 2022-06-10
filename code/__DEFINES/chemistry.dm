/// Factor of how fast mob nutrition decreases
#define DEFAULT_HUNGER_FACTOR 0.03
/// Factor of how fast mob hydration decreases
#define DEFAULT_THIRST_FACTOR 0.03
/// Means 'Reagent Effect Multiplier'. This is how many units of reagent are consumed per tick
#define REM 0.2
#define CHEM_TOUCH 1
#define CHEM_INGEST 2
#define CHEM_BLOOD 3

#define MINIMUM_CHEMICAL_VOLUME 0.01

// states of matter
#define REAGENT_SOLID 1
#define REAGENT_LIQUID 2
#define REAGENT_GAS 3

#define REAGENTS_OVERDOSE 30

/// How much energy does it take to synthesize 1 unit of chemical, in Joules.
#define CHEM_SYNTH_ENERGY 500
// Some on_mob_life() procs check for alien races.
// TODO: better way? flags? we won't possibly need more than 24 right...?
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
#define IS_MOTH		17

/// Inaprovaline
#define CE_STABLE "stable"
/// Antibiotics
#define CE_ANTIBIOTIC "antibiotic"
/// Iron/nutriment
#define CE_BLOODRESTORE "bloodrestore"
#define CE_PAINKILLER "painkiller"
/// Liver filtering
#define CE_ALCOHOL "alcohol"
/// Liver damage
#define CE_ALCOHOL_TOXIC "alcotoxic"
/// Hyperzine
#define CE_SPEEDBOOST "gofast"
/// Slowdown
#define CE_SLOWDOWN "goslow"
/// Don't puke.
#define CE_ANTACID "nopuke"
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

///Max icon state of the pill sprites
#define MAX_PILL_SPRITE 24
///Max icon state of the pill sprites
#define MAX_BOTTLE_SPRITE 4
///Max number of pills/patches that can be made at once
#define MAX_MULTI_AMOUNT 20
///Max amount of units in a pill
#define MAX_UNITS_PER_PILL 60
///Max amount of units in a patch
#define MAX_UNITS_PER_PATCH 60
///Max amount of units in a lollipop.
#define MAX_UNITS_PER_LOLLI 20
///Max amount of units in an autoinjector.
#define MAX_UNITS_PER_AUTO 5
///Max amount of units in a bottle (it's volume)
#define MAX_UNITS_PER_BOTTLE 60
///Max length of a custom pill/condiment/whatever
#define MAX_CUSTOM_NAME_LEN 64

///Syringe
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

//reagents_holder_flags defines
///Makes it possible to add reagents through droppers and syringes.
#define INJECTABLE (1<<0)
///Makes it possible to remove reagents through syringes.
#define DRAWABLE (1<<1)

///Makes it possible to add reagents through any reagent container.
#define REFILLABLE (1<<2)
///Makes it possible to remove reagents through any reagent container.
#define DRAINABLE (1<<3)

///Used on containers which you want to be able to see the reagents off.
#define TRANSPARENT (1<<4)
///For non-transparent containers that still have the general amount of reagents in them visible.
#define AMOUNT_VISIBLE (1<<5)
///Applied to a reagent holder, the contents will not react with each other.
#define NO_REACT (1<<6)
