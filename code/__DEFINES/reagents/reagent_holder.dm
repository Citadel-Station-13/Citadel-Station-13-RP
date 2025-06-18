//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Constants *//

#define REAGENT_HOLDER_VOLUME_PRECISION 0.00001
#define REAGENT_HOLDER_VOLUME_QUANTIZE(VAL) round(VAL, REAGENT_HOLDER_VOLUME_PRECISION)

//* flags for /datum/reagent_holder/var/reagent_holder_flags *//

/// currently reacting
/// * todo: should this also be set while doing instant reactions? think this is onyl
///   set during ticked, right now
#define REAGENT_HOLDER_FLAG_CURRENTLY_REACTING (1<<0)
/// currently being violently shaken
/// * whatever is shaking the holder sets this, calls reconsider reactions, and disables this again
/// * should not be set just for movement; this is stuff like shaker shaking, throw impact, etc
#define REAGENT_HOLDER_FLAG_BEING_JOSTLED (1<<2)
/// is considered an open container right now
/// * this is only the case if we are directly open to the environment. this is **not**
///   a 'can we use syringes'; this is a 'is the lid uncapped and someone can see the reagents'.
#define REAGENT_HOLDER_FLAG_OPEN_CONTAINER (1<<3)

#warn DEFINE_BITFIELD_NEW, including on /datum/chemical_reaction
