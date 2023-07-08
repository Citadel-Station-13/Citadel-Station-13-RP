// Bitflags defining which status effects could be or are inflicted on a mob.
#define STATUS_CAN_STUN      (1<<0) //! Can Stun()
#define STATUS_CAN_KNOCKDOWN (1<<1) //! Can Knockdown()
#define STATUS_CAN_ROOT      (1<<2) //! Can Root()
#define STATUS_CAN_STAGGER   (1<<3) //! Can Stagger()
#define STATUS_CAN_PARALYZE  (1<<4) //! Can Paralyze()
#define STATUS_CAN_PUSH      (1<<5) //! Can Push()

#define STATUS_LEAPING       (1<<20) //! Is leaping (??? legacy)
#define STATUS_HIDING        (1<<21) //! Is hiding  (??? legacy)
#define STATUS_GODMODE       (1<<22) //! Godmode    (??? legacy)
#define STATUS_FAKEDEATH     (1<<23) //! In fakedeath - SLATED FOR REMOVAL, THIS SHOULD BE TRAIT

#define STATUS_FLAGS_DEFAULT (STATUS_CAN_STUN | STATUS_CAN_PARALYZE | STATUS_CAN_PUSH \
| STATUS_CAN_KNOCKDOWN | STATUS_CAN_ROOT | STATUS_CAN_STAGGER)

#define BORGMESON 0x1
#define BORGTHERM 0x2
#define BORGXRAY  0x4
#define BORGMATERIAL  0x8

/// Backwards compatability
#define STANCE_ATTACK    11
/// Ditto
#define STANCE_ATTACKING 12
/*
/// Looking for targets if hostile.  Does idle wandering.
#define STANCE_IDLE      1
/// Bears
#define STANCE_ALERT     2
/// Attempting to get into attack position
#define STANCE_ATTACK    3
/// Doing attacks
#define STANCE_ATTACKING 4
/// Bears
#define STANCE_TIRED     5
/// Following somone
#define STANCE_FOLLOW    6
/// Do nothing on life ticks (Other code is running)
#define STANCE_BUSY      7
*/
/// Doing (almost) nothing, to save on CPU because nobody is around to notice or the mob died.
#define STANCE_SLEEP        0
/// The more or less default state. Wanders around, looks for baddies, and spouts one-liners.
#define STANCE_IDLE         1
/// A baddie is visible but not too close, and essentially we tell them to go away or die.
#define STANCE_ALERT        2
/// Attempting to get into range to attack them.
#define STANCE_APPROACH     3
/// Actually fighting, with melee or ranged.
#define STANCE_FIGHT	    4
/// Fighting something that cannot be seen by the mob, from invisibility or out of sight.
#define STANCE_BLINDFIGHT   5
/// Relocating to a better position while in combat. Also used when moving away from a danger like grenades.
#define STANCE_REPOSITION   6
/// Similar to above but for out of combat. If a baddie is seen, they'll cancel and fight them.
#define STANCE_MOVE         7
/// Following somone, without trying to murder them.
#define STANCE_FOLLOW       8
/// Run away from the target because they're too spooky/we're dying/some other reason.
#define STANCE_FLEE         9
/// Used when the holder is afflicted with certain status effects, such as stuns or confusion.
#define STANCE_DISABLED     10
#define STANCES_COMBAT      list(STANCE_ALERT, STANCE_APPROACH, STANCE_FIGHT, STANCE_BLINDFIGHT, STANCE_REPOSITION)

#define LEFT  0x1
#define RIGHT 0x2
#define UNDER 0x4

// Pulse levels, very simplified.
/// So !M.pulse checks would be possible.
#define PULSE_NONE    0
/// <60     bpm
#define PULSE_SLOW    1
///  60-90  bpm
#define PULSE_NORM    2
///  90-120 bpm
#define PULSE_FAST    3
/// >120    bpm
#define PULSE_2FAST   4
/// Occurs during hypovolemic shock
#define PULSE_THREADY 5
/// Less accurate. (hand)
#define GETPULSE_HAND 0
/// More accurate. (med scanner, sleeper, etc.)
#define GETPULSE_TOOL 1
//These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
#define HUMAN 1
#define MONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

// Robot AI notifications
#define ROBOT_NOTIFICATION_NEW_UNIT 1
#define ROBOT_NOTIFICATION_NEW_NAME 2
#define ROBOT_NOTIFICATION_NEW_MODULE 3
#define ROBOT_NOTIFICATION_MODULE_RESET 4
#define ROBOT_NOTIFICATION_AI_SHELL 5

