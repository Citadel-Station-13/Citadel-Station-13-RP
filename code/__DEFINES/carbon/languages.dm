// Languages.
#define LANGUAGE_ADHERENT "Vibrant"
#define LANGUAGE_AKHANI "Akhani"
#define LANGUAGE_AKULA "Olelo Mano"
#define LANGUAGE_ALAI "Alai"
#define LANGUAGE_BIRDSONG "Birdsong"
#define LANGUAGE_BONES "Echorus"
#define LANGUAGE_CANILUNZT "Canilunzt"
#define LANGUAGE_CHANGELING "Changeling"
#define LANGUAGE_CHIMPANZEE "Chimpanzee"
#define LANGUAGE_CULT "Cult"
#define LANGUAGE_DAEMON "Daemon"
#define LANGUAGE_EAL "Encoded Audio Language"
#define LANGUAGE_ECUREUILIAN "Ecureuilian"
#define LANGUAGE_ENOCHIAN "Enochian"
#define LANGUAGE_EVENT1 "Occursus"
#define LANGUAGE_FARWA "Farwanese"
#define LANGUAGE_GALCOM "Galactic Common"
#define LANGUAGE_GIBBERISH "Babel"
#define LANGUAGE_GUTTER "Gutter"
/// moth native language
#define LANGUAGE_LUINIMMA "Luinimma"
#define LANGUAGE_MINBUS "Minbus"
#define LANGUAGE_NEAERA "Neaeranae"
#define LANGUAGE_OCCULT "Occult"
#define LANGUAGE_ROOTGLOBAL "Global Rootspeak"
#define LANGUAGE_ROOTLOCAL "Local Rootspeak"
#define LANGUAGE_SAGARU "Sagaru"
#define LANGUAGE_SCHECHI "Schechi"
#define LANGUAGE_SHADEKIN "Shadekin Empathy"
#define LANGUAGE_SIGN "Sign Language"
#define LANGUAGE_SIIK "Siik"
#define LANGUAGE_SKRELLIAN "Common Skrellian"
#define LANGUAGE_SKRELLIANFAR "High Skrellian"
#define LANGUAGE_SLAVIC "Pan-Slavic"
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_SQUEAKISH "Squeakish"
#define LANGUAGE_STOK "Stokan"
#define LANGUAGE_SWARMBOT "Ancient Audio Encryption"
#define LANGUAGE_TERMINUS "Terminus"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_VERNAL "Vernal"
#define LANGUAGE_VESPINAE "Vespinae"
#define LANGUAGE_VOX "Vox-Pidgin"
#define LANGUAGE_XENO "Xenomorph"
#define LANGUAGE_ZADDAT "Vedahq"

// Language flags.
/// Language is available if the speaker is whitelisted.
#define WHITELISTED  (1 << 0)
/// Language can only be acquired by spawning or an admin.
#define RESTRICTED   (1 << 1)
/// Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define NONVERBAL    (1 << 2)
/// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define SIGNLANG     (1 << 3)
/// Broadcast to all mobs with this language.
#define HIVEMIND     (1 << 4)
/// Do not add to general languages list.
#define NONGLOBAL    (1 << 5)
/// All mobs can be assumed to speak and understand this language. (audible emotes)
#define INNATE       (1 << 6)
/// Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_TALK_MSG  (1 << 7)
/// No stuttering, slurring, or other speech problems.
#define NO_STUTTER   (1 << 8)
/// Language is not based on vision or sound. (Todo: add this into the say code and use it for the rootspeak languages)
#define ALT_TRANSMIT (1 << 9)
