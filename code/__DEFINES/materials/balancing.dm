//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? master file for balancing / efficiency tuning

//* Attributes - Resistance

/// the level at which vulnerability is comedically high
#define MATERIAL_RESISTANCE_CATASTROPHICALLY_VULNERABLE -800
/// the level at which vulnerability is very high
#define MATERIAL_RESISTANCE_SUPER_VULNERABLE -400
/// the level at which vulnerability is high
#define MATERIAL_RESISTANCE_VERY_VULNERABLE -200
/// the level at which vulnerability is high
#define MATERIAL_RESISTANCE_VULNERABLE -100
/// the level at which vulnerability is present
#define MATERIAL_RESISTANCE_SOMEWHAT_VULNERABLE -50
/// the level at which vulnerability is slightly there
#define MATERIAL_RESISTANCE_NEGLIGIBLY_VULNERABLE -25
/// baseline MATERIAL_RESISTANCE for nothing
#define MATERIAL_RESISTANCE_NONE 0
/// the level at which resistance is barely there
#define MATERIAL_RESISTANCE_NEGLIGIBLE 25
/// the level at which resistance is workable
#define MATERIAL_RESISTANCE_LOW 50
/// the level at which resistance is good
#define MATERIAL_RESISTANCE_MODERATE 100
/// the level at which resistance is high
#define MATERIAL_RESISTANCE_HIGH 200
/// the level at which resistance is very high
#define MATERIAL_RESISTANCE_EXTREME 400
/// the level at which resistance is nearly impermeable
#define MATERIAL_RESISTANCE_IMPERMEABLE 800

//* Attributes - Significance; This is how much material is in something

/// baseline significance of material calculations done on material-side / default computations
#define MATERIAL_SIGNIFICANCE_BASELINE 10
/// used for most doors
#define MATERIAL_SIGNIFICANCE_DOOR 15
/// significance used for normal wall layer
#define MATERIAL_SIGNIFICANCE_WALL 20
/// significance used for reinforcing wall layer
#define MATERIAL_SIGNIFICANCE_WALL_REINF 10
/// significance used for girder wall layer
#define MATERIAL_SIGNIFICANCE_WALL_GIRDER 5

//* Attributes - Factoring; This is applied to stats like density/weight, as significance affects armor.

/// baseline
#define MATERIAL_FACTORING_BASELINE 10
/// material gloves
#define MATERIAL_FACTORING_GLOVES 2

//* Efficiency

/// scale a lathe's efficiency to upgrade level
#define MATERIAL_EFFICIENCY_LATHE_SCALE(tier) max(0, 1.1 - tier * 0.1)

//* Opacity

/// threshold for block
#define MATERIAL_OPACITY_THRESHOLD 0.6
/// opacity to alpha; uses quadratic falloff and a constant because we don't want stuff to just be invisible
#define MATERIAL_OPACITY_TO_ALPHA(opacity) max((255 * (1 - (1 - opacity)**2)), 25)

//* Radioactivity

#define MATERIAL_RADIOACTIVITY_MULTIPLIER_WALL 1.5
#define MATERIAL_RADIOACTIVITY_MULTIPLIER_GIRDER 1
#define MATERIAL_RADIOACTIVITY_MULTIPLIER_NORMAL 1
#define MATERIAL_RADIOACTIVITY_MULTIPLIER_GRILLE 0.33
#define MATERIAL_RADIOACTIVITY_MULTIPLIER_ITEM 0.25
#define MATERIAL_RADIOACTIVITY_MULTIPLIER_SHARD 0.25
