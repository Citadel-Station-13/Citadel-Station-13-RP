//! ## LANGUAGE_FLAGS
/// Language is available if the speaker is whitelisted.
#define WHITELISTED  (1<<0)
/// Language can only be acquired by spawning or an admin.
#define RESTRICTED   (1<<1)
/// Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define NONVERBAL    (1<<2)
/// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define SIGNLANG     (1<<3)
/// Broadcast to all mobs with this language.
#define HIVEMIND     (1<<4)
/// Do not add to general languages list.
#define NONGLOBAL    (1<<5)
/// All mobs can be assumed to speak and understand this language. (audible emotes)
#define INNATE       (1<<6)
/// Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_TALK_MSG  (1<<7)
/// No stuttering, slurring, or other speech problems.
#define NO_STUTTER   (1<<8)
/// Language is not based on vision or sound. //Todo: Add this into the say code and use it for the rootspeak languages.
#define ALT_TRANSMIT (1<<9)

DEFINE_BITFIELD(language_flags, list(
	BITFIELD(WHITELISTED),
	BITFIELD(RESTRICTED),
	BITFIELD(NONVERBAL),
	BITFIELD(SIGNLANG),
	BITFIELD(HIVEMIND),
	BITFIELD(NONGLOBAL),
	BITFIELD(INNATE),
	BITFIELD(NO_TALK_MSG),
	BITFIELD(NO_STUTTER),
	BITFIELD(ALT_TRANSMIT),
))
