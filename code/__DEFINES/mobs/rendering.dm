//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* human overlay enums for standing_overlays
#define HUMAN_OVERLAY_BODY "body"
#define HUMAN_OVERLAY_SKIN "skin"
#define HUMAN_OVERLAY_MUTATIONS "mutations"
#define HUMAN_OVERLAY_MODIFIERS "mutations"
#define HUMAN_OVERLAY_BLOOD "blood"
#define HUMAN_OVERLAY_EYES "eyes"
#define HUMAN_OVERLAY_DAMAGE "damage"
#define HUMAN_OVERLAY_SURGERY "surgery"
#define HUMAN_OVERLAY_UNDERWEAR "underwear"
#define HUMAN_OVERLAY_FIRE "fire"
#define HUMAN_OVERLAY_LIQUID "liquid"
#define HUMAN_OVERLAY_HAND(INDEX) "hand-[INDEX]"

// todo: sprite accessories list system

#define HUMAN_OVERLAY_HAIR "hair"
#define HUMAN_OVERLAY_FACEHAIR "facehair"
#define HUMAN_OVERLAY_TAIL "tail"
#define HUMAN_OVERLAY_WINGS "wings"
#define HUMAN_OVERLAY_HORNS "horns"
#define HUMAN_OVERLAY_EARS "ears"

//* human rendering layers
//* human layers are via FLOAT_LAYER so all of these are negative
//* higher (so smaller subtracted numbers after FLOAT_LAYER) is on-top

/// layer used for on-fire visual
#define HUMAN_LAYER_FIRE (FLOAT_LAYER - 25)
/// layer used for water/acid/etc overlays when you're in a pool or liquid
#define HUMAN_LAYER_LIQUID (FLOAT_LAYER - 50)
//! legacy - modifier graphics
#define HUMAN_LAYER_MODIFIERS (FLOAT_LAYER - 75)

#define HUMAN_LAYER_SLOT_RHAND (FLOAT_LAYER - 324)
#define HUMAN_LAYER_SLOT_LHAND (FLOAT_LAYER - 325)

#define HUMAN_LAYER_SLOT_LEGCUFFED (FLOAT_LAYER - 370)
#define HUMAN_LAYER_SLOT_HANDCUFFED (FLOAT_LAYER - 371)

#define HUMAN_LAYER_SLOT_HEAD (FLOAT_LAYER - 375)
#define HUMAN_LAYER_SLOT_MASK (FLOAT_LAYER - 400)
#define HUMAN_LAYER_SLOT_EYES (FLOAT_LAYER - 425)
#define HUMAN_LAYER_SLOT_EARS (FLOAT_LAYER - 450)

#define HUMAN_LAYER_SPRITEACC_HORNS_FRONT (FLOAT_LAYER - 475)
#define HUMAN_LAYER_SPRITEACC_EARS_FRONT (FLOAT_LAYER - 476)
#define HUMAN_LAYER_SPRITEACC_HAIR_FRONT (FLOAT_LAYER - 477)
#define HUMAN_LAYER_SPRITEACC_FACEHAIR_FRONT (FLOAT_LAYER - 478)
#define HUMAN_LAYER_SPRITEACC_WINGS_FRONT (FLOAT_LAYER - 479)
#define HUMAN_LAYER_SLOT_BACKPACK_ALT (FLOAT_LAYER - 480)
#define HUMAN_LAYER_SPRITEACC_TAIL_FRONT (FLOAT_LAYER - 482)

#define HUMAN_LAYER_SLOT_BACKPACK (FLOAT_LAYER - 500)
#define HUMAN_LAYER_SLOT_SUITSTORE (FLOAT_LAYER - 525)
#define HUMAN_LAYER_SLOT_BELT_ALT (FLOAT_LAYER - 550)
#define HUMAN_LAYER_SLOT_GLASSES (FLOAT_LAYER - 575)

#define HUMAN_LAYER_SLOT_OVERSUIT (FLOAT_LAYER - 625)
#define HUMAN_LAYER_SLOT_BELT (FLOAT_LAYER - 650)
#define HUMAN_LAYER_SLOT_GLOVES (FLOAT_LAYER - 675)
#define HUMAN_LAYER_SLOT_SHOES (FLOAT_LAYER - 700)
#define HUMAN_LAYER_SLOT_IDSLOT (FLOAT_LAYER - 725)
#define HUMAN_LAYER_SLOT_UNIFORM (FLOAT_LAYER - 750)
#define HUMAN_LAYER_SLOT_SHOES_ALT (FLOAT_LAYER - 775)

//! legacy - underwear clothing
#define HUMAN_LAYER_UNDERWEAR (FLOAT_LAYER - 800)
//! legacy - surgery overlays
#define HUMAN_LAYER_SURGERY (FLOAT_LAYER - 825)
//! legacy - damage on limbs
#define HUMAN_LAYER_DAMAGE (FLOAT_LAYER - 850)
//! legacy - blood on skin
#define HUMAN_LAYER_BLOOD (FLOAT_LAYER - 875)
//! legacy - species skin
#define HUMAN_LAYER_SKIN (FLOAT_LAYER - 900)

#define HUMAN_LAYER_BODY (FLOAT_LAYER - 925)

#define HUMAN_LAYER_SPRITEACC_HORNS_BEHIND (FLOAT_LAYER - 950)
#define HUMAN_LAYER_SPRITEACC_EARS_BEHIND (FLOAT_LAYER - 951)
#define HUMAN_LAYER_SPRITEACC_HAIR_BEHIND (FLOAT_LAYER - 952)
#define HUMAN_LAYER_SPRITEACC_FACEHAIR_BEHIND (FLOAT_LAYER - 953)
#define HUMAN_LAYER_SPRITEACC_WINGS_BEHIND (FLOAT_LAYER - 954)
#define HUMAN_LAYER_SPRITEACC_TAIL_BEHIND (FLOAT_LAYER - 955)

//! legacy - genetics
#define HUMAN_LAYER_MUTATIONS (FLOAT_LAYER - 998)


//* Helpers *//

/// end proc immediately if we're being deleted or transformed into something
#define HUMAN_RENDER_ABORT_IF_DELETING if(QDELING(src) || transforming) return

// carbon appearance update enums
#define CARBON_APPEARANCE_UPDATE_CLOTHING "clothing"
#define CARBON_APPEARANCE_UPDATE_OTHER "other"
