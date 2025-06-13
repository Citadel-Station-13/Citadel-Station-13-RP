//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/// called normally
#define SS_TRANSFER_INITIATE_SUCCESSFUL (1<<0)
/// called, overriding another finale
#define SS_TRANSFER_INITIATE_OVERRIDE (1<<1)
/// rejected, due to another finale
#define SS_TRANSFER_INITIATE_COLLIDED (1<<2)
/// rejected, unknown error
#define SS_TRANSFER_INITIATE_FATAL (1<<3)
