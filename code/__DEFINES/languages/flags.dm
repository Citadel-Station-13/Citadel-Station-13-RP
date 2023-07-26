//! /datum/language/var/language_flags
/// Language is available if the speaker is whitelisted, or if granted by a species.
#define LANGUAGE_WHITELISTED  (1<<0)
/// Language can only be acquired by spawning or an admin.
#define LANGUAGE_RESTRICTED   (1<<1)
/// Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define LANGUAGE_NONVERBAL    (1<<2)
/// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define LANGUAGE_SIGNLANG     (1<<3)
/// Broadcast to all mobs with this language.
#define LANGUAGE_HIVEMIND     (1<<4)
/// Do not add to general languages list.
#define LANGUAGE_NONGLOBAL    (1<<5)
/// All mobs can be assumed to speak and understand this language. (audible emotes)
#define LANGUAGE_EVERYONE     (1<<6)
/// Do not show the "\The [speaker] talks into \the [radio]" message
#define LANGUAGE_NO_TALK_MSG  (1<<7)
/// No stuttering, slurring, or other speech problems.
#define LANGUAGE_NO_STUTTER   (1<<8)
/// Language is not based on vision or sound. //Todo: Add this into the say code and use it for the rootspeak languages.
#define LANGUAGE_ALT_TRANSMIT (1<<9)

DEFINE_BITFIELD(language_flags, list(
	BITFIELD(LANGUAGE_WHITELISTED),
	BITFIELD(LANGUAGE_RESTRICTED),
	BITFIELD(LANGUAGE_NONVERBAL),
	BITFIELD(LANGUAGE_SIGNLANG),
	BITFIELD(LANGUAGE_HIVEMIND),
	BITFIELD(LANGUAGE_NONGLOBAL),
	BITFIELD(LANGUAGE_EVERYONE),
	BITFIELD(LANGUAGE_NO_TALK_MSG),
	BITFIELD(LANGUAGE_NO_STUTTER),
	BITFIELD(LANGUAGE_ALT_TRANSMIT),
))

//! translation_class on /datum/language and /datum/translation_context as well as all translation operations
/// common galactic languages; most translators can instantly translate this
#define TRANSLATION_CLASS_LEVEL_1 (1<<0)
/// high end translators can translate these; you're looking at science/cargo; low level learning translators learn this
#define TRANSLATION_CLASS_LEVEL_2 (1<<1)
/// extremely high end translators can translate these; high end learning translators learn this; anything above is probably adminbus
#define TRANSLATION_CLASS_LEVEL_3 (1<<2)
/// xenomorphs, etc
#define TRANSLATION_CLASS_MONSTER (1<<18)
/// simpler animal languages
#define TRANSLATION_CLASS_ANIMAL (1<<19)
/// magical languages
#define TRANSLATION_CLASS_ARCANE (1<<20)
/// encrypted languages ; usually conjunction with machine class
#define TRANSLATION_CLASS_ENCRYPTED (1<<21)
/// tribal/native languages
#define TRANSLATION_CLASS_TRIBAL (1<<22)
/// machine-like languages
#define TRANSLATION_CLASS_MACHINE (1<<23)

/// core galactic species
#define TRANSLATION_CLASS_DEFAULT_CORE_RACE (TRANSLATION_CLASS_LEVEL_1)
/// standard galactic species
#define TRANSLATION_CLASS_DEFAULT_STANDARD_RACE (TRANSLATION_CLASS_LEVEL_1)
/// people's snowflakes that wanna be super speshul and be mYsTerIoUS
#define TRANSLATION_CLASS_DEFAULT_RARE_RACE (TRANSLATION_CLASS_LEVEL_2)
/// native species
#define TRANSLATION_CLASS_DEFAULT_NATIVE_RACE (TRANSLATION_CLASS_LEVEL_3 | TRANSLATION_CLASS_TRIBAL)
/// core alt langauges for galaxy
#define TRANSLATION_CLASS_DEFAULT_CORE_LANGUAGE (TRANSLATION_CLASS_LEVEL_1)

/// what cyborgs get by default
#define TRANSLATION_CLASSES_CYBORG_SPEAKS (TRANSLATION_CLASS_LEVEL_1)
/// what ais get by default
#define TRANSLATION_CLASSES_AI_SPEAKS (TRANSLATION_CLASS_LEVEL_1)
/// what all universal translators get intrinsically
#define TRANSLATION_CLASSES_STANDARD_TRANSLATE (TRANSLATION_CLASS_LEVEL_1)
/// what adaptive universal translators can learn
#define TRANSLATION_CLASSES_STANDARD_ADAPTIVE (TRANSLATION_CLASS_LEVEL_2)

DEFINE_SHARED_BITFIELD(translation_classes, list(
	"translation_class",
	"translation_class_forbid",
	"translation_class_learn",
	"translation_class_learn_forbid",
), list(
	BITFIELD(TRANSLATION_CLASS_LEVEL_1),
	BITFIELD(TRANSLATION_CLASS_LEVEL_2),
	BITFIELD(TRANSLATION_CLASS_LEVEL_3),
	BITFIELD(TRANSLATION_CLASS_MONSTER),
	BITFIELD(TRANSLATION_CLASS_ANIMAL),
	BITFIELD(TRANSLATION_CLASS_ENCRYPTED),
	BITFIELD(TRANSLATION_CLASS_TRIBAL),
	BITFIELD(TRANSLATION_CLASS_MACHINE),
))
