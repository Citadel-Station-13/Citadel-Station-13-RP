//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* coloration_mode

/// no recoloring
#define COLORATION_MODE_NONE (1<<0)
/// free normal multiply color
#define COLORATION_MODE_MULTIPLY (1<<1)
/// free matrix or normal multiply color
#define COLORATION_MODE_MATRIX (1<<2)
/// red-green matrix for parts 1, 2.
//  todo: implement
#define COLORATION_MODE_RG_MATRIX (1<<3)
/// red-blue matrix for parts 1, 2
//  todo: implement
#define COLORATION_MODE_RB_MATRIX (1<<4)
/// green-blue matrix for parts 1, 2
//  todo: implement
#define COLORATION_MODE_GB_MATRIX (1<<5)
/// red-green-blue matrix for parts 1, 2, 3
//  todo: implement
#define COLORATION_MODE_RGB_MATRIX (1<<6)
/// overlays - dynamic amount
//  todo: implement
#define COLORATION_MODE_OVERLAYS (1<<7)

#define COLORATION_MODES_COMPLEX \
	(COLORATION_MODE_RG_MATRIX | COLORATION_MODE_RB_MATRIX | COLORATION_MODE_GB_MATRIX \
	 COLORATION_MODE_RGB_MATRIX | COLORATION_MODE_OVERLAYS )
