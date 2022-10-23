//cast_method flags, needs to be up to date with Technomancer's. They were, for some reason, not working outside it.
/// Clicking the spell in your hand.
#define CAST_USE		1
/// Clicking an atom in melee range.
#define CAST_MELEE		2
/// Clicking an atom beyond melee range.
#define CAST_RANGED		4
/// Throwing the spell and hitting an atom.
#define CAST_THROW		8
/// Clicking another spell with this spell.
#define CAST_COMBINE	16
/// Activates upon verb usage, used for mobs without hands.
#define CAST_INNATE		32
//Aspects
///Damage over time and raising body-temp.  Firesuits protect from this.
#define ASPECT_FIRE			"fire"
///Slows down the affected, also involves imbedding with icicles.  Winter coats protect from this.
#define ASPECT_FROST		"frost"
///Energy-expensive, usually stuns.  Insulated armor protects from this.
#define ASPECT_SHOCK		"shock"
///Mostly involves manipulation of atmos, useless in a vacuum.  Magboots protect from this.
#define ASPECT_AIR			"air"
///Manipulates gravity to push things away or towards a location.
#define ASPECT_FORCE		"force"
///Teleportation of self, other objects, or other people.
#define ASPECT_TELE			"tele"
///Makes all those photons vanish using magic-- WITH SCIENCE.  Used for sneaky stuff.
#define ASPECT_DARK			"dark"
///The opposite of dark, usually blinds, makes holo-illusions, or makes laser lightshows.
#define ASPECT_LIGHT		"light"
///Mainly concerned with healing and restoration.
#define ASPECT_BIOMED		"biomed"
///Unused now.
#define ASPECT_EMP			"emp"
///Heavily RNG-based, causes instability to the victim.
#define ASPECT_UNSTABLE		"unstable"
///Used to combine with other spells.
#define ASPECT_CHROMATIC	"chromatic"
///Involves the dead, blood, and most things against divine beings.
#define ASPECT_UNHOLY		"unholy"