// Appearance change flags
#define APPEARANCE_UPDATE_DNA  0x1
#define APPEARANCE_RACE       (0x2|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_GENDER     (0x4|APPEARANCE_UPDATE_DNA)
#define APPEARANCE_SKIN        0x8
#define APPEARANCE_HAIR        0x10
#define APPEARANCE_HAIR_COLOR  0x20
#define APPEARANCE_FACIAL_HAIR 0x40
#define APPEARANCE_FACIAL_HAIR_COLOR 0x80
#define APPEARANCE_EYE_COLOR 0x100
#define APPEARANCE_ALL_HAIR (APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR)
#define APPEARANCE_ALL       0xFFFF

// Click cooldown
///Default timeout for aggressive actions
#define DEFAULT_ATTACK_COOLDOWN 8
#define DEFAULT_QUICK_COOLDOWN  4
#define DEFAULT_PULL_COODDOWN	2

#define MIN_SUPPLIED_LAW_NUMBER 15
#define MAX_SUPPLIED_LAW_NUMBER 50

//default item on-mob icons
#define INV_ACCESSORIES_DEF_ICON 'icons/mob/clothing/ties.dmi'

// Character's economic class
#define CLASS_UPPER  "Well-Off"
#define CLASS_MIDDLE  "Average"
#define CLASS_LOWMID "Underpaid"
#define CLASS_LOWISH "Poor"
#define CLASS_LOW  "Impoverished"

#define ECONOMIC_CLASS list(CLASS_UPPER,CLASS_MIDDLE,CLASS_LOWMID,CLASS_LOWISH,CLASS_LOW)

// Defines mob sizes, used by lockers and to determine what is considered a small sized mob, etc.
#define MOB_HUGE  		40
#define MOB_LARGE		30
#define MOB_MEDIUM 		20
#define MOB_SMALL 		10
#define MOB_TINY 		5
#define MOB_MINISCULE	1

#define TINT_NONE 0
#define TINT_MODERATE 1
#define TINT_HEAVY 2
#define TINT_BLIND 3

#define FLASH_PROTECTION_VULNERABLE -2
#define FLASH_PROTECTION_REDUCED -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_MODERATE 1
#define FLASH_PROTECTION_MAJOR 2

#define ANIMAL_SPAWN_DELAY round(config_legacy.respawn_delay / 6)
#define DRONE_SPAWN_DELAY  round(config_legacy.respawn_delay / 3)

// Incapacitation flags, used by the mob/proc/incapacitated() proc
#define INCAPACITATION_RESTRAINED 1
#define INCAPACITATION_BUCKLED_PARTIALLY 2
#define INCAPACITATION_BUCKLED_FULLY 4
#define INCAPACITATION_STUNNED 8
///needs a better name - represents being knocked down BUT still conscious.
#define INCAPACITATION_FORCELYING 16
#define INCAPACITATION_KNOCKOUT 32
#define INCAPACITATION_NONE 0

#define INCAPACITATION_DEFAULT (INCAPACITATION_RESTRAINED|INCAPACITATION_BUCKLED_FULLY)
#define INCAPACITATION_KNOCKDOWN (INCAPACITATION_KNOCKOUT|INCAPACITATION_FORCELYING)
#define INCAPACITATION_DISABLED (INCAPACITATION_KNOCKDOWN|INCAPACITATION_STUNNED)
#define INCAPACITATION_ALL (~INCAPACITATION_NONE)

/// Disallows stacking entirely.
#define MODIFIER_STACK_FORBID	1
/// Disallows a second instance, but will extend the first instance if possible.
#define MODIFIER_STACK_EXTEND	2
/// Multiple instances are allowed.
#define MODIFIER_STACK_ALLOWED	3

/// Modifiers with this flag will be copied to mobs who get cloned.
#define MODIFIER_GENETIC	1

#define MOB_PULL_NONE 0
#define MOB_PULL_SMALLER 1
#define MOB_PULL_SAME 2
#define MOB_PULL_LARGER 3

//XENOBIO2 FLAGS
#define NOMUT		0
#define COLORMUT 	1
#define SPECIESMUT	2

// Used to seperate simple animals by ""intelligence"".
#define SA_PLANT	1
#define SA_ANIMAL	2
#define SA_ROBOTIC	3
#define SA_HUMANOID	4

