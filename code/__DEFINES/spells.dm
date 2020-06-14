//cast_method flags, needs to be up to date with Technomancer's. They were, for some reason, not working outside it.
#define CAST_USE		1	// Clicking the spell in your hand.
#define CAST_MELEE		2	// Clicking an atom in melee range.
#define CAST_RANGED		4	// Clicking an atom beyond melee range.
#define CAST_THROW		8	// Throwing the spell and hitting an atom.
#define CAST_COMBINE	16	// Clicking another spell with this spell.
#define CAST_INNATE		32	// Activates upon verb usage, used for mobs without hands.

//Aspects
#define ASPECT_FIRE			"fire" 		//Damage over time and raising body-temp.  Firesuits protect from this.
#define ASPECT_FROST		"frost"		//Slows down the affected, also involves imbedding with icicles.  Winter coats protect from this.
#define ASPECT_SHOCK		"shock"		//Energy-expensive, usually stuns.  Insulated armor protects from this.
#define ASPECT_AIR			"air"		//Mostly involves manipulation of atmos, useless in a vacuum.  Magboots protect from this.
#define ASPECT_FORCE		"force" 	//Manipulates gravity to push things away or towards a location.
#define ASPECT_TELE			"tele"		//Teleportation of self, other objects, or other people.
#define ASPECT_DARK			"dark"		//Makes all those photons vanish using magic-- WITH SCIENCE.  Used for sneaky stuff.
#define ASPECT_LIGHT		"light"		//The opposite of dark, usually blinds, makes holo-illusions, or makes laser lightshows.
#define ASPECT_BIOMED		"biomed"	//Mainly concerned with healing and restoration.
#define ASPECT_EMP			"emp"		//Unused now.
#define ASPECT_UNSTABLE		"unstable"	//Heavily RNG-based, causes instability to the victim.
#define ASPECT_CHROMATIC	"chromatic"	//Used to combine with other spells.
#define ASPECT_UNHOLY		"unholy"	//Involves the dead, blood, and most things against divine beings.
