// Language flags.
#define WHITELISTED  (1 << 0) // Language is available if the speaker is whitelisted.
#define RESTRICTED   (1 << 1) // Language can only be acquired by spawning or an admin.
#define NONVERBAL    (1 << 2) // Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define SIGNLANG     (1 << 3) // Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define HIVEMIND     (1 << 4) // Broadcast to all mobs with this language.
#define NONGLOBAL    (1 << 5) // Do not add to general languages list.
#define INNATE       (1 << 6) // All mobs can be assumed to speak and understand this language. (audible emotes)
#define NO_TALK_MSG  (1 << 7) // Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_STUTTER   (1 << 8) // No stuttering, slurring, or other speech problems
#define ALT_TRANSMIT (1 << 9) // Language is not based on vision or sound (Todo: add this into the say code and use it for the rootspeak languages)


// Languages.
#define LANGUAGE_GALCOM "Galactic Common"
#define LANGUAGE_EAL "Encoded Audio Language"
#define LANGUAGE_SWARMBOT "Ancient Audio Encryption"
#define LANGUAGE_SOL_COMMON "Sol Common"
#define LANGUAGE_UNATHI "Sinta'unathi"
#define LANGUAGE_AKHANI "Akhani"
#define LANGUAGE_SIIK "Siik'maas"
#define LANGUAGE_SIIK_TAJR "Siik'tajr"
#define LANGUAGE_SKRELLIAN "Common Skrellian"
#define LANGUAGE_TRADEBAND "Tradeband"
#define LANGUAGE_GUTTER "Gutter"
#define LANGUAGE_SIGN "Sign Language"
#define LANGUAGE_SCHECHI "Schechi"
#define LANGUAGE_ROOTLOCAL "Local Rootspeak"
#define LANGUAGE_ROOTGLOBAL "Global Rootspeak"
#define LANGUAGE_CULT "Cult"
#define LANGUAGE_OCCULT "Occult"
#define LANGUAGE_CHANGELING "Changeling"
#define LANGUAGE_VOX "Vox-Pidgin"
#define LANGUAGE_TERMINUS "Terminus"
#define LANGUAGE_SKRELLIANFAR "High Skrellian"
#define LANGUAGE_MINBUS "Minbus"
#define LANGUAGE_EVENT1 "Occursus"
#define LANGUAGE_AKHANI "Akhani"
#define LANGUAGE_ZADDAT "Vedahq"
#define LANGUAGE_GIBBERISH "Babel"
#define LANGUAGE_VERNAL "Vernal"
#define LANGUAGE_ADHERENT "Vibrant"

//Languages from _vr file
#define LANGUAGE_SLAVIC "Pan-Slavic"
#define LANGUAGE_BIRDSONG "Birdsong"
#define LANGUAGE_SAGARU "Sagaru"
#define LANGUAGE_CANILUNZT "Canilunzt"
#define LANGUAGE_ECUREUILIAN "Ecureuilian"
#define LANGUAGE_DAEMON "Daemon"
#define LANGUAGE_ENOCHIAN "Enochian"
#define LANGUAGE_BONES "Echorus"
#define LANGUAGE_VESPINAE "Vespinae"

#define LANGUAGE_CHIMPANZEE "Chimpanzee"
#define LANGUAGE_NEAERA "Neaera"
#define LANGUAGE_STOK "Stok"
#define LANGUAGE_FARWA "Farwa"

#define LANGUAGE_SQUEAKISH "Squeakish"

#define LANGUAGE_SHADEKIN "Shadekin Empathy"

// Temp loc for new languages
#define LANGUAGE_ALIUM "Alium"
#define LANGUAGE_XENOMORPH "Xenomorph"
#define LANGUAGE_XENOMORPH_HIVE "Hivemind"
#define LANGUAGE_SPACER "Spacer"
#define LANGUAGE_INDEPENDENT "Independent"
#define LANGUAGE_LUNAR "Selenian"
