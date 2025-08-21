//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Significance; This is how much material is in something

/// used for shards
#define MATERIAL_SIGNIFICANCE_SHARD 3.5
/// baseline significance of material calculations done on material-side / default computations
#define MATERIAL_SIGNIFICANCE_BASELINE 10

#define MATERIAL_SIGNIFICANCE_WEAPON_ULTRALIGHT 6
#define MATERIAL_SIGNIFICANCE_WEAPON_LIGHT 8.5
#define MATERIAL_SIGNIFICANCE_WEAPON_MEDIUM 10
#define MATERIAL_SIGNIFICANCE_WEAPON_HEAVY 15
#define MATERIAL_SIGNIFICANCE_WEAPON_SUPERHEAVY 20

#define MATERIAL_SIGNIFICANCE_ARMOR_LIGHT 7.5
#define MATERIAL_SIGNIFICANCE_ARMOR_MEDIUM 10
#define MATERIAL_SIGNIFICANCE_ARMOR_HEAVY 15

/// used for most doors
#define MATERIAL_SIGNIFICANCE_DOOR 20
/// significance used for normal wall layer
#define MATERIAL_SIGNIFICANCE_WALL 20
//? we are using a higher value because we max(), so reinf lets you basically combine another mat's armor.
//? this should be dropped to 10 later when we get a new algorithm.
/// significance used for reinforcing wall layer
#define MATERIAL_SIGNIFICANCE_WALL_REINF 17.5
/// significance used for girder wall layer
#define MATERIAL_SIGNIFICANCE_WALL_GIRDER 5

#define MATERIAL_SIGNIFICANCE_TABLE_STRUCTURE 10
#define MATERIAL_SIGNIFICANCE_TABLE_REINFORCEMENT 7.5

//*                                             Uh Oh.                                             *//
//! WARNING: HERE BE DRAGONS                                                                       !//
//! Here's the core values for the current material dynamics system                                !//
//! Material dynamics is in charge of assigning damage and armor values to things using materials. !//
//! This will be documented as well as possible but understand that it's all a bit arbitrary.      !//

//* desmos graphs:
//* v1 material damage https://www.desmos.com/calculator/dzyyj0vpem
//* v2 material damage https://www.desmos.com/calculator/awyudtcm6e <-- CURRENT

/// upper curve
#define MATERIAL_DYNAMICS_DAMAGE_CEILING 30
/// logistic constant
#define MATERIAL_DYNAMICS_DAMAGE_LOGISTIC 0.04
/// divisor
#define MATERIAL_DYNAMICS_DAMAGE_DIVISOR 7
/// multiplier to x
#define MATERIAL_DYNAMICS_DAMAGE_INTENSIFIER 1
/// shift to x after multiply
#define MATERIAL_DYNAMICS_DAMAGE_SHIFT 185


#define MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(DENS) max(0, log(10, DENS/2 + 1))
#define MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(SIG) max(0, (SIG > MATERIAL_SIGNIFICANCE_BASELINE)? ((SIG - MATERIAL_SIGNIFICANCE_BASELINE) / MATERIAL_SIGNIFICANCE_BASELINE + 1) : (SIG / MATERIAL_SIGNIFICANCE_BASELINE))

/// upper curve
#define MATERIAL_DYNAMICS_DAMTIER_CEILING 45.5
/// logistic constant
#define MATERIAL_DYNAMICS_DAMTIER_LOGISTIC 0.005
/// divisor
#define MATERIAL_DYNAMICS_DAMTIER_DIVISOR 1
/// multiplier to x
#define MATERIAL_DYNAMICS_DAMTIER_INTENSIFIER 1
/// shift to x after multiply
#define MATERIAL_DYNAMICS_DAMTIER_SHIFT 50
/// +- shift
#define MATERIAL_DYNAMICS_DAMTIER_ADJUST 0
/// overall result gets multiplied by this
#define MATERIAL_DYNAMICS_DAMTIER_SCALER 0.1

#define MATERIAL_DENSITY_TO_DAMTIER_INTENSIFIER(DENS) max(0, log(10, DENS/2 + 1))
#define MATERIAL_SIGNIFICANCE_TO_DAMTIER_INTENSIFIER(SIG) max(0, (SIG > MATERIAL_SIGNIFICANCE_BASELINE? ((SIG - MATERIAL_SIGNIFICANCE_BASELINE) / 10) : ((MATERIAL_SIGNIFICANCE_BASELINE - ((MATERIAL_SIGNIFICANCE_BASELINE - SIG) / 2)) / 10)))


//ROUNDING VALUE
#define MATERIAL_DYNAMICS_TOOLSPEED_PRECISION 0.01


// note: https://www.desmos.com/calculator/pokzwymxnu
///curve bound.
#define MATERIAL_DYNAMICS_TOOLSPEED_BOUND 1 //'b' on calculator

//x-intercept shift
#define MATERIAL_DYNAMICS_TOOLSPEED_X_INTERCEPT 15 //'x_intercept' on calculator

//gradient
#define MATERIAL_DYNAMICS_TOOLSPEED_GRADIENT 0.02 //'g' on calculator
