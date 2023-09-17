/// message range for silenced combat actions. for stuff like id swipes, etc
#define MESSAGE_RANGE_COMBAT_SILENCED			1
/// message range for moderately silenced combat actions. for most things like syringe injections, etc.
#define MESSAGE_RANGE_COMBAT_SUPPRESSED			2
/// message range for subtle combat actions. for things like subtle hits in melee
#define MESSAGE_RANGE_COMBAT_SUBTLE				3
/// message range for loud combat actions. for things like obvious melee / ranged fire
#define MESSAGE_RANGE_COMBAT_LOUD				7

/// message range for most construction / deconstruction actions
#define MESSAGE_RANGE_CONSTRUCTION 3
/// message range for most machine / structure configuration actions
#define MESSAGE_RANGE_CONFIGURATION 3
/// silent-ish inv ops like swapping beacons
#define MESSAGE_RANGE_INVENTORY_SOFT 3
/// hard-ish inv ops like taking things out of backpacks
#define MESSAGE_RANGE_INVENTORY_HARD 7
