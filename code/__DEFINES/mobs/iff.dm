//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//*                 IFF Factions                  *//
//*                                               *//
//* On new system, neutral faction is just null.  *//
#warn should neutral be null?

//? -- Special; These must start with '!' -- ?//

/// get an arbitrary faction that's the same on a given /datum/map_level
#define MOB_IFF_FACTION_BIND_TO_LEVEL "!bind-level"
#warn impl
/// get an arbitrary faction that's the same on a given /datum/map
///
/// * acts like BIND_TO_LEVEL if there's no parent /datum/map for a /datum/map_level
#define MOB_IFF_FACTION_BIND_TO_MAP "!bind-map"
#warn impl

// todo: "bind to /area"

//? AI / machine intelligence factions ?//

#define MOB_IFF_FACTION_HIVEBOT "ai-hivebot"
#define MOB_IFF_FACTION_SWARMER "ai-swarmer"

//? Alien factions

#define MOB_IFF_FACTION_BLOB "alien-blob"
#define MOB_IFF_FACTION_CHIMERIC "alien-chimeric"
#define MOB_IFF_FACTION_SLIME "alien-slime"
#define MOB_IFF_FACTION_XENOMORPH "alien-xenomorph"

//? Animal factions ?//
//* Farm refers to 'this would not be out of place in a normal earth farm that isn't in a horror series'

/// goats, cows, sheep
#define MOB_IFF_FACTION_FARM_ANIMAL "farm-animal"
/// ducks, other 'non producing' (canonically, anyways)
#define MOB_IFF_FACTION_FARM_NEUTRAL "farm-neutral"
/// mice and similar
#define MOB_IFF_FACTION_FARM_PEST "farm-pest"
/// cats, dogs
#define MOB_IFF_FACTION_FARM_PET "pet"

/// man's worst enemy
#define MOB_IFF_FACTION_SPIDER "spider"
/// fallout gone wrong - wait what?!
#define MOB_IFF_FACTION_ROACH "roach"
/// biotech gone wrong
#define MOB_IFF_FACTION_MUTANT "mutant"
/// hydroponics gone wrong
#define MOB_IFF_FACTION_PLANT "plant"
/// is this a dune reference???
#define MOB_IFF_FACTION_WORM "worm"

//? Human factions ?//

#define MOB_IFF_FACTION_MERCENARY "mercenary"
#define MOB_IFF_FACTION_MERCENARY_GROUP(GROUP) ("mercenary-" + GROUP)

//? Paracausal factions ?//

#define MOB_IFF_FACTION_CLOCKWORK_CULT "clock-cult"
#define MOB_IFF_FACTION_SANGUINE_CULT "blood-cult"
