//! *ALL DEFINES RELATED TO ORGANS GO HERE* !//

//These control the damage thresholds for the various ways of removing limbs
#define DROPLIMB_THRESHOLD_EDGE 5
#define DROPLIMB_THRESHOLD_TEAROFF 2
#define DROPLIMB_THRESHOLD_DESTROY 1


/// Global list of organs for future use.
#define O_ALL (O_ALL_STANDARD + O_ALL_NONSTANDARD)
/// Global list of all standard body parts.
///TODO: Currently used for random limb dmg, needs a refactor to make it species-based instead.
#define BP_ALL BP_ALL_STANDARD
//* GENERIC INTERNAL ORGANS *//
#define O_APPENDIX "appendix"
#define O_BRAIN "brain"
#define O_EYES "eyes"
#define O_HEART "heart"
#define O_INTESTINE "intestine"
#define O_KIDNEYS "kidneys"
#define O_LIVER "liver"
#define O_LUNGS "lungs"
#define O_SPLEEN "spleen"
#define O_STOMACH "stomach"
#define O_VOICE "voicebox"
///List of all standard organs.
#define O_ALL_STANDARD list( \
		O_EYES, \
		O_HEART, \
		O_LUNGS, \
		O_BRAIN, \
		O_LIVER, \
		O_KIDNEYS, \
		O_SPLEEN, \
		O_APPENDIX, \
		O_VOICE, \
		O_STOMACH, \
		O_INTESTINE)


//* AUGMENTS *//
#define O_AUG_EYES "occular augment"
#define O_AUG_L_FOREARM "left forearm augment"
#define O_AUG_L_HAND "left hand augment"
#define O_AUG_L_UPPERARM "left upperarm augment"
#define O_AUG_PELVIC "pelvic augment"
#define O_AUG_R_FOREARM "right forearm augment"
#define O_AUG_R_HAND "right hand augment"
#define O_AUG_R_UPPERARM "right upperarm augment"
#define O_AUG_RIBS "rib augment"
#define O_AUG_SPINE "spinal augment"
/// List of all Augment organs.
#define O_ALL_AUGMENTS list( \
		O_AUG_EYES, \
		O_AUG_L_FOREARM, \
		O_AUG_L_HAND, \
		O_AUG_L_UPPERARM, \
		O_AUG_PELVIC, \
		O_AUG_R_FOREARM, \
		O_AUG_R_HAND, \
		O_AUG_R_UPPERARM, \
		O_AUG_RIBS, \
		O_AUG_SPINE)


//* NON-STANDARD ORGANS *//
#define O_ACID "acid gland"
#define O_ANCHOR "anchoring ligament"
#define O_AREJECT "immune hub"
#define O_CELL "cell"
#define O_EGG "egg sac"
#define O_GBLADDER "gas bladder"
#define O_HIVE "hive node"
#define O_MOUTH "mouth"
#define O_NUTRIENT "nutrient vessel"
#define O_PLASMA "plasma vessel"
#define O_POLYP "polyp segment"
#define O_REGBRUTE "pneumoregenitor"
#define O_REGBURN "thermoregenitor"
#define O_REGOXY "respiroregenitor"
#define O_REGTOX "toxoregenitor"
#define O_RESIN "resin spinner"
#define O_RESPONSE "response node"
#define O_STRATA "neural strata"
#define O_VENTC "morphoplastic node"
#define O_VRLINK "virtual node"
#define O_ORCH "orchestrator"
#define O_FACT "refactory"
#define O_FRUIT "fruit gland"
#define O_HONEYSTOMACH "honey stomach"
/// List of all non-standard organs.
#define O_ALL_NONSTANDARD list( \
		O_ACID, \
		O_ANCHOR, \
		O_AREJECT, \
		O_CELL, \
		O_EGG, \
		O_FACT, \
		O_GBLADDER, \
		O_HIVE, \
		O_HONEYSTOMACH, \
		O_MOUTH, \
		O_NUTRIENT, \
		O_ORCH, \
		O_PLASMA, \
		O_POLYP, \
		O_REGBRUTE, \
		O_REGBURN, \
		O_REGOXY, \
		O_REGTOX, \
		O_RESIN, \
		O_RESPONSE, \
		O_STRATA, \
		O_VENTC, \
		O_VRLINK)


