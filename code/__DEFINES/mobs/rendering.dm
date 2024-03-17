//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* human overlay enums for standing_overlays

#define HUMAN_OVERLAY_SKIN "skin"
#define HUMAN_OVERLAY_MUTATIONS "mutations"
#define HUMAN_OVERLAY_BLOOD "blood"
#define HUMAN_OVERLAY_DAMAGE "damage"
#define HUMAN_OVERLAY_SURGERY "surgery"
#define HUMAN_OVERLAY_UNDERWEAR "underwear"
#define HUMAN_OVERLAY_FIRE "fire"
#define HUMAN_OVERLAY_LIQUID "liquid"

// todo: sprite accessories list system

#define HUMAN_OVERLAY_HAIR "hair"
#define HUMAN_OVERLAY_TAIL "tail"
#define HUMAN_OVERLAY_WINGS "wings"

#define HUMAN_OVERLAY_INVENTORY "inventory"

//* human rendering layers
//* human layers are via FLOAT_LAYER so all of these are negative
//* higher (so smaller subtracted numbers after LAYER_FLOAT) is on-top

/// layer used for on-fire visual
#define HUMAN_LAYER_FIRE (LAYER_FLOAT - 25)
/// layer used for water/acid/etc overlays when you're in a pool or liquid
#define HUMAN_LAYER_LIQUID (LAYER_FLOAT - 50)
//! legacy - modifier graphics
#define HUMAN_LAYER_MODIFIERS (LAYER_FLOAT - 75)

#define HUMAN_LAYER_SPRITEACC_TAIL_ALT (LAYER_FLOAT - 349)
#define HUMAN_LAYER_SPRITEACC_WINGS (LAYER_FLOAT - 300)

#define HUMAN_LAYER_SLOT_RHAND (LAYER_FLOAT - 324)
#define HUMAN_LAYER_SLOT_LHAND (LAYER_FLOAT - 325)

#define HUMAN_LAYER_SLOT_LEGCUFFED (LAYER_FLOAT - 349)
#define HUMAN_LAYER_SLOT_HANDCUFFED (LAYER_FLOAT - 350)

#define HUMAN_LAYER_SLOT_HEAD (LAYER_FLOAT - 375)
#define HUMAN_LAYER_SLOT_MASK (LAYER_FLOAT - 400)
#define HUMAN_LAYER_SLOT_EYES (LAYER_FLOAT - 425)
#define HUMAN_LAYER_SLOT_EARS (LAYER_FLOAT - 450)

#define HUMAN_LAYER_SPRITEACC_HAIR (LAYER_FLOAT - 475)

#define HUMAN_LAYER_SLOT_BACKPACK (LAYER_FLOAT - 500)
#define HUMAN_LAYER_SLOT_SUITSTORE (LAYER_FLOAT - 525)
#define HUMAN_LAYER_SLOT_BELT_ALT (LAYER_FLOAT - 550)
#define HUMAN_LAYER_SLOT_GLASSES (LAYER_FLOAT - 575)

#define HUMAN_LAYER_SPRITEACC_TAIL (LAYER_FLOAT - 600)

#define HUMAN_LAYER_SLOT_OVERSUIT (LAYER_FLOAT - 625)
#define HUMAN_LAYER_SLOT_BELT (LAYER_FLOAT - 650)
#define HUMAN_LAYER_SLOT_GLOVES (LAYER_FLOAT - 675)
#define HUMAN_LAYER_SLOT_SHOES (LAYER_FLOAT - 700)
#define HUMAN_LAYER_SLOT_IDSLOT (LAYER_FLOAT - 725)
#define HUMAN_LAYER_SLOT_UNIFORM (LAYER_FLOAT - 750)
#define HUMAN_LAYER_SLOT_SHOES_ALT (LAYER_FLOAT - 775)

//! legacy - underwear clothing
#define HUMAN_LAYER_UNDERWEAR (LAYER_FLOAT - 800)
//! legacy - surgery overlays
#define HUMAN_LAYER_SURGERY (LAYER_FLOAT - 825)
//! legacy - damage on limbs
#define HUMAN_LAYER_DAMAGE (LAYER_FLOAT - 850)
//! legacy - blood on skin
#define HUMAN_LAYER_BLOOD (LAYER_FLOAT - 875)
//! legacy - species skin
#define HUMAN_LAYER_SKIN (LAYER_FLOAT - 900)
//! legacy - genetics
#define HUMAN_LAYER_MUTATIONS (LAYER_FLOAT - 1000)
