//! General

// none yet

//! Skills

//? skill levels.
//? These must be SEQUENTIAL FROM 1 TO X.
#define CHARACTER_SKILL_UNTRAINED 1
#define CHARACTER_SKILL_NOVICE 2
#define CHARACTER_SKILL_TRAINED 3
#define CHARACTER_SKILL_EXPERIENCED 4
#define CHARACTER_SKILL_PROFESSIONAL 5

#define CHARACTER_SKILL_ENUM_MIN 1
#define CHARACTER_SKILL_ENUM_MAX 5

//? Skill costs
/// baseline skillpoints
#define SKILLPOINTS_BASELINE 36
/// for a negligible gain from the last level
#define SKILLCOST_INCREMENT_NEGLIGIBLE 1
/// for a mild gain from the last level
#define SKILLCOST_INCREMENT_MINOR 2
/// for a moderate gain from the last level
#define SKILLCOST_INCREMENT_MODERATE 3
/// for a major gain from the last level
#define SKILLCOST_INCREMENT_MAJOR 4
/// for an extreme gain from the last level
#define SKILLCOST_INCREMENT_EXTREME 6

//? Skill scaling
/// constant * 2 ** level diff
#define SKILL_SCALING_EXPONENTIAL_HARD 1
/// constant * level diff
#define SKILL_SCALING_LINEAR 2
/// constant * 1.5 ** level diff
#define SKILL_SCALING_EXPONENTIAL_SOFT 3

//! Stats

//? stat datatypes
/// a number
#define CHARACTER_STAT_NUMERIC "num"
/// text data
#define CHARACTER_STAT_STRING "str"
/// boolean
#define CHARACTER_STAT_BOOL "bool"
/// a datum of some kind - NOT RECOMMENDED
#define CHARACTER_STAT_DATUM "datum"
/// unknown
#define CHARACTER_STAT_UNKNOWN "unkw"

//! Talents

// none yet