//* FBP ORGANS *//
#define O_CYCLER "reagent cycler"
#define O_DIAGNOSTIC "diagnostic controller"
#define O_HEATSINK "thermal regulator"
#define O_PUMP "hydraulic hub"
/// List of all FBP Organs.
#define O_ALL_FBP list( \
		O_CYCLER, \
		O_DIAGNOSTIC, \
		O_HEATSINK, \
		O_PUMP)


//* GENERIC EXTERAL ORGANS *//
// Also used as target zones.
#define BP_GROIN  "groin"
#define BP_HEAD   "head"
#define BP_L_ARM  "l_arm"
#define BP_L_FOOT "l_foot"
#define BP_L_HAND "l_hand"
#define BP_L_LEG  "l_leg"
#define BP_R_ARM  "r_arm"
#define BP_R_FOOT "r_foot"
#define BP_R_HAND "r_hand"
#define BP_R_LEG  "r_leg"
#define BP_TORSO  "torso"
/// List of all standard body parts.
#define BP_ALL_STANDARD list( \
		BP_GROIN, \
		BP_HEAD, \
		BP_L_ARM, \
		BP_L_FOOT, \
		BP_L_HAND, \
		BP_L_LEG, \
		BP_R_ARM, \
		BP_R_FOOT, \
		BP_R_HAND, \
		BP_R_LEG, \
		BP_TORSO)


//* ADHERENT EXTERNAL ORGANS *//
#define O_COOLING_FINS "cooling fins"
#define O_FLOAT "floatation disc"
#define O_JETS "maneuvering jets"
/// List of all Adherent body parts.
#define O_ALL_ADHERENT list( \
		O_COOLING_FINS, \
		O_FLOAT, \
		O_JETS)


//* SYNTH INTERNAL COLORS *//
#define SYNTH_BLOOD_COLOUR "#030303"
#define SYNTH_FLESH_COLOUR "#575757"


//* FBP BRAIN TYPES *//
#define FBP_NONE ""
#define FBP_CYBORG "Cyborg"
#define FBP_POSI "Positronic"
#define FBP_DRONE "Drone"

// Similar to above but for borgs.
// Seperate defines are unfortunately required since borgs display the brain differently for some reason.
//* BORG BRAIN TYPES *//
#define BORG_BRAINTYPE_CYBORG "Cyborg"
#define BORG_BRAINTYPE_POSI "Robot"
#define BORG_BRAINTYPE_DRONE "Drone"
#define BORG_BRAINTYPE_AI_SHELL "AI Shell"


//* CARBON TASTE SENSITIVITY *// Used in mob/living/carbon/proc/ingest
///anything below 5%
#define TASTE_HYPERSENSITIVE 3
///anything below 7%
#define TASTE_SENSITIVE 2
///anything below 15%
#define TASTE_NORMAL 1
///anything below 30%
#define TASTE_DULL 0.5
///anything below 150%
#define TASTE_NUMB 0.1
//* ORGAN FLAGS *//
#define BP_IS_ASSISTED(org) ((org) && ((org).robotic == ORGAN_ASSISTED))
#define BP_IS_BRITTLE(org)  ((org) && ((org).status == ORGAN_BRITTLE))
#define BP_IS_CRYSTAL(org)  ((org) && ((org).robotic == ORGAN_CRYSTAL))
#define BP_IS_ROBOTIC(org)  ((org) && ((org).robotic == ORGAN_ROBOT))

//! organ locality
/// organ is in a living mob
#define ORGAN_LOCALITY_IN_LIVING_MOB			0
/// organ is in a dead mob
#define ORGAN_LOCALITY_IN_DEAD_MOB				1
/// organ is outside of a mob
#define ORGAN_LOCALITY_REMOVED					2
