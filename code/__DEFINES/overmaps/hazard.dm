// hazard scales WARNING WARNING THIS IS LOGARITHMIC -10 IS 10 MILLION TIMES WEAKER AND VICE VERSA
/// min severity - below this expect nothing to happen
#define OVERMAP_HAZARD_SCALE_MIN				-10
/// default severity - used as a baseline
#define OVERMAP_HAZARD_SCALE_DEFAULT			0
/// max severity - above this expect awful things to happen
#define OVERMAP_HAZARD_SCALE_MAX				10

// hazard ids
/// dust
#define OVERMAP_HAZARD_ID_DUST					"dust"
/// meteors
#define OVERMAP_HAZARD_ID_METEORS				"meteors"
/// ion storm
#define OVERMAP_HAZARD_ID_ION_STORM				"ion_storm"
/// electrical storm
#define OVERMAP_HAZARD_ID_ELECTRICAL_STORM		"electrical_storm"
/// mobs: carp
#define OVERMAP_HAZARD_ID_MOB_CARP				"mob_carp"
/// mobs: cult
#define OVERMAP_HAZARD_ID_MOB_CULT				"mob_cult"
/// mobs: pirates
#define OVERMAP_HAZARD_ID_MOB_PIRATES			"mob_pirates"
/// mobs: rats
#define OVERMAP_HAZARD_ID_MOB_RATS				"mob_rats"
