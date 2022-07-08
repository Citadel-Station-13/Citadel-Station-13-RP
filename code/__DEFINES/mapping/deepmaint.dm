/**
 * START PUBLIC SECTION: THIS, MAPPERS, IS WHAT YOU CARE ABOUT
 *
 * All deepmaint template defines go in here.
 */

// deepmaint template themes we probably won't need more than 24
/// generic
#define DEEPMAINT_THEME_GENERIC				(1<<0)
/// ice-like
#define DEEPMAINT_THEME_FROZEN				(1<<1)
/// cave/mountain
#define DEEPMAINT_THEME_MOUNTAIN			(1<<2)
/// lava-like
#define DEEPMAINT_THEME_MOLTEN				(1<<3)
/// plains - whether above or underground
#define DEEPMAINT_THEME_PLAINS				(1<<4)
/// asteroid
#define DEEPMAINT_THEME_ASTEROID			(1<<8)
/// spacestation
#define DEEPMAINT_THEME_STATION				(1<<9)

#define DEEPMAINT_THEME_ANY					ALL

// deepmaint type
/// marks if this should be usable aboveground
#define DEEPMAINT_TYPE_ABOVEGROUND			(1<<5)
/// marks if this should be usable underground
#define DEEPMAINT_TYPE_UNDERGRONUD			(1<<6)
/// marks if this should be usable in space
#define DEEPMAINT_TYPE_SPACE				(1<<7)

#define DEEPMAINT_TYPE_ANY					ALL

// deepmaint danger rating
/// as harmless as a suspiciuos rock outcropping
#define DEEPMAINT_DANGER_NEGLIGIBLE			1
/// a few rats
#define DEEPMAINT_DANGER_ANNOYANCE			2
/// a few spiders
#define DEEPMAINT_DANGER_HARMFUL			3
/// a merc or two, spider cave
#define DEEPMAINT_DANGER_HOSTILE			4
/// a few mercs, cult constructs, etc
#define DEEPMAINT_DANGER_LETHAL				5
/// this room will utterly fuck the station up if we seed it too close
#define DEEPMAINT_DANGER_OH_SHIT			6

// deepmaint rarity rating
/// this is worthless
#define DEEPMAINT_RARITY_WORTHLESS			1
/// this has some tools, first aid kit, etc
#define DEEPMAINT_RARITY_BASICS				2
/// this has chems, low grade weapons, w/e
#define DEEPMAINT_RARITY_UNIQUE				3
/// this has powerful stuff
#define DEEPMAINT_RARITY_IMPRESSIVE			4
/// this shouldn't be seen most of the time
#define DEEPMAINT_RARITY_SUPER				5

// deepmaint template directive flags
/// this is a branch point. this means that; 1. the deepmaint system is allowed to penetrate your template with a hallway any way it sees fit and 2. we don't care about any doorways anymore
#define DEEPMAINT_DIRECTIVE_ROOM_FREEBRANCH			(1<<0)
/// this is an entrance template. use this on edges and whatnot.
#define DEEPMAINT_DIRECTIVE_ROOM_ENTRANCE			(1<<1)


/**
 * END PUBLIC SECTION
 */

/**
 * START GENERATOR DEFINES
 */

// generator directive flags
/// ignore AREA_DEEPMAINT_ALLOWED - DANGEROUS
#define DEEPMAINT_DIRECTIVE_GENERATOR_IGNORE_AREAS	(1<<0)

// generation state
#define DEEPMAINT_GENERATION_STATE_NOT_STARTED			0
#define DEEPMAINT_GENERATION_STATE_RUNNINIG				1
#define DEEPMAINT_GENERATION_STATE_FINISHED				2

// generation mode/algorithm
/// complex advanced algorithm
#define DEEPMAINT_ALGORITHM_DUNGEON					"dungeon"