// More refined version of SA_* ""intelligence"" seperators.
// Now includes bitflags, so to target two classes you just do 'MOB_CLASS_ANIMAL|MOB_CLASS_HUMANOID'
/// Default value, and used to invert for _ALL.
#define MOB_CLASS_NONE 			NONE
/// Unused at the moment.
#define MOB_CLASS_PLANT			(1<<0)
/// Animals and beasts like spiders, saviks, and bears.
#define MOB_CLASS_ANIMAL		(1<<1)
/// Non-robotic humanoids, including /simple_mob and /carbon/humans and their alien variants.
#define MOB_CLASS_HUMANOID		(1<<2)
/// Silicons, mechanical simple mobs, FBPs, and anything else that would pass is_synthetic()
#define MOB_CLASS_SYNTHETIC		(1<<3)
/// Everyone's favorite xenobiology specimen (and maybe prometheans?).
#define MOB_CLASS_SLIME			(1<<4)
/// Weird shit.
#define MOB_CLASS_ABERRATION	(1<<5)
/// Cult stuff.
#define MOB_CLASS_DEMONIC		(1<<6)
/// Future megafauna hopefully someday.
#define MOB_CLASS_BOSS			(1<<7)
/// Fake mobs, e.g. Technomancer illusions.
#define MOB_CLASS_ILLUSION		(1<<8)
/// Holographic mobs like holocarp, similar to _ILLUSION, but that make no attempt to hide their true nature.
#define MOB_CLASS_PHOTONIC		(1<<9)
#define MOB_CLASS_ALL			(~MOB_CLASS_NONE)

// For slime commanding.  Higher numbers allow for more actions.
/// When disciplined.
#define SLIME_COMMAND_OBEY		1
/// When in the same 'faction'.
#define SLIME_COMMAND_FACTION	2
/// When befriended with a slime friendship agent.
#define SLIME_COMMAND_FRIEND	3
// Threshold for mobs being able to damage things like airlocks or reinforced glass windows.
// If the damage is below this, nothing will happen besides a message saying that the attack was ineffective.
// Generally, this was not a define but was commonly set to 10, however 10 may be too low now since simple_mobs now attack twice as fast,
// at half damage compared to the old mob system, meaning mobs who could hurt structures may not be able to now, so now it is 5.
#define STRUCTURE_MIN_DAMAGE_THRESHOLD 5

// Clothing flags, organized in roughly top-bottom
#define EXAMINE_SKIPHELMET			0x0001
#define EXAMINE_SKIPEARS			0x0002
#define EXAMINE_SKIPEYEWEAR			0x0004
#define EXAMINE_SKIPMASK			0x0008
#define EXAMINE_SKIPJUMPSUIT		0x0010
#define EXAMINE_SKIPTIE				0x0020
#define EXAMINE_SKIPHOLSTER			0x0040
#define EXAMINE_SKIPSUITSTORAGE		0x0080
#define EXAMINE_SKIPBACKPACK		0x0100
#define EXAMINE_SKIPGLOVES			0x0200
#define EXAMINE_SKIPBELT			0x0400
#define EXAMINE_SKIPSHOES			0x0800

// Body flags
#define EXAMINE_SKIPHEAD			0x0001
#define EXAMINE_SKIPEYES			0x0002
#define EXAMINE_SKIPFACE			0x0004
#define EXAMINE_SKIPBODY			0x0008
#define EXAMINE_SKIPGROIN			0x0010
#define EXAMINE_SKIPARMS			0x0020
#define EXAMINE_SKIPHANDS			0x0040
#define EXAMINE_SKIPLEGS			0x0080
#define EXAMINE_SKIPFEET			0x0100

/// How far away you can be to make eye contact with someone while examining
#define EYE_CONTACT_RANGE 5

/// If you examine the same atom twice in this timeframe, we call examine_more() instead of examine()
#define EXAMINE_MORE_TIME 1 SECONDS

#define SLEEP_CHECK_DEATH(X) sleep(X); if(QDELETED(src) || stat == DEAD) return;

//! Blood levels
#define BLOOD_VOLUME_MAX_LETHAL  2150
#define BLOOD_VOLUME_EXCESS      2100
#define BLOOD_VOLUME_MAXIMUM     2000
#define BLOOD_VOLUME_SLIME_SPLIT 1120
#define BLOOD_VOLUME_NORMAL      560
#define BLOOD_VOLUME_SAFE        475
#define BLOOD_VOLUME_OKAY        336
#define BLOOD_VOLUME_BAD         224
#define BLOOD_VOLUME_SURVIVE     122

//* misc
/// how far you have to shift to not be bumped by people
#define WALLFLOWERING_PIXEL_SHIFT 8
