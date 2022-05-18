/*ALL DEFINES FOR AIS, CYBORGS, AND BOTS*/

//Mode defines. If you add a new one make sure you update mode_name in /mob/living/simple_animal/bot
/*
/// idle
#define BOT_IDLE          0
/// found target, hunting
#define BOT_HUNT          1
/// at target, preparing to arrest
#define BOT_PREP_ARREST   2
/// arresting target
#define BOT_ARREST        3
/// start patrol
#define BOT_START_PATROL  4
/// patrolling
#define BOT_PATROL        5
/// summoned by PDA
#define BOT_SUMMON        6
/// cleaning (cleanbots)
#define BOT_CLEANING      7
/// repairing hull breaches (floorbots)
#define BOT_REPAIRING     8
/// for clean/floor/med bots, when moving.
#define BOT_MOVING        9
/// healing people (medibots)
#define BOT_HEALING      10
/// responding to a call from the AI
#define BOT_RESPONDING   11
/// moving to deliver
#define BOT_DELIVER      12
/// returning to home
#define BOT_GO_HOME      13
/// blocked
#define BOT_BLOCKED      14
/// computing navigation
#define BOT_NAV          15
/// waiting for nav computation
#define BOT_WAIT_FOR_NAV 16
/// no destination beacon found (or no route)
#define BOT_NO_ROUTE     17
/// cleaning unhygienic humans
#define BOT_SHOWERSTANCE 18
/// someone tipped a medibot over ;_;
#define BOT_TIPPED       19
*/
//Bot types
/// Secutritrons (Beepsky) and ED-209s
#define SEC_BOT     (1<<0)
/// MULEbots
#define MULE_BOT    (1<<1)
/// Floorbots
#define FLOOR_BOT   (1<<2)
/// Cleanbots
#define CLEAN_BOT   (1<<3)
/// Medibots
#define MED_BOT     (1<<4)
/// Honkbots & ED-Honks
#define HONK_BOT    (1<<5)
/// Firebots
#define FIRE_BOT    (1<<6)
/// Hygienebots
#define HYGIENE_BOT (1<<7)
/*
//AI notification defines
#define NEW_BORG   1
#define NEW_MODULE 2
#define RENAME     3
#define AI_SHELL   4
#define DISCONNECT 5
*/
//Assembly defines
#define ASSEMBLY_FIRST_STEP  0
#define ASSEMBLY_SECOND_STEP 1
#define ASSEMBLY_THIRD_STEP  2
#define ASSEMBLY_FOURTH_STEP 3
#define ASSEMBLY_FIFTH_STEP  4
/*
//Bot Upgrade defines
#define UPGRADE_CLEANER_ADVANCED_MOP    (1<<0)
#define UPGRADE_CLEANER_BROOM           (1<<1)

#define UPGRADE_MEDICAL_HYPOSPRAY       (1<<0)
#define UPGRADE_MEDICAL_CHEM_BOARD      (1<<1)
#define UPGRADE_MEDICAL_CRYO_BOARD      (1<<2)
#define UPGRADE_MEDICAL_CHEM_MASTER     (1<<3)
#define UPGRADE_MEDICAL_SLEEP_BOARD     (1<<4)
#define UPGRADE_MEDICAL_PIERERCING      (1<<5)

#define UPGRADE_FLOOR_ARTBOX 	     (1<<0)
#define UPGRADE_FLOOR_SYNDIBOX     	 (1<<1)

//Checks to determine borg availability depending on the server's config. These are defines in the interest of reducing copypasta
#define BORG_SEC_AVAILABLE (!CONFIG_GET(flag/disable_secborg) && GLOB.security_level >= CONFIG_GET(number/minimum_secborg_alert))

//silicon_priviledges flags
#define PRIVILEGES_SILICON	(1<<0)
#define PRIVILEGES_PAI		(1<<1)
#define PRIVILEGES_BOT		(1<<2)
#define PRIVILEGES_DRONE	(1<<3)

///special value to reset cyborg's lamp_cooldown
#define BORG_LAMP_CD_RESET -1
/// Defines for whether or not module slots are broken.
#define BORG_MODULE_ALL_DISABLED (1<<0)
#define BORG_MODULE_TWO_DISABLED (1<<1)
#define BORG_MODULE_THREE_DISABLED (1<<2)
*/
