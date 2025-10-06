//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station developers.          *//

//*                 IFF Factions                  *//

//? -- Special; These must start with '!' -- ?//
//?                                          ?//
//? These are only valid syntax in places    ?//
//? where you should be using them, aka      ?//
//? initializers.                            ?//

/// get an arbitrary faction that's the same on a given /datum/map_level
#define MOB_IFF_FACTION_BIND_TO_LEVEL "!bind-level"
/// get an arbitrary faction that's the same on a given /datum/map
///
/// * acts like BIND_TO_LEVEL if there's no parent /datum/map for a /datum/map_level
#define MOB_IFF_FACTION_BIND_TO_MAP "!bind-map"
/// get an arbitrary faction that's the same on a given /datum/map_level for a given key
///
/// * GROUP must be a string
#define MOB_IFF_FACTION_BIND_TO_LEVEL_GROUP(GROUP) list(MOB_IFF_FACTION_BIND_TO_LEVEL = GROUP)
/// get an arbitrary faction that's the same on a given /datum/map for a given key
///
/// * GROUP must be a string
/// * acts like BIND_TO_LEVEL if there's no parent /datum/map for a /datum/map_level
#define MOB_IFF_FACTION_BIND_TO_MAP_GROUP list(MOB_IFF_FACTION_BIND_TO_MAP = GROUP)

// todo: "bind to map template" (?)
// todo: "bind to /area" (?)
// todo: "bind to specific type" handling; maybe just input typepath?

/// automatically detect what we should bind to
///
/// * submap
/// * map
/// todo: impl
#define MOB_IFF_FACTION_BIND_AUTO MOB_IFF_FACTION_BIND_TO_MAP
/// automatically detect what we should bind to, and use a specific separated group
///
/// * submap
/// * map
/// todo: impl
#define MOB_IFF_FACTION_BIND_AUTO_GROUP(GROUP) list(MOB_IFF_FACTION_BIND_TO_MAP = GROUP)

//? Default factions *//

/// mobs have this by default
///
/// * this makes a lot of things assume that the mob is nonhostile.
/// * this should be removed for hostile mobs
#define MOB_IFF_FACTION_NEUTRAL "neutral"
/// generic hostile mob faction
///
/// * do not check for this; most hostile mobs do not have this
/// * having FACTION_NEUTRAL is an effect; having this is not, this is just a generic one so the mob has a faction.
/// * you probably shouldn't even be using this unless you're doing BIND_TO_LEVEL/MAP_GROUP with this.
#define MOB_IFF_FACTION_HOSTILE "hostile"

//? AI / machine intelligence factions ?//

#define MOB_IFF_FACTION_HIVEBOT "ai-hivebot"
#define MOB_IFF_FACTION_SWARMER "ai-swarmer"
#define MOB_IFF_FACTION_CASINO "ai-casino"

//? Alien factions

#define MOB_IFF_FACTION_BLOB "alien-blob"
#define MOB_IFF_FACTION_CHIMERIC "alien-chimeric"
#define MOB_IFF_FACTION_SLIME "alien-slime"
#define MOB_IFF_FACTION_STATUE "alien-statue"
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

/// man's worst enemy (spiders)
#define MOB_IFF_FACTION_SPIDER "spider"
/// fallout gone wrong - wait what?! (cockroaches)
#define MOB_IFF_FACTION_ROACH "roach"
/// biotech gone wrong (genetic horrors)
#define MOB_IFF_FACTION_MUTANT "mutant"
/// hydroponics gone wrong (literally any hostile plane)
#define MOB_IFF_FACTION_PLANT "plant"
/// is this a dune reference??? (space worms)
#define MOB_IFF_FACTION_WORM "worm"
/// we're going whaling! (space carps)
#define MOB_IFF_FACTION_CARP "carp"
/// the bane of engineering (solargrubs)
#define MOB_IFF_FACTION_GRUB "grubs"

// odysseus may have been right... (monsters)
#define MOB_IFF_FACTION_MONSTER "monsters"
// snakes! why'd it have to be snakes?! (lamias)
#define MOB_IFF_FACTION_MONSTER_LAMIA "lamias"
// here kitty kitty... (bobcats)
#define MOB_IFF_FACTION_MONSTER_BOBCAT "bobcats"
// IS THAT A FUCKING BEAR?! (bears)
#define MOB_IFF_FACTION_MONSTER_BEAR "bears"
// burn it with fire! (skallax)
#define MOB_IFF_FACTION_MONSTER_SKALLAX "skallax"
// hope little red isn't around! (wolves)
#define MOB_IFF_FACTION_MONSTER_WOLF "wolves"
// water won't do anything this time.. (slimes)
#define MOB_IFF_FACTION_MONSTER_SLIME "slimes"
// giant. fucking. mosquitos. (komar)
#define MOB_IFF_FACTION_MONSTER_KOMAR "komar"
// maybe ask them if they need sunglasses? (moles)
#define MOB_IFF_FACTION_MONSTER_MOLE "mole"
// bugs, bug and more bugs! (bugs)
#define MOB_IFF_FACTION_MONSTER_BUG "bugs"

//? Human factions ?//

#define MOB_IFF_FACTION_MERCENARY "mercenary"
#define MOB_IFF_FACTION_MERCENARY_GROUP(GROUP) ("mercenary-" + GROUP)
#define MOB_IFF_FACTION_PIRATE "mercenary"
#define MOB_IFF_FACTION_PIRATE_GROUP(GROUP) ("mercenary-" + GROUP)

//? Paracausal factions ?//

#define MOB_IFF_FACTION_CLOCKWORK_CULT "clock-cult"
#define MOB_IFF_FACTION_SANGUINE_CULT "blood-cult"
#define MOB_IFF_FACTION_ELDRITCH_CULT "eldritch-cult"

//? Tajara Factions ?//

#define MOB_IFF_FACTION_TAJARA_NKA "tajara-nka_brigands-"
#define MOB_IFF_FACTION_TAJARA_NKA_GROUP(GROUP) ("tajara-nka_brigands-" + GROUP)

#define MOB_IFF_FACTION_TAJARA_DRA "tajara-dra_guerillas-"
#define MOB_IFF_FACTION_TAJARA_DRA_GROUP(GROUP) ("tajara-dra_guerillas-" + GROUP)

#define MOB_IFF_FACTION_TAJARA_PRA "tajara-pra_insurgents"
#define MOB_IFF_FACTION_TAJARA_PRA_GROUP(GROUP) ("tajara-pra_insurgents-" + GROUP)
