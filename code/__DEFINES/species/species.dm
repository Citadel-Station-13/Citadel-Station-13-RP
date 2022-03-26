// Species Flags.
#define NO_MINOR_CUT      		(1 << 0) // Can step on broken glass with no ill-effects. Either thick skin (diona), cut resistant (slimes) or incorporeal (shadows)
#define IS_PLANT          		(1 << 1) // Is a treeperson.
#define NO_SCAN           		(1 << 2) // Cannot be scanned in a DNA machine/genome-stolen.
#define NO_PAIN           		(1 << 3) // Cannot suffer halloss/recieves deceptive health indicator.
#define NO_SLIP           		(1 << 4) // Cannot fall over.
#define NO_POISON         		(1 << 5) // Cannot not suffer toxloss.
#define NO_EMBED		  		(1 << 6) // Can step on broken glass with no ill-effects and cannot have shrapnel embedded in it.
#define NO_HALLUCINATION  		(1 << 7) // Don't hallucinate, ever
#define NO_BLOOD		  		(1 << 8) // Never bleed, never show blood amount
#define UNDEAD			  		(1 << 9) // Various things that living things don't do, mostly for skeletons
#define NO_INFECT		  		(1 << 10) // Don't allow infections in limbs or organs, similar to IS_PLANT, without other strings.
#define NO_DEFIB          		(1 << 11) // Cannot be defibbed
#define CONTAMINATION_IMMUNE 	(1 << 12) //(Phoron) Contamination doesnt affect them.
// unused: 0x8000 - higher than this will overflow

// Species spawn flags
#define SPECIES_IS_WHITELISTED    	 (1 << 0) // Must be whitelisted to play.
#define SPECIES_IS_RESTRICTED     	 (1 << 1) // Is not a core/normally playable species. (castes, mutantraces)
#define SPECIES_CAN_JOIN          	 (1 << 2) // Species is selectable in chargen.
#define SPECIES_NO_FBP_CONSTRUCTION  (1 << 3) // FBP of this species can't be made in-game.
#define SPECIES_NO_FBP_CHARGEN       (1 << 4) // FBP of this species can't be selected at chargen.
#define SPECIES_WHITELIST_SELECTABLE (1 << 5) // Can select and customize, but not join as

// Species appearance flags
#define HAS_SKIN_TONE     (1 << 0) // Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_COLOR    (1 << 1) // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          (1 << 2) // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     (1 << 3) // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR     (1 << 4) // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR    (1 << 5) // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS   (1 << 6) // Radiation causes this character to glow.
#define BASE_SKIN_COLOR   (1 << 7) // Sets default skin colors based on icons.

#define SKIN_NORMAL (1 << 0)
#define SKIN_THREAT (1 << 1)
#define SKIN_CLOAK  (1 << 2)


/// Actual Species IDs


// 'Regular' species.
#define SPECIES_HUMAN			"Human"
#define SPECIES_HUMAN_VATBORN	"Vatborn"
#define SPECIES_UNATHI			"Unathi"
#define SPECIES_SKRELL			"Skrell"
#define SPECIES_TESHARI			"Teshari"
#define SPECIES_TAJ				"Tajara"
#define SPECIES_PROMETHEAN		"Promethean"
#define SPECIES_DIONA			"Diona"
#define SPECIES_VOX				"Vox"
#define SPECIES_ZADDAT			"Zaddat"
#define SPECIES_ADHERENT		"Adherent"

// Monkey and alien monkeys.
#define SPECIES_MONKEY			"Monkey"
#define SPECIES_MONKEY_TAJ		"Farwa"
#define SPECIES_MONKEY_SKRELL	"Neaera"
#define SPECIES_MONKEY_UNATHI	"Stok"

// Virtual Reality IDs.
#define SPECIES_VR				"Virtual Reality Avatar"
#define SPECIES_VR_HUMAN		"Virtual Reality Human"
#define SPECIES_VR_UNATHI		"Virtual Reality Unathi"
#define SPECIES_VR_TAJ			"Virtual Reality Tajara" // NO CHANGING.
#define SPECIES_VR_SKRELL		"Virtual Reality Skrell"
#define SPECIES_VR_TESHARI		"Virtual Reality Teshari"
#define SPECIES_VR_DIONA		"Virtual Reality Diona"
#define SPECIES_VR_MONKEY		"Virtual Reality Monkey"
#define SPECIES_VR_SKELETON		"Virtual Reality Skeleton"
#define SPECIES_VR_VOX			"Virtual Reality Vox"

// Ayyy IDs.
#define SPECIES_XENO			"Xenomorph"
#define SPECIES_XENO_DRONE		"Xenomorph Drone"
#define SPECIES_XENO_HUNTER		"Xenomorph Hunter"
#define SPECIES_XENO_SENTINEL	"Xenomorph Sentinel"
#define SPECIES_XENO_QUEEN		"Xenomorph Queen"

// Misc species. Mostly unused but might as well be complete.
#define SPECIES_SHADOW			"Shadow"
#define SPECIES_SKELETON		"Skeleton"
#define SPECIES_GOLEM			"Golem"
#define SPECIES_EVENT1			"X Occursus"
#define SPECIES_EVENT2			"X Anomalous"
#define SPECIES_EVENT3			"X Unowas"

// Replicant types. Currently only used for alien pods and events.
#define SPECIES_REPLICANT		"Replicant"
#define SPECIES_REPLICANT_ALPHA	"Alpha Replicant"
#define SPECIES_REPLICANT_BETA	"Beta Replicant"


//Virgo Species
#define SPECIES_AKULA			"Akula"
#define SPECIES_ALRAUNE			"Alraune"
#define SPECIES_NEVREAN			"Nevrean"
#define SPECIES_PROTEAN			"Protean"
#define SPECIES_RAPALA			"Rapala"
#define SPECIES_SERGAL			"Sergal"
#define SPECIES_SHADEKIN_CREW   "Black-Eyed Shadekin"
#define SPECIES_VASILISSAN		"Vasilissan"
#define SPECIES_VULPKANIN		"Vulpkanin"
#define SPECIES_XENOCHIMERA		"Xenochimera"
#define SPECIES_XENOHYBRID		"Xenomorph Hybrid"
#define SPECIES_ZORREN_FLAT		"Flatland Zorren"
#define SPECIES_ZORREN_HIGH		"Highlander Zorren"
#define SPECIES_CUSTOM			"Custom Species"
#define SPECIES_PLASMAMAN		"Phoronoid"
#define SPECIES_APIDAEN			"Apidaen"
#define SPECIES_VETALA_RUDDY	"Ruddy Vetalan"
#define SPECIES_VETALA_PALE		"Pale Vetalan"
#define SPECIES_AURIL			"Auril"
#define SPECIES_DREMACHIR		"Dremachir"

//monkey species
#define SPECIES_MONKEY_AKULA		"Sobaka"
#define SPECIES_MONKEY_NEVREAN		"Sparra"
#define SPECIES_MONKEY_SERGAL		"Saru"
#define SPECIES_MONKEY_VULPKANIN	"Wolpin"

//event species
#define SPECIES_WEREBEAST			"Werebeast"
#define SPECIES_SHADEKIN			"Shadekin"
