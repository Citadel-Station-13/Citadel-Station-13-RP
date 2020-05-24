// Security levels.
#define SEC_LEVEL_GREEN 0
#define SEC_LEVEL_YELLOW  1
#define SEC_LEVEL_VIOLET  2
#define SEC_LEVEL_ORANGE  3
#define SEC_LEVEL_BLUE  4
#define SEC_LEVEL_RED   5
#define SEC_LEVEL_DELTA 6

#define BE_TRAITOR    (1<<0)
#define BE_OPERATIVE  (1<<1)
#define BE_CHANGELING (1<<2)
#define BE_WIZARD     (1<<3)
#define BE_MALF       (1<<4)
#define BE_REV        (1<<5)
#define BE_ALIEN      (1<<6)
#define BE_AI         (1<<7)
#define BE_CULTIST    (1<<8)
#define BE_RENEGADE   (1<<9)
#define BE_NINJA      (1<<10)
#define BE_RAIDER     (1<<11)
#define BE_PLANT      (1<<12)
#define BE_MUTINEER   (1<<13)
#define BE_PAI        (1<<14)
#define BE_LOYALIST   (1<<15)

var/list/be_special_flags = list(
	"Traitor"          = BE_TRAITOR,
	"Operative"        = BE_OPERATIVE,
	"Changeling"       = BE_CHANGELING,
	"Wizard"           = BE_WIZARD,
	"Malf AI"          = BE_MALF,
	"Revolutionary"    = BE_REV,
	"Loyalist"         = BE_LOYALIST,
	"Xenomorph"        = BE_ALIEN,
	"Positronic Brain" = BE_AI,
	"Cultist"          = BE_CULTIST,
	"Renegade"         = BE_RENEGADE,
	"Ninja"            = BE_NINJA,
	"Raider"           = BE_RAIDER,
	"Diona"            = BE_PLANT,
	"Mutineer"         = BE_MUTINEER,
	"pAI"              = BE_PAI
)


// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB		(1<<0) // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB		(1<<1) // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT	(1<<2) // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME		(1<<3) // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE	(1<<4) // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS		(1<<5) // Shows up on roundstart report.
#define ANTAG_HAS_LEADER		(1<<6) // Generates a leader antagonist.
#define ANTAG_HAS_NUKE			(1<<7) // Will spawn a nuke at supplied location.
#define ANTAG_RANDSPAWN			(1<<8) // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE			(1<<9) // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE	(1<<10) // Causes antagonists to use an appearance modifier on spawn.

// Mode/antag template macros.
#define MODE_BORER "borer"
#define MODE_XENOMORPH "xeno"
#define MODE_LOYALIST "loyalist"
#define MODE_MUTINEER "mutineer"
#define MODE_COMMANDO "commando"
#define MODE_DEATHSQUAD "deathsquad"
#define MODE_ERT "ert"
#define MODE_TRADE "trader"
#define MODE_MERCENARY "mercenary"
#define MODE_NINJA "ninja"
#define MODE_RAIDER "raider"
#define MODE_WIZARD "wizard"
#define MODE_TECHNOMANCER "technomancer"
#define MODE_CHANGELING "changeling"
#define MODE_CULTIST "cultist"
#define MODE_HIGHLANDER "highlander"
#define MODE_MONKEY "monkey"
#define MODE_RENEGADE "renegade"
#define MODE_REVOLUTIONARY "revolutionary"
#define MODE_LOYALIST "loyalist"
#define MODE_MALFUNCTION "malf"
#define MODE_TRAITOR "traitor"
#define MODE_AUTOTRAITOR "autotraitor"
#define MODE_INFILTRATOR "infiltrator"
#define MODE_THUG "thug"
#define MODE_STOWAWAY "stowaway"

#define DEFAULT_TELECRYSTAL_AMOUNT 120

/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		(1<<0) // can a ghost cast it?
#define NEEDSCLOTHES	(1<<1) // does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		(1<<2) // does it require the caster to be human?
#define Z2NOCAST		(1<<3) // if this is added, the spell can't be cast at CentCom
#define STATALLOWED		(1<<4) // if set, the user doesn't have to be conscious to cast. Required for ghost spells
#define IGNOREPREV		(1<<5) // if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		(1<<6) // does the spell include the caster in its target selection?
#define SELECTABLE		(1<<7) // can you select each target for the spell?
//AOE spells
#define IGNOREDENSE		(1<<6) // are dense turfs ignored in selection?
#define IGNORESPACE		(1<<7) // are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	(1<<8) // used by construct spells - checks for nullrods
#define NO_BUTTON		(1<<9) // spell won't show up in the HUD with this

//invocation
#define SpI_SHOUT	"shout"
#define SpI_WHISPER	"whisper"
#define SpI_EMOTE	"emote"
#define SpI_NONE	"none"

//upgrading
#define Sp_SPEED	"speed"
#define Sp_POWER	"power"
#define Sp_TOTAL	"total"

//casting costs
#define Sp_RECHARGE	"recharge"
#define Sp_CHARGES	"charges"
#define Sp_HOLDVAR	"holdervar"

#define CHANGELING_STASIS_COST 20